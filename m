Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6763BB44
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115198; cv=none; b=PXusSejooBg3VdGC+40W+ojtANXJBs8kiJjyrkF8M8oaEvd7RQhOq/IHgRXq74F4Pp62nNf+mNLVaxuAQm5fAsCWzxQxO8w8hAc8kFNuErywkkYzSnHCSJa+EHgHFIL8JzMBwHsEwu2+xfNQzRmElb6fnOM0f0Qy12V7iwKq+qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115198; c=relaxed/simple;
	bh=+8ikEHpZHahS2On2pbE/2znSsbHpcn8CgoXkknwrMzk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mtaQI2tx/q5bdOZBLYaPCL/w441aY1eAYM4eStrsVOnP4JEfC/Nst6pIwhyrK0Vq7qISoRIztv4rxuw+/VW8BQyHYMcPW33MdHkFGF2nNP0H4gl9XhD5e2P/sW3aZLyEcyG9c+NXuvUiwEcDfy6sz3Wpws1CbHqQ9K8rv4JYC6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CGVfymlN; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CGVfymlN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TbmlIFHdX2zja8dqoQ2q1BuDOoG23G30svsnocIKAyQ=;
	b=CGVfymlNR2GAn8CUqDinl6u3wzooVm777k0Wnwz6xHhyM4/dzNZVJayUDoalKKy4fcrhZ7
	UG3ZGTVO3XhKupaN8+F5FS0YcQSG9jqKgFeaNYbGGbHQqukdWZ3nu48lupKZw3bqK3CUrH
	a5HOsUT2/CMAFy3XuuTC8Gc+RUkrMsg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 26/27] KVM: arm64: selftests: Add SCTLR2_EL1 to get-reg-list
Date: Mon, 16 Jun 2025 16:03:07 -0700
Message-Id: <20250616230308.1192565-27-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Handle SCTLR2_EL1 specially as it is only visible to userspace when
FEAT_SCTLR2 is implemented for the VM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/get-reg-list.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index d01798b6b3b4..684c52b1b881 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -52,6 +52,12 @@ static struct feature_id_reg feat_id_regs[] = {
 		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
 		16,
 		1
+	},
+	{
+		KVM_ARM64_SYS_REG(SYS_SCTLR2_EL1),
+		KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR3_EL1),
+		ID_AA64MMFR3_EL1_SCTLRX_SHIFT,
+		ID_AA64MMFR3_EL1_SCTLRX_IMP
 	}
 };
 
@@ -469,6 +475,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 1, 0, 0),	/* SCTLR_EL1 */
 	ARM64_SYS_REG(3, 0, 1, 0, 1),	/* ACTLR_EL1 */
 	ARM64_SYS_REG(3, 0, 1, 0, 2),	/* CPACR_EL1 */
+	KVM_ARM64_SYS_REG(SYS_SCTLR2_EL1),
 	ARM64_SYS_REG(3, 0, 2, 0, 0),	/* TTBR0_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 1),	/* TTBR1_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 2),	/* TCR_EL1 */
-- 
2.39.5

