Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17091E1DE4
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 11:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742989152; cv=none; b=iZbecyCplnm/b2BEMzm/ginZ6PKXAcobXF0r0wZrEwXFSjbsGNc30Mb0EXParza8/iCVtGRKiVulgGZtnMohvrIEzM/65gpOmsx/Bx8KJJi2PSwAqLiHcxgC4W5n3J0VXbDO5Uq/av5HAk3Kb/2XW1FPzOEPPKkUoQzlZbpf6R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742989152; c=relaxed/simple;
	bh=UgBqeTaDk5nYZ0B//mFPRrazdUKQag+EQMWMdNe4gdk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pgERWUShD23aeAJfPUkJbYbZdAKFyrBt20SgEj/iMtR5k+j88ZiaSjSQj98dHXzMoHoaoVUhz0VfTciKEpuwje9uyVrnpf4L0ICiG0yRUXt+2EoEtKQKbihgHKObQ8E93+QD/4BiUNYdL429FBM9+0KRMuP2FGVln5uH+hXMbZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uoLyNde1; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uoLyNde1"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d4d15058dso48531985e9.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 04:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742989149; x=1743593949; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D8ajkpiQTqtR9VJRMGj5F4HjopRvHwcyjLs80bQ1Ix0=;
        b=uoLyNde1xUQl2wvsrfeBTqFMJ3oYus4TeFmMpCxi8znZMWAkRzjXzduXUZSvD+vtN1
         +VRSz4IcyyxNWBG3KnCIe1w7+P9bS9DuKYpiVgo3pUOnUvq0YDRSETUd9biVIV9D5p8h
         kuJLyds4ceDnBHBsa3aSquzI5cnrcdZE4XdZs57frYoLpJx+WTZ8HsN991VfvqTG9esR
         fv//IL0MNirnpidWVqjaeAl8sO94hEZkNxde5Ce16annlDvnRN4BwrqJSmtzEsy3MW7o
         iYoKCWwNCLdEyI1GeAdMkUELpnMNT4SfFzM0n8WOD77D+gQcvFM+6gT8yU7WSzYLlZrp
         uhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742989149; x=1743593949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D8ajkpiQTqtR9VJRMGj5F4HjopRvHwcyjLs80bQ1Ix0=;
        b=Daz2c7keW26+AsLcTGTnAJZqE7ujCUYEBMxK6nIs595vwUPcVeDoF+zo42Lol3hGUk
         sLyZZkoXyG+kuS2eqNdhW+ruQDm+T5jz9evx8dkujO0xZ73FQMcL7dojMJMju08go+TQ
         AxRyKUF7uaqdIY0h+LwS8VzacUccEejFn0kLLwr908c8Gltk++L5Jb1kQbWcK2snP8A8
         NryRyATZMOyx7z/Cj79yK1iL/LGDwFYxI22K1uNG36OobWFiCTZqSf54DhRPyEuzsCHt
         n5A3k9B90EsUAgMhAuQvHiJJ+uEUe9UKh78DFLH0ydlemlPesU9PbBEanIe49uO2szIb
         Clgw==
X-Gm-Message-State: AOJu0YxyEcNSW9azBm8aAQACMpGjkhvlmYNdt1lCCgJBxvzJQwrK5WCK
	hYjs9m3W7aLMwkTGrOLYQPphGhgh3rgkTwBYwYjh+iKIqIe9c51mLH3VW0J0S0v4dLAOa7SqaO6
	FQ76H9A1ZaQ16rGYy+5Dc08cFCg==
X-Google-Smtp-Source: AGHT+IGt24UV1F1gn3DBiJA89bM8xyxzcFBTUpe7uN0vVj4Q/IEqACUFIlVuS9cdYKWGLRea4OJ8IMRq4qWmWhdzPh4=
X-Received: from wmqe22.prod.google.com ([2002:a05:600c:4e56:b0:43d:8f:dd29])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1882:b0:391:12a5:3c95 with SMTP id ffacd0b85a97d-3997f91202dmr20021811f8f.22.1742989149185;
 Wed, 26 Mar 2025 04:39:09 -0700 (PDT)
Date: Wed, 26 Mar 2025 11:39:00 +0000
In-Reply-To: <20250326113901.3308804-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250326113901.3308804-1-sebastianene@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250326113901.3308804-3-sebastianene@google.com>
Subject: [PATCH v4 2/3] firmware: arm_ffa: Move the ffa_to_linux definition to
 the ffa header
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com, qperret@google.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Keep the ffa_to_linux error map in the header and move it away
from the arm ffa driver to make it accessible for other components.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/firmware/arm_ffa/driver.c | 26 --------------------------
 include/linux/arm_ffa.h           | 27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 2c2ec3c35f15..3f88509a15b7 100644
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
@@ -238,8 +214,6 @@ static int ffa_features(u32 func_feat_id, u32 input_props,
 	return 0;
 }
 
-#define PARTITION_INFO_GET_RETURN_COUNT_ONLY	BIT(0)
-
 /* buffer must be sizeof(struct ffa_partition_info) * num_partitions */
 static int
 __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 74169dd0f659..cdaa162060f4 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -223,6 +223,9 @@ extern const struct bus_type ffa_bus_type;
 /* The FF-A 1.0 partition structure lacks the uuid[4] */
 #define FFA_1_0_PARTITON_INFO_SZ	(8)
 
+/* Return the count of partitions deployed in the system */
+#define PARTITION_INFO_GET_RETURN_COUNT_ONLY	BIT(0)
+
 /* FFA transport related */
 struct ffa_partition_info {
 	u16 id;
@@ -475,4 +478,28 @@ struct ffa_ops {
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
2.49.0.395.g12beb8f557-goog

