Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A1E22331
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 01:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716342026; cv=none; b=jRwMW48W7B39svApTgPwa2uWWxLwdfU7UlGn8Lk9bK2J2DPt9WkP3awF6BqKmOq7aUsa34kG7EHWYvK8slVRjLfnQuKy/bOGlMpJIr4CYbaoVPmbzpUbrV394XovFmFhQK814ZAIvV4l5nK+cnutwOfGYqg1TTB77ASq6E23OM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716342026; c=relaxed/simple;
	bh=WdlG4f+O5x4XRiT8YMvTWNy6dZwjlO1PItml2z/JwkA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s41EInsKd+V5WPdk7E27AKok0s413sOBLV4vAAQ6EdFi61p3MarTxnZOfqSuzX+C3GnBDbvPg0GBoi2R+iXCwojAuu7Bn5Zjsi9krvToN4/hJU7Sk6tJY1dfbPhpkzA6KKQeDL68AspKoJ9f9/GcEkXrurVsOJeNAsGmML95cf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhaszvMQ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhaszvMQ"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so25305095276.2
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 18:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716342023; x=1716946823; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YIaHuI54z6BrBG13k0tb5gdPpybD0vyJf2+hzL+sGEQ=;
        b=dhaszvMQes67DsWMkYYqXOi4IrUZ6TBOzgjqm1UWz5DZax39t6l//81GEq7KKa/uzn
         RnbGBKDu6Dlb8/HmTXBsWzLLu6CAYRm37E4yj3FvXVkpUmtf0o85DnOazGu0nePJDhu9
         SU0JEQTXxw2CoSN49QrnNBMCJiKS9g8yAlSVCtNqtWMdW/Ytk3B7Ysvw2SeeJK1J7iTd
         6OnwCEde1l4GZfy5CxPpqxPyUImD8eHmAYvvlfsQ6W2Hrj4XOKZnATOY6sylO+Xjn+k1
         kpUwKVKwxiTTF8vqya4JKJD5+mWqfxB0TjHc2J/xXEQmkS/zzKHTMSqnq9oecWFSaF5l
         gp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716342023; x=1716946823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YIaHuI54z6BrBG13k0tb5gdPpybD0vyJf2+hzL+sGEQ=;
        b=hfzBsF1A/xd6pgCMZEIBR4Dz+GjZ++N1c7LFbB8M3lFNVkOKRo5GW1Md9SvAm1C5qY
         jAFT9sFm7NKTn5sLJ3fx3kuar0waeEub3yd5EAOEMUXOe2tVRohKjB+P8uQgfXocYFFG
         G3iJ7Zx4Qnjn9KTlveDZCNykRAxB9hthnmgD9SzNI78DKoHW+SDBPKmk5VhIuDMmcWR1
         STsUNYbAVYhBgR2hNFEd47eIOGxOOCVpBLAJ1w+LkmQcqaboewuOd5V9q+Ai4ZruZQNK
         BH6yS03II9dMYy/szUGEr1YTco/5q8ghVTPMFKzohO/zW7q0zz5M4KspcMFUzhFk/5ZM
         0qbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL9UHf0+dLbA8EJR5XJ8KdXFuGRKb3GlVOZbLUyK2KKOo+oVC4WcA04LWYZu6/WVa7z7UUDyAhXaZIkA3meESws/CxXoD9
X-Gm-Message-State: AOJu0Yz9aZ8qTuZBTXKylmIWkxedp+VcsB8J4JBRXdPzis+SCerJHXPS
	u+QhlciY7cPGLJ01YET4LeaVFYusDFrRtPXHvcvaCjibxQgQjK/Do4TzpEmtm7dBsdXcKwtYJ5F
	HAg==
X-Google-Smtp-Source: AGHT+IFtIcfoZKgdjst/9jN1ZKnYmldDCh/IcPZbGUEgdBNc2SyD0bVhs92SlTALzbm7WKOs3vxydBMimy8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100b:b0:dee:7f2c:ad90 with SMTP id
 3f1490d57ef6-df4e0d38b1bmr236895276.10.1716342023595; Tue, 21 May 2024
 18:40:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 18:40:11 -0700
In-Reply-To: <20240522014013.1672962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522014013.1672962-5-seanjc@google.com>
Subject: [PATCH v2 4/6] KVM: Delete the now unused kvm_arch_sched_in()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Delete kvm_arch_sched_in() now that all implementations are nops.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h     | 1 -
 arch/loongarch/include/asm/kvm_host.h | 1 -
 arch/mips/include/asm/kvm_host.h      | 1 -
 arch/powerpc/include/asm/kvm_host.h   | 1 -
 arch/riscv/include/asm/kvm_host.h     | 1 -
 arch/s390/include/asm/kvm_host.h      | 1 -
 arch/x86/kvm/pmu.c                    | 6 +++---
 arch/x86/kvm/x86.c                    | 5 -----
 include/linux/kvm_host.h              | 2 --
 virt/kvm/kvm_main.c                   | 1 -
 10 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..615e7a2e5590 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1225,7 +1225,6 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 }
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index c87b6ea0ec47..4162a252cdf6 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -261,7 +261,6 @@ static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *arch)
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 179f320cc231..6743a57c1ab4 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -890,7 +890,6 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 8abac532146e..c4fb6a27fb92 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -897,7 +897,6 @@ struct kvm_vcpu_arch {
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index d96281278586..dd77c2db6819 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -286,7 +286,6 @@ struct kvm_vcpu_arch {
 };
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
 #define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 95990461888f..e9fcaf4607a6 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1045,7 +1045,6 @@ extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a593b03c9aed..f9149c9fc275 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -521,9 +521,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * Unused perf_events are only released if the corresponding MSRs
-	 * weren't accessed during the last vCPU time slice. kvm_arch_sched_in
-	 * triggers KVM_REQ_PMU if cleanup is needed.
+	 * Release unused perf_events if the corresponding guest MSRs weren't
+	 * accessed during the last vCPU time slice (need_cleanup is set when
+	 * the vCPU is scheduled back in).
 	 */
 	if (unlikely(pmu->need_cleanup))
 		kvm_pmu_cleanup(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e924d1c51e31..59aa772af755 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12586,11 +12586,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
 }
 
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-
-}
-
 void kvm_arch_free_vm(struct kvm *kvm)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bde69f74b031..c404c428a866 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1495,8 +1495,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
 
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7ecea573d121..b312d0cbe60b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6286,7 +6286,6 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 	WRITE_ONCE(vcpu->ready, false);
 
 	__this_cpu_write(kvm_running_vcpu, vcpu);
-	kvm_arch_sched_in(vcpu, cpu);
 	kvm_arch_vcpu_load(vcpu, cpu);
 
 	WRITE_ONCE(vcpu->scheduled_out, false);
-- 
2.45.0.215.g3402c0e53f-goog

