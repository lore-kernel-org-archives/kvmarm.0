Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D36221543
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826829; cv=none; b=EGPP/kJdlcgdaHGWb20cZSwzOy2k1ICkvLNjh2fa9yCIUiTnK8X1AU2Zyr8tNYnB2UhltmS8mgtYmQYEq3rj8J/AhhHHGVL2RKKTiI9HwU4C8iPSJyvWJBDy6irTS0f9kkpufiueBcd1+cDl0BtpmZDDTti5faA6o/nGAUYsag0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826829; c=relaxed/simple;
	bh=ilZyBr/0UC+YHcdnNiHjYBCPLVUAoDM/YjJevxwCSLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxTVs06I8U+fwmwHzDYX65PgA3aOpDQMdpVJL0j0jKxIie2whNLDBou1SL7iOo7Xq/wFXs9kQJ8LkTgjWf5aPVJE3bn7Lkn9UQf2pmWdL2VLPAAUHkW2Sx3f/OdwGylMKRCeUb63flYmrVFlS2CwVEH8U3hrnXguvEBx4vASfLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=urV5s74X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="urV5s74X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADE0C2BC87;
	Mon, 19 Jan 2026 12:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826828;
	bh=ilZyBr/0UC+YHcdnNiHjYBCPLVUAoDM/YjJevxwCSLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urV5s74X02f5AftapIIiz8YtQH6vJMrOr44HiLy45D9q4TWtQbMp31L4atPFOmAB8
	 UGt5He0/Ekap1yGSA/kyht74lYv4AZpkdSkA5AAvuymO2NEePcWVjHS+dI7r+u5pWp
	 H5stgc6/np8rOOJqCUuAs/5LdvTAnMJyfb3nidy15tMhU0prfK5Lyzu4Hr/F5hNOYf
	 mWpXU5Ir8leO3kuRqxUoy7aJlDHRo6m8OGYXzK4bqSmHXDoatKcKd/JOYMDrokFGRD
	 Fy5433DHejJQvBlaxOaq6YUnTnhE4bdHm37lC10f41+vjYWzWvVXp3pTGMBfZ2yIDW
	 6u5Tt4X1AOVPA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 05/35] KVM: arm64: Don't advertise unsupported features for protected guests
Date: Mon, 19 Jan 2026 12:45:58 +0000
Message-ID: <20260119124629.2563-6-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both SVE and PMUv3 are treated as "restricted" features for protected
guests and attempts to access their corresponding architectural state
from a protected guest result in an undefined exception being injected
by the hypervisor.

Since these exceptions are unexpected and typically fatal for the guest,
don't advertise these features for protected guests.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 0aecd4ac5f45..5a71d25febca 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -37,8 +37,6 @@ static inline bool kvm_pvm_ext_allowed(long ext)
 	case KVM_CAP_MAX_VCPU_ID:
 	case KVM_CAP_MSI_DEVID:
 	case KVM_CAP_ARM_VM_IPA_SIZE:
-	case KVM_CAP_ARM_PMU_V3:
-	case KVM_CAP_ARM_SVE:
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
-- 
2.52.0.457.g6b5491de43-goog

