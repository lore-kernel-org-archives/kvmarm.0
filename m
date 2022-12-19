Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E36C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 19:45:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD03B4B7D2;
	Mon, 19 Dec 2022 14:45:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t+QUiYnNDZ2J; Mon, 19 Dec 2022 14:45:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B4CE4B636;
	Mon, 19 Dec 2022 14:45:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECB494B62A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 14:45:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g851If0JfcHp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 14:45:50 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C60B4B4D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 14:45:50 -0500 (EST)
Date: Mon, 19 Dec 2022 19:45:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1671479149;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=KILJmguHjqQ6SByYTuCuINiGP5uaLk6cxMS8sOPjn0c=;
 b=UfsgUfhaKwCbijceLCFVlsniHw9mVLe92O73X3euqvwK/tvJJ2CqD8V/7eFD4ARw29WQR1
 pTc5kpTexZK235ggECEhD+EDZob46yI6/gEiSer2XrUOMQdRojyFehkN6it7ws5H3BlvPc
 slZRldJaA9A8izfOqzfwYG+BqoQpzK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v1 05/12] KVM: arm64: Maintain page-table format info in
 struct kvm_pgtable
Message-ID: <Y6C/aACDK8rrF6df@google.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <20221206135930.3277585-6-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221206135930.3277585-6-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT
Cc: Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Ryan,

On Tue, Dec 06, 2022 at 01:59:23PM +0000, Ryan Roberts wrote:
> As the next step on the journey to supporting FEAT_LPA2 in KVM, add a
> flag to struct kvm_pgtable, which functions can then use to select the
> approprate behavior for either the `classic` or `lpa2` page-table
> formats. For now, all page-tables remain in the `classic` format.
> 
> No functional changes are intended.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 2 ++
>  arch/arm64/kvm/hyp/pgtable.c         | 2 ++
>  arch/arm64/kvm/mmu.c                 | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2247ed74871a..744e224d964b 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -157,6 +157,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>   * @start_level:	Level at which the page-table walk starts.
>   * @pgd:		Pointer to the first top-level entry of the page-table.
>   * @mm_ops:		Memory management callbacks.
> + * @lpa2_ena:		Format used for page-table; false->classic, true->lpa2.

I'd prefer that we describe the paging structure purely in terms of
input and output address. If you add the latter it should be possible to
decide if LPA2 is actually in use.

(i.e. PAGE_SIZE != SZ_64K && pgt->oa_bits > 48)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
