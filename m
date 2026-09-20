Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 480284756C8;
	Sun, 20 Sep 2026 21:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789939756; cv=none; b=bpt994+ffeHoUovLFSpB3IMn7IJewE68Ew+G2KZdV+Xzknx6gcqY1N68UDVy2wWFMWG0VRCOU7LlyR5FodEGX7BM0OrYd9PKuIlIE8tVn/9WAsvcG2V4xZ4yJBE5Re77GguImFR8y9ud1mJCyVc1BsxrkDBD+HjDFnzOeuLXglI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789939756; c=relaxed/simple;
	bh=8q9Rt/6mKLCfGe51uszKwi9iQrDRjaKLQZ+w4aPQW+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vFODgVjafR+f+O3vqMB3QmwiB5CcnwSnzw/B4Qsab4LSJG2uabdRkXEVw6LbgARcKDovlRpv+UrNvGAOaBvvAK1F/dedfP1mCIguodb2QUFqavmsPcaF8uphLoBxOu51evQobQKcwgOsXAIeDyBvyzy1aTQFJudRsJCIkPS5uGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YwPgmKxM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YwPgmKxM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2638A1596;
	Sun, 20 Sep 2026 14:29:08 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BBB0A3F632;
	Sun, 20 Sep 2026 14:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789939751; bh=8q9Rt/6mKLCfGe51uszKwi9iQrDRjaKLQZ+w4aPQW+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwPgmKxMVqTCkmdUbVjFX237jHAP3Qqji6VWlIE/xg7/RwlknUPuEbmx/FbxdQTqK
	 vpSe9OlrNwV/xKqAWxr6iJ/RBxipSthEvUsCj7oTvXD+l/lSWiYghW+HG8LD+mNmML
	 0rW2JiczIOtF4adkWbRtO0OKI4706Na/NfLDZ2e8=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v19 03/20] KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
Date: Sun, 20 Sep 2026 22:28:28 +0100
Message-ID: <20260920212845.707-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920212845.707-1-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix a potential build error (like below, when asm/kvm_emulate.h gets
included after the kvm/arm_psci.h) by including the missing header file
in kvm/arm_psci.h:

./include/kvm/arm_psci.h: In function ‘kvm_psci_version’:
./include/kvm/arm_psci.h:29:13: error: implicit declaration of function
   ‘vcpu_has_feature’; did you mean ‘cpu_have_feature’? [-Werror=implicit-function-declaration]
   29 |         if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
	         |             ^~~~~~~~~~~~~~~~
			       |             cpu_have_feature

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 include/kvm/arm_psci.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index f86a006d67136..06c20612e9e7d 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -10,6 +10,8 @@
 #include <linux/kvm_host.h>
 #include <uapi/linux/psci.h>
 
+#include <asm/kvm_emulate.h>
+
 #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
 #define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
-- 
2.43.0

