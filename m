Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F65405ACF;
	Wed, 18 Mar 2026 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849386; cv=none; b=GjqEk64I8U9vxAet80e/+iBQ/ri5RUCLMiXs8tbLy6HJKuA2CfXUJV0gR1UYwj+2Mv5+jA/pzYiNxDjo5hSJAnDot7Lw32RAu0OHQUoDIxoMmT687E+zPqxY1Hu9YMBOruH5BLQvHNQBsPC5y0MXSpIVqTwbkKr5qWxZcxG9xFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849386; c=relaxed/simple;
	bh=Ai7XUWFGWwONd9zlpqRkFLNX67JxfNFg4Qa/qHT3lKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEGK+fBM1CTp5MoXHMBPtjiQC47YxoI1zJ0NH5poE+z0JQoOIEPhUXg68lb3xqiqT255HegOTYPUaUGsUTO+KzEcSJp01HfsiFLzA/3PDCHM2GcBfWxlt8NKy+RhmY+HEnODV03eEF72Hc+5OgWQr2HRoX5i0rQjgE4LrEKINNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87C17201B;
	Wed, 18 Mar 2026 08:56:15 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 809DF3F73B;
	Wed, 18 Mar 2026 08:56:18 -0700 (PDT)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v13 32/48] arm64: Don't expose stolen time for realm guests
Date: Wed, 18 Mar 2026 15:53:56 +0000
Message-ID: <20260318155413.793430-33-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v7:
 * Update the documentation to add a note about stolen time being
   unavailable in a realm.
---
 Documentation/virt/kvm/api.rst | 3 +++
 arch/arm64/kvm/arm.c           | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bc180c853faf..70911fe6d435 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9240,6 +9240,9 @@ is supported, than the other should as well and vice versa.  For arm64
 see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
 For x86 see Documentation/virt/kvm/x86/msr.rst "MSR_KVM_STEAL_TIME".
 
+Note that steal time accounting is not available when a guest is running
+within a Arm CCA realm (machine type KVM_VM_TYPE_ARM_REALM).
+
 8.25 KVM_CAP_S390_DIAG318
 -------------------------
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 61182eb0cf70..7d92ddb06460 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -469,7 +469,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

