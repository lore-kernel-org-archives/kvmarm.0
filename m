Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6204B1DE896
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104699; cv=none; b=T2HFQnPcs0B/taXTABnge+87JbvWeR5ULaXIsNOryO5O92j2BSY7JRvtwNqEYoFag3GDGK8B0HXRjpRy1EsSRnnnXV9LbVMCqkOjNgHW+B0XvNZLrUgc7UHZWVeA9EUVurPODijeW9QjinIUvlCazwuTJON+ayHWe7jzqya5y1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104699; c=relaxed/simple;
	bh=Qq9X9dTGF73Paqz6k4185PdjYDgSq6r5hvI98EIqLDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lLu9y/jIz8Yjk66jJApQOoWIkw22B6k0YhH4BG+H1QCsuHnr7nOMpsMSWzp/qDI9r9JKDcXKdpmqav6wYmV8PEfhroBq4fyK9TyLjQt+iwNjMR0gGwWtu5CQNSP5L+w+GAvZEssYPc5p3rBIOxyaApln2ER4EZuj/10tpeIqnsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ilkykKgx; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ilkykKgx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a3+e7ES3DDU2lSrzZr3o8hLqgPMQQ80GB6EJ5h1tDKo=;
	b=ilkykKgxJ0BPyngR7JvCjdu0YbE8tIYoY8RiJ3aIltcY7Io+WGtk6khcmHrfC7tIrp6kSy
	pGL//nM+njvSo9/h8AmgJPuneXy54faUVJZo3QZOHkJz+aOLOwrvNeT9BmfMcXgPPGWjMG
	a39SkhUrVGzHbk9YrbgSo7CQ8hPH6ac=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 06/15] KVM: arm64: Advance debug_owner state machine for sysreg traps
Date: Fri,  8 Nov 2024 14:24:10 -0800
Message-Id: <20241108222418.1677420-7-oliver.upton@linux.dev>
In-Reply-To: <20241108222418.1677420-1-oliver.upton@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Preserve lazy restore of the breakpoint/watchpoint registers by updating
the debug owner after the first trap, assuming the host isn't using
them.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/debug.c            | 9 +++++++++
 arch/arm64/kvm/sys_regs.c         | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f954b082dc4f..d76e4e44b65b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1352,6 +1352,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
+void kvm_handle_debug_access(struct kvm_vcpu *vcpu);
 
 #define kvm_vcpu_os_lock_enabled(vcpu)		\
 	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & OSLSR_EL1_OSLK))
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index e2798a4eec47..c2bf1b296b14 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -336,3 +336,12 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 			vcpu->arch.debug_owner = VCPU_DEBUG_FREE;
 	}
 }
+
+void kvm_handle_debug_access(struct kvm_vcpu *vcpu)
+{
+	if (kvm_host_owns_debug_regs(vcpu))
+		return;
+
+	WARN_ON_ONCE(vcpu->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED);
+	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 91714639bebf..3632a4b52cc7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -656,6 +656,7 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
+	kvm_handle_debug_access(vcpu);
 	trace_trap_reg(__func__, r->reg, p->is_write, p->regval);
 
 	return true;
@@ -709,6 +710,7 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
+	kvm_handle_debug_access(vcpu);
 	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
-- 
2.39.5

