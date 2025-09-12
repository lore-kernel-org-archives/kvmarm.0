Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58DA261B93
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712208; cv=none; b=q5f04xeEghSuQnqumjUq2czIDFRTmZ1FFT2XMgK1RseEeifcsdrv2lSSXuAKKC2wlQqhOUnVoJ3L0Dr/gryAaAs8CaT6N2V9x4jVJdzHYiVGIndJ953KwZBytwwYhfRR32CbBewJu9uIcckOQbKTO3YesrW+Yupi4TLm/gKnm9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712208; c=relaxed/simple;
	bh=duOAsE1F0we66rNUjgKsYN+nYhTLU/RBitDpT11D05Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uNPJe4mrn2s+DwnbqgN3tcgMeOyHPIaHZOC4rESaaddxohZZOOIuTjCcl2IVDvmN9gix1cwye4uuL717AI348a5GNZpTPy2W1s3S8FFMr8shSmkaaH2D2Mvz42PIyYKE4+nEBZiGHAYaH/UNyG0/cOS6XmWDoWUbp0zjzM0DCMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=udyR42HG; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="udyR42HG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0HJI9Hd+y91khFcUBdKPT0+mMzf9U2VpWNGGKiEeFuo=;
	b=udyR42HGoiVdwpLKCkh25nI5Lkur0K/I6QM4YmVxEz+UWQgXoY3eVDbh/JDlyDQU5kVaOp
	+/ly4nzb9gT2RPaI36UhI4ceOC2L69wR/Yb4fAESgfblYefCm7xLDSqYtV+bJk/G8pNy4X
	gnlBrxC//dpzb6R325w8eL803BsonhI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 10/11] KVM: arm64: nv: Advertise FEAT_TIDCP1 to NV-enabled VMs
Date: Fri, 12 Sep 2025 14:22:57 -0700
Message-Id: <20250912212258.407350-11-oliver.upton@linux.dev>
In-Reply-To: <20250912212258.407350-1-oliver.upton@linux.dev>
References: <20250912212258.407350-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

While KVM does not expose IMPDEF features to VMs, FEAT_TIDCP1 is an
architecturally-defined EL1 trap of a particular sysreg encoding range.
Furthermore, KVM already advertises this feature to non-NV VMs.

As there is no interaction with EL2 traps, expose the feature.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d3186f656d83..65b5fbb88510 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1525,7 +1525,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 
 	case SYS_ID_AA64MMFR1_EL1:
 		val &= ~(ID_AA64MMFR1_EL1_CMOW		|
-			 ID_AA64MMFR1_EL1_TIDCP1	|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
 			 ID_AA64MMFR1_EL1_ETS		|
 			 ID_AA64MMFR1_EL1_XNX		|
-- 
2.39.5

