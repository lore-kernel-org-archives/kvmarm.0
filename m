Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570E6C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 15:57:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2C7B61279
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 15:57:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2C7B61279
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE0240895;
	Mon, 19 Jul 2021 11:57:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zx5qoCR0ULT6; Mon, 19 Jul 2021 11:57:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5706049F8F;
	Mon, 19 Jul 2021 11:57:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC0949F8F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:57:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ubhBf-3d6Cpq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 11:57:02 -0400 (EDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8E1D40895
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:57:02 -0400 (EDT)
Received: by mail-wr1-f53.google.com with SMTP id g16so22665832wrw.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 08:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=lqk2jkzthWLyzhPPwl9UElGn40y2Dt6x0oKXE1RM9g8=;
 b=jI3en6+L35OGQjtiyLEBUmVWVLufhxwq/1aOfwuDJV44bcq1jbW0DRpXwwWlYvSdMk
 e4Xm3XmGv35SIVRFvfDV0Fdm1m0G59WRs/JZYelzbtxZfeEOv0+E2rKlGbQ1frzNzc76
 fXzvmTXp+dnZBCwUIz5YNwPAkhnsQdXVRzQKoZsBp43fwvrYi9RgXPvTk1n7ltpWSPVQ
 IZp88OIXUDGh7cL1PTzzyxgcCC1TNFv7J2WYENBPUFn78VP+iJbtcr9SZZkNqNjdndnk
 FQG0OmlrWdFs0XoRXmu2H2p3Dl+9wpibmflX0a+iE/KQ2XvTufMt3nNZvVUNv9GRNHov
 34sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lqk2jkzthWLyzhPPwl9UElGn40y2Dt6x0oKXE1RM9g8=;
 b=Mftjol5YO/Vph3myEdKIA5cmB5G+Y69qBXmOfylSpnfk7yVJF0Ixod7QPVfY4DYkzr
 hWOu91+NSEVFFcxaSrvgOfrD3EmUMQ26HjqbN5d0pJHabLhbtq5ZvkpR0fivXPYm8DAb
 yoJjbAV7atBc0zHwaVxNqnlzIgYivy6XmGkJ+WDxHPHqUKqvhG1IDpCh7Y92CDe2Hwgk
 uRM3L1ULgjDfLlpS7EkQ97WECcsbY5anlVb6mdw/x9CsVgbc+SAOE+Gxhw/4QlI2AuS8
 QYYLu3liu3spvOBB5TS+IdQpB6ck9gCpkwYgc0BD0+MpUKGIFqBTXuqVvKTohaWSzdwD
 1ruw==
X-Gm-Message-State: AOAM532gU75ixFoirRPkvfO4A9kwyfEQLwaX4IlSAPx2tLpMjB+d85Yh
 By5KhRzM+J2oZaSNWdENtxBagA==
X-Google-Smtp-Source: ABdhPJxpNsB2RMnrXBTt9Gp1trnlhrfx+X5PhpEBH6aIheVp4g43w00+TxDIiSELO95IVAOEFTQhhA==
X-Received: by 2002:adf:a41e:: with SMTP id d30mr30429082wra.10.1626710221588; 
 Mon, 19 Jul 2021 08:57:01 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id w16sm6652930wru.58.2021.07.19.08.57.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Jul 2021 08:57:01 -0700 (PDT)
Date: Mon, 19 Jul 2021 16:56:57 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 09/14] KVM: arm64: Mark host bss and rodata section as
 shared
Message-ID: <YPWgyS7i2sMtiX8S@google.com>
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-10-qperret@google.com>
 <87eebujqjv.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87eebujqjv.wl-maz@kernel.org>
Cc: kernel-team@android.com, qwandor@google.com, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Monday 19 Jul 2021 at 16:01:40 (+0100), Marc Zyngier wrote:
> On Mon, 19 Jul 2021 11:47:30 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > +static int finalize_mappings(void)
> > +{
> > +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RWX;
> > +	int ret;
> > +
> > +	/*
> > +	 * The host's .bss and .rodata sections are now conceptually owned by
> > +	 * the hypervisor, so mark them as 'borrowed' in the host stage-2. We
> > +	 * can safely use host_stage2_idmap_locked() at this point since the
> > +	 * host stage-2 has not been enabled yet.
> > +	 */
> > +	prot |= KVM_PGTABLE_STATE_SHARED | KVM_PGTABLE_STATE_BORROWED;
> > +	ret = host_stage2_idmap_locked(__hyp_pa(__start_rodata),
> > +				       __hyp_pa(__end_rodata), prot);
> 
> Do we really want to map the rodata section as RWX?

I know, feels odd, but for now I think so. The host is obviously
welcome to restrict things in its stage-1, but for stage-2, this is
just 'memory' so far, the host is allowed to patch it if it wants too.

Eventually, yes, I think we should make it RO in the host stage-2, but
maybe that's for another series?

> > +	if (ret)
> > +		return ret;
> > +
> > +	return host_stage2_idmap_locked(__hyp_pa(__hyp_bss_end),
> > +					__hyp_pa(__bss_stop), prot);
> 
> If the 'locked' state implies SHARED+BORROWED, maybe consider moving
> the ORRing of the prot into host_stage2_idmap_locked()?

Ah no, sorry for the confusion, but 'locked' means that we already hold
the pgtable lock. That is not actually true here, but this is a special
case as only the current CPU can be messing with it at this point in
time so taking the lock would just be wasted cycles.

> > +}
> > +
> >  void __noreturn __pkvm_init_finalise(void)
> >  {
> >  	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
> > @@ -167,6 +199,10 @@ void __noreturn __pkvm_init_finalise(void)
> >  	if (ret)
> >  		goto out;
> >  
> > +	ret = finalize_mappings();
> > +	if (ret)
> > +		goto out;
> > +
> >  	pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
> >  		.zalloc_page = hyp_zalloc_hyp_page,
> >  		.phys_to_virt = hyp_phys_to_virt,

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
