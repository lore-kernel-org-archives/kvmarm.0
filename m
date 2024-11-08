Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9325D1C1F18
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104713; cv=none; b=kpIQebGgHdBUTp1nPOtCQUHWJl9Y++jtLrq7Eby8Ece8aHwG51aUrM3TM73rFH870zcHmQ2mLjUyn8fuALLZPy406myniW6xTLBzk+PtJy/ql+vSOPuL4UEjf+yXfIPuYKU2knq0xm/4BYmZtA2siGwJ8pAvCRp7ty+LNi4Nus4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104713; c=relaxed/simple;
	bh=l97TtyWPSYkhzP0COZid2C7uFlZ+YC3k82wYPtkp5No=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P2Lfv/bAexQJuNVn+nV4yHQmyX+k8EKYO+ICy8YlFkqcCkslAPHsiYwZWjEP+AvPlND8bBmQdTSvzCwEhysfZU9u9Nep9aITun9ecqhatxg/+BHLq26QUPwYg+X8xd5bB0ryBKqvHfYDKE/y3ap8nS9HRSqZqoZlsYW9YKBprnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QPcNuI5s; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QPcNuI5s"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CA31FVItCXz0w0Fsijb6KGUMRkn6O33EGqdguQB7pE0=;
	b=QPcNuI5sPcs8BETvGIiHOEWtqQtJ8WuEA+zihhUDJ2bn+af8U+DZg4CIhWyudAqz9PXJFG
	ycxOTEJQmsTtIc/vpiG8gwg1fJEntmeOtCV05R+bvwRkETlxc5LdhrGlB0bEk6oimReKxA
	YXsTMFmXYp3L7Dnm5zELhGFXLHAePJA=
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
Subject: [PATCH 12/15] KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
Date: Fri,  8 Nov 2024 14:24:16 -0800
Message-Id: <20241108222418.1677420-13-oliver.upton@linux.dev>
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

KVM takes ownership of the debug regs if the guest enables the OS lock,
as it needs to use MDSCR_EL1 to mask debug exceptions. Just reload the
vCPU if the guest toggles the OS lock, relying on kvm_vcpu_load_debug()
to update the debug owner and get the right trap configuration in place.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.c         |  9 +--------
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bb2bd722af56..91341fb3405d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1346,6 +1346,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
 void kvm_handle_debug_access(struct kvm_vcpu *vcpu);
+void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val);
 
 #define kvm_vcpu_os_lock_enabled(vcpu)		\
 	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & OSLSR_EL1_OSLK))
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index e131327ad01a..04a62660ca5b 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -275,3 +275,16 @@ void kvm_handle_debug_access(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(vcpu->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED);
 	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
 }
+
+void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (val & OSLAR_EL1_OSLK)
+		__vcpu_sys_reg(vcpu, OSLSR_EL1) |= OSLSR_EL1_OSLK;
+	else
+		__vcpu_sys_reg(vcpu, OSLSR_EL1) &= ~OSLSR_EL1_OSLK;
+
+	preempt_disable();
+	kvm_arch_vcpu_put(vcpu);
+	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	preempt_enable();
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6b0995754aa8..37b3b30f7b1c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -570,17 +570,10 @@ static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	u64 oslsr;
-
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
-	/* Forward the OSLK bit to OSLSR */
-	oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~OSLSR_EL1_OSLK;
-	if (p->regval & OSLAR_EL1_OSLK)
-		oslsr |= OSLSR_EL1_OSLK;
-
-	__vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
+	kvm_debug_handle_oslar(vcpu, p->regval);
 	return true;
 }
 
-- 
2.39.5

