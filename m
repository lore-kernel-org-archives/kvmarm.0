Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62AD528302B;
	Thu, 13 Feb 2025 16:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463401; cv=none; b=l2FShm/XzEuxRry6w8kDw5AwtzuNtCLHLduRdGCRs+68JTOdYaoA8gj/X5+Eke8zn5U66YclICyXABWpZYpnWus5XXMiZNoGfw4xzaDdwGQjxSyVVjPehELpjfgsDwUW30TBL05UIaAUEnKcUU2C1b6w34kSnp4sX8bEJbq21NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463401; c=relaxed/simple;
	bh=5/Wv4roDFR5pN7vczGfekW5rqfIGe4zsbFQv+4bSHIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/xZb6dNxD+vdc/Lo3LU5MuA4n89TpwaSJhXIeKvn73s2IOgZBHZuqUDi7qIA7RWvMGYcuV1BxD1VnTIpLJM/CeipMqs7u1UsSDmQYrLi5QXz9jZvwzFQVklkrPKhi4dmPI/0cK9JXjyIpuSOg59L6ohlcNjuQQOPHvg1/LzU9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A441526BA;
	Thu, 13 Feb 2025 08:17:00 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.32.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 875823F6A8;
	Thu, 13 Feb 2025 08:16:35 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 26/45] arm64: Don't expose stolen time for realm guests
Date: Thu, 13 Feb 2025 16:14:06 +0000
Message-ID: <20250213161426.102987-27-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250213161426.102987-1-steven.price@arm.com>
References: <20250213161426.102987-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It doesn't make much sense as a realm guest wouldn't want to trust the
host. It will also need some extra work to ensure that KVM will only
attempt to write into a shared memory region. So for now just disable
it.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a6718dec00c9..79d541c95bfb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -403,7 +403,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = system_supports_mte();
 		break;
 	case KVM_CAP_STEAL_TIME:
-		r = kvm_arm_pvtime_supported();
+		if (kvm_is_realm(kvm))
+			r = 0;
+		else
+			r = kvm_arm_pvtime_supported();
 		break;
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
-- 
2.43.0

