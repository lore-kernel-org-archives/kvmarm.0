Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794231283;
	b=4ETOpQ1XW54+HmTwl+iNeouDon1JauBNdYMXuPcvDl13UL5G2+cgZFdFNFdqqgjtVdht
	 QUECx/dbWrDOPo5hcHLzb78grlopWbocghy+aMtVSwDVCCBi1a2EqOnZIymMaOTu8c/c+
	 hMCaOVJ4scMoqIJjIbemd6Gsi35+CrL7FldhypyoDiQJAO4RiAAfxkIxHLwDTZ42cj1oC
	 luOR3FavJHUS9b5xdhOs83My4ofR5KbQQoowNP5wMOLDyAwtgQkyKkrjQHuyxNsgPMfNy
	 Rn+E0Pqg2dKnkfhzYezX5zwgyEAw/zn9/oxLZ1puU0HP5adWy5TzEFAbgkt/4Aba9ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794231283;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i72jvjXZYiuFvX2PVomJVIa3lpIvz23JTo9dsgI517M=;
	b=VB4JGZ6rRye0s1tmbgrRm8X3oUmp/ceZ4koG3MeW/P9jgg4/MylST4OGO/g91YuRZeLC
	 FkBrEc+KX9QJlSxtKTtdrinBWUtBYgWBVT3wDTjb+yRJpAlIz4xpK38b5rLVY0Yihb8Z5
	 MiJappbPDt0i9iUB00aCK3oSJYDrhPDaLLLtxMEPGat2u6ZLQzqiZzZ0b3aF5Du++lXC9
	 EhEmAmIINsrLc/28a4Ki6ieoAXI/sn0LcbcSOeNq1CYoDihbgfWKx5rOKOOSMrDzEQt9v
	 4p6g31V9+HW01fOmLfdY9S6mPWkvzBpsEkVc5BFcf9r+cepyGDWJL5Ok3qYg2ivig2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ND3W/v75";
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEA1606A31C
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 13:34:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AEA1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ND3W/v75
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so10593575e9.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 05:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794231282; x=1794836082; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i72jvjXZYiuFvX2PVomJVIa3lpIvz23JTo9dsgI517M=;
        b=ND3W/v75/JUbrmw9tzmCTB68Kup2jBT+ZnnIEYzFbOSbrgLkdGL3XXEK8lG7bkpQpj
         vXYlUzOVrimH5ytMvvxpsYZr8Ih3CfzNqvvKmlfWdLRcFNwuIubOwv4W5bJ1LGosKcbh
         J4RCDAY6sNX9SRfRRMkSJEbYD5FqVnhu9WeFi95MB7ogL/Xo1qhH7N+bIGkGKOmSrxfr
         Bn/sKy19sSAYZsVWkKWO4WMLpGPlm3lrZsqNQO/NeYOL0OcQGDdoNbYPmmcr2BDotdn9
         lCJoVfTqT0lkCqg04wMEBSvIpvtaH07druJ3JCpOxUDO7d2ZMMdHXulBTlz6p4vpF6Af
         Kq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794231282; x=1794836082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i72jvjXZYiuFvX2PVomJVIa3lpIvz23JTo9dsgI517M=;
        b=V7yo6iQtCrCNEBRDKN01poYkJMfESAK0pNZJOCXM/1muGTbLIwt3tKUx29xsFIfHKt
         x71nre1K60xlIDicq45TEAa/XV9ilSMAM1BRbZB4w/eaEpOQXe838nVM7Ofd0qF1yxq0
         J75s2SYbrfcnAjny9p4DbRZtQpsICP2UuaqcEU7N6y9palNk37/pAirVZf65BXoSGlJw
         y/p29n+RNKZSdJAcSmNeSmaP/sGFyoYAJReH+BbrMZXudI6hThgQFxvjvzqy8Mc3Hf1B
         /cBi4L//uWmG5erris7GEPZG6ro0w2VCw1PKlhotYc8XznkE65Ycvgfezclfy7TBCqWQ
         glHg==
X-Forwarded-Encrypted: i=1; AL+hErHXqeojJyA6mAyfgYj4M/b0xD5DlbBxQrGV/Q1m40UV3YWS14k8As8zjzX0jE4/052Swy01evA=@lists.linux.dev
X-Gm-Message-State: APuU4Z9IDRfdGIQkMPE5fzYwkcvC6FnwCMYb3X/iKAHMf3Rg6CwDJTMW
	1xfhG2n5Lcw+6x0VDSyTiCI1PkM2+z+9CgU/jNvriPHhBjsqfwNZLeMy
X-Gm-Gg: AYBFou0haL9Pl22kq7Zbah3FBr5nxKDep0ZZMGvCPb+oT/jY2mhZZD7hoh3dzXNHO3f
	HFIbWFw6ixPwYHo0vIdM+jBLOSbQl5af8cNcp8KMdke6lPkic4nZC3OuCSYKUoNPuVatUI6SOH6
	RRpzuXW5yFXfxQAn0YMqZXuCrgeKJOaPTqbv9UK2Myc6LsyZ1MEbEm5kgn8eoA/4/kL7iBWd1Gj
	j2GkgXgV3f6UKRonTIU3WoMrceyZRh4Ms2dypnWOVShsBMRME23iLwwLlnpQPHVTjfqVF5o8cmn
	zlTAV4gh5KQwMr3hq7//jvCPFc4864S3YnzH/m1DOO6Js4prY/GCN60ouWExthtZAigOtwOvIKE
	R/L3FqCA/JJcXcDVIR7Wc0Rh5JFwEi8xpHe0bJ27TYRwZJMQ6i4UqyabhojN4C6bbGiY9BHDx1N
	m8Yb8FSdP7E/EVfW2HoYm16mid14WRu4MqNYD1x1SZhoI0OWB3Vb3+fCyt75ZZp5LfzXb9PuxRH
	c/FVVmiSCjyDQvnhUHNcL2EjzCTZzTMJ/fG6Mq3lZMadGI7MZtMCHGsVyosjtzTaob9fsCdfeCg
	bXosO3CMt1zYIRM2FHkvgC5pXq5YtkKKKoCxWeCNURYzV71VcCAFi4nhII64dF9Vd7vWvRbdjDj
	bZ0j6xClfrRLIrwrA1/MXygVl9w==
X-Received: by 2002:a05:600c:19d3:b0:4a3:5aea:21e5 with SMTP id 5b1f17b1804b1-4b9633cf337mr78658475e9.9.1794231281628;
        Mon, 09 Nov 2026 05:34:41 -0800 (PST)
Received: from PKL-HASEEBA-LT.. ([39.36.57.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39899sm9140435f8f.3.2026.11.09.05.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 05:34:41 -0800 (PST)
From: Haseeb Ashraf <haseebashraf091@gmail.com>
To: maz@kernel.org,
	Oliver Upton <oupton@kernel.org>
Cc: Haseeb Ashraf <haseeb.ashraf@siemens.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
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
Subject: [RFC PATCH 1/2] KVM: arm64: nv: Skip empty spans when unmapping a shadow S2
Date: Mon,  9 Nov 2026 18:34:30 +0500
Message-ID: <cfa77cdbf14d9fd24c22ab1ef9b940a0d7411699.1794229714.git.haseeb.ashraf@siemens.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109133431.185154-1-haseebashraf091@gmail.com>
References: <20261109133431.185154-1-haseebashraf091@gmail.com>
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

Emulating TLBI VMALLS12E1IS unmaps the whole shadow stage-2 of the
guest hypervisor's current VMID by passing the complete nested IPA
range to kvm_stage2_unmap_range(). That walks the range in chunks of
the largest block size and calls kvm_pgtable_stage2_unmap() on each of
them, mapped or not: 262144 chunks per shadow MMU with 4kB pages and a
48-bit PARange, each ending in a range TLBI when FEAT_TLBIRANGE and
FWB are available.

Guest hypervisors such as Xen issue this TLBI while creating domains,
and an empty table is charged for the whole IPA space. A full-range
unmap of one shadow MMU takes 0.87-1.06 s on AmpereOne (Xen on KVM,
4kB pages, function_graph). On Graviton4 (Xen-on-KVM, 48-bit IPA),
twelve VMALLS12E1IS traps took 1.46-9.50 s each (median 3.09 s), all
of it in stage2_apply_range():

  22)   4.180 us    |              } /* kvm_pgtable_stage2_unmap */
  22) $ 2278329 us  |            } /* stage2_apply_range */
  22) $ 2278329 us  |          } /* __unmap_stage2_range */
  22) $ 2278330 us  |        } /* kvm_stage2_unmap_range */
  22) $ 2278331 us  |      } /* s2_mmu_unmap_range */
  22) $ 2278337 us  |    } /* kvm_s2_mmu_iterate_by_vmid */
  22) $ 2278347 us  |  } /* handle_vmalls12e1is */

Add kvm_stage2_unmap_all(). It uses kvm_pgtable_get_leaf() to find the
entry covering the current address and, if that is a zero descriptor
at least as large as an unmap chunk, skips to the end of the span
without entering the unmap walker. Everything else is unmapped chunk
by chunk as before, so populated chunks keep their unmap, cache
maintenance and table reclamation ordering. Non-zero invalid
descriptors are never skipped, as they can carry software state.

Populated chunks use the tracked unmap, and the guest stage-2 records
of a skipped span are removed under the same mmu_lock hold: nothing is
mapped there, so they are stale. Dropping them after the walk would be
wrong if mmu_lock was released, as a concurrent fault could have
mapped something behind it.

The helper ends with a VMID-wide TLBI: VMALLS12E1IS also invalidates
stage-1 translations, which the per-chunk invalidations used to do
even for empty tables. mmu_lock may be dropped between spans if the
caller allows blocking, as for the range unmap.

Only the VMALLS12E1IS handler is converted here.

Signed-off-by: Haseeb Ashraf <haseeb.ashraf@siemens.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/kvm/mmu.c             | 80 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        | 20 ++++----
 3 files changed, 91 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 32392abf2e21..45655a669bd7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -184,6 +184,7 @@ void __init free_hyp_pgds(void);
 
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 			    u64 size, bool may_block);
+void kvm_stage2_unmap_all(struct kvm_s2_mmu *mmu, bool may_block);
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db7..af45c4226b31 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -409,6 +409,86 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 	kvm->arch.vm_s2_ops->vm_stage2_unmap_range(mmu, start, size, may_block);
 }
 
+/**
+ * kvm_stage2_unmap_all -- Unmap a whole shadow stage-2
+ * @mmu:       The shadow stage-2 MMU to unmap
+ * @may_block: Whether or not we are permitted to block
+ *
+ * Remove every mapping from a shadow stage-2, as unmapping its whole IPA
+ * space with kvm_stage2_unmap_range() would, but without entering the
+ * unmap walker for the (usually vast) parts of the IPA space that are
+ * already empty. A span covered by a zero descriptor that is at least as
+ * large as an unmap chunk is skipped; everything else is unmapped chunk
+ * by chunk, exactly as before.
+ *
+ * Like kvm_stage2_unmap_range(), this must be called with mmu_lock held
+ * for write, and may drop it between spans if @may_block is set.
+ */
+void kvm_stage2_unmap_all(struct kvm_s2_mmu *mmu, bool may_block)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	phys_addr_t addr = 0, end = kvm_phys_size(mmu);
+	bool lock_dropped = false;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	if (WARN_ON_ONCE(!kvm_is_nested_s2_mmu(kvm, mmu)))
+		return;
+
+	do {
+		struct kvm_pgtable *pgt = mmu->pgt;
+		phys_addr_t next;
+		kvm_pte_t pte;
+		s8 level;
+
+		/*
+		 * We may be raced on PGT teardown when we drop mmu_lock.
+		 * That's fine as the PGT is legitimately no longer present.
+		 */
+		if (!pgt) {
+			WARN_ON_ONCE(!lock_dropped);
+			return;
+		}
+
+		/*
+		 * A zero descriptor at, or above, the unmap chunk level
+		 * covers an empty span. Do not skip non-zero invalid
+		 * descriptors, as the unmap walker may have to clear the
+		 * software state they carry. Finer-grained leaves keep the
+		 * chunk-sized unmap, so that a populated table is not
+		 * processed one page at a time.
+		 */
+		if (!kvm_pgtable_get_leaf(pgt, addr, &pte, &level, 0) &&
+		    !pte && level <= KVM_PGTABLE_MIN_BLOCK_LEVEL) {
+			next = __stage2_range_addr_end(addr, end,
+						       kvm_granule_size(level));
+			/* Nothing is mapped here, so any record is stale. */
+			kvm_remove_guest_s2_mappings(mmu, addr, next - addr);
+		} else {
+			next = stage2_range_addr_end(addr, end);
+			if (WARN_ON_ONCE(kvm_pgtable_stage2_unmap_tracked(pgt, addr,
+									  next - addr)))
+				break;
+		}
+
+		if (may_block && next != end) {
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+			lock_dropped = true;
+		}
+		addr = next;
+	} while (addr != end);
+
+	/*
+	 * Skipping empty spans must not skip the invalidation that the
+	 * guest operation implies: a TLBI VMALLS12E1IS also invalidates
+	 * stage-1 translations, and a context that does not use the shadow
+	 * page tables can have TLB entries tagged with this MMU's VMID
+	 * even though they are empty. The per-chunk range invalidations
+	 * used to provide this as a side effect.
+	 */
+	kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+}
+
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
 	stage2_apply_range_resched(mmu, addr, end, KVM_PGT_FN(kvm_pgtable_stage2_flush));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 850eba167aad..58c221e7c710 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4124,26 +4124,26 @@ static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
 	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true);
 }
 
+static void s2_mmu_unmap_all(struct kvm_s2_mmu *mmu,
+			     const union tlbi_info *info)
+{
+	/* See s2_mmu_unmap_range() for the rules when dropping mmu_lock. */
+	kvm_stage2_unmap_all(mmu, true);
+}
+
 static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 				const struct sys_reg_desc *r)
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
-	u64 limit, vttbr;
+	u64 vttbr;
 
 	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding))
 		return undef_access(vcpu, p, r);
 
 	vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-	limit = BIT_ULL(kvm_get_pa_bits(vcpu->kvm));
 
-	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
-				   &(union tlbi_info) {
-					   .range = {
-						   .start = 0,
-						   .size = limit,
-					   },
-				   },
-				   s2_mmu_unmap_range);
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr), NULL,
+				   s2_mmu_unmap_all);
 
 	return true;
 }
-- 
2.43.0

