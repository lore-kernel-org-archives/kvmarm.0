Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794979024;
	b=e25PQKReyfNcxn0c0wcgxd4uOiW+Gid+UB606kz1qNeqT0wiYO/VFYkMm5aWw+nEBEQi
	 7JzkKSM+aCJEEmRuVui8Uw/OuNNf0qWr1j3l+v2hD3Cvtb8lrFwlF38yhdSOr1NkGsamz
	 mknN6cbhJWpHO0r57ADaNGzV4P07HCr4zrb3DUzkPuk0OFzktAOuVDyHQ3FsRxVfeRvss
	 9Ra6BujS0ck7l8x/35T4i3do6rSfN4C8NrEPl/1+uRAO2Y0f21Pbcu89wYe4243PsXAOR
	 70aas6H/MIi+PbL/nb649dwXvFL0BoBlNz6mk8Xc/+Lm0wxxngTO5OATCfhU9v/AfuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794979024;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=emIFi9MtfIR7SpLGE9qwf6+LtUi3bsONfmSNGbybc/g=;
	b=VWgAejDbmuyxyWhv4iV6mX3a1zfxLSGGEz+DfHKLlB/6EyxUVEFbC1ZKaK2Ty4yt6/WY
	 +te+BwDuIwQrH/8ngTrXyx76scK5kdP28vigOuGAiBDV0dH7R3Ak84otX1sDCuU2VRZEp
	 Wf0CBNMSa8FAJxYYcsFM6e6FgTn0R2rq3A2rncWsPka46ziMD0InBfnJPPH5wVubwMyFX
	 KkHUvC8h8eVWg6rQj3Epgz9eqWbaPFx+DWKUWIl986m0pTV38eTYlkdrq79fHDUPOHwce
	 xj0GGItvufpPX35LMiVreH3JPPubloilZXunSKCgmSXqAbdSS9vD/VHKfhuXPfxYO/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OwvOI74n;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B742606A325
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 05:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B742606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OwvOI74n
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso8805105e9.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 21:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794979023; x=1795583823; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=emIFi9MtfIR7SpLGE9qwf6+LtUi3bsONfmSNGbybc/g=;
        b=OwvOI74nt/3xceHTt0fxMlGuSE1a2YlPPEBJc1n3NJbJEmYgjFgSKmCFkaPdAQNsDz
         UBVAC1JBAaIBZCnXdp7NrGhoRnIyB6MMoKyrTxI6rIhmJ8GN3sh8shuhNKse3Fqpy555
         2hLc+fg5kGYVDNANnch0RCnl7gAPisAR2s2m8I48ZVymukn5NiSa12rwqBdmbdsOi2TN
         F7OCCi0eN3PYWznlaCcKeNVvz9QqAGDVUkLECZKu8HAEPJQ23f8lmZKw1VvcdvV4Ktgp
         zMsvHC6BEnd5JnWQJhaJ/CMxO3ne49muQRSVZLOsbCrPOQrTsQRO1o0JmImHJyaS0/Z2
         f8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794979023; x=1795583823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=emIFi9MtfIR7SpLGE9qwf6+LtUi3bsONfmSNGbybc/g=;
        b=JHB38tcRZ/Gl/fXRm1zxlWzQv9fp1cWvkSrAtFbNrGXtV0+uPV+spaBjBHkA2ie7y7
         eZauX4FxwOXWTs4zIUSSpHiyO58mx7Ng5x+WEqC1deZFTO3ZrFbOyn8gxuB0AGul8SJ5
         4iN0/ShZPbPx5XpWjzLSrHEI/XMQfPvss+x82X9Avowm7s/T9kjGpgHXrhGBX45mUHtf
         DcPhEOjE9kgPUhfpUGxi4dkrwRD2Wz6Bs/elQ6QAFnPIA59TEY9Dy5vkam4sNaDh0LRE
         AgvGfMSxkMNXirdFgQDlbkVj94iZscKFjWn1ZfFqOFqJhYqgV5CfULfkz2G5DJ+4h7oJ
         m37Q==
X-Forwarded-Encrypted: i=1; AL+hErGHKwuxq3wWTSyonwCPJ4P1DXP9x05ROh4oIdH7hnTdBKIM6e0yL3UfIEPMtt1RLdAdsTcbuww=@lists.linux.dev
X-Gm-Message-State: APuU4Z83ul5twaDaeXl+H7E7AJodAEQP79dz2pa+yMfQD6GQy+d8UXs8
	PnJCH/da+B7RY0xYpSfRdUHBIHshtkCAmsSFj6PCpCHdfzb/Ry0SBTHL
X-Gm-Gg: AYBFou3krjtz0MV546gsmIPTyc7FrtDE5GmRa2wyyl2tjQL0GEE9WF6KHfUthsMwC81
	9347C2dAEpToHIZe3LSfuI7wer7p0/KP8hFttRGWChjaFuooDvrXRED7Dcpk7tdc2fDCSusqIzu
	wPEBbFBz0X+wNc6MTmAQngJ2h6yx07rMPeWmLE4ZgBwZa2AGkgBC2epkIOSpcLkswQ/B6+nhYDV
	RvvjBevMoG8c9xv9rHCFNlhvfNge/N2F98Vzw5cePie99+HNiFQ7YpqeuOnnfrzaBCSlou95tGB
	eJLJ5oiadDKYrmAWEfiNNb7Apngdoi8Gv2G1SRG2lknus6yEj3pY3h+O3+YanaiTyrz9cbSvLQ/
	F7RCHLY0e90exyBhTWHW5vTIGuqAPEmWFAgHPbHw9eWFlD+MwxEaWoFwmnZby/Z8T4oT3U8lzeA
	8f2mQvkyzO3G7ESLaJ4WfvQmNpEnC4w+ZxrVa6Wde4077LQqMJfqezsWjJ+maJgIkoD0vXdt8AV
	F/O8heUBYgZvHFZjoDVlfLn+hIfc1U1aKNu4c6FzcvHNiXxtlp+mm7sL/HOiCnsJpHzi4RGbvVh
	FpRAtUSbFxyXTIoFA5reBnG+9FgLxf/mqM4oqyPtRfs571J1WjHd6+WtTeRvYHxAO8BMYQCmKZ1
	Wmdb5GBHsDxUW2i08nFQd3BPsUv7ZYpA/Zs49DLkbTSB/
X-Received: by 2002:a05:600c:3e07:b0:4bb:6626:5a25 with SMTP id 5b1f17b1804b1-4bb7da443fdmr24610265e9.20.1794979022474;
        Tue, 17 Nov 2026 21:17:02 -0800 (PST)
Received: from PKL-HASEEBA-LT.. ([39.36.59.78])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78346f4asm122582685e9.0.2026.11.17.21.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 21:17:02 -0800 (PST)
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
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] KVM: arm64: Resume stage-2 range walks where they stopped
Date: Wed, 18 Nov 2026 10:16:48 +0500
Message-ID: <20261118051648.74580-2-haseebashraf091@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118051648.74580-1-haseebashraf091@gmail.com>
References: <20261118051648.74580-1-haseebashraf091@gmail.com>
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

stage2_apply_range() walks a range one block-sized chunk at a time.
The walker steps over an invalid entry in one go, but the next walk
starts at the following chunk, so an invalid entry larger than a chunk
is visited once for every chunk it covers. Unmapping the whole IPA
space of a shadow stage-2, as emulating TLBI VMALLS12E1IS and TLBI
ALLE1IS does, takes 2^18 walks with 4K pages and a 48-bit IPA space,
however little it maps. Each walk also ends with a range TLBI when
FEAT_TLBIRANGE and FWB are available.

On an AmpereOne A192-32X (192 CPUs, Xen on KVM, 4K pages, 48-bit IPA),
a full-range unmap of one shadow stage-2 took 0.84-0.94 s (mean 0.91 s
over 226 unmaps) on 6.18.29. With v3 of this change and the mainline
commits it builds on backported, it took 2.1-45 ms (mean 4.1 ms over 672
unmaps), with 512 to 1023 walks instead of 262144. The slowest TLBI
VMALLS12E1IS trap took 0.94 s before and 46 ms after.

Have the walk report the address it reached, and have
stage2_apply_range() resume from there. Unmap, write-protect and flush
all go through it, so all three get this. kvm_pgtable_stage2_unmap(),
kvm_pgtable_stage2_wrprotect() and kvm_pgtable_stage2_flush() now
return the address, or a negative error code, and so do their pKVM
counterparts, which do not walk page tables and return the end of the
range. The other callers, in nested.c and at EL2, only looked for an
error: they now check for a negative value, and those that pass the
result on turn it back into 0. The walk handles every entry it steps
over, including invalid entries that carry state, so nothing has to be
looked up beforehand.

The unmap of a shadow stage-2 also drops the guest stage-2 records of
the whole span the walk covered: nothing is mapped in the part it
stepped over, so any record there is stale. Each walk that remains
ends with the same deferred TLB invalidation as before. The spans that
were skipped have no valid entry, so there is nothing to invalidate.

Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Haseeb Ashraf <haseeb.ashraf@siemens.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 25 ++++++++----
 arch/arm64/include/asm/kvm_pkvm.h     |  6 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 22 +++++++----
 arch/arm64/kvm/hyp/pgtable.c          | 55 +++++++++++++++++----------
 arch/arm64/kvm/mmu.c                  | 32 ++++++++++------
 arch/arm64/kvm/nested.c               |  2 +-
 arch/arm64/kvm/pkvm.c                 | 14 +++----
 7 files changed, 97 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1c9c57cd6ae4..cc9b4b6a5fe8 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -721,9 +721,12 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * freed. Unmapping a cacheable page will ensure that it is clean to the PoC if
  * FWB is not supported by the CPU.
  *
- * Return: 0 on success, negative error code on failure.
+ * Return: the address the walk reached, which can be past @addr + @size when it
+ * steps over an invalid entry that extends beyond the range, or a negative error
+ * code on failure. Nothing is mapped up to that address, so a caller that unmaps a
+ * larger range in chunks can resume from it.
  */
-int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
+s64 kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
 /**
  * kvm_pgtable_stage2_wrprotect() - Write-protect guest stage-2 address range
@@ -739,9 +742,12 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * calling this function to ensure that the updated permissions are visible
  * to the CPUs.
  *
- * Return: 0 on success, negative error code on failure.
+ * Return: the address the walk reached, which can be past @addr + @size when it
+ * steps over an invalid entry that extends beyond the range, or a negative error
+ * code on failure. A caller that write-protects a larger range in chunks can
+ * resume from the returned address.
  */
-int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
+s64 kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
 /**
  * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
@@ -802,7 +808,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 				   enum kvm_pgtable_walk_flags flags);
 
 /**
- * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
+ * kvm_pgtable_stage2_flush() - Clean and invalidate data cache to Point
  * 				      of Coherency for guest stage-2 address
  *				      range.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
@@ -812,9 +818,14 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
  * The offset of @addr within a page is ignored and @size is rounded-up to
  * the next page boundary.
  *
- * Return: 0 on success, negative error code on failure.
+ * The walk can end past @addr + @size when it steps over an invalid entry that
+ * extends beyond the range. A caller that flushes a larger range in chunks can
+ * resume from the returned address.
+ *
+ * Return: the address the walk reached, which can be past @addr + @size, or a
+ * negative error code on failure.
  */
-int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
+s64 kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
 /**
  * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fd042d2b5462..b727600f2475 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -355,9 +355,9 @@ void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
 int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 			    enum kvm_pgtable_prot prot, void *mc,
 			    enum kvm_pgtable_walk_flags flags);
-int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
-int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
-int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
+s64 pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
+s64 pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
+s64 pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold);
 int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
 				    enum kvm_pgtable_walk_flags flags);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d4c332a91803..31900d2d1f13 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -383,16 +383,20 @@ static int host_stage2_unmap_dev_all(void)
 	struct kvm_pgtable *pgt = &host_mmu.pgt;
 	struct memblock_region *reg;
 	u64 addr = 0;
-	int i, ret;
+	int i;
+	s64 ret;
 
 	/* Unmap all non-memory regions to recycle the pages */
 	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
 		reg = &hyp_memory[i];
 		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
-		if (ret)
+		if (ret < 0)
 			return ret;
 	}
-	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
+
+	ret = kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
+
+	return ret < 0 ? ret : 0;
 }
 
 /*
@@ -1418,7 +1422,7 @@ int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 		goto unlock;
 	}
 
-	WARN_ON(kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE));
+	WARN_ON(kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE) < 0);
 	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
 
 unlock:
@@ -1600,7 +1604,7 @@ int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 {
 	u64 ipa = hyp_pfn_to_phys(gfn);
 	u64 size, phys;
-	int ret;
+	s64 ret;
 
 	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
 	if (ret)
@@ -1614,9 +1618,11 @@ int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 		goto unlock;
 
 	ret = kvm_pgtable_stage2_unmap(&vm->pgt, ipa, size);
-	if (ret)
+	if (ret < 0)
 		goto unlock;
 
+	ret = 0;
+
 	for_each_hyp_page(page, phys, size) {
 		/* __check_host_shared_guest() protects against underflow */
 		page->host_share_guest_count--;
@@ -1673,7 +1679,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 {
 	u64 size, ipa = hyp_pfn_to_phys(gfn);
-	int ret;
+	s64 ret;
 
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
@@ -1687,7 +1693,7 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 	ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, size);
 	guest_unlock_component(vm);
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b184d..84a3256d4488 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -261,8 +261,13 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
 	return ret;
 }
 
-int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
-		     struct kvm_pgtable_walker *walker)
+/*
+ * Walk [addr, addr + size) and return the address that the walk reached, or a
+ * negative error code. The address can be past addr + size when the walk steps
+ * over an invalid entry that extends beyond the range.
+ */
+static s64 kvm_pgtable_walk_next(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				 struct kvm_pgtable_walker *walker)
 {
 	struct kvm_pgtable_walk_data walk_data = {
 		.start	= ALIGN_DOWN(addr, PAGE_SIZE),
@@ -270,7 +275,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
 	};
-	int r;
+	s64 r;
 
 	r = kvm_pgtable_walk_begin(walker);
 	if (r)
@@ -279,7 +284,15 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	r = _kvm_pgtable_walk(pgt, &walk_data);
 	kvm_pgtable_walk_end(walker);
 
-	return r;
+	return r ?: walk_data.addr;
+}
+
+int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
+		     struct kvm_pgtable_walker *walker)
+{
+	s64 r = kvm_pgtable_walk_next(pgt, addr, size, walker);
+
+	return r < 0 ? r : 0;
 }
 
 struct leaf_walk_data {
@@ -1197,16 +1210,16 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+s64 kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
-	int ret;
+	s64 ret;
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
 		.arg	= pgt,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk_next(pgt, addr, size, &walker);
 	if (stage2_unmap_defer_tlb_flush(pgt))
 		/* Perform the deferred TLB invalidations */
 		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
@@ -1258,12 +1271,12 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
+static s64 stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 				    u64 size, kvm_pte_t attr_set,
 				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
 				    s8 *level, enum kvm_pgtable_walk_flags flags)
 {
-	int ret;
+	s64 ret;
 	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
 	struct stage2_attr_data data = {
 		.attr_set	= attr_set & attr_mask,
@@ -1275,8 +1288,8 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 		.flags		= flags | KVM_PGTABLE_WALK_LEAF,
 	};
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
-	if (ret)
+	ret = kvm_pgtable_walk_next(pgt, addr, size, &walker);
+	if (ret < 0)
 		return ret;
 
 	if (orig_pte)
@@ -1284,10 +1297,10 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 
 	if (level)
 		*level = data.level;
-	return 0;
+	return ret;
 }
 
-int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
+s64 kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
@@ -1298,11 +1311,11 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
 				enum kvm_pgtable_walk_flags flags)
 {
-	int ret;
+	s64 ret;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
 				       NULL, NULL, flags);
-	if (!ret)
+	if (ret >= 0)
 		dsb(ishst);
 }
 
@@ -1361,7 +1374,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 {
 	kvm_pte_t xn = 0, set = 0, clr = 0;
 	s8 level;
-	int ret;
+	s64 ret;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
 		return -EINVAL;
@@ -1382,10 +1395,10 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	}
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
-	if (!ret || ret == -EAGAIN)
+	if (ret >= 0 || ret == -EAGAIN)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr,
 			     (ret == -EAGAIN) ? TLBI_TTL_UNKNOWN : level);
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 static int stage2_flush_walker(const struct kvm_pgtable_visit_ctx *ctx,
@@ -1403,7 +1416,7 @@ static int stage2_flush_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
+s64 kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_flush_walker,
@@ -1412,9 +1425,9 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	};
 
 	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
-		return 0;
+		return addr + size;
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	return kvm_pgtable_walk_next(pgt, addr, size, &walker);
 }
 
 kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db7..84fb7baafaa4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -62,17 +62,23 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
  * CONFIG_LOCKUP_DETECTOR, CONFIG_LOCKDEP. Additionally, holding the lock too
  * long will also starve other vCPUs. We have to also make sure that the page
  * tables are not freed while we released the lock.
+ *
+ * @fn returns the address that its walk reached, or a negative error code. The
+ * address can be past the chunk it was given, when the walk stepped over an
+ * invalid entry that is larger than the chunk. The walk has processed entries
+ * up to that address, so the next chunk starts there: such an entry is then
+ * stepped over once, rather than once for every chunk that it covers.
  */
 static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 			      phys_addr_t end,
-			      int (*fn)(struct kvm_pgtable *, u64, u64),
+			      s64 (*fn)(struct kvm_pgtable *pgt, u64 addr, u64 size),
 			      bool resched)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	bool lock_dropped = false;
 	phys_addr_t addr = start;
-	int ret;
 	u64 next;
+	s64 ret;
 
 	do {
 		struct kvm_pgtable *pgt = mmu->pgt;
@@ -86,16 +92,17 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 
 		next = stage2_range_addr_end(addr, end);
 		ret = fn(pgt, addr, next - addr);
-		if (ret)
-			break;
+		if (ret < 0)
+			return ret;
 
+		next = min_t(u64, ret, end);
 		if (resched && next != end) {
 			cond_resched_rwlock_write(&kvm->mmu_lock);
 			lock_dropped = true;
 		}
 	} while (addr = next, addr != end);
 
-	return ret;
+	return 0;
 }
 
 #define stage2_apply_range_resched(mmu, addr, end, fn)			\
@@ -319,7 +326,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
 	__invalidate_icache_guest_page(va, size);
 }
 
-static int kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt,
+static s64 kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt,
 					    u64 addr, u64 size);
 
 static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
@@ -327,7 +334,7 @@ static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
 				      u64 size, bool may_block)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	int (*fn)(struct kvm_pgtable *, u64, u64);
+	s64 (*fn)(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		fn = kvm_pgtable_stage2_unmap_tracked;
@@ -375,16 +382,17 @@ static void no_stage2_unmap_range(struct kvm_s2_mmu *mmu,
  * does.
  */
 
-static int kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt, u64 addr, u64 size)
+static s64 kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
-	int ret;
+	s64 ret;
 
 	ret = kvm_pgtable_stage2_unmap(pgt, addr, size);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
-	kvm_remove_guest_s2_mappings(pgt->mmu, addr, size);
-	return 0;
+	/* The walk may have stepped over invalid entries: any record there is stale. */
+	kvm_remove_guest_s2_mappings(pgt->mmu, addr, ret - addr);
+	return ret;
 }
 
 /**
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28..4f2b22f9faf9 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1413,7 +1413,7 @@ void kvm_nested_unmap_cipa_range(struct kvm *kvm, gpa_t cipa, size_t unmap_size,
 			mapping_size = mapping->nested.last - nested_start + 1;
 
 			if (WARN_ON_ONCE(kvm_pgtable_stage2_unmap(mmu->pgt, nested_start,
-								  mapping_size)))
+								  mapping_size) < 0))
 				return;
 
 			interval_tree_remove(&mapping->nested, &mmu->guest_s2_mappings);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 016997288fd2..2275451b8245 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -602,7 +602,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+s64 pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 
@@ -611,10 +611,10 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
+	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size) ?: addr + size;
 }
 
-int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
+s64 pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	pkvm_handle_t handle = kvm->arch.pkvm.handle;
@@ -632,10 +632,10 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 			break;
 	}
 
-	return ret;
+	return ret ?: addr + size;
 }
 
-int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
+s64 pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	struct pkvm_mapping *mapping;
@@ -643,7 +643,7 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	lockdep_assert_held(&kvm->mmu_lock);
 
 	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
-		return 0;
+		return addr + size;
 
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
 		if (!mapping->nc)
@@ -651,7 +651,7 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 						  PAGE_SIZE * mapping->nr_pages);
 	}
 
-	return 0;
+	return addr + size;
 }
 
 bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold)
-- 
2.43.0
