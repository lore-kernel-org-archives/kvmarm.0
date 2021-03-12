Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7D0C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 11:18:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C37CD64F78
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 11:18:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C37CD64F78
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BCF74B5A0;
	Fri, 12 Mar 2021 06:18:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R3Ynmz1Gm4w7; Fri, 12 Mar 2021 06:18:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2206A4B5C0;
	Fri, 12 Mar 2021 06:18:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA5A4B5A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 06:18:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0iceftgpNm2f for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 06:18:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B7704B594
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 06:18:12 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EB0864F09;
 Fri, 12 Mar 2021 11:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615547891;
 bh=4M8/d1QtvNV0W22nnWX2De2qfNZVr8K7C/taDssa2Ss=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hvgY2ixxwgnMDRs6DayZDJfXR1VG+agFl/c5ryWLihtPZrXyiAITc3Z3DhwjhWKSr
 QixZ+cIFSfVRHu4wj4bqnJGhgTgoxG5Q0jiA/zFwgGZIAd9kbttdxrXMz+h8rc8DLf
 MDeAFCrDlcWQpHH4KXEY+shjNwnrtMK00t5f1QibG3Md/5LlHoA1oaIwqvgMnuJWJq
 uqmgObMsd6Ue5uqdFkktT4ksgWSGaYa+dit8HiN9xOqjsbTRGwR40tCGNsgeSqNRyX
 XKYql/ytfOCaQm3wnG3kpztMyXHP3ok0WEpLpAMsOBbBGibTvIk9DztGVRjgRRV51L
 JBSXW6eZQ3BHg==
Date: Fri, 12 Mar 2021 11:18:05 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 28/34] KVM: arm64: Use page-table to track page
 ownership
Message-ID: <20210312111804.GB32208@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-29-qperret@google.com>
 <20210311183834.GC31378@willie-the-truck>
 <YEsIxA/fKaDlSaio@google.com>
 <20210312093205.GB32016@willie-the-truck>
 <YEs+xi6IDj3gwX10@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YEs+xi6IDj3gwX10@google.com>
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

On Fri, Mar 12, 2021 at 10:13:26AM +0000, Quentin Perret wrote:
> On Friday 12 Mar 2021 at 09:32:06 (+0000), Will Deacon wrote:
> > I'm not saying to use the VMID directly, just that allocating half of the
> > pte feels a bit OTT given that the state of things after this patch series
> > is that we're using exactly 1 bit.
> 
> Right, and that was the reason for the PROT_NONE approach in the
> previous version, but we agreed it'd be worth generalizing to allow for
> future use-cases :-)

Yeah, just generalising to 32 bits feels like going too far! I dunno,
make it a u8 for now, or define the hypervisor owner ID as 1 and reject
owners greater than that? We can easily extend it later.

> > > > > @@ -517,28 +543,36 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> > > > >  	if (!kvm_block_mapping_supported(addr, end, phys, level))
> > > > >  		return -E2BIG;
> > > > >  
> > > > > -	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
> > > > > -	if (kvm_pte_valid(old)) {
> > > > > +	if (kvm_pte_valid(data->attr))
> > > > 
> > > > This feels like a bit of a hack to me: the 'attr' field in stage2_map_data
> > > > is intended to correspond directly to the lower/upper attributes of the
> > > > descriptor as per the architecture, so tagging the valid bit in there is
> > > > pretty grotty. However, I can see the significant advantage in being able
> > > > to re-use the stage2_map_walker functionality, so about instead of nobbling
> > > > attr, you set phys to something invalid instead, e.g.:
> > > > 
> > > > 	#define KVM_PHYS_SET_OWNER	(-1ULL)
> > > 
> > > That'll confuse kvm_block_mapping_supported() and friends I think, at
> > > least in their current form. If you _really_ don't like this, maybe we
> > > could have an extra 'flags' field in stage2_map_data?
> > 
> > I was pondering this last night and I thought of two ways to do it:
> > 
> > 1. Add a 'bool valid' and then stick the owner and the phys in a union.
> >    (yes, you'll need to update the block mapping checks to look at the
> >     valid flag)
> 
> Right, though that is also used for the hyp s1 which doesn't use any of
> this ATM. That shouldn't be too bad to change, I'll have a look.

Oh, I meant stick the bool in the stage2_map_data so that should be limited
to the stage2 path.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
