Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695665;
	b=FDPxMLDNL0VAWpnj36v2CW3Rs99hOuIqwa+ZXk0iZSQ5CAs+8mxmTQt4XXsXhA+RRt5e
	 cm6lWSsbKK8WDauy4HEDwfIQ+cyl11raVWhZJHGk/lW3380ir+33nqr1z+r0d8tJ6CmY3
	 fWH0djN2gjeaZeNKga1UUnQe/UF62LQb+L32aievoHt0z64VKVym9DZHnyTROQ5tD/pwr
	 Sxa8z0DkeH2HpPMZgpuOzmkvtFGBnnY/a4ZoJ0rFD/ooHNZEXpvwStnYUrUOWlGe6i+lb
	 PJP/G/DZj6yVa0W4HxbNbcMMpWcYuRGKYQQHm4iQUZW24SdeozEhZrYEjRrrP2G7++w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695665;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OILCjqp4rpCuWLpYe1vtBX1qnrLQcf8UfE34EzygRjs=;
	b=b2w5ER7nW2TnEi95JO6DBowWkfkHzANiSo8utgsd9mQSsLPkcPC7EIUg/+Kp3Xx+ajH0
	 hLNvo68YP9utKvjUjmvqvdhMNYxvDMlLR2Txv/8bEpIyIfjgIdbUCQBU1ygO3NJKKyx+H
	 pniihEBOVGHUdnKEnz45byROLTnGI4QABjGpyFYZG9f6yDJrspO2/AagfPK6UHn6mu6Cv
	 /00b+2xRXKJA7s/LBh8cbqAzs9uf2A+VyqEmJlVYyV2aNLwRfWgZPT+/n6d2lTaHOsDod
	 si+3ow0mPz9DGk0HKqAaBabibfCsGGtLsqtFxpDxtXET8TgOW1KbZcPirhgXlsDByJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TO3TIizf;
	arc=none smtp.remote-ip=91.218.175.61
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C9A606A953
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 08:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1C9A606A953
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TO3TIizf
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=w/k/7zrmyeo5I/eUYEpGuLcAIJvpXePkVLh+wDmGFys=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793695663; v=1; x=1794300463;
 b=TO3TIizf9FF/Syh31DMy7PRBV1NzEn8VfdLS+HF5htINIa0hJtO/Nv82Ebd1lZfNvj7bPSlz
 UwkiliIIeuzcyiSVBWk5EZFR3xtgN1lsp4gKYARbq09qwu1d6kxkNEZufTqlJjPXNtFeSZBKBiW
 96mbtuPCrKOFi/sXgVzRb6G8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cdb0f0ca1530150d;
	Tue, 03 Nov 2026 08:47:43 +0000
X-Mizu-Trace-ID: cdb0f0ca1530150d
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 1/3] KVM: arm64: Don't walk the whole IPA space when destroying a pKVM stage-2
Date: Tue,  3 Nov 2026 08:47:40 +0000
Message-ID: <20261103084742.1302597-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103084742.1302597-1-fuad.tabba@linux.dev>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 4ddfab5436b6 ("KVM: arm64: Reschedule as needed when
destroying the stage-2 page-tables"), kvm_stage2_destroy() steps through
the IPA space in block-sized chunks, and with pKVM each chunk is a
lookup in the VM's mapping tree. However, pKVM gives every VM the host's
IPA limit, so with LPA2 a teardown makes 2^27 lookups with 16K pages
(2^22 with 4K), nearly all of them for empty space.

Walk the mapping tree once instead, and reschedule after passing each
mapping to the reclaim or unshare helper. The unshare helper can't
reschedule itself, as the map and unmap paths call it under the
mmu_lock. A failed unshare now leaves only its own mapping behind, not
the rest of its chunk.

Fixes: 4ddfab5436b69 ("KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/mmu.c  |  7 ++++++-
 arch/arm64/kvm/pkvm.c | 17 +++++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db73..42977cf8a7f5d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1022,7 +1022,12 @@ static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
 {
 	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
 
-	stage2_destroy_range(pgt, 0, BIT(ia_bits));
+	/* pKVM walks its mapping tree, not the IPA space, and reschedules per mapping */
+	if (is_protected_kvm_enabled())
+		pkvm_pgtable_stage2_destroy_range(pgt, 0, BIT(ia_bits));
+	else
+		stage2_destroy_range(pgt, 0, BIT(ia_bits));
+
 	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
 }
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 016997288fd23..992ed3ca6bdd9 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -504,6 +504,7 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+	struct pkvm_mapping *mapping;
 
 	if (!handle)
 		return;
@@ -513,10 +514,18 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 		kvm->arch.pkvm.is_dying = true;
 	}
 
-	if (kvm_vm_is_protected(kvm))
-		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
-	else
-		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
+	/* Called once for the whole IPA space, so reschedule between mappings */
+	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
+		u64 start = __pkvm_mapping_start(mapping);
+		u64 end = __pkvm_mapping_end(mapping) + 1;
+
+		if (kvm_vm_is_protected(kvm))
+			__pkvm_pgtable_stage2_reclaim(pgt, start, end);
+		else
+			__pkvm_pgtable_stage2_unshare(pgt, start, end);
+
+		cond_resched();
+	}
 }
 
 void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
-- 
2.47.3

