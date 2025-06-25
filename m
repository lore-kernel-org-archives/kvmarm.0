Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A1A25E477
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 12:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750854355; cv=none; b=CIxk4yuBC8dB9VnJdm3OWQdLWhHSfVoo107NfsQZ7pYEP7MT+02RKpPRtL7TnjL2+SqtnJZvE98gO69vNjJpoWZmEnBh7WMqsL4hYmSSINlKK4eJHLpEfEBrcOnR1xXPgZIqT6YMk1bLvDr5VVDT1zl8MPm6GQaFwrmTRV+fMok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750854355; c=relaxed/simple;
	bh=g7tVhWNQEWOrEFO+Wx+fLCWSoQW9KQpcO66Pz2aMF+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7Tk58QDkLlKAzaqUQuz/Fq3Pa42i8Q8iJ39x9xWDISbOxj5ahHGDZEy9/YFToCfe7adjOliIDTSvfjWjfYoDWQzUgwOQ0hdzWOEkYMxgM2bZCAqbMB8mNVK2a0vtlVlfbZntXIEHMP5P1EpsuNOEjfa/XWMxl1/Yu9t4IYQHjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WNkZLjo5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WNkZLjo5"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-453663b7bf1so76305e9.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 05:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750854351; x=1751459151; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ORz82HmG8MePjwyhjUnw+YyKg1bZgQsmMoLl2/yzhQE=;
        b=WNkZLjo5E/gIyc+ureWo2zZy95dHQMWouUtp5UvxZFjr4FtoOoiAv82mYAox+B3vPQ
         8jnzi6pCgKlkct0UA1D4Vywj+tqWNNkkh0m/3ENpFybS4NINvQYaPM6L6NNoagV5/XTx
         cKTaxHXgRLedQ7SfwrBkDGiAPTit/822dbqYMGCfT99x1dOiFj7YWg04UROgUuUkKEcz
         QB3toyGScbLd/ANQ0M/0/cHOjtDFRCNerib7wpBPzl5pVgEpHGyiLeU51bvIlI5RAsO1
         eslWus45qCbl9QQxlf2xVmXnkuX/eRflaGLzKCwTd+q4MEcS4RJNxZ5u086KFL1TjX56
         28gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750854351; x=1751459151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ORz82HmG8MePjwyhjUnw+YyKg1bZgQsmMoLl2/yzhQE=;
        b=ALLmMOH2n/749f7gRmJv8t27KVsh1Kt/DJzmAp/4zNVQPr2t8SO3/kSebKRKISBgBq
         jNErrKAxh+gNBoyqXORMAAbm+Jqk4G4qbm/jPieISjOT6BGpmBRcfnKEvpjqw/yYwTsS
         5gQZ+QuOBvwi7RvqKjn6utCqLtrU138gDWg+PfHmprCZSlLY6xOMxXzvjBx7AV4AWj57
         9337endU9SVX/xdGxBsCcUpb++i9MxceeyhnEcs1ZqwNYG5lYTEaLYJ0hYD2yXRZdRig
         g3IYgB/FdvOhthfAgd0zfKlm2eFpYgFg3N6nvWswXAjNcdpBHW9Wv65g8daiCfUgS5B7
         KFcg==
X-Forwarded-Encrypted: i=1; AJvYcCVrHYeGxGD8Ng8uo13C3MsVMssoeOISfvmV85Os/jeeo6QDamJca3axfwKFcCPYvIVvVpFzSYY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzC+JzI74m2NB/j5BTZrNX5B1FapEYMChbU3ytQedj4PB8hSGu8
	tBbCx1aOi1N1CvtYVc5etwhnaYex7rbWitN0zCsoNN4pI/MkhZcuO3piBR4VLDf+sw==
X-Gm-Gg: ASbGncuK5S2xSbFBiYQl2DYDOEdnhIz8aOVzsgfOeLr+GuQdAveBWGeEH2biyX4qYTU
	OAOlKXdcUfpTtvE9PvTGN5JdvsBhos2FnCsdamNHFLh7OFjZVOdsn5fQr5/DpqaR8xXjJ4d4Zp9
	w3VAQc1eoOikRfo6tSNvA73dFRb1xzkUbhMxYz4uFI9zuSB31gcxSbpfFonyOcrP91ezJvHBR8w
	rjnMfypGGoU72ko8gTBbJSuIqOvGNzrKq3j7LCGKMyI9gs2JM1HD3crg+yOQUV0G0SMr+yi/hrG
	13BGlwuZol1VRvJRYKmzLpuF5edDXssD7Vs9Z9GKB9heWndkdHzAk12YGe2W1hChCHZRw1LWm2e
	dkn996Bgeq1dg3Ptqj59mwvTXzpTF9DwPniQ=
X-Google-Smtp-Source: AGHT+IHPyu4K7DFqX3gLjlWDl8SuaCVRLnWxYtuvRdiGcRhqnltdTavombWZNicSNu6nwKbmjbZ0JQ==
X-Received: by 2002:a05:600c:c04f:b0:453:65f4:f4c8 with SMTP id 5b1f17b1804b1-45383195f5emr555595e9.3.1750854350879;
        Wed, 25 Jun 2025 05:25:50 -0700 (PDT)
Received: from google.com (206.39.187.35.bc.googleusercontent.com. [35.187.39.206])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8069467sm4409880f8f.42.2025.06.25.05.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 05:25:50 -0700 (PDT)
Date: Wed, 25 Jun 2025 12:25:46 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Quentin Perret <qperret@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix error path in init_hyp_mode()
Message-ID: <aFvqyl-Xquuoyvh1@google.com>
References: <20250625113301.580253-1-smostafa@google.com>
 <aFvqFdwNYI0-3zWY@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFvqFdwNYI0-3zWY@google.com>

On Wed, Jun 25, 2025 at 12:22:45PM +0000, Quentin Perret wrote:
> On Wednesday 25 Jun 2025 at 11:33:01 (+0000), Mostafa Saleh wrote:
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 38a91bb5d4c7..5bb36c3b06b5 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2344,15 +2344,22 @@ static void __init teardown_hyp_mode(void)
> >  	int cpu;
> >  
> >  	free_hyp_pgds();
> > +	/* Order matches the order of initialization init_hyp_mode() */
> >  	for_each_possible_cpu(cpu) {
> > +		if (!per_cpu(kvm_arm_hyp_stack_base, cpu))
> > +			continue;
> >  		free_pages(per_cpu(kvm_arm_hyp_stack_base, cpu), NVHE_STACK_SHIFT - PAGE_SHIFT);
> > +
> > +		if (!kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu])
> > +			continue;
> >  		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
> >  
> >  		if (free_sve) {
> >  			struct cpu_sve_state *sve_state;
> >  
> >  			sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
> > -			free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());
> > +			if (sve_state)
> > +				free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());
> 
> I'm a bit confused by these extra checks -- free_pages() should be safe
> to call on NULL?

Yes, I surprised in my testing I didn't see an issue with freeing NULL, I
though it might be config related, but I should have looked more.

> 
> IIUC correctly, the actual issue is that per_cpu_ptr_nvhe_sym() will
> dereference the per-cpu pages to find the sve state, which is entirely
> bogus if the per-cpu pages have not been allocated. Now, looking at
> this, it looks like the bigger problem is that we literally free the
> per-cpu pages right before the sve state...
> 
> Should we at least change the freeing order here?

Make sense, I will fix that in v2.

Thanks,
Mostafa

> 
> Thanks,
> Quentin
