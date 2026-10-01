Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADC953D9D2;
	Thu,  1 Oct 2026 21:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790888895; cv=none; b=ANhqGVb4VKffRBEldF8JhMKMhg1/w9ylNn4+iev5FB9AYEVEHezCMLrVb6voO9x6ELAANDTjwYkrU5M/NNZY6btvBghWGiEn+ktVF8AoKIi9Mh4sb43zLwQsX44OBRxJd7Hbcbsb59Lp9D/dZPLSWqpXL1I1Sv6xoPCoFAPANK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790888895; c=relaxed/simple;
	bh=WsjSAf7iPMA/K8mPP8RhduMdKhLRQFgtRTlAA6Oernw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpzSCgyx5TRldfEEt+5w6FWnVUf265XWx3xrSz6bshIcbWr5GWF85sXyFH0vrndwxRLuubq46zTAe74ue92ZZYBxiDnRwvFrdC/rmJkhlC+Ql3GeeuUbiRWK9NR0gb2+SohJsnKaGAY9ROVs/YGTNoFH+RZaVERcv0y1Ys3+utM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RFd7Lj6p; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RFd7Lj6p"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6039316F8;
	Thu,  1 Oct 2026 14:08:09 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6E0B93F86F;
	Thu,  1 Oct 2026 14:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790888892; bh=WsjSAf7iPMA/K8mPP8RhduMdKhLRQFgtRTlAA6Oernw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFd7Lj6pc3b5WJuyjN+0CngiS2XcgDjLatO4PjBuQKiDrlojAdaiCSbMVHraV9iZl
	 vAc1wRY1KqcJ6B9P/EGfibuhWCS01SmILvA2Z3VhTXwiemh/bQFMbvDTAQLOnaRPjj
	 koSqa0jPyoKTkJ36e9kYDSIhVD/FhY2F2MMRdGM8=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v21 14/23] KVM: arm64: CCA: Add a new mode for supporting Realm guests
Date: Thu,  1 Oct 2026 22:06:54 +0100
Message-ID: <20261001210703.1597150-15-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001210703.1597150-1-suzuki.poulose@arm.com>
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an explicit mode to support Arm CCA guests.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 +++
 arch/arm64/include/asm/kvm_host.h               | 1 +
 arch/arm64/kvm/arm.c                            | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd24..1afe3df3b923e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3256,6 +3256,9 @@ Kernel parameters
 			nested: VHE-based mode with support for nested
 				virtualization. Requires at least ARMv8.4
 				hardware (with FEAT_NV2).
+			rmm: Support for running confidential guests in Realm
+			     world using RMM, as defined by Arm Confidential
+			     Compute Architecture (CCA)
 
 			Defaults to VHE/nVHE based on hardware support. Setting
 			mode to "protected" will disable kexec and hibernation
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4d75b8e6797bb..4516594d90462 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -69,6 +69,7 @@ enum kvm_mode {
 	KVM_MODE_DEFAULT,
 	KVM_MODE_PROTECTED,
 	KVM_MODE_NV,
+	KVM_MODE_RMM,
 	KVM_MODE_NONE,
 };
 #ifdef CONFIG_KVM
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bcb78fc7676c5..3ab722f2af7c8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3277,6 +3277,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return 0;
 	}
 
+	if (strcmp(arg, "rmm") == 0 && !WARN_ON(!is_kernel_in_hyp_mode())) {
+		kvm_mode = KVM_MODE_RMM;
+		return 0;
+	}
+
 	return -EINVAL;
 }
 early_param("kvm-arm.mode", early_kvm_mode_cfg);
-- 
2.43.0

