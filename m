Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BB132D0D8
	for <kvmarm@lists.linux.dev>; Sat,  9 May 2026 23:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778369688; cv=none; b=jZYrzlrV9vBEvkGV+fhVtL9dtZ50h60e3b0TwhmyqngIMiKUkzN0xejgVLPQq436GOzfEociAo4JA6/VkGgIxytBR7eIydTh20tuR+iqpPuhc4LMk4J79OPLsNlpK8KFrI/sS3vY7bXUFq/N6V/P3rwWA1yMSwPr0kx59mM0jo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778369688; c=relaxed/simple;
	bh=viE2tZT/M+fmeTU3fRuSrMwCvMP+jn8S3W++VN5Bl0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjRBj1RAthrRbmOjfON7UmzzTChT68IQRGmEv9FfEreMpyc43eaxN+qhhoa+TMOGphgo6ptgjxSp5uiF/ZahEEwmq/j5K3qa78HIjTU6cJ8gJMewG03QX1a54US968xX3CPqo0qkVsQKXeSxFCoyiR5KBWmjk8uoO4nOkARDgk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=R4XcU/RY; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="R4XcU/RY"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-514ae601df2so1331431cf.0
        for <kvmarm@lists.linux.dev>; Sat, 09 May 2026 16:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778369686; x=1778974486; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t6tLt4US09DyLso/mhdji9Hp8lkbi3csRWs2bmEy9sU=;
        b=R4XcU/RYKFBXFTaONdVKP4n+LPB81y9dWQ32Wr2E+uFGBfCEYZyQt+lRGAvpn8rRtf
         VkU3Pl9OzlgfJWx1FUHVTMUZLN52tJajiVPHmOBK2mTMIH0NLVZfAw3j43ITJfsgkqh+
         xFy9SPg3tyOcoK4UR7bruur+aMDwKnr59I8el9xDc9ykYpwYty0wDt3VCctsr6M9rVwP
         3H/wt/XshOqT6YQe5KLDQ7rYsfjAgHo5bI2Y2/6v7ZQHuwxaxdjij34x5iiFL2y/Ya9Y
         /2oNI8+ByzevTZbCnN19465pDbaKTgASdipYbq7o5jGHwp+M6toGbH9c7kn/LZRAzERO
         YElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778369686; x=1778974486;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t6tLt4US09DyLso/mhdji9Hp8lkbi3csRWs2bmEy9sU=;
        b=kaTweNtu/JnyU4Lt4rfeJ/JhfXHsxqmuIsGR1Q5Oy0rLHUu01CDT2eISQ5y9fYhQfX
         vHF88xGqZ8N46BnBirbuKUWKBebjPjwDSzGs06jySTCiD4f33HKA5r0A4K/RSWqfZudE
         j+1wRDqyDZ2IwNNyGEScl+EgG5LGDSO8LFwSElyiBMZS4Txabpa3opmUw2MBrGN2oFco
         A3IA2TPvwNb4tDYbQ0zSUEuf4G/ANZ20w+GoPy5sbSFuO28LVwperxwvZcxm+JDS3onC
         yvIdvgxoMfvCYk5lfnkpC4mIbva1CNGaP4kalYdy4NmbNBQA15nOgbo24Z2ke2XkpVo5
         9GlQ==
X-Forwarded-Encrypted: i=1; AFNElJ+FBao18iiRtPMF/JCOWwKwG1pqzwypTDOyOwd0bKDCmklb7hynJRu8G+Lw0rwiJpSGa8okFmg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOGfzL+ZGsjRXVtHb78JZ5vhAD3mDIzcbL/hTNJPw14dbXqjVg
	Sv4iV39HoRiyFWvSqaXzRvz3Ak2OyuAewl9NDjqNyEjpC+WnwUxLHFgudhWAooQsaYc=
X-Gm-Gg: Acq92OHqeXzOxmFU7O4TZNqVNlAH8dAY/hEhW7HEAIIOsiwOUyQdt14TjQUEVVTOcsA
	49lD06n+YuHSl5R/hr5E6Grp6zGA9tY/3/knrY7335zFa2pivFhBJ0aY9/QVl/4USq53+fGuCov
	NMR2/RgJqx+tLn4AxcJ+YdnVolVNmrNYuPv+SE+4V8VE0Q9cdE4Jxz2SkOK5YPNm/mw+iKl1r7P
	Z6djxPlM7VACKukLnIj5AiTggvWrPRaE1XSOv/Q1M2iwkJ2MlA178peSSturFe4vcsf+xleW06x
	0jwxcHlG4BX3cmnujJ/fjjhGLec6IlhKv7KhnxHaPHR/Lly8ioj2zBhstYFNq5ED7ybhGCEJLEy
	kP50xIDJStNvhyaCKVmsNPhFhuCjyoNd9a3eE31gtNQqiiWIZ4J4mqAfkkx35O4bb4y9IhS4WG5
	X2j074JxqB1DRQHLKJuMOTnpQX3WLzr5ClpCRslkJ3o8IupKlFCwgnbqMtP0LttntkDU85JBsWY
	Q9ngC3ZUi22A16E
X-Received: by 2002:a05:622a:5a9b:b0:50e:6139:492b with SMTP id d75a77b69052e-51461c3620dmr247096161cf.23.1778369685834;
        Sat, 09 May 2026 16:34:45 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e7e3d90sm51028881cf.20.2026.05.09.16.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 16:34:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wLrBz-00000002ONN-38VG;
	Sat, 09 May 2026 20:34:43 -0300
Date: Sat, 9 May 2026 20:34:43 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 05/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <20260509233443.GK9285@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-6-smostafa@google.com>
 <20260501124716.GD6912@ziepe.ca>
 <afiODW2sVMeOj3Ag@google.com>
 <afoagb/wVBJD1IX+@ziepe.ca>
 <afofSPQbepd_fpom@google.com>
 <afsQTwO3eW+Ks2fe@ziepe.ca>
 <afxlufh3t3hRe4-G@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afxlufh3t3hRe4-G@google.com>

On Thu, May 07, 2026 at 10:13:13AM +0000, Mostafa Saleh wrote:
> > I was thinking more like
> > 
> > #define arm_smmu arm_pkvm_smmu
> > 
> > Before the pkvm compile of the shared code. 
> 
> Oh, so we rely on arm_pkvm_smmu and arm_smmu having the same field
> names and types?

Just for the shared code, yes.

For instance this patch would require the features field be present in
both, and then all you do is directly copy all the smmu->features
logic into the shared file and that's it.

> I don’t think that’s better for maintainability, I can look into it
> if Robin and Will are OK with that.

I think maintainability here means pkvm minimizes how much it changes
the code of the main driver.

Copying a bunch of functions into a shared .c file exactly as it is,
then compiling the shared file with some #ifdef'ery at is going to be
long term better than trying to mangle the whole thing to avoid using
any of the core types and not directly share the code, IMHO.

Like my tlbi point for instance, it is not a good idea to rip out a
little bit of the invalidation logic then open code a pkvm
version. Use the exact driver code. But to do this you need to pass an
arm_smmu through to to the pkvm specific queue management functions.

> > How does pkvm compilation work anyhow? Is it all rolled into a unique
> > link, or do you have to worry about symbol conflicts with the main
> > kernel?
> 
> All pkvm symbols are prefixed with __kvm_nvhe_ in the main kernel.

So automatically with objcopy or something like that during the build?

Jason
