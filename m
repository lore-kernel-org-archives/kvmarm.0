Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164F81C86EF;
	Wed, 21 Aug 2024 15:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254873; cv=none; b=s8VZi67H/JQB75LRTe8zkWRnpXWtiiccJMC5gB7ce1CWxljak6mYDDlHJy7Cx0hjrw33pLek1QjZjLJGPDnrEwiYvc7jL8TGtkNztorX0kW04FESytupzxt15fpYvRxmde3j0iIc2uSYR35BCbbKL1axSIie950m0HDZtJcXc54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254873; c=relaxed/simple;
	bh=wXmusIbL5drF/uU1R2zcQMLdKmg4O+4YeAcdA3ErzVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uancJpAR81rtMVlTMG/esvRFbTlfwbbZ/Qf8MzznQaJgljJJ5bKTrEkX0DpSbK3rDQMgDOyWKh7hB+P45mGgB0M6q0e5meVcx1LdcwNDPu93HdzPXBtRl3wICVZPthz4z1lJcnGzJz4xXU6xRrP9ZfA/pFQew9mTtD9sWxgCpyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B5E5DA7;
	Wed, 21 Aug 2024 08:41:37 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.37.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A947A3F73B;
	Wed, 21 Aug 2024 08:41:07 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>
Subject: [PATCH v4 34/43] kvm: rme: Hide KVM_CAP_READONLY_MEM for realm guests
Date: Wed, 21 Aug 2024 16:38:35 +0100
Message-Id: <20240821153844.60084-35-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821153844.60084-1-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For protected memory read only isn't supported. While it may be possible
to support read only for unprotected memory, this isn't supported at the
present time.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe815a0d20bf..bd79a928d036 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -374,7 +374,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ARM_PSCI:
 	case KVM_CAP_ARM_PSCI_0_2:
-	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
@@ -388,6 +387,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_COUNTER_OFFSET:
 		r = 1;
 		break;
+	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_SET_GUEST_DEBUG:
 		r = !kvm_is_realm(kvm);
 		break;
-- 
2.34.1

