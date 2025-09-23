Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D001A9F90
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638156; cv=none; b=XSmTfivN6TpsCGZEsOCOujzck9q1ZwfaCKeWwKYq6sO5g0YoVbJtN4HcCHgwe2ju6ZBrDTj1I+qa3icrRCJoDIC5j/qGNrjQh8IugQ88RCIToylIlSTXRUh8QIC6xZOOW08bGtqYKJ0c9A4lHhx8K+DwI5HP8GkCHWRWLDM8lbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638156; c=relaxed/simple;
	bh=+qI76m61UBIiYSKYa7PKpe19ghecX989zXs+Qyuqc5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+j4GBkka+22G8kwXTWcY+k3mCGkWSoJDDxK7UdWVqS6397ykmXKPgELFwJoRhuUq2eDvr2t49KQYvRAkDbj+4yIfxe6bUv5Rh2LA0NOtu/yeCjfY34HGJJYr/u643WtPQbXCBSuqSeGbIYk9YYEUzWNfeVSt81jgtRZcaSo4e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZNXGHRvq; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZNXGHRvq"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46d6080d3bfso56805e9.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 07:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758638153; x=1759242953; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w7gFiyv7OnRS5nGrN+3NtlLFQvUag+pzI6L45ZXC1s8=;
        b=ZNXGHRvq89QfeLKMHgme5jjyytZZXhSV6L90YxQ8BCv6oA+f8xuQFs63Hd0yLdgGq7
         PtyIrB/7IkRLHL/DTSK9THx+3PmhT/8UX+ZS95mmA7KgbcBXJpFvz34WsbzTQ7srghvn
         nvpO9VwpIsLpx5DnE9xNjQeC/Q3Xt0MhW+rmblkkH1oz44nMo24ZSEwhoKv8HFvCzCd+
         mRSwaDdlTOLndOAnaMd9H/mvPHzwRcRXm5xnAeO1574Tc3rM/Z+AJZ7kCGSCFYv0GD+b
         AiLwjRwGm7R73fTxbaP8XRfwNNotmtscWY4KGMOv7jQDStCp+0XA3ZlMuiqkZ2Pu2Qj0
         wPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758638153; x=1759242953;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7gFiyv7OnRS5nGrN+3NtlLFQvUag+pzI6L45ZXC1s8=;
        b=pvrhfwELxJ2KSeSeD3y/nEeWk7PsSec16ujnPxrkevkjfpYYm0tc/AjZJScKbOhdZW
         DwQ9IA6T/VeyrzTpz+4/cm5tYGh+qTEM+ifRQ8xyepkZFX8fKEdl8iWoKBwga3qup7s6
         QDJSByzhyaqLTMM7Q57lFNoFAKq5FVJWZXgEbhryZyJMJtGIwkcPgLT9E3mX6zsM2eu4
         7yEf3AZTlb8EfZqlaf4mZ7iU+mGfQ5KJ5MYqoS7RA4UVh6m6WOh3L2A2ve7Xv2mP8GE6
         cGynVdQ6+e3TJCwRJKfpdWOx733wBs4yoN5pmIT/ULhg9YG8XGkGck45mMmvRhgbQbVa
         ZhUw==
X-Forwarded-Encrypted: i=1; AJvYcCUUk78N9EiM9JnCPHvLzy8263jzeFKC8bkQuXglrzUXqKwYVzHF+y7D2eeGjXTBmQJ1FlyPApE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMuwDIDETdkUQhm1UhCIDFlEPkaHbfTQ1gowUcbvmFWrc2kz5J
	9ZX8kDUs01tIVgdKs+AMuL815xIw2dNe/CVUh7wLsEHA6U8i6T+raoLDvrJKOH+3sw==
X-Gm-Gg: ASbGncsKgRyOdJZCQ69uTMzYGvrKSkzopvJJR85PuuW7Z7+b0/CX3yRiuc8goWacxjR
	MdaqsseUqbk3FQon9KDMglfC3PNnXU/MsalrkfZqKeSl036wYXpsLauKL8aRdQZrSWqwocQximp
	oCkPF4+GvLQEBt/XfQLdjce3G8tOGUT5+wDCFnP0a/4JndCx7jmhERI+DVI5/GbfaQfVfsOp5zE
	TeDa+GJ/V3knAoQVQkdMkSe3qvGMUhcXHy7qL46ED58hwTtEpOYuZl0gT9akYsJKZZqBSWuBrJR
	INeFvkFeEl+Umo6m+c9k1sWXAPLF+tg3wziuX0TfQX5uWCyHUiXBSPlq8ObprxZeRaAYghtKRzY
	L5QGWj6wDQdJmiTsGodbtSORT0z281KaMeHQ92OohwmvCLKqJuFrhpXUwyu0CwEzo17I=
X-Google-Smtp-Source: AGHT+IFvUZC8hU4aVaM+B2ZVSTNY2pCK/nLLcGd0XFRXs64IKLx9ZNGK9gnrvBoN85r9vD2bqa+nEg==
X-Received: by 2002:a05:600c:a40a:b0:45f:2e6d:ca01 with SMTP id 5b1f17b1804b1-46e1dc7b863mr1452625e9.4.1758638152887;
        Tue, 23 Sep 2025 07:35:52 -0700 (PDT)
Received: from google.com (140.240.76.34.bc.googleusercontent.com. [34.76.240.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07408258sm24481309f8f.19.2025.09.23.07.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 07:35:52 -0700 (PDT)
Date: Tue, 23 Sep 2025 14:35:48 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 15/28] iommu/arm-smmu-v3: Load the driver later in KVM
 mode
Message-ID: <aNKwROPzDCWgJBGQ@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-16-smostafa@google.com>
 <aMQmA9cLaeYWG5_C@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMQmA9cLaeYWG5_C@willie-the-truck>

On Fri, Sep 12, 2025 at 02:54:11PM +0100, Will Deacon wrote:
> On Tue, Aug 19, 2025 at 09:51:43PM +0000, Mostafa Saleh wrote:
> > While in KVM mode, the driver must be loaded after the hypervisor
> > initializes.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 25 ++++++++++++++++-----
> >  1 file changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 10ca07c6dbe9..a04730b5fe41 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -4576,12 +4576,6 @@ static const struct of_device_id arm_smmu_of_match[] = {
> >  };
> >  MODULE_DEVICE_TABLE(of, arm_smmu_of_match);
> >  
> > -static void arm_smmu_driver_unregister(struct platform_driver *drv)
> > -{
> > -	arm_smmu_sva_notifier_synchronize();
> > -	platform_driver_unregister(drv);
> > -}
> > -
> >  static struct platform_driver arm_smmu_driver = {
> >  	.driver	= {
> >  		.name			= "arm-smmu-v3",
> > @@ -4592,8 +4586,27 @@ static struct platform_driver arm_smmu_driver = {
> >  	.remove = arm_smmu_device_remove,
> >  	.shutdown = arm_smmu_device_shutdown,
> >  };
> > +
> > +#ifndef CONFIG_ARM_SMMU_V3_PKVM
> > +static void arm_smmu_driver_unregister(struct platform_driver *drv)
> > +{
> > +	arm_smmu_sva_notifier_synchronize();
> > +	platform_driver_unregister(drv);
> > +}
> > +
> >  module_driver(arm_smmu_driver, platform_driver_register,
> >  	      arm_smmu_driver_unregister);
> > +#else
> > +/*
> > + * Must be done after the hypervisor initializes at module_init()
> > + * No need for unregister as this is a built in driver.
> > + */
> > +static int arm_smmu_driver_register(void)
> > +{
> > +	return platform_driver_register(&arm_smmu_driver);
> > +}
> > +device_initcall_sync(arm_smmu_driver_register);
> > +#endif /* !CONFIG_ARM_SMMU_V3_PKVM */
> 
> I think this is a bit grotty as we now have to reason about different
> initialisation ordering based on CONFIG_ARM_SMMU_V3_PKVM. Could we
> instead return -EPROBE_DEFER if the driver tries to probe before the
> hypervisor is up?

I looked a bit into this and I think the current approach would be
better because:
1- In case KVM fails to initialise or was disabled from command line,
   waiting for the hypervisor means SMMUs may never probe.
   One of the things I was cautious to get right is the error path,
   so if KVM or if the nested driver fails at any point at initialization,
   the SMMUs should still be probed and the systems should still be running
   even without KVM.

2- That's not as bad, but it leaks some KVM internals as we need to either
   check (is_kvm_arm_initialised()\or kvm_protected_mode_initialized) from
   driver code, as opposed to registering the driver late based on a kernel
   config for the nested SMMUv3.

If we really want to avoid the current approach, we can keep deferring probe,
until a check for a new flag set from “finalize_pkvm” which is called
unconditionally of KVM state.

Thanks,
Mostafa

> 
> Will
