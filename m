Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2FA372
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:32:07 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d81503de9c9so3244402276.3
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824327; x=1695429127; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=g87cF9aMFFIIQhALNgZyjDSNT/0Iy7aXKR5wCizfY2Q=;
        b=XtEfz4R0zOFCfsemrg0esjv6uAj0bkNdZqoH/Ek3VS3DNCm+fPtts/SLILQM7eq0ZI
         OZuPnr0VSiYZZffTr2t7vZ8IsvUJET/6dVjvyiIiH+yRYzGOTbABxNnxp8iCQA5o7Tgn
         0TT4rw562ZKrGh2ErGjzxn6m9QGe2plI0mz5k4CgEgwG7/SRU2V57pm6fpgmribzJtLZ
         Uv5T3wF0xgTcAwzRuC2xeNnAclFbe0c8Gfweb8RkhGMHk1WJ4IgZooJjTMSkeOsMZOYa
         ALcXmZC7zkJbkzrZ4VjQrvIo+xZwvTVnhidgS7pmee5fVfU4fhtcDSpwS8O8AinQbNft
         Yk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824327; x=1695429127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g87cF9aMFFIIQhALNgZyjDSNT/0Iy7aXKR5wCizfY2Q=;
        b=wUApFtYDOe+/ENXB5kbVMjprpl/v7C/ZmSWnWcML5i5lzFkbnTIJB7pnopPPU8klJu
         dQGwpVjeVW86FsnWjKJVWgtj+i4BW5/yrX71SW8xXmIy6Ulh7hB+O4RS5MXuiMtbFmAw
         nBT0UdYK6ng/vVtyawsj/ORuLD8q7xiy1T/xmAxUKmDN41CS3K+rpQJZHCL6qTUt8N3H
         aPrfQJw56t1CijY488jc7QO0ZPatdLvOZie0op+ya4KldbcYzb1IcwpKsn3wcb7Zh/TX
         ZhEl+R9eZ7owPLnntIV+wL4M3fJsNTD0Rf1Mg4PjmU6w7LecbYJ+e8Z9ByXCzQlpnu3k
         VOFg==
X-Gm-Message-State: AOJu0YxF1qqzDt1PQURxItu4vnjCq3RAkew/uhN7uox1BF2vQmLfOG6p
	GzYby7DBS3mXHLuTyesyfWe8rxJ3gFI=
X-Google-Smtp-Source: AGHT+IFjtTFMkJb5nyS/TbDu5WGvlim/mDgHE3y34bDt9PwwLEa+gj6fWVowFGkCoq7czWyFJVVkIfy0aAQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d28b:0:b0:d0c:c83b:94ed with SMTP id
 j133-20020a25d28b000000b00d0cc83b94edmr70330ybg.10.1694824326852; Fri, 15 Sep
 2023 17:32:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:15 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-24-seanjc@google.com>
Subject: [PATCH 23/26] KVM: arm64: Move and consolidate "public" functions in asm/kvm_host.h
From: Sean Christopherson <seanjc@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tony Krowiak <akrowiak@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Jason Herne <jjherne@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Andy Lutomirski <luto@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"

Move a variety of "public" symbols in arm64's kvm_host.h, i.e. symbols and
functions that are used by non-KVM code, towards the top of the header.
This will allow hiding the "private" code in kvm_host.h, i.e. the stuff
that is intended to be KVM-internal, with a minimal amount of #ifdeffery.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 48 ++++++++++++++-----------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 90cfbf420545..89b40c34f0af 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -67,10 +67,32 @@ enum kvm_mode {
 };
 #ifdef CONFIG_KVM
 enum kvm_mode kvm_get_mode(void);
+
+extern phys_addr_t hyp_mem_base;
+extern phys_addr_t hyp_mem_size;
+void __init kvm_hyp_reserve(void);
+
+void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u32 clr);
+bool kvm_set_pmuserenr(u64 val);
 #else
 static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
+
+static inline void kvm_hyp_reserve(void) { }
+
+static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u32 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
 #endif
 
+static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
+{
+	return (!has_vhe() && attr->exclude_host);
+}
+
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int __ro_after_init kvm_sve_max_vl;
@@ -1086,28 +1108,10 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
 
-static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
-{
-	return (!has_vhe() && attr->exclude_host);
-}
-
 /* Flags for host debug state */
 void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_KVM
-void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
-void kvm_clr_pmu_events(u32 clr);
-bool kvm_set_pmuserenr(u64 val);
-#else
-static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
-static inline void kvm_clr_pmu_events(u32 clr) {}
-static inline bool kvm_set_pmuserenr(u64 val)
-{
-	return false;
-}
-#endif
-
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu);
 
@@ -1142,14 +1146,6 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &(kvm)->arch.flags))
 
 int kvm_trng_call(struct kvm_vcpu *vcpu);
-#ifdef CONFIG_KVM
-extern phys_addr_t hyp_mem_base;
-extern phys_addr_t hyp_mem_size;
-void __init kvm_hyp_reserve(void);
-#else
-static inline void kvm_hyp_reserve(void) { }
-#endif
-
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
-- 
2.42.0.459.ge4e396fd5e-goog

