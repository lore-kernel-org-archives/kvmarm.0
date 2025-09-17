Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945861E4BE
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 20:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141099; cv=none; b=O0YObqlzU98jBYtrbKiFFCdUCmNvgT0AtDD32eR9bw4BaZ3RCTbEYX3BMRG5GEUsDh0Pm7KEfnt0bZbBZnuLxRhziZgwLTf0XBiY+xWW0+BEBWvdTVYXDckKs/Ouo1zZDAYsoiLfNU1uv+oznWAr27QgOc6tcgh+pbwje28qT1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141099; c=relaxed/simple;
	bh=LpmH39RoEslpwA/76eYd+VavgZkoHi5APgdX4LLMyEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCdAkS42FgdUhgIb30nckYdEFLR8Bb20+AJO5OkGJpImutDCqt8fRfM/vwUUCR/mJz7Zv25zTmhljKgfDNwjor0RqTiF4jYh6Q2Wu2HCB0v/ENgtpj9P5dR+ByXHQsNDScU8nHBQpHw+ue8/Co346CW9ecY0tBxDuyS6DCa8Dg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bqwutOh0; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bqwutOh0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758141095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kh1K612vG1ILN+2sDQkFg801+cTFqnMDbVNEZiDE4Mc=;
	b=bqwutOh0XcAwVhMMApwLV9BWE/vpse8yICDuBdwrsPSSLJavbQyObWVc+pDnR9teihdbQu
	6+8/YTa4nioDE8/kSbdLrx607qG1jGi5dHAaLv91xEy69Xsy7YA9lg2ylFTDkM2Gw4gMii
	tBqN1B8ReSu1uC2rKw2VidL8uys90c4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: nv: Trap debug registers when in hyp context
Date: Wed, 17 Sep 2025 13:31:24 -0700
Message-ID: <20250917203125.283116-2-oliver.upton@linux.dev>
In-Reply-To: <20250917203125.283116-1-oliver.upton@linux.dev>
References: <20250917203125.283116-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In case you haven't realized it yet, the architecture is _slightly_
broken in the context of nested virt. Here we have another example of
FEAT_NV2 redirecting a sysreg (MDSCR_EL1) to memory that actually
affects execution at vEL2.

Fortunately, MDCR_EL2.TDA provides the necessary traps to hide this
mess at the expense of unnecessarily trapping the breakpoint/watchpoint
registers. Yes, FEAT_FGT gives us a precise trap but let's just opt for
obvious correctness to start.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/debug.c              |  3 +++
 arch/arm64/kvm/nested.c             | 11 +++++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 7fd76f41c296..cd3ab06abdca 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -83,6 +83,8 @@ extern void check_nested_vcpu_requests(struct kvm_vcpu *vcpu);
 extern void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu);
 extern void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu);
 
+extern void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu);
+
 struct kvm_s2_trans {
 	phys_addr_t output;
 	unsigned long block_size;
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 381382c19fe4..fc275335c0ee 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -56,6 +56,9 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	if (!kvm_guest_owns_debug_regs(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 
+	if (vcpu_has_nv(vcpu))
+		kvm_nested_setup_mdcr_el2(vcpu);
+
 	/* Write MDCR_EL2 directly if we're already at EL2 */
 	if (has_vhe())
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 77db81bae86f..9559c64e7e0c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1796,3 +1796,14 @@ void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
 		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
 }
+
+void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * In yet another example where FEAT_NV2 is fscking broken, accesses
+	 * to MDSCR_EL1 are redirected to the VNCR despite having an effect
+	 * at EL2. Use a big hammer to apply sanity.
+	 */
+	if (is_hyp_ctxt(vcpu))
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
+}
-- 
2.47.3

