Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7554C3E1239
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880683; cv=none; b=qEqAB+dSTVXyFGQbjpE/ILURgKY8aJDieNXydvI+wTudS/WSzmmw7ZD8Up8+2hlAxlqD/quRZDz4sW92IN2PaM84/rfMBuX8QFl1kDZFbM16jqBWqUZLJZVy7A9q5uJUtSyWhXaP0arQUo0Gb2auWMU0qunY6NjCHvM87lCupy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880683; c=relaxed/simple;
	bh=hpDfcXJ0ERxD9QdxSdOFTgn2JgPNfhZudvBW4grrPzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB//CQ9a6e3UVsmPQBrQgfZz67wOBTPn01vGiVBcH3ys9K89hWIOGNkff7pu6Swpo24LvvzWur50iBFbSG5emplWIV+mdmyS540i/0r/4+rqp/Db6N6tUFRUzJ4otRofPNLvpzfpNtrZw6CJQx3nswCfhv0IC9ChpoK5k5/I3Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QCwo9GUg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QCwo9GUg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DE7E4515;
	Mon, 30 Mar 2026 07:24:36 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 603D23F915;
	Mon, 30 Mar 2026 07:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880682; bh=hpDfcXJ0ERxD9QdxSdOFTgn2JgPNfhZudvBW4grrPzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCwo9GUggPZUgT2mTOwHXvj0JMJuYKgQ9sLZmll3d/fHBwKNdKBxpvZarhW7UUSwq
	 AcrwHsAlEwfmFUASCnRxU8DsUGGtrPqDli1O/HktA5oxQ9fKzPhinQztKAMiMQ8WPt
	 UIALdy03FavOb/RVD+xuPLpqB6aqrFlgxL/JCIQ8=
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
Subject: [PATCH v7 16/17] arm64: psci: Implement SYSTEM_{OFF,RESET}
Date: Mon, 30 Mar 2026 15:23:33 +0100
Message-ID: <20260330142334.3309961-17-suzuki.poulose@arm.com>
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

Add support for the PSCI SYSTEM_{OFF,RESET} calls. Match the behavior of
the SYSTEM_EVENT based implementation and just terminate the VM.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/psci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm64/psci.c b/arm64/psci.c
index 3deb672e..874ad141 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
@@ -33,6 +33,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_AFFINITY_INFO:
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -195,6 +197,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		/* Trusted OS not present */
 		res->a0 = PSCI_0_2_TOS_MP;
 		break;
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
+		kvm__reboot(vcpu->kvm);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.43.0

