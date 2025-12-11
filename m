Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F822303C8A
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450040; cv=none; b=E6GS71IGSZB/Kij9Bi01Es8soO8uwVllySKbQa8lKlSejLmuBOEQEDIcgkkhURSOubDab2CJ0/G2UHbwYnUqEIjb39pwsnvRIT6Fl1vDHUzFe33EMI41Dfrq+vYpLikz2/2N6MvUT9D5SGVOzwl8MfthZFWHBChaKHt+A5CYYzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450040; c=relaxed/simple;
	bh=rsY7dRiLvrQvjx54azFGS3AA+npW59N5BiCWzuwkS6U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m3Jovdq1JAfPThtQuW6X6am+DdEq5Q2ZWYT1NyNPrZbJRcDBTnYeOikEHzuhXOwsv4R8Mz9ELFLfGbKp5eBfrZoVOBLRvmk46rBS2QNIRM3YTUsYPw7ArMTbODGQFwgh4i2iVszl6xWP4bnXbjd0x4GYlUiPKOiCStuivhOY9p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EPLUWcY8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EPLUWcY8"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779981523fso5944125e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450037; x=1766054837; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a+mal7HTHfWe8plwjg0zx4lZB8mal6cIfV5WaXbVuko=;
        b=EPLUWcY8F18hOXMSkA1pw2AFCFlwpy0Xr8DpOcdwbI1hZO4V4QgjfdAuwKzsmhW+0U
         eX4EShe0b7GPumRInF9+6DvWuRro8YMdOmMRHU76tlUMrTs2Jmy6bDW5ESfeqJkiHL3t
         DNLv8sYPCQRSW6P5CRi2y1hh7Zbh/W6xgsW/kBtNDNanPpUJ+rCxihzOguWoMjBMBDjc
         aFX17mbLOpuhTTOFV7hTcLAyjD+HDB4CxV1sBjoR2DVcCYDxIb9JUiMXENUeIPYrfpOU
         OtkDEB1cVsd6gXjdTKS5DUmL6vgojcsT4Ie2M78lHjgye5D8NzEFJjWf5ThiqOdoqqqY
         OaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450037; x=1766054837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+mal7HTHfWe8plwjg0zx4lZB8mal6cIfV5WaXbVuko=;
        b=osMFGHCGdzLPGsC4PcySWVbw3ZPzhHK6IJAAwTL1H6Jd/FNWaU1MW1r3HItoQXFWzc
         OXNWNC5nX88AyIdOzCWqjI8+UZUAVVHVTnKn5Ls7uQ4zRbReAQKfFZZJkYDN/qXQZ7Xw
         Hczk+E1gFOLFRveO47NvwwrAuQ297FK2x17aJUaUHQVub/4n7GnxN8hA169vyHu2gNMH
         XMTDXdUzQ7DjDFL9xh/zI/MiDO5reOSGAfuuJ/lRdS02Dqct+/KwM/4K8O6RxNMqyfFS
         uIn/gQageOkAamG0GlkykjGVVSREWl94VAP7rfyo81r0n/iDZdVPsPfJJck2xlgyZViN
         7Gaw==
X-Gm-Message-State: AOJu0Yx3Mw9KlRjD+HyE076WZ5HoaCJNKR0jig6TawF/Vn6qwE5D0n31
	JCeQ4KrVpkxXccIF+/GKEr8KHoQD6UG66BpK6P77O9ICu99vX0motkHclqH1Hc4hbtSXXXCV6c7
	7hqJ40/hWb9AQThDOZI43ObzfpustpsVWClLHIXF5QdKAY3ar/7MjKls49bj7DuORSH6vsWuwHg
	fI9Ne7dzkZagXssCEqeCe5tjPT2tCSx1c=
X-Google-Smtp-Source: AGHT+IFxAJYh0RoX2PIWUW9yyln89JmGUy0/gLNAYgixKLIv4qxLnqP1L3/Y/kl9MfOpk7khjJD8Njv25w==
X-Received: from wmbb8.prod.google.com ([2002:a05:600c:5888:b0:477:5a0f:1860])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b37:b0:477:b734:8c53
 with SMTP id 5b1f17b1804b1-47a8375a595mr56402235e9.12.1765450036730; Thu, 11
 Dec 2025 02:47:16 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:07 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-8-tabba@google.com>
Subject: [PATCH v6 7/9] KVM: arm64: Track KVM IOCTLs and their associated KVM caps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Track KVM IOCTLs (VM IOCTLs for now), and the associated KVM capability
that enables that IOCTL. Add a function that performs the lookup.

This will be used by CoCo VM Hypervisors (e.g., pKVM) to determine
whether a particular KVM IOCTL is allowed for its VMs.

Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 42 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 3 files changed, 45 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 64302c438355..9def5e1f536c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1652,4 +1652,6 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
 		p;							\
 	})
 
+long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e4936cb9c8c3..1bbba79e2686 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -58,6 +58,48 @@ enum kvm_wfx_trap_policy {
 static enum kvm_wfx_trap_policy kvm_wfi_trap_policy __read_mostly = KVM_WFX_NOTRAP_SINGLE_TASK;
 static enum kvm_wfx_trap_policy kvm_wfe_trap_policy __read_mostly = KVM_WFX_NOTRAP_SINGLE_TASK;
 
+/*
+ * Tracks KVM IOCTLs and their associated KVM capabilities.
+ */
+struct kvm_ioctl_cap_map {
+	unsigned int ioctl;
+	long ext;
+};
+
+/*
+ * Sorted by ioctl to allow for potential binary search,
+ * though linear scan is sufficient for this size.
+ */
+static const struct kvm_ioctl_cap_map vm_ioctl_caps[] = {
+	{ KVM_CREATE_IRQCHIP, KVM_CAP_IRQCHIP },
+	{ KVM_ARM_SET_DEVICE_ADDR, KVM_CAP_ARM_SET_DEVICE_ADDR },
+	{ KVM_ARM_MTE_COPY_TAGS, KVM_CAP_ARM_MTE },
+	{ KVM_SET_DEVICE_ATTR, KVM_CAP_DEVICE_CTRL },
+	{ KVM_GET_DEVICE_ATTR, KVM_CAP_DEVICE_CTRL },
+	{ KVM_HAS_DEVICE_ATTR, KVM_CAP_DEVICE_CTRL },
+	{ KVM_ARM_SET_COUNTER_OFFSET, KVM_CAP_COUNTER_OFFSET },
+	{ KVM_ARM_GET_REG_WRITABLE_MASKS, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES },
+	{ KVM_ARM_PREFERRED_TARGET, KVM_CAP_ARM_BASIC },
+};
+
+/*
+ * Set *ext to the capability.
+ * Return 0 if found, or -EINVAL if no IOCTL matches.
+ */
+long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vm_ioctl_caps); i++) {
+		if (vm_ioctl_caps[i].ioctl == ioctl) {
+			*ext = vm_ioctl_caps[i].ext;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..861733b8f159 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -963,6 +963,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_ARM_BASIC 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.52.0.223.gf5cc29aaa4-goog

