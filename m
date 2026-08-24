Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB147371867
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787589527; cv=none; b=RiPFRwoXMZ32cMR2So3FWEIS2FOylaOrGuPeYm6RU1Ne6MY0sqsM1w51aYRF+xquzEdvtxAVltxHBqhs3klMIldHAzkZnypeAhjfHD+bnjgvVFxN+yqeA9VJbWfzkr71v4JDJ/n8PVaj/B/nclz32pJJQWVnFEzxIJagcKSLqmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787589527; c=relaxed/simple;
	bh=xtFg3MKYp+d+9xVLdhid5iZBnFp/CufuOO5e6Jf9Imw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NXYjDzr0ZbRXGTpmNr5RyD6Q2gn5e1YnAx9OFULGnXBCjewDavhQYwjUaG6eMcWt77iyuxIUxDO4RYM1LXfMcals7fUi3FWO4yDcMYhnnSy9GAhrA3RM6LYSXc7ABCKNXjiZWPQqDztW47gODm+QVZh+izzwIA+0zfQHasiovPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LGMRoJQh; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LGMRoJQh"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f703a9d05so1805175f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 09:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787589522; x=1788194322; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Oifvu65sIA0XdhJEnNqAtZI4A+dT6SUlucjIQqK6vsQ=;
        b=LGMRoJQhyGJHDO/7kcImPjrg+dWDlIQ+TkpODK0s7Qo/CIAyBOxSNrnKVm3Lk+za5A
         UdLEGDsaVJZpekU3R29op3Z54+OcxuDCcOVXoahCfPSr7EzPvXnrY9X16KWX1OtvBM8Q
         utlxCk1M3G+P0M9UVNDzGRT0ocoFj2Wszr9hhGMNvHuH0IMcZwtwmduFPOnFJ0PeVF25
         tjCh5TZtMgceH49cNXVOqFUM1aCItonzQAtHBWy40kBFh65zTR1/bDmJTcjhl3dGyvFh
         /+34Zo8RNZ7HGfPeNiqIqgUS+YA86TeVLAdz5RB02ZsTMp5KtBp1sBj4cmyntSpNmPBu
         k96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787589522; x=1788194322;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oifvu65sIA0XdhJEnNqAtZI4A+dT6SUlucjIQqK6vsQ=;
        b=D3sFYX1Zl04SsLKN11Y5cmvBSx66WcYNDqptrbQIQ3x5Nx45Yv/ZDkh3ErS+0wepma
         7iApdK2O3pRA1oX3aifFzOkR/t8Fnav22W+k5I2TwgoxE8p0/6f6UWgwmZ8coyW+iDtq
         djDjo03jAx+1BlpuK+4GBtVXCUzjSme/wfcnuAIab6DpiMC4/dAfixFeGcwr2iTXD29K
         Hz7j6yFYivzReHmG0VFTOp90uRLsMBLqWTuWF6aChCJoI4U5POBR9qy4pIqxNMM9SHV1
         Qwguj/9igYRs8gmlCr6froJdjJ7On0g6lvBDr7pEtf6ySnUSgOBDP7cSXhdIrKBbG+a5
         i/UA==
X-Forwarded-Encrypted: i=1; AHgh+RoVLTTPGbgKmcuZIoIHl3MIwwsMJotFs1+v1a6IfgyfYU6CLlONuWYSGLgRnQR0X31XNOXJ7fw=@lists.linux.dev
X-Gm-Message-State: AFuF++k38PkTp1S5RKYXbUgFYlJH52cLj5SXRCB0MAruAXx46RpS3MZy
	qSmnUaCX2cyR9o0z2xGOBPmaDerG3q8W+BmK9GrPHM70EU7sRXQJ0xEEgbYum26jiQ==
X-Gm-Gg: AR+sD12qrJE+SSvJKZAoVtGBzqNOuzYJvmHXepdN1hogFt7RD+8XrrLjc8r//dno7cH
	hRSq9A5kA8y2LW6vIDBEWKoHsAz/GUF/2fWgu/XMohyzrWTSE/wIOrdH7IF5Fnkq25M96hf8zi3
	CTvyYxIbj/h+NpFKTQHqQ/r3ZmhlUi1qWSnqvrMvV4fRrQtZAGHX1KlAbHZbTcRhBMbpa6jYmLM
	tGLqKdeW80QZgkX40Pdn3hwa8Hld2fMJuhQKIftCNmpXfKq6wr5ZAVMiyw09oaOD44F5RkDLN1M
	aHAA3wa+FWr0btLdKtDK2o72R1dSbfTiPoHUamhISQY6c1NVf3P7RzzLthxJF1nJJ1IsNb7TvP7
	7zX5+FwLazEke4YCLIcyNMs72gFlIchXdhc6iVKK0mT5cs4or3fKdjwRm8vpzr0m4aayQNDGPAL
	WdfV22IxO9SXJArEBrkD0XpQPMwDuNeZnXv6Mt8ZlDAD21IWL6oHo1x++mPpXmIzMdtVPlGitbN
	f6E5MvvXklrmrLJJDR492xHmpgzeQt/
X-Received: by 2002:a5d:64c4:0:b0:47f:e377:8d61 with SMTP id ffacd0b85a97d-482c0b99d81mr33579028f8f.11.1787589521794;
        Mon, 24 Aug 2026 09:38:41 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482c9b69a60sm8912087f8f.1.2026.08.24.09.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 09:38:40 -0700 (PDT)
Date: Mon, 24 Aug 2026 17:38:37 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v4 10/17] KVM: arm64: Add a shrinker for pKVM
Message-ID: <aoxzjag7xr_emuvX@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-11-vdonnefort@google.com>
 <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>

On Tue, Aug 18, 2026 at 04:28:38PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Fri, 31 Jul 2026 at 15:36, 'Vincent Donnefort' via kernel-team
> <kernel-team@android.com> wrote:
> >
> > Integrate the pKVM memory reclaim interface with the host's memory
> > management subsystem.
> >
> > This allows the host to automatically recover unused memory fom the
> > hypervisor's heap allocator when the host is under memory pressure.
> >
> > Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index d28422f5c3d6..bfbb1266491d 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -115,7 +115,7 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
> >         return ret;
> >  }
> >
> > -static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
> > +static unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
> 
> This is the first caller of these, so it is where reclaim starts
> running against a concurrent top-up.
> 
> Nothing marks the pages a top-up just put in allocator->mc as spoken
> for, and hyp_allocator_reclaim() ends with an unbounded drain of it,
> so a shrink with target 1 hands back the lot. Land that between a
> top-up and the retry it was for, and the retry asks again, and
> pkvm_call_hyp_req() goes round.

Sorry, I am not sure I follow here.

IIRC, the shrinker will only reclaim half of what is available. So the pressure
should be proportional to what is available and limit races with topup!

However now looking at it. I wonder if I don't want to ratelimit here the number
of pages reclaimed in one go to limit the time spent at EL2. Especially we do
all that with the allocator lock taken...

> 
> Both are driven by memory pressure, so they are busiest together.
> Worth holding back what a pending request asked for?
> 
> >  {
> >         struct kvm_hyp_memcache mc;
> >         struct arm_smccc_res res;
> > @@ -133,7 +133,7 @@ static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsi
> >         return reclaimed;
> >  }
> >
> > -static __maybe_unused unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
> > +static unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
> >  {
> >         return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
> >  }
> > @@ -342,8 +342,19 @@ void __init pkvm_selftests(void)
> >  #endif
> >  }
> >
> > +static unsigned long pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
> > +{
> > +       return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
> > +}
> > +
> > +static unsigned long pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
> > +{
> > +       return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
> > +}
> 
> Returning 0 rather than SHRINK_STOP when reclaim comes back empty
> leaves do_shrink_slab() calling this until total_scan runs out, and
> each call is an HVC. count_objects() covers the case where there is
> nothing at all, but not the one where it goes stale between the two
> calls.
> 
> Cheers,
> /fuad

Ha right, that SHRINK_STOP seems indeed to be the convention for other users.

-- 
Vincent
> 
> > +
> >  static int __init finalize_pkvm(void)
> >  {
> > +       struct shrinker *pkvm_shrinker;
> >         int ret;
> >
> >         if (!is_protected_kvm_enabled() || !is_kvm_arm_initialised())
> > @@ -359,10 +370,21 @@ static int __init finalize_pkvm(void)
> >         kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
> >
> >         ret = pkvm_drop_host_privileges();
> > -       if (ret)
> > +       if (ret) {
> >                 pr_err("Failed to finalize Hyp protection: %d\n", ret);
> > +               return ret;
> > +       }
> >
> > -       return ret;
> > +       pkvm_shrinker = shrinker_alloc(0, "pkvm");
> > +       if (pkvm_shrinker) {
> > +               pkvm_shrinker->count_objects = pkvm_shrinker_count;
> > +               pkvm_shrinker->scan_objects = pkvm_shrinker_scan;
> > +               shrinker_register(pkvm_shrinker);
> > +       } else {
> > +               kvm_err("Failed to register shrinker for pKVM\n");
> > +       }
> > +
> > +       return 0;
> >  }
> >  device_initcall_sync(finalize_pkvm);
> >
> > --
> > 2.55.0.508.g3f0d502094-goog
> >
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> >
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
