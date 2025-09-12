Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A7126E701
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712209; cv=none; b=VAZ9iT2cUYP37uEGfRnLk0AeZu+h4C5EPGN+uEm3rQ0I8MNL36RVeZhDr9bkeAK0KLQDIoAoChj6ZHMyAjSdEqXzUxAhBMkEu5eAIROKqUNEYYW8zQTYmu/8ZQ3Qqi5lgc35UvjBFSVViNyIi+AZlmuNdBOG9SqR/DVMaRzC0C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712209; c=relaxed/simple;
	bh=QhHDRtamGHNqbRWIo6Ojx+fmf77sLPnVLcHCcbVB6vA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B/Sgd8o5WIvOT35999IrRNqqKB1xeGUdMIlb1IxAvRwDVQPessnpgxLvP++FrZjXXwOyxKqEgLmS5fvLbhenS/Q8Qqj0mNyRGdSGhBBTpYUhrH5MGsHAYXYtRChais/ew7nYALCpDXI2oSEq87lgGkvRJGHsk9xqAGgMm71e0Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cg3fz+3n; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cg3fz+3n"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kbJyACD2zKs3BtD/b2gnM8mDDFj6e3FGgo+X4Ei0qQ=;
	b=Cg3fz+3n21Iz1XlBTq+y+ztjy7hrx5FiIj6DZQzMo4ElybDDOcsknhdDSFUPFvSTAehGXf
	1fYCmBme3pk59hFrwJhcnb5DpNz3fmE44riffWn9Py/NamW981DxNjKG6kGlID2nGojbYH
	Y2lvi+jbnIFfHuOEKoKlR5LbxHnpW1U=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 11/11] KVM: arm64: nv: Expose up to FEAT_Debugv8p8 to NV-enabled VMs
Date: Fri, 12 Sep 2025 14:22:58 -0700
Message-Id: <20250912212258.407350-12-oliver.upton@linux.dev>
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

The changes to the debug architecture up to v8.8 are concerned with
external debug, which of course has no direct impact on VMs. Raise the
feature limit and document what's preventing us from raising it further.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 65b5fbb88510..74bd5140c9a4 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1581,8 +1581,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 			 ID_AA64DFR0_EL1_PMSS		|
 			 ID_AA64DFR0_EL1_TraceVer);
 
-		/* Cap Debug to ARMv8.1 */
-		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, VHE);
+		/*
+		 * FEAT_Debugv8p9 requires support for extended breakpoints /
+		 * watchpoints.
+		 */
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 		break;
 	}
 
-- 
2.39.5

