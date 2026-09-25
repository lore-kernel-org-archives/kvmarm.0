Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4BA381AF0
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348564; cv=none; b=LyqpvchABEMERB50FgVCwL2IpS7f1TJ6DziLZv9D+QsPR6DMAKo7AQ5AiiEe6bnLOqFkRZ25rsWe+RxItS78Rqvpuxjfy/ZInyzuSVac1WETdnToFFOpPSPFuYi43DnFpxWJMqI6MRUUZXEvif//VRn3q1vWy7Oz3PqOEVk0cto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348564; c=relaxed/simple;
	bh=rTrm4vM2zJ0jSJraYrYS+k71Y/VdjxgDn0ElPc4aI1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6efPLz/89q3TOKSFS6F2kp6zs695OM8gAsmBdKoexSp2Z0x6Xqb/Wde+pqqkjPsvNGp7bX4YJaDusasJkVcM+rebp5kkm27wZGzf7ni82Yuy6eZg49eQdAOs+rapy99R/Efwg2vtjtUKBh6PSJc391M46serdOi7QsjTQwzMo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wBEYOrPQ; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wBEYOrPQ"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so6243235e9.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 08:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790348555; x=1790953355; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uQbHVyvOfJT59Z1tjcStlzFu/GfhyqjlrHuEPmE7uTg=;
        b=wBEYOrPQy00fDiMal7JEh1zzSUvu2WdYAYTmza1eAWYSwsXbLuev0yKdp09WKGn2fp
         OO41nAtPzVsd7Nj9na+R6sXdEHLCxVjUtnwhLNr3De6qR/FkiXO7nLKAiNSSRJ0DL32Z
         yxd/LVNRfr6pXgE+DhB/NUUZQ1oaqic9yRCN3r1Nj5rzLM2ovo8M+EHuDvDN72PFlt1h
         iO2AfatHlREn26GsQRJTPuEvmL+7TFNoPkEMNAUupI9H8GFq7FF9moPAkcU09ophzL0C
         UlQPJsbQd//ajYqBGWKs2JkJCfA/U21N82laO+2uF9u9KZoPqG3t8uE+UJ0cCKeGnqyz
         R5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790348555; x=1790953355;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uQbHVyvOfJT59Z1tjcStlzFu/GfhyqjlrHuEPmE7uTg=;
        b=QiihbHPlrP1qDrQq3j0jpw82EYh3qlqk357M6zxu3V2k68xD5zpo/Whl7WzOwf5IPP
         Ob3aViy6+a7pmR1Q8AZ+ES0FleZLa4NVWdr60WV05soZa3pjZhpkNTswX6CyNgqIgwEl
         KXVzLCbyJW4JqeRPSFeFsHiLTYMryar4KE2OD9XZkgBy1Oh+I60tFl07x5XLG3SybTnq
         xB99g/243gEb0+qlDcDXD4NkisGPhkV1i9DdaKuu6/uRu4/GakDxKehCu1lxIe7HlL66
         eP4XjgNMQCSnoFqnOnrn7asBVQvXL/x9U2BDwSnJtXjjjlbvUCRpdBHQtGfEoPgFyphN
         S4Tw==
X-Forwarded-Encrypted: i=1; AKwUvBwGJiTs2RYfcsgYlAWhi/7Par9hMlTqwbYNjJfE3DIbOaoSGi9WnHJcaM6u1mYC5BnsxphPMIc=@lists.linux.dev
X-Gm-Message-State: AFuF++l2lK+7Y9fsBgxhg7PV6i4Ho1kJTVVzQDSgt8t2KRj5gnTNye5g
	629BxPZbbKSl+M0Ydw3aLzcraoB008ygLe/XLy3nm6JSTPzy5HcXWSbX6TEh2wqa7g==
X-Gm-Gg: AYBFou0+v4rfYuavcONY9HbrNfc0hjZTM5pmlDcpxhI0w90pzgoHZ09P4bRexa4KvTB
	fYVWlskzRI6wbNzFpvcIaG2eb52rm1pR4Fs7L8fYp9rdg3Mk9vZwAV2og91rMXhkq2LEkX3VGCf
	5Ea1nn7xGhreWIuyV1XYXpl/IUiQQLcE76LoAbhdA4g/KywSUUT9EmJiAhr2S/+ByYbQ9ctP5TT
	jRv+E337yHaDUWL1FCpxaOZB7PrFGsBSRx7a5fmQT/L8On82DzuQzr1PK8LJ5FJfoUu5eylWbRx
	mn5F/Cn8WbpUOS2DUSwx7Rldka9DffJePDzmRqg4+nku064Gp9i3hr/1MUCipcw9L9NhtCU4wy/
	JLIY+5w9rMH2wOiZp/aZTTSmS507NRdWZwOafFPeBSaJJon0RMgIvJDeieg9m8Icm2NJ4+Ny83R
	oFj/YLmslBuCW1MHN4ZmDnGKCEqNASGDjMhxEfjny14mn0tI2GOrxDmWCOxlfoJy5qynz4QjgR4
	WUyTLzhLzV2/xa9l/pBxwjvZ1wwzxSTn8x1T9S2Efg=
X-Received: by 2002:a05:600c:4594:b0:49e:6249:268b with SMTP id 5b1f17b1804b1-49fe6707f69mr117966225e9.32.1790348554298;
        Fri, 25 Sep 2026 08:02:34 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff06bdef2sm66540075e9.11.2026.09.25.08.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:02:31 -0700 (PDT)
Date: Fri, 25 Sep 2026 16:02:27 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, weilin.chang@arm.com,
	Keir Fraser <keirf@google.com>
Subject: Re: [PATCH v2 01/22] KVM: arm64: Prefault host stage-2 entries on
 block split
Message-ID: <araNAy968NbQkfer@google.com>
References: <20260911135053.146435-1-vdonnefort@google.com>
 <20260911135053.146435-2-vdonnefort@google.com>
 <arVgKRqRRon00wTD@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arVgKRqRRon00wTD@google.com>

On Thu, Sep 24, 2026 at 05:38:49PM +0000, Mostafa Saleh wrote:
> On Fri, Sep 11, 2026 at 02:50:32PM +0100, 'Vincent Donnefort' via kernel-team wrote:
> > From: Keir Fraser <keirf@google.com>
> > 
> > For the host stage-2 that is idmap, we can avoid lazy-mapping on block
> > splitting by propagating existing valid mappings to neighbouring entries
> > of the new table.
> > 
> > Signed-off-by: Keir Fraser <keirf@google.com>
> > Co-developed-by: Quentin Perret <qperret@google.com>
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index b74dd5ce1efd..34f78a58cded 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1030,10 +1030,39 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
> >  	return 0;
> >  }
> >  
> > +static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
> > +{
> > +	kvm_pte_t block_pte = ctx->old;
> > +	u64 pa;
> > +	int i;
> > +
> > +	if (!kvm_pte_valid(block_pte))
> > +		return;
> > +
> > +	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
> > +	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
> > +		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
> > +
> > +		/*
> > +		 * Skip ptes in the range being modified by the caller if we're
> > +		 * installing last level entries. Otherwise, we need to
> > +		 * temporarily put in a valid mapping to make sure the
> > +		 * prefaulting logic is triggered on the next
> > +		 * stage2_map_walk_leaf(). This adds an unnecessary TLBI as
> > +		 * we'll presumably re-break the freshly installed block, but
> > +		 * that should happen very infrequently.
> > +		 */
> > +		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
> > +		    (pa < ctx->addr) || (pa >= ctx->end))
> > +			*ptep = pte;
> 
> Do we need now to call get_page() on the table as we are installing a
> new PTE?

Ouch, I really start mixing android branches with upstream... I thought this
wasn't an issue because the host stage-2 doesn't refcount valid PTE... but this
is only true on Android branches, not in the current upstream...

So yes, you are right (and so were Wei-Lin who reported it as well on v1), I
should move the if (counted) get_page() from PATCH2 into PATCH1.

> 
> Also, I think we need a WRITE_ONCE() for the PTE write.

This one though I am pretty sure it isn't needed because of the
smp_store_release() when replacing the PTE with a table.
> 
> Thanks,
> Mostafa
> 
> > +	}
> > +}
> > +
> >  static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >  				struct stage2_map_data *data)
> >  {
> >  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +	struct kvm_pgtable *pgt = data->mmu->pgt;
> >  	kvm_pte_t *childp, new;
> >  	int ret;
> >  
> > @@ -1051,6 +1080,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >  	if (!childp)
> >  		return -ENOMEM;
> >  
> > +	if (pgt->flags & KVM_PGTABLE_S2_IDMAP)
> > +		stage2_map_prefault_idmap(ctx, childp);
> > +
> >  	if (!stage2_try_break_pte(ctx, data->mmu)) {
> >  		mm_ops->put_page(childp);
> >  		return -EAGAIN;
> > -- 
> > 2.55.0.1007.g17ff1f9808-goog
> > 
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> > 

-- 
Vincent
