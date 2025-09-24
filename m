Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E0A11185
	for <kvmarm@lists.linux.dev>; Wed, 24 Sep 2025 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758757926; cv=none; b=raf0reub1V8bgkoOMYm/gH6uGv0MLTAtyDN1T4JOvDaWwtacKyq0H8rd9r/WlufeJmdyr+xzD9bDH1FfIYO1YKtjRpn6tntJkKKxp2LvuZI3FEGuvA/4dh/8L83UBLXmBIhmKVTJ37AbuFNSoDPrl9GtryinSAzuh34wDZ2nN6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758757926; c=relaxed/simple;
	bh=UuH2dxbcrZpj0U8pUlEUVux7rU+rn4Ok0XV8Q2Yx3IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcwQG71WMnoe4JUW395H4t6zc12HguE2cmOvc/DRAxfS3+qeO859inq9YXMI9U4Jn3Neg8XNKVe4mNREYzYpHIEwIQfyfLYzOQpPVVmWv8VSuPiVxGPE5B2iOsCM9oW0B8ooL4+/Ws7mayRXM9EUi1uJd5DSuJHAMRnJIl7PU88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LHReXvDI; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LHReXvDI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758757922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DJQisQIHzulId77lgcoT2La+H3oTwYiX+TcH8Jux0U=;
	b=LHReXvDIQoCvFNF1owDeF4uvPiK6IbqVOW/fs7RObxfxAWCMBKiBYeyYIBh0bqlZJNhJiH
	aIXJIaMmSVcjzSDES635e96jb22UqmSLTmkoeW8Sm2dG0boVy1wf/s4o5HVsqBdavHdr7M
	iKR/dmv2HVtswH95GyrUgJ7WI+2u+zo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: nv: Use FGT write trap of MDSCR_EL1 when available
Date: Wed, 24 Sep 2025 16:51:50 -0700
Message-ID: <20250924235150.617451-3-oliver.upton@linux.dev>
In-Reply-To: <20250924235150.617451-1-oliver.upton@linux.dev>
References: <20250924235150.617451-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Marc reports that the performance of running an L3 guest has regressed
by 60% as a result of setting MDCR_EL2.TDA to hide bad architecture.
That's of course terrible for the single user of recursive NV ;-)

While there's nothing to be done on non-FGT systems, take advantage of
the precise write trap of MDSCR_EL1 and leave the rest of the debug
registers untrapped.

Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/config.c | 10 +++++++++-
 arch/arm64/kvm/nested.c |  9 ++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index b1cf7660efe1..24bb3f36e9d5 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1489,6 +1489,14 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
 }
 
+static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGWTR_EL2);
+
+	if (is_hyp_ctxt(vcpu))
+		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= HDFGWTR_EL2_MDSCR_EL1;
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1498,7 +1506,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_hfgwtr(vcpu);
 	__compute_fgt(vcpu, HFGITR_EL2);
 	__compute_fgt(vcpu, HDFGRTR_EL2);
-	__compute_fgt(vcpu, HDFGWTR_EL2);
+	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d828c60c6300..5009bfe849ff 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1830,13 +1830,16 @@ void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
 	u64 guest_mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
 
+	if (is_nested_ctxt(vcpu))
+		vcpu->arch.mdcr_el2 |= (guest_mdcr & NV_MDCR_GUEST_INCLUDE);
 	/*
 	 * In yet another example where FEAT_NV2 is fscking broken, accesses
 	 * to MDSCR_EL1 are redirected to the VNCR despite having an effect
 	 * at EL2. Use a big hammer to apply sanity.
+	 *
+	 * Unless of course we have FEAT_FGT, in which case we can precisely
+	 * trap MDSCR_EL1.
 	 */
-	if (is_hyp_ctxt(vcpu))
+	else if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
-	else
-		vcpu->arch.mdcr_el2 |= (guest_mdcr & NV_MDCR_GUEST_INCLUDE);
 }
-- 
2.47.3

