Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C95063CB
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760110255; cv=none; b=HW8rWaasPfXS5qVGObIhEo8xuj9oMgFS2rlcXqVhPU0/0mfow5SPy0MhtB6DsUygdoBrNAfv8chrtTsWYqdJiLLF8AYgo5SqzCwJs4nVAu5BtsJH9TuQAJOF3FgbjD7Hk8CMbrBeZdGu+Uia6l0wPzQNRlyO2KxtAU1240W77gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760110255; c=relaxed/simple;
	bh=YweDjybfnRXAUjAFM2cXyTvz7RwWQP0buSdnlIEIdyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kb8MeS9gpFSLczs/g9NnIsZnrNbsO4nyWv6HyBhhnaD9yNHRkwlehIQ+gg82vJibtAJuGauG1rMLS01e/gz/HraFmyNI33K/TKn8stgS3TFKWx2iLyQAatAzjb/LiHnxWVFZ7O43l1bgHVUqIMgBLb5oTI+RixGn4+HnDX4FeXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=j5ntdxnZ; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="j5ntdxnZ"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-78eba712e89so21160316d6.3
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 08:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1760110253; x=1760715053; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e6cOfIK7qdN8qKLRMhM71lR4Nf+xbZ2+eVm4l2+34ic=;
        b=j5ntdxnZhwokfZ7GwQ0MXIZII8RpMEFYoa7cclFhZ5HVEjQFU9n5rgZcBMYIRObngp
         SYTBfSBPZwyvW4lAWNZhP/yX+4TZn+7n77Y3ybNMQpFOtRXQj/j8ce8cp7ol/5knmGMx
         Sagg44BeajqF1urzk10YTae1mcUW/O46Ji4iavgZcUU5/0i45tZUX6van5LlzP/hi+ii
         wHp3N3MDVoE1Ln43uRwvAXAQtUiVOZZeOjGPVI2oq83AvXmYxZ6i4+9AWRREyznNZbii
         vE5ODABc3ynS/4nNIfJs4A9gUFNVMVnKRcNQq2u7BGgzM4u378DtLMpWvAaEicnjgnEq
         3pyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760110253; x=1760715053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e6cOfIK7qdN8qKLRMhM71lR4Nf+xbZ2+eVm4l2+34ic=;
        b=fSo+sigg9lxL73FXa07S2lk6f7D8OXlnEuW+sfB0JFmpzMN5g1ozkt84MtM6620fjs
         lfd8ocifDUA5SAAixlYKUUORvGU2LzQT0bEuDXb6v1tip1ZGSdWA+aNFThxxZ9FC+GHe
         fvWw7vOMy7U/BMG2qswGKqRTcqowQyiSaoHGa2DScbg9P1h9l1nidM9IT/ATRBfPyGUe
         SiU/RXpeFXGUGp1CELjpYt/Fh01jNvch80349gJULQGJl4B8Pu2oqtryStl2iVFwEb6Q
         HOtEBTXBiS/vxOUNnTzcBeppKeXZ79z2An364CiwIK+P539YVz3cS9bI9/IiuDnwYhy7
         ZXHg==
X-Forwarded-Encrypted: i=1; AJvYcCXenVRsZjQL0D/sHoIMTRhLlVlmECunmzUeZigBZ4Cm1MD73o82YMllEbhJxlp2tJvPZnyM01I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7k7EFwg/sHG+Q+o4QhDi8V6GUgznEp0gPsnVj2bNH/+wab1JT
	zTLCKpR4gkA8jy9ZPvRH9+eEaXW0WvyjjrAoKmYB+k47Gf4sewm+O/PF9SxUz1efY40=
X-Gm-Gg: ASbGncsn19wrr9sYygMQJlcZPrT2inlZdpvGNuRriMqr2OU8dq6CaJsiW7BFiDS/5fq
	Bw6uuCASf5JF2rldV8JC6uWzBG7BU2vyBRhneDgqZWacNd/iAWQdzSrdS2NFbElVy6zoY80k2+c
	z1pngrKkZRyb8tGpBaPsTaCd+p/nlZI/o5E6SH9Op07VWDUGqLIROkjaU4kjWdLtb7mj6+EFkIJ
	2x0kx6PK4MqSuY58uRUB1K2m7yi7H0Qtmbb7oSWpndllPG+0hQVzCNMQHrRfkmLOcFyhozkKoMe
	ytMClxe2dugDfsPpPyBZVN75l58U3hsJynb8Acyrxba98Ln0qdBLubFH58JMXtNn3OVUC+Uc3BY
	ONgR3wV9RAX10Yd36um/VuiQJMN5tB2TTmEV3+YwIu+T6EYI/OPgaaiSt/5of7xg81ilJRJu0Qe
	8uwSLp8cdkwA8=
X-Google-Smtp-Source: AGHT+IGgKhRm3oNF4ALMXNjdHTaNK2zfI9rzl46bTecy6J4CNJ6lSFvDvqcPlarS77J3/CcjSy9rWQ==
X-Received: by 2002:a05:6214:c64:b0:830:5c6d:419 with SMTP id 6a1803df08f44-87b210728c4mr182061246d6.4.1760110247638;
        Fri, 10 Oct 2025 08:30:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87bc3570c1esm18187826d6.40.2025.10.10.08.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 08:30:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v7F4w-0000000GWAu-2XWh;
	Fri, 10 Oct 2025 12:30:46 -0300
Date: Fri, 10 Oct 2025 12:30:46 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jeremy Linton <jeremy.linton@arm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, aik@amd.com, lukas@wunner.de,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 11/38] KVM: arm64: CCA: register host tsm platform
 device
Message-ID: <20251010153046.GF3833649@ziepe.ca>
References: <20250728135216.48084-12-aneesh.kumar@kernel.org>
 <20250729181045.0000100b@huawei.com>
 <20250729231948.GJ26511@ziepe.ca>
 <yq5aqzxy9ij1.fsf@kernel.org>
 <20250730113827.000032b8@huawei.com>
 <20250730132333.00006fbf@huawei.com>
 <2025073035-bulginess-rematch-b92e@gregkh>
 <b3ec55da-822a-4098-b030-4d76825f358e@arm.com>
 <20251010135922.GC3833649@ziepe.ca>
 <4a7d84b2-2ec4-4773-a2d5-7b63d5c683cf@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a7d84b2-2ec4-4773-a2d5-7b63d5c683cf@arm.com>

On Fri, Oct 10, 2025 at 10:28:36AM -0500, Jeremy Linton wrote:

> > So you could use auxiliary_device, you'd consider SMC itself to be the
> > shared HW block and all the auxiliary drivers are per-subsystem
> > aspects of that shared SMC interface. It is not a terrible fit for
> > what it was intended for at least.
> 
> Turns out that changing any of this, will at the moment break systemd's
> confidential vm detection, because they wanted the earliest indicator the
> guest was capable and that turned out to be this platform device.

Having systemd detect a software created platform device sounds
compltely crazy, don't do that. Make a proper sysfs uapi for such a
general idea please.

Jason
