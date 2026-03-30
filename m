Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294A332861F
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882148; cv=none; b=IuaJlVbOsgZQaxZNyPrt4stOGQKpaf1jW7p7J9X7h6kNyDT9P5V4f3NOyNiisK9iKoSKI9NvxzWQrmpraigpuBcrvGpnsPUmjE3udpPLhqpBQORnijnnO0Xnrza1Jgg6XwwqFkfpunxL4vRuKpQTi2s48XTXw0NxoBOpl9T0zpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882148; c=relaxed/simple;
	bh=GEg9qAdks1S+YwQJuBag8f327Zhp7USRaMcrpEgiyho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juKWQERimAJIcG/Ksf7Ji3mO9XXlDGgX6qmODf3kBjYSg+uRY27yCj7ULRlYCiLPLyZEd4wJRHHFycLJ6VtKHaPB6L//doABGDkAjKjd19+sB3iJnE4y6/zzNYUpSx6RokNmE47P+rTG/xr4zSdIKqKgaMBITggtEohqdbvus10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYnLwmCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYnLwmCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088B2C4CEF7;
	Mon, 30 Mar 2026 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882147;
	bh=GEg9qAdks1S+YwQJuBag8f327Zhp7USRaMcrpEgiyho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYnLwmCTC5Pdo/AJEKshXlYSsKwjMIe7O18EUCdKOy3IsG+1Jmh+D1K62Nv50Drwe
	 BwHTmBhaGSlYH+xWddww1dhdxYeJS86B37ftoONSC3CDKD3gNFICwBoH3N0QKrrwvm
	 u5uvMmmkv9qhaALLhI6plueG0DPvtQiWdFX/m5ParaDLxzm87jmJyMt2tVT82v5277
	 buIgzhiq42LjrXPIF9VyINgVIKYFEatiFz0Ppy28mlNQsaG28rWQ/Hbd+/fH2AtDot
	 ufT+vnAK4V6POCuCG4DELFaLbzriFOg9PQ80twkgWSnKgN84ekbY/+lIiZ4jn76o6R
	 Wj1NhkWw4K2kQ==
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
Subject: [PATCH v5 05/38] KVM: arm64: Don't advertise unsupported features for protected guests
Date: Mon, 30 Mar 2026 15:48:06 +0100
Message-ID: <20260330144841.26181-6-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
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

