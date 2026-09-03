Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C321B4A6CE0
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451618; cv=none; b=BFijjO7drpwAcu/Ept9M4KkzIwuRHUTYPyixluSA8TZ6kUBoMtrGXt0MeBDSn8LTKwM9zvJt+BWnsiyrcIoaNLeozma0h0kmyXChqKxgTYpgjaep0ilq1zDJRC3694/wD+avOyt5JCjw57ZFoIuS2jX6dwR3GfniROgH7kNqDNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451618; c=relaxed/simple;
	bh=J7TA+zV8kmgZt4wrJnZbQsqLDsJ8zbM7UZBpwa76m/c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMQRNN5cgPuqYRNW85yzFa9hL/lOHwx8yXqeJX1dpyKPewkk6gtLuRUoBx7X1ksrZfXsNPcur6uZ2RkRS73OCWpmQSSqiCtCiNYNZ6KcR0x7DxF0/wH4S0Dx7iCcCkZDhuZnCTThrsMzoj9aTII2a4y1q95V/XwgYhBqRwy55sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YvcxaEaq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YvcxaEaq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E8531650;
	Thu,  3 Sep 2026 09:06:52 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62C543F673;
	Thu,  3 Sep 2026 09:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451616; bh=J7TA+zV8kmgZt4wrJnZbQsqLDsJ8zbM7UZBpwa76m/c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YvcxaEaqUu7xOg2JVbn6D6bN36ItxpJ68KGeHRUloC90DnMx3E7N8V+rcB3cDiuRd
	 +No+xpPZO2lgW2+Og5j9N8K3A2Ixoi0d/lHnapen+RfIiA5TNpAR3/Ez/Ac6NhDI3n
	 6nyns/D1mk0yrzClcL40VXoB2GLQxNwJ3hjsW+3I=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 10/28] HACK! KVM: arm64: Disable SPE virtualization if nested virt is enabled
Date: Thu,  3 Sep 2026 17:06:05 +0100
Message-ID: <20260903160623.315525-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
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
index b9cee4cf293d..763b102dc51f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1640,6 +1640,11 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	    !test_bit(KVM_ARM_VCPU_PMU_V3, &features))
 		return -EINVAL;
 
+	/* TODO: NV support */
+	if (test_bit(KVM_ARM_VCPU_SPE, &features) &&
+	    test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
+		return -EINVAL;
+
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
-- 
2.43.0

