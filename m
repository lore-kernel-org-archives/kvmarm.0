Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63DC18A6B2
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 11:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736162626; cv=none; b=MCQJxaQzEwGuDaQyX7rFU/OXjH6FLkQmX4pl1lu1vr0byqz8d7r31m34RDH4Yvxl0oA5PFEYINABp681uYt2mtAFjcg5s6pp/eaClQUIdljpK4X8qr8+E2llS8SPMuI/x+dBsXKBdAs8g8fy6RZTTUEtqE6SsfXjfuSlnEU99OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736162626; c=relaxed/simple;
	bh=MrHim05fZmgSO1OXN0/eeLf95HfOSjS2kDC1nnwNoMg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LjimTtzoiSWSd3N408JEbP3d5awKV5p6lg1ypT44m4xN8OOXpce2CqoPRbpc6c1pnyco0h2i5glo7hRHWEwQ0klrIRRBslZJpOb4VVoieskJJ4E0+ZpPnwUP/U5TYwdbBKdZgbMBMSK1IaR3fVR4K2Rh2FKbE3mhKdwvAlV/kLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E87ED1476;
	Mon,  6 Jan 2025 03:24:10 -0800 (PST)
Received: from login2.euhpc.arm.com (login2.euhpc.arm.com [10.6.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CFE633F59E;
	Mon,  6 Jan 2025 03:23:41 -0800 (PST)
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev,
	maz@kernel.org,
	joey.gouly@arm.com
Subject: [PATCH] KVM: arm64: Fix FEAT_MOPS in pKVM
Date: Mon,  6 Jan 2025 11:23:29 +0000
Message-Id: <20250106112329.64013-1-vladimir.murzin@arm.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flush HCRX_EL2 when switching between the host and the guests.

Fixes: 84de212d739e ("KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6aa0b13d86..d9a41ddc63 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -109,6 +109,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
 						 (HCR_TWI | HCR_TWE);
+	hyp_vcpu->vcpu.arch.hcrx_el2    = host_vcpu->arch.hcrx_el2;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
-- 
2.24.0

