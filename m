Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831853EDE60
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 17:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184132; cv=none; b=FQ2UWZ7M9w4KY7Ps20Tyc66WtUTYIVZbuwQeSUTGx7GsHGGd3ESu8w4wpJOOtMj41+NG9vLZqA/wVnmmbUQCkQrAgQpCDhdtVsevAvDERzRlv/59KP2ncpJXugNpPJcqfcO4D+FsyqxHHIJEiMIVa1LAe1JpOdHJGaPC0rYpi8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184132; c=relaxed/simple;
	bh=D9Nh1qABv2EMxX6HivmQ3UiAglxR8QFUMaPCX1n/oZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ood5Bby+k68Q/qvJnsVmjN0NZaaWzqZfsUkBzIsMPV+ojWmdDagVUpJIV5XWQlI/Qo2QNANHkyyjut+AaNSUrRI5rzyGTx7PiO7keKhchYkXa886UcHrnfvD1spTl9Nh6DQIIohuXvkXDkgwrXwxB5u+K0ND3EL7lw9rNUeJmUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=cER96IEU; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cER96IEU"
Received: by mail-oi2-f13.google.com with SMTP id 46e09a7af769-80a71781323so867235a34.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 10:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790184129; x=1790788929; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nZO+CuLetaTJpUNxxsNmcxZ2zY0gVwrRgHqGQbQ+ftg=;
        b=cER96IEUjOLoOehNuw+UchOBSnGSBoXhq+2oH81ULPlzuGg6/Y5nGcmNbUZAVl00UW
         V5mwY7KZn+jHOW2rnou2jEOTaZseT5QyC0aO5v/fyqip/J7PX2eSJAQRzqI2CaP25AR1
         FGul08Hxs7P0E/SS3QIx/AZg0NGynkKKm0A2KafvT/P68uTJhM2R1PHycnAMyZda55aE
         0NeDRb3ylqycOAf8lpMbLYFqRNKI5wCS0oDPzzLlfnlIV8TloC97s0avt3fy+4uCsexY
         FmtM4oOQQkTWY6gokVI0duk3bZkMoz4b0k080+z9yZLhxgHvw9QVNpmdvxrCBM8k15DI
         HIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790184129; x=1790788929;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nZO+CuLetaTJpUNxxsNmcxZ2zY0gVwrRgHqGQbQ+ftg=;
        b=K5Acpw6oiD5tk3Qf9onulWjlkqzRf6dZMWjqoKIS2o+rxVm16bxQDgnpzhzSsqOG9D
         lx6uYXNq52og7JiN0l4cWGAkZhN43zN8KoRV7qfK2D0xQQOULjOCoB1cNUlFfRGdGXu0
         Gcw5ad/FPEEGQ1QrAXrQdFTIBWrNTRD4Q0uWtHZs6HzX7v5KZJFfWfIaRJVGk7pUy7nN
         InCalDkozOCnrC7SrJY0Q7XaoJaYdXmJDsYLfL6qrXDSeb0D6VDbBEWdBtfN6UXhH4k7
         Pu0ZH1i+GKysX9Gn4Pu4sfXv7Xc3TTiabmMVnGvb8rH1xA6Dc/Cf5KEimXBOr+2I22fu
         f8vg==
X-Forwarded-Encrypted: i=1; AKwUvBzU+MCnLbfsLWyCf6jMeuK5YkdJK0Mnk28X8MUUORdWMUB9oYfY+STAxbVTvwWTVJDyim4Leew=@lists.linux.dev
X-Gm-Message-State: AFuF++kz9V2FOspYPeq0AjfK+zWGcxHBdpQndH8jG4oUBBS1/Vglzxws
	7wZIAchG0iF9LVSJwRVSEN8kZi3XVZt0rHPAf4kz+obU2e5tGMZjxJvsYzE5I+qwkdI=
X-Gm-Gg: AYBFou31812UJ12XvmBk+wwJ4rEmvLaov1hFF8pXvU3aPAhKj5IWDrRH76CwUoLMqXN
	MjRnxOTCRbAgQW2i27Kzh4HKwmapjLVucisHDqGIuvn6wRaA7ESHVQG5BbFKxBYGjS7/v9efhEm
	5bYUhX0ysi5iQTb9Pv5hcp2hhWUKmAATLTGYREHlwCFHUqyFQwELDGu0sVG4O3oTHFEN+vOVbY/
	gjXTsofHPlkI0bNp7HO62W+U979XGDhejrbcUE2yEtNfEkKkt/wrSxq3X+SZFsbrblen0JBs2XJ
	XdxvvUChWyL+VrLaK2tIw/9usL26tkSX0ygJi11HCvhsz5lji9TMkEzN9NnmB/al0JpK+6XR42q
	n+4tYRCbDXSK9m4JueurqymFY1zf7wzcCNrSiHA0bWCKLRyUg+mWAtXEW210DZ+pwov8u4HKtyk
	ic+5WsY+eEzcqbu335vNziZccc3ITqoBU/1k7qwgiMCUFoXwuJtreG2lY=
X-Received: by 2002:a4a:ee12:0:b0:6bd:c175:521d with SMTP id 006d021491bc7-6d2d023f352mr2916611eaf.11.1790184129300;
        Wed, 23 Sep 2026 10:22:09 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6d2ce25c058sm2985571eaf.5.2026.09.23.10.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:22:08 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9QfX-0000000E9a2-3usD;
	Wed, 23 Sep 2026 14:22:07 -0300
Date: Wed, 23 Sep 2026 14:22:07 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <20260923172207.GL1540250@ziepe.ca>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-12-smostafa@google.com>
 <arMbxX+sqTS3gByB@nvidia.com>
 <arO9hGmEx7c9mZAj@google.com>
 <20260923155507.GJ1540250@ziepe.ca>
 <arQHamIHuaUqlJyy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arQHamIHuaUqlJyy@google.com>

On Wed, Sep 23, 2026 at 05:07:54PM +0000, Mostafa Saleh wrote:
> On Wed, Sep 23, 2026 at 12:55:07PM -0300, Jason Gunthorpe wrote:
> > On Wed, Sep 23, 2026 at 11:52:36AM +0000, Mostafa Saleh wrote:
> > > I can add more info in the cover letter about the code split. Mainly:
> > > - arm-smmu-v3-kvm.c: Is the kernel driver for KVM SMMUv3 (this runs in
> > >   EL1 and can use all the kernel functions).
> > >   The main job of this driver is for discovery, it doesn't do anything
> > >   else in the runtime.
> > 
> > Maybe call this el1 stub or something like that?
> > 
> > guest_pkvm_stub.c
> > pkvm/hyp.c
> > 
> 
> It is not really a stub and I was following the convention of
> arm-smmu-v3-(iommufd/test/sva) I think for the pkvm/ one it can be:
> - pkvm/arm-smmu-v3-pkvm.c
> - pkvm/arm-smmu-v3-nested.c
> - pkvm/arm-smmu-v3-el2.c
> - pkvm/arm-smmu-v3-hyp.c

pkvm/arm-smmu-v3-hyp.c reads well to me

> All of those are fine and for the other one:
> - arm-smmu-v3-{pkvm, nested, el2, hyp}-init.c
> - arm-smmu-v3-pkvm-el1.c
> 
> Anything along this lines, otherwise it's too vague IMHO.

arm-smmu-v3-pkvm-init.c seems clear?

Linus has complained about the stuttering before, so think about it..

Jason
