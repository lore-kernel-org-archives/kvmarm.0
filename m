Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342D3207644
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740680281; cv=none; b=rJS1DO0MWdcWaXe9tRg/MmGAjROB5SyT9uW70Z3xJFierHQh0CxXKoNj5lQFp/O0iGEKpTkh9kRScU2WQYl7S+EXxs23/HxlY4n/3MSpwU+Nx7Mqwy42t33/YS6rS04hwPLlKuqd7+UHGKhGD6LIanG012KXrhUz6YuYXMRdOWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740680281; c=relaxed/simple;
	bh=yROXWz5RPIqMRSS9HSXpl1oGHLGodzFWkAFk1uLzGBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oQDWQTI0BwtuLkfhczszgmZyWn6PXqyyhbBO4eghpWkUe//aPchA+dpbg44XMG88UmE4WkN1Ghais+Tng6IxT/HzV7xf3CBOqu81HvHN52OoWCjfNP2Y5+cPXdjXiAmRAq7oVR/0hQMKHMn9NHsKaPhlGRXqmUgIZ9t4etlzMs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uqh4Z3Pf; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uqh4Z3Pf"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ba50406fbso4039935e9.2
        for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 10:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740680278; x=1741285078; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1lj8uuu7iWZsAclpHD2qzdXk8KQojj805ab43KuXmCc=;
        b=Uqh4Z3Pfj2C174IwlG7yMoe+wCkty9uo3Q40iKX1ZWzpBg88G7ork9xMhwu5ChP4GO
         IoL43YVBSzVXnQ/cFE2awQjwdAduANWw8mj+/d0A41Iwa5TGOOXQHUmih6zhcY6TYOVS
         /nWlcTXo4yFql2/vLlWdyjYeyVUDSldpot9TGwNc+auAq1Z44uYF9vaMom0OTrVl7N6T
         L+S0rjz2pZoRFfXvb67d9dGLFgDxIDQCvJcBEDDDs0y/c/jHskaMeWNPss8RIBgrpMKZ
         sJ4CEwNXRPR6gWOnT9z0OQTwzZsO5X95tcOISDblKHu6P3gd5BRVpRXoC29T1PkhQ7ke
         0qGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740680278; x=1741285078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1lj8uuu7iWZsAclpHD2qzdXk8KQojj805ab43KuXmCc=;
        b=HGQVIUpMVHN/s5sDRlOD3696dIYHHTY8fMI2S/Hca3/9oZVDJ+1hbQgvngOiKes5mL
         jQEb2XAwzda69xmiXB9GCQv179Eeb2ekUFyzyK1M6DOZAriHveARCa9jylCjvEFDKMNn
         TL3lzmija0KGm2UUgtO+FXcfPPxLlKueapD/Q3hupGF7nMjBoU/SkbnLsJNdJHCa2wE6
         Z41J3JAe69HA1yP1GkikJtk/WBHrRf3zAc+LywLpVybrfT8QwseU3ZVc4CwD4Ct6xVoD
         AMSSZ+YdeoVAkb7KgG4SVlNXrJMbfzpDlIHVUGnEZp4/u8nP8msDN5+Q4qdg1+IrBZOP
         6TNQ==
X-Gm-Message-State: AOJu0Yzrm5MCuDBVvqzZBxHvDCKaX1nzk00zP9tDPIHz6CjXMpcAgLaG
	Laz88R8eQjxvps8neznDlL8P41z0S5hZCUhvXVxvdOFGJPlOiQ7PxXM2gyqVrjEci0wzvH8Vlfk
	qd2Iaz1UG4IGaHdhXjx+o5x5O4g==
X-Google-Smtp-Source: AGHT+IF2Njxm5dDDIzoh690S6dlDK7FR8OBLvtmE8g2ukm7Bwq0tFN/UVviqT95gpNUzFNzheKYgVxT063PkICiN5Uw=
X-Received: from wmqd1.prod.google.com ([2002:a05:600c:34c1:b0:439:65f0:b039])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fd3:b0:439:a255:b2ed with SMTP id 5b1f17b1804b1-43ba66e5f09mr2558785e9.9.1740680278652;
 Thu, 27 Feb 2025 10:17:58 -0800 (PST)
Date: Thu, 27 Feb 2025 18:17:47 +0000
In-Reply-To: <20250227181750.3606372-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250227181750.3606372-1-sebastianene@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227181750.3606372-3-sebastianene@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Move the ffa_to_linux definition to the
 ffa header
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
2.48.1.711.g2feabab25a-goog

