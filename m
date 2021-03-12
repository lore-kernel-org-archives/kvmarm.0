Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB466C433E6
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 10:13:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CB1564FD6
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 10:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CB1564FD6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C89504B191;
	Fri, 12 Mar 2021 05:13:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aHTaYiSZOd6P; Fri, 12 Mar 2021 05:13:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8304A4B2F2;
	Fri, 12 Mar 2021 05:13:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 986344B1C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 05:13:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zX4ndmtL+2fn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 05:13:34 -0500 (EST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03C664B191
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 05:13:33 -0500 (EST)
Received: by mail-wm1-f42.google.com with SMTP id
 b2-20020a7bc2420000b029010be1081172so14831660wmj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 02:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dOH5AK+PAfRAsg2dxAdQE8C774VeCltqpKz+okkVeFM=;
 b=OQyevQU51Wt1xnh2LbX/w1hCSfiwz6KAaijoqwJz0R8Wjxrl8Uep70/qnj/OCN76EJ
 zF1lDsjWFBn//WEW76/aHd88jg2/A3oLTLTdCoEH41VqrLnPwfka/vDfXzhgvKKz2hwh
 Bw5aWs/xlmjzVaxZfgDMnWoYGONap/ih6d6St4+g2PG9ckB2n1Sh7VojdF0bX3prNspp
 kOjtaPujuw5izKVEhe6VmVy5Ut/10+gwAMKKGLJsN52lPb6tkRsQFegz3mLkvdUqs7Gl
 69DP+TmO9mqm0hSj6w62fHZEarnptc9hBY8JXn2fANa1fWzKp4/xHqI1UndehrCgdbcv
 oJKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dOH5AK+PAfRAsg2dxAdQE8C774VeCltqpKz+okkVeFM=;
 b=VX/vmOQ72TaSLFIqTVr4/Gqrj0ScXgSYNkmvUleXC1OZzm7Ckg6OXrzQAzUasC2MBM
 W/+nEUCJDppjoMBWC4ysRkDjrBXRbojU2pLOJirmPgfb8TBdJxG8es8zE0mkufiRSQFo
 phzGdv12IT/0DQQHf0nR3oW2MKrQzXpSMcTNFEqm3CynX9L8aKeduo9zUTPxm80/ZmD2
 FYeWRXn/097dvuWcT260JfDW3bNsUAZ2DL/E/xCupxpLcJAP4Foa9evcRv50yb2WTOwY
 Pbii2WiRHdiAFTCr1eLNM2kg/pelVC+Ea9ceJ8EvJE970FJLwC1rLoBKg7gOjed03ZXc
 PE0Q==
X-Gm-Message-State: AOAM531p5C4FQ9GL41GM1O5QDj8Xkh8KyDsdxHgBVaZ5JSBFQpJm2H7l
 hyTbwsf7L0aggvWzWHsGrAt2lg==
X-Google-Smtp-Source: ABdhPJzs2CwFIhMIFHCtWhF0Kk8Mn96x94X3sQBAAfKwNZIrb+5CYxK9LtqpnTzDcLxhgVyEpFqTlw==
X-Received: by 2002:a05:600c:224e:: with SMTP id
 a14mr12231304wmm.57.1615544012774; 
 Fri, 12 Mar 2021 02:13:32 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id h25sm1933615wml.32.2021.03.12.02.13.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Mar 2021 02:13:32 -0800 (PST)
Date: Fri, 12 Mar 2021 10:13:26 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 28/34] KVM: arm64: Use page-table to track page
 ownership
Message-ID: <YEs+xi6IDj3gwX10@google.com>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-29-qperret@google.com>
 <20210311183834.GC31378@willie-the-truck>
 <YEsIxA/fKaDlSaio@google.com>
 <20210312093205.GB32016@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210312093205.GB32016@willie-the-truck>
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

On Friday 12 Mar 2021 at 09:32:06 (+0000), Will Deacon wrote:
> I'm not saying to use the VMID directly, just that allocating half of the
> pte feels a bit OTT given that the state of things after this patch series
> is that we're using exactly 1 bit.

Right, and that was the reason for the PROT_NONE approach in the
previous version, but we agreed it'd be worth generalizing to allow for
future use-cases :-)

> > > > @@ -517,28 +543,36 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> > > >  	if (!kvm_block_mapping_supported(addr, end, phys, level))
> > > >  		return -E2BIG;
> > > >  
> > > > -	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
> > > > -	if (kvm_pte_valid(old)) {
> > > > +	if (kvm_pte_valid(data->attr))
> > > 
> > > This feels like a bit of a hack to me: the 'attr' field in stage2_map_data
> > > is intended to correspond directly to the lower/upper attributes of the
> > > descriptor as per the architecture, so tagging the valid bit in there is
> > > pretty grotty. However, I can see the significant advantage in being able
> > > to re-use the stage2_map_walker functionality, so about instead of nobbling
> > > attr, you set phys to something invalid instead, e.g.:
> > > 
> > > 	#define KVM_PHYS_SET_OWNER	(-1ULL)
> > 
> > That'll confuse kvm_block_mapping_supported() and friends I think, at
> > least in their current form. If you _really_ don't like this, maybe we
> > could have an extra 'flags' field in stage2_map_data?
> 
> I was pondering this last night and I thought of two ways to do it:
> 
> 1. Add a 'bool valid' and then stick the owner and the phys in a union.
>    (yes, you'll need to update the block mapping checks to look at the
>     valid flag)

Right, though that is also used for the hyp s1 which doesn't use any of
this ATM. That shouldn't be too bad to change, I'll have a look.

> 2. Go with my latter suggestion:
> 
> > > Is there ever a reason to use kvm_pgtable_stage2_set_owner() to set an
> > > owner of 0, or should you just use the map/unmap APIs for that? If so,
> > > then maybe the key is simply if owner_id is non-zero, then an invalid
> > > entry is installed?
> > 
> > I couldn't find a good reason to restrict it, as that wouldn't change
> > the implementation much anyway. Also, if we added the right CMOs, we
> > could probably remove the unmap walker and re-express it in terms of
> > set_owner(0) ... But I suppose that is for later :-)
> 
> The idea being that if owner is 0, then we install a mapping for phys, but
> if owner is !0 then we set the invalid mapping.

And I could even special-case set_owner(0) by calling unmap under the
hood so the caller doesn't need to care, but it's a bit yuck.

> (1) is probably the less hacky option... what do you reckon?

Agreed, (1) is a bit nicer. I was also considering setting phys = BIT(63)
in the set_owner() path. That makes it obvious it is an invalid PA, and
it should retain the nice alignment properties I need. But I suppose an
explicit flag makes it easier to reason about, so I'll have a go at it.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
