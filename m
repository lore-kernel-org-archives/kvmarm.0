Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A6A37C926
	for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776003779; cv=none; b=pkl6zCd1Y61Fgu8uxv+oBKGi3nP3+T6itV65NC4VJR7BjCXG5yF0bGwdYbR5ZPORn6k3bN/4mO2QqIze/kq4zIMqGYJCi0OQ+bn3b92W4bpnruaTjSD4i0xsTbFo1mb+zAB+n/DV03MIBZjLTjdTNWeDTL7T3/DuuObjC+XBsYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776003779; c=relaxed/simple;
	bh=E0tA+aBloqPjlEi88eqOCQ0ZNlkrLclDrT1oQOIPBbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1LS587INQDkKPnbqrDeGiac8E6MMg+ytRa59qaQlJif8unE/6EWHdsUftkAC91PkiAhNHsO4Ne+xGanYUeVjyFVKrJ9ppMZhnJ5nAMyHFvrsySSChS5HBs1ytjVZaGDNKaKKOePuyfz7ifd/EJVHt08sSIF5dq59WNoGyhByMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hE2pS9tp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hE2pS9tp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9455F4CE1;
	Sun, 12 Apr 2026 07:22:44 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22D003F641;
	Sun, 12 Apr 2026 07:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776003770; bh=E0tA+aBloqPjlEi88eqOCQ0ZNlkrLclDrT1oQOIPBbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hE2pS9tpMG6yqM9R0CInYNT2tvJDfKfEpDQyoLVzn4kUelFrvFKAdpnBS1rfYh7V8
	 Xx3V2MEfSdDjx5D3luZCNKQcGHw7CbCahJnRB1tFCbVF65afUJX/KXYAjUysI0Xu70
	 9/HE0NF0en9nNxCmWNlJfHwf7PYkbGtmz0JJRgFc=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 2/4] KVM: arm64: sefltests: Add helpers for guest hypervisors
Date: Sun, 12 Apr 2026 15:22:14 +0100
Message-ID: <20260412142216.3806482-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260412142216.3806482-1-weilin.chang@arm.com>
References: <20260412142216.3806482-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helpers so that guest hypervisors can run nested guests. SP_EL1
save/restore is added to allow nested guests to use a stack.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 .../selftests/kvm/include/arm64/nested.h      | 17 +++++++
 tools/testing/selftests/kvm/lib/arm64/entry.S |  5 ++
 .../testing/selftests/kvm/lib/arm64/nested.c  | 46 +++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
index 86d931facacb..7928ef89494a 100644
--- a/tools/testing/selftests/kvm/include/arm64/nested.h
+++ b/tools/testing/selftests/kvm/include/arm64/nested.h
@@ -21,8 +21,17 @@
 
 extern char hyp_vectors[];
 
+enum vcpu_sysreg {
+	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
+
+	SP_EL1,
+
+	NR_SYS_REGS
+};
+
 struct cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
+	u64 sys_regs[NR_SYS_REGS];
 };
 
 struct vcpu {
@@ -37,9 +46,17 @@ struct hyp_data {
 	struct cpu_context hyp_context;
 };
 
+void prepare_hyp(void);
+void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top);
+int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data);
+
+void do_hvc(void);
 u64 __guest_enter(struct vcpu *vcpu, struct cpu_context *hyp_context);
 void __hyp_exception(u64 type);
 
+void __sysreg_save_el1_state(struct cpu_context *ctxt);
+void __sysreg_restore_el1_state(struct cpu_context *ctxt);
+
 #endif /* !__ASSEMBLER__ */
 
 #endif /* SELFTEST_KVM_NESTED_H */
diff --git a/tools/testing/selftests/kvm/lib/arm64/entry.S b/tools/testing/selftests/kvm/lib/arm64/entry.S
index 33bedf5e7fb2..df3af3463c6c 100644
--- a/tools/testing/selftests/kvm/lib/arm64/entry.S
+++ b/tools/testing/selftests/kvm/lib/arm64/entry.S
@@ -3,6 +3,11 @@
  * adapted from arch/arm64/kvm/hyp/entry.S
  */
 
+ .globl do_hvc
+ do_hvc:
+	hvc	#0
+	ret
+
 /*
  * Manually define these for now
  */
diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
index 06ddaab2436f..b30d20b101c4 100644
--- a/tools/testing/selftests/kvm/lib/arm64/nested.c
+++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
@@ -4,7 +4,53 @@
  */
 
 #include "nested.h"
+#include "processor.h"
 #include "test_util.h"
+#include <asm/sysreg.h>
+
+void prepare_hyp(void)
+{
+	write_sysreg(HCR_EL2_E2H | HCR_EL2_RW, hcr_el2);
+	write_sysreg(hyp_vectors, vbar_el2);
+	isb();
+}
+
+void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top)
+{
+	memset(vcpu, 0, sizeof(*vcpu));
+	vcpu->context.regs.pc = l2_pc;
+	vcpu->context.regs.pstate = PSR_MODE_EL1h | PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
+	vcpu->context.sys_regs[SP_EL1] = l2_stack_top;
+}
+
+void __sysreg_save_el1_state(struct cpu_context *ctxt)
+{
+	ctxt->sys_regs[SP_EL1] = read_sysreg(sp_el1);
+}
+
+void __sysreg_restore_el1_state(struct cpu_context *ctxt)
+{
+	write_sysreg(ctxt->sys_regs[SP_EL1], sp_el1);
+}
+
+int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data)
+{
+	u64 ret;
+
+	__sysreg_restore_el1_state(&vcpu->context);
+
+	write_sysreg(vcpu->context.regs.pstate, spsr_el2);
+	write_sysreg(vcpu->context.regs.pc, elr_el2);
+
+	ret =  __guest_enter(vcpu, &hyp_data->hyp_context);
+
+	vcpu->context.regs.pc = read_sysreg(elr_el2);
+	vcpu->context.regs.pstate = read_sysreg(spsr_el2);
+
+	__sysreg_save_el1_state(&vcpu->context);
+
+	return ret;
+}
 
 void __hyp_exception(u64 type)
 {
-- 
2.43.0

