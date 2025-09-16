Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA3234321C
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031462; cv=none; b=JFbfVhZutVP1e0rnzhwWJE4kgR5DGTjRKyEtVIEIe4gOh7wNhnZWmbcs2zusay9nz22x1+tMWU7MydnNTk1YMxv4JCT4zRgrFk09mXZBqsr/E10ut37PiaG4Gan/q/gtJ07SODq7j4hrFbHpIqQ1JQdpNwm7XUEVG6/aLm/ejP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031462; c=relaxed/simple;
	bh=Mj2uch2k7gnXMgjun6OnhPHWnFGJa3Fum6oHaYqsUBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHmNQPDj3FieTXFcl2PEnDC4NHFB9Z2o1dQhPz9haSzPT47+LxdnZfqf1tOnL6u8j2w1KRzOfj7AULGsRUixmRr6mb9C+eKmU5KrJEDFoSDWlyxT4wtmOh2ZIyaAu2wm4KhHSb40wCGRv8iI8rKH4lEREQTZPJfcBrPxvPNjlZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sHfevkFL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sHfevkFL"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45f30011eceso56285e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 07:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758031459; x=1758636259; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2KMOMO3XHmFOxVaDXop6w1+ZPJDKNJK8AZpmO1KEadE=;
        b=sHfevkFLe39Hjvtqe/BK4X11Il7x0l2ubw9aovsYwEJOkajRHw8/mEIdOvLHtLIaIk
         0/tbaxRHCWOXzLaDdFw7AGOolV8BfFsCG+evs08QDM5Jc8Jqg+P1gUhlnMdjwP0jvxMJ
         4Kh3gnndz2SdNKnrusyXaplA4ty20h8X83j5nS9ArHUbCVxRen7pLh7Pi8Itq3ajjyuM
         FrZVyw3q+qnMfqlaJCJDH/ASUc5U7XgGydl8M/fm9GcBkDRTz1K8VCj5mbuLWIwfAv/l
         zVea5Bz6YpYq+8Q3WxFaZ9G9gHLMwBMOoiksgIulS5YfgchcEMQUAAKTSJWQqhnLOhlz
         L7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031459; x=1758636259;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2KMOMO3XHmFOxVaDXop6w1+ZPJDKNJK8AZpmO1KEadE=;
        b=BlBavHp00oMy/nDF5QXxqOb1RfdruYxT4I3PQzh+5t0drKT8peynM4v4mxumWkVh2s
         0HqBrspCkjMSesu2iINecDNEmVkTzJeYUmyvyBgwPEPRWhvfRtZgXoaYMv22SaIm6iI/
         ewkRR1qWbWpcvkA/j9jkYZWO5I4f26HgyP4mDqZkatZsAnynl4LUlf1W4rTgxuwWD8B1
         nsLYnV8LnDsGkcwsOaM55jDKKXIWE2TuTqFkXziG6PK9mhYXSZcSRvJFA3fWvMd3hlt5
         OFMyElrhH7X9qgZ40NO8jAm52x/vfFe3lD/zNy/YReaIMt9mAVh62JDg1pom+l2ojIua
         qdKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJsw9tBfKdqXI61MV0qw/EvXOhLGJk9cOIDgP4Y1gPxB5CnXlK8BItWz8vKcwK8WkRvNHpcsE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwK1uFtRymTeaaD7WXFMPGM5AZIKTFhvPntRLxg02gY5BbfQ2Hx
	LSfvbkhXOZxiEV35af/FqUSiq4EWy296QvvFZMzxAOOGlN90YCM6dAWsgzOOd6mhvg==
X-Gm-Gg: ASbGncuNk3JL4vEhwbKFCa/Y0NDSogQHkuo7deyXmHVsRyKcC2BRaFN58SYkVXUYovZ
	Lp6akI0brnEl4NUDRDycDKjdhzkkhvnbI3JlTK2nK+zVc8FgH2sLp6vECA2ef9PUN2eZZNFZmnw
	0CcBCwr7qZYE1f4xug0bIq2TPCF34Z9+IsviYP/H22CJJts0oXnNYGyCC37z1Z4zmdv+/ihdnpN
	ha/0pemDrXHN4ZpruCp/PyBl0a5dgV7rhlFylbZzHx3B3ztQ+K577Ll2lHqcYAKj0aYigKZ1Llm
	540/yjNhi6SIN/N4op4PiC9gsx/3bQPlZYVZGaZNOAwwuFqfQ+C21795S9NdgvD7hzyaYto4gAF
	CPjsje8JdkccbfcwONmqFyxWWm3mdgkJfhqcasbxAWlRNXiKb9Q0toLuirMRL8x3cpR2wVw==
X-Google-Smtp-Source: AGHT+IHnm9FwdHAPOXF/eEjid/iWJ/+0RKN/ZPnistvH7jALBPjgIBevgkp2XifrX2DSJ35JmAkJcQ==
X-Received: by 2002:a05:600c:a10d:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-4601d6b4da8mr561855e9.2.1758031458150;
        Tue, 16 Sep 2025 07:04:18 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0372aea2sm233815705e9.7.2025.09.16.07.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:04:17 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:04:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 03/28] KVM: arm64: pkvm: Add pkvm_time_get()
Message-ID: <aMluXZfrvg_-fhMN@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-4-smostafa@google.com>
 <aMA2ugNakqrA1Pg0@willie-the-truck>
 <86frcvd3hb.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86frcvd3hb.wl-maz@kernel.org>

On Tue, Sep 09, 2025 at 04:56:16PM +0100, Marc Zyngier wrote:
> On Tue, 09 Sep 2025 15:16:26 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Tue, Aug 19, 2025 at 09:51:31PM +0000, Mostafa Saleh wrote:
> > > Add a function to return time in us.
> > > 
> > > This can be used from IOMMU drivers while waiting for conditions as
> > > for SMMUv3 TLB invalidation waiting for sync.
> > > 
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > ---
> > >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 ++
> > >  arch/arm64/kvm/hyp/nvhe/setup.c        |  4 ++++
> > >  arch/arm64/kvm/hyp/nvhe/timer-sr.c     | 33 ++++++++++++++++++++++++++
> > >  3 files changed, 39 insertions(+)
> 
> [...]
> 
> > > +#define SEC_TO_US 1000000
> > > +
> > > +int pkvm_timer_init(void)
> > > +{
> > > +	timer_freq = read_sysreg(cntfrq_el0);
> > > +	/*
> > > +	 * TODO: The highest privileged level is supposed to initialize this
> > > +	 * register. But on some systems (which?), this information is only
> > > +	 * contained in the device-tree, so we'll need to find it out some other
> > > +	 * way.
> > > +	 */
> > > +	if (!timer_freq || timer_freq < SEC_TO_US)
> > > +		return -ENODEV;
> > > +	return 0;
> > > +}
> > 
> > Right, I think the frequency should be provided by the host once the arch
> > timer driver has probed successfully. Relying on CNTFRQ isn't viable imo.
> 
> We can always patch the value in, à la kimage_voffset. But it really
> begs the question: who is their right mind doesn't set CNTFRQ_EL0 to
> something sensible? Why should we care about supporting such
> contraption?
> 
> I'd be happy to simply disable KVM when CNTFRQ_EL0 is misprogrammed,
> or that the device tree provides a clock frequency. Because there is
> no good way to support a guest in that case.
> 

I can make "arch_timer_rate" available to the hypervisor, but I'd rather
just to fail in that case as Marc suggested to avoid complexity (and due
to the lack HW on my end to test this) even if we check this only for
protected mode.

Thanks,
Mostafa

> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
