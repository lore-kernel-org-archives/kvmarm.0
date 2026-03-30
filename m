Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828073E1202
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880681; cv=none; b=J9bukRquZQHJp1UgJckmVdtHnLOl/z5flIRvdhTtMHcsUegtZJgJ28FGIWEDmmq6tuT+tqPohrRve7sFSoDdcMcBDrMZSTcWW7MtURQ9gZSptasymg/7pcxe8+yl+WH/6KeYq2Xl2FDb3ve3mbrP3+/AhP3fFRffoFUSEgZDPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880681; c=relaxed/simple;
	bh=sx1ccfpOH3rIlBXTgrOC+8Y/h/QBr758sug6lz7re9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGXC5Fu1jxDzboa3Q5Rl2b9uSmp5Ql5Zmke0XqiPf4gPKHXESEt57IXXVOwXdWryQ2VkHABSP0iqD9ntmkJCwrtqj/w/tmjbs4ODwz7DFYAw2GOLP16PWiac8UEMG0gjFdc/xrntgTSydAdsDDtfvLon9hDD2hOwQKQYTTQaDTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CorUkqcY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CorUkqcY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33EBD1E7D;
	Mon, 30 Mar 2026 07:24:34 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 66B4F3F915;
	Mon, 30 Mar 2026 07:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880680; bh=sx1ccfpOH3rIlBXTgrOC+8Y/h/QBr758sug6lz7re9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CorUkqcYFNhwDskus+lBA4Zd/V8uZPFP3+rBCj63cJtIH3C0veAkdr40WJvDIhaOA
	 Un5gtkO2Phhg8RBS+hzikQDu0dDx2Riwg2a9PGtBfcoH/cbMi5RRdgV5NAFtMErj+2
	 fVWuJ5QwqrJEG2jUgkBfGxZn3VXdzz0mTN0GwdZk=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 15/17] arm64: psci: Implement MIGRATE_INFO_TYPE
Date: Mon, 30 Mar 2026 15:23:32 +0100
Message-ID: <20260330142334.3309961-16-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Let the guest know that our PSCI implementation is entirely oblivious to
the existence of a Trusted OS, and thus shouldn't care about it.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/psci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm64/psci.c b/arm64/psci.c
index 94e39d40..3deb672e 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
@@ -32,6 +32,7 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_CPU_ON:
 	case PSCI_0_2_FN_AFFINITY_INFO:
 	case PSCI_0_2_FN64_AFFINITY_INFO:
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -190,6 +191,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 		affinity_info(vcpu, res);
 		break;
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+		/* Trusted OS not present */
+		res->a0 = PSCI_0_2_TOS_MP;
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.43.0

