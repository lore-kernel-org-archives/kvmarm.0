Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19783C43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 12:34:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68B1720882
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 12:34:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQRGPBHL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68B1720882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6D7E4B261;
	Thu, 10 Sep 2020 08:34:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P8Bt5VLLH-aX; Thu, 10 Sep 2020 08:34:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92BFA4B1EA;
	Thu, 10 Sep 2020 08:34:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DF144B180
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 08:34:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UKZJFqRj7u4s for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 08:34:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 144AA4B191
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 08:34:11 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 68ACC20882;
 Thu, 10 Sep 2020 12:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599741250;
 bh=8eR8TAoPbqwWQ2DQ19kAdxvtNuwY3QaCmzLRuqS+Cww=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kQRGPBHLvgUUv7jh6W3obasoLJnq3nsvGbavxuBcpB5v00Wh/cTs1QLCzfyyJYvuQ
 GumvkDQeBrpSJuMHjrTT06qVghug3SLOI0Ffa+syyUdY1kaIBwN1GMT4XjndYAhVHo
 YPJ/W1+f42Ogz3DED0b7cgwb+uWmDBTzoORYb1Bw=
Date: Thu, 10 Sep 2020 13:34:05 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v4 06/21] KVM: arm64: Add support for stage-2
 map()/unmap() in generic page-table
Message-ID: <20200910123404.GA18100@willie-the-truck>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-7-will@kernel.org>
 <f5939f12-56e8-794c-8d9b-9ae348bba3c0@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f5939f12-56e8-794c-8d9b-9ae348bba3c0@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 10, 2020 at 12:20:42PM +0100, Alexandru Elisei wrote:
> On 9/7/20 4:23 PM, Will Deacon wrote:
> > +static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
> > +				      kvm_pte_t *ptep,
> > +				      struct stage2_map_data *data)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!data->anchor)
> > +		return 0;
> > +
> > +	free_page((unsigned long)kvm_pte_follow(*ptep));
> > +	put_page(virt_to_page(ptep));
> > +
> > +	if (data->anchor == ptep) {
> > +		data->anchor = NULL;
> > +		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> > +	}
> 
> I had another look at this function. If we're back to the anchor entry, then that
> means that we know from the pre-order visitor that 1. the mapping is supported at
> this level and 2. that the pte was invalidated. This means that
> kvm_set_valid_leaf_pte() will succeed in changing the entry. How about instead of
> calling stage2_map_walk_leaf() -> stage2_map_walker_try_leaf() ->
> kvm_set_valid_leaf_pte() we call kvm_set_valid_leaf_pte() directly, followed by
> get_page(virt_to_page(ptep)? It would make the code a lot easier to follow
> (stage2_map_walk_leaf() is pretty complicated, imo, but that can't really be
> avoided), and also slightly faster.

I'm not sure I agree. I would consider kvm_set_valid_leaf_pte() to be lower
level, and not the right function to be calling here. Rather,
stage2_map_walk_leaf() is what would have been called if we hadn't spotted
the potential for a block mapping anyway, so I much prefer that symmetry. It
also means that if stage2_map_walk_leaf() grows some extra logic in future
that we need to take into account here, we won't miss anything.

> > +/*
> > + * This is a little fiddly, as we use all three of the walk flags. The idea
> > + * is that the TABLE_PRE callback runs for table entries on the way down,
> > + * looking for table entries which we could conceivably replace with a
> > + * block entry for this mapping. If it finds one, then it sets the 'anchor'
> > + * field in 'struct stage2_map_data' to point at the table entry, before
> > + * clearing the entry to zero and descending into the now detached table.
> > + *
> > + * The behaviour of the LEAF callback then depends on whether or not the
> > + * anchor has been set. If not, then we're not using a block mapping higher
> > + * up the table and we perform the mapping at the existing leaves instead.
> > + * If, on the other hand, the anchor _is_ set, then we drop references to
> > + * all valid leaves so that the pages beneath the anchor can be freed.
> > + *
> > + * Finally, the TABLE_POST callback does nothing if the anchor has not
> > + * been set, but otherwise frees the page-table pages while walking back up
> > + * the page-table, installing the block entry when it revisits the anchor
> > + * pointer and clearing the anchor to NULL.
> > + */
> 
> The comment does wonders at explaining what is going on, thank you.

Glad it helps!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
