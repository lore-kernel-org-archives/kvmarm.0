Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF48F8248B
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620068; cv=none; b=djZo57CjPVmi5J0u6lB2Qw6FaJ0ZUPYPnmY0GB4kukYUzVEvGb0LEhjpABoMgT/biHnXR5gB5GqSQi1Da1PyOw9PaEumbTAVtH4pWqnnUeMf5R2jqmOsNgKUfYIlpDuu8I8Uc26yrHr/N+dZyJkgpJnHlwh2/W3I5JzcNvwcJCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620068; c=relaxed/simple;
	bh=GEg9qAdks1S+YwQJuBag8f327Zhp7USRaMcrpEgiyho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owhGBKdog+pr/4jL/8zlXBqRqmTc5o9/r2XJrQuvfGECG8NwCiWZ0uhob0bk1Ah3VyUB6BTj/185tkwHcNaRkZTHkx+DFluXA2oPMXBkmsBlATrwYuYbgIBn1yydDedkj76Wz5l2chtsgiJMsK+XMzOUftldC2XSuAJ0CmoR3hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOJCN+24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOJCN+24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BAFC2BCB0;
	Fri, 27 Mar 2026 14:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620067;
	bh=GEg9qAdks1S+YwQJuBag8f327Zhp7USRaMcrpEgiyho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOJCN+24HF1P8N3vOszHXVONmUqmtK0wysGXnU7XB/VHEaVFn7OGnOF++R5KlAye/
	 C7lssuZ3cUnsCRks66Dd8Nh+jwsgrV5qZPG9l8/DV/hepmlKM4xGQlSIUSt40UH+ws
	 ctD88G+YdjlyRwmKCEz8xIwSgVzKuzhPruC8oHxAP5XzpyWLfC2cl3X2X4EN4VyCVA
	 NcHPjz+nBqQRhv3K8AvYr7YOK00DFxe1tdhhqjr7EiyINpdTyX9iMB1wDmd0gCsAPP
	 0TJ1/Sn6vg2ZloSau50Hc1QG23ZLzCLolBBNAYI0TLYcP6sIJpTbAzhMSQSRA4nxyD
	 5iAYYhQXwUvhA==
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
Subject: [PATCH v4 05/38] KVM: arm64: Don't advertise unsupported features for protected guests
Date: Fri, 27 Mar 2026 14:00:04 +0000
Message-ID: <20260327140039.21228-6-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
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
2.53.0.1018.g2bb0e51243-goog

