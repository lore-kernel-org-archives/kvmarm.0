Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5D023816C
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402183; cv=none; b=DelUtgaPEPzE6IkFOJmacuNa/fg6RreQv6A6fQ8B5uR5ley9CREBu4fQPhMHd8xbiOTAJX7kPUrxXjc5tAyDrbvlMUejfgR9l7hfWSmZ/gaBMcYCVHT1PCVOwrR82AFWUd+YU49qjfZ62zIs7vF08VVY0B1A7yZXTAuKQigjWu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402183; c=relaxed/simple;
	bh=sDjq4b6RUDNx5PxefChkphpWI4opbuKhZaYVauVO2Aw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rhNOhQ9PSt/TWsDwuQoz5h7ynY7pHAiaIpVlhw3qKtAE89/r3VOtKAIxUG2g+rqEuZxjMFJBCOy0+KAzxpHQjEWvnzYDp3te+7FfHNFmfLxwO+cnLUToWSI1IFF2WzBhhFopQhkSjpgGR8/7Z47M4t8xgZ04cLXL3liiKz8NrRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mHXUoeS5; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mHXUoeS5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757402174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=58/WQwUKjO1Bhr+jt1G0I0MHn6q79XTAHx7VecDSibk=;
	b=mHXUoeS5c8kh0MRoVsCo73XuBh/ukOynhMKdnlboO6eirIRjE//yDbxh7bkSPvVOVyRM0s
	EvaxCygrQDadcRNycvYwNjVcXJCZ43uRZ8U11CwQa1cWCx8ESU/5UiOGs4hs+Rt/bl5CrE
	7BFszsLpApAvQPmuH1/uyhKOBH8Ywyk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: nv: Exclude guest's TWED configuration when TWE isn't set
Date: Tue,  9 Sep 2025 00:16:02 -0700
Message-Id: <20250909071602.294783-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM blindly OR's the guest values for TWEDEL and TWEDEn into the
programmed value even if the guest has WFE traps disabled. Exclude these
fields from the final value when TWE isn't set to avoid potentially
delaying a trap desired by the host.

Note that KVM doesn't use FEAT_TWED currently so there's no need to
empty out these fields the other way around (i.e. host TWE=0, guest
TWE=1).

Fixes: 04ab519bb86d ("KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 0998ad4a2552..e4955b49c0d2 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -95,6 +95,13 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 			/* Force NV2 in case the guest is forgetful... */
 			guest_hcr |= HCR_NV2;
 		}
+
+		/*
+		 * Exclude the guest's TWED configuration if it hasn't set TWE
+		 * to avoid potentially delaying traps for the host.
+		 */
+		if (!(guest_hcr & HCR_TWE))
+			guest_hcr &= (HCR_EL2_TWEDEn | HCR_EL2_TWEDEL);
 	}
 
 	BUG_ON(host_data_test_flag(VCPU_IN_HYP_CONTEXT) &&

base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.39.5

