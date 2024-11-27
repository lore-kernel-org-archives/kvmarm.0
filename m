Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FF11F9A9F
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732719424; cv=none; b=DYS3PyOabbxlHV/lZG/uqMnBTg+1Csh3SK22HVFKjGpKq9soCp2FUL9/Bu5XYcpS6BVUzkupd++JQaUuOg3YrVXN8e8X6NTvII49G61L4MKj4RsjdjyABZGpcl7+Mm2AIahJkFGHx4lIbY90Cs2NNBbyy5lgc8WxeRPYgqix8ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732719424; c=relaxed/simple;
	bh=/Ot4oxvlB+fxqPbCQnBzcP18mMeEKhrm2uVJP0I/n70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QA7MEjgKZl5GAdZD7vQ1cJyrmABz6C5weyMFxFZUngFTTAk1goPBr1JsTLyXq8ZzMdvx3KVT7NotJbQptc65z1lYOHlxQi9anzU3bGClM8TqxN5U/4DCNdQSyy41pSThUQuttBy0pAy+Q0sY/+cOY5H158g9jELH/4ZHIIPmk1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B31C1477;
	Wed, 27 Nov 2024 06:57:30 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.69.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B85D3F58B;
	Wed, 27 Nov 2024 06:56:57 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Cc: Steven Price <steven.price@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Bump KVM_VCPU_MAX_FEATURES
Date: Wed, 27 Nov 2024 14:56:31 +0000
Message-ID: <20241127145644.421352-1-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the KVM_ARM_VCPU_HAS_EL2 define was added, the value of
KVM_VCPU_MAX_FEATURES wasn't incremented, so that feature has never been
in the KVM_VCPU_VALID_FEATURES bit mask. This means the HAS_EL2 feature
will never be exposed to user space even if the system supports it.

Fixes: 89b0e7de3451 ("KVM: arm64: nv: Introduce nested virtualization VCPU feature")
Signed-off-by: Steven Price <steven.price@arm.com>
---
I might be missing something, and it's possible that
KVM_ARM_VCPU_HAS_EL2 is deliberately not exposed yet. However I'm
working on v6 of the host CCA series and as part of that want to add a
new feature but and bump KVM_VCPU_MAX_FEATURES up to 9.

 arch/arm64/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a..af7c827b216e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 8
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
-- 
2.43.0

