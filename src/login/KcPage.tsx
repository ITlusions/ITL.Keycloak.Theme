import React from "react";
import { KcContext, type PageProps } from "keycloakify/login";
import { useI18n } from "./i18n";
import { ThemeProvider } from "../components/ThemeProvider";
import { getThemeVariant } from "../themes";
import DefaultPage from "keycloakify/login/DefaultPage";
import Login from "./pages/Login";
import Register from "./pages/Register";
import LoginResetPassword from "./pages/LoginResetPassword";
import LoginOtp from "./pages/LoginOtp";

export default function KcPage(props: PageProps<any, typeof i18n>) {
  const { kcContext } = props;
  const { i18n } = useI18n({ kcContext });
  const themeVariant = getThemeVariant();

  return (
    <ThemeProvider variant={themeVariant}>
      <KcPageInner {...props} i18n={i18n} />
    </ThemeProvider>
  );
}

function KcPageInner(props: PageProps<any, typeof i18n> & { i18n: any }) {
  const { kcContext, i18n, ...otherProps } = props;

  const pageNode = (() => {
    switch (kcContext.pageId) {
      case "login.ftl":
        return <Login {...{ kcContext, i18n, ...otherProps }} />;
      case "register.ftl":
        return <Register {...{ kcContext, i18n, ...otherProps }} />;
      case "login-reset-password.ftl":
        return <LoginResetPassword {...{ kcContext, i18n, ...otherProps }} />;
      case "login-otp.ftl":
        return <LoginOtp {...{ kcContext, i18n, ...otherProps }} />;
      default:
        return <DefaultPage {...props} />;
    }
  })();

  return <>{pageNode}</>;
}