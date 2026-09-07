Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3398923815B
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764424; cv=none; b=LXjW+KUY/cPpG1mPxv2IRpCeaOMdqQYeQecLhU8mnjBzu5hy+cuvKm/7plPikN7GT/fGUgniFWbYH3mGw852WWqcSJhuY7VFb+Qz9BhpDcnlq4ATSrKX9hWt3z4IivGTGUqzQxIyht8i4/uBVRSglFx6Qq9pYqb/aaYLw38D0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764424; c=relaxed/simple;
	bh=PK1z4T8+HJA4CmHfQi7yiSBW4CDCz2oM5Ruw56h1rLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hoeSQYHIcRnVNuwtHttKvWUCkc3GxDUBbMnG8SLatipDK0h3CrJzYR8Q3KHjOwL1TRPaSYBJ4/kO/sQkNrqTFvsEW6V+KCR4T8/ZRSasn3bbERD+sZNY4SGFu/rgI8b4zA8foay2wHKn6nk674LnXF9am7TK1NAWDgHKOWtrCU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KIAJh8wv; arc=none smtp.client-ip=91.218.175.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KIAJh8wv"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PK1z4T8+HJA4CmHfQi7yiSBW4CDCz2oM5Ruw56h1rLM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764421; v=1; x=1789369221;
 b=KIAJh8wvoMZVe8f+WnnXTzrEEeNxpQoEXly03XKOnbZM6Tikcmzz3BHEjfH87x7Ua5LfOTpy
 X/Rrsj/2gN//A6JO8jRP/PFwCB6CRcex4RyaQcVD6nYZff2G3eGhKU5ynXoxda24qqRCB13EN3P
 XYxmweHod7U3LWNm4X1E/Q1I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1bd4e47017fc79c9;
	Mon, 07 Sep 2026 07:00:07 +0000
X-Mizu-Trace-ID: 1bd4e47017fc79c9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 02/17] KVM: arm64: Reject the PVTIME vCPU attribute for protected VMs
Date: Mon,  7 Sep 2026 07:59:47 +0100
Message-Id: <20260907070002.3333525-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260907070002.3333525-1-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM currently doesn't support steal time for protected guests:
KVM_CAP_STEAL_TIME reports 0 for them. The host still accepts the
KVM_ARM_VCPU_PVTIME_CTRL attribute, whose IPA would point
kvm_update_stolen_time() at the guest's private memory on every vCPU
load. Return -EPERM for the attribute group instead.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/guest.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b01d6622b8720..ab659795d4b2f 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -916,6 +916,10 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 		ret = kvm_arm_timer_set_attr(vcpu, attr);
 		break;
 	case KVM_ARM_VCPU_PVTIME_CTRL:
+		/* Steal time is not advertised to protected guests. */
+		if (vcpu_is_protected(vcpu))
+			return -EPERM;
+
 		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
 		break;
 	default:
@@ -939,6 +943,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 		ret = kvm_arm_timer_get_attr(vcpu, attr);
 		break;
 	case KVM_ARM_VCPU_PVTIME_CTRL:
+		if (vcpu_is_protected(vcpu))
+			return -EPERM;
+
 		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
 		break;
 	default:
@@ -962,6 +969,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 		ret = kvm_arm_timer_has_attr(vcpu, attr);
 		break;
 	case KVM_ARM_VCPU_PVTIME_CTRL:
+		if (vcpu_is_protected(vcpu))
+			return -EPERM;
+
 		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
 		break;
 	default:
-- 
2.39.5

