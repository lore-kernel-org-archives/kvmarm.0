Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1926632AAD8
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 19:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592659; cv=none; b=FtguCYmkD144CKB5yC06DnPCfiRkinU8l5JL/prnNICJVxskMpwYfn4jjLN/G7CkWc+RB9tB/gNT1LUTyNJQrSasHKDDf3jNbaoH53eOcsovVyWePOvpdOc6NJwN5AsQ9yZLRaUPiXjV988jp06pMktWEQc7ndaMC+EHMNFV+Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592659; c=relaxed/simple;
	bh=GiYHP4eOLFxhxNGk7qH8zk5E/0fAQTENJvmg4lqvZsg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VzMbOZ6zAFsYPzhWK6gokW3e+j8SjG1kYlIHTbzhIRU04XILAvkKCigeD1xjXbEvCM/3QRoePszP2uLQonVCmfdQmokBp4QOrxKyt+4Ei8UIkhnnAMuWqHR8RNr+B5Sg1l+TLsbyI/qBRR3HfgFW9pIoofvvBF0U7otilZB0+eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A26CF2574;
	Mon, 27 Oct 2025 12:17:29 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 91BAC3F63F;
	Mon, 27 Oct 2025 12:17:35 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	perlarsen@google.com,
	ayrton@google.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 2/2] KVM: arm64: support optional calls of FF-A v1.2
Date: Mon, 27 Oct 2025 19:17:29 +0000
Message-Id: <20251027191729.1704744-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251027191729.1704744-1-yeoreum.yun@arm.com>
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To use TPM drvier which uses CRB over FF-A with FFA_DIRECT_REQ2,
support the FF-A v1.2's optinal calls by querying whether
SPMC supports those.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 0ae87ff61758..9ded1c6369b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -646,6 +646,22 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 		ffa_to_smccc_res(res, ret);
 }
 
+static bool ffa_1_2_optional_calls_supported(u64 func_id)
+{
+	struct arm_smccc_1_2_regs res;
+
+	if (!smp_load_acquire(&has_version_negotiated) ||
+		(FFA_MINOR_VERSION(FFA_VERSION_1_2) < 2))
+		return false;
+
+	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+		.a0 = FFA_FEATURES,
+		.a1 = func_id,
+	}, &res);
+
+	return res.a0 == FFA_SUCCESS;
+}
+
 /*
  * Is a given FFA function supported, either by forwarding on directly
  * or by handling at EL2?
@@ -678,12 +694,13 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
+		return false;
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
 	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
 	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
-		return false;
+		return ffa_1_2_optional_calls_supported(func_id);
 	}
 
 	return true;
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

