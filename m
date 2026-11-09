Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794221275;
	b=4eKTSYgl5rKyMrvzyY5x9J2fYPgMhMJ+5IwYRLb7bofzg1K9QcTEtBLWoaTWfzpxV16M
	 Ww6PVkPBri807jM1QPxhy62Ee0aD0137yoGp/FPl31whinkgnGnMHvWKHVZkRHhZmIYI/
	 extYX8C2gBF7YElB2HoFQhDbZrtXA2vj0mqTgzl5S2uiBzMOVEnSTJHS5nea9hU//Bjs+
	 80tDq/RmxkAKFDybEBHdlNutPcvkGh98f+WBLwjHciwD5eEY3GzQvPj5GtJiDsmk0t3Lo
	 WaFBngLShmTg3bhzrbYsDVdqvHm/gso+M2hbwwJrGKmXfUfpxxy7J4BzusQepArqn7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794221275;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Wzi6KrhT88vehfKY7qgpQ1+JN6+5jlpjxZmv28MWhTQ=;
	b=HQFyrGK7nLtoKFbMb2LGTEjr20poePzFwr0ieF1FAyMy9NFzU31px5P5V4bn+ZuCkRzs
	 3sLM4dYiYt0wbPcPDJjncOeWyeQwytAA3DlQTfus+izfGEzx51y1/8wc5C5fFnkNL2smd
	 6lTwtcFrTmNZGZvuvqR7Z93GF0J3YvsqE1pM/8knxIcOHBlXPtcryxY+3M/ZJWvQDDe0P
	 CzCYFXyphYesioDoJf8UtFipDGLx8IlBRbqZuZSoAFVNJf4ag8kIfNZA+Ik42ppq8cf98
	 Zsv2+iwlmgedGpRXsggUcYj9jce7wHzp3D7HBo4TLt7BqJWJwPNpzaLIRejMRDTbliA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lvhMgIv5;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B03606A322
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 10:47:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3B03606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lvhMgIv5
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a018493d57so23215e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 02:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794221273; x=1794826073; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wzi6KrhT88vehfKY7qgpQ1+JN6+5jlpjxZmv28MWhTQ=;
        b=lvhMgIv58U7ffRHDCt/oCi3qU15SiX0HvooEudCydM5Z8TFMwsmp9sZ3kiS7XAdttt
         +1V+tbGCE8hSrrFJ45OClPuiNnUt7QcoRb7ThfabT+Th3f2OLdTYF2Sya/SABjB98ABy
         ALoXSziBO5COtMTb9y3Tz05Y/ANN1WVn4PCJyg7QtH+CnvPVhcrTxKxnQ1ORUNGo76Jq
         Hxnpl7Xm1pzVfQAOZPIHRsjVhokywRxX3/SERkf6WvduDijnpxMY7iJin+Mnj+OsROUU
         dTkVaND9A3E2pIs8JbvArDDzBP3BcZu1Z91KcjxNVhroUfNTnRrH3EYtwggsMfW9PKfY
         QTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794221273; x=1794826073;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wzi6KrhT88vehfKY7qgpQ1+JN6+5jlpjxZmv28MWhTQ=;
        b=Lb/HGRdiKhMIx44QTatyqoDb8NJ7xDGcIGo6UVt1d5tTBn+piddrRjo8k9I9P4sgBP
         tYu7BmOQby5iKOxUAoDXP9yGpOjd8e72Uu99sZ2gQOQQ5uWJSOZlXwOhnWEaek9nSrI2
         1G/EJ8hx4/r5P6qOppZxanJ+UOM28cG+3nEyStzM/kj6RR+L5SJxqn7/OVR1leijF/Dt
         mncqKsrovhzpwrfgXs410HVrYjscYl9Y6e1j0mCAnOu84LJpaA/le4Ni/VtWPGIZ/MAR
         2CkvYxD8RbFVpdDCTyyj3iQsNs1sagFr9Hpb399w/dzMDwdKbELnPVZYVhX+b7+cLgfo
         w/7g==
X-Forwarded-Encrypted: i=1; AL+hErFoqqRS5LMepI9Beve2Xr54xudoFdVMsDb0t55CMCyjy+d6uSggZwcWkzHRsmvur+7JLaE+L88=@lists.linux.dev
X-Gm-Message-State: APuU4Z+m5Kdp7Z0/qXnjPJNnP5kFy5uUym5iXHgyXDXenXabsXvK14rH
	xrcsm7pS/troQttMKe55Oa13VUEo6hxAfBDjFp5JY3q//89PF+0y5v8wCNriad3XTw==
X-Gm-Gg: AYBFou0P+8XVekDTb2ugvMlebM/1ukAsUsBtMAiAXyMJtKt25Taoqo22CdAh8fUU1OD
	+0yO0U8G2+LdaFjmsp6LK2DNua25sqRY952Ua6IXsE53WTK4iL9YuXVceZNKqNIS+z+uAatZ2dQ
	2oJTx0TxMbeNsLe6cdXnrI0CqaUiGpuPDsioCsMA+enFC613pcv/Rg6lfltQ5Ijeb1kCdaS/pUF
	M3rMzDRP7zHZlOxKf4kix2YoMP63CUXeprSeQPiPuavasU/o9MISDAP7w5H9+hohuK2Tlwy/4Nx
	jPAvySGWzYmlWKHNLI6UUXJXgiP3367MW8QWwZsfjVp6Wsk4V3EsBCE/KLXqMSOOx+dXG7MGEtR
	ShEAhV5BB5qvvcWTwN4MJbwVNGq5lHU1Xf4QLR1A3q4TQDiU3SA0WWFDu/5p3fDLpYHhFvzcHTO
	2zYgnnB6BezDB3ViI1ozM2DRu1Fo5Ndzq6XiqRJmAEfbH21q9bG7UwB83rd7d1fWW11rt5tLXMB
	hzkLatAXU/jcOod2f8kpxTvoximOEGnsIi0rqQlZpsAiHaQUeTwb32Iq5yzcsgYxVmqU1RuXxPA
	+WSexzYaRKRYparyi9UdxNj9iHaQM+6Kup8EqF3s55fLQT7uaqe3IMzShRWTx/7AxW6oxA==
X-Received: by 2002:a05:600c:2d91:b0:4a1:d373:5759 with SMTP id 5b1f17b1804b1-4b8b04d3e52mr1256155e9.8.1794221272587;
        Mon, 09 Nov 2026 02:47:52 -0800 (PST)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b90f1117fasm149512245e9.13.2026.11.09.02.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 02:47:51 -0800 (PST)
Date: Mon, 9 Nov 2026 10:47:46 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <avGk0ilyJh3obmKx@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
 <auzvygiGRTWgJXzF@nvidia.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auzvygiGRTWgJXzF@nvidia.com>

On Thu, Nov 05, 2026 at 01:06:18PM -0800, Nicolin Chen wrote:
> On Thu, Oct 15, 2026 at 08:08:42PM +0000, Mostafa Saleh wrote:
> > +static struct platform_driver smmuv3_nesting_driver;
> > +static int __init smmuv3_nesting_probe(struct platform_device *pdev)
> 
> Could it use a different naming than "nesting"?
> 
> "Nesting" is widely used in iommufd path for nested translation.
> 
> Here, it could be smmuv3_pkvm_driver?

Sure, pkvm/hyp works.

> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > +/*
> > + * Two devices are involved: the aux device bound to this driver, and the
> > + * physical platform device bound to the pKVM init driver, which only uses it
> > + * for discovery. This driver keeps using the platform device, as it carries
> > + * the fwnode the IOMMU core and consumers link to, the DMA configuration and
> > + * the IRQs.
> 
> It would be nicer to have a diagram or so to show the co-relationship
> among different devices and drivers.
> 
> I assume the regular arm-smmu-v3 driver is a part of the picture too,
> when the pkvm driver binding fails?
> 

I can add some ASCII diagram.
If pKVM driver fails, no aux devices are created and the main driver
probes the platform SMMUv3 devices as usual.

> > +static struct auxiliary_driver arm_smmu_driver_emu = {
> > +	.driver = {
> > +		.suppress_bind_attrs = true,
> > +	},
> > +	.name = "arm-smmu-v3-emu",
> > +	.id_table = arm_smmu_aux_table,
> > +	.probe = arm_smmu_device_probe_emu,
> > +	.remove = arm_smmu_device_remove_emu,
> > +	.shutdown = arm_smmu_device_shutdown_emu,
> > +};
> > +
> > +module_auxiliary_driver(arm_smmu_driver_emu);
> > +#endif
> 
> Nit:
> #endif /* CONFIG_ARM_SMMU_V3_PKVM */

Will fix it.

Thanks,
Mostafa

> 
> Nicolin
