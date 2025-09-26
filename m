Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CD51D6AA
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 22:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758926580; cv=none; b=dsvz5vuCgmSN8GcsFDoAjlPUElizXdVjJDWAaA/kusKTIGQlI1BCKNc+sQ4CbfTIodGTYEHH2wYaLDa7KVnCdw9zHhSlGfr9fOAJYHySOKV1cCCFjb7ng3F6We4fXPG3Woo1h2GjRdztGz0AQ9LV6dnmyhqkyTSyTxqQVlIn514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758926580; c=relaxed/simple;
	bh=NlvP7l42gOtXKHpbiYPX9byye2HL/yCr2dTdDZrru/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s4Kp7HIUXGMdxkdj+Pxt6TKbMc/JMFUAFDSTYU2u7Wj5rolA7P3yFRKGr9i2Cr0Fq5W9qOqyoFLS4rCIEvD4F7l2EvDnLDvDYpFfsTJGEODlFpowUahZZ7EFhxXVtTSXApTFFDiCeodbL57CSD+PgicEkrrJxO2JNKkyLzMY7lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LpqCHQ+d; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LpqCHQ+d"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758926575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2pUV+KcR5foBOJ6qzzH5M4krB4ht2srqPTxu0gojY2M=;
	b=LpqCHQ+dR/OA6hKrjvyHorTTOtts2t3imw0iPMPuxCbv4dGiYxONP4cIRlMVERg6Brt8sj
	Xh2wcyH4Wdbd5D2coDbO1HMFfnWoi1xRo8YWxMkjGcXWsBiIhti6eSRbaGEz/M/LNPG5kB
	O813pBWYbNqBYijBhFhxnf81qI0i5kE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Use the in-context stage-1 in __kvm_find_s1_desc_level()
Date: Fri, 26 Sep 2025 15:42:46 -0700
Message-ID: <20250926224246.731748-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Running the external_aborts selftest at EL2 leads to an ugly splat due
to the stage-1 MMU being disabled for the walked context, owing to the
fact that __kvm_find_s1_desc_level() is hardcoded to the EL1&0 regime.

Select the appropriate translation regime for the stage-1 walk based on
the current vCPU context.

Fixes: b8e625167a32 ("KVM: arm64: Add S1 IPA to page table level walker")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/at.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 20bb9af125b1..e2e06ec8a67b 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1602,13 +1602,17 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 			.fn	= match_s1_desc,
 			.priv	= &dm,
 		},
-		.regime	= TR_EL10,
 		.as_el0	= false,
 		.pan	= false,
 	};
 	struct s1_walk_result wr = {};
 	int ret;
 
+	if (is_hyp_ctxt(vcpu))
+		wi.regime = vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
+	else
+		wi.regime = TR_EL10;
+
 	ret = setup_s1_walk(vcpu, &wi, &wr, va);
 	if (ret)
 		return ret;

base-commit: 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6
-- 
2.47.3

