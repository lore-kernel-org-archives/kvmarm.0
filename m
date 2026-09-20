Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA12E488228
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933235; cv=none; b=LkhDRuk4mXrV+6hCtgfkdVSH6nntJtqzpXmfWJJ8p5mD4/S7IGmFLulhNEWT/6aVXvNPK8tBGxRgtcICE2dqKjm32eyys+lpTXEQGJefhvhGhQkcqOanqtFZkmB1vUigVi11jM+2pe0jlnbQ2JDLvfJEp17SgOu7u/dOx0/wVY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933235; c=relaxed/simple;
	bh=8tO43vfkvin5iK4wJKBDgqPh58Lb9V2KiW72NOnNrv4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQlTEjKcG+3IYc/5sdkkB0osO9E68oFUSQl2BCWq41+qf/trm+lqqeF90rKreFfHOcpOloMDZ2RPT6kMk74bxWgheHkHLtKUUcQdIbDwnSUsQ0kBMt/gOVK4ne2RpkDFT0FVPJ2weq3JvhLjp1X4yeIIWokFxx87AA/R3HV3n+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=bMP/l1x5; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="bMP/l1x5"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4aae3149so1691690d50.2
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933231; x=1790538031; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vFPyUqf9Ykwf6q7bGvGlkuyq3L5HApELGYTIBtZIcIQ=;
        b=bMP/l1x5q/nkulH/zMojMxMdZQIctxVsWrWj0CEvoZE85m87scg4A4YYNjBCESacpj
         qt1P+RgVu/W1bhInhdTnLQyynaYMQ+mSwHU0z11V+EHt5TpMesRe5lifHXs1V9LADfPv
         fNXSfXyrfc1wYcrJ84Ue8XsdBrANsfeqB6QdMvZsT7UZobsm/iuG0J/PrLBLmsbF2x8Q
         qYIjHmS55qmpi9uiIu+CKuvcmT2+vz2u9LkYNnUMg17faR0lGhaXqgzPriTu6eAIoyse
         XdlWeZQIVcXh1ryNTadwpjUUPXcAxn7+2WukHn1EigG6q7z0aAPlZkC9cWFFW4j8HpJU
         S4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933231; x=1790538031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=vFPyUqf9Ykwf6q7bGvGlkuyq3L5HApELGYTIBtZIcIQ=;
        b=jA398MjOQylbYtfxyiyCjNeYCf1Vd5KAKufkY4DXp5DkQroqI3uZ7yn7hxSwQVn7kL
         w+dgrh2Dv6IXcx3010Gkx8z3CRVJJadbqDfOkBDT52MhOFUJK6fx3elzfvK9pIiiwFsN
         WFARnaRbjKpC9jjVVmqAg5+EoCA42Q+/M8v9J5HEbd7DtNuF5Zrniy8rw52iUuW9mCWg
         Ro9RTy6DUTR895bR6uC1ZuzSwsLmMWmrAIDJP/t0+0WQv52mK3Be6sb1tcr6nxTm4c6L
         3XSvjb0OwPxNEiDXGRNOnc4nWzr3XefmrTMHcM+XlOGSNehZ5t6VirPkzPXNUGujxefL
         IlGA==
X-Forwarded-Encrypted: i=1; AKwUvBwRIihlpG0d7P/YRcYdX+Z6HZZmxDt0OsWV6RLODDeTCMi9eqZPexQiw2b+EtGg9rwifYCv0Ck=@lists.linux.dev
X-Gm-Message-State: AFuF++lHCKutjHLNKNxIUPWpg98bp3shFcWPkP5igYU2SizLFu1+x5ds
	FimF3MaMDVfawAzxKbAC4fck40dqlDAZmz0vI9MNHQ+LTqIoABmPNswsJqMtFk4keEY=
X-Gm-Gg: AYBFou0Rcs5Sv2GrfZudGJ63a5gGK/R/fK2EZ31Gk7c25GknpHlY8CjcbyiNBzgF3DL
	t1jTPPxUO4J3FiXrDGXZgIV2hn4bRmAuNbNkkbaw7NYqYtNjTa9+anEb3/VWImR6wuAHNKcdsaW
	dgdrMsW8O78OsiOkexYcHbD3McJo8X3hPAFYSpysKFnWXaCq83GN4pJpOF083JMjPPUfnYwKh4R
	C3ZUwZQr4UBsi4rIB7gthRmvlk2X8/u2NBxlIAXoKaDKU8L5Rz+hyH5E7f+odOK6Cj821yPH4rx
	8MDc9z0hNPmmtTaoKjfXCLMY1pU7kZjgZjTyRpVMhvQk6cBb3G0rgt7XnVgBWN77hy8w/N4pUAO
	ZpUeurT0NAgAW6WMh1xWCAebT1notJhZg3ko5j7Y1qQll+tSG6cf7oxQp322gIK2+rHnYiuJ9Fo
	wdFYQCPCZTB3/xQjlMV+kPVS/0Bp3ywPHBpXnHKR7H0+mD83ONyTSfhdeRo6RgRJukFe0hrgbV9
	GtNu5cD2wYehCqu554nZXiyKpwooOIUlSgL0YFCgEj2ysmqINvgP2z0gF6febw14S17XT8AIM4P
	DKCAk8JJBKf/44RbXpM=
X-Received: by 2002:a53:b10a:0:b0:671:4e37:a810 with SMTP id 956f58d0204a3-6717fcb43a2mr1769168d50.5.1789933230812;
        Sun, 20 Sep 2026 12:40:30 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67299146eb0sm2609969d50.21.2026.09.20.12.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:29 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 36/46] KVM: x86: Implement Caretaker run loop and LUO detach/attach lifecycle
Date: Sun, 20 Sep 2026 15:36:40 -0400
Message-ID: <20260920193650.3373435-37-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complete the x86 Caretaker vCPU execution loop, detach-time state
serialization, and LUO integration in arch/x86/kvm/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/Kconfig     |   1 +
 arch/x86/kvm/Makefile    |   3 +-
 arch/x86/kvm/caretaker.c | 230 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/caretaker.h |  12 +-
 arch/x86/kvm/kvm_luo.c   |  30 +++++
 5 files changed, 270 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index bae79fded6ff..2d1cb82ac3f1 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,6 +22,7 @@ config KVM_X86
 	select KVM_COMMON
 	select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
 	select KVM_MMU_LOCKLESS_AGING
+	select HAVE_KVM_ARCH_CARETAKER
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 2cf0f1f2a59b..11e67c072258 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,7 +7,8 @@ include $(srctree)/virt/kvm/Makefile.kvm
 
 kvm-y			+= x86.o emulate.o irq.o lapic.o cpuid.o msrs.o pmu.o regs.o \
 			   mtrr.o debugfs.o mmu/mmu.o mmu/page_track.o mmu/spte.o
-kvm-$(CONFIG_LIVEUPDATE) += kvm_luo.o
+kvm-$(CONFIG_LIVEUPDATE) += kvm_luo.o mmu/kho.o
+kvm-$(CONFIG_KVM_CARETAKER) += caretaker.o
 
 kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_IOAPIC) += i8259.o i8254.o ioapic.o
diff --git a/arch/x86/kvm/caretaker.c b/arch/x86/kvm/caretaker.c
index dd2b2d582b69..c43913e94a9d 100644
--- a/arch/x86/kvm/caretaker.c
+++ b/arch/x86/kvm/caretaker.c
@@ -39,6 +39,7 @@
 struct caretaker_x86_host_state {
 	struct desc_ptr orig_idt;
 	unsigned long orig_cr2;
+	unsigned long orig_cr8;
 	unsigned long orig_fs_base;
 	unsigned long orig_gs_base;
 	unsigned long orig_kernel_gs_base;
@@ -53,6 +54,8 @@ static void kvm_x86_caretaker_init_idt(gate_desc *idt);
 static void kvm_x86_caretaker_init_gdt_tss(struct desc_struct *gdt,
 					   struct x86_hw_tss *tss,
 					   unsigned long stack_top);
+static enum oncore_exit_reason __cpu_preserved_text
+kvm_x86_caretaker_run_page(struct caretaker_x86_page *cxp, u64 deadline_ticks);
 
 /*
  * A preserved page is handed over by physical address.  The SME/SEV C-bit is
@@ -75,21 +78,129 @@ cxp_from_cb(struct kvm_caretaker_cb_ser *cb)
 	return container_of(cb, struct caretaker_x86_page, abi.cb);
 }
 
-static const struct kvm_x86_caretaker_ops *kvm_x86_caretaker_ops __cpu_preserved_data;
+static const struct kvm_x86_caretaker_ops *kvm_x86_caretaker_host_ops;
+static const struct kvm_x86_caretaker_runtime_ops *kvm_x86_caretaker_ops __cpu_preserved_data;
 
 void kvm_x86_caretaker_register_ops(const struct kvm_x86_caretaker_ops *ops)
 {
-	WRITE_ONCE(kvm_x86_caretaker_ops, ops);
+	WRITE_ONCE(kvm_x86_caretaker_host_ops, ops);
+	WRITE_ONCE(kvm_x86_caretaker_ops, ops ? ops->runtime : NULL);
+	cpu_preserved_clean(&kvm_x86_caretaker_ops);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_register_ops);
 
 void kvm_x86_caretaker_unregister_ops(const struct kvm_x86_caretaker_ops *ops)
 {
-	if (kvm_x86_caretaker_ops == ops)
+	if (kvm_x86_caretaker_host_ops == ops) {
+		WRITE_ONCE(kvm_x86_caretaker_host_ops, NULL);
 		WRITE_ONCE(kvm_x86_caretaker_ops, NULL);
+		cpu_preserved_clean(&kvm_x86_caretaker_ops);
+	}
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_unregister_ops);
 
+enum oncore_exit_reason __cpu_preserved_text
+kvm_arch_vcpu_caretaker_run(void *data, u64 deadline_ticks)
+{
+	struct kvm_caretaker_cb_ser *cb = data;
+
+	/*
+	 * @data is always a struct kvm_caretaker_cb_ser:
+	 * kvm_caretaker_vcpu_post_preserve() installs it with
+	 * oncore_job_set_data() before activating the job.
+	 */
+	if (!cb)
+		return ONCORE_EXIT_ERROR;
+
+	return kvm_x86_caretaker_run_page(cxp_from_cb(cb), deadline_ticks);
+}
+
+static void kvm_arch_vcpu_caretaker_init(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_caretaker_host_ops && kvm_x86_caretaker_host_ops->init)
+		kvm_x86_caretaker_host_ops->init(vcpu);
+}
+
+int kvm_arch_vcpu_caretaker_preserve(struct kvm_vcpu *vcpu,
+				     struct kvm_vcpu_ser *ser,
+				     struct kvm_vcpu_arch_ser *state, size_t size)
+{
+	struct kvm_caretaker_arch_ser *abi;
+
+	kvm_arch_vcpu_caretaker_init(vcpu);
+	if (!vcpu->caretaker.cb)
+		return -ENOMEM;
+
+	ser->cb.phys = virt_to_phys(vcpu->caretaker.cb);
+	abi = phys_to_virt(ser->cb.phys);
+	container_of(abi, struct caretaker_x86_page, abi)->arch_state = state;
+	cpu_preserved_map_buffer(state, size);
+
+	return 0;
+}
+
+static void kvm_x86_caretaker_signal_attach(struct kvm_vcpu *vcpu, u64 cb_pa)
+{
+	struct kvm_caretaker_arch_ser *abi;
+	struct kvm_caretaker_cb_ser *cb;
+	int target_pcpu;
+	u32 apic_id;
+
+	if (!cb_pa)
+		return;
+
+	abi = caretaker_pa_to_va(cb_pa);
+	cb = &abi->cb;
+	target_pcpu = cb->pcpu_id;
+
+	if (cpu_is_preserved(target_pcpu)) {
+		apic_id = apic->cpu_present_to_apicid(target_pcpu);
+		if (apic_id == BAD_APICID)
+			apic_id = cpuid_to_apicid[target_pcpu];
+		if (apic_id == BAD_APICID)
+			apic_id = abi->apic_id ? abi->apic_id : target_pcpu;
+		if (apic_id != BAD_APICID && apic_id != (u32)-1 && apic_id != 0)
+			per_cpu(x86_cpu_to_apicid, target_pcpu) = apic_id;
+	}
+
+	kvm_caretaker_wait_for_attach(cb, target_pcpu);
+	if (vcpu)
+		vcpu->cpu = -1;
+}
+
+static void kvm_x86_caretaker_attach(struct kvm_vcpu *vcpu, u64 cb_pa)
+{
+	const struct kvm_x86_caretaker_ops *ops = kvm_x86_caretaker_host_ops;
+
+	if (cb_pa) {
+		struct kvm_caretaker_arch_ser *abi = caretaker_pa_to_va(cb_pa);
+
+		vcpu_load(vcpu);
+		if (ops && ops->sync_vcpu)
+			ops->sync_vcpu(vcpu, abi);
+		vcpu_put(vcpu);
+	}
+}
+
+void kvm_arch_vcpu_luo_pre_retrieve_caretaker(struct kvm_vcpu *vcpu,
+					      struct kvm_vcpu_ser *ser)
+{
+	if (!ser || !ser->cb.phys || !(ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER))
+		return;
+
+	kvm_x86_caretaker_signal_attach(vcpu, ser->cb.phys);
+}
+
+void kvm_arch_vcpu_luo_attach_caretaker(struct kvm_vcpu *vcpu,
+					struct kvm_vcpu_ser *ser)
+{
+	if (!ser || !ser->cb.phys || !(ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER))
+		return;
+
+	kvm_x86_caretaker_attach(vcpu, ser->cb.phys);
+	kvm_caretaker_post_attach_vcpu(vcpu);
+}
+
 static bool caretaker_x86_has_tsc_deadline __cpu_preserved_data;
 static u32 caretaker_x86_lapic_timer_period __cpu_preserved_data;
 static u32 caretaker_x86_tsc_khz __cpu_preserved_data;
@@ -289,6 +400,8 @@ kvm_x86_caretaker_save_host_state(struct caretaker_x86_host_state *host,
 
 	store_idt(&host->orig_idt);
 	host->orig_cr2 = native_read_cr2();
+	asm volatile("mov %%cr8, %0" : "=r" (host->orig_cr8));
+	asm volatile("mov %0, %%cr8" : : "r" (0UL) : "memory");
 	/*
 	 * MSR_FS_BASE is in the guest-writable passthrough set below, so it
 	 * has to be saved here or a guest WRMSR to it survives the run and
@@ -334,6 +447,7 @@ kvm_x86_caretaker_restore_host_state(const struct caretaker_x86_host_state *host
 	 * to be zero leaves the *guest's* value live in the host MSR.
 	 */
 	native_write_cr2(host->orig_cr2);
+	asm volatile("mov %0, %%cr8" : : "r" (host->orig_cr8) : "memory");
 	native_wrmsrq(MSR_FS_BASE, host->orig_fs_base);
 	native_wrmsrq(MSR_GS_BASE, host->orig_gs_base);
 	native_wrmsrq(MSR_KERNEL_GS_BASE, host->orig_kernel_gs_base);
@@ -853,6 +967,87 @@ kvm_x86_caretaker_handle_exit(void *data, struct kvm_caretaker_exit *exit)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_handle_exit);
 
+__caretaker_text static void
+caretaker_restore_guest_fpu(struct caretaker_x86_page *cxp,
+			    struct kvm_vcpu_arch_ser *state)
+{
+	union fpregs_state *xstate;
+	u64 rfbm;
+
+	if (!cxp || !state || !cxp->save_guest_fpu)
+		return;
+
+	xstate = (union fpregs_state *)state->xsave.region;
+	rfbm = state->xcrs.xcrs[0].value | XFEATURE_MASK_FPSSE;
+
+	if (native_read_cr0() & X86_CR0_TS)
+		asm volatile("clts" : : : "memory");
+
+	asm volatile("1: xrstor64 %[buf]\n\t"
+		     "2:\n\t"
+		     _ASM_EXTABLE(1b, 2b)
+		     :
+		     : [buf] "m" (*xstate),
+		       "a" ((u32)rfbm), "d" ((u32)(rfbm >> 32))
+		     : "memory");
+}
+
+STACK_FRAME_NON_STANDARD(kvm_x86_caretaker_run_page);
+
+static enum oncore_exit_reason __cpu_preserved_text
+kvm_x86_caretaker_run_page(struct caretaker_x86_page *cxp, u64 deadline_ticks)
+{
+	const struct kvm_x86_caretaker_runtime_ops *ops = kvm_x86_caretaker_ops;
+	enum oncore_exit_reason reason = ONCORE_EXIT_QUANTUM_EXPIRED;
+	struct cpu_preserved_stack_context *sctx;
+	struct caretaker_x86_host_state host_state;
+	int pcpu;
+
+	if (!cxp || !ops)
+		return ONCORE_EXIT_ERROR;
+
+	sctx = cpu_preserved_get_stack_context();
+	if (sctx && sctx->cpu >= 0 && sctx->cpu < CONFIG_NR_CPUS)
+		pcpu = sctx->cpu;
+	else
+		pcpu = cxp->abi.cb.pcpu_id;
+	cxp->abi.cb.pcpu_id = pcpu;
+
+	if (cmpxchg(&cxp->abi.cb.state, KVM_CARETAKER_PAUSED,
+		    KVM_CARETAKER_RUNNING) != KVM_CARETAKER_PAUSED ||
+	    kvm_caretaker_should_exit(&cxp->vcpu)) {
+		smp_store_release(&cxp->abi.cb.state, KVM_CARETAKER_STOPPED);
+		return ONCORE_EXIT_ATTACH_SIGNALED;
+	}
+
+	/* Save host context, switch to Caretaker descriptors and CR3 */
+	kvm_x86_caretaker_save_host_state(&host_state, cxp);
+
+	if (cxp->arch_state)
+		caretaker_restore_guest_fpu(cxp, cxp->arch_state);
+
+	cxp->vcpu.ops = &ops->common;
+
+	reason = kvm_caretaker_vcpu_run(&cxp->vcpu, deadline_ticks);
+
+	iret_to_self();
+
+	if (ops->detach_serialize && cxp->arch_state)
+		ops->detach_serialize(cxp, cxp->arch_state);
+
+	kvm_x86_caretaker_restore_host_state(&host_state, pcpu);
+
+	if (reason == ONCORE_EXIT_ATTACH_SIGNALED ||
+	    kvm_caretaker_should_exit(&cxp->vcpu) ||
+	    cmpxchg(&cxp->abi.cb.state, KVM_CARETAKER_RUNNING,
+		    KVM_CARETAKER_PAUSED) != KVM_CARETAKER_RUNNING) {
+		reason = ONCORE_EXIT_ATTACH_SIGNALED;
+		smp_store_release(&cxp->abi.cb.state, KVM_CARETAKER_STOPPED);
+	}
+
+	return reason;
+}
+
 __caretaker_text void kvm_x86_caretaker_arm_timer(u64 deadline_ticks)
 {
 	if (!deadline_ticks)
@@ -903,3 +1098,32 @@ __caretaker_text void kvm_x86_caretaker_disarm_timer(void)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_disarm_timer);
 
+void kvm_arch_vcpu_caretaker_unpreserve(struct kvm_vcpu_ser *ser)
+{
+	if (ser->cb.phys) {
+		struct kvm_caretaker_arch_ser *abi = caretaker_pa_to_va(ser->cb.phys);
+
+		kvm_x86_caretaker_unpreserve_pages(abi);
+		kho_unpreserve_free(abi);
+		ser->cb.phys = 0;
+	}
+}
+
+void kvm_arch_vcpu_caretaker_finish(struct kvm_vcpu_ser *ser)
+{
+	if (ser->cb.phys) {
+		struct kvm_caretaker_arch_ser *abi = caretaker_pa_to_va(ser->cb.phys);
+		u32 i;
+
+		for (i = 0; i < abi->nr_preserved_pages; i++) {
+			phys_addr_t pa = __sme_clr(abi->preserved_pages_pa[i]);
+			struct page *page = kho_restore_pages(pa, 1);
+
+			if (page)
+				__free_pages(page, 0);
+		}
+		abi->nr_preserved_pages = 0;
+		kho_restore_free(abi);
+		ser->cb.phys = 0;
+	}
+}
diff --git a/arch/x86/kvm/caretaker.h b/arch/x86/kvm/caretaker.h
index 9dd8815d414b..8c0fc336be6b 100644
--- a/arch/x86/kvm/caretaker.h
+++ b/arch/x86/kvm/caretaker.h
@@ -217,11 +217,19 @@ void kvm_x86_caretaker_unregister_ops(const struct kvm_x86_caretaker_ops *ops);
 struct kvm_vcpu_ser;
 
 #ifdef CONFIG_KVM_CARETAKER
-void kvm_arch_vcpu_caretaker_init(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_caretaker_preserve(struct kvm_vcpu *vcpu,
+				     struct kvm_vcpu_ser *ser,
+				     struct kvm_vcpu_arch_ser *state, size_t size);
 void kvm_arch_vcpu_caretaker_unpreserve(struct kvm_vcpu_ser *ser);
 void kvm_arch_vcpu_caretaker_finish(struct kvm_vcpu_ser *ser);
 #else
-static inline void kvm_arch_vcpu_caretaker_init(struct kvm_vcpu *vcpu) {}
+static inline int kvm_arch_vcpu_caretaker_preserve(struct kvm_vcpu *vcpu,
+						   struct kvm_vcpu_ser *ser,
+						   struct kvm_vcpu_arch_ser *state,
+						   size_t size)
+{
+	return 0;
+}
 static inline void kvm_arch_vcpu_caretaker_unpreserve(struct kvm_vcpu_ser *ser) {}
 static inline void kvm_arch_vcpu_caretaker_finish(struct kvm_vcpu_ser *ser) {}
 #endif
diff --git a/arch/x86/kvm/kvm_luo.c b/arch/x86/kvm/kvm_luo.c
index 899b193812bb..ff6acf3acb52 100644
--- a/arch/x86/kvm/kvm_luo.c
+++ b/arch/x86/kvm/kvm_luo.c
@@ -20,9 +20,11 @@
 #include <linux/mem_encrypt.h>
 #include <asm/virt.h>
 
+#include "caretaker.h"
 #include "cpuid.h"
 #include "fpu.h"
 #include "lapic.h"
+#include "mmu.h"
 #include "msrs.h"
 #include "pmu.h"
 #include "regs.h"
@@ -30,7 +32,23 @@
 
 int kvm_arch_vm_luo_preserve(struct kvm *kvm, struct kvm_luo_ser *ser)
 {
+	int ret;
+
 	ser->type = kvm->arch.vm_type;
+
+	/*
+	 * Shadow/TDP page tables are a VM-wide resource: an orphaned vCPU keeps
+	 * running the guest out of them while the VM is detached, so they must
+	 * survive the kexec.  Preserve them once here rather than once per vCPU
+	 * from the caretaker init hook -- the walk is O(size of the guest's page
+	 * tables) and holds mmu_lock for write, so repeating it per vCPU is both
+	 * redundant and a scalability problem on large guests.
+	 */
+	ret = kvm_mmu_preserve_kho(kvm);
+	if (ret)
+		return ret;
+
+	KHOSER_STORE_PTR(ser->kho_folios, kvm->kho_folios);
 	return 0;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vm_luo_preserve);
@@ -185,6 +203,16 @@ int kvm_arch_vcpu_luo_preserve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
 	vcpu_put(vcpu);
 
 	KHOSER_STORE_PTR(ser->arch_state, state);
+
+	if (ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) {
+		int err = kvm_arch_vcpu_caretaker_preserve(vcpu, ser, state, size);
+
+		if (err) {
+			kho_unpreserve_free(state);
+			return err;
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vcpu_luo_preserve);
@@ -315,6 +343,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vcpu_luo_retrieve);
 
 void kvm_arch_vcpu_luo_unpreserve(struct kvm_vcpu_ser *ser)
 {
+	kvm_arch_vcpu_caretaker_unpreserve(ser);
 	if (ser->arch_state.phys) {
 		struct kvm_vcpu_arch_ser *state =
 			phys_to_virt(__sme_clr(ser->arch_state.phys));
@@ -327,6 +356,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_arch_vcpu_luo_unpreserve);
 
 void kvm_arch_vcpu_luo_finish(struct kvm_vcpu_ser *ser)
 {
+	kvm_arch_vcpu_caretaker_finish(ser);
 	if (ser->arch_state.phys) {
 		struct kvm_vcpu_arch_ser *state =
 			phys_to_virt(__sme_clr(ser->arch_state.phys));
-- 
2.55.0.1082.g2b9226bbc0-goog

