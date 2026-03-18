Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B903FAE03;
	Wed, 18 Mar 2026 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849318; cv=none; b=XCetiSAHhqE9N5AMn49P5enPF1oiB60nBuQszwrlumg7CeddJBmPfAtE0bIKHVx82S29Ji+vx+ODc9l7JO/Jle6KisOrk+AOKg3FDbthyNUwJBjzxh0dFVoJfQ1VqrXpd6tQOxXW0Ms42kHYRabfhavMXoMinHCfwr/F0dELtLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849318; c=relaxed/simple;
	bh=tREyKjSLOxG+2m3J40cj4DKH58HgiXmTvScOgJAtTRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5vo2O1kR0MeFwdwuNpgRKYDpF9MYirs44d8QjRSN9s03CnOWaUY2SK2rabM6veTb2rwIntrz23uu7JZMn9Ks9D1Dv3DmQ+2KQquLPNpxIbbMqYeSvGXubvt2TD07rYa6+csc5D7rpy95vIzsiJxOkDBJkJKo/Winp2VkpD9Q+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CB692008;
	Wed, 18 Mar 2026 08:55:07 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26D703F73B;
	Wed, 18 Mar 2026 08:55:10 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v13 13/48] kvm: arm64: Don't expose unsupported capabilities for realm guests
Date: Wed, 18 Mar 2026 15:53:37 +0000
Message-ID: <20260318155413.793430-14-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

RMM v1.0 provides no mechanism for the host to perform debug operations
on the guest. So limit the extensions that are visible to an allowlist
so that only those capabilities we can support are advertised.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v10:
 * Add a kvm_realm_ext_allowed() function which limits which extensions
   are exposed to an allowlist. This removes the need for special casing
   various extensions.
Changes since v7:
 * Remove the helper functions and inline the kvm_is_realm() check with
   a ternary operator.
 * Rewrite the commit message to explain this patch.
---
 arch/arm64/kvm/arm.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9b17bdfaf0c2..ddbf080e4f55 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -357,6 +357,25 @@ static bool kvm_has_full_ptr_auth(void)
 		(apa + api + apa3) == 1);
 }
 
+static bool kvm_realm_ext_allowed(long ext)
+{
+	switch (ext) {
+	case KVM_CAP_IRQCHIP:
+	case KVM_CAP_ARM_PSCI:
+	case KVM_CAP_ARM_PSCI_0_2:
+	case KVM_CAP_NR_VCPUS:
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+	case KVM_CAP_MSI_DEVID:
+	case KVM_CAP_ARM_VM_IPA_SIZE:
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+	case KVM_CAP_ARM_RMI:
+		return true;
+	}
+	return false;
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
@@ -364,6 +383,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
 		return 0;
 
+	if (kvm && kvm_is_realm(kvm) && !kvm_realm_ext_allowed(ext))
+		return 0;
+
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 		r = vgic_present;
-- 
2.43.0

