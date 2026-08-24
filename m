Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838DE370AFD
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787595081; cv=none; b=Y8+d/5QSU2DnR/hTKeRlLdAOK5mRzPPMkNEBcNsbgeVGEksom0ywRvwlTKYGmlfv3s43xGmfQP5smnKVBsW90bddTq7AA4po9pemqPCrIYfrVanGXnMmfJ7B6OKFUVFA4IR57Zp1HGqexUsKzr02eRI2qyyLBwzmDJvLSvVjWZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787595081; c=relaxed/simple;
	bh=E2jaU37tQeUcIjkW19HoffUL927um7nsAS5L5j9Rxw8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C1ZDA92j+9XI0JQKGbyQmMB/xsadvO9CrmLYbzp/wxDhno+JfEIqAwapK2XSpvlqer3T1X8cRTR+lB78dvjaFKtjTPu8jqCRu/+n3clWQM+LMfIgRLcPlVeocaLrIHUeOW3vqtffWTprw41i+0o7MGz57sxRxjJx1OlH2V1rL+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nUzxDXLe; arc=none smtp.client-ip=91.218.175.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nUzxDXLe"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=E2jaU37tQeUcIjkW19HoffUL927um7nsAS5L5j9Rxw8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787595075; v=1; x=1788199875;
 b=nUzxDXLelmip+hu815qSh/beuiCouJLyJZKXIJyyX6LggKUAFZc+e4lUYu3gfQkTQyEa/w7i
 WHp5YTXx9jDBeselEz65FH84NXA04ha3nsbmv3quJYhUiuX7uolQsbTSytSt2znDFE5QuJmeNh+
 uIZdbSVx0W0kPQccVB/1ki10=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f44.google.com (209.85.167.44)
	by smtp.migadu.com with ESMTPS id 5b52ff1e1ef9fc17;
	Mon, 24 Aug 2026 18:11:15 +0000
X-Mizu-Trace-ID: 5b52ff1e1ef9fc17
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so656e87.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 11:11:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrUl0MrDKqwyxlPZ+zlcQcy7pEU/NlfJOTpI30o9AB8VL2ycalAlmN/1trdo9roakQp8WaiMwQ=@lists.linux.dev
X-Gm-Message-State: AFuF++l4E7Re2cwkpCSoYoQT0d98LIQHof/rFUsZJOCFuyyxqEgo5bxD
	A/E0xsd6WG5VZSEQdflbr030d03WwYvDGIefNdwUZdcfCko4Kdi+/IYckiTYVHYS/xA8mPKhkop
	WFvaCMO13dDQl4dGFKpvqEYxa3jHZ/7ygdrfWYCLt
X-Received: by 2002:a05:6512:688a:20b0:5b1:4fd9:ac with SMTP id
 2adb3069b0e04-5b49cfb11bbmr1e87.3.1787595073680; Mon, 24 Aug 2026 11:11:13
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-11-vdonnefort@google.com> <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>
 <aoxzjag7xr_emuvX@google.com>
In-Reply-To: <aoxzjag7xr_emuvX@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 24 Aug 2026 19:10:37 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxraCfN1bfZ9ygRiyxxyEPeHw4mg6f6O0qzPBpFi165Qg@mail.gmail.com>
X-Gm-Features: AcwNN1XJpoXidKq07m2BnDIJg0Ftg4tyZwrDQ0iNhfHbpQ5gmaLqF6lsd5lLiJY
Message-ID: <CA+EHjTxraCfN1bfZ9ygRiyxxyEPeHw4mg6f6O0qzPBpFi165Qg@mail.gmail.com>
Subject: Re: [PATCH v4 10/17] KVM: arm64: Add a shrinker for pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 17:38, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Tue, Aug 18, 2026 at 04:28:38PM +0100, Fuad Tabba wrote:
> > Hi Vincent,
> >
> > On Fri, 31 Jul 2026 at 15:36, 'Vincent Donnefort' via kernel-team
> > <kernel-team@android.com> wrote:
> > >
> > > Integrate the pKVM memory reclaim interface with the host's memory
> > > management subsystem.
> > >
> > > This allows the host to automatically recover unused memory fom the
> > > hypervisor's heap allocator when the host is under memory pressure.
> > >
> > > Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > >
> > > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > > index d28422f5c3d6..bfbb1266491d 100644
> > > --- a/arch/arm64/kvm/pkvm.c
> > > +++ b/arch/arm64/kvm/pkvm.c
> > > @@ -115,7 +115,7 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
> > >         return ret;
> > >  }
> > >
> > > -static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
> > > +static unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
> >
> > This is the first caller of these, so it is where reclaim starts
> > running against a concurrent top-up.
> >
> > Nothing marks the pages a top-up just put in allocator->mc as spoken
> > for, and hyp_allocator_reclaim() ends with an unbounded drain of it,
> > so a shrink with target 1 hands back the lot. Land that between a
> > top-up and the retry it was for, and the retry asks again, and
> > pkvm_call_hyp_req() goes round.
>
> Sorry, I am not sure I follow here.
>
> IIRC, the shrinker will only reclaim half of what is available. So the pressure
> should be proportional to what is available and limit races with topup!

It's the ordering, not the amount.

topup and its retry are separate hypercalls, lock dropped between
them, so a shrink on another CPU can slip in, right? .
hyp_allocator_reclaim() drains allocator->mc, where the topup pages
sit, before any chunk, so half still comes out of them first: a target
of 1 fails the retry.

>
> However now looking at it. I wonder if I don't want to ratelimit here the number
> of pages reclaimed in one go to limit the time spent at EL2. Especially we do
> all that with the allocator lock taken...

Ratelimiting would cap the time under the lock, but it wouldn't stop a
concurrent shrink from taking the topup pages, would it?

Cheers,
/fuad


>
> >
> > Both are driven by memory pressure, so they are busiest together.
> > Worth holding back what a pending request asked for?
> >
> > >  {
> > >         struct kvm_hyp_memcache mc;
> > >         struct arm_smccc_res res;
> > > @@ -133,7 +133,7 @@ static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsi
> > >         return reclaimed;
> > >  }
> > >
> > > -static __maybe_unused unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
> > > +static unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
> > >  {
> > >         return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
> > >  }
> > > @@ -342,8 +342,19 @@ void __init pkvm_selftests(void)
> > >  #endif
> > >  }
> > >
> > > +static unsigned long pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
> > > +{
> > > +       return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
> > > +}
> > > +
> > > +static unsigned long pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
> > > +{
> > > +       return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
> > > +}
> >
> > Returning 0 rather than SHRINK_STOP when reclaim comes back empty
> > leaves do_shrink_slab() calling this until total_scan runs out, and
> > each call is an HVC. count_objects() covers the case where there is
> > nothing at all, but not the one where it goes stale between the two
> > calls.
> >
> > Cheers,
> > /fuad
>
> Ha right, that SHRINK_STOP seems indeed to be the convention for other users.
>
> --
> Vincent
> >
> > > +
> > >  static int __init finalize_pkvm(void)
> > >  {
> > > +       struct shrinker *pkvm_shrinker;
> > >         int ret;
> > >
> > >         if (!is_protected_kvm_enabled() || !is_kvm_arm_initialised())
> > > @@ -359,10 +370,21 @@ static int __init finalize_pkvm(void)
> > >         kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
> > >
> > >         ret = pkvm_drop_host_privileges();
> > > -       if (ret)
> > > +       if (ret) {
> > >                 pr_err("Failed to finalize Hyp protection: %d\n", ret);
> > > +               return ret;
> > > +       }
> > >
> > > -       return ret;
> > > +       pkvm_shrinker = shrinker_alloc(0, "pkvm");
> > > +       if (pkvm_shrinker) {
> > > +               pkvm_shrinker->count_objects = pkvm_shrinker_count;
> > > +               pkvm_shrinker->scan_objects = pkvm_shrinker_scan;
> > > +               shrinker_register(pkvm_shrinker);
> > > +       } else {
> > > +               kvm_err("Failed to register shrinker for pKVM\n");
> > > +       }
> > > +
> > > +       return 0;
> > >  }
> > >  device_initcall_sync(finalize_pkvm);
> > >
> > > --
> > > 2.55.0.508.g3f0d502094-goog
> > >
> > > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> > >
> >
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> >
