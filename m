Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8378C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 15:49:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57944610D2
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 15:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57944610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C37D24B086;
	Tue, 20 Jul 2021 11:49:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jtJA-V04oFT1; Tue, 20 Jul 2021 11:49:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96A304B08A;
	Tue, 20 Jul 2021 11:49:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC70749F83
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 11:49:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rol-SVrBHLU9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 11:49:50 -0400 (EDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E30E49F6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 11:49:50 -0400 (EDT)
Received: by mail-wr1-f48.google.com with SMTP id k4so26517976wrc.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 08:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=eXamM+sMZZfyW2rB3syre/v13RlKOutdbrix8Hieb/Q=;
 b=KXp0zKrUI/OXoRw6lXxx2SFUUXaOZwzGxopbvF0uAfHTw7ZmIku2LexAmSY8NEHCGQ
 K5WN0Y8Jo3COz5c3QitqdFAQNczB2y0+XoewDy5ZSAI5R78/TdP4nbqPKFtoTSTfunVl
 bYN8+t4/ZagWjaeYdraSMxMDpI8Hog34PDuKoXSZx9FX+J+2o6wqUoAD9MttLM/PKiro
 OCwm/Cvoam/U9zF03GieeDkrvVkMT0/cqwSXZxbvvcGAbOXoUBAlCKlMWMmqAj7lHMtD
 X5g2NJEkHfXzydWS8RU//uFnq6ZimmZw6TPCCxXOqcqeMnwLuORTvkgHMukdmC1e5bTB
 emKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eXamM+sMZZfyW2rB3syre/v13RlKOutdbrix8Hieb/Q=;
 b=od5LBow1aL0ejuke2E3gWy2EZt+hn9dQecVG6TaE6J/Ipx+3qFIq1mLCI8psAmEg6p
 GSRwuVSfF5TXzJx5+8lfqi86GLZsD9092H48oaU/LPK1gLyL0Vjv+/u1ZSjveWRaqebo
 i2pF6WUdiydF3XbhwPZEFKzmaWzEszWjcT3OlkSbRwgbDj1xA3KofpBsTw3p3wC5bVSb
 qcXdUY/CVbP4OMmpXO0drFqam+1iO5bhoxFkqRxs3gpLhUqm9H1CAvlor303K+8cSaRE
 AjeQu91VXhkKNLqNWOcvkeOKYuNX6HpMVOgl5lI9ZnuYa/mu57XoVCe5GNMIzokN/2Fd
 TwqQ==
X-Gm-Message-State: AOAM5326fP2k1VzE0Dg0PuVOrvAssiwuq/lzmKBQS/5Dj60YjJWe9iOx
 50ceDdhY1q75giFg8hR0OJa2tw==
X-Google-Smtp-Source: ABdhPJyzRWkzFreaGWXMPsTfkWs7PmiScWdF0pFWpbrQIca+q2nIlIPzY5Ms7/DYn3Ihu8xo8lE/SQ==
X-Received: by 2002:adf:efc6:: with SMTP id i6mr36363480wrp.213.1626796189365; 
 Tue, 20 Jul 2021 08:49:49 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:ffa2:b757:e72a:11dd])
 by smtp.gmail.com with ESMTPSA id c2sm23910164wrs.60.2021.07.20.08.49.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 08:49:48 -0700 (PDT)
Date: Tue, 20 Jul 2021 16:49:45 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <YPbwmVk1YD9+y7tr@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
 <YPav0Hye5Dat/yoL@google.com> <87wnpl86sz.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87wnpl86sz.wl-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
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

On Tuesday 20 Jul 2021 at 14:15:56 (+0100), Marc Zyngier wrote:
> On Tue, 20 Jul 2021 12:13:20 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > On Thursday 15 Jul 2021 at 17:31:47 (+0100), Marc Zyngier wrote:
> > > +struct s2_walk_data {
> > > +	kvm_pte_t	pteval;
> > > +	u32		level;
> > > +};
> > > +
> > > +static int s2_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > > +		     enum kvm_pgtable_walk_flags flag, void * const arg)
> > > +{
> > > +	struct s2_walk_data *data = arg;
> > > +
> > > +	data->level = level;
> > > +	data->pteval = *ptep;
> > > +	return 0;
> > > +}
> > > +
> > > +/* Assumes mmu_lock taken */
> > > +static bool __check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> > > +{
> > > +	struct s2_walk_data data;
> > > +	struct kvm_pgtable_walker walker = {
> > > +		.cb             = s2_walker,
> > > +		.flags          = KVM_PGTABLE_WALK_LEAF,
> > > +		.arg            = &data,
> > > +	};
> > > +
> > > +	kvm_pgtable_walk(vcpu->arch.hw_mmu->pgt, ALIGN_DOWN(ipa, PAGE_SIZE),
> > > +			 PAGE_SIZE, &walker);
> > > +
> > > +	/* Must be a PAGE_SIZE mapping with our annotation */
> > > +	return (BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(data.level)) == PAGE_SIZE &&
> > > +		data.pteval == MMIO_NOTE);
> > 
> > Nit: you could do this check in the walker directly and check the return
> > value of kvm_pgtable_walk() instead. That would allow to get rid of
> > struct s2_walk_data.
> > 
> > Also, though the compiler might be able to optimize, maybe simplify the
> > level check to level == (KVM_PGTABLE_MAX_LEVELS - 1)?
> 
> Yup, all good points. I guess I could do the same in my other series
> that parses the userspace PT to extract the level.

Well, actually, let me take that back. I think something like you have
would be useful, but in pgtable.c directly and re-usable for stage-1 and
stage-2 walks. Maybe something like the below (totally untested)?

I could use such a walker in several places as well in the memory
ownership series:

 - following the idea of [1], I could remove the
   kvm_pgtable_stage2_find_range() function entirely;

 - [2] defines 2 custom walkers that do nothing but walk host stage-2
   and hyp stage-1 page-tables to check permissions and such --  they
   could be removed/re-implemented easily as well.

And you seem to need something similar here, so clearly there is a need.
WDYT?

Thanks,
Quentin

[1] https://lore.kernel.org/kvmarm/20210719104735.3681732-3-qperret@google.com/
[2] https://lore.kernel.org/kvmarm/20210719104735.3681732-14-qperret@google.com/

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e0ae57dca827..bd6d26f27e1a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -357,6 +357,38 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
        return _kvm_pgtable_walk(&walk_data);
 }

+struct get_leaf_data {
+       kvm_pte_t *ptep;
+       u32 *level;
+};
+
+static int get_leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+                          enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+       struct get_leaf_data *data = arg;
+
+       *(data->ptep) = *ptep;
+       *(data->level) = level;
+
+       return 0;
+}
+
+int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr, kvm_pte_t *ptep,
+                        u32 *level)
+{
+       struct get_leaf_data data = {
+               .ptep = ptep,
+               .level = level,
+       };
+       struct kvm_pgtable_walker __get_leaf_walker = {
+               .cb             = get_leaf_walker,
+               .flags          = KVM_PGTABLE_WALK_LEAF,
+               .arg            = &data,
+       };
+
+       return kvm_pgtable_walk(pgt, addr, PAGE_SIZE, &__get_leaf_walker);
+}
+
 struct hyp_map_data {
        u64                             phys;
        kvm_pte_t                       attr;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
