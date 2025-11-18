Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E482D4B66
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462297; cv=none; b=fw/F01QRo9a09W2IQrOm/zy4I1YaN7jdCmW53BEZxlijoUfWt6t4Gk0QOttyFgt9LKaKCZhM/1TaciIoIevJmEWfR4TDpTp0f0+57cnFADOeCki5EDXBxVxoJfkwN7K1obSGX7b52tuULiyIV/aDZrRYdu0OzPxDZ5K0JQUAw8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462297; c=relaxed/simple;
	bh=kgJd1xA0i1mby4L8vq6WdQZ6MiQdSsX0GOy588gokjQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HgnBaOCldIxrabaoknwKJX89aHvvDMkCes1ONHgibICBCLi+N8bE4bQxaNuCcZXQ6kNpxAy6iP/S+3rcrnfAV7/Ev9u3KGkjzlBO+dYTioQY84WEY58SkplPHZIppXcbH1RB1k/agB8KkwrvXpxNckiuITbPPQifo4NsFMEtxQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s6ewk3O7; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s6ewk3O7"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b352355a1so3034845f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462295; x=1764067095; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J1KpAk/X+mJeWWI/FqOB+Io4kN5HIqeKrqVApCd567Q=;
        b=s6ewk3O73hBEn+C4DptfG/VBavc7HSOZjQv8Rr7HK2U8UZFCqjj7x2WUbv4vLD14bm
         mTqwX9Ph9Un0xnp3fJmY6pI5+oMNwpJ4+iYVp+nf+4wGFZXlcfwU9qU+y5swLsLOyj9S
         ZDTf0vqjbaU7e8e4v3O10e9gner0sKKwg5OUBZfdrMpK8kET3YROwqr15bvIGTMkJoTo
         NChiB+0JTJ4/ytb5Hr273VBkMl9ZkCwIHWv5W+ETkmvKXyvHgdp0XGOmJ+x38B4YPkkv
         +rqGsElK47otciNyi12rlnMR/JPZgksUkRuaZwU5RiBup2Obv0IFVufTwokJCK6sOKgb
         I56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462295; x=1764067095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J1KpAk/X+mJeWWI/FqOB+Io4kN5HIqeKrqVApCd567Q=;
        b=EfS08retfj92pxbtMmjp06HjIB9h3z409kPsv0d7R3LuwcUWGsUh9NJRdevTUV7y69
         5hgUvBO/iuVo1pNGHV1jDxXsZNlr/mw9xzNkwdkVYxKPhPWS68G3TLVljMH+fUuXqvlP
         AXOnGwVAOQi3/ZIoxgESjQWAvskfBqkOog/HbhwnwJLaqU4Tl9DdJRnzmtsRX9SSIBGU
         NaGsM4X7qAIlIBFfGhciSEB+wqIJ1DSI3j6pNrbFkcpWb0tGYbNy2ZZX8FkkpmGE7q2i
         gblodgv3nIxATWt7evHyVp6l0Fj9iXXFB9zf6YGRcOky/8zdhssrnllic8I0Ojp+IvHN
         T9Ag==
X-Gm-Message-State: AOJu0YxKwMOQ+kK+MBCp4bWONWirV3sGpx9ssjndxQQxEl+QtJ29IXOr
	bQ0h7AY4aoQcwJsuMCdtch34Q8gn6D9LgRdtE2bLtLbXH4aSkkSPrphpoV8+pWbg8IrF11fbct8
	nfsz4l3+1MugRw40/8MPRvZJd5kWHTc93s2XuqVjxWR2KTdsIJf1KAvwJxat39nkN+KWchMeVGS
	E6V26BevKCkMewbaznK+mTir8akQNz1Lo=
X-Google-Smtp-Source: AGHT+IEAYj+W/utL/Dvs1aiYdmCy2z5+TKwIEDcEUnNtXsvha71Ab0BwsvmfljNEPRzfgpl8tCmySeuxRA==
X-Received: from wrbei2.prod.google.com ([2002:a05:6000:4182:b0:42b:b28a:673a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:615:b0:42b:3dbe:3a37
 with SMTP id ffacd0b85a97d-42ca86971acmr2477705f8f.10.1763462294513; Tue, 18
 Nov 2025 02:38:14 -0800 (PST)
Date: Tue, 18 Nov 2025 10:38:04 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-8-tabba@google.com>
Subject: [PATCH v5 7/9] KVM: arm64: Track KVM IOCTLs and their associated KVM caps
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
 arch/arm64/include/asm/kvm_host.h | 42 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 2 files changed, 43 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 64302c438355..3ec2d4edd3b4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1652,4 +1652,46 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
 		p;							\
 	})
 
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
+	{ KVM_ARM_PREFERRED_TARGET, KVM_CAP_CORE },
+};
+
+/*
+ * Set *ext to the capability.
+ * Return 0 if found, or -EINVAL if no IOCTL matches.
+ */
+static inline long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext)
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
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..1f6e51234157 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -704,6 +704,7 @@ struct kvm_enable_cap {
 /*
  * Extension capability list.
  */
+#define KVM_CAP_CORE -1	/* represents core KVM capabilities */
 #define KVM_CAP_IRQCHIP	  0
 #define KVM_CAP_HLT	  1
 #define KVM_CAP_MMU_SHADOW_CACHE_CONTROL 2
-- 
2.52.0.rc1.455.g30608eb744-goog

