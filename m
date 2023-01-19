Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36F4A93E
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 17:36:13 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id s76-20020a632c4f000000b0049ceb0f185eso1306394pgs.7
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 09:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GgujeBTGY+XPYs5ne3mTkJokj6lazpp6N+d6XNZ97pw=;
        b=latOsqax6/PmzNPPdGRPsks2ZPHfSiaoVYaka5jMmqwJQavYtzMyOpZciFUpDiWGD8
         TQQSjrxyS3NZ/nnLYwJShowJUhlSp7XkMCflOl4PIo6c8VDpH5Rf6NLe0a3eOnvdnAes
         Oirg6ipeLtjYdqlnKTLR3rlxyPaT/iVlx8VCkmhit7DE+00R9343AfUr4sdVPT/XxIwO
         DUx9jDVHdcmWuTQ+62j4EEl64EcGNCMQLDZwgUB3/vFNLSGGOMfCugHrLTC4F4AgnNmX
         amE92hT+gOABTNn3Fdf3D3upUlbiKTf7EoW1w/A+BbgnYlDm6bWnXyVZ9YYGborZRydD
         YDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GgujeBTGY+XPYs5ne3mTkJokj6lazpp6N+d6XNZ97pw=;
        b=DRZK3idORlS2xBHkd4cXSzOryPgLd603Tvfkd4qq1QJxik5rOqKl3ECAbt3gjNWE1z
         jmRFfDJFg8nyjAD8tfhA9NqjwzZfkuXRG0TPpiGpnq9WSbDCigU0aEERQU2ws3WLoDUT
         VM7JRnPIPBPHG8IZSLGhHSUaZDRESBIO9DJwL8TasvLRGVrUGb9FpfgpRZ2Pga7+xIGT
         ZVqAOcp+/fbHURG47FeweVUwdgRF/+EsT7MPXZSsVXC+oBiAW4PKkqIBCsSzQfu/YYgD
         gzF9l752kbkGQFLW7K3pwy8UWLJdXrpQq3WnCPI3zWgSVSp+LRNDphZyDGXsVcwojDuY
         T8pw==
X-Gm-Message-State: AFqh2kp2d250lOMuTk6+kejGl2kwE/h9a9lMb1D2SeHJpWMYRYQZ+qrt
	k79BzDxVnBthT1/DWTrQGRnO+HY+xKVuUA==
X-Google-Smtp-Source: AMrXdXtcil7hw2SSiTYuJm0VVkKpNKzO555qItFAZvlrYLAajHo5qGGmiFYRAQqSVOhsfjkuf63pFdSVnZe90g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:aa7:8a45:0:b0:581:6059:b7c8 with SMTP id
 n5-20020aa78a45000000b005816059b7c8mr1316362pfa.26.1674149773461; Thu, 19 Jan
 2023 09:36:13 -0800 (PST)
Date: Thu, 19 Jan 2023 09:35:54 -0800
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-3-dmatlack@google.com>
Subject: [PATCH 2/7] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Use kvm_arch_flush_remote_tlbs() instead of
CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL. The two mechanisms solve the same
problem, allowing architecture-specific code to provide a non-IPI
implementation of remote TLB flushing.

Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
all architectures on kvm_arch_flush_remote_tlbs() instead of maintaining
two mechanisms.

Opt to standardize on kvm_arch_flush_remote_tlbs() since it avoids
duplicating the generic TLB stats across architectures that implement
their own remote TLB flush.

This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
path, but (I assume) that is a small cost in comparison to flushing
remote TLBs.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/Kconfig            | 1 -
 arch/arm64/kvm/mmu.c              | 6 +++---
 virt/kvm/kvm_main.c               | 2 --
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 113e20fdbb56..062800f1dc54 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -998,6 +998,9 @@ int __init kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ca6eadeb7d1a..e9ac57098a0b 100644
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
index 01352f5838a0..8840f65e0e40 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -80,15 +80,15 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 277507463678..fefd3e3c8fe1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -347,7 +347,6 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 }
 EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
-#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
 	++kvm->stat.generic.remote_tlb_flush_requests;
@@ -368,7 +367,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		++kvm->stat.generic.remote_tlb_flush;
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
-#endif
 
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
-- 
2.39.0.246.g2a6d74b583-goog

