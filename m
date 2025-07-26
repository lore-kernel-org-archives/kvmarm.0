Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EB515746F
	for <kvmarm@lists.linux.dev>; Sat, 26 Jul 2025 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753520345; cv=none; b=Gh/kh3vWYFhAn0BzNvewzMMkbl04KgHmyqOI90ainE94LJOyQUu0B3hBEHYcyS0ExKyjJrTq3YOYQ+pxxkhQ/4XEUZpz6EKa1LoQVJds7RF1Xtc6UsXEriq47rgIJRTh/l/Swayw3btj2o/sU8VKNUXyuGyLoywG+I4Wab5pXqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753520345; c=relaxed/simple;
	bh=BAlyNZBIlPoNcyJn72zqkAHVHCI4YLaoZhEYbwrktkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoJE+jWmivlI72r3IDnT/Dr3yBuN+sTIJSEaTtHff98AXe449mgWl6Ah47JEH3Yg5SptO7EWbBiEvOtLduzZ0T+dP4f1BIXyUiS1ikLfB+Cbh+d1IiISjVpeK9blH/HByuASifiCm6imDezZRAd1GnJrr+OUgAOLhtO6xLdNBA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=D/PByF1L; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="D/PByF1L"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-23636167b30so26937645ad.1
        for <kvmarm@lists.linux.dev>; Sat, 26 Jul 2025 01:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1753520340; x=1754125140; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IsSwfYx72SBzxWb7IltAxR/7pX8mu/ij+8zDC/fxnNE=;
        b=D/PByF1L2W0wgEQKnVs0Om8vmxFsT6G8rKlgpawtF9cZZ2tZpP7dGoIG/mjniOKmWR
         N5f5Wb43IIGyxc+aglX9jRXDGSfL2AjBHEEhcFn8vPp4v185Rz1N6wgtoWjD/7qangbg
         iAhfvyfFjdLeIlhXaS7ICNp6vzonYEJMZNHj1KfSu0fFphIc97CKfyTs7xgvxny3SZRm
         t7BIyrbGbQ76XZ3L6XFvEBX2cUTTj5Aa4OZtCb2Zv0pE7X2bH+TeWfsm5HB0kBZwuaZ2
         fexuuDrpRsYAUywcw/Nq4EIJkeqjFfoGK1MqkZ/FvxGRK8MB2xcxdKYl3xoB76GQXxl2
         AOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753520340; x=1754125140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsSwfYx72SBzxWb7IltAxR/7pX8mu/ij+8zDC/fxnNE=;
        b=gQyLjjcK6qRNdscLSjKh5QJZHfJeVPRmiLCMHjSSOtmd4X0aeWhz21GXF6vqmVcdjO
         fy/lo33p2yog0TSZIIuyqStoBgsTMEE4Cqu2z4j0JVdJp4nbP7G06PCu83cAY17jzc1n
         FYbC52SjNZjkVOABSl8c9+uVl9FTtzVqDjs6JZUhcLvGn3dZKqxG3rXJal435DuU+QND
         BlJNVRyk8dezBdMkwgCRNuAozLC+jzFOaUN+3Zx3uL5GzwBwljkoH/wGZbgMnIExVPH8
         qCKXIwgbtJR3rXj09PbSzoa/9hDGt3qEonPV+B9XXUunEHohNa4BbWkRC8SiRZaqmm4/
         XTpA==
X-Forwarded-Encrypted: i=1; AJvYcCUsorNo22I+/C664X3zv4qnKPKBD8AJtCFT0mlIMIFVJKKu6TBfaL5aIVPCWmJjCQz4z80zwvE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtqqtmEmJHRCfZ+s6Upf5X3Wsil6niblimTcAcErt1erzYgUN7
	VHcmNJjLFHMYNyJVLp67+kSyZ2LmXEWIRTtXqPP5mxEocMw3XCospcGZ2nx9kP8rMQMQD48lp2I
	7LKZbZXkdObKiG+yuOmGxBbfVL/DQTWBJXDHNVJgvNsTVciAqhfU=
X-Gm-Gg: ASbGncvegeSW4sPxtahIukr1VBaT8iGs8wysjbwIUZTxnq5MnJ3Lq9/gmuIPJ3D+UKI
	VjXx1v5Y8Hsqzvr1W2alC1gASm2hxCqLjnNfsZq6FlYoRwqxfBRL24Xj91dvU0w4L8uBNs8BrcJ
	7/T2bWPFiaQWGGIbwKimQPf6mFMG8sFQenqwaZvqtD9Nx4kNL5S7+lSe6SG4mn8WuSuyYowWm+Z
	DrF7h9f0JX2WJ5q5g3n/gUJdOQbu0+ItIUYKYrQP2NznIoa6KRtxG+2ZHOIUXsp8r3wrxFKV+72
	SJN5YRODf3G+YBja8N4c7jrwhbSxvF1YDEqnUtliyyyIIJX3pbqoBHBr+5Wyi9aZx9yUswmLV9a
	V+UHnaDTvz54Ak37yZe0LXidVD6dfks0yP0pU4z2CwI+gADBAfMs8reGGil6XX2Vrf9XjzM4=
X-Google-Smtp-Source: AGHT+IGSfqKHy9SGFb/1/uiPQ8AY7vue0rGViceJfxWSMYoCR4FrxJn5LaDGauIUCkJl8iR0dcK/wA==
X-Received: by 2002:a17:903:3bcc:b0:23f:adc0:8ccb with SMTP id d9443c01a7336-23fb3030e96mr62904435ad.16.1753520340556;
        Sat, 26 Jul 2025 01:59:00 -0700 (PDT)
Received: from zenbook (1-162-100-110.dynamic-ip.hinet.net. [1.162.100.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe4fc7dasm13280705ad.116.2025.07.26.01.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jul 2025 01:59:00 -0700 (PDT)
Date: Sat, 26 Jul 2025 17:01:25 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>, Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v2 5/6] arm64: add FEAT_E2H0 support (TBC)
Message-ID: <zbgu6irpeytcpymaxpg55tvijeppfpdpwcju275g3h6bx4u5qn@35vb5ymt55hx>
References: <20250725144100.2944226-1-andre.przywara@arm.com>
 <20250725144100.2944226-6-andre.przywara@arm.com>
 <86cy9o8bwn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cy9o8bwn.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi all,

On Fri, Jul 25, 2025 at 05:37:12PM +0100, Marc Zyngier wrote:
> Hi Andre,
> 
> Thanks for picking this. A few nits below.
> 
> On Fri, 25 Jul 2025 15:40:59 +0100,
> Andre Przywara <andre.przywara@arm.com> wrote:
> > 
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > To reduce code complexity, KVM only supports nested virtualisation in
> > VHE mode. So to allow recursive nested virtualisation, and be able to
> > expose FEAT_NV2 to a guest, we must prevent a guest from turning off
> > HCR_EL2.E2H, which is covered by not advertising the FEAT_E2H0 architecture
> > feature.
> > 
> > To allow people to run a guest in non-VHE mode, KVM introduced the
> > KVM_ARM_VCPU_HAS_EL2_E2H0 feature flag, which will allow control over
> > HCR_EL2.E2H, but at the cost of turning off FEAT_NV2.
> 
> All of that has been captured at length in the kernel code, and I
> think this is "too much information" for userspace. I'd rather we
> stick to a pure description of what the various options mean to the
> user.
> 
> > Add a kvmtool command line option "--e2h0" to set that feature bit when
> > creating a guest, to gain non-VHE, but lose recursive nested virt.
> 
> How about:
> 
> "The --nested option allows a guest to boot at EL2 without FEAT_E2H0
>  (i.e. mandating VHE support). While this is great for "modern"
>  operating systems and hypervisors, a few legacy guests are stuck in a
>  distant past.
> 
>  To support those, the --e2h0 option exposes FEAT_E2H0 to the guest,
>  at the expense of a number of other features, such as FEAT_NV2. This

Just a very small thing:

Will only mentioning FEAT_NV2 here lead people to think that FEAT_NV is
still available with --e2h0?
Maybe s/FEAT_NV2/FEAT_NV/ makes it clearer?

Thanks,
Wei-Lin Chang

>  is conditioned on the host itself supporting FEAT_E2H0."
> 
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm64/include/kvm/kvm-config-arch.h | 5 ++++-
> >  arm64/kvm-cpu.c                     | 2 ++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> > index 44c43367b..73bf4211a 100644
> > --- a/arm64/include/kvm/kvm-config-arch.h
> > +++ b/arm64/include/kvm/kvm-config-arch.h
> > @@ -11,6 +11,7 @@ struct kvm_config_arch {
> >  	bool		has_pmuv3;
> >  	bool		mte_disabled;
> >  	bool		nested_virt;
> > +	bool		e2h0;
> >  	u64		kaslr_seed;
> >  	enum irqchip_type irqchip;
> >  	u64		fw_addr;
> > @@ -63,6 +64,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
> >  	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
> >  		"Specify the counter offset, defaulting to 0"),			\
> >  	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
> > -		    "Start VCPUs in EL2 (for nested virt)"),
> > +		    "Start VCPUs in EL2 (for nested virt)"),			\
> > +	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
> > +		    "Create guest without VHE support"),
> >  
> >  #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> > diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
> > index 42dc11dad..6eb76dff4 100644
> > --- a/arm64/kvm-cpu.c
> > +++ b/arm64/kvm-cpu.c
> > @@ -76,6 +76,8 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
> >  		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
> >  			die("EL2 (nested virt) is not supported");
> >  		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
> > +		if (kvm->cfg.arch.e2h0)
> > +			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
> 
> This really should also check the capability in order to fail
> gracefully on system that have no E2H0 support at all (or have it so
> buggy that it is permanently disabled by the kernel):
> 
> +		if (kvm->cfg.arch.e2h0) {
> +	  		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
> +				die("FEAT_E2H0 is not supported");
> +			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
> +		}
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
