Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D618A19DF4A;
	Thu, 15 Aug 2024 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723727065; cv=none; b=fs1jC4QaoDdQY/RyWt87Dt64+jJkLj9Z1444qaupg97mioA0xkgHY4kft7DPho3VJWAZAje/Z2PN5mqAN1ugqwqSu/Eqllf5U0gSDQEhGBh/oPBlpOWYNGkuOhs+wIfWa5YGHU+h2QLZT1K3CVfp/3eisWvLCSGTHRw05Y5nVg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723727065; c=relaxed/simple;
	bh=TcE9Fmkg76QEca3z+T0r9EanPBCiYLxL8EoYuoiKbzY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=klBHaQWTl+LXSyNMeo0HiAJqvEYr9o/io2detaaKgsaTaODVzqA+WWItgzKugUxhDKGcYrZPtDCfoT0FisXs6qWqY4kq31Rv1HZNz/VmQFX06jFp97whP2Q4WjKOd9QQA2t1PvszW3j06y6irBzO4o/029nO461eQauU/4ddl1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfWoug1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfWoug1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CBBC32786;
	Thu, 15 Aug 2024 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723727064;
	bh=TcE9Fmkg76QEca3z+T0r9EanPBCiYLxL8EoYuoiKbzY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=WfWoug1CnO7PJ6V6imGZ8sSHmuyUjbnZpUhu3NHje1OZCuAoWVBqZctY29f533mFW
	 5tXX6B6HayDQGOnXmK4x6jV59BEb0EV6Ov3NrdrNhd5Z8FwRCqkYNmRRTcQMFyqDwy
	 7cs5QkYrhCW7Tgsvu9z+Zz9vlR86FoU6SfSiqY4U=
Subject: Patch "KVM: arm64: Don't defer TLB invalidation when zapping table entries" has been added to the 6.6-stable tree
To: gregkh@linuxfoundation.org,kvmarm@lists.linux.dev,maz@kernel.org,oliver.upton@linux.dev,rananta@google.com,shahuang@redhat.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 15 Aug 2024 15:04:21 +0200
In-Reply-To: <20240815124626.21674-2-will@kernel.org>
Message-ID: <2024081521-backfire-deputize-0792@gregkh>
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

    KVM: arm64: Don't defer TLB invalidation when zapping table entries

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-don-t-defer-tlb-invalidation-when-zapping-table-entries.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-67767-greg=kroah.com@vger.kernel.org Thu Aug 15 14:49:10 2024
From: Will Deacon <will@kernel.org>
Date: Thu, 15 Aug 2024 13:46:25 +0100
Subject: KVM: arm64: Don't defer TLB invalidation when zapping table entries
To: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, Raghavendra Rao Ananta <rananta@google.com>, Shaoqin Huang <shahuang@redhat.com>
Message-ID: <20240815124626.21674-2-will@kernel.org>

From: Will Deacon <will@kernel.org>

commit f62d4c3eb687d87b616b4279acec7862553bda77 upstream.

Commit 7657ea920c54 ("KVM: arm64: Use TLBI range-based instructions for
unmap") introduced deferred TLB invalidation for the stage-2 page-table
so that range-based invalidation can be used for the accumulated
addresses. This works fine if the structure of the page-tables remains
unchanged, but if entire tables are zapped and subsequently freed then
we transiently leave the hardware page-table walker with a reference
to freed memory thanks to the translation walk caches. For example,
stage2_unmap_walker() will free page-table pages:

	if (childp)
		mm_ops->put_page(childp);

and issue the TLB invalidation later in kvm_pgtable_stage2_unmap():

	if (stage2_unmap_defer_tlb_flush(pgt))
		/* Perform the deferred TLB invalidations */
		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);

For now, take the conservative approach and invalidate the TLB eagerly
when we clear a table entry. Note, however, that the existing level
hint passed to __kvm_tlb_flush_vmid_ipa() is incorrect and will be
fixed in a subsequent patch.

Cc: Raghavendra Rao Ananta <rananta@google.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-2-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Cc: <stable@vger.kernel.org> # 6.6.y only
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -861,9 +861,11 @@ static void stage2_unmap_put_pte(const s
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
 
-		if (!stage2_unmap_defer_tlb_flush(pgt))
+		if (!stage2_unmap_defer_tlb_flush(pgt) ||
+		    kvm_pte_table(ctx->old, ctx->level)) {
 			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
 					ctx->addr, ctx->level);
+		}
 	}
 
 	mm_ops->put_page(ctx->ptep);


Patches currently in stable-queue which might be from will@kernel.org are

queue-6.6/kvm-arm64-don-t-defer-tlb-invalidation-when-zapping-table-entries.patch
queue-6.6/kvm-arm64-don-t-pass-a-tlbi-level-hint-when-zapping-table-entries.patch
