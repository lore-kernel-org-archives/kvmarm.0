Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699E6C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 09:40:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB9C764FE0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 09:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB9C764FE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1684B6FE;
	Fri, 12 Mar 2021 04:40:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XU7lBTY3vi6S; Fri, 12 Mar 2021 04:40:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 155254B594;
	Fri, 12 Mar 2021 04:40:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 683564B50B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 04:40:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vXB3E1+SxbL3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 04:40:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BE6F4B594
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 04:40:19 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3961E64FDD;
 Fri, 12 Mar 2021 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615542017;
 bh=IhMRNUcJYwCkDReHSF76lISid/6+vJxJRq5TrqpWgk8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=FttZZGnGm4GqH4u+TmUc57P5wbD6izysvvsuuknHB0t9tFFQ2cQUyxJP/LmMkMDPj
 pBaaPhflRrPTYmpAiwT0ngHHanDpHmZPoRs7X+JJnQ9lmsdsaUrapQE8/wHB66L3Hu
 aVesI5HypLmSPbqdaaWqDr25iEvI5DhjopJJ0hEA3yEeNosk9xaawcrEhTcWRKRiSJ
 byZmtWoB7mUSOf5wgOLjHY3cp9Q9veMVqbG3NIvjswUAA8acTGGr0x/S3V/DniQx4j
 0+d4EafNVWpjsvT9E+2S9Uv0D5JTLHwiVdzh+eQOaEL5QjPeEq0Xn9UUd3EPKbRAWz
 EWOc5VUiGsXxg==
Date: Fri, 12 Mar 2021 09:40:09 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 30/34] KVM: arm64: Add kvm_pgtable_stage2_find_range()
Message-ID: <20210312094009.GC32016@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-31-qperret@google.com>
 <20210311190406.GB31586@willie-the-truck>
 <YEr83QKZnEd4a6Ba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YEr83QKZnEd4a6Ba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 12, 2021 at 05:32:13AM +0000, Quentin Perret wrote:
> On Thursday 11 Mar 2021 at 19:04:07 (+0000), Will Deacon wrote:
> > On Wed, Mar 10, 2021 at 05:57:47PM +0000, Quentin Perret wrote:
> > > +	for (level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS; level++) {
> > > +		granule = kvm_granule_size(level);
> > > +		start = ALIGN_DOWN(addr, granule);
> > > +		end = start + granule;
> > > +
> > > +		if (!kvm_level_support_block_mappings(level))
> > > +			continue;
> > > +
> > > +		if (start < range->start || range->end < end)
> > > +			continue;
> > > +
> > > +		/*
> > > +		 * Check the presence of existing mappings with incompatible
> > > +		 * permissions within the current block range, and try one level
> > > +		 * deeper if one is found.
> > > +		 */
> > > +		ret = kvm_pgtable_walk(pgt, start, granule, &check_perm_walker);
> > > +		if (ret != -EEXIST)
> > > +			break;
> > > +	}
> > 
> > Can you write this as a:
> > 
> > 	do {
> > 		...
> > 	} while (level < KVM_PGTABLE_MAX_LEVELS && ret == -EEXIST);
> > 
> > loop?
> 
> I tried it but found it a little less pretty -- the pre-assignment of
> level and the increment at the end make it really feel like a for loop
> to me:
> 
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1098,26 +1098,23 @@ int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
>                 return ret;
>         attr &= KVM_PTE_LEAF_S2_COMPAT_MASK;
>  
> -       for (level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS; level++) {
> +       ret = -EEXIST;
> +       level = pgt->start_level;
> +       do {
>                 granule = kvm_granule_size(level);
>                 start = ALIGN_DOWN(addr, granule);
>                 end = start + granule;
>  
> -               if (!kvm_level_support_block_mappings(level))
> -                       continue;
> -
> -               if (start < range->start || range->end < end)
> -                       continue;

Urgh, yes, sorry, I hadn't appreciated what a mess it causes for these guys.

Stick with the 'for' loop.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
