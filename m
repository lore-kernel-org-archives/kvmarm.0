Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9334821E097
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712203; cv=none; b=k6SdO4aLnsg4G+IO/i+3O+cvMX/YeN07KJ2HccGXlV3FUfUbjRWhgJcozAKsEj+GvUrUnJmGvyTmPRrnUAxAMNrrIrEO8gJv83FoVtO5BJEhdsPcTZu3T08PyfrFJuNF+bRjrl74ki1K+F3EDwYEQmHKJ0nVmgeZzQl5lxqjFPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712203; c=relaxed/simple;
	bh=CI8HVvjQgC9qbEImyyGD4jvrFfUwJ1+3oqonkF+Hijw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fxV5eNkk4i4nVgcD/Sqhp3WGgCjNEW4YPylyj5s2mJWwzvSv08nn7HxFinKnEmhplLvsjrrRQmRP5zPvWLpcJ7OadK/2bvVHERu9OaTGaEHuuFlsJMrhbw5gHJyRGjsBnjSVv4bsScxI7ZO/Ea6uaUgki4KERs8FeqsJqbIH6lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AGFRVLM2; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AGFRVLM2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UExjXWTPdTOUBCzKCbaCgjGjrdA1X8/a+8jBFVKm5io=;
	b=AGFRVLM2HUtR4Mdeabjjz3c/sQNUTyWPl2ijWOhpyuQ4/E1uPio0RiFwS10El3Jkdp1Or8
	/03rNRA3i+G7eqkcelIkTuRQQB1ngXEv4F9A22Sa+1wO9hQ97JA7ly+1+TtGwdo2L9aqCj
	Y/x7hs7xdPYIJxAJLWuIFH1/i86Xdik=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 07/11] KVM: arm64: nv: Exclude guest's TWED configuration when TWE isn't set
Date: Fri, 12 Sep 2025 14:22:54 -0700
Message-Id: <20250912212258.407350-8-oliver.upton@linux.dev>
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

Ignore the guest hypervisor's configured TWE delay if it hasn't actually
requested WFE traps. Otherwise, OR'ing these fields into the effective
HCR when the guest sets TWE is safe as KVM doesn't use FEAT_TWED and
leaves the fields initialized to 0.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 0998ad4a2552..9984c492305a 100644
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
+			guest_hcr &= ~(HCR_EL2_TWEDEn | HCR_EL2_TWEDEL);
 	}
 
 	BUG_ON(host_data_test_flag(VCPU_IN_HYP_CONTEXT) &&
-- 
2.39.5

