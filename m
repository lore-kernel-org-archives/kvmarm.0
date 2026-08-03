Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1E243230D;
	Mon,  3 Aug 2026 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764790; cv=none; b=MCgj4H7Ns+cSEqItLTTqD05yAAEXiMLeR8BGq7EvfICoplc+f1+Owxrjp9LoJNQhnNzrkU7QZntlbUvfGT0iedDvCU/bK6GSYVZNliGI0Z+d/0h7WXbdekdHC93z6lHL3CsBY8ekvJPiUwGSo1sYX1IB5uspfV9M+MDSdc9getc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764790; c=relaxed/simple;
	bh=W30500oBfBmJ6/xAl04uVtK46drltLrN652Rd4ULSFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5iCf6F74tWOWyg8Gpz1Fx7OJffJ4yK7sn3daGkOsabzOeZRGk9QhKwaIVB68K4WpMAXy8wCiujp3lHffxpFUumW+JMQIBlio7hW1Yza/thFCN8n0x/4faVohZoMFQB+4cn5/hpK8Zg/XScyKQSLA1CL0ygO45xu2DvpG7iHpdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=d5xcZQy4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="d5xcZQy4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 661011476;
	Mon,  3 Aug 2026 06:46:24 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94A513F66F;
	Mon,  3 Aug 2026 06:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764788; bh=W30500oBfBmJ6/xAl04uVtK46drltLrN652Rd4ULSFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5xcZQy4139yVmA+Nhewrcaf6jL53MCaYkcke2saHsgyRXhcUeEM19vnEHK2ZqEHs
	 MkUl9T8z39xWuDpxYv98F0LWDYyt8HG3KOjVEWXUrY4knAKm4Lq5MD/ppD99horeVo
	 wGJA66zSUO0YMdnMaEtHcoDEvyh3VGNP8z5EYXLk=
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
Subject: [PATCH v16 28/45] KVM: arm64: CCA: Set RIPAS of initial memslots
Date: Mon,  3 Aug 2026 14:43:44 +0100
Message-ID: <20260803134403.80630-29-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
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
index d18c241f7eb2..4f362fd21477 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -779,6 +779,14 @@ static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
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
@@ -797,6 +805,32 @@ static int realm_ensure_created(struct kvm *kvm)
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
@@ -1084,6 +1118,10 @@ int kvm_activate_realm(struct kvm *kvm)
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

