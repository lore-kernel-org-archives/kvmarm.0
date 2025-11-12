Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6093E283FEE
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939262; cv=none; b=sixOneVs24VpkI/f1VPcejOTtpDZgKUYwHByjemYHW+gn3M4TBSud6sqNCMLMcyxypJq8N+WpYkBXVNwqNxgVQg9nW5KhADzJVOFEP6up8KrCFf0alhUep4pSwxQ7kCxdaHqVMcckAZZiId0TqPyKTIYtRNjBpVomv67HKH38kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939262; c=relaxed/simple;
	bh=OI2i9W7HfmEUh1YzgyOqRxjA2l0Cfp2xADDP867ZM+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RMJZtXicRCPTpKwLwRhWcSjj5lD6k+WKhO+JAmsPmIdQdl10n2RasoTTYFCRGEiS+/XZCsEiw3EoZ4pYOrGnEvSviAXC4oOZHd9BG+px6FcbdQqRWUi//zLYX8iNauHhv2iNJiGmFanPslDXC8IOkaAWId64KySmvUkgGmivp3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D30xyOBb; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D30xyOBb"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4777b03b90fso2965665e9.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939259; x=1763544059; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kjn3ziG+riq1CP7p6ieagwSWj8kSfInnE/GY9lPyPvY=;
        b=D30xyOBbW/PSNAJfkxdzCwyFFW/B8Y/Bte0NtQdpBywIj7BRwaCq8P6nvayGLlj8eu
         6H04gYRJmsHxIgplcEOcFQLRPJcyPKOBrLWCgThVUCBKM26PXZfvYBfWFM2XLEeSlj41
         Exdi1zyN2nP6Tc0V7CeZ2Wz4aeH8GxBmEZG9mgZlp2DqsezDkxfbK6JPRnXaqbfRccuJ
         5Olf5ozJy67v6Sq9KPEYhQZjzIf4Fuc+y2fkI8KK8banrd5INBUasA+l4J1TDmJYDXeu
         wLWXw7+81v0L4vjUiFrZECGkvLIU5hc3wmEPmmMB0UyouQZp6xJwLWeo6KTJJ7igiCS2
         JySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939259; x=1763544059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kjn3ziG+riq1CP7p6ieagwSWj8kSfInnE/GY9lPyPvY=;
        b=YGTjNUdjyKS6fKT0ck5TEfYSRWyFv7foy10d/l1eNwoq/OGUb9PwHwnR2oa2sqjjgu
         IZoCeXWbbb4bx55r8u3mCE9RRaC16QOe21LfAhjR0dANgn9Md6KuTCfYM/3BTUeg++y7
         XNcFEgOb0YHdALkNWGFC+2ZkrXvgxu5sNCt4oQ8SnEuAKEwmE0WB5wIWW9xNaLumsJNg
         gaKZirbssO2PhO9GTPZ6z1dZdDmAG9m/siL17DqUMqh54lA0pU0KM25FoUS6ZgP25LQH
         HmPlEHH2NjaaJc9dRrhFH1g3GHYOUXiSrZG85M+xnJvRNK22SVYtfV3AmIRZP1bZLsmu
         wIew==
X-Gm-Message-State: AOJu0YxjyL1N5L9t11J7CvtL4ApuTVjtYlZQhXETFzYb6oFXnbiM1JDC
	XMQXvikdyCfhEk/4z/EH6FmdpZkQSqcoNYhcToJbg7fdX3t+GvUMquNWtuXbLeKeFVO6n+jR5xE
	7MzQAdIH2OpJnkRtAmDwUatEzg5Y1MP9z2ACcu71+9vWAFKwnX0/EU4APWbEhKvwcBollfMHw1h
	A8t06aYJeVgj/wItTnxeBy4JBd5cpfGS8=
X-Google-Smtp-Source: AGHT+IFlnpNWQQd8XzhD9WlKKZvHlxlXUiwVjk/aG1tNnEUZSrorzKTWftWmWdZMx5mRwqTHrZhOi18TUw==
X-Received: from wmbjn5.prod.google.com ([2002:a05:600c:6b05:b0:46f:aa50:d716])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f8f:b0:477:1709:1f32
 with SMTP id 5b1f17b1804b1-477870b9830mr16518165e9.26.1762939258700; Wed, 12
 Nov 2025 01:20:58 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:50 +0000
In-Reply-To: <20251112092051.1376245-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-8-tabba@google.com>
Subject: [PATCH v4 7/8] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
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
 arch/arm64/include/asm/kvm_pkvm.h | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c              |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 5b564576160d..7a418ea276d1 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -51,6 +51,35 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
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
+	switch (ioctl) {
+	case KVM_CREATE_IRQCHIP:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_IRQCHIP);
+	case KVM_ARM_SET_DEVICE_ADDR:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SET_DEVICE_ADDR);
+	case KVM_ARM_MTE_COPY_TAGS:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE);
+	case KVM_ARM_SET_COUNTER_OFFSET:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_COUNTER_OFFSET);
+	case KVM_HAS_DEVICE_ATTR:
+	case KVM_SET_DEVICE_ATTR:
+	case KVM_GET_DEVICE_ATTR:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_DEVICE_CTRL) ||
+		       kvm_pkvm_ext_allowed(kvm, KVM_CAP_VM_ATTRIBUTES);
+	case KVM_ARM_GET_REG_WRITABLE_MASKS:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
+	default:
+		return true;
+	}
+}
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 10d853f2722e..020cadd811a3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1879,6 +1879,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	struct kvm_device_attr attr;
 
+	if (is_protected_kvm_enabled() && !kvm_pkvm_ioctl_allowed(kvm, ioctl))
+		return -EINVAL;
+
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
 		int ret;
-- 
2.51.2.1041.gc1ab5b90ca-goog

