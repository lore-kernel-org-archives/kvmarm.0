Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329240;
	b=0P0t3AixQT6gCZZRBODU7iy62gQdeaFXmhPXjBBXpGMDIbVW0WF4oqJe6dbrnAj43TqF
	 nGh9j31+7HGUcPSs48C5EL62fneDNP3HspulZTwKZGZPGp4UfxyJ63zIoDIzPM2eIp55+
	 Oz5jtYos6AM2UWKDrGnPCZr33bRX6soFd6poqBzedrWQcfZz0QQ8TMiIkh3Trq43nJVQv
	 i9hAByImfqJDRB2UWB2v3ohOaYLw1NENfw0c/ND1rDH26OgdsqOhE2C4e07Uny23EAubF
	 i3QjpeW1LTh70ylCSm4IVitLyz2Pu13BzbqBmNRgzxCNg+kmPWgVSYBYOlvxZyyOj3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329240;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dCfP6OhX1xgWnjMEw/Fwz/hUIMTroe2e1vks4lC1ucM=;
	b=OBRJ6z+PEhpocPfDxfOpCJtWdQH7gG/BQHMrIL7FSzj8EIafiYBj8spQHrVSC6fNe4if
	 /FubeNuF6QepyoUEuZFv6HGFWLqShBNbrxqdoyD6zE+yRnWJUhn7X4Ir/JCDFIeDtR4bc
	 9EvVd8Oi03Di5gYzZZpnBFLlppzXJ+bKCXli0u9y4a9XRDhMpSJWU9bmR4mGpUJCpFXDA
	 gwxmYTkU8wx8kmhEgDD3rHks0n513EMdFs+ZxmeuamNYQ1yrOW2PQJMBR+1J1BymaX9Jj
	 YcX0TBNGuXY6a0tidJhk+mWhMVIpbBNQyMtEjFJUpCu9SoZ2RJQYMQfMOPp3K0VCJWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xjeHzfiM;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76418606A32A
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 16:47:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76418606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xjeHzfiM
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so19574225e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 08:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329239; x=1794934039; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dCfP6OhX1xgWnjMEw/Fwz/hUIMTroe2e1vks4lC1ucM=;
        b=xjeHzfiMwft+X3JM3amB6HbUgeuQbx1vBRBrCUM4TmtnYaei3YAOopk48mtVz994P4
         hJ6KzhI8x3BFl5MTO/hfjtEsPsR4J2d1RThGq+ThaK0+2dOroaPqpoky/yJn+yILW9QK
         LW3aMr7tZdcQ3cztnfTn2G2P2DC0Pu/Vk8UcqGWQrlosjtK6rrTZWaGL/Hky0yTYsAsJ
         xbtseLYZDFEIDe0Ld4TCv6B5dEu+BJIJX/jFGNujsYWt1PiUJEaGC7SPGaHcr+isvQAO
         1wE1i012hSIDOHCPEQTuN4ih/FUYSTfMqNlefZD+7gR/66IVdbGlxu1gfkkhXPtzqlxS
         /ymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329239; x=1794934039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dCfP6OhX1xgWnjMEw/Fwz/hUIMTroe2e1vks4lC1ucM=;
        b=MSGUS1rX9iJkUj3lH5xLNsZl9//uLi/yw6+AABjkvg87OZ70cv3UKCfiqO+t/d3E8c
         VYHr74mR9eDYoXTB5f/0x+zRgP6ROBsnuTf1b8soaefdRFw6ID+AU7iA3/kmn+LJtycu
         MO8sBWuNkAagAJ7tNZ21Orhy5pFUF5zACpbWWl0P4gn4Oi7zlweI5v7dJl/7LgOAilsJ
         ZJeyATHaS6smK8aUtupX4lhx/2lBHI+O7rXtXfUS7d22iZKwSyEgyjUNnjYKzzC3fDdL
         022BSZgxpX6psqpiQaRCBov98s+FOIJxegLeFdCvd76pjSZuu/NcmkSgQiQ+T/3fkrgq
         RlMw==
X-Forwarded-Encrypted: i=1; AL+hErGlUUlOpVdcjf3usa/VXRSvQzLYWPgMwZHpUMHMHU9Wx0Mw1obnhfB+THz9vYw/DHHw+9ouvfQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z+tKEbl+GgQq4yc2ZPIp7T2Qqh9UmG4FvPEdbTZQAFwajIw9ZM2
	3IB7+nebExSvvv9GHhz2rQtBY2F9tU9BrItazTdH2dTv9VUlMrTv4wex
X-Gm-Gg: AYBFou3lrU+loeznkE/PE6KXdyOeYoO2MozEUJuy1hoKz/BvJ0KGRcfhNLV87cagI33
	EmzNyjffnrV8hJiVAKAljtXLvaG/1TMfliP4d0yJRQyH7+FVStEBPPupOKLhS9yLJ+S38LkgWnj
	fdAQJzatyeXNebhpNB1itGDfIrR6oG4/wlQwYAr1sZlFqt7VOKJE3cBZkB9rPbaXTZ7rwiwMDhE
	S4PZ0mJRvKJm2Yo0e7V2ufFW1xPkNpBmisKTlaSjJav1Ml6fty2gIOXvSSxzCQ58OPVue/Sogul
	oYqS7ZfnB/exveD4mNqt+pOUgTVHrSIs55OC409YGr81GGyLtS8L+tzpyVUNTgy+rsAusk287gb
	P0qIXRlDeZAr/E11hIrFq863lWrNHLwzYDMu/gW4EbzGZQmtx9JrpnCda8DqVW5HMguCOAv9Q8M
	mOPWscyn5d3+EkUEzVIkyqbMkIo124s4/u1e4jnqv68rAqRtbMNmrdQjd0Q9qobAH0R1d7qqu6b
	eCxgBXcPtsp/c1wN/PqJ/Gf8nfLtfZTXX2myTjYXpr8u/OwkREYk0JNZGrLc2aFvLYzU/UY4FsS
	PNMYVFcqL5Pp/7i2Dmcxvp7Vr8fAPFqWGTbAM9P7Cc20MobowSAjMdSqw8G40QeQM2NxR0rQNZC
	Rv4Ta7/Yc6pzbSpe4wfd05sJd
X-Received: by 2002:a05:600c:8b21:b0:4a7:a5db:a93e with SMTP id 5b1f17b1804b1-4ba023085c6mr53018695e9.4.1794329238548;
        Tue, 10 Nov 2026 08:47:18 -0800 (PST)
Received: from PKL-HASEEBA-LT.. ([39.36.65.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fe9357sm84905075e9.9.2026.11.10.08.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 08:47:17 -0800 (PST)
From: Haseeb Ashraf <haseebashraf091@gmail.com>
To: maz@kernel.org,
	Oliver Upton <oupton@kernel.org>
Cc: Haseeb Ashraf <haseeb.ashraf@siemens.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	fahad.arslan@siemens.com,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Resume stage-2 unmap where the walk stopped
Date: Tue, 10 Nov 2026 21:47:06 +0500
Message-ID: <20261110164706.582879-2-haseebashraf091@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110164706.582879-1-haseebashraf091@gmail.com>
References: <20261110164706.582879-1-haseebashraf091@gmail.com>
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

From: Haseeb Ashraf <haseeb.ashraf@siemens.com>

kvm_vm_stage2_unmap_range() unmaps a range one block-sized chunk at a
time. The walker steps over an invalid entry in one go, but the next
walk starts at the following chunk, so an invalid entry larger than a
chunk is visited once for every chunk it covers. Unmapping the whole
IPA space of a shadow stage-2, as emulating TLBI VMALLS12E1IS and TLBI
ALLE1IS does, takes 2^18 walks with 4K pages and a 48-bit IPA space,
however little it maps. Each walk also ends with a range TLBI when
FEAT_TLBIRANGE and FWB are available.

On an AmpereOne A192-32X (192 CPUs, Xen on KVM, 4K pages, 48-bit IPA),
a full-range unmap of one shadow stage-2 took 0.82-0.94 s (mean 0.91 s
over 192 unmaps) on 6.18.29. With this change and the mainline commits
it builds on backported, it took 2.1-27.8 ms (mean 3.8 ms over 128
unmaps), with 512 to 1024 walks instead of 262144. A TLBI VMALLS12E1IS
trap that unmapped two shadow stage-2s took up to 1.85 s before.

Add kvm_pgtable_stage2_unmap_range(), which returns the address its
walk reached, and have the unmap loop resume from there.
kvm_pgtable_stage2_unmap() still returns 0 or an error, for its
callers at EL2. The walk handles every entry it steps over, including
invalid entries that carry state, so nothing has to be looked up
beforehand.

The unmap of a shadow stage-2 also drops the guest stage-2 records of
the whole span the walk covered: nothing is mapped in the part it
stepped over, so any record there is stale. Each walk that remains
ends with the same deferred TLB invalidation as before. The spans that
were skipped have no valid entry, so there is nothing to invalidate.

Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Haseeb Ashraf <haseeb.ashraf@siemens.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 22 ++++++++--
 arch/arm64/kvm/mmu.c                 | 63 +++++++++++++++++++++++-----
 3 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1c9c57c..4ed096f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -725,6 +725,24 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
  */
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_unmap_range() - Remove a mapping from a guest stage-2
+ *                                    page-table, and report where the walk
+ *                                    stopped.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @addr:	Intermediate physical address from which to remove the mapping.
+ * @size:	Size of the mapping.
+ *
+ * Same as kvm_pgtable_stage2_unmap(), but the walk can end past @addr + @size
+ * when it steps over an invalid entry that extends beyond the range. Nothing
+ * is mapped up to the address that is returned, so a caller that unmaps a
+ * larger range in chunks can resume from it.
+ *
+ * Return: the address the walk reached, which can be past @addr + @size, or a
+ * negative error code on failure.
+ */
+s64 kvm_pgtable_stage2_unmap_range(struct kvm_pgtable *pgt, u64 addr, u64 size);
+
 /**
  * kvm_pgtable_stage2_wrprotect() - Write-protect guest stage-2 address range
  *                                  without TLB invalidation.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837..b02f548 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1197,7 +1197,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+s64 kvm_pgtable_stage2_unmap_range(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	int ret;
 	struct kvm_pgtable_walker walker = {
@@ -1205,13 +1205,29 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 		.arg	= pgt,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
+	struct kvm_pgtable_walk_data data = {
+		.walker	= &walker,
+		.start	= ALIGN_DOWN(addr, PAGE_SIZE),
+		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
+		.end	= PAGE_ALIGN(data.addr + size),
+	};
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = _kvm_pgtable_walk(pgt, &data);
 	if (stage2_unmap_defer_tlb_flush(pgt))
 		/* Perform the deferred TLB invalidations */
 		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
 
-	return ret;
+	if (ret)
+		return ret;
+
+	return data.addr;
+}
+
+int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	s64 ret = kvm_pgtable_stage2_unmap_range(pgt, addr, size);
+
+	return ret < 0 ? ret : 0;
 }
 
 struct stage2_attr_data {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8..55a3cb5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -319,22 +319,64 @@ static void invalidate_icache_guest_page(void *va, size_t size)
 	__invalidate_icache_guest_page(va, size);
 }
 
-static int kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt,
+static s64 kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt,
 					    u64 addr, u64 size);
 
+/*
+ * Unmap [start, end) one chunk at a time, resuming from the address that each
+ * walk reached. An invalid entry that is larger than a chunk is then stepped
+ * over once, rather than once for every chunk that it covers.
+ */
+static int stage2_apply_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
+				    phys_addr_t end,
+				    s64 (*fn)(struct kvm_pgtable *, u64, u64),
+				    bool resched)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	bool lock_dropped = false;
+	phys_addr_t addr = start;
+	u64 next;
+	s64 ret;
+
+	do {
+		struct kvm_pgtable *pgt = mmu->pgt;
+
+		/*
+		 * We may be raced on PGT teardown when we release the
+		 * kvm->mmu_lock. That's fine as the PGT is legitimately no
+		 * longer present.
+		 */
+		if (!pgt)
+			return lock_dropped ? 0 : -EINVAL;
+
+		next = stage2_range_addr_end(addr, end);
+		ret = fn(pgt, addr, next - addr);
+		if (ret < 0)
+			return ret;
+
+		next = min_t(u64, ret, end);
+		if (resched && next != end) {
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+			lock_dropped = true;
+		}
+	} while (addr = next, addr != end);
+
+	return 0;
+}
+
 static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
 				      phys_addr_t start,
 				      u64 size, bool may_block)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	int (*fn)(struct kvm_pgtable *, u64, u64);
+	s64 (*fn)(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		fn = kvm_pgtable_stage2_unmap_tracked;
 	else
-		fn = kvm_pgtable_stage2_unmap;
+		fn = kvm_pgtable_stage2_unmap_range;
 
-	WARN_ON(stage2_apply_range(mmu, start, start + size, fn, may_block));
+	WARN_ON(stage2_apply_unmap_range(mmu, start, start + size, fn, may_block));
 }
 
 static void pkvm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
@@ -375,16 +417,17 @@ static void no_stage2_unmap_range(struct kvm_s2_mmu *mmu,
  * does.
  */
 
-static int kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt, u64 addr, u64 size)
+static s64 kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
-	int ret;
+	s64 ret;
 
-	ret = kvm_pgtable_stage2_unmap(pgt, addr, size);
-	if (ret)
+	ret = kvm_pgtable_stage2_unmap_range(pgt, addr, size);
+	if (ret < 0)
 		return ret;
 
-	kvm_remove_guest_s2_mappings(pgt->mmu, addr, size);
-	return 0;
+	/* The walk may have stepped over invalid entries: any record there is stale. */
+	kvm_remove_guest_s2_mappings(pgt->mmu, addr, ret - addr);
+	return ret;
 }
 
 /**
-- 
2.43.0

