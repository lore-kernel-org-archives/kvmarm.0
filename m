Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E342C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 10:46:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE9D764F30
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 10:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE9D764F30
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C85B4B67F;
	Thu, 18 Mar 2021 06:46:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yrSfqKyT27hX; Thu, 18 Mar 2021 06:46:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0BA34B6A8;
	Thu, 18 Mar 2021 06:46:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50D904B685
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 06:46:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g5PBjeZr9Hte for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 06:46:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57B464B679
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 06:46:23 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB58C64F30;
 Thu, 18 Mar 2021 10:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616064381;
 bh=XqdkH1nXt37hLBmtJ5Y+VX8+z2R5eLWjcxknTKXuaPo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ijqwq4EO+ziR0VxoYBYEdVyi3SsaW4T42zOz70yn74DlslPtqkk8GiLnfLhOBLWD1
 c44gjrh0WYXHLuJ1E3KJNwztWn9nuoHaj7TR+GoFAyZ2rSxLxYNXsd0MbNJEQAlScq
 SagKXTIYAV+qg28tUyK3Jp5/29vKL0hhBSy/+nACnSyDQWDcbEtjNJuXle9HWHHzCF
 eEqWKF30QQWq+GWu6rMWqcQmU5HnhhF/dP2Yc5oIGtBndhcVledw7TRhpeCZbf1rUs
 crotBQgY3b7ghLZTDScfH1WQ5mTfB/ma95hWBwLCIhDyXLSTTRy5gwA5f7Tr4Ox/fs
 EpE7Qtknpmyjw==
Date: Thu, 18 Mar 2021 10:46:16 +0000
From: Will Deacon <will@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH] KVM: arm64: Update comment for parameter rename
Message-ID: <20210318104616.GB6959@willie-the-truck>
References: <20210315142311.1848485-1-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210315142311.1848485-1-ascull@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: catalin.marinas@arm.com, maz@kernel.org, kernel-team@android.com,
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

On Mon, Mar 15, 2021 at 02:23:11PM +0000, Andrew Scull wrote:
> The first parameter of __hyp_do_panic() was changed, so update the
> comment that's intended to explain the significance of passing zero.
> This hunk previously got lost in the merge.
> 
> Fixes: c4b000c3928d ("KVM: arm64: Fix nVHE hyp panic host context restore")
> Signed-off-by: Andrew Scull <ascull@google.com>
> ---
> 
> Applied on 5.12-rc3. The backports of the original patch contained this
> hunk, and it's mainly cosmetic anyway, so no further action is needed.
> 
> ---
>  arch/arm64/kvm/hyp/nvhe/host.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index 5d94584840cc..c419648c1d3f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -152,7 +152,7 @@ SYM_FUNC_END(__hyp_do_panic)
>  
>  .macro invalid_host_el1_vect
>  	.align 7
> -	mov	x0, xzr		/* restore_host = false */
> +	mov	x0, xzr		/* host_ctxt = NULL */
>  	mrs	x1, spsr_el2
>  	mrs	x2, elr_el2
>  	mrs	x3, par_el1

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
