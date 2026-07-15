Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA9E4483B2
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784115328; cv=none; b=afRRc3987RWSA6S6nfLRUers5HRHPUCeyNS8AofqHkVRrRZseHQmEgyL5nI0gG6IMG6APlzH1DMgX2Ze4ngmFahb/yqnuxVkYOaz2b64rm2BIa/Na1NpGjXYS5HKLi2HaGH63+vHyez2tcaVFaIGlNd9wcZLQBdGlRnoRHrVRDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784115328; c=relaxed/simple;
	bh=s4sp1mZjm4iPCbhW5Hmd7xXLSHYT9N4xiEmXB1rIJZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJfZiu86rOfJHcDLhOK7piIDON2kgnP9X1YQ1y7I9aG6hKWbEqHrIfyXTdtLvV/BG4vc04RMUtwIc597XYSwYkP4WgnBM5AHvaUTsLo3B21uzWXzTzFmi7LayItLOd1UlwHL4Hw3uJVyqvS1h+bRaHOFVGJYFIOcEdIMBcNW2E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OnrsLIBw; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OnrsLIBw"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493e497643fso9634255e9.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784115324; x=1784720124; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ta+kur5ryJs2I5yQGZkvpcOeEwa4qpkvMvmH1OmJGTs=;
        b=OnrsLIBw7tJKugd3r9FbDjczYRUEPCNcWziOxOwIf0aM78mzJh88bTbxi4/PDRZRzt
         wvOeeJGqKNl5p0fOY1+miv1/oIrFNwZ8zbGPMnqP7qCRH6pJfrD3JnuMTXCZNa3p9W2B
         zQyD4MIq5SLI5IeW/DeEloRl/83a3HbheaI9HCQo630XD36Bm1Cgl9k23bKwsu9zKbSi
         YUmZLo7vbPGm1hGM2Dekls2RjjqJOB+MI87nccYjEVOa87iMmeJQypFB7TyhvNHaInsJ
         gFNmSqaiGqX8FuEdnvpPVppSFBDM6XHxWCQlsa5qWoTnEp9Fc17YMsjxbMkg7SoRC8tD
         qrFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784115324; x=1784720124;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ta+kur5ryJs2I5yQGZkvpcOeEwa4qpkvMvmH1OmJGTs=;
        b=N1ynME8ComU8a4W8lv50junP2gNNdn61Qec0fVAf9GGnxinhevoYr3A67pbaC20ndU
         nDGdq0zRqHAMnVev3Rsq7yDZIiG/BBlW7UMs8a6ieT+1zFkghQfxI7pcREzCHoH9eBbm
         x6WIbRlxofkSnuJKx9Qrajw9T668iLMlDT2i7Dz6Igfx/D5YlqvNdX6NPfgA9QBiuc1B
         OTdffmH2bvVZGkZnoQ9k9i2ixBCoqLAme3C/NFpxBokLHmDNqwgVmJgmTSAsYECpvuly
         lnsJnHBBDiVNc33tJBEZrER+XxU1a3hHrMJmm3ErCaUoD3GPMCyzVSkeloX0qOgYQu8W
         wsYg==
X-Forwarded-Encrypted: i=1; AHgh+Rqz2k9X7tuSFOhNc9nl/Qh/XzTzlQu0rYSdSDDf89Hq87YUESf1QxbE3jOJJKDp2aHyMaU0MEA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyq6CF2ZQ/cZ05yBNWs1wnnsRTA/3h1igAL3i6p9ci0IPWNRPtx
	9homJP3CLgaPZRlJggBcHYPe3Qpcxi0gZbpCgtO7/moZcw3vVYzLl0C4Ud4Ij21yvA==
X-Gm-Gg: AfdE7cnxwK8gqzBJ8F8/R08E1POjr0Myz+sUTPAJ9H8bNcCHSJLLZ1C4RTmTuxbFePQ
	9U/6J0g2ytT/wMvTsxVgkfwPNQDyeWIweTS7+6/QLdEIeNhxEGsy9boidYVdSnl4O5+juJeZXGR
	OsyE59iVZpFlUVz0+4Jshnfixn+IZorB/7/+tBK8a923zSPaqBXSNCLVu1xdg2aWqzT9xmxA9we
	5VQYrb1Afa9f3LmU7eSW5bO4FkY6H7CR/kLcrsnBm+IXiU5w8YFZjgTruT/Kz4BS0eFUnbcZgXa
	6A/h6qNhCochBovFSwgSVmeIYynbJI0nlLj2Q6qJ0zqRqcH+U7EBaSbnNKRCGH9H2KKsNZKhEHU
	EgsojWUhgkSGA76J1ElpGhCpisc9eIfQAF1hSZ6RAFwvJngCboP90qpNRBWC3Ni7nCdF4HYkLDy
	WH9JSKa7naFx5i6sMeQ1dUu2QJQGW/8sjUEAIR5Fc2uXmviB+LHOw=
X-Received: by 2002:a05:600c:a40c:b0:493:ee4d:5c5d with SMTP id 5b1f17b1804b1-493f882cb8cmr125670585e9.31.1784115323077;
        Wed, 15 Jul 2026 04:35:23 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4953c6ff429sm35719355e9.1.2026.07.15.04.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 04:35:22 -0700 (PDT)
Date: Wed, 15 Jul 2026 12:35:18 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qperret@google.com
Subject: Re: [PATCH v2 11/18] KVM: arm64: Add a shrinker for pKVM
Message-ID: <aldwduiixzAFNCa1@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-12-vdonnefort@google.com>
 <CA+EHjTwcz8T_RfgE46+xMKP_nz7Mi9rVCdhtnC2CbjtO1O5xCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwcz8T_RfgE46+xMKP_nz7Mi9rVCdhtnC2CbjtO1O5xCQ@mail.gmail.com>

On Wed, Jul 15, 2026 at 12:20:51PM +0100, Fuad Tabba wrote:
> On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > Integrate the pKVM memory reclaim interface with the host's memory
> > management subsystem.
> >
> > This allows the host to automatically recover unused memory fom the
> > hypervisor's heap allocator when the host is under memory pressure.
> >
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 50adfff75be8..3dc2b9d2c322 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -122,6 +122,8 @@ static bool vgic_present, kvm_arm_initialised;
> >
> >  static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
> >
> > +static struct shrinker *pkvm_shrinker;
> > +
> >  bool is_kvm_arm_initialised(void)
> >  {
> >         return kvm_arm_initialised;
> > @@ -2526,8 +2528,8 @@ static void __init teardown_hyp_mode(void)
> >                 }
> >
> >                 free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
> > -
> >         }
> > +       shrinker_free(pkvm_shrinker);
> >  }
> >
> >  static int __init do_pkvm_init(u32 hyp_va_bits)
> > @@ -2713,6 +2715,18 @@ static void pkvm_hyp_init_ptrauth(void)
> >         }
> >  }
> >
> > +static unsigned long
> > +pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
> > +{
> > +       return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
> > +}
> > +
> > +static unsigned long
> > +pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
> > +{
> > +       return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
> > +}
> > +
> >  /* Inits Hyp-mode on all online CPUs */
> >  static int __init init_hyp_mode(void)
> >  {
> > @@ -2883,6 +2897,16 @@ static int __init init_hyp_mode(void)
> >                         kvm_err("Failed to init hyp memory protection\n");
> >                         goto out_err;
> >                 }
> > +
> > +               pkvm_shrinker = shrinker_alloc(0, "pkvm");
> > +               if (pkvm_shrinker) {
> > +                       pkvm_shrinker->count_objects = pkvm_shrinker_count;
> > +                       pkvm_shrinker->scan_objects = pkvm_shrinker_scan;
> > +                       shrinker_register(pkvm_shrinker);
> > +               } else {
> > +                       kvm_err("Failed to register shrinker for pKVM\n");
> > +               }
> > +
> >         }
> 
> Sashiko might be onto something here. The shrinker goes live in
> init_hyp_mode(), but kvm_protected_mode_initialized isn't set until
> finalize_pkvm()...

I doubt the shrinker can be triggered that early... BUT 

The hyp tracing is a user of this hyp allocator and I have been working on
enabling early tracing [1] so I shall move those HVCs as well!

[1] https://lore.kernel.org/all/20260708075435.47419-2-vdonnefort@google.com/

> 
> Cheers,
> /fuad
> 
> >
> >         return 0;
> > --
> > 2.55.0.rc2.803.g1fd1e6609c-goog
> >
