Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A243921CD
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240129; cv=none; b=RIzqyCvCWNeQE1rvxy35BgIAKRg2HoRrO1krPC4LhymJPPUEyjZL/0SIc8Yu5+sidJDuA2HSNgO/8WeZICiqTNKScbimwUgBFri/fBtb7M+pYKWAgZB3Wu6RoBSGG9acOW3ENM9tDLGcr6W/u1F6xXbBVafQLMPRVjVutgtsbuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240129; c=relaxed/simple;
	bh=L9EbqIoXi4lqgtbOixu3i8NrKxi9s2ptBYnh9f5vtAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkHBpxQCNx4QDLzmTxHwM0TlwDB6/v2lqqRun8f+c83HWvORIRrmZMAwYqo6Bw2SBuA2KlB98qlYEHcIlNp+EPb3iwH751rrxHw9qfYEWuBxmhLdM9c40kBED0CLHmUlovZzBgeJ6viSQPGLSxtM0WSN7MeQFi2N3OUnh7qhJSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qe2KoZCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qe2KoZCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9029A1F00ADB;
	Tue, 23 Jun 2026 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240128;
	bh=uFsoeteNkL3H+lvIgeRxBhDFR2gGdf02bV1mVkRZEmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qe2KoZCbvRI2nyctF+uTUIak0ja8vnA3mI4YELMomKqbBX2qK5gxswZBnZXyMJyln
	 KYojzmbnqier8GH4lDPbTOvmDJsyD2h9/WJFzVGmzb+4mcphcqPwZ7xbLxQUU1l1bx
	 nzOYG4+aTufY1d+vqBCI1uRCJawAjAWJlTpWDTUcG7rAk96OU2rp4htDhcjRtWS1Ms
	 r+5c37NQKIZmkhpFKoHhee61RGLFp1khvw4V8TLHSc406PzOefO5rnQBha63g+KFsh
	 i+MewHJ6RL1EZagg5636i+ESRx6R/XvZ5Y9FoGM7LaUpjV8uxuK2G6qME2qiPYDnMA
	 m1E29kJtIfCvA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 16/22] KVM: arm64: nv: Expose FEAT_HAFDBS
Date: Tue, 23 Jun 2026 11:41:55 -0700
Message-ID: <20260623184201.1518871-17-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything is in place now to support hardware dirty state management.
Flip the corresponding bit and advertise the feature to the guest.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d128003ae7a..2408d604a1e1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1790,7 +1790,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
 			val &= ~ID_AA64MMFR1_EL1_VH;
 
-		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);
 		break;
 
 	case SYS_ID_AA64MMFR2_EL1:
-- 
2.47.3

