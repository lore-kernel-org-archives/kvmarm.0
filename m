Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE845383984
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 10:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789034654; cv=none; b=VI/SHTmXJaoTcamZNHqolahC717kvnTW2Q5qhq1sQMmiU21apl6+ETyoBLtxP2r8go+msO5FRBfWIMfTrcwLGiwf/dTHYQDX6/p2aHIU3HHnfpQ1w455VaJtInGGsDLnExew7bhjrkX6s5WPS8nzkvkgBF4FgDyBNnFl6oFknvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789034654; c=relaxed/simple;
	bh=gvVkzoxlejwWsEuO0An8TG2vkreGC7bFn24IvTx4CZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9Za45Fv/bOC+dhZV7SH3VgzrAgbiu1MDuvlbN4QD0wf9KmgmkVSCtccZ2AM47Rne/ocwHIPxOdncuoM8RqoIya53wUf09BrOfSmEC3LgCkxzSb/9PIjm+NjipAPlbFCBDn7CFXOefzkGELt2MY/LVBhOKjciDQ7qmf9PIverIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hMzV0hmi; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hMzV0hmi"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-485aca32ab7so344195f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 03:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789034648; x=1789639448; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WINo3MBcFwoSNDQfzt2Lle9+HR9ovDEJnLqZu/S/ymg=;
        b=hMzV0hmiDEuk7zjVjuvJtOO2/pcaVajDjhSGB5j2fMDSddb3CVoHfouPTA1PiTkHhP
         zqUHWD3LMQl68fsdV3LxuBnELK1yLIzB7IyCqgRUa8adUAJ2Lt8ypzSIbnFhrdkXPqh1
         quA/LQmvyjRfMeURBjnij/PDqYTBYLQ6tkPejw5IpQM+2tOZrboSQKKa17FSQ8aUiyOt
         WliFZpbKoexNBJjEexMIDY7X9IMEIN473CBInJuBVcgM94wH5cZqleL30gIUxA5RQV4u
         kDD8dEUqvl2O/fwmTDntt41enin9BBsCIks+SBFAyDrtrmCoFPmiBzB2qm5HDUJEu62y
         o74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789034648; x=1789639448;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WINo3MBcFwoSNDQfzt2Lle9+HR9ovDEJnLqZu/S/ymg=;
        b=FeLdLsonooM6Qvuh1S94zUQR/8A9DXqvUixVrXkoNNzigo5GdjKLcAGseoC7yogoY1
         7k2Y1Vbh5HSNzDFpTrwjWJX6Ry3n3yabaJXG8JSya16GVfiwQPAf7IazecihstEjc4ts
         9u/vnlSTbJ3bDHW4fn93WwgLh42gPbXKR2sUnC4gjhCOu6+QVNFybTp6z6mLB/3TpPQe
         qFPW/h3F8qztN556U2z2WqNAz4aMrsXqO8A4jcKRg/+8TtZA2AlO+MLAGsu+9rQDOCoB
         12bj1U8Jyh6J7Uu+/BeAIvcQ4zb17dKMlW+KJ9nquL0VhWPEzeVmHj5Wj0OQg1g/u+4q
         4PEQ==
X-Forwarded-Encrypted: i=1; AKwUvBzX6hcZQ8tAKuLhDbUaV2qXnNz37kdkvV2t6b+eC1t+gexX3aqfeu7dwA6k5BMMHclfBC8cHpA=@lists.linux.dev
X-Gm-Message-State: AFuF++lhBuEyRzyK9/LPRFEyziRGPcFVyoJxrQLWN3NvVy2xn6Z7ChZd
	UayHRqbe5v523Mqhb2ASyHajX3VdhkbUqABs8HbSuYCG28CH5GGEyihd6tZ5Pj0Dmg==
X-Gm-Gg: AYBFou3UbSauBCWMu131EfoYc6/eO3iSL2YbeKF2ViFbE/JanjyVrSlCGMZyF6KCNDE
	+gvFmcRo4v7nMOBHRn4mcTr0NzWFKRMAXPDUNlAxV6DHV0/pi056hugUFQfNTxnYTFaHigAblX/
	U3kapJZeVcD94YpJAElQBOPI5UgAey1zom6+C5fzvvatjjU7RFa20Y+9jJhhadw1QEKv2K+Hca8
	EgLvnkVj8lSywK1CHpct5mtTIK3V4qQfOJRoR6tNfIWVX5zUZfWze9zM7czQGe2iNwr+gcYAQf8
	8HsTNRPLDs8UlXk3SMU7SOASxSFuNJVmZqynS41Y48lZy9SuxCucvBDnXo0qquzYrcl0RXFRQI+
	hw21UQzP2OqiHLxYC373G/ZcDK/UdRSlMSKvfKryOq8QZdAMyEqLgEb/FJHSEc+p9oLyGAS8HrI
	sOioq7cE3j95DtqKbE7JNQrVLjYeWH09KAIyC6OusqG6E79SeyNBiyYS5mnF+bLzeAic8KIjemj
	fVKPl884IzfmJ4Y3TGtePTQxMOB+TOj6z++3IZwcIQ=
X-Received: by 2002:a05:600c:4714:b0:49d:462:6eda with SMTP id 5b1f17b1804b1-49d04627387mr310806105e9.28.1789034647707;
        Thu, 10 Sep 2026 03:04:07 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883959f0sm53204782f8f.10.2026.09.10.03.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 03:04:06 -0700 (PDT)
Date: Thu, 10 Sep 2026 11:04:03 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 11/20] KVM: arm64: Add a range to pKVM ownership selftest
Message-ID: <aqKAk6n_DBZXnvnl@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-12-vdonnefort@google.com>
 <ravrecwvcy2okwdi3h5buzneyfilfjgx76c374r7l7jtx62lqc@rom2sxozz5is>
 <ap_ioANYZN2_aogf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap_ioANYZN2_aogf@google.com>

On Tue, Sep 08, 2026 at 11:25:36AM +0100, Vincent Donnefort wrote:
> On Mon, Sep 07, 2026 at 03:58:13PM +0100, Wei-Lin Chang wrote:
> > On Mon, Aug 03, 2026 at 11:08:55AM +0100, Vincent Donnefort wrote:
> > 
> > [...]
> > 
> > >  void __init pkvm_ownership_selftest(void)
> > >  {
> > >  	unsigned long pgtable_order = 5;
> > >  	unsigned long pgtable = 0;
> > > -	unsigned long page = 0;
> > > -	long ret = -ENOMEM;
> > >  
> > >  	/* Memory for the VM page-table */
> > >  	pgtable = __get_free_pages(GFP_KERNEL, pgtable_order);
> > >  	if (!pgtable)
> > > -		goto out;
> > > +		return;
> > 
> > nit: previously this allocation failure will print a message, but not
> > after the change. Is this the intention?
> > 
> > Thanks,
> > Wei-Lin Chang
> 
> Nah, that's a good point, it should print something.
> 
> -- 
> Vincent

Ha I remember now... GFP_KERNEL doesn't have __GFP_NOWARN. So if it fails,
warn_alloc() will already print an error.

-- 
Vincent

> 
> > 
> > >  
> > > -	/* Page whose ownership will be tested */
> > > -	page = __get_free_page(GFP_KERNEL);
> > > -	if (!page)
> > > -		goto out;
> > > -
> > > -	ret = kvm_call_hyp_nvhe(__pkvm_ownership_selftest, virt_to_pfn((void *)page),
> > > -				virt_to_pfn((void *)pgtable), 1 << pgtable_order);
> > > -out:
> > > -	if (ret)
> > > -		kvm_err("Failed to run %s (%ld)\n", __func__, ret);
> > > +	__pkvm_ownership_selftest(0, pgtable, pgtable_order);
> > > +	__pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);
> > >  
> > >  	free_pages(pgtable, pgtable_order);
> > > -	free_page(page);
> > >  }
> > >  #endif
> > >  
> > > -- 
> > > 2.55.0.508.g3f0d502094-goog
> > > 
