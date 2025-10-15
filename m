Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911F6337685
	for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546103; cv=none; b=Kz7bnVmO7bgBlcrXbzjdFvKstpI0f2LGOGb8HhVxHFxOPUGTzQic8tjGXB3ssogUPVtYRt5na8cwJsGcb0frtjQT1P2iFijaO/NtIdIuilCbJa5nCp/7Xq4SdBNaN4P9mIlmkyfa9pS40bRYYZwhaNGyuRRvpAPjfk3QwRjdU+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546103; c=relaxed/simple;
	bh=L5tvi7+IQDs+VRJpw8WX5BI2YljAtn95hgbTZZTzOw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WG3N8YziR4hs6g0D5OhqCwi6eAv3ZT/E1HmVBHo4woFFtavlSkbZq2nNMKFgk2pC/FUdg18LH4fqjnF0OYWXDLnccZ8yiBVuMjfWPAN6omnGhGxlKDf0fHWkpoDiSXXrncq5Kn5T8bYRoRZ354ODiX4PHeWAmmw2doWMy2A95jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VeTVG+qU; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VeTVG+qU"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c12ddebffdso557603a34.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 09:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1760546100; x=1761150900; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wCDXpcrAleflJDj99gPUKdddGhphTvnCdBCeqIcXopk=;
        b=VeTVG+qUNtOQ6QY/Xx/Xh/CSi339DGb0T4SyH9QObnyo7cruNzXNI91PueDOu3Qhkq
         bbVsflKaCpC2e47s3dNE5iguzsYSV3HXrWXAedG1CeBusAb4hzRaWAQzYnpIoC1GdxaQ
         b7FymKMgmn/mCbaF/PIc01VdGNq68Tx6gglu5aw6TtbtPnyVX4I2EGm7SSyKCHEMGgFt
         6bdDuJf4DyGOzHZNZ8OvVoY/fg6WYKRjijjEzkzEbprhIC3Yo4jmk3yPywN6LbyYmOpr
         LnYgbWaIJ0jslfNSRvLtgIlRHwXOEM/KYy3XnlhDrUw9myjpvAd1wIUxwOS7malLNrcD
         mkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760546100; x=1761150900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCDXpcrAleflJDj99gPUKdddGhphTvnCdBCeqIcXopk=;
        b=o/eAkPH9PR3x1qqAEWCn7ia6VANCw5XSDGpXampzwLmPbP8qT+6tziPOyYxXL1wNNk
         MA20Yf93LpKoSPCIqDczX8kA+NOlwJQvqeY1RDzGhVr52QNldGI44u3V86sNkHIpPd+n
         oZBvbnBwzq1D9VyTDneUm83hTQ2ySX4F8N2/PLgs0kFTuUpl1AZfZPu/rN0+M9vKwAkS
         nZkBdU0/Gv59MpYwBMmD+JCcUZRnnYt+4Cd18IMkaJejVZ9daJ6OEw1POxGMOjstUdMJ
         miLL8hM53tuZcwD9klb/CBQgvHraD5rynk59vwPhylo6SF1CEVHDAymn4YR0DzjYNnta
         cDag==
X-Forwarded-Encrypted: i=1; AJvYcCWtVnUQIYjqhtG4ZD6qg0S7HYHFbIf/srV4sWjirNItnKOk8/OYvamGOaVkAz7TG3AO+y/SJ4Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzA5dBnO2SmccZWNa5Lmr0WIr6eaA8X9wVjucVgkf+7Z8Hx3okx
	gjI678gIXr33sQs8JiJDE9rg2FCus/JyQvFgZLXT5sUJeAgEH57taiUkX8NaaCc1ZlU=
X-Gm-Gg: ASbGnctM9Ze1HrT0FRTi0D5393H3CmmBhcWp+YXHfgeAdaRkcP4S6m1PRyoSv2F0v1O
	t6yDqFSVyrBJhgiXJWf2aOBMgAldq58LbtGSggDfZWdV200uAfTZjA4UG1v6kj8EXbUf4nRQI/D
	SwLJiD7h8K9VB6tbIj4AuP40nFGyoV118Rvir72dowu3SZjoVm7qgkaWwMpddoM4EPqavbJ0dgM
	C0ekgZgJQ9HX0HGaogNIq70UVxWPFxfqfTnB9wbLaybk7BrmhrqMI+Rzrf4w1BiBAseReYvtHrb
	prrFmjbLh5gO2v438YqQMxLTOStVFPwx2x2mPkx9u3sTLbvAbN2vis9JSm/vVbVP8UFjd4fUFAO
	yYeaC1q6KMGdZp2MelnHEmhhZdw==
X-Google-Smtp-Source: AGHT+IEoFlFxHVOg3TlsEA/EV9K2+7van7rs1mfIHJz6ue9Awll3yFhXypIbfuEYnE5GhO0NQgK8cQ==
X-Received: by 2002:a05:6808:4f14:b0:43f:75f0:3881 with SMTP id 5614622812f47-4417b38b780mr11335099b6e.31.1760546100574;
        Wed, 15 Oct 2025 09:35:00 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65031fb8ac8sm2365203eaf.20.2025.10.15.09.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 09:35:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v94So-0000000HS5J-2mCC;
	Wed, 15 Oct 2025 13:34:58 -0300
Date: Wed, 15 Oct 2025 13:34:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
Message-ID: <20251015163458.GI3938986@ziepe.ca>
References: <yq5aqzxy9ij1.fsf@kernel.org>
 <20250730113827.000032b8@huawei.com>
 <20250730132333.00006fbf@huawei.com>
 <2025073035-bulginess-rematch-b92e@gregkh>
 <b3ec55da-822a-4098-b030-4d76825f358e@arm.com>
 <20251010135922.GC3833649@ziepe.ca>
 <yq5a347kmqzn.fsf@kernel.org>
 <2025101523-evil-dole-66a3@gregkh>
 <20251015115044.GE3938986@ziepe.ca>
 <d5144c99d7c04e4ad09ed9965fa3512c203b5694.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5144c99d7c04e4ad09ed9965fa3512c203b5694.camel@HansenPartnership.com>

On Wed, Oct 15, 2025 at 11:19:41AM -0400, James Bottomley wrote:
> This came up for the SVSM as well: we want to expose things that can be
> virtual devices or other resources that the guest discovers.  Our
> conclusion was we either needed to share one of the virtual busses
> (like virtio) or do our own svsm bus.  The agreement was to implement
> our own bus, but we still haven't got around to it.

I think your own bus only makes sense if there is a structured
general discovery mechanism that can be used to automatically
enumerate the devices to create.

If you are open coding all the discovery via C tests in Linux then aux
bus is probably appropriate..

Jason
