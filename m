Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2C24C14E2;
	Tue, 15 Sep 2026 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488157; cv=none; b=C/Bn4SINvp6J+sgtvnceGv7BmKMIhAjaoazGhWxZt42Ua3TjrG5VqwNzgESisLSYc8Crq2pKF4kydI9y556qn4fFkBxEYCi9VW/rNUFbQSzaGqc7w4/G3pzWuetrjr5LUhNjwQp8Ca8Epz8xo4vWysOxyC+NKLSCv8urhPBrouc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488157; c=relaxed/simple;
	bh=3txRcWQsJihaCMkChZU8QnEkjzabm1OeIAmZ/JVQQZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRFJHUZLHGXlSPbLeOJmbC2j22cowh4Sdi0hOc5HJzHSlHlU2PLstWZUYpSUgb7N4GMS9Rg340z2e8enGB3CWcdt3k52VihfELV/7KbVY8u/KVaA4XoFy57j/vXWFE+N4TTWp09jpXfeCNA0DdeMXzudsrRJNER46JEzL8GdqrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y5vhUav2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y5vhUav2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88E381570;
	Tue, 15 Sep 2026 09:02:31 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 720E43F882;
	Tue, 15 Sep 2026 09:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488155; bh=3txRcWQsJihaCMkChZU8QnEkjzabm1OeIAmZ/JVQQZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5vhUav264lnGStYDQ0TrDQfREW9OpKJ195DiEGkUYDHu0TFERlAhLr1bJBeers14
	 fbsgOkT2O3P7YHJV/Ob3j9ZQ6Y1dUXc3m225l4pacgeBpzLtZ8dsmVh39ueNmoMEzH
	 iz5JZ2FvD2dGagp7aEKsxerDKwiWGv6D9Mty3doQ=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18 14/23] KVM: arm64: CCA: Add a new mode for supporting Realm guests
Date: Tue, 15 Sep 2026 17:01:32 +0100
Message-ID: <20260915160141.3543048-15-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915160141.3543048-1-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an explicit mode to support Arm CCA guests.

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
index 09910b2c61bfb..3cedb71f49ab8 100644
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
index 42d9385f5e329..ae09d0d9812c5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3283,6 +3283,11 @@ static int __init early_kvm_mode_cfg(char *arg)
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

