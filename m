Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E4C3542D4
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333904; cv=none; b=UQsAQjHdzegHAXk34/lXWx/uCjZo1uZeH8V+8TYlhs+4Mksolsl52IaDyqHPTHvsoIWYkS/KjOsoAbTH4EIqQQ4flYCaYXjoM41MK3k60pRV2JBxBceNhFiQ+vLRU0KJ48iryCG9DVcf8+o12VF+9zm3Y6urpSTiuIpdVUQTvEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333904; c=relaxed/simple;
	bh=sRMf8iKM0NV4389HiXRgySDOyEsPpVMcCrowfvib0lE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H4cKgTY66jckyC8BNc8FVqGWkTXxO4RgtEONfZ8NeDcfEOSfP/jZc+g6xaCJi41QM2dDbyRQ7hY3u8aIUfaLe72QyNK56q2P3hbvcccWWr91zY/UDIxIKzAHl7taQ8CodbFacnygYCD4Tz+eZ+5HcjxE1rIZvBR/ZkAxR4xXhOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nmmu6IaO; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nmmu6IaO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783333898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e/ipqegKk/EDFfUXsHGBuepdJETo3GeI79VTrPNPXuo=;
	b=Nmmu6IaOrdu6PBW/jnkewszoEC/rWSD1PRGq5VlcO3nSUoGX0RRL/cU+kCeymTymlnW5GX
	NXTfN77zactK172DKBzUvh4R8VrNeKzrU0rx7uWb7avw40TYpRVgw7XUuZT64QgUvPUuZf
	RtgdErx9A8biXmpazxNXQ0MRDAZdyGY=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Keir Fraser <keirf@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()
Date: Mon,  6 Jul 2026 11:31:29 +0100
Message-Id: <20260706103129.706974-4-fuad.tabba@linux.dev>
In-Reply-To: <20260706103129.706974-1-fuad.tabba@linux.dev>
References: <20260706103129.706974-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

is_created is written under config_lock. Every concurrent reader is
serialised against that write: pkvm_create_hyp_vm() under config_lock,
and the memslot path (kvm_arch_prepare_memory_region) via slots_lock,
which the creation writer also holds. The teardown-path accesses have no
concurrent writer. The read is therefore serialised, and the READ_ONCE()
is unnecessary.

Reviewed-by: Keir Fraser <keirf@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pkvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 67b90a58fbea2..008766273912e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -185,7 +185,11 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 
 bool pkvm_hyp_vm_is_created(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.pkvm.is_created);
+	/*
+	 * Serialised by config_lock/slots_lock, or by VM lifecycle at
+	 * teardown, so a plain read suffices.
+	 */
+	return kvm->arch.pkvm.is_created;
 }
 
 int pkvm_create_hyp_vm(struct kvm *kvm)
-- 
2.39.5

