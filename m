Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119882C1597
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 12:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753964780; cv=none; b=HGFRjsy1fOQvGAorKUZa5ObhmpMChV1uaM00NOr2q4/UrHJqngr6UEZK2MyA8BVwTJ2QNbgUC6dABcs+fw+dtqG0xbcV30aHzzqSHMplsYZWduUIimSMj0Nu3mQGgOZsya7X1s7eSjjD22gsnUw3Yl6P8pPMRAXvKbhH/eL4zvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753964780; c=relaxed/simple;
	bh=DdxvPDAw0mc8/2mcJ0LEU5pxZezLf4CuYkBruMEyp5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCa1fsAiYRe+FquCL/ei34CLOPOdJuYUjjtmJMt0s0fqv+3bo3M4XITYmoP3Muj0MC7mpuIeH9ptNwusvpvYh3HnrM67By9jAIvkeOMpNoWWIPD2z+qDpQ4CRhtI1vilWIihml9NUFOKexTSm4psvQOMkpgF2QBhJph/0kZyd1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=S9L7n6f5; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="S9L7n6f5"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-7074bad055eso6062106d6.3
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 05:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753964778; x=1754569578; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I0UTzXjMbQLF812F/cBlHHlhQP11knn9ieRgsIR0U4g=;
        b=S9L7n6f5b0/tV3P4RP0FvUgqkvYgy7Ueo5sIzUMnmujFP/nx3j75UC300LxemBs9+n
         X8ANeNCNI+v6r1Xr4ycYh5D+R3/z+YgnSx4PnuSRtGzlZUynReFeqj1jyThxT4DZgele
         AxS2Z25Gb9Zw6fw6V/YyYcFMSU/Kjg3MrKfR4sK40TegfM7nrHTZQZj0NO7vrK5JTrgI
         TD40yBM20SYBuzRh4IG7QowTR5JoGIj+Upyb4MZouFsXBmbVTb81QjJq2pU0XdgHfFev
         AuACU0G5v4WlWq3sRpoUiSVh03d92R+mfdtmbSykboxYT5l4ekGmHi7QVP+JYofHK9mP
         NEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964778; x=1754569578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I0UTzXjMbQLF812F/cBlHHlhQP11knn9ieRgsIR0U4g=;
        b=XjMHZopDIdtpE7jJUuzHf+2wDmtLr/j4LRVgYPPj7sFgJQ+NN7eeKvxu943K5yLeSg
         XYlh978c5lqyMDA8owbV1K6BBS0Qqapv2KGhg8MpjO3A/I4Yyxt0a6l+ck4G/tXa0M3o
         XSQSabECTWUD02kpGYec8Eb+i4V8MG1tVfhZ2VsDVhgAA3PiAfmfB9EkeFtnkxBxfjTU
         PouZoe6KDghmAmwsf5KMWvCdEe3q1NdIA9QLaWhep86NFqYAcXh99XJ75/tntpuFkYec
         t2AZJhLWIwytDCE0nQs5b4CIfZhvTUMC4PaFbH2MyMezloS3B0aeIi2QI1uIiy9iyxP5
         iklQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFjJ1LBRxXnQbeuhycwRHehdAHaqCpr6Z5fK8ahcthe3joaMEy7zpfSgR6BKsfsxp7Q36daSU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmYZ4/PNUlA/InfqmBLH50ph6e0aZ/zfDG0dUt1+/B1omLssz1
	FXavtyc4Y/70WXud9bB1krseBs4VehnSpLuhkNfnH0Yzq81OpVKt4CZ8eBUhtS8wKYk=
X-Gm-Gg: ASbGncvXoMkLLSvDgQaEyDtw8/u89SjPXHnUvCNREBGG8jBlVcJi7SPtehR16nSWIRw
	nVXSiBEr7BFiAS73GS6HPH1XCS087/MuTAazOZwgh/SUY9KL5bGQ4QYBzfisjfcJgwLoZCQMSKe
	YN3o4fG7W1vGaHKU2LXvgzibxY1ufN5gsMLn+gXjZcgaqWn+qIFvsc5pBnau4A7jzVUxsDv0zOt
	S9fnj+hSaPuytEZrNyPCLk7B50oMtcQPAW6hkDWvlNLc7VNytRzD+tYUsQDae1xLdgNZrB6itF8
	A8cjmAd4RBl04vs/2+FFbK5t8PGAAZMKLbWQsxuOHXMuf3a7q8MGDnIoAjmjRxFjyR1ovbNuWC1
	FkFO3DyzI1UhQg5iX5rhX0e27E6tTjGG8pSvTQ+m19yo7BP4Jr/NJmIyHOO+YlvQBEWvb
X-Google-Smtp-Source: AGHT+IEV8Gmvc00o50P6OQKANpqFcknIb1Fql8SzhfROvZ160cWgmtvbR5AnJBSI+9ww0K1Z9AZwLQ==
X-Received: by 2002:a05:6214:21e4:b0:707:4daf:62d with SMTP id 6a1803df08f44-70766f89168mr126988486d6.21.1753964777814;
        Thu, 31 Jul 2025 05:26:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c9da870sm6583536d6.1.2025.07.31.05.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:26:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhSMS-00000000oZ9-3Vfz;
	Thu, 31 Jul 2025 09:26:16 -0300
Date: Thu, 31 Jul 2025 09:26:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 12/38] coco: host: arm64: CCA host platform device
 driver
Message-ID: <20250731122616.GS26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-13-aneesh.kumar@kernel.org>
 <20250729182244.00002f4f@huawei.com>
 <20250729232243.GK26511@ziepe.ca>
 <20250730112804.00002629@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730112804.00002629@huawei.com>

On Wed, Jul 30, 2025 at 11:28:04AM +0100, Jonathan Cameron wrote:
> > devm is useful to solve complex things, these trivial things should be
> > done normally..
> 
> Sure, that would be fine for now.  If we end up with a large complex flow that
> happens to have a tsm_register() in amongst various managed resources
> we can revisit.  If they all end up looking like this then a manual call
> in remove is fine.

IMHO just don't use devm, it is so easy to use devm wrong and get out
of order clean up. It works well for extremely simple case where 100%
of cleanup is in devm (but then it is questionable if the overhead is
worthwehile), and it is necessary for extremely hard cases where
writing a manual unwind is too hard. But the middle ground it tends to
just make ordering bugs and not provide alot of value, IMHO.

Jason
