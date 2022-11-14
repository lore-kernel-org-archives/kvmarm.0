Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B74C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Nov 2022 18:48:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F7B4BAF1;
	Mon, 14 Nov 2022 13:48:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pjn0EBpPR6l4; Mon, 14 Nov 2022 13:48:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 904784BA03;
	Mon, 14 Nov 2022 13:48:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A919A4B9FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 13:48:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OSgC+sLQSnPm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2022 13:48:11 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EB5D4B94A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 13:48:11 -0500 (EST)
Date: Mon, 14 Nov 2022 18:48:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668451689;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ql8zFw/DxEYIf4IQ7KYe8Xa1QN1s9FqjeGphu6RWQE0=;
 b=fZ0/Ii6j2iJMk+5Ifc1knRSHKvjiHHn3ogpu2jcYbK+f0t4CQJZkX/9gpvgZZYcdEMPy7v
 RCtRu/x1mWpxQxYTS19afbHKVMlExyhZrat4Ov8c4n1sLfOguH0PbCXbOEPfoRoILSq5Qf
 6AO6nic/6sRSOEy/ku4/33HGFBSVpEw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [RFC PATCH 02/12] KVM: arm64: Allow visiting block PTEs in
 post-order
Message-ID: <Y3KNZCLVqnFeg7hi@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-3-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: ricarkol@gmail.com, kvm@vger.kernel.org, catalin.marinas@arm.com,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev, bgardon@google.com,
 maz@kernel.org, dmatlack@google.com, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

On Sat, Nov 12, 2022 at 08:17:04AM +0000, Ricardo Koller wrote:
> The page table walker does not visit block PTEs in post-order. But there
> are some cases where doing so would be beneficial, for example: breaking a
> 1G block PTE into a full tree in post-order avoids visiting the new tree.
> 
> Allow post order visits of block PTEs. This will be used in a subsequent
> commit for eagerly breaking huge pages.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++-------------
>  3 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index e2edeed462e8..d2e4a5032146 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -255,7 +255,7 @@ struct kvm_pgtable {
>   *					entries.
>   * @KVM_PGTABLE_WALK_TABLE_PRE:		Visit table entries before their
>   *					children.
> - * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
> + * @KVM_PGTABLE_WALK_POST:		Visit leaf or table entries after their
>   *					children.

It is not immediately obvious from this change alone that promoting the
post-order traversal of every walker to cover leaf + table PTEs is safe.

Have you considered using a flag for just leaf post-order visits?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
