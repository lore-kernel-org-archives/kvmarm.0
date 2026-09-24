Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E284AA3E8;
	Thu, 24 Sep 2026 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265984; cv=none; b=o1o3dNdisT3oIkD4dNsRCgyPXQF7ajSA/9i+9JqRk+eQ1zu/40EohnlGltkJgm17tBHE9P/L6LfsyfYVkQSu0OoGJqUpOH1u7cpY45P15NW4h2Q1hXDtOU/CYRIfBPMD04mDIU1OWhUlly0rvUsDarYOfN73xxFuhjN+EcK3pmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265984; c=relaxed/simple;
	bh=WsjSAf7iPMA/K8mPP8RhduMdKhLRQFgtRTlAA6Oernw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDcRdWNJuXb/ol54j7KxKQ/IAM4fXjvIK1r1UyCYnXBH0NpQDUCKMk74cyQUHnE4CV2FeJpQLf8Qn0x9A4Y2nVpdPBl8raYiwygsmk1lz2olIvn0C3RisR/O6YB1IrFRLco8bcKDexAXMCxYv9btFVV0nSWFLOwPpMvDyTYBf94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pU5ymd75; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pU5ymd75"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDFD01E8D;
	Thu, 24 Sep 2026 09:06:18 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 34F253F86C;
	Thu, 24 Sep 2026 09:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790265982; bh=WsjSAf7iPMA/K8mPP8RhduMdKhLRQFgtRTlAA6Oernw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pU5ymd75t/CsfpLogXNdcKPi6/IkzjunVpNkSNjU+ftoujdOrGrACqvP69o+M6ac+
	 um4onCJbRh8aczQEMbtQSNjCYHd2ujS9M06fe1S+T3jKJNIHKJ6dveCrxCvHkHkTCs
	 7FlWfo8P4z5mDotM95yfp6eRbdPk17QbNI4JNMV8=
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
Subject: [PATCH v20 14/22] KVM: arm64: CCA: Add a new mode for supporting Realm guests
Date: Thu, 24 Sep 2026 17:04:56 +0100
Message-ID: <20260924160504.853911-15-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924160504.853911-1-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
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

