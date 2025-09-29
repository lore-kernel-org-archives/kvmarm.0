Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB42FF678
	for <kvmarm@lists.linux.dev>; Mon, 29 Sep 2025 11:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759144220; cv=none; b=dxIW/ERVYfr7YLuyeSQX0eayvR4IvxfYGvl08L0uuYd3lHwBSn8xrRxcS+1CmomwtAuyvYqvpiO+66MWIVVWf7Py+Dap8SGPKiZYhvMK9g4wJr8O9IEjc7ueYO+fSEVmfoyyD4cooePwLYA5G3Dg2WQnknTrOUsQ9LeMRnba6mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759144220; c=relaxed/simple;
	bh=uGU0X4XRvs5GtQI3Ay7FhA1xMjMBv4FbZpT42eARQ58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XS39A1DZ7naaJKmbgr5tkg2ai4VpuqIxfTM3Psl8gjJMpUglmv0SA2sLroEK7J/kBHeJ7aAlD6V0c8HFfpivOk0/Nje6MNwUSTp2zWAI/4BTu8Qo5S/ibwiArAG4VaRv+2OgYlStd+n7gk1oCXF/4+ZHmmy6XivRcbmUDjO2G/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4PJ1wsIq; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4PJ1wsIq"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e3f213b59so118125e9.0
        for <kvmarm@lists.linux.dev>; Mon, 29 Sep 2025 04:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759144216; x=1759749016; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KBw4ejj4fmMEafZBPpzx+wYOwZgdJDUmWT9JGV8MXfA=;
        b=4PJ1wsIqCPZSnL0M9YVkkW1WN0MS+dSnil+cGJBKCxbctKoktxNIIdz7bkXXWl4sN7
         CXHoRy7d/Y01EG2SG7drYVoCJddPcQrnr6AMdOSO/xzEWBYr/M89C8ppTUoMxHnU4fzP
         qVHl77ocE1Ou9BnGrZZ6v/pB/nzdX4DRdM2zgE/n9l5f2akP9gdIrHvgHhbrlAKfZnk3
         150gz3irkvl0ytvps0YQSsW9K49cs+NkSQ7Q8WVwAKB0BEk0aOatlqP5O8fEnMQSAiaD
         lkJa1jvEWSDRyJTnlSsdsfjO2n5iW8naNtLm/FJJf4GvL4t3GS+Y3BhSVEmSVpJ/8bOI
         9MBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759144216; x=1759749016;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KBw4ejj4fmMEafZBPpzx+wYOwZgdJDUmWT9JGV8MXfA=;
        b=mhKVNed9X7n13ZkN8Jou3veGo6JXaYUWcsPxp4eTH/ZD7Lh8HR6EMyQoBuP2L+hRwc
         wmy7b0ClIfL2+9BdcC32pz2Imlkhnkbiqdf4KSz5ZXZHS/bCQh3Pi+ydepa0GRFqNxiI
         SQv7sBGZPYGqqPPPEQTXVhgnUAgxqIX1SUKlcYQRnazuzVZeXBoCpLOhov4cAGjnFPA7
         3hYmRviqEMJpEE6o18tNRVCCbBzlagrs9dTOVscXtiHR6+eYTNZERlW7CdGNXCIFgiI+
         nvG4i1tfgondqU+5qe8xKq5EwqafkK8vpoGZqPAIW/0QTsBhSUtEWYcOsXVDCIxYbnzl
         SNRw==
X-Forwarded-Encrypted: i=1; AJvYcCV8SUd8gWw+h2QKxhOkLwVdUYU9pFvLiwo6ewz1qLbMiFg3Ff9um60WDj43MO3xgXYuGv2Tvtc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaLy4QJ2NxIc/6MC40G6goQyuw38PM9L6kGflPSN5oZp0ASTNu
	9PNl0DTj7P52FCXPUqOGUwQUzY/W57/6+8dcNt31z59hLhl74sBco6CSm9uNNLx66WgZNvnKliR
	CnwXl1Q==
X-Gm-Gg: ASbGnctWN7gcRkJUnyTX9AEgNlGYd+y1TBUU2MhOVnUCEGhkE9snO8PGBPp0fKTNqTj
	t76AK0rNIQRAOSH1lNKMZ2eIKes8VkZO8K+oglwykzT2rYbkt/V7t280tPwMhyAPAiZtZc93Yq3
	DMK2qxbD/0ueWQNSjK+d62KxtfYOR8mbOVfEsEnJRovpmgTTitHZqLUCm8HJtmojQJB4/Xkhn9K
	CJkAiTi9gyrykOesy5IHC9FM5vNNCl7lm2HL7tSq/4TziD3YrajAIQRLgU7Ycxt8jX7+1T3JVwv
	i7pr4W2//HHgWUMOQJnb9HGmigR+dI1AUpL4LxDKkiD9o2MNBDrvAK341zDcBVtqFKkQGNaAT3K
	ssKaARmF31bbC0fkyTqbmnUtzRvhPCWEpyeIN0qhM8zUBb47dPvwKjTvQ0AkPX8vs+8w=
X-Google-Smtp-Source: AGHT+IFGf4k+JJs/tMEbOwTNQ+j0uedEPD+8WOGLeH7x1gD8a+XVxRfw6dvXWns5XmMqAfUaxJmdrw==
X-Received: by 2002:a05:600c:37c3:b0:45b:9bcb:205 with SMTP id 5b1f17b1804b1-46e575a08e6mr402015e9.5.1759144216266;
        Mon, 29 Sep 2025 04:10:16 -0700 (PDT)
Received: from google.com (140.240.76.34.bc.googleusercontent.com. [34.76.240.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5603365sm18381901f8f.37.2025.09.29.04.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 04:10:15 -0700 (PDT)
Date: Mon, 29 Sep 2025 11:10:11 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 15/28] iommu/arm-smmu-v3: Load the driver later in KVM
 mode
Message-ID: <aNppE9A3PDiDg_1W@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-16-smostafa@google.com>
 <aMQmA9cLaeYWG5_C@willie-the-truck>
 <aNKwROPzDCWgJBGQ@google.com>
 <20250923173806.GF2547959@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250923173806.GF2547959@ziepe.ca>

On Tue, Sep 23, 2025 at 02:38:06PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 23, 2025 at 02:35:48PM +0000, Mostafa Saleh wrote:
> > If we really want to avoid the current approach, we can keep deferring probe,
> > until a check for a new flag set from “finalize_pkvm” which is called
> > unconditionally of KVM state.
> 
> I still think the pkvm drivers should be bound to some special pkvm
> device_driver and the driver core should handle all this special
> dancing:
>  - Wait for pkvm to decide if it will start or not
>  - Claim a device for pkvm and make it visible in some generic way,eg
>    in sysfs
>  - Fall back to using the normal driver once we conclude pkvm won't
>    run.
> 
> It sounds like a pain to open code all this logic in every pkvm
> driver? How many do you have?

I though more about this, I think involving the driver core will be
useful in the future for init, as it will ensure power domains are
probed before the SMMUs when RPM is supported.

One simple way to do that, is the make the KVM SMMUv3 driver bind to
the SMMUs first until KVM finish init, then it unbinds them so the
main driver can be bind to them, that will not require any changes
or assumptions from the main driver, but in runtime the KVM driver
can't interact with the driver model.

Another possible solution, to keep a device bound to the KVM driver,
is to probe the SMMUs from the KVM driver, then to create child devices;
possibly use something as device_set_of_node_from_dev to bind those to
the main SMMUv3 or find another way to probe the main SMMUv3 without
changes.

Then we have a clear parent/child representation in the kernel, we can
also use sysfs/debugfs. But this might be more challenging, I will
look more into both and will update the logic in v5.

Thanks,
Mostafa

> 
> Jason
