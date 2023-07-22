Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D036AA2
	for <kvmarm@lists.linux.dev>; Sat, 22 Jul 2023 02:22:58 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-56942442eb0so27247707b3.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 19:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992577; x=1690597377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SI6Gva1qvgHyCE7QYiuLXB9Rb6SmeiZnCZaqC2WR/Sc=;
        b=pclINCkRdRgYAwaus01ejO4ihWr9A2XfL0ddUkYV/8EArvjBZbbuZd1gAvOxilC3EG
         LI5ig+mCKvx5zZiKKeWtoSn1KRLqe9PQt44bIhGnETmctKhIlGGYczLFfINjjUmeV8eM
         vF/f00G3soAZho0MrsjCa00CHbPDXDffhgNgwsvO6ihBYLorYgrQRClyFLc4+ju/Ndg2
         KuE5q+mG/CiKyTPw9stpjZ4mmv5/rWSOe25ukny2y+mj1Vac8JoETMrp/Yu7K8MxNjLv
         ZwVGfuZusT3+e53fBM7XlIyyfghatocIbRyjEOEWb7qvJx+JIJLcOjh2l5X25Jd+zX6l
         km/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992577; x=1690597377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SI6Gva1qvgHyCE7QYiuLXB9Rb6SmeiZnCZaqC2WR/Sc=;
        b=DxzgZfgIFPQf9zW2KbRTsMErJpO6VPRFE8Ch+s9Rh9PqMqfItm6qL5H5Xv7O4U41Iv
         RnyVhsQ35a066lJ0Ipp4HdoLwO4Y3QFdI/zRD7RjfCr4CzTQEdNxUojO44mhVzPqKE3/
         Bc0Fzhe5Tfuw92MCE/2vk9pHAOfqkDpTG4hKSHH9CJfnpYj6SOm+rUVSj7E+624toFb3
         Az7EcGby9g09EUJK16W8fTAKsT/nSXU7WP8DLJ7MdZ+JiE2b5lx6PiJMPNFNvsZFYRDO
         QJoFPgnW2CJScgbvi9soGwoRXComu5m4jvC2QcO7+ejmIYJRXk4H9I4YfgCiiZk1F2HY
         znFA==
X-Gm-Message-State: ABy/qLYle88ENmTF895QZ9t5sCW0mEtOlcDKlPmh9bZRFzPLKvTclQv8
	+RdQuYMLrUlKYDoutMWQjPcEVOvMoPsg
X-Google-Smtp-Source: APBJJlE74S44aAdDkeUWprjnh97a+iXOQv70bhnTttKdjXjLztwho8eu5se6DQmHFzL4Hoaq3q6ibV20GsDb
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:e801:0:b0:57a:793:7fb0 with SMTP id
 a1-20020a81e801000000b0057a07937fb0mr15253ywm.3.1689992577014; Fri, 21 Jul
 2023 19:22:57 -0700 (PDT)
Date: Sat, 22 Jul 2023 02:22:41 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-3-rananta@google.com>
Subject: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Stop depending on CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL and opt to
standardize on kvm_arch_flush_remote_tlbs() since it avoids
duplicating the generic TLB stats across architectures that implement
their own remote TLB flush.

This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
path, but that is a small cost in comparison to flushing remote TLBs.

In addition, instead of just incrementing remote_tlb_flush_requests
stat, the generic interface would also increment the
remote_tlb_flush stat.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/Kconfig            | 1 -
 arch/arm64/kvm/mmu.c              | 6 +++---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b6096753740..7281222f24ef 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1111,6 +1111,9 @@ int __init kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index f531da6b362e..6b730fcfee37 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -25,7 +25,6 @@ menuconfig KVM
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
-	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_XFER_TO_GUEST_WORK
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6db9ef288ec3..0ac721fa27f1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -161,15 +161,15 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 }
 
 /**
- * kvm_flush_remote_tlbs() - flush all VM TLB entries for v7/8
+ * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
  *
  * Interface to HYP function to flush all VM TLB entries
  */
-void kvm_flush_remote_tlbs(struct kvm *kvm)
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
-	++kvm->stat.generic.remote_tlb_flush_requests;
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
+	return 0;
 }
 
 static bool kvm_is_device_pfn(unsigned long pfn)
-- 
2.41.0.487.g6d72f3e995-goog

