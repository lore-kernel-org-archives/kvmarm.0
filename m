Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E47A19D89D;
	Thu, 15 Aug 2024 13:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723727073; cv=none; b=TN+qXB0xlK0jNrbIr/lsEE6oo1haQYi9BNKhJuBIqo8bBIZAQWjZuUKjVOP1BFG9hafwZCgkLlJkCLH8gLAL7+PbDjWs5twspaDAc/NPZ/k/DiPX87Hf3r+splZXJ9aYm9KlkTOEnOjOYJugmY7ZXtNDH7qfRcLIPbFoTuxOFIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723727073; c=relaxed/simple;
	bh=/fZItteGjQ5Y+5BJEV1l6FgRp1QTqwAdJ3yBnbId5j8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=NAqeWiT20FBTIEpRVInybbgB1ssCk51DW2x2JGEwEKGyTwmI4TwMcql5nveFpIKHIjzkio8liWREif7lEBEnHoRz/6aCwCbfXYpgW/NXvDG3b+Nbu6DrmITQp7anOGqce+ZEv9aN1SP6hOd0K4VRAKXM0O7o2p8Opdnh9/wy/SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isy4pzZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isy4pzZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79325C4AF0B;
	Thu, 15 Aug 2024 13:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723727072;
	bh=/fZItteGjQ5Y+5BJEV1l6FgRp1QTqwAdJ3yBnbId5j8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=isy4pzZfF9Z+etzzseawn13tfUo82qz5no3O+bO9GHJshCMPb1uDCKHGNHks9IbU6
	 6M7edSCi9bb2uQ97RrPRW+4AvWL24G1fQykb67AIXcNjLDc/QuTuvIZ+/qlt7oT5Ha
	 w+xvH0zlfAND2R4rHMyr1OpRec8EQuuUiwTsIMzc=
Subject: Patch "KVM: arm64: Don't pass a TLBI level hint when zapping table entries" has been added to the 6.6-stable tree
To: gregkh@linuxfoundation.org,gshan@redhat.com,kvmarm@lists.linux.dev,maz@kernel.org,oliver.upton@linux.dev,qperret@google.com,shahuang@redhat.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 15 Aug 2024 15:04:22 +0200
In-Reply-To: <20240815124626.21674-3-will@kernel.org>
Message-ID: <2024081521-sprinkler-precision-e0ee@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    KVM: arm64: Don't pass a TLBI level hint when zapping table entries

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-don-t-pass-a-tlbi-level-hint-when-zapping-table-entries.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-67768-greg=kroah.com@vger.kernel.org Thu Aug 15 14:49:11 2024
From: Will Deacon <will@kernel.org>
Date: Thu, 15 Aug 2024 13:46:26 +0100
Subject: KVM: arm64: Don't pass a TLBI level hint when zapping table entries
To: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, Gavin Shan <gshan@redhat.com>, Quentin Perret <qperret@google.com>, Shaoqin Huang <shahuang@redhat.com>
Message-ID: <20240815124626.21674-3-will@kernel.org>

From: Will Deacon <will@kernel.org>

commit 36e008323926036650299cfbb2dca704c7aba849 upstream.

The TLBI level hints are for leaf entries only, so take care not to pass
them incorrectly after clearing a table entry.

Cc: Gavin Shan <gshan@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Fixes: 82bb02445de5 ("KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2")
Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-3-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Cc: <stable@vger.kernel.org> # 6.6.y only
[will@: Use '0' instead of TLBI_TTL_UNKNOWN to indicate "no level"]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -523,7 +523,7 @@ static int hyp_unmap_walker(const struct
 
 		kvm_clear_pte(ctx->ptep);
 		dsb(ishst);
-		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
+		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), 0);
 	} else {
 		if (ctx->end - ctx->addr < granule)
 			return -EINVAL;
@@ -861,10 +861,12 @@ static void stage2_unmap_put_pte(const s
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
 
-		if (!stage2_unmap_defer_tlb_flush(pgt) ||
-		    kvm_pte_table(ctx->old, ctx->level)) {
-			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
-					ctx->addr, ctx->level);
+		if (kvm_pte_table(ctx->old, ctx->level)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     0);
+		} else if (!stage2_unmap_defer_tlb_flush(pgt)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     ctx->level);
 		}
 	}
 


Patches currently in stable-queue which might be from will@kernel.org are

queue-6.6/kvm-arm64-don-t-defer-tlb-invalidation-when-zapping-table-entries.patch
queue-6.6/kvm-arm64-don-t-pass-a-tlbi-level-hint-when-zapping-table-entries.patch
