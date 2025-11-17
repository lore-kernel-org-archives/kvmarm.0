Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926E731354C
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419410; cv=none; b=qLnCO7PbKnyAkEJuSWjFvbLLf/0Jgj8Meu0QHk4c3LpLZiCVP71GKl+3ygchO+UTmTXrPOm2HUX1lKBMo0QD2msDl3Hj/gtwpXN1HmXDMhPsbSvKPnkyBILUGUA1pf47dgMcp/sPJkYtoZhyRQOrTLDe2Z6oIRaQRIgaPKTJQvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419410; c=relaxed/simple;
	bh=FRqgu+EFqz02ePtaknEcKDASxY5EBt03ZV5dBoVUqX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ma5tlqWF3yb2WDNtwQVZrzoLRD3TaS/t8eTuGH50Lk8463cYFOatnZGx+sj7t6wxaB5+VkbQp/CGnF8oUcXvZ7zr+VqV7UkluDKe7YB2yKTyma01YJEPRzca0oFJf8ouM11fHImbkIQA6X+EX2Yv7GzIt61ST7hm2ihYjluOho0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awDBlPWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awDBlPWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9D5C4AF0C;
	Mon, 17 Nov 2025 22:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419410;
	bh=FRqgu+EFqz02ePtaknEcKDASxY5EBt03ZV5dBoVUqX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awDBlPWF5OHZxezO/ax7bC2c3WnoBNSy4Us8eIfBirweoqazdVtFDDZ5gHRFBYiXZ
	 NPREOFFN90zGlTqs3FlSpumMZxhX/nc3EEOg3ArB0+RjXyVTsZH8gnlNXf/TqtLu0u
	 7PYFN9wOiHFbDNiefoA1nCjSLWQVes+3NyIMF83mpelIlkmAR/K2gsmlgWU1q46RLG
	 qDsgDHj0jZrOigztImDPvY2EvT38Yq49MhM0S1D+dPdfjYhcIVbcLpjRQ/5cT/2xyF
	 J3Gxlk86Dq55EGW9icMEukRZo80YNmOOCcD0QoDnmFBOWjTKaD8Qe/hac/S6FYQZLl
	 F2ss4aLIHbHNQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 05/14] KVM: arm64: nv: Advertise support for FEAT_XNX
Date: Mon, 17 Nov 2025 14:43:16 -0800
Message-ID: <20251117224325.2431848-6-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything is in place to support FEAT_XNX, advertise support.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 92b2a69f0b89..08839a320a45 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1559,7 +1559,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		val &= ~(ID_AA64MMFR1_EL1_CMOW		|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
 			 ID_AA64MMFR1_EL1_ETS		|
-			 ID_AA64MMFR1_EL1_XNX		|
 			 ID_AA64MMFR1_EL1_HAFDBS);
 		/* FEAT_E2H0 implies no VHE */
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
-- 
2.47.3

