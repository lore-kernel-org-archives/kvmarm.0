Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BFF1AD3F6
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728925105; cv=none; b=jcxSwLx/gpC9Uhz97rTG+r21Q4gNDF0kO1e1NMt1sz88ZGSvBgaYP0IOXSh+yRp1mgo3otD7DjGq1gdiVSVC+S6Ey7xL+wJVrHvgp0ppX2m0AyqJjJwIerAE+zznEi5XddkM6B6KiZxq/5nsVLvd18rocDW6T7/DW5Sn0Tnxi1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728925105; c=relaxed/simple;
	bh=W1IVu9+b5gSF3B2PI+4Tr4dDVoipz7943U1Otau3XAo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FtTrOfwk18sG5bHA65JAXMy1JODrbCWijbBoYi6TRiUGhGdlHjD24/aIm3rA+ypq2SjwEoZ1cDEu5efDoCWdj4calLWCPY5Zmitm87RzQhU5tQ9rdGGlyaL7S/vc23SG9b//XkOwxEha/ujV4zQB/9AqCU5yEu77JrGMbed9ftc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rhbPI6vr; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rhbPI6vr"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4311db0f3f1so22176035e9.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 09:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728925102; x=1729529902; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sRB8E8xtPpTSDCr1Bv1nKgP4EzWKYFobhvQEiuVshG0=;
        b=rhbPI6vrWvNjBJo9fg1i80LxgowxnAunTkFUCx7ZjDA1btZsij3hIaswV4xeU5M0O1
         XcJVDAoHguzbJzL7idN7SK4778aeaMgc0EhBmWiuUGGdoSCOc0LMYggvsLWsUfYS3fdy
         Wq+D/vJ9BN23LhefOLL+2o4u+602oK8WaxCwx5Rqg2JR6sNn5gCC9YOVUcY8ALY2MLpi
         GISussoHJJSyygwVvLqL+bCEePCLIOqqIOdx4ZxjgtTJFCjTNHMSuzE7nUqg6qxdz/3i
         3pAqxBZjYVp6a47UEOnEb9ZKNro763B0NKDtYyro+hyyvCcWPnRXv4Iu8BaeCZB9K3eH
         2Pqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728925102; x=1729529902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sRB8E8xtPpTSDCr1Bv1nKgP4EzWKYFobhvQEiuVshG0=;
        b=pJEHc2Mh27tIiVVZ611/sKHBg7VP7MkchtBzdfjJCJWUMJIomoi9g9Dj6I/GHosV5j
         4YcENz0zclTtN/GnLEHXhwU/MZcD2SoPz6pIMoVvu5O/Hn1kOWrhlV0SRXo0rN18bvX8
         RsmSRH35Rrf4uYHD3pRBogiWlKbgPA+H4oV30D4OjxIXf04YGtHSCkcVHZ1tcZT6Wgw1
         LHfUv4tSYBlU6spXCgCxrGMZnTxV8fBWAwZSwajkWbgg0kRRMdBEj4De5BLErzT6ItcJ
         QZzDYy+p1o4/DfIZd7+Txkkp3wIC7MQbXpdjSvJG76xtE+F4/NGXXK619Pne3m/2swak
         eHCA==
X-Gm-Message-State: AOJu0Yyx9za4+S1gfesg6zadfALbUXZ4JOgTzkEPASIXEnyLryE+EgFd
	WveXUxoRjelz5v2cHQBiU8YBpaaGbz7og3kaE27JKxZ8X3/Tz3TfDl64zhqVL57UF0LbcO418Z8
	psp3bdCKCyizgm8aD15jZI+lCgAwKX2+0YcHQDG3iMLiyOE+8sucH0rNVHDk7TN1Z7Co/n7fCRc
	WUnnt1xu/DKdc8cHPMi8TmDt+hOZE=
X-Google-Smtp-Source: AGHT+IEuIl3C215xa62X7B0GD/suNIytgCDcR92Wy4iDaA+Hg1vQY+ZpeN79kDVcfpSPXZTclNgl5rklvw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4213:b0:42e:8ffd:4276 with SMTP id
 5b1f17b1804b1-4311ddfc7a7mr235805e9.0.1728925101140; Mon, 14 Oct 2024
 09:58:21 -0700 (PDT)
Date: Mon, 14 Oct 2024 17:58:09 +0100
In-Reply-To: <20241014165809.984883-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241014165809.984883-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014165809.984883-5-tabba@google.com>
Subject: [PATCH v1 4/4] KVM: arm64: Convert KVM_ARCH_FLAG_* into an enum
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, christoffer.dall@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Instead of using compile time defines, convert the
KVM_ARCH_FLAG_* vm flags into an enum. Add a compile-time check
to ensure it fits in flag.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 53 +++++++++++++++++--------------
 arch/arm64/kvm/arm.c              |  2 ++
 2 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9b7bf4ba07a3..b55057c3fb2c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -268,6 +268,35 @@ enum fgt_group_id {
 	__NR_FGT_GROUP_IDS__
 };
 
+enum kvm_arch_flags {
+	/*
+	 * If we encounter a data abort without valid instruction syndrome
+	 * information, report this to user space.  User space can (and
+	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
+	 * supported.
+	 */
+	KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER = 0,
+	/* Memory Tagging Extension enabled for the guest */
+	KVM_ARCH_FLAG_MTE_ENABLED,
+	/* At least one vCPU has ran in the VM */
+	KVM_ARCH_FLAG_HAS_RAN_ONCE,
+	/* The vCPU feature set for the VM is configured */
+	KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED,
+	/* PSCI SYSTEM_SUSPEND enabled for the guest */
+	KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED,
+	/* VM counter offset */
+	KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
+	/* Timer PPIs made immutable */
+	KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE,
+	/* Initial ID reg values loaded */
+	KVM_ARCH_FLAG_ID_REGS_INITIALIZED,
+	/* Fine-Grained UNDEF initialised */
+	KVM_ARCH_FLAG_FGU_INITIALIZED,
+
+	/* Must be last */
+	KVM_ARCH_FLAG_MAX
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -300,29 +329,7 @@ struct kvm_arch {
 	/* Protects VM-scoped configuration data */
 	struct mutex config_lock;
 
-	/*
-	 * If we encounter a data abort without valid instruction syndrome
-	 * information, report this to user space.  User space can (and
-	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
-	 * supported.
-	 */
-#define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
-	/* Memory Tagging Extension enabled for the guest */
-#define KVM_ARCH_FLAG_MTE_ENABLED			1
-	/* At least one vCPU has ran in the VM */
-#define KVM_ARCH_FLAG_HAS_RAN_ONCE			2
-	/* The vCPU feature set for the VM is configured */
-#define KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED		3
-	/* PSCI SYSTEM_SUSPEND enabled for the guest */
-#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		4
-	/* VM counter offset */
-#define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			5
-	/* Timer PPIs made immutable */
-#define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		6
-	/* Initial ID reg values loaded */
-#define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
-	/* Fine-Grained UNDEF initialised */
-#define KVM_ARCH_FLAG_FGU_INITIALIZED			8
+	/* Bitmap of the set kvm_arch_flags */
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index df17d50887d6..0d2bcc65cf85 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -117,6 +117,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	if (kvm_vm_is_protected(kvm) && !pkvm_ext_allowed(kvm, cap->cap))
 		return -EINVAL;
 
+	BUILD_BUG_ON(sizeof(kvm->arch.flags) * __CHAR_BIT__ <= KVM_ARCH_FLAG_MAX);
+
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
 		r = 0;
-- 
2.47.0.rc1.288.g06298d1525-goog

