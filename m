Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD0A450FE
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 12:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753964264; cv=none; b=lpqAdKdD//TU8ndFUsnLGIjNnkzmHDVSvhJqyfjN+YipHEhhvajyeDj7Fq5qUWrcvHikZd3ls7dHqx9lc8xilS3DPzUFZnJxFv21BmHiBqv6eOxI9Zx61d74sTl4797yZKxGOZmncrKIUwJM0nM1Gv+oPQrjCN5gKOENrFyAXds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753964264; c=relaxed/simple;
	bh=lgkxQThTtfZZSUnIFCf5fUKUIMl2aWvIb0b/yw6y6ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBaIs0DQx7yEPD/TQ2JKVmbao2Wq/j7ghRaBugjtanx9vgmqWBw5sJlmYhV/aHO5I1awxAvsA4WnDOmnQI5NIuncHunxzT4z1xAU0Lat/b9SkX57IvoT/2pMpGBfe2+IjkiLwllmFhTqDaGZLh4UPskdHiTFmFQAkN+7UoV4il4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=MjG5gOpT; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="MjG5gOpT"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-70740598a9dso7869516d6.0
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 05:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753964262; x=1754569062; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=32tD2N96Q6MQNin9/Lb0EqTq3IigVZXvJ6wxZCRCR/8=;
        b=MjG5gOpT4SRlEM61/VU0hWwPJAbGzByA0H8AdvAXCSn/TjEhKJPQ+YpKO0B6M2a+FS
         xU/LMPVkrmD620GT2a2BRJnPnXNXF5EayWqKG4bzyr5qqKj+I0yht0g5TRJL2S3clt1/
         eGLKYQ0iR98JJlrKf3VSzC1b348sVtdBwqeucZtbdjB8jJV1xr0g4LEdYBva6udl4Stp
         xw0OGjgcHOICqx3AzXJOJ1TBLI365KDrqTAsiI2SZCnsyUwqWdXYtPKZVThbbx2Zp5gL
         BiSQnRT/3iTCzIt1yRORXJMIaYYO912AGBULJGFyRkes/pIwPgMeft9j/zlkqVpt1J+G
         RL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964262; x=1754569062;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32tD2N96Q6MQNin9/Lb0EqTq3IigVZXvJ6wxZCRCR/8=;
        b=IEy9AqElNWyaryK0oNlK1woriyxXqFAytyeWcsNny8S4xWDOGNrEGzgc9NjBEnDXkt
         SNig1IV/aP9brPWDjxITHXbwfgpUC4/K0o6yd8pt/KPYIlnkb6JAk4YKS+21fiMuXxu/
         eptAPPZo/m0B5bTCeoXLstHMD2lUd2he18OlHwhvswqQleOsC7GBU9jTVHxsVvSMm+n8
         BCHF0UZXHI4uiBvvKsmvcoUY8uMgM3iHgyWdF+lUJOBudVTeSd+Ld7o1cx8jIFQhabow
         IFB0Re8bDKxIYYZSZ6mD7zOBc22jsJa93bqPn/zu52K45ESKsUrOkS89q5uzRtotpNoG
         J7ag==
X-Forwarded-Encrypted: i=1; AJvYcCVyoLhcuyzk8ZS/uQejX6BK2E+RXciGma+fvfmX3iEJ/pnXAdyfwdC56i3eTUdgl05NHA1Vl2k=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWReWcMLq9R7CDh5fN01VVw0QI+s9nDSDAee66VBvDg8E5klM6
	fQWDov4kqQJNxyLjb5jadsuhJoekjar3u5xfB/FMcGINAWgBs1qNIL5McKujwwrS8HI=
X-Gm-Gg: ASbGncuuX4f5PhRLtg5X923hf8QcxyWNgwtOkMfVEdjYMQM3YXXqEN8uZMzQiObd2Aa
	iEgUKZMRJZNi3OZhaVl0yA2d/oFDb8eL/JHUf9rXV8FQ0MAaRDcrp8vRKgi8uKbB16MMV6WdTOe
	Tm8D4jMSWBX7nk3jxWPa5urrzuOV3IGAwrR8E1zZm+gknkpDYm9AVJghb1hYzYA1MzkyhMv1gtE
	aBTxE36MeGruuGzv9Yb69HSCW48LadeV7tmiPBRO61Dk3RKd6IQ8hjD5QIpzzo1dQFIm+clb3pb
	AJVmtdOIQnKiJcc4jva1DVJfi7YIiMnVE2ElWebutWShzXgyIyQS136h7vXBI7AWX0eEH+1Dqj8
	Cb4nWap9izf2377VMam3zl1rlC5Hh9YF1pIqt86Qh2/911LyYFqptl22VKQ1gzEP2FeAq
X-Google-Smtp-Source: AGHT+IGlDd7T/UCTYlC3jJ27LG/kD/8HSLFnnlHhhhTVJjke6DkBwfMlPtU4g+DEqonThAsKUvPm4g==
X-Received: by 2002:a05:6214:c62:b0:707:62c5:9768 with SMTP id 6a1803df08f44-707670aa577mr86346366d6.26.1753964261687;
        Thu, 31 Jul 2025 05:17:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ca58d36sm6577016d6.38.2025.07.31.05.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:17:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhSE8-00000000oWW-2X84;
	Thu, 31 Jul 2025 09:17:40 -0300
Date: Thu, 31 Jul 2025 09:17:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 04/38] tsm: Support DMA Allocation from private
 memory
Message-ID: <20250731121740.GQ26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-5-aneesh.kumar@kernel.org>
 <20250728143318.GD26511@ziepe.ca>
 <yq5a5xfbbe35.fsf@kernel.org>
 <20250729143339.GH26511@ziepe.ca>
 <bbe2a41a-8f72-4224-a0bc-225c1e35a180@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbe2a41a-8f72-4224-a0bc-225c1e35a180@arm.com>

On Wed, Jul 30, 2025 at 11:09:35AM +0100, Suzuki K Poulose wrote:
> > > It is unclear whether devices would need to perform DMA to shared
> > > (unencrypted) memory while operating in this mode, as TLPs with T=1
> > > are generally expected to target private memory.
> > 
> > PCI SIG supports it, kernel should support it.
> 
> ACK. On Arm CCA, the device can access shared IPA, with T=1 transaction
> as long as the mapping is active in the Stage2 managed by RMM.

Right, I expect that the T=0 SMMU S2 translation is a perfect subset of
the T=1 S2 rmm translation. At most pages that are not available to
T=0 should be removed when making the subset.

I'm not sure what the plan is here on ARM though, do you expect to
pre-load the entire T=0 SMMU S2 with the shared IPA aliases and rely
on the GPT for protection or will the hypervisor dynamically change
the T=0 SMMU S2 after each shared/private change? Same question for
the RMM S2?

The first option sounds fairly appealing, IMHO

> Rather than mapping the entire memory from the host, it would be ideal
> if the Coco vms have some sort of a callback to "make sure the DMA
> wouldn't fault for a device". 

Isn't that a different topic? For right now we expect that all pages
are pinned and loaded into both S2s. Upon any private/shared
conversion the pages should be reloaded into the appropriate S2s if
required. The VM never needs to tell the hypervisor that it wants to
do DMA.

There are all sorts of options here to relax this but exploring them
it an entirely different project that CCA, IMHO.

Jason
