Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA72311954
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462298; cv=none; b=fXlKDaT+laXOuDM/ZYm8msnK8k2BtyAV8gFFCErLIjfWxYNVoWzNuC1AJcTgpyyYWrKhJegEnuVm87Jba8AKZAqgYRMAL2e9Y66AzJx1rmqtHaKPcY/g6rcKsNVHrFPFdZNq6RMbXX4pq/0mjYHXY03JFmZxR7utAicOEsHp+4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462298; c=relaxed/simple;
	bh=v6HnMXIRJVHYjHBHmKGwtj+/Dn+/S4HxeSywIevMMH4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hU1c7CsScSQO+VA4wp0yYe3txvRg1roh335MfER52WH85wg7h5N7h49Qfu4HBd9WpSNnsAukpC6d7eh2wZWZbH/un7Hcq+2IzsuQuMLt0BaxqHRWh9P7o5qiEKRj3co38X6xpVgKR+CIJlcYVAyYOtF69kAGd1C9eJcZ5i+vzcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OQysbq8G; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OQysbq8G"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a11d9f89so3878795e9.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462295; x=1764067095; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f7Ix1gvDoedoa2VySziNtSICAiph6cR2zcFJA1VxEgw=;
        b=OQysbq8GEJxUQDrn4jKiKAdRtG3Ld4IXRv+D2c/MT15YBDmwiH0TJdFTlzuWU/xL50
         t54x6C/pzbCtEfewb0hN8khCicIfKHy1pSrwreFvMIEj+uKes0i9J+V07OSX3+ogsYUZ
         3PH0pWMDzsTBp0OXgoqAQQx47UAQJ1TdjI9PI2MEbYkVnDUXPcD7YgLWZx6bCFK8Wkc4
         MfTn+Vq09MARHF0U4RBeOCE8fO1aDCgJTOs3IkwOEFO5RM8uF7+HhSlDNLQ1dCHlnFUn
         W5OQdeb0Cjeai9RWwZq7hss5PGs/xPmxI+vDemUQrn2LKVm6IA7lwPLevvG3VbjJbXu2
         VbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462295; x=1764067095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f7Ix1gvDoedoa2VySziNtSICAiph6cR2zcFJA1VxEgw=;
        b=ofF3+hCGSUOkvXFBPjqYFguD3hqEZ59T+i9x6y3ISDX8OuYiPmhM1Q721ISAdXo2bJ
         uxkmg37lSvAdTsenw/k8WVar7Vdli/fpFfgq9dOv0p1yryPFr88E0suIuKiMB/Ws5UBw
         z5C62OAYaeqKO26qOfrgGv4IIgX58k/Xvu+Sd/urbnnvCv00jWmPuu2J0gkkQZv/ejii
         a4jNYGLrvWscR+6a1G7/JTTIPLustuE/S0mjAvRofvKhIeroYuL0SL4dcGXe3rjYumew
         LzDX60sel8uKa+zCEsASbw1tEAktZyz3u6Jpl8m+jJ6EatIKMSet2ErOW/9h0dn1GcyV
         TQBA==
X-Gm-Message-State: AOJu0YyTiqz19AMH84MdBm6sn/VRLpwzUXHotqmhvk5ErVh2vTcOwgah
	IUeP57qH4/HUlCvS67kB8nndfKVYvrKEGHbK1lLQ6Qbcf6mOwCObZVks7skRC54VihrR1WM4h+r
	RqrmcVZRITo7ZdF442zAfcZEKVLIPpBBmT0glDctr1uZcnowz7sKZ0mf8rN1JEpI7hZAYda12AY
	nxVwavNmnSWUnpOkqrPUHZTGyqAd+Ui5s=
X-Google-Smtp-Source: AGHT+IHHaFRT48dnQv9XnnqkCXxSMygY1YzNHot8cTmVJYtqnUnJm6Bhep5tmphH8wELHWrZN7tKJjb/Cg==
X-Received: from wmla8.prod.google.com ([2002:a05:600d:2388:b0:477:9945:466d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b23:b0:477:7bd2:693f
 with SMTP id 5b1f17b1804b1-4778fe60615mr147591815e9.6.1763462295255; Tue, 18
 Nov 2025 02:38:15 -0800 (PST)
Date: Tue, 18 Nov 2025 10:38:05 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-9-tabba@google.com>
Subject: [PATCH v5 8/9] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
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
index 5b564576160d..dcba7f99b88c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -9,6 +9,7 @@
 #include <linux/arm_ffa.h>
 #include <linux/memblock.h>
 #include <linux/scatterlist.h>
+#include <asm/kvm_host.h>
 #include <asm/kvm_pgtable.h>
 
 /* Maximum number of VMs that can co-exist under pKVM. */
@@ -31,6 +32,7 @@ int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
 static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 {
 	switch (ext) {
+	case KVM_CAP_CORE:
 	case KVM_CAP_IRQCHIP:
 	case KVM_CAP_ARM_PSCI:
 	case KVM_CAP_ARM_PSCI_0_2:
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
2.52.0.rc1.455.g30608eb744-goog

