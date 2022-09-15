Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41D0ECAAD3
	for <kvmarm@archiver.kernel.org>; Thu, 15 Sep 2022 08:36:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D824BC7C;
	Thu, 15 Sep 2022 04:36:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3UbG5JJKyZOp; Thu, 15 Sep 2022 04:36:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 324B74BC68;
	Thu, 15 Sep 2022 04:36:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EDEB4BC57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Sep 2022 04:36:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P11go3RSPMmP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Sep 2022 04:36:00 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C48704BBD4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Sep 2022 04:36:00 -0400 (EDT)
Date: Thu, 15 Sep 2022 09:35:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663230959;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=os9IwzMucLgvaJoFDfZwUuHXyNMsYUbmD+UZT0aPk50=;
 b=E/tahtjhO+Blv3iPVh0DxXR5+zb1T97qHYNma9aXxibWOSflrt9ii0ORnnylzqS95STLGn
 Gh7oKiN3KOeCQIoh0ZfJlrIdL1p5P1FHPH7PfI8p5/7KX7mI3kzN0fevcLDPdQo2cm/wYR
 YUqtx80pvv6k24UTJFIyckf3Eb1J3Qw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 01/25] KVM: arm64: Move hyp refcount manipulation
 helpers to common header file
Message-ID: <YyLj69OheXbXZLRw@google.com>
References: <20220914083500.5118-1-will@kernel.org>
 <20220914083500.5118-2-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220914083500.5118-2-will@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Will,

On Wed, Sep 14, 2022 at 09:34:36AM +0100, Will Deacon wrote:
> From: Quentin Perret <qperret@google.com>
> 
> We will soon need to manipulate 'struct hyp_page' refcounts from outside
> page_alloc.c, so move the helpers to a common header file to allow them
> to be reused easily.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 ++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 19 -------------------
>  2 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index 592b7edb3edb..418b66a82a50 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -45,4 +45,22 @@ static inline int hyp_page_count(void *addr)
>  	return p->refcount;
>  }
>  
> +static inline void hyp_page_ref_inc(struct hyp_page *p)
> +{
> +	BUG_ON(p->refcount == USHRT_MAX);
> +	p->refcount++;
> +}
> +
> +static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
> +{
> +	BUG_ON(!p->refcount);
> +	p->refcount--;
> +	return (p->refcount == 0);
> +}
> +
> +static inline void hyp_set_page_refcounted(struct hyp_page *p)
> +{
> +	BUG_ON(p->refcount);
> +	p->refcount = 1;
> +}

It might be good to add a comment mentioning the hyp_pool::lock must
be held to update refcounts, as that part is slightly less clear when
the helpers are hoisted out of page_alloc.c

With that:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
