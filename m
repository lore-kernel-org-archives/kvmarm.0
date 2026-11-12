Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794470370;
	b=LhazpkDvI6txk7jUaudFAPqPBH03yGRT33vR4qwiX2VI10RzJtwpxvBYQxNpFTxNf1qn
	 4eAjMATPefW4e7EzuJmytihRHT9x4JY3M54T3SbzV+WKXBxj64rLf+IqsJCDyw4t0V/pi
	 mGLHRbZojg31Hcf8CWDeDes84koiZ8N46S2zNZAqDgAncd0Cnq+HwgM0ED6CSTEIo/CKP
	 rc8BxJpN43sWUeZTChnHBZEEW2vhxbPGb7Hsftl0/bPTfKvPKctyS3og8XyqUwn8DFdGC
	 +9ob7QD+vIVv6ugB2wGdSthHOV1b/Clguox/IPh2fjf94XVhbwlXGfVjICUXlgmAgUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470370;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zAWSlv59a8MCO7BiIv0PjshhyKJmXxJ12N3fAjhXUPU=;
	b=dSo9c8AVgzU+D4+BekHcGgt666AoPh6GzUZo7VU55fP7CYOIq+PZr5JYWc3isvmC011i
	 HGxJdJ/Ld7mQad/BJuSG4f9PsR5BkcXkGXajsYpsLtFMkQUUgz2FRPMjYf265qjFw3NQX
	 03GgxHqxYIkjuLae1xUbrHM822fGrCN+y/R6rEgXTv+HF2GtmxRKpadej/O/6TpsNVLOU
	 cUdNygXZP4hS4kKpKXTOMqO+VuZ953e4bojZss3jGKl8weitawIPMmUkP25GRf+L0f+M2
	 9ZIAhEgSBSEIwViHbj9J8+rdWOteKYiK/HgVZ20FqJ1vIwRVPSwWoBpdy9nORHSyshw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="UxBCu/ua";
	arc=none smtp.remote-ip=91.218.175.151
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE21B606A32D
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 07:59:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE21B606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UxBCu/ua
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=cISyCbOfugjzFqMvt9U+R6HEQpkQoIcxPv/Uh007S2o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794470367; v=1; x=1795075167;
 b=UxBCu/uavHXkiMLejK3qL+E9sf/QSXkNEY8Zq8CMa2Eja03HwffsmHEkRHItDJ/8v00WXw8k
 EZe9SI6z8GOYXE3JDHku9Rmh5eEp3GC6zbAULtrQ9syE2aIyQQ6ibIj84fZrFKnbFKAWUp9lbwB
 +a1PtyDasBfHjBGqp3T5nEF0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 80bbba1496a8ace9;
	Thu, 12 Nov 2026 07:59:27 +0000
X-Mizu-Trace-ID: 80bbba1496a8ace9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2] KVM: arm64: Sync a pVM's control state before CPU_ON reads its endianness
Date: Thu, 12 Nov 2026 07:59:23 +0000
Message-ID: <20261112075923.3018139-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM handles a protected guest's PSCI CPU_ON at EL2 before the guest's
EL1 sysregs are saved, so kvm_vcpu_is_be() reads a stale SCTLR_EL1. A
guest that changes SCTLR_EL1.EE and calls CPU_ON before its next exit
to the host starts the target vCPU with the old endianness.

Have CPU_ON sync the caller's PC, PSTATE, VBAR_EL1 and SCTLR_EL1 before
reading its endianness, through a helper factored out of
inject_sync64(), so that both handlers sync the same state.

Fixes: 9d4ec80be2eb4 ("KVM: arm64: Handle PSCI calls for protected VMs at EL2")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes in v2:
    - Factor inject_sync64()'s sync into a helper and call it from CPU_ON,
      as Marc suggested. Named pkvm_sync_vcpu_ctrl_state() rather than
      ..._before_exception(), since CPU_ON injects no exception.
    - Subject and message reworded to match.
    
    v1: https://lore.kernel.org/r/20261111082746.1064567-1-fuad.tabba@linux.dev

 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c         |  2 ++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c     | 16 ++++++++++------
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 0261b2bc681f7..5c68c9184bda6 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -133,6 +133,7 @@ bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
 void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
+void pkvm_sync_vcpu_ctrl_state(struct kvm_vcpu *vcpu);
 
 int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *vm, unsigned long mpidr);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fc0475f0877d1..eedc1dd81ee56 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1321,6 +1321,8 @@ static bool pvm_psci_vcpu_on(struct pkvm_hyp_vcpu *hyp_vcpu)
 		goto error;
 	}
 
+	pkvm_sync_vcpu_ctrl_state(&hyp_vcpu->vcpu);
+
 	reset_state = &target->vcpu.arch.reset_state;
 	WRITE_ONCE(reset_state->pc, smccc_get_arg2(&hyp_vcpu->vcpu));
 	WRITE_ONCE(reset_state->r0, smccc_get_arg3(&hyp_vcpu->vcpu));
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 32e82653ebf7e..be785eec2ec96 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -254,17 +254,21 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	}
 }
 
-static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
+/*
+ * pKVM handles some exits at EL2 before it saves the guest's EL1 state, so
+ * sync the copies that exception injection and PSCI CPU_ON read.
+ */
+void pkvm_sync_vcpu_ctrl_state(struct kvm_vcpu *vcpu)
 {
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
-
-	/*
-	 * Sync VBAR_EL1 and SCTLR_EL1, both read by enter_exception64(),
-	 * as pKVM handles traps before sysregs are resync'ed.
-	 */
 	__vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
 	__vcpu_assign_sys_reg(vcpu, SCTLR_EL1, read_sysreg_el1(SYS_SCTLR));
+}
+
+static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
+{
+	pkvm_sync_vcpu_ctrl_state(vcpu);
 
 	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
 

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.47.3

