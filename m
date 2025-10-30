Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2ED374AA2
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855004; cv=none; b=YDXcSVpA3TTNABpMK2BG3kyIzqDwt6DesMGAOSHqNQO3xlOreybTrpH05vrmspH1of79D1AKtCqGHM4R/idrugqmDWI0v5eslfzhPc9cMGPrZMptyoz6+1Esy+k5WtX1xE7G2upnBui4lxM+j5YRWd/v9JorBCPs3f3EXpH8fMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855004; c=relaxed/simple;
	bh=GwQR3WqNM/N4V33I9/zWw/yrZtqHSbqQBGNXQvrrL5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KSg2z6+ZD8JBZ2u637AbTJqFOehq6Pibx8qcHJQC0nt9tbSSwUBXchvikt2L1I7THsqGQ20uQksGQpi1xgXLU13muwfwHc6H1PyVszBJ17MC0E7sue/Ob6Mmh6I5lA5lc/nod/4u2j9BDqA8dPQYpxLOLT3prWZh6Di/RUVPNOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=atpjPALb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="atpjPALb"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso2390388a91.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855002; x=1762459802; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vdmNuA/XJs18gaKKFpEA0E3nq9J2Wf2NR2DLPMRdiiE=;
        b=atpjPALbLxACHn/EjG5DFJHYu/NaCcHlKGcQUHpRS1sUP7OCmatZ9+kP2odngmD8FJ
         gcLqnb15ZD2V0yV8HkSP693T/Q+c5bCRlgWMRoE8Jau1bSfLYmXJ5h157MftNnPua/ey
         i7suAwz993BPBpu24PM8ASlrTjBmiA9NR3gHeT+Wx16CCXQ7SaTC6vUHoxVKHPHcOccn
         MRNg+tzDRIwx0bbDaUJ+06XNckxRsJalLyspgchRWpcICO4PA6igakyxpI2ZKrIoX/LB
         vT75kJsnUcFFdgA3fBx9vMoPM86KxF3J6nT57Fn7zvSudIKeCekzWwpKchHDmgIevlAI
         ILOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855002; x=1762459802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vdmNuA/XJs18gaKKFpEA0E3nq9J2Wf2NR2DLPMRdiiE=;
        b=K4o4iJEZFJnyS1i9H2ohuEYUlHoSVXP8eLT2B1kj4ZIhCWXp322BmZRBEHK4YrH+G9
         wSC6D9mWFCWHEoIBV5KGGi6oRcB2PrhlqMK8w727BAmbDS6vg2ndWeliavpoD2Eyb7q7
         FqNc+oIo9N0MKiyOykZQFWTW/1Xo3HSux3JjfLYVjNPo19SQ3qiL9/7jwQdo1GbRXyIW
         j4eXPPOaNdxw08LbwQm7B09/d2Yk5R2pLEaMGqEZ//kaypUyoIkhUW9ImPlj2mFEsHlL
         OdMur2kBhGQbxaAY42bKzK4bJ4+p8deej+43ak9PWyCMZ4zmniO/zMw+Zzd7QA+36DR+
         eUWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2v3DRB7p5AQsqe5oAYE8wdy96SyMQowG7uU4ViNJtZ5TuyAbTMM1rJ164rxwhyDOtTCqnmbo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfK2FTnLVJ+bil7q0/XGttgb660/ZHH4wWYp6ZTB9AyrNo9xWH
	/3ExECvq6aeca09XM1jEIHdEkKTBjM09p9koBiRf6FCdMD8R1PJuQOWa4e2+PF+1Ynfkp3z72cY
	rxzninQ==
X-Google-Smtp-Source: AGHT+IHCp67ng7EPL926/aDQ0svpDIsDoj6OeGfyMpf/ofykocac96hQIKqfmRloHmNuNLaZynEjzDSP6Us=
X-Received: from pjvm17.prod.google.com ([2002:a17:90a:de11:b0:33d:79bb:9fd5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b92:b0:334:2a38:2a05
 with SMTP id 98e67ed59e1d1-34082fc64a4mr1360357a91.8.1761855001643; Thu, 30
 Oct 2025 13:10:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:24 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-2-seanjc@google.com>
Subject: [PATCH v4 01/28] KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_vcpu_async_ioctl() "natively" in x86 and arm64 instead
of relying on an #ifdef'd stub, and drop HAVE_KVM_VCPU_ASYNC_IOCTL in
anticipation of using the API on x86.  Once x86 uses the API, providing a
stub for one architecture and having all other architectures opt-in
requires more code than simply implementing the API in the lone holdout.

Eliminating the Kconfig will also reduce churn if the API is renamed in
the future (spoiler alert).

No functional change intended.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c       |  6 ++++++
 arch/loongarch/kvm/Kconfig |  1 -
 arch/mips/kvm/Kconfig      |  1 -
 arch/powerpc/kvm/Kconfig   |  1 -
 arch/riscv/kvm/Kconfig     |  1 -
 arch/s390/kvm/Kconfig      |  1 -
 arch/x86/kvm/x86.c         |  6 ++++++
 include/linux/kvm_host.h   | 10 ----------
 virt/kvm/Kconfig           |  3 ---
 9 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..ef5bf57f79b7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1835,6 +1835,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
+long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
+			       unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
+
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index ae64bbdf83a7..ed4f724db774 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -25,7 +25,6 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_MSI
 	select HAVE_KVM_READONLY_MEM
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index ab57221fa4dd..cc13cc35f208 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	select EXPORT_UASM
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 2f2702c867f7..c9a2d50ff1b0 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 config KVM
 	bool
 	select KVM_COMMON
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_VFIO
 	select HAVE_KVM_IRQ_BYPASS
 
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index c50328212917..77379f77840a 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -23,7 +23,6 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_READONLY_MEM
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select KVM_COMMON
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index cae908d64550..96d16028e8b7 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -20,7 +20,6 @@ config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_ASYNC_PF
 	select KVM_ASYNC_PF_SYNC
 	select KVM_COMMON
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..ca5ba2caf314 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7240,6 +7240,12 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
+long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
+			       unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
+
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5bd76cf394fa..7186b2ae4b57 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2437,18 +2437,8 @@ static inline bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_NO_POLL */
 
-#ifdef CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg);
-#else
-static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
-					     unsigned int ioctl,
-					     unsigned long arg)
-{
-	return -ENOIOCTLCMD;
-}
-#endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
-
 void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 5f0015c5dd95..267c7369c765 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -78,9 +78,6 @@ config HAVE_KVM_IRQ_BYPASS
        tristate
        select IRQ_BYPASS_MANAGER
 
-config HAVE_KVM_VCPU_ASYNC_IOCTL
-       bool
-
 config HAVE_KVM_VCPU_RUN_PID_CHANGE
        bool
 
-- 
2.51.1.930.gacf6e81ea2-goog

