Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90C5478E33;
	Wed, 15 Jul 2026 14:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125839; cv=none; b=GUbI/8cf9xEJ3ock62QHS3g6sHI6QWfweTgopFUnv8qSpOyXUpTUGo16Th8xaYqdKnEMLwGZmengfe0Z/O2YohbVwfnxUDN8PDd/8EGS3wTBYlaBhkFRo4UXpXU/c6s/i0RCypLAc5kbchbyO+fObwi/lSxfSN52mKmOM1adVl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125839; c=relaxed/simple;
	bh=LVpTnAu3uJ7T4L4lsdBjk/5iVJcIHD+HZJ2BNsxHVGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kp5LjnFCh42NhS5ZfQ5o0mOp9mq3kBF9ZrX0GZgpU2l2M9apP8cQPRapDBVfJQ21mTvcnRMZ0BMkm2Tbr5zVYtI1V8pZpcF/SKFVCoRBZND/8rxoQSFVKP2J1XPcJNXL2D0jwLNHo/Iesh4KQb3abMAvVXa727zL56xYOyKffMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L51nJ+Pe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L51nJ+Pe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6E29153B;
	Wed, 15 Jul 2026 07:30:32 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAC633F7B4;
	Wed, 15 Jul 2026 07:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125837; bh=LVpTnAu3uJ7T4L4lsdBjk/5iVJcIHD+HZJ2BNsxHVGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L51nJ+PeMf42u5bZ/OygcSXpLA79Ko5eeRp/7BAjXRHVtmH85QuqSHNoAc1yovfC5
	 oV+1iyurEkn428aJ6w3R3sQVLujFTC3g7bGfMGirRShwxLVNjjRymVliH84EtN476w
	 q13Y3mniOWGS+TQ2gC0f5nhPbzgcNZxnK63FIBHc=
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
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v15 21/37] KVM: arm64: CCA: Set RIPAS of initial memslots
Date: Wed, 15 Jul 2026 15:28:23 +0100
Message-ID: <20260715142841.80544-22-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142841.80544-1-steven.price@arm.com>
References: <20260715142841.80544-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory which the realm guest accesses must be set to RIPAS_RAM.
Iterate over the memslots and set all gmem memslots to RIPAS_RAM.

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v12.
---
 arch/arm64/kvm/rmi.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index e2b4c64e982d..1e6c04145f6c 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -757,6 +757,14 @@ static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static int realm_init_ipa_state(struct kvm *kvm,
+				unsigned long gfn,
+				unsigned long pages)
+{
+	return ripas_change(kvm, NULL, gfn_to_gpa(gfn), gfn_to_gpa(gfn + pages),
+			    RIPAS_INIT, NULL);
+}
+
 static int realm_ensure_created(struct kvm *kvm)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
@@ -775,6 +783,32 @@ static int realm_ensure_created(struct kvm *kvm)
 	return realm_create_rd(kvm);
 }
 
+static int set_ripas_of_protected_regions(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int idx, bkt;
+	int ret = 0;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	slots = kvm_memslots(kvm);
+	kvm_for_each_memslot(memslot, bkt, slots) {
+		if (!kvm_slot_has_gmem(memslot))
+			continue;
+
+		ret = realm_init_ipa_state(kvm, memslot->base_gfn,
+					   memslot->npages);
+		if (ret)
+			break;
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return ret;
+}
+
 int kvm_arm_rmi_populate(struct kvm *kvm,
 			 struct kvm_arm_rmi_populate *args)
 {
@@ -1045,6 +1079,10 @@ int kvm_activate_realm(struct kvm *kvm)
 			return ret;
 	}
 
+	ret = set_ripas_of_protected_regions(kvm);
+	if (ret)
+		return ret;
+
 	ret = rmi_realm_activate(virt_to_phys(realm->rd));
 	if (ret)
 		return -ENXIO;
-- 
2.43.0

