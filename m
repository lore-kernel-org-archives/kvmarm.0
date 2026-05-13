Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CC9330675;
	Wed, 13 May 2026 13:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678448; cv=none; b=Nua/ejcvXGQ39YQYhkB7LG1AW2OxQZogXyAp5t2KKOS3qo6Ja9LfL2pLkne26IuqBvJHDhUIuPoJDNvpXbaASve4YuekHmSxR3LuqpzTZFWIFZ4x5VGOGHBStk6HISn1XsYIgkFUg58qtkI8nHgLoOS+S6xXNVoriWGwKTMKkDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678448; c=relaxed/simple;
	bh=Vo8ZmmZi5qqVTJlFrfGFu6ewMMpqqhjvVp3JgbePFdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCecKF1+VtqMTwegBpoI+/2Un980qQQnVidjFMDc52aQHN595MQugk95Nycllx4ZbEHX2BR1qSevJxndwhwpep8AoVj3LwKmxGNAqnHqCw/OFOC71xOk0eVUzfDgNGEB12suq2SZsTp4PnItOI0VIRaoMSYFJgVso2+axF866Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z5/QgpcF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z5/QgpcF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C6EE237B;
	Wed, 13 May 2026 06:20:41 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DD0E3F836;
	Wed, 13 May 2026 06:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678446; bh=Vo8ZmmZi5qqVTJlFrfGFu6ewMMpqqhjvVp3JgbePFdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5/QgpcFW7FgiX1paj+VO63eddFA9QnHFt+pj2crYGhlUahbxsuC71ETSv3kobedr
	 j61T7tiAyYM2b8XH3UE8YqNnq/7t+90T7AtFzGwFUKHVnqB7wyrHkRbxbjfl7V/HER
	 M+3zDkNCPQiSVsLjsEFj8oJUt9ZPL9vJlLn/iPTo=
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
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 27/44] arm64: RMI: Set RIPAS of initial memslots
Date: Wed, 13 May 2026 14:17:35 +0100
Message-ID: <20260513131757.116630-28-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
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
 arch/arm64/kvm/rmi.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 209087bcf399..fb96bcaa73ed 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -637,12 +637,44 @@ static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
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
 	/* Provided in later patch */
 	return -ENXIO;
 }
 
+static int set_ripas_of_protected_regions(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int idx, bkt;
+	int ret = 0;
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
@@ -890,6 +922,10 @@ int kvm_activate_realm(struct kvm *kvm)
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

