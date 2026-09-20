Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C904734C6
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933078; cv=none; b=AZ3gUrtAG1BZOxM2zoP83iPc1C8keQb1DjTEVN6BjtST/aiWTMKOKkLqYBnL+OljMjR8afY95mrwYqaDbMLYdcr01B+SA3UQ9Ky7thFJr2KIFoBzQCSt3Clhp+GbcolLvO0x6rRg7qSGy7rR4A9h5rQ8m8cmtFuqWaKt0jiSc/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933078; c=relaxed/simple;
	bh=t0G5vIts1mMbeg764fSq8qqdcLZw1TL5IRAMdknmqb0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG6XPteg+cQx72IZ5kSOBo2dTLh0ovaLZ3MNyMQXVV0m5070qJi2TPQEehEirWZipciitrR/HA9AJkK9LThNkaLPiJGhdPsDTYcOmpZDZpsUmfAZwG7fQv+tP4pSWLoSQwuLWFZtG8Ji/7bivs8EtXdMcz1iEY1GsrnNf/qxP2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=jzRN0Jsw; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="jzRN0Jsw"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-8659af7454eso21816647b3.1
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933074; x=1790537874; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TISPcN17siKpndLz83tiaGlQU7pN0QJXl7jCDX0Mj3w=;
        b=jzRN0JswdXupJUbf4YBS0n3ZspA8GiE7eoCxx1H1iJUxfIKMPc/0/gdaR5Y1hZtUaY
         Elbr85agXdoqhR/sMjv0QP9wMi8Jxz4MmG4pNYNdwJFklJjyiiY2Mmof+wGDV4LDOR0R
         zHfNxqvuaBPJzf4sjjKgR0KNhTW1m/JmiTATO2j4ZoSDiHXtVKeHTHtWupbd2sTv4Ezi
         nH/ERpuia6xUjOkhzfba8A1v71htqXfv8zRvvRPoPbGUyjK0cioXCXJG7Wj3EuHZy+cG
         UC5f9WBE2YwGgE1tCdBJ62aC2tcHwGR+dDSa3k5tLfERx128h0we8Vx3NJTeubkan7As
         hRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933074; x=1790537874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TISPcN17siKpndLz83tiaGlQU7pN0QJXl7jCDX0Mj3w=;
        b=YB00ZGwN/pCKcZdLjNCHBZWZULRtpvrvOgWaWltmbScTqOroEc2YenEROZrCToPI52
         3Secg0/wEX5bZ6BF5XIjFLRKel6AXK2sl1Hmacu9QM7KUQcz3d0PynhyLALvBQ36Wng1
         5rjmK/NzAWY/97AN038nZua1RMldHALXk060lV2jRdctJc7BD4beFas8hzeuto98Oa1q
         c12/b36BS0zrG/C11eB4bQuWzZ40i6s1MLd4jB8wKQ+Zt0z65quHlTZXLo979kXex7/0
         f6JKZaXaME5+f42eD7M+AS3mgLhqczRLU/Ic+hTlhKfSndIAy5GC3pPXViHz2OkGizwW
         Fg+A==
X-Forwarded-Encrypted: i=1; AKwUvBx6aiGBp8T9YHTuapIcMSjSXlX2qEwJGgDRubaVjxvuL/NjZImhiBgLbODww+lyQoFyuF4HiQI=@lists.linux.dev
X-Gm-Message-State: AFuF++lzxhIZAt8k8JsEOHMlUXVja4W+nk0FcmCqPCVOFsBk6aow9pUO
	0+wO3J2v1Xt7mgENgRUu40XMqaPoCLNeESdrj8mA3gcMMLQgQSfkH3GfZ2KayLb9VFg=
X-Gm-Gg: AYBFou0dPfoa1+BMhQUXah8bq1BbphMazE2IG2fBvK8u/byLonjXjNSYtrtmVz5eEC4
	iJNVOJgP/0VaAir9JTC+sNIpX5rOQlxbFe/bEBhla7CTch8bRVF4QB3HdhhpljMOgPcnW1jy4ln
	Gwh0eA2nhIN+a7rlKDjKiaegoCjlXfHR4UqoK6ekrOQygPgRAMCs739MGoMhdauOp+q4xBEx6zD
	sou1iKqeRuJfVJzt1L6PYGxQzGpdJDF90lfOYvH9Cus9r17FQACgHPgy2fQBVhhVHmlsKe2eHrd
	0cGBH3GGHSn54I8NXCgphnnNXRy5ZIz1tT4JJriqEiS6V032Lz6iyrR3RlU9Ca3vPVgQEEQNZIi
	/dmfxrmtnZtewRWPf9DFP2YkjehLloiaYHua+6Bx9aU4emM/j4u3/fFX4EFOoluZ5Xztcp5Hy80
	NDQJRp0nt9bvJSZ8equNy7mSf1keTT14ww26+yd0VNz21jxnZBYxuvy+00KUTUBJry393AEZG8v
	45c5TZ98R6jIrFcG8f3Pq/kqfzoD6MPGVKbMWZ7I7NamzdkevzWSUab4Nbihrp46ZzI44bz38KK
	v2apAeYa8eh/dgXXC7o=
X-Received: by 2002:a05:690e:4505:20b0:671:1490:8e67 with SMTP id 956f58d0204a3-6717fdc19eamr2004447d50.72.1789933074089;
        Sun, 20 Sep 2026 12:37:54 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6729910a52dsm2550544d50.16.2026.09.20.12.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:53 -0700 (PDT)
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
Subject: [RFC PATCH 10/46] KVM: arm64: Implement architectural vCPU state preservation via LUO
Date: Sun, 20 Sep 2026 15:36:14 -0400
Message-ID: <20260920193650.3373435-11-pasha.tatashin@soleen.com>
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

Implement ARM64 architectural vCPU state preservation and retrieval
handlers over LUO using struct kvm_vcpu_arch_ser in
include/linux/kho/abi/kvm_arm64.h.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/Kconfig            |   1 +
 arch/arm64/kvm/Makefile           |   2 +
 arch/arm64/kvm/kvm_luo.c          | 201 ++++++++++++++++++++++++++++++
 include/linux/kho/abi/kvm_arm64.h |  61 +++++++++
 4 files changed, 265 insertions(+)
 create mode 100644 arch/arm64/kvm/kvm_luo.c
 create mode 100644 include/linux/kho/abi/kvm_arm64.h

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..fd25b3c0d8ca 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
+	select HAVE_KVM_ARCH_VCPU_PRESERVE
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c..d5e888d1bd50 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -47,3 +47,5 @@ $(obj)/hyp_constants.h: $(obj)/hyp-constants.s FORCE
 
 obj-kvm := $(addprefix $(obj)/, $(kvm-y))
 $(obj-kvm): $(obj)/hyp_constants.h
+
+kvm-y += kvm_luo.o
diff --git a/arch/arm64/kvm/kvm_luo.c b/arch/arm64/kvm/kvm_luo.c
new file mode 100644
index 000000000000..59c56836cda8
--- /dev/null
+++ b/arch/arm64/kvm/kvm_luo.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * ARM64 KVM LUO preservation and retrieval handlers.
+ */
+
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kvm_arm64.h>
+#include <linux/kvm_host.h>
+#include <linux/sched.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
+
+#include <kvm/arm_arch_timer.h>
+#include <kvm/arm_vgic.h>
+
+#include "sys_regs.h"
+#include "vgic/vgic.h"
+
+int kvm_arch_vm_luo_preserve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+	ser->type = kvm_phys_shift(&kvm->arch.mmu);
+	if (kvm_vm_is_protected(kvm))
+		ser->type |= KVM_VM_TYPE_ARM_PROTECTED;
+
+	return 0;
+}
+
+int kvm_arch_vm_luo_retrieve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+	return 0;
+}
+
+void kvm_arch_vm_luo_unpreserve(struct kvm *kvm, struct kvm_luo_ser *ser)
+{
+}
+
+void kvm_arch_vm_luo_finish(struct kvm_luo_ser *ser)
+{
+}
+
+static void kvm_arm_luo_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	regs->regs = vcpu->arch.ctxt.regs;
+	regs->sp_el1 = ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1);
+	regs->elr_el1 = ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
+	regs->spsr[KVM_SPSR_EL1] = ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
+	regs->spsr[KVM_SPSR_ABT] = vcpu->arch.ctxt.spsr_abt;
+	regs->spsr[KVM_SPSR_UND] = vcpu->arch.ctxt.spsr_und;
+	regs->spsr[KVM_SPSR_IRQ] = vcpu->arch.ctxt.spsr_irq;
+	regs->spsr[KVM_SPSR_FIQ] = vcpu->arch.ctxt.spsr_fiq;
+	regs->fp_regs = vcpu->arch.ctxt.fp_regs;
+}
+
+static void kvm_arm_luo_set_regs(struct kvm_vcpu *vcpu, const struct kvm_regs *regs)
+{
+	vcpu->arch.ctxt.regs = regs->regs;
+	ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1) = regs->sp_el1;
+	ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1) = regs->elr_el1;
+	ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1) = regs->spsr[KVM_SPSR_EL1];
+	vcpu->arch.ctxt.spsr_abt = regs->spsr[KVM_SPSR_ABT];
+	vcpu->arch.ctxt.spsr_und = regs->spsr[KVM_SPSR_UND];
+	vcpu->arch.ctxt.spsr_irq = regs->spsr[KVM_SPSR_IRQ];
+	vcpu->arch.ctxt.spsr_fiq = regs->spsr[KVM_SPSR_FIQ];
+	vcpu->arch.ctxt.fp_regs = regs->fp_regs;
+}
+
+int kvm_arch_vcpu_luo_preserve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
+{
+	struct kvm_vcpu_arch_ser *state;
+	int num_sysregs;
+	u64 *indices;
+	size_t size;
+	int i;
+
+	num_sysregs = kvm_arm_get_sys_reg_indices(vcpu, NULL);
+	indices = kmalloc_array(num_sysregs, sizeof(u64), GFP_KERNEL);
+	if (!indices)
+		return -ENOMEM;
+	num_sysregs = kvm_arm_get_sys_reg_indices(vcpu, indices);
+
+	size = struct_size(state, sysregs, num_sysregs);
+	state = kho_alloc_preserve(size);
+	if (IS_ERR(state)) {
+		kfree(indices);
+		return PTR_ERR(state);
+	}
+
+	/* Core register state (uAPI struct kvm_regs) */
+	kvm_arm_luo_get_regs(vcpu, &state->regs);
+
+	/* Multiprocessor execution state (uAPI struct kvm_mp_state) */
+	kvm_arch_vcpu_ioctl_get_mpstate(vcpu, &state->mp_state);
+	state->pad = 0;
+
+	/* Exception / SError injection events (uAPI struct kvm_vcpu_events) */
+	__kvm_arm_vcpu_get_events(vcpu, &state->events);
+
+	/* CPU target and feature configuration (uAPI struct kvm_vcpu_init) */
+	state->init.target = KVM_ARM_TARGET_GENERIC_V8;
+	bitmap_to_arr32(state->init.features, vcpu->kvm->arch.vcpu_features,
+			KVM_VCPU_MAX_FEATURES);
+
+	/* System registers (uAPI struct kvm_one_reg array) */
+	state->num_sysregs = 0;
+	state->reserved = 0;
+	for (i = 0; i < num_sysregs; i++) {
+		u64 val;
+
+		if (kvm_arm_sys_reg_read(vcpu, indices[i], &val) == 0) {
+			state->sysregs[state->num_sysregs].id = indices[i];
+			state->sysregs[state->num_sysregs].addr = val;
+			state->num_sysregs++;
+		}
+	}
+	kfree(indices);
+
+	KHOSER_STORE_PTR(ser->arch_state, state);
+	return 0;
+}
+
+int kvm_arch_vcpu_luo_retrieve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser)
+{
+	struct kvm_vcpu_arch_ser *state;
+	int i;
+
+	if (!ser->arch_state.phys)
+		return 0;
+
+	state = KHOSER_LOAD_PTR(ser->arch_state);
+
+	/* Restore vCPU features */
+	bitmap_from_arr32(vcpu->kvm->arch.vcpu_features, state->init.features,
+			  KVM_VCPU_MAX_FEATURES);
+	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &vcpu->kvm->arch.flags);
+	kvm_reset_vcpu(vcpu);
+	vcpu_set_flag(vcpu, VCPU_INITIALIZED);
+
+	vcpu_reset_hcr(vcpu);
+
+	/* Restore core registers */
+	kvm_arm_luo_set_regs(vcpu, &state->regs);
+
+	if (irqchip_in_kernel(vcpu->kvm) &&
+	    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		vgic_v3_reset(vcpu);
+	}
+
+	/* Restore system registers */
+	for (i = 0; i < state->num_sysregs; i++)
+		kvm_arm_sys_reg_write(vcpu, state->sysregs[i].id, state->sysregs[i].addr);
+
+	/* Restore multiprocessor execution state */
+	kvm_arch_vcpu_ioctl_set_mpstate(vcpu, &state->mp_state);
+
+	/* Restore exception / SError injection events */
+	__kvm_arm_vcpu_set_events(vcpu, &state->events);
+
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		struct vgic_irq *irq;
+		unsigned long flags;
+
+		vcpu->kvm->arch.vgic.enabled = true;
+
+		irq = vgic_get_vcpu_irq(vcpu, timer_irq(vcpu_vtimer(vcpu)));
+		if (irq) {
+			raw_spin_lock_irqsave(&irq->irq_lock, flags);
+			irq->enabled = true;
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+		irq = vgic_get_vcpu_irq(vcpu, timer_irq(vcpu_ptimer(vcpu)));
+		if (irq) {
+			raw_spin_lock_irqsave(&irq->irq_lock, flags);
+			irq->enabled = true;
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+
+	return 0;
+}
+
+void kvm_arch_vcpu_luo_unpreserve(struct kvm_vcpu_ser *ser)
+{
+	if (ser->arch_state.phys) {
+		kho_unpreserve_free(phys_to_virt(ser->arch_state.phys));
+		ser->arch_state.phys = 0;
+	}
+}
+
+void kvm_arch_vcpu_luo_finish(struct kvm_vcpu_ser *ser)
+{
+	if (ser->arch_state.phys) {
+		kho_restore_free(phys_to_virt(ser->arch_state.phys));
+		ser->arch_state.phys = 0;
+	}
+}
diff --git a/include/linux/kho/abi/kvm_arm64.h b/include/linux/kho/abi/kvm_arm64.h
new file mode 100644
index 000000000000..dc121224a177
--- /dev/null
+++ b/include/linux/kho/abi/kvm_arm64.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef _LINUX_KHO_ABI_KVM_ARM64_H
+#define _LINUX_KHO_ABI_KVM_ARM64_H
+
+#ifdef CONFIG_ARM64
+
+#include <linux/build_bug.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <linux/kho/abi/kvm.h>
+#include <uapi/linux/kvm.h>
+#include <uapi/asm/kvm.h>
+
+/**
+ * DOC: arm64 KVM vCPU Live Update ABI
+ *
+ * arm64 KVM uses the ABI defined below for preserving architectural vCPU state
+ * across a kexec reboot using LUO.
+ *
+ * The state is serialized into a packed structure `struct kvm_vcpu_arch_ser`
+ * which is handed over to the next kernel via KHO.
+ *
+ * The core register structure (struct kvm_regs) is a uAPI contract.
+ *
+ * This interface is a contract. Any modification to the structure layout
+ * constitutes a breaking change. Such changes require incrementing the version
+ * number in the KVM_VCPU_LUO_FH_COMPATIBLE string.
+ */
+
+/**
+ * struct kvm_vcpu_arch_ser - Preserved arm64 architectural vCPU state in RAM.
+ * @regs:        Core general-purpose and floating-point registers (uAPI struct kvm_regs).
+ * @mp_state:    Multiprocessor execution state (uAPI struct kvm_mp_state).
+ * @pad:         Padding to maintain 64-bit alignment after mp_state.
+ * @events:      Exception and SError injection state (uAPI struct kvm_vcpu_events).
+ * @init:        Target CPU and vCPU feature bitmap (uAPI struct kvm_vcpu_init).
+ * @num_sysregs: Number of serialized system registers in sysregs array.
+ * @reserved:    Reserved padding for 64-bit alignment.
+ * @sysregs:     Guest architectural system registers (uAPI struct kvm_one_reg array).
+ */
+struct kvm_vcpu_arch_ser {
+	struct kvm_regs regs;
+	struct kvm_mp_state mp_state;
+	u32 pad;
+	struct kvm_vcpu_events events;
+	struct kvm_vcpu_init init;
+	u32 num_sysregs;
+	u32 reserved;
+	struct kvm_one_reg sysregs[];
+} __packed;
+
+static_assert(offsetof(struct kvm_vcpu_arch_ser, sysregs) % sizeof(u64) == 0,
+	      "sysregs must be 64-bit aligned");
+
+#endif /* CONFIG_ARM64 */
+
+#endif /* _LINUX_KHO_ABI_KVM_ARM64_H */
-- 
2.55.0.1082.g2b9226bbc0-goog

