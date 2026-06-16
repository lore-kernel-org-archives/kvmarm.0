Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3F3BB11B
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 11:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610605; cv=none; b=DKVSQrHjfM2HYTVFrtFK8gf6EL/xT2OQKj6+1193n854IDhiejYZ87rIvqQPjws5ZciwXIJ/SbHvMGLmNca8o0mQNh1WyzsHQ5CaMC2I1M6CRcRlAyUodOyPX/pfw2xAQ+g2aW0IYxYfHZbgYjp11iS5/UTstvj4YWIl1HhiaF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610605; c=relaxed/simple;
	bh=H/oWHDrv5UtGpg4uNjh4Fmos4nGWa+wxts2uoSUKTE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aLfQZmcw/nz1lJatil086TLibdMAsWgU56tv2KQcjRqb0b4Qu95q6ukHqCNlkTTSATkiuOQ8A/sHRT1eWHbqu9MgscQR/9SyWGsSvHeTt7JJ5zjFgVFLMNYi+DKAqDGKfURlLxzhhX/hw6yxxSXme8KUjNrxGEo3gdMCv1zo2C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORx7ci5H; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORx7ci5H"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8423f420455so2094551b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 04:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781610603; x=1782215403; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+B8CgWtXYrJhRkqUat12EDvVB3QBzEo8L7yf27L0qGs=;
        b=ORx7ci5HDgD5RnuTjh2mStPY9+UNgcNeu536/BtiuO+x/p6QuJiwcAw9Z3/yR07t/f
         dXGIRFn1I+FlEttdB91lkqy7nUv+KmNWfh0PYUCSUC9pq4wXqr7c8+YaAu8t4YljA/KZ
         jEJIodmQ0sWkXfPjWO5m2XzhTfFO6C2ykA/rc51BjuPfAXIirfyydkRB17b5fzZn3JTr
         W0+qmy4AcS3q961DBQ/AFyp0tB+kRtZhbGTtcivsmae/yFk1xfa7ZRqBfP45XkC0Q5vI
         WDaUpoedCwokdXVzck1SO7DDgu2mvgdhE1SZ0rHOY3zu9gR1iKKK+GnJSVgIKcRT5PBb
         xGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781610603; x=1782215403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+B8CgWtXYrJhRkqUat12EDvVB3QBzEo8L7yf27L0qGs=;
        b=kY8MTsYlmeYEIZyx70RwpQxcx+YbFo6poAcdpbJUrwTBEx4cV/600YNmSKIXf3IIXj
         B2fFl3qXpRGAJW6Gez3KQK8fJAKIrDlnUZ2SI+Z7REtvSnP6mLIc3aR38dATP8T1p/FB
         n6fgWS+RrrwpAcb6BmakzrN7HUB1JhPQ+bBd1e9IdAkzyoyRvpKmnozJFlk7dmvaznLN
         V7WJjphC6xm/QMW0kma2qKdeOajaZK5eLuFPykfgMBYy10F8/gGGV5yniqd6ACL93QK5
         5lxiu+6kILd5igFyL54p9HsSem+0euZA5l/sd419rZOUkvmbiib3jZOX1j5eod5jDsM0
         hrGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9lGp9cfgtAO2LGRv1v0JNaF9QDsG+oX8M5T5WNlUfg72vKTA4cbCQiuh1cYl4ldwSiOcwAtco=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyiF5RxYozcNFyIQ+SlXzSoIipKYme1pghYduZ2L9fn5iPqcA1
	qfdsWd4EJL/IxxIQHFCR8+S0llPXh5XgQwf5/5wkitq2sbZLO1hd/VVi
X-Gm-Gg: Acq92OFmhcakKCvrCphiaN2bWDVSqJrXfNrFN4pt3/H+d88SprA3DVW7BngVdWDylVB
	xczFD2CifYBnI1d2qUOtgnY3wr4NSh5dncf6GSrzB9UHMIEuyYDYO/U0j0jNjoKiteK2UdFjNkz
	CFRtKKJ0iTI1AVNAIeSGgM4rApxn9CwwPy2k0Bw6gkJT9fvr2M1OjQYc6eqrCXVludfPrq08VBD
	V7Ts+UQZ3M3XHZvxAlnWvpWKgvFKq2qetIc2CyF8rqxzgVtglWx4doBWWSzpSQLVNmTijJLnI2K
	C4MQYhqcLoOUr6PYZGarg8EOr+mk1vwl/Rq999XRyIYxMd+DESD5pwNt+L7un3FQOI+XeRKrWBs
	IcgiLfcEe5cEoIB3arKd1ShYR7bhSmLHzI1cZWihYm4pDRxai7+kQE0DCxD+7ZyVp8epkK+GQ+P
	hbGLQyAPYiTOEk4bk6XQDu38SQ8bFOxiZSuQUigDnADcL9WVP1VTz/7Ppp7Zuebkls/c5NZc5nS
	TCYQKfyIfYP
X-Received: by 2002:a05:6a00:1309:b0:842:6fec:1296 with SMTP id d2e1a72fcca58-844e193a3f7mr15072267b3a.4.1781610602893;
        Tue, 16 Jun 2026 04:50:02 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ac9df57sm13255838b3a.7.2026.06.16.04.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 04:50:02 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Zhong Wang <wangzhong.c0ss4ck@bytedance.com>,
	Xuanqing Shi <shixuanqing.11@bytedance.com>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH] KVM: arm64: nv: Translate vEL2 PSTATE to EL1 in kvm_hyp_handle_mops()
Date: Tue, 16 Jun 2026 19:49:44 +0800
Message-ID: <20260616114943.81188-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a nested virtualisation guest is running its virtual EL2 (vEL2),
fixup_guest_exit() rewrites vcpu_cpsr() to the guest's virtual exception
level: a hardware PSTATE.M of EL1{t,h} is presented as EL2{t,h}. The
hardware, however, executes vEL2 at EL1.

kvm_hyp_handle_mops() runs on the fast guest re-entry path, where it
clears the single-step bit and restores SPSR_EL2 directly from
vcpu_cpsr():

	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);

For a guest hypervisor this writes the vEL2 view (PSTATE.M == EL2h) into
the hardware SPSR_EL2 without translating it back. The fast path re-enters
the guest via __guest_enter()/ERET without going through
__sysreg_restore_el2_return_state(), so neither to_hw_pstate() nor the
"return to a less privileged mode" safety check there (which would set
PSR_IL_BIT) is applied. The ERET therefore restores PSTATE.M = EL2h and
re-enters the guest at the real EL2 with a guest-controlled ELR, escaping
stage-2 and the guest/host boundary.

This is reachable on a kernel with FEAT_MOPS running a KVM nested guest
(kvm-arm.mode=nested): KVM sets HCRX_EL2.MCE2, which the guest hypervisor
cannot clear for its own context (is_nested_ctxt() is false), so a vEL2
MOPS exception is taken to the host and dispatched to kvm_hyp_handle_mops()
with VCPU_IN_HYP_CONTEXT set.

Translate EL2{t,h} back to EL1{t,h} before writing SPSR_EL2, mirroring
kvm_hyp_handle_eret(). For non-nested guests vcpu_cpsr() never holds an
EL2 mode, so the translation is a no-op and behaviour is unchanged.

Fixes: 2de451a329cf ("KVM: arm64: Add handler for MOPS exceptions")
Assisted-by: Claude:claude-opus-4-8
Reported-by: Zhong Wang <wangzhong.c0ss4ck@bytedance.com>
Reported-by: Xuanqing Shi <shixuanqing.11@bytedance.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e9b36a3b27bbc..a6b7963ddbf0b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -448,6 +448,8 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	u64 spsr, mode;
+
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	arm64_mops_reset_regs(vcpu_gp_regs(vcpu), vcpu->arch.fault.esr_el2);
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
@@ -457,7 +459,26 @@ static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * instruction.
 	 */
 	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
-	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+
+	/*
+	 * For a guest hypervisor, vcpu_cpsr() holds the vEL2 view
+	 * (PSTATE.M == EL2h) installed by fixup_guest_exit(), but vEL2
+	 * runs at EL1. Translate it back before restoring SPSR_EL2, as in
+	 * kvm_hyp_handle_eret().
+	 */
+	spsr = *vcpu_cpsr(vcpu);
+	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
+	switch (mode) {
+	case PSR_MODE_EL2t:
+		mode = PSR_MODE_EL1t;
+		break;
+	case PSR_MODE_EL2h:
+		mode = PSR_MODE_EL1h;
+		break;
+	}
+	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
+
+	write_sysreg_el2(spsr, SYS_SPSR);
 
 	return true;
 }
-- 
2.43.0

