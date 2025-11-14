Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88422283151
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136478; cv=none; b=HjYiyGhkQLG4LO7z9pDQpcCF7tCBjp8o7mP0z4P2SD37rJnCYi9UAwr7Wus+xWgkZIlDv74hIOrot2jXBJWOCAtCjtGEcxWcRdBU8GRHF5n332HcHOLovmHKJnlGvm5yBTdhRw5eWq2bMJ25PXYL46i7dhMkiBVoE9LI9X9RDIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136478; c=relaxed/simple;
	bh=gYzb66OlG1z+3UrDqh2QdrfsegW8sBmAzpyAoOicOFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdTIN/1UtFWg3EHfVsB0a7gqVEmwKhJu0ZuaqgnK3A7jUavZIeMPyFUMtUwcO3f+WXLue+ElOvBvaEDNvYtMIEAf3MeBZY+EwbHqwFN5/1mUTHVGAEa0EyDdXMGQ2dT5NpPsNF7eUXWgrlZQo2Co9v/pLenFC5GL8DFG2yClv+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47461106F;
	Fri, 14 Nov 2025 08:07:49 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC0093F5A1;
	Fri, 14 Nov 2025 08:07:54 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 09/35] HACK! KVM: arm64: Disable SPE virtualization if nested virt is enabled
Date: Fri, 14 Nov 2025 16:06:50 +0000
Message-ID: <20251114160717.163230-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For RFC only.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/arm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1e4449d96d62..d7f802035970 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1490,6 +1490,11 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
 		return -EINVAL;
 
+	/* TODO: NV support */
+	if (test_bit(KVM_ARM_VCPU_SPE, &features) &&
+	    test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
+		return -EINVAL;
+
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
-- 
2.51.2

