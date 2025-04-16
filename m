Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3EF1FBEBE;
	Wed, 16 Apr 2025 13:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811168; cv=none; b=rQlRrzE6Bzi9EiPr2riKD5q+yB1tP9Z6ZLU2zjI7URjKeXif/CNKPxrfZtwYpgX8bJa4oCABPoTIYerkGqbriW8ibZHWWGmFcAin8P4ZsVnbKH/eo1S2A17ZDmUjW26N5YTSuj8ttPEydB8lSDZY71S5v1I/9lKXcRepQUx5uSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811168; c=relaxed/simple;
	bh=NtZ/MNTJvzn6PbTwyWQmI+s96F1OqWPvwxXaeXse6B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtQIyMLl8+besjw6o7LrxjbEYorIl94y0ozN2gexS2UIRgSCqGAngrbcHd+t0OsPLlgcgg2vWSh6N/Rys7bjge4kbbUqxaaNMNFji5IrQgPr2xLKzlI57ihpl5xrij5uFD8QUBcWKOnHTECkBOty81FmOZn//v603Ab36FWzy4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE75F1E7D;
	Wed, 16 Apr 2025 06:46:03 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.90.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 915AC3F59E;
	Wed, 16 Apr 2025 06:46:01 -0700 (PDT)
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
Subject: [PATCH v8 33/43] arm64: RME: Hide KVM_CAP_READONLY_MEM for realm guests
Date: Wed, 16 Apr 2025 14:41:55 +0100
Message-ID: <20250416134208.383984-34-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250416134208.383984-1-steven.price@arm.com>
References: <20250416134208.383984-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For protected memory read only isn't supported by the RMM. While it may
be possible to support read only for unprotected memory, this isn't
supported at the present time.

Note that this does mean that ROM (or flash) data cannot be emulated
correctly by the VMM as the stage 2 mappings are either always
read/write or are trapped as MMIO (so don't support operations where the
syndrome information doesn't allow emulation, e.g. load/store pair).

This restriction can be lifted in the future by allowing the stage 2
mappings to be made read only.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v7:
 * Updated commit message to spell out the impact on ROM/flash
   emulation.
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8060e25afbd0..4780e3af1bb9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -340,7 +340,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ARM_PSCI:
 	case KVM_CAP_ARM_PSCI_0_2:
-	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
@@ -355,6 +354,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_SET_GUEST_DEBUG:
 		r = !kvm_is_realm(kvm);
 		break;
-- 
2.43.0

