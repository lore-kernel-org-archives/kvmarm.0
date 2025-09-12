Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFDB2561AF
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712206; cv=none; b=n98j54n5ERxjm8be/E8FiNEaJ+WdggljmbO/23zP7mEbl2SKqrZPhbJzoONuebJCoTnkWxIVQh2dgOwdwhXcXszqoetqTAvIviakxWEoIOb5EAEoJ/65pZCuWgCTUvUWHL0WVOfZGklWGFxmrlMHTbxoURQizA52I1sYE1tXnVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712206; c=relaxed/simple;
	bh=snF5jrbrrNgwpM+CxhONsiHW+wQhujpeVzsNgbE0ZJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nJtk6gT8HtqtzQOeWPBvqwAmdSnnZ4xBc0wuqerj9S+8JTwyvCqA7u0nfaiw5pimtiG9MuUBPPqkYCCA7A9A/xIYwMCYwjKFkJyWbBqE9AVQFplaheUFDjpNEeYk7YN+np9ueBCQ0Vq0hq97/K5uiZlWMmvHqMIwwwuK8uH3uso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LCnYkW6L; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LCnYkW6L"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Tpr/BVHaqRfET+AsiGfb6XCdKMX5jTN3mnFFJvaBkQ=;
	b=LCnYkW6LQKPzNzcOeVTpRaya2pFKqSMLq0ScV0vjkc+ThB/KI9MkkbtLQ+QXpjlf0Gzlum
	VEtLCjowhNMsdTybJbbBr4aPHdjzPWDVXMXS9LB2x1C0vBOenJtYMlM9vjZSVM0bVVTs9n
	/SzFRJ7xziXvZZ1tHqrklpjckTnSpYY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 09/11] KVM: arm64: nv: Advertise FEAT_SpecSEI to NV-enabled VMs
Date: Fri, 12 Sep 2025 14:22:56 -0700
Message-Id: <20250912212258.407350-10-oliver.upton@linux.dev>
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

FEAT_SpecSEI is an informational feature describing whether speculative
loads may generate SErrors. Since there are already cases where KVM
reinjects an SError into the VM it is already possible this may happen
due to a speculative load within the VM.

Stop hiding the feature from NV-enabled VMs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index a5e1a3de2742..d3186f656d83 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1529,7 +1529,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 			 ID_AA64MMFR1_EL1_nTLBPA	|
 			 ID_AA64MMFR1_EL1_ETS		|
 			 ID_AA64MMFR1_EL1_XNX		|
-			 ID_AA64MMFR1_EL1_SpecSEI	|
 			 ID_AA64MMFR1_EL1_HAFDBS);
 		/* FEAT_E2H0 implies no VHE */
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
-- 
2.39.5

