Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936361474A5
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279749; cv=none; b=JicTzmjnqStDOVQaVfFPDuJjecX4lsmrHAjP9eCZlyc5vLR3tk/WmVjfNC0okgI61tZp9gKarjdRg9KQtRj8uvuq9WWnNpq296VRCZOtnZ08d4xEc6YsktTph+Og8SZjQENMHIRcycd+jmun4GnNTQnvAgeukFIPmUfjY0wG9ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279749; c=relaxed/simple;
	bh=zayRYx0j0HIZLKsRyHeMaNEFZNZDwo5WpQ/cssi8WOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0GSqQiy6Q2KecDsXzDrQ6Exgt/niZaR9uH5nwJVi2S51puW7UyE827ZLpkd+wx3piFMCyJV4Z1DqiQuuDOXnKFRixVoGbzJNsXX77Q4cVV6osx0vbFyFgiXnC+GwTfelWEzsC6tyYIW9wJMs+tBnMXP7VMCMgCw+56bQoUjUq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cql35Z41; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cql35Z41"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f70ec6ff8bso151965ad.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 04:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718279746; x=1718884546; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EE1nN/bbZGwmk0UpB/fAkY4ALv0H3P02C8XfuKC6Rwo=;
        b=cql35Z41j9FS2DX5ygmFh35X7NWrikL7i25n+HO0ExsuDcRrrrrNsTe9lso86QvuGa
         9QjLbJKHq3eIpjGXHJafj0GNQbMNjk/9/oqiGN7bC3l2y8+zVtCXC/68nGruAEWyFPv1
         Vs0bZEocC8FPA9fF/jOtTLhZ5ChFO8vxALvkpgTdz+zeX64K4kBxWAVNheJcg2+2rrqy
         dXCv06SW8lkjs+8mxpwgVpBoJkfh9JBLqQhDezz/yxY9DpwdwcOjw5gR6/iTtd0n24Qa
         BVy+P4SxAgihLPPIZVKotbW5bb5heLvInv2FRusNdoV8G9TgdSyKn8AG1NBcCQo0MVZd
         eb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718279746; x=1718884546;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EE1nN/bbZGwmk0UpB/fAkY4ALv0H3P02C8XfuKC6Rwo=;
        b=o+VXqj2cZSbvsfrW9M+JeKFSmV/JemhBzUsdW3K5gfv3EI6FBz59Yktt5noc7C+nAZ
         NupgdaJ/qnlXm720JphOLiDCqYanAAlm7HYOKjvGxJwrbRBhOlcQpTEV2veud8E3m5Rd
         HGWG/jbd+Y8GFFi5MBeQ7Dg0fvOLQBFJt7vcpgdn2ESUApUwggif4zGImZqjOdImrMeV
         uqYUOQYcp/b4tMdgPRIWRmaPWlzdcqbrPm8fnIPU3z+ucM3ISYUFDGGd/ncWEJjfevbH
         IHvrAOHfpie+Dj3tqwCp5c1mgCuhGq+aSMf445edfM47rQE2COKEYm10J1ydRT9JA3Jw
         4XwQ==
X-Forwarded-Encrypted: i=1; AJvYcCW52NCXwDkXLudOjRRux21RObWUt4XpoyzOrWvRYwe0qBWgr5JPmDf2QsYYkGoitTn+x7MEHxrgZw1deNMmje2dC/tSR9HI
X-Gm-Message-State: AOJu0YxnK0yXtLR7XNWsxroNuSrgKs1YQR4w+7rgalCrbOJqUx+dCwvj
	ja4/eSKvomaYYAUzYMLs/vu2JBR0b2+uhdE9XgqQ0B3CxEPNwGQNHmgv20ko5w==
X-Google-Smtp-Source: AGHT+IG5IOEOepR0qdMVRmtxHZM0ZHQKWE+MvnTBo2aRyqmr9Ec2NAfOXkaUKM2+xp4/pE/pves/TA==
X-Received: by 2002:a17:902:968d:b0:1f7:3764:1e19 with SMTP id d9443c01a7336-1f84fde613cmr2805325ad.20.1718279745485;
        Thu, 13 Jun 2024 04:55:45 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4c45f8690sm1455192a91.33.2024.06.13.04.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 04:55:44 -0700 (PDT)
Date: Thu, 13 Jun 2024 11:55:40 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, suzuki.poulose@arm.com, tabba@google.com,
	will@kernel.org, yuzenghui@huawei.com, lpieralisi@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 1/4] KVM: arm64: Trap FFA_VERSION host call in pKVM
Message-ID: <ZmrePPCdc28OLyPb@google.com>
References: <20240515172258.1680881-1-sebastianene@google.com>
 <20240515172258.1680881-2-sebastianene@google.com>
 <Zmmph6YlIsBhJQqd@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zmmph6YlIsBhJQqd@bogus>

On Wed, Jun 12, 2024 at 02:58:31PM +0100, Sudeep Holla wrote:
> On Wed, May 15, 2024 at 05:22:55PM +0000, Sebastian Ene wrote:
> > The pKVM hypervisor initializes with FF-A version 1.0. The spec requires
> > that no other FF-A calls to be issued before the version negotiation
> > phase is complete. Split the hypervisor proxy initialization code in two
> > parts so that we can move the later one after the host negotiates its
> > version.
> 
> Blank line here would be nice.
> 

Added blank line.

> > Without trapping the call, the host drivers can negotiate a higher
> > version number with TEE which can result in a different memory layout
> > described during the memory sharing calls.
> >
> 
> LGTM(apart from minor nits),
> 
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> 

Thanks Sudeep, I will incorporate the tag it in v3.

> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 123 +++++++++++++++++++++++++---------
> >  1 file changed, 92 insertions(+), 31 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 320f2eaa14a9..72f1206c85fb 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -1,4 +1,5 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> > +//
> 
> It should be OK but still spurious for $subject 😉
> 
> [...]
> 

Dropped this.

> > @@ -700,7 +789,6 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  int hyp_ffa_init(void *pages)
> >  {
> >  	struct arm_smccc_res res;
> > -	size_t min_rxtx_sz;
> >  	void *tx, *rx;
> >
> >  	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
> > @@ -726,35 +814,7 @@ int hyp_ffa_init(void *pages)
> >  	if (FFA_MAJOR_VERSION(res.a0) != 1)
> >  		return -EOPNOTSUPP;
> >
> > -	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
> > -	if (res.a0 != FFA_SUCCESS)
> > -		return -EOPNOTSUPP;
> > -
> > -	if (res.a2 != HOST_FFA_ID)
> > -		return -EINVAL;
> > -
> > -	arm_smccc_1_1_smc(FFA_FEATURES, FFA_FN64_RXTX_MAP,
> > -			  0, 0, 0, 0, 0, 0, &res);
> > -	if (res.a0 != FFA_SUCCESS)
> > -		return -EOPNOTSUPP;
> > -
> > -	switch (res.a2) {
> > -	case FFA_FEAT_RXTX_MIN_SZ_4K:
> > -		min_rxtx_sz = SZ_4K;
> > -		break;
> > -	case FFA_FEAT_RXTX_MIN_SZ_16K:
> > -		min_rxtx_sz = SZ_16K;
> > -		break;
> > -	case FFA_FEAT_RXTX_MIN_SZ_64K:
> > -		min_rxtx_sz = SZ_64K;
> > -		break;
> > -	default:
> > -		return -EINVAL;
> > -	}
> > -
> > -	if (min_rxtx_sz > PAGE_SIZE)
> > -		return -EOPNOTSUPP;
> > -
> > +	hyp_ffa_version = FFA_VERSION_1_0;
> >  	tx = pages;
> >  	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
> >  	rx = pages;
> > @@ -773,8 +833,9 @@ int hyp_ffa_init(void *pages)
> >  	};
> >
> >  	host_buffers = (struct kvm_ffa_buffers) {
> > -		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
> > +		.lock   = __HYP_SPIN_LOCK_UNLOCKED,
> 
> Spurious or intentional whitespace change ? I can't make out from the mail.
> 
> --

I dropped this, it was a spurious whitespace change.

> Regards,
> Sudeep

Cheers,
Seb
