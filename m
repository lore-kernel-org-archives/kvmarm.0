Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D80302176
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628203; cv=none; b=jnAt15gwwyN+hLStv/yey8NF6z3U3FsYHbf7ANDI5Z3+syoRb2LHK5XTJ3W1ELh+KhQvIz7LHfuxSNdthEXL54BE2JmZRWkbrN16zLHyt95c9B+EhdDEQbDYx6ZY6KVolW3bcJ8TowlcPQ1dJGmlMXXmCHzj9V3PssAJMA8mGGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628203; c=relaxed/simple;
	bh=urzC1N4aQ6kG8UqznJupq3gEB8+LBsZGlefWUCpaFx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EL7f7G5aVkpfnkPSE3HtgRG7d07WmZGrRPt194iLUJukN4i5j8/bVsJqdrjcYepCu7SdtNvqmsxd3tog4GwRyvUhwrruGY2WznRx4EVnsvWDWKNsaIPkIupkxnMtpbfPf8oPla8wPQgsQaypRDziuwvRuEwHuigMGqq8d+hAIbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxERz5s6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxERz5s6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC8DC19425;
	Mon,  5 Jan 2026 15:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628202;
	bh=urzC1N4aQ6kG8UqznJupq3gEB8+LBsZGlefWUCpaFx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxERz5s641JQj1eu2LAkhYryLlMlPmq6kWR6NNt9H+5YgdzKemLUI/Ps35nPCt9JS
	 td4ig/PraeyNZZtSR+HJ4sYRUvptYxeVeDszaxiEKS9X/F0fdJjeLii0oUaXTydS7v
	 MxilMjzon9CS1ELiX4Uum8zy1VuTAcLou1aZPfXrCa5d8a03BMvFWciYlLRalLVMtd
	 c/5EWK739nkggs+LhRCX1i6dGMlvHX8+k0eaaidIJwilSLSayKnZnt8eHC7DVRh0le
	 JNNCNGdl3MWG/p9kJU86+xQP4kR4p4EC4wAFpDnVwh216jeeWGk1wEAeJYVwcVcs3b
	 GunoWSrMEMYnA==
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
Subject: [PATCH 04/30] KVM: arm64: Don't advertise unsupported features for protected guests
Date: Mon,  5 Jan 2026 15:49:12 +0000
Message-ID: <20260105154939.11041-5-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
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
2.52.0.351.gbe84eed79e-goog

