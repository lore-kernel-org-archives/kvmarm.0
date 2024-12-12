Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA53242EFC;
	Thu, 12 Dec 2024 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019162; cv=none; b=K4b3AgrYKA7nMR3L9zQtspsCfd7kLPzy1Sgxmfk1+tNQlXvPl6PtB/Nlhn3W4l4j5JSUj0rGW7u4drJhxdLDrwdrYH99RO2zyZacP5djif59xSFcRG/zE1af7txxIlTxpDE5zytR/PEz+L1ExXQH4d1OX9T3zIXq7tI5nZ6e9WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019162; c=relaxed/simple;
	bh=dkvWObTafw3QyIlhb9mcS/ryypStWAlH+FQHXYW2rrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/NNdR0AT1yfntJcQ7gBsCieMPTgTSADVq7NthS+H/zSjfoUSZgKG3mwP0YCWhLj08F1v3U/nPD0KEeSic9+uX1mxz2hAbBTl5uNQHTPqRy33zEWn3WH/Cri9BciQm9/ThDKjBkeANV0ld2jjhlBBg9O/PyYQqbTihA7YH64nQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A1041A25;
	Thu, 12 Dec 2024 07:59:47 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.39.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E52E3F720;
	Thu, 12 Dec 2024 07:59:15 -0800 (PST)
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
Subject: [PATCH v6 42/43] KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
Date: Thu, 12 Dec 2024 15:56:07 +0000
Message-ID: <20241212155610.76522-43-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241212155610.76522-1-steven.price@arm.com>
References: <20241212155610.76522-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Increment KVM_VCPU_MAX_FEATURES to expose the new capability to user
space.

*NOTE*: This also exposes KVM_ARM_VCPU_HAS_EL2 (as it is one less than
KVM_ARM_VCPU_REC) - so this currently depends on nested virt being
'finished' before merging. See below for discussion:

https://lore.kernel.org/r/a7011738-a084-46fa-947f-395d90b37f8b%40arm.com

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 837e2d29609d..df3168cbe70a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -40,7 +40,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 9
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
-- 
2.43.0

