Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9442E289367
	for <kvmarm@lists.linux.dev>; Sat, 18 Jul 2026 19:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784404509; cv=none; b=OT3fO49mgBmPihbe5+koRymdSg2r+/ZI69bd/Y5F5ILK07zq+Ncr8aaUs+/h/U9WO6uTIcbI1cIHjcU3oIwgY/JovF4sbkM4dEWsoBsPXlFQIvJORSaEBCOCGQXWjHlXAc2W0VGbPScpNr0KivaTTeHZaRfm+8W2AWei7j46N4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784404509; c=relaxed/simple;
	bh=hZdtk/8woaKTNLmw0wtSCx9vrBFUx14/5HBeedVZsVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=My+/0jZ84MhKSlpxfI81BmRd+axm6EvBZ8OG/+z1GcUlUgqu+b6TUkJu/sY2Y9u3lZumtMoxDxz2uyntQmmaq47il9DizpERjZ/HTkfJ3IUQ10LZhex0/zfOUK3AJJ9QyEt8pzuBqJr2M0NjvooHy6NSZr0yDIHZdUKS2D0Eqf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QiBHhxK/; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QiBHhxK/"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954d5d814fso60315e9.0
        for <kvmarm@lists.linux.dev>; Sat, 18 Jul 2026 12:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784404505; x=1785009305; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/OtteCJd5kLZ2hGXBwK3WYGu95XqRXhomwJCp9pxwjE=;
        b=QiBHhxK/TEHmKL8K+5QXeassH+BLT4Itsl9No9Vqcm0pTtaBIMwCGm2kt6opvL26FA
         mS0gRGYsLMuXErfKEwJi8cd2SqUHn1767H6tWKPqU04zwpaE+IwPibCHb2kSCIuKbRRK
         vaqr/pSBqVsKcAb3v6u/rzz3+zYS+88a3PlOI2odpAys/aLE66gxfcOGVMouIASFyFS1
         kZUv2XoenDHmAAsaUoL3zqY/lVGt5lXo9A7psPUFAbDmJInbfnvPi2dGF5N6SYxue3ZP
         DtdwqFWR5goTO4Vx1L6ttYzcE5bKB6xv3sBw+EsNaPIVxJr5t/e4WMD85QCppLhVlx/U
         X0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784404505; x=1785009305;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/OtteCJd5kLZ2hGXBwK3WYGu95XqRXhomwJCp9pxwjE=;
        b=GM/tRi5g4GHSTcP6DzLSDhc9pUElY6C6byrwzIWvAFX8rxmU2dlHzDYOC7agieeQe+
         FWWHK/mS1rzlXgXsjOxNPYxMaUxp/mE6URnwak4xA1RttL+PQhpzrSAjQhN499Ur1ZuH
         W/LcTwCq2w17dw1rWMQT1jZ8r9NY/JoL2dvwcbi/Gje55wdREVEWTMadn76a2UAzYeZS
         YWmBtz3i/uqbgBHAnenRX1pMGM4mfcwN4EEXfTrd0YFvbbGcbIo/QcK9j3DnG8irUq4O
         aMYKzc7KSLpmsM5mHHhEUzgENE6WQeIIVS4gxKlg4BjYRDH4EUdnVCfOQJ105BtZGWk7
         drCQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr7mDExI+5Xazj9eL9jPcfv55RcHwWqB92g+iaom3sq723Bwz9+P9pBgcBFCrLBUWA0gavzCz0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3d/U+kaPFSxoolNIJ/iN948jgufBpJCwQas8XKko8MEPiZw8x
	IAzC1+irkD930VDlBG0k60+w9aGWseqQr/CQn1GL/pdMuKVaICVCT5UTcDX7MGKELQ==
X-Gm-Gg: AfdE7cmccu/x2w88xHt1n9Cs/H3KRYxiydaiBUjo+iuDtLA9ieY7yYc5hr2eqbqxyqZ
	oKRZV8PxdZ8CrjbvF3ETMmBB/J3LDImfGeevsWoihAZoJO9MZwqKE3FNrlaZXW6/Lul7R+Ro6H5
	oJZZv11KjOuxeZCrowkJnyMwwfNDhFgivg5ObPcilypwzdy0rsBgAKV7L2IOYm84gj4eigfV5eo
	vOyWr2JjEYMgqumXlHMYLISCa/TSAta12KlpTu/ydbm26cwMPo1X7H6Bk2zJlmqnktwA5wHR2V/
	uQiHqphzbymtqm29I4xaC6QNAVZNrofJZ1ajKeziJ4iios3Fsc+9sSjql5afPiRsxNKvEVfJabF
	7Am8t1BwJvyuV8hvyJYMxh2UIXgWfa/PLb2tTidVnatkswW/5eZExnd+yEM3nIbClTXIRMdSu38
	F9/jemUWH00kzVh3/3qkav/GTSctCizYm9XwhoqA==
X-Received: by 2002:a05:600c:4995:b0:493:a96b:f9fe with SMTP id 5b1f17b1804b1-4954ff99257mr1026495e9.4.1784404504362;
        Sat, 18 Jul 2026 12:55:04 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549a36312sm161560395e9.2.2026.07.18.12.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 12:55:03 -0700 (PDT)
Date: Sat, 18 Jul 2026 19:54:58 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	vdonnefort@google.com, tabba@google.com
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3
Message-ID: <alvaEgJFJ5DaQaac@google.com>
References: <20260717130901.2239134-1-smostafa@google.com>
 <20260717130901.2239134-3-smostafa@google.com>
 <alqW49CH7eViDpAZ@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alqW49CH7eViDpAZ@kernel.org>

Hi Oliver,

On Fri, Jul 17, 2026 at 01:56:03PM -0700, Oliver Upton wrote:
> Hi Mostafa,
> 
> On Fri, Jul 17, 2026 at 01:09:00PM +0000, Mostafa Saleh wrote:
> > If the system supports hardware Break-Before-Make (BBM) level 3, use it
> > to replace stage-2 PTEs directly instead of falling back to the software
> > break-before-make sequence.
> > 
> > 1) Get a reference count on the containing table for the new PTE.
> > 2) Atomically update the PTE with the new valid descriptor.
> > 3) Invalidate the TLB for the old PTE.
> > 4) Drop the reference count holding the old PTE.
> > 
> > One interesting case, as BBML3 will update the PTE atomically, it
> > can only know it raced with another core at the point of the cmpxchg
> > failing, unlike the SW implementation which locks the PTE first.
> > And as we must issue CMOs to the new mapped page before the update,
> > that means with BBML3 racing cores will issue redundant CMOs,
> 
> I'd rather we just predicate BBML3-style transformations on an
> implementation having FEAT_S2FWB and DIC. You can definitely come along
> later and enable it when using a stage-2 in an SMMU makes this
> mandatory, possibly at the expense of some extra CMOs.

Makes sense, I will do that in v2.

> 
> There's also an extremely subtle detail that BBML3 enablement relies on,
> which is that KVM will never change the OA of active translation. IOW,
> if the host is moving the PFN we expect an invalidation before
> re-mapping it.
> 
> I have no issue with relying on that behavior but we should make that
> assumption abundantly clear.

I see, I can add a comment as:
Note: we assume that KVM will never change the OA of an active
translation. If the host needs to move the backing PFN,it should do
an explicit unmap to issue the required TLBI.

> 
> One of the things on my wish list for a while has been rebuilding
> hugepages after dirty logging is disabled on a memslot. That seems like
> like a very good optimization to do when BBML3 is present.
> 

In android we have support for coalescing for KVM_PGTABLE_S2_IDMAP
on map, that does not rely on BBML3, maybe this can be added in a
follow-up series, and eventually extended to be more generic.

https://android.googlesource.com/kernel/common/+/refs/heads/android17-6.18/arch/arm64/kvm/hyp/pgtable.c#1107

> > to improve this:
> > - We only use BBML3 if the old PTE was live.
> > - To reduce the window of the race, an early check is added before
> >   the CMO to exit early, but that does not eliminate the race.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 53 +++++++++++++++++++++++++++++++-----
> >  1 file changed, 46 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 127b7f9541b1..69d52308236f 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -838,7 +838,8 @@ static void stage2_clean_old_pte(const struct kvm_pgtable_visit_ctx *ctx,
> >  /**
> >   * stage2_try_break_pte() - Invalidates a pte according to the
> >   *			    'break-before-make' requirements of the
> > - *			    architecture.
> > + *			    architecture, if BMML3 is supported it
> > + *			    will be used, otherwise fallback to SW.
> >   *
> >   * @ctx: context of the visited pte.
> >   * @mmu: stage-2 mmu
> > @@ -854,6 +855,18 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> >  {
> >  	kvm_pte_t locked_pte;
> >  
> > +	if (system_supports_bbml3() && kvm_pte_valid(ctx->old)) {
> > +		kvm_pte_t curr_pte = READ_ONCE(*ctx->ptep);
> > +
> > +		/*
> > +		 * All handled in stage2_make_pte(). However exit early if we already
> > +		 * lost the race to avoid extra CMOs.
> > +		 */
> > +		 if (curr_pte != ctx->old)
> > +			return false;
> 
> Does this race detection actually move the needle? We haven't gotten
> very far from the read in __kvm_pgtable_visit().

Yes, doesn't seem to help much with the current users, I will drop it.

Thanks,
Mostafa

> 
> Thanks,
> Oliver
