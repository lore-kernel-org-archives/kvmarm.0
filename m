Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D2A211466
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742315137; cv=none; b=KnWy7gddqm3Et5ncFSyXw8BBFzWEFll30HQwUfxhlsrHAKMVlvBnZ1tNrdqf1gMagOkwz/+lJ2JX85Y1RPwGvOQDl2fk1EMINoKB2UgBZJOwJmE9ExmGCaUY/zIRaJPGrmMZ2reSbg/YJ738lwXR4lgGng51BfywiEFfc0gCGBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742315137; c=relaxed/simple;
	bh=+cUzHTM1msMshEPjgxhwtRV3Pje5egr7gsw54xqxOyE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uuLOlmkcXSxwpuGnU8SpSffLooY3Fa4GG4g53mpa++U0AVAdD055C1PiXupXLIm/KW6LJxWWkXWFapS7QkgdsYMIVjl7X4P9FCb0Filv6QQwLS9Gw7Ybb7Xqv52jN2t37I/+kR8htCaL8KrW84H2iilDCdRkxKwWCQhHRBWW5qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EMPNFuCu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EMPNFuCu"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d08915f61so19466705e9.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 09:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742315134; x=1742919934; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDMdEEdy1VVckNvVv+9Uw4kcuPuHKQ0YP6w02i+CGWM=;
        b=EMPNFuCuf57tZ63XI6aNDr//Cs9J3sOzsSDAVofyqseWXfnJq+MZqSbJLSVZyaS4lI
         Q1P/hWxKuRy/Yy95kp/BTodW2Tm+hH5TSySzAXOtELuOdTV3K2ArdYWX9cjsqLoMVU88
         5Xtgvugjw4CsJ4DUuI2DVvHeJq+awgeZhyQWGTGbMw+UGNpuiDmQOCWUxXn9V0NBUCyG
         JxvXgE058faZ5lyhsQg4QPMHCu1w07k/A1ZC2P1DuPPPtc6SViOJqj7qoZ8Ap9IyJlEx
         4sjwZ8P9kj9Lobb4EBQR05wz3pNQZ4Ti+Pa4tO1RYmpplpFVz59eoqyoH24ieydmbGTY
         RLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742315134; x=1742919934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDMdEEdy1VVckNvVv+9Uw4kcuPuHKQ0YP6w02i+CGWM=;
        b=YFrBhRC77BwFa/EVrS9CQuVEhub3YPHUrjeNih1dt3tbsycWdSwgyi/3pbeVZC4Pjz
         maSOkAUmCQpZJ2mG1jJLMb4LcP0dZn9nb4zBf+dX7ERZItwYZRGe3ePCESZLOy5Wjef7
         A0cRuY8WWtJCS/r2pRidZ3hAJoKKZKusv+E0cQ18Rh0drbSE2JZtwl/e/Q8kJFl3LUQ9
         etb6UhvQb6euFLMpYT4hTHvY95RO61Xku9Ilr09txMLXFSuEuvDUZM0zTPKj4j9E48Lk
         DO9ENZgh3tHIjJYeNnnBCmj1hCOjY9ahJPhMUrdP9ZgumMI9vjITEYDjgEap82cox7Q0
         jJ8w==
X-Gm-Message-State: AOJu0Yw/p+DoUY0YQWLkjrRwRM2/gC79gTBCojZu7Wd6bXX9pwJLktRx
	KRK8cwtPPQaH/K/gVABpulCnV4l4QbNCXIAqEnKNwymVaUAMxutaog8vrmtm4sO2kAQionOiE6c
	7t3lC8w4INaO9CcjXQc26WLehiw==
X-Google-Smtp-Source: AGHT+IGrqCyZAj3WhiZpuq4EomsTyl0s1Z4lp12t9lZvwltIa9qDp+9pdQe/IpL9JiYdK9qni53p5x/BRGVpG+ks5V4=
X-Received: from wmcn5.prod.google.com ([2002:a05:600c:c0c5:b0:43d:1db0:6628])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3584:b0:43c:fd72:f028 with SMTP id 5b1f17b1804b1-43d3ba27a69mr28607885e9.29.1742315134353;
 Tue, 18 Mar 2025 09:25:34 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:25:09 +0000
In-Reply-To: <20250318162510.3280359-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250318162510.3280359-1-sebastianene@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162510.3280359-3-sebastianene@google.com>
Subject: [PATCH v3 2/3] firmware: arm_ffa: Move the ffa_to_linux definition to
 the ffa header
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Keep the ffa_to_linux error map in the header and move it away
from the arm ffa driver to make it accessible for other components.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/firmware/arm_ffa/driver.c | 24 ------------------------
 include/linux/arm_ffa.h           | 24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 2c2ec3c35f15..b02b80f3dfe8 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -61,30 +61,6 @@
 
 static ffa_fn *invoke_ffa_fn;
 
-static const int ffa_linux_errmap[] = {
-	/* better than switch case as long as return value is continuous */
-	0,		/* FFA_RET_SUCCESS */
-	-EOPNOTSUPP,	/* FFA_RET_NOT_SUPPORTED */
-	-EINVAL,	/* FFA_RET_INVALID_PARAMETERS */
-	-ENOMEM,	/* FFA_RET_NO_MEMORY */
-	-EBUSY,		/* FFA_RET_BUSY */
-	-EINTR,		/* FFA_RET_INTERRUPTED */
-	-EACCES,	/* FFA_RET_DENIED */
-	-EAGAIN,	/* FFA_RET_RETRY */
-	-ECANCELED,	/* FFA_RET_ABORTED */
-	-ENODATA,	/* FFA_RET_NO_DATA */
-	-EAGAIN,	/* FFA_RET_NOT_READY */
-};
-
-static inline int ffa_to_linux_errno(int errno)
-{
-	int err_idx = -errno;
-
-	if (err_idx >= 0 && err_idx < ARRAY_SIZE(ffa_linux_errmap))
-		return ffa_linux_errmap[err_idx];
-	return -EINVAL;
-}
-
 struct ffa_pcpu_irq {
 	struct ffa_drv_info *info;
 };
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 74169dd0f659..850577edadbc 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -475,4 +475,28 @@ struct ffa_ops {
 	const struct ffa_notifier_ops *notifier_ops;
 };
 
+static const int ffa_linux_errmap[] = {
+	/* better than switch case as long as return value is continuous */
+	0,		/* FFA_RET_SUCCESS */
+	-EOPNOTSUPP,	/* FFA_RET_NOT_SUPPORTED */
+	-EINVAL,	/* FFA_RET_INVALID_PARAMETERS */
+	-ENOMEM,	/* FFA_RET_NO_MEMORY */
+	-EBUSY,		/* FFA_RET_BUSY */
+	-EINTR,		/* FFA_RET_INTERRUPTED */
+	-EACCES,	/* FFA_RET_DENIED */
+	-EAGAIN,	/* FFA_RET_RETRY */
+	-ECANCELED,	/* FFA_RET_ABORTED */
+	-ENODATA,	/* FFA_RET_NO_DATA */
+	-EAGAIN,	/* FFA_RET_NOT_READY */
+};
+
+static inline int ffa_to_linux_errno(int errno)
+{
+	int err_idx = -errno;
+
+	if (err_idx >= 0 && err_idx < ARRAY_SIZE(ffa_linux_errmap))
+		return ffa_linux_errmap[err_idx];
+	return -EINVAL;
+}
+
 #endif /* _LINUX_ARM_FFA_H */
-- 
2.49.0.rc1.451.g8f38331e32-goog

