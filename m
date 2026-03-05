Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552E03A9D91
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721865; cv=none; b=OYASYqUGdc9rPK9u6dQWWE6FO//lYv5l3T/C24qRflviEkU3NyjbR0oBhDEQAdF6bcySOSQHCGEBQpQ899I1LBTXc0Ghk3SWVSNEy+oznG8nxJ6m8sqRp062htFhk98QNa8Xtdn3ho7uMQy8W9j+MPPhn/qsr3LnQ+/NJbbDpPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721865; c=relaxed/simple;
	bh=gCsYu54+rda1wp7ZSqfP5W9dm2M/NIWUZ+HpfEGTVN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYSB75tpf81HkxBU0hGmLH8iJBDnh3h1wmfYIjZcvNOGlhs13w3jNtdyLzfoSzkP35VzrosPmZkVXflURpP9aTa1007KaHvS1ozBZh2Oka2D/SR+B1gbqJ4MtdvfZpboE/sOk4fVGsCtsNwXhs4leWjKWsirKOgV4+bu6GpWgDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSfRmb/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSfRmb/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0062EC19423;
	Thu,  5 Mar 2026 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721864;
	bh=gCsYu54+rda1wp7ZSqfP5W9dm2M/NIWUZ+HpfEGTVN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSfRmb/1xNnovsjt+t+jVHxUtHx49sEd+QkEyHCqOdW36nlPM7HJi48gXq87WQw24
	 1BuC29R1p7953RpFi6jkuLxAACCuRoeSwDO83AmboJ8O6dR9W1ZPkZIDHNKNZtT9Un
	 MiICCTasLZZqyagodb5gNRkRqtgELdL4H20o447kDtlah71DQ+VLvZ/hlVmgP6YJOP
	 WCS7Tv0ilKHkOVLD3rP0VSFxdKCa1jfYpaiaAkcTkQg0M9rzI171MlO4CpovwOojwO
	 +BtXhsPS861C4FTBeN1O3JWEwPrS/CmPcFPOfGSJBToKx9+C6XpJA6Q2E+ZAsFozrG
	 Bu6mlW33vWNcw==
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
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 04/36] KVM: arm64: Don't advertise unsupported features for protected guests
Date: Thu,  5 Mar 2026 14:43:17 +0000
Message-ID: <20260305144351.17071-5-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
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
index 757076ad4ec9..7041e398fb4c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -40,8 +40,6 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPU_ID:
 	case KVM_CAP_MSI_DEVID:
 	case KVM_CAP_ARM_VM_IPA_SIZE:
-	case KVM_CAP_ARM_PMU_V3:
-	case KVM_CAP_ARM_SVE:
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
-- 
2.53.0.473.g4a7958ca14-goog

