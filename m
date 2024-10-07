Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCD718C908
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 23:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343847; cv=none; b=pM2PwwGHcXokmG7uV20u1WQ6LuX2ufVYCe/v37LInsK9oQTR6IRTUjvXIg5lw8jYySNte9tveAEgL8f072JCW/BPlhIVlkLRuZieecfmmi6zeNbtdcVRn3+vmE4k+NvJOva4KkNQ++UpVNziIvxAowjByPT5sQcxxtvBVk1vUU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343847; c=relaxed/simple;
	bh=STh261EsmTihx/t6FQVBH3UUpEP8q77mTPSRh+0xXlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luEVRAt43fdXSefeihZK7u4rRpj6Z+8FbWrJ+GnH5XxfiDd/NFxMWaxhN4p4mIpixkOB8Td9dzom+ltspEFdUSm6sPA0g3lwxfcrvMuz3V1N35TpyXqj341MRGMO3heErrC3P3d7ejrMsnz65/6xnqODv01UyfNNyWcTvT7+p7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gxyqKAyL; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gxyqKAyL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728343844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASZc0ZAfhg+6RCUDVQRrPWliQIj6M0WAWUerblhPJXM=;
	b=gxyqKAyLJAdLcLs+nfcSncTEgEW6zZKj/Eq6wJBmoOkU0XWnIA1H7gD+7TsO4etBaW8gfa
	L81bX4fJqNkBf+xGhNV4ly41vtf2f+1oxmXC+tI/2Wvf/SLyWXnm9QXwOakxlG6wfuwi18
	O/kxXT9oRQPKurCcreODfKlfGTXdqQM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 4/4] KVM: arm64: nv: Clarify safety of allowing TLBI unmaps to reschedule
Date: Mon,  7 Oct 2024 23:30:28 +0000
Message-ID: <20241007233028.2236133-5-oliver.upton@linux.dev>
In-Reply-To: <20241007233028.2236133-1-oliver.upton@linux.dev>
References: <20241007233028.2236133-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There's been a decent amount of attention around unmaps of nested MMUs,
and TLBI handling is no exception to this. Add a comment clarifying why
it is safe to reschedule during a TLBI unmap, even without a reference
on the MMU in progress.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e0c7cc16466e..48903821142b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2955,6 +2955,29 @@ union tlbi_info {
 static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
 			       const union tlbi_info *info)
 {
+	/*
+	 * The unmap operation is allowed to drop the MMU lock and block, which
+	 * means that @mmu could be used for a different context than the one
+	 * currently being invalidated.
+	 *
+	 * This behavior is still safe, as:
+	 *
+	 *  1) The vCPU(s) that recycled the MMU are responsible for invalidating
+	 *     the entire MMU before reusing it, which still honors the intent
+	 *     of a TLBI.
+	 *
+	 *  2) Until the guest TLBI instruction is 'retired' (i.e. increment PC
+	 *     and ERET to the guest), other vCPUs are allowed to use stale
+	 *     translations.
+	 *
+	 *  3) Accidentally unmapping an unrelated MMU context is nonfatal, and
+	 *     at worst may cause more aborts for shadow stage-2 fills.
+	 *
+	 * Dropping the MMU lock also implies that shadow stage-2 fills could
+	 * happen behind the back of the TLBI. This is still safe, though, as
+	 * the L1 needs to put its stage-2 in a consistent state before doing
+	 * the TLBI.
+	 */
 	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true);
 }
 
@@ -3050,6 +3073,10 @@ static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
 	max_size = compute_tlb_inval_range(mmu, info->ipa.addr);
 	base_addr &= ~(max_size - 1);
 
+	/*
+	 * See comment in s2_mmu_unmap_range() for why this is allowed to
+	 * reschedule.
+	 */
 	kvm_stage2_unmap_range(mmu, base_addr, max_size, true);
 }
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog

