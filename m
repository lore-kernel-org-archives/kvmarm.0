Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7A4EA6
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:32:11 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1c0cfc2b995so24155185ad.2
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824331; x=1695429131; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XQKt9ip81eNaA/ioPgL3dH9e9vr3TzqljSeTBinzyVo=;
        b=Eq9AeZcp+/YCtvjWPTQhXPBOWxcRi484tlc3PJtj22i/o+Hq/9T/rWyh6uxF2OgZZC
         NmIgqvOBr32pfd5j1y8AjPpBsAkexRj3Qa5EElCkRxP2cdqGopM8YlFSrx2ZzDs6P+bA
         aCBBzK7gPpYe8JAnj/70mMFl2p7q2KcCUhh/rlK7LQ+vADibb39ch7t9FdKGOQ3yZepJ
         0B0/aE/Hy/2zza59HEQ7j4aZE7NaJzZQvXgS6pYOoyMbX9wtklBCit8EkCmc01xF5nh+
         Meh9w8Ftn4UIeFgiKtdwek6NJs8mogC4185ys5TjEFK7sD5rUcD+gZPl0NGvZVNshnvP
         Rzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824331; x=1695429131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XQKt9ip81eNaA/ioPgL3dH9e9vr3TzqljSeTBinzyVo=;
        b=GGPWWyzwSnM9FoCR32zqVNVWeBZWKKPAd+uYK82berfIEFKQ3/KexITgv5xvcJxsI9
         aX+BJzJ2fkgvA3hiXM08tnCt8IvJskCBbO/vgK6/CajDuYPHC3d3cAcc9OO9Cts+cF9g
         olmv/9e3yq6vR+j2eOlP3p8Fc663YE+9Bm0Q7UL+rzAsWNRC1tRJ8iOm5YtQ7s5gcwpR
         AMWYvbdIWQPYTEs1Ib8dHQL32o8gi6Qv4X4+DlxJx0MgKj4RGU76Bm1/OEUy9bV7bwo3
         f+u0TzoocIHHOODF6nDxNf5jdpBEYhqClXPR1TSXg3hw+yX0E2yEnRv+n8i8icKTvKb7
         tbeA==
X-Gm-Message-State: AOJu0Yx3yEqr0gCA3cWmP5yUO4OiK268WcBr0iUbC5ZZYDA+407VtbNm
	AMfsrRxQrHLqomH9Ft5tJXUVWzw/DOM=
X-Google-Smtp-Source: AGHT+IGF/tpivhdzzMxCzu4p2COJ/tsujORVDRvqtMyofX9ypz/OjlCrOXRz/aOj6KmZJ7FZTcTX3ecEuUc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c7:b0:1bc:5182:1de2 with SMTP id
 o7-20020a170902d4c700b001bc51821de2mr81466plg.1.1694824330917; Fri, 15 Sep
 2023 17:32:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:17 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-26-seanjc@google.com>
Subject: [PATCH 25/26] KVM: PPC: Rearrange code in kvm_ppc.h to isolate
 "public" information
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

Move all declarations and definitions in kvm_ppc.h that are consumed by
things other than KVM to the top of the file.  This will allow wrapping
the parts of kvm_ppc.h that are intended only for KVM, i.e. are intended
to be "private" to KVM, with an #ifdef to hide KVM's internal details from
the kernel at-large.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_ppc.h | 302 +++++++++++++++--------------
 1 file changed, 153 insertions(+), 149 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 72fee202d3ec..ead2ad892ebc 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -30,6 +30,159 @@
 #endif
 #include <asm/inst.h>
 
+struct openpic;
+
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+extern void kvm_cma_reserve(void) __init;
+static inline void kvmppc_set_xics_phys(int cpu, unsigned long addr)
+{
+	paca_ptrs[cpu]->kvm_hstate.xics_phys = (void __iomem *)addr;
+}
+
+static inline void kvmppc_set_xive_tima(int cpu,
+					unsigned long phys_addr,
+					void __iomem *virt_addr)
+{
+	paca_ptrs[cpu]->kvm_hstate.xive_tima_phys = (void __iomem *)phys_addr;
+	paca_ptrs[cpu]->kvm_hstate.xive_tima_virt = virt_addr;
+}
+
+static inline u32 kvmppc_get_xics_latch(void)
+{
+	u32 xirr;
+
+	xirr = get_paca()->kvm_hstate.saved_xirr;
+	get_paca()->kvm_hstate.saved_xirr = 0;
+	return xirr;
+}
+
+/*
+ * To avoid the need to unnecessarily exit fully to the host kernel, an IPI to
+ * a CPU thread that's running/napping inside of a guest is by default regarded
+ * as a request to wake the CPU (if needed) and continue execution within the
+ * guest, potentially to process new state like externally-generated
+ * interrupts or IPIs sent from within the guest itself (e.g. H_PROD/H_IPI).
+ *
+ * To force an exit to the host kernel, kvmppc_set_host_ipi() must be called
+ * prior to issuing the IPI to set the corresponding 'host_ipi' flag in the
+ * target CPU's PACA. To avoid unnecessary exits to the host, this flag should
+ * be immediately cleared via kvmppc_clear_host_ipi() by the IPI handler on
+ * the receiving side prior to processing the IPI work.
+ *
+ * NOTE:
+ *
+ * We currently issue an smp_mb() at the beginning of kvmppc_set_host_ipi().
+ * This is to guard against sequences such as the following:
+ *
+ *      CPU
+ *        X: smp_muxed_ipi_set_message():
+ *        X:   smp_mb()
+ *        X:   message[RESCHEDULE] = 1
+ *        X: doorbell_global_ipi(42):
+ *        X:   kvmppc_set_host_ipi(42)
+ *        X:   ppc_msgsnd_sync()/smp_mb()
+ *        X:   ppc_msgsnd() -> 42
+ *       42: doorbell_exception(): // from CPU X
+ *       42:   ppc_msgsync()
+ *      105: smp_muxed_ipi_set_message():
+ *      105:   smb_mb()
+ *           // STORE DEFERRED DUE TO RE-ORDERING
+ *    --105:   message[CALL_FUNCTION] = 1
+ *    | 105: doorbell_global_ipi(42):
+ *    | 105:   kvmppc_set_host_ipi(42)
+ *    |  42:   kvmppc_clear_host_ipi(42)
+ *    |  42: smp_ipi_demux_relaxed()
+ *    |  42: // returns to executing guest
+ *    |      // RE-ORDERED STORE COMPLETES
+ *    ->105:   message[CALL_FUNCTION] = 1
+ *      105:   ppc_msgsnd_sync()/smp_mb()
+ *      105:   ppc_msgsnd() -> 42
+ *       42: local_paca->kvm_hstate.host_ipi == 0 // IPI ignored
+ *      105: // hangs waiting on 42 to process messages/call_single_queue
+ *
+ * We also issue an smp_mb() at the end of kvmppc_clear_host_ipi(). This is
+ * to guard against sequences such as the following (as well as to create
+ * a read-side pairing with the barrier in kvmppc_set_host_ipi()):
+ *
+ *      CPU
+ *        X: smp_muxed_ipi_set_message():
+ *        X:   smp_mb()
+ *        X:   message[RESCHEDULE] = 1
+ *        X: doorbell_global_ipi(42):
+ *        X:   kvmppc_set_host_ipi(42)
+ *        X:   ppc_msgsnd_sync()/smp_mb()
+ *        X:   ppc_msgsnd() -> 42
+ *       42: doorbell_exception(): // from CPU X
+ *       42:   ppc_msgsync()
+ *           // STORE DEFERRED DUE TO RE-ORDERING
+ *    -- 42:   kvmppc_clear_host_ipi(42)
+ *    |  42: smp_ipi_demux_relaxed()
+ *    | 105: smp_muxed_ipi_set_message():
+ *    | 105:   smb_mb()
+ *    | 105:   message[CALL_FUNCTION] = 1
+ *    | 105: doorbell_global_ipi(42):
+ *    | 105:   kvmppc_set_host_ipi(42)
+ *    |      // RE-ORDERED STORE COMPLETES
+ *    -> 42:   kvmppc_clear_host_ipi(42)
+ *       42: // returns to executing guest
+ *      105:   ppc_msgsnd_sync()/smp_mb()
+ *      105:   ppc_msgsnd() -> 42
+ *       42: local_paca->kvm_hstate.host_ipi == 0 // IPI ignored
+ *      105: // hangs waiting on 42 to process messages/call_single_queue
+ */
+static inline void kvmppc_set_host_ipi(int cpu)
+{
+	/*
+	 * order stores of IPI messages vs. setting of host_ipi flag
+	 *
+	 * pairs with the barrier in kvmppc_clear_host_ipi()
+	 */
+	smp_mb();
+	WRITE_ONCE(paca_ptrs[cpu]->kvm_hstate.host_ipi, 1);
+}
+
+static inline void kvmppc_clear_host_ipi(int cpu)
+{
+	WRITE_ONCE(paca_ptrs[cpu]->kvm_hstate.host_ipi, 0);
+	/*
+	 * order clearing of host_ipi flag vs. processing of IPI messages
+	 *
+	 * pairs with the barrier in kvmppc_set_host_ipi()
+	 */
+	smp_mb();
+}
+
+extern void kvmppc_xics_ipi_action(void);
+
+extern void kvm_hv_vm_activated(void);
+extern void kvm_hv_vm_deactivated(void);
+extern bool kvm_hv_mode_active(void);
+#else
+static inline void __init kvm_cma_reserve(void)
+{}
+
+static inline void kvmppc_set_xics_phys(int cpu, unsigned long addr)
+{}
+
+static inline void kvmppc_set_xive_tima(int cpu,
+					unsigned long phys_addr,
+					void __iomem *virt_addr)
+{}
+
+static inline u32 kvmppc_get_xics_latch(void)
+{
+	return 0;
+}
+
+static inline void kvmppc_set_host_ipi(int cpu)
+{}
+
+static inline void kvmppc_clear_host_ipi(int cpu)
+{}
+
+static inline bool kvm_hv_mode_active(void)		{ return false; }
+#endif
+
 /*
  * KVMPPC_INST_SW_BREAKPOINT is debug Instruction
  * for supporting software breakpoint.
@@ -443,166 +596,18 @@ void kvmppc_set_pid(struct kvm_vcpu *vcpu, u32 pid);
 struct openpic;
 
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-extern void kvm_cma_reserve(void) __init;
-static inline void kvmppc_set_xics_phys(int cpu, unsigned long addr)
-{
-	paca_ptrs[cpu]->kvm_hstate.xics_phys = (void __iomem *)addr;
-}
-
-static inline void kvmppc_set_xive_tima(int cpu,
-					unsigned long phys_addr,
-					void __iomem *virt_addr)
-{
-	paca_ptrs[cpu]->kvm_hstate.xive_tima_phys = (void __iomem *)phys_addr;
-	paca_ptrs[cpu]->kvm_hstate.xive_tima_virt = virt_addr;
-}
-
-static inline u32 kvmppc_get_xics_latch(void)
-{
-	u32 xirr;
-
-	xirr = get_paca()->kvm_hstate.saved_xirr;
-	get_paca()->kvm_hstate.saved_xirr = 0;
-	return xirr;
-}
-
-/*
- * To avoid the need to unnecessarily exit fully to the host kernel, an IPI to
- * a CPU thread that's running/napping inside of a guest is by default regarded
- * as a request to wake the CPU (if needed) and continue execution within the
- * guest, potentially to process new state like externally-generated
- * interrupts or IPIs sent from within the guest itself (e.g. H_PROD/H_IPI).
- *
- * To force an exit to the host kernel, kvmppc_set_host_ipi() must be called
- * prior to issuing the IPI to set the corresponding 'host_ipi' flag in the
- * target CPU's PACA. To avoid unnecessary exits to the host, this flag should
- * be immediately cleared via kvmppc_clear_host_ipi() by the IPI handler on
- * the receiving side prior to processing the IPI work.
- *
- * NOTE:
- *
- * We currently issue an smp_mb() at the beginning of kvmppc_set_host_ipi().
- * This is to guard against sequences such as the following:
- *
- *      CPU
- *        X: smp_muxed_ipi_set_message():
- *        X:   smp_mb()
- *        X:   message[RESCHEDULE] = 1
- *        X: doorbell_global_ipi(42):
- *        X:   kvmppc_set_host_ipi(42)
- *        X:   ppc_msgsnd_sync()/smp_mb()
- *        X:   ppc_msgsnd() -> 42
- *       42: doorbell_exception(): // from CPU X
- *       42:   ppc_msgsync()
- *      105: smp_muxed_ipi_set_message():
- *      105:   smb_mb()
- *           // STORE DEFERRED DUE TO RE-ORDERING
- *    --105:   message[CALL_FUNCTION] = 1
- *    | 105: doorbell_global_ipi(42):
- *    | 105:   kvmppc_set_host_ipi(42)
- *    |  42:   kvmppc_clear_host_ipi(42)
- *    |  42: smp_ipi_demux_relaxed()
- *    |  42: // returns to executing guest
- *    |      // RE-ORDERED STORE COMPLETES
- *    ->105:   message[CALL_FUNCTION] = 1
- *      105:   ppc_msgsnd_sync()/smp_mb()
- *      105:   ppc_msgsnd() -> 42
- *       42: local_paca->kvm_hstate.host_ipi == 0 // IPI ignored
- *      105: // hangs waiting on 42 to process messages/call_single_queue
- *
- * We also issue an smp_mb() at the end of kvmppc_clear_host_ipi(). This is
- * to guard against sequences such as the following (as well as to create
- * a read-side pairing with the barrier in kvmppc_set_host_ipi()):
- *
- *      CPU
- *        X: smp_muxed_ipi_set_message():
- *        X:   smp_mb()
- *        X:   message[RESCHEDULE] = 1
- *        X: doorbell_global_ipi(42):
- *        X:   kvmppc_set_host_ipi(42)
- *        X:   ppc_msgsnd_sync()/smp_mb()
- *        X:   ppc_msgsnd() -> 42
- *       42: doorbell_exception(): // from CPU X
- *       42:   ppc_msgsync()
- *           // STORE DEFERRED DUE TO RE-ORDERING
- *    -- 42:   kvmppc_clear_host_ipi(42)
- *    |  42: smp_ipi_demux_relaxed()
- *    | 105: smp_muxed_ipi_set_message():
- *    | 105:   smb_mb()
- *    | 105:   message[CALL_FUNCTION] = 1
- *    | 105: doorbell_global_ipi(42):
- *    | 105:   kvmppc_set_host_ipi(42)
- *    |      // RE-ORDERED STORE COMPLETES
- *    -> 42:   kvmppc_clear_host_ipi(42)
- *       42: // returns to executing guest
- *      105:   ppc_msgsnd_sync()/smp_mb()
- *      105:   ppc_msgsnd() -> 42
- *       42: local_paca->kvm_hstate.host_ipi == 0 // IPI ignored
- *      105: // hangs waiting on 42 to process messages/call_single_queue
- */
-static inline void kvmppc_set_host_ipi(int cpu)
-{
-	/*
-	 * order stores of IPI messages vs. setting of host_ipi flag
-	 *
-	 * pairs with the barrier in kvmppc_clear_host_ipi()
-	 */
-	smp_mb();
-	WRITE_ONCE(paca_ptrs[cpu]->kvm_hstate.host_ipi, 1);
-}
-
-static inline void kvmppc_clear_host_ipi(int cpu)
-{
-	WRITE_ONCE(paca_ptrs[cpu]->kvm_hstate.host_ipi, 0);
-	/*
-	 * order clearing of host_ipi flag vs. processing of IPI messages
-	 *
-	 * pairs with the barrier in kvmppc_set_host_ipi()
-	 */
-	smp_mb();
-}
-
 static inline void kvmppc_fast_vcpu_kick(struct kvm_vcpu *vcpu)
 {
 	vcpu->kvm->arch.kvm_ops->fast_vcpu_kick(vcpu);
 }
 
-extern void kvm_hv_vm_activated(void);
-extern void kvm_hv_vm_deactivated(void);
-extern bool kvm_hv_mode_active(void);
-
 extern void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu);
 
 #else
-static inline void __init kvm_cma_reserve(void)
-{}
-
-static inline void kvmppc_set_xics_phys(int cpu, unsigned long addr)
-{}
-
-static inline void kvmppc_set_xive_tima(int cpu,
-					unsigned long phys_addr,
-					void __iomem *virt_addr)
-{}
-
-static inline u32 kvmppc_get_xics_latch(void)
-{
-	return 0;
-}
-
-static inline void kvmppc_set_host_ipi(int cpu)
-{}
-
-static inline void kvmppc_clear_host_ipi(int cpu)
-{}
-
 static inline void kvmppc_fast_vcpu_kick(struct kvm_vcpu *vcpu)
 {
 	kvm_vcpu_kick(vcpu);
 }
-
-static inline bool kvm_hv_mode_active(void)		{ return false; }
-
 #endif
 
 #ifdef CONFIG_PPC_PSERIES
@@ -642,7 +647,6 @@ extern u64 kvmppc_xics_get_icp(struct kvm_vcpu *vcpu);
 extern int kvmppc_xics_set_icp(struct kvm_vcpu *vcpu, u64 icpval);
 extern int kvmppc_xics_connect_vcpu(struct kvm_device *dev,
 			struct kvm_vcpu *vcpu, u32 cpu);
-extern void kvmppc_xics_ipi_action(void);
 extern void kvmppc_xics_set_mapped(struct kvm *kvm, unsigned long guest_irq,
 				   unsigned long host_irq);
 extern void kvmppc_xics_clr_mapped(struct kvm *kvm, unsigned long guest_irq,
-- 
2.42.0.459.ge4e396fd5e-goog

