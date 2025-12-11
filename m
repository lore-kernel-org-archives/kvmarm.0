Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E54B303C96
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450040; cv=none; b=BhxuI9qZNZWyIlxYV0QvE3JjEz4sWL6ZGvnwO/sSjFxtsb4jv/s+Aq4huTPQptwLkZXZUTjbzFZnFZ0sx8VXFlHE+vC6VZhNUzxP6rJ4/bX5n3ILxobI/x8jMoUSgTg0dFCEClvltC6bmLgzZCWXN1tz0CiYPsQGTDQeRlc5eQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450040; c=relaxed/simple;
	bh=uTJ+VWlYKDyI+qntdZsvrZ5BtNF9XLFH4eOjSU8fMIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lP+S0ppcsjkK2QZukcgxF8SVVBF9o3ejFI/uVTqCLCcuIdS9f/0HEHH4teXAWFiABDwb19IfeTHD/QkRg2qsbL4JgwhHUl6giQizb5LBmV1iKkNUvE+4VvOOrM5QW1kow7eQKxKwEYasnRU75uj9WGszR6cSjcik1519r5N2gUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HoiDeFqu; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HoiDeFqu"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6450f3e7e71so762305a12.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450038; x=1766054838; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OUUJO08oM+ZIak4io3fwTWUbAx7PbiFis0a16dmFfjI=;
        b=HoiDeFquWcRq0nD1uZPqaMtvaR8Ns4aztIcNTSc6QMGr2AnFIScWpGAXD0t5nZKEtQ
         YNobWfradrAy1RTI2LvbJ0GJmeEXMGBnZ0xWHpGZnXdx9MIEpabmq8vrHtbMg1bR5/bY
         FYYKR66qNwR+cXkk+Zgwh2xQFWmIAqLFxTZ6Pb7xLPJTMIyTCCLrVQ8tE8x80D/XnX3D
         gwo/luC7XLmWEJN55WqxgWrm8ZrWMBoQBC3YFON3QKID70rA2ba/X/gPFHa08Ya50r+k
         /y87cWhAkEP7vNTVSwAE6PWgc7m0w2sXCLzK9K6aAzeBfCvBpayWY7/VYRagnCMZLqDF
         xp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450038; x=1766054838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OUUJO08oM+ZIak4io3fwTWUbAx7PbiFis0a16dmFfjI=;
        b=ac3awncQ1c7BdxDHClEPKej8dvjUBL0UVqiZepwtfQnu4XqUA/KTw4Cf+qk0beklEG
         QLJNVQ6yHBkMqm4JTCgalNkOPTtwY1fD/DOH8uxyk48Bttr1WRLXswEQOUMyzG3EBpnc
         3/IyvGYjCoTAQB5Od/QVOjLE3KDPvL1AI++40+aWPHKOYFtu+ZgUoN2sMRhzB57WWTxZ
         mqqe4eAHcSXGbM5xNPrRn5IV3IXmb31rPDs2jCBne26ml+yT0NSRHsDivGd43eclR4eV
         QgPovHsdKjYjw0m4g1IbF2w7MpPwPEcLZV7wBC5tRhCZLHZQU0HxyEvDBoxu0zg/Wt6C
         5W9g==
X-Gm-Message-State: AOJu0YzapS96R6sssPLE3kEnhhfxPf5ZC4AKWXhYMVGdELbyG0YlW2KB
	QJ6RdGcelOQmb48tqWzr9y3XjwBLsQ/NsEqPeZu3+clQCHHsaqN5nK0/x8wvXF7cw+7o3cTnDez
	5ibIbZPw2csUeBrwVpHkwXPlm/To/W+6M3DZ+aJ4eTK307GYgwkPQk9lb/9SMBxW9Xg7dcx1caQ
	OvshnqNfvurlNb253MEkho7vrqleTrBtk=
X-Google-Smtp-Source: AGHT+IEarHaHYeX8TaRF54z2z76wqA7owm+qT+LrdA1o1Q5fRCRwCa8o4E9r6jCnF+jUICEAkFE1ff4+iA==
X-Received: from edf1.prod.google.com ([2002:a05:6402:21c1:b0:649:7070:60b0])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:35d2:b0:640:a356:e797
 with SMTP id 4fb4d7f45d1cf-6496cb90e08mr5358305a12.13.1765450037542; Thu, 11
 Dec 2025 02:47:17 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:08 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-9-tabba@google.com>
Subject: [PATCH v6 8/9] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Certain VM IOCTLs are tied to specific VM features. Since pKVM does not
support all features, restrict which IOCTLs are allowed depending on
whether the associated feature is supported.

Use the existing VM capability check as the source of truth to whether
an IOCTL is allowed for a particular VM by mapping the IOCTLs with their
associated capabilities.

Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 21 +++++++++++++++++++++
 arch/arm64/kvm/arm.c              |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 5b564576160d..0fa8c84816fd 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -9,6 +9,7 @@
 #include <linux/arm_ffa.h>
 #include <linux/memblock.h>
 #include <linux/scatterlist.h>
+#include <asm/kvm_host.h>
 #include <asm/kvm_pgtable.h>
 
 /* Maximum number of VMs that can co-exist under pKVM. */
@@ -43,6 +44,7 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SVE:
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+	case KVM_CAP_ARM_BASIC:
 		return true;
 	case KVM_CAP_ARM_MTE:
 		return false;
@@ -51,6 +53,25 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	}
 }
 
+/*
+ * Check whether the KVM VM IOCTL is allowed in pKVM.
+ *
+ * Certain features are allowed only for non-protected VMs in pKVM, which is why
+ * this takes the VM (kvm) as a parameter.
+ */
+static inline bool kvm_pkvm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
+{
+	long ext;
+	int r;
+
+	r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
+
+	if (WARN_ON_ONCE(r < 0))
+		return false;
+
+	return kvm_pkvm_ext_allowed(kvm, ext);
+}
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1bbba79e2686..d9a8745d0bd6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1921,6 +1921,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	struct kvm_device_attr attr;
 
+	if (is_protected_kvm_enabled() && !kvm_pkvm_ioctl_allowed(kvm, ioctl))
+		return -EINVAL;
+
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
 		int ret;
-- 
2.52.0.223.gf5cc29aaa4-goog

