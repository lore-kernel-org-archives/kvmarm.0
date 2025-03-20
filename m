Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E4F1EDA3A
	for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742473644; cv=none; b=bNoLi7ePSiR5UgAnmpUvyiriRIhDChipOVK/StIaB7FV619QvEG8gWYVeFwoXoHyjhbyRXPBaKtxzfKTzVQIQCYyW48DuwSLMBr+9HX4nEYxr0FAY0B3enu/do5Tfaeljgf31vyW76YZiG/01VcWe016AZUBGjXVDpoBawGGVaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742473644; c=relaxed/simple;
	bh=0KqmKcwnP2ZM8J1oayLgNQo1WGTmWgXX7O7nQamUJHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3H01uFLcI0w6vMRo23QLbeB3n7kVmKUO35sD1AS0UCrtzyZZEnel6NkxtO8CnfhbiZ+Z1ViMsnONNhLhVcT/Z4wMFAiCXsd02ect02N64DkjMYgG9M5ydoH6s9YXKT281sczbzfyCmMDXryZ/AMrS9gRrAkWkpX2PLmBil2CQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ST7+zYFO; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ST7+zYFO"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7c56321b22cso78048585a.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 05:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1742473641; x=1743078441; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=owuoEKLJ8GyqS05+WPOOz/9ttskeFhIAhs7NlVT92ic=;
        b=ST7+zYFO/g37JmXNxXjsFDmBAZJwSFDPQ9K7VTua+3+rrnygBvC2roTjbDG23fx0Q4
         G2CCU0e2fwgRleAMInvsKMBrrxOGdlDB7XDbDnUcC7qZ/zfFqLdFMU4cg/5XlxIfDBF+
         WFr9QFHplM99xRSzC9mK9QLpJMtyU/OVlCs2xR+0D75ulDk5OlIVGpmUAjBP1N8hEdrx
         WO17oRbmQTqJL8ebY0g0Hqk6VYr3bq7FWRaK7Ry9MnhaPuCE4OUWJHeG06H7PU/9wy4+
         FXbSCrqxB+RFeu+aZhkSqObozpTaKweb8J9pkVrA5b/sJQes1iakfA9XyHcXwc/jMzm3
         +zVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742473641; x=1743078441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owuoEKLJ8GyqS05+WPOOz/9ttskeFhIAhs7NlVT92ic=;
        b=EUMPK3zOGp8UuE4zp+sggr3bS2ux8k/Fox/v8pOSh1Iym1GEUKzpJfMlXECGtctMSY
         Z+6l2l0iw+JXXldzwZqPUt6mwBEFKtj6a0HBkcPRJufsboODtDGsNEiSDKv/o9RT5MeN
         JV6ZtQPWECFUBemQsIdF0+tS6uUtlYPkchfdaFs7ciSQkBTEqDNTWMvkNbLxTqoxy/ce
         tQj3cLekz8bSopE9AgAN5jpOTmtUq8kA3BagJamw10U1eXT1DLxhrMcKWSVUYEhLlsql
         D9JJl6c5rYr7V9ORuU/s0RBPfwd3hZbl6wxFwzwwLdPdGuCBiPEednXYg+LDUCV02yhI
         r+/w==
X-Gm-Message-State: AOJu0YxqjkWbLoTx/fD0u88eC6pSo7z/jH0eSa1A2ERcIDBLlIg6MXrn
	Cmbdvp3jlS3quXNaAIf9Oz0w2umU6MBpO/UGs3qbOfODlOET+jR4rjhUxw/GeVI=
X-Gm-Gg: ASbGnctRPJ/UunIynVuffy5cGR599x7ysvggClxNfXR6F5eI0fbHxWOTSfVVuapNA3I
	uCldwj1jm8kZUMghelefDRdXX2FYvm1l85ESTKmiwGtCdwxHg1rPpvjAo0+8gtzAz+7YDryJ/vd
	B0zZC6bm7c0xTRawoU1sPHdiWfollkApELTWp2NFufjOfY/6hEzvPWqmhblG+pakGLWzKV3Nrlc
	n4VqP0Z2i3H/+R0yAV5Pl42KnOMao6WJOapG9m2omPa8r0CkSXh7uVsDKTzvv0cgfM+dMhYS9bY
	qJFx8ni8oUQ/dw/PSxsfIJnzuIB6iBKJ5zFY69IrxPiOOyyjny/RaVandA3pVGEmDNLQtyfjq0X
	IbpQj5L5Fq6bFEC67Vg==
X-Google-Smtp-Source: AGHT+IHBPIN78tejYWs7VfIlk4YaIqTbv/OkaggJ7vH5SMoIZQdAyhpfUCC8gDblTwanJpuz9ATgQQ==
X-Received: by 2002:a05:620a:f02:b0:7c0:ad47:db3d with SMTP id af79cd13be357-7c5b0550e7bmr538847685a.21.1742473641194;
        Thu, 20 Mar 2025 05:27:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573c7859bsm999375685a.34.2025.03.20.05.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 05:27:20 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tvEzX-00000000hOS-1nJZ;
	Thu, 20 Mar 2025 09:27:19 -0300
Date: Thu, 20 Mar 2025 09:27:19 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linuxarm <linuxarm@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [RFC PATCH v3 4/5] iommu/arm-smmu-v3-iommufd: Use KVM VMID for
 s2 stage
Message-ID: <20250320122719.GI126678@ziepe.ca>
References: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
 <20250319173202.78988-5-shameerali.kolothum.thodi@huawei.com>
 <20250319233946.GF126678@ziepe.ca>
 <f654ae10e55e4142acb83eb926bb80b2@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f654ae10e55e4142acb83eb926bb80b2@huawei.com>

On Thu, Mar 20, 2025 at 09:30:45AM +0000, Shameerali Kolothum Thodi wrote:
> > Isn't kvm_get_kvm_safe() in modular KVM code most of the time? You can't
> > call it like this right?
> 
> I think it is safe since KVM is not modular for ARM64. And that is one of the
> reasons I thought I will hold the KVM reference here as we don't have to go
> through the symbol_get/put calls here. Also IOMMUFD is not using the kvm
> pointer at the moment. Probably I should add some comments in IOMMUFD
> to make it clear.

Oh I didn't know that.. Interesting simplification

> > That more closely matches how this will eventually work when the VMID
> > allocation is properly made to be local to the viommu.
> 
> Ok. Will update.

You should also block creating a VIOMMU without a KVM for the same
reason.. Really isolate the S2 to only being usable with the KVM
shared VMID.

Jason
