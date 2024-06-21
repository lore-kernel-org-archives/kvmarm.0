Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1801216F0F9
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 22:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009665; cv=none; b=MrA2Pvr6xe+DpA3VgR3LnqsdmD5ecdFsmpY8ttPw2t942n+TrAHyDJEk39vDCYlp/kvpgpXYzLLqF+fDFmUp9gMjX34Bg7aGsUyPgyTNhYIvCqvqSx9uzfPbqTypaaW1+3Yjj+eyVzYcGyZojArJvSYFIY885WDOUI98nKPQjto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009665; c=relaxed/simple;
	bh=t24dQDkS/RraAb5M8thD/yvwGzrVtvv2HInGY8vPPVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SZ6G18U1ULwcBmVdfNKVCLB5lMC6uFZNPGdZFwk8oOB6ueeo5I9k8Yx8mx5AnVIkuWXsrhQQ9RilQBCA+qtAfW2CR7kVdph0h+O1MXA+FDeXiyCEzzjOOUBip6UnHP+ZW5/mCcnsSal/R8kfzY2kvygKuUiwtYmggjAjWnrH+jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OypKgA6p; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OypKgA6p"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719009661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k44kEMr3JDkUE7H0F2GKzTt2reCTKR8SGFNS6J7QYh0=;
	b=OypKgA6pg+AYWFutruWuHNsyB7mVBYbtXRCyL2/w82/4ka3rs7Z4sqIWtkPnzWD872zkKF
	dPkzvLTpc4vDfLK2foEVYhCmGCdq6egZ/9/bKSCRuAT15F/bPBMl0B+klA1ehVyYRqz94X
	LNjKAAq9GaCz0gk6qwu5PNQNeeRtiKE=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: nv: Unfudge ID_AA64PFR0_EL1 masking
Date: Fri, 21 Jun 2024 22:40:44 +0000
Message-ID: <20240621224044.2465901-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Marc reports that L1 VMs aren't booting with the NV series applied to
today's kvmarm/next. After bisecting the issue, it appears that
44241f34fac9 ("KVM: arm64: nv: Use accessors for modifying ID
registers") is to blame.

Poking around at the issue a bit further, it'd appear that the value for
ID_AA64PFR0_EL1 is complete garbage, as 'val' still contains the value
we set ID_AA64ISAR1_EL1 to.

Fix the read-modify-write pattern to actually use ID_AA64PFR0_EL1 as the
starting point. Excuse me as I return to my shame cube.

Reported-by: Marc Zyngier <maz@kernel.org>
Fixes: 44241f34fac9 ("KVM: arm64: nv: Use accessors for modifying ID registers")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f02089d98445..96029a95d106 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -815,7 +815,7 @@ static void limit_nv_id_regs(struct kvm *kvm)
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1, val);
 
 	/* No AMU, MPAM, S-EL2, or RAS */
-	kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1);
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1);
 	val &= ~(GENMASK_ULL(55, 52)	|
 		 NV_FTR(PFR0, AMU)	|
 		 NV_FTR(PFR0, MPAM)	|

base-commit: a9e3d7734719d5b58f260edc15dce3ea4dc3d313
-- 
2.45.2.741.gdbec12cfda-goog

