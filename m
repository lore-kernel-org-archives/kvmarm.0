Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D51357CFB
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781614848; cv=none; b=byNqWgi7thm6ILL6VSztDcU7OwJkLh7F0vVBWohnNiC3n0RzxKTyb/AgO30iWZvWGBtedSfaCXZf3mLmullyOQewQols5Cd/OrISBnZ57Rtq1c40Su2T/DVAG7Sa3BUgl32xzf+dO6xEim0XZA25XvDUBUf7lsUCpgqPCOKfJpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781614848; c=relaxed/simple;
	bh=HI4KSffIIgwA5GJ8P55nt6IdxSCSSHhQf83EuNz/dhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuFMB/qwYLn+jDSN8d8FleqSwvos+ZjBQTkhLbXbH8QVIMbP2OksTxAM7jxORSBh4zWz8rXA0gSyYzqscr+YzJfOWv7Bg4U5Vxnfi/zxGJubvIoR0iV6FNEDbzp9bJ7da/idh94zVb5v8LBrowo1c9ZXT1xqb5X5kyLoJevhPCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ofU06nS3; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ofU06nS3"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bed19623d6eso582695966b.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 06:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781614846; x=1782219646; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wNTSMzgRJmXIzWcqWEqDdC42PhcZeRCvxhxGiPL0LsI=;
        b=ofU06nS38qou60/GKT5GB+VU4V9ooB+SH04gz7yXnnJ+HdpTj7heZncsiIVntUjKe1
         XrqAR/N8bcPRFvTbSRnO4HA3lnI0G3PGzVstHQYiwuQn1O0nrR0mTHfcxODyc6v2ToGQ
         nQIvAXMGgXgq9prvFsicpyp4KqUXN7jbkQPJxlbrDRBTCLThUDFHGghgGtEvLKpvJTVz
         wO3/1s5L7nClyKCYeZZkBqkAsNH8Hn69CwCDZSedPff2+n0qslm3jasVRYclDwJUF+hV
         4l/w0zTggPHeNkKiPrkC55gMLx6CP263B1f6NbFWds1wFr3gF4TvMMq0ZnfgVQpfRQVx
         KJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781614846; x=1782219646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wNTSMzgRJmXIzWcqWEqDdC42PhcZeRCvxhxGiPL0LsI=;
        b=lPMjsyli1cBvjf5VNA7imXA9g5Mqw/eWEpuNVNe3bcJ7HRz3m7nj4Xpd15MDulYOl/
         MhmbaCUd7n8G7o5RgQFWbWxUWUDMrFLCFFfF/GLFIgEU2UhxVbHf5HWW8VISRuH2bs9/
         uYJcm4GIiZHnnwM+QM07XZUQgxHisMn9lWZ+PJ1CvXAGMMTsxfNwfCLHiHEQinxLgoTf
         jWBFg/t5OMIbHMFq5nHAMOpDwBj4RU96fnwdUGzNJePwIqbrUOsRKFoga2geIZoLKFLo
         aMhLE9gFtkdITraA+0ruYP8kYvdoQV/25ekvK7khemWzPod2PEFS/74TSgmi8aB6nQ8H
         RCPQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mIrF4/qf+EJRlotGicVsb2pEP0OZ2bwRKPh1KipAJk5QDI6+fvxmTMg/rldTh6VEbJI+nuzY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyc9pAjBkqcqupqXa+f8S4gG5D5yiOdQSz6MS7qSIBbfezlowH4
	eLON26b8TCOywuwY0+xGgzkHVzP5FrOKXkIrmCu3FogSGQckwdWfQCSDWsgHI1U0bg==
X-Gm-Gg: Acq92OF64m/DTd5xmZZB8XBCAEnXs4+ULLo9eY063WX29MzZxnnqe3AkyGO5yUdGNvX
	6NOfCzuj9IxGRpXaB6JEwoJ28yM1HbYP8CAvem2KYflzYPeQffeDLylAN/6BDJYJJgsmrq0jtZO
	LZv7NzHzqO+yVimsf39CjnLvaFyucBoiAb+R1cysIZvxV/A9kGLjAwz4qWrn8XOnPSCUz8ALx7k
	wNXnxudCgyNmFHKGZINP0+C2AL1b30Gan/NtuHudz6QVf3Oy+dwDoAETPZGrcrPkH7EL5jyfExm
	CM3nVkO2WjlBAcfkoTIH/ICWeny6Gvw9pPeWuL+AJv5xxn6UlErxFtst5XrV00I3ofcrXqYztS7
	frH6458HxKQEMvtqhds2vww/FhM+788fsBN8oxJqNiA1jz3P8lnoiAlvja6SNTwZmVnOtdS9Frm
	Q7Nz8ckLue5nWnEb5UgUOM26gCQnIak8hn4HxDLRUcMA6Lb2tSdG7mKrofmy8JCsi6ndE=
X-Received: by 2002:a17:906:f5a0:b0:c04:1973:cdd1 with SMTP id a640c23a62f3a-c041973d111mr250472566b.36.1781614845012;
        Tue, 16 Jun 2026 06:00:45 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c03ba328d6dsm214905966b.49.2026.06.16.06.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 06:00:43 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:00:39 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 1/7] KVM: arm64: Enforce strict SBZ checks in the FF-A
 proxy
Message-ID: <ajFI95hZJxZfFg5q@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616105417.2578670-2-sebastianene@google.com>

On Tue, Jun 16, 2026 at 10:54:08AM +0000, Sebastian Ene wrote:
> Introduce a helper method ffa_check_unused_args_sbz to enforce strict
> arguments checking when the hypervisor acts as a relayer between the
> host and Trustzone.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 47 +++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..c723a21006aa 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
>  static hyp_spinlock_t version_lock;
>  
> +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> +{
> +	int reg;
> +
> +	for (reg = first_reg; reg < 17; reg++) {

Hum, should it be reg <= 17? 


> +		if (cpu_reg(ctxt, reg))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +

[...]
