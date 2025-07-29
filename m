Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F094501A
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 14:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753799363; cv=none; b=otj1lxU/U3xzV5L1ffQb4Lj2+MRcXo7WCdWP/ouMgKA0REjqIwBWrK4JljlYu2KRX04Zt6LLCuHJ+TPV3Ni/WOtIJEkGUuxXqSE8WMsV+rA6G0X7s2XQKuLEAppUXx8sdzFRrGvuKSkZ2eiM9kUYOTFZqzKvvR8hmKugP7L86u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753799363; c=relaxed/simple;
	bh=xOGcPk1h5mkQlFHPfT4qZPTUZq5yx18xGEjyCFHAQpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sztN/IALo4hZOakP7gzeot6eWUP8AOsX3i2ccyhz3SeGwmeu74lT7RmKg8dBB9/KvglwHMr+pyaUKsiS+FlpVWV8gKwAZJ4wlQqfY91x0omjKFsMoyHX/WiDYAfC+8SuA6TkSTIRLzjwSZ9zBpLQ39URe8fXh72pioFyB/v97Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=j29O4yhb; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="j29O4yhb"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7e2e3108841so682273585a.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 07:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753799359; x=1754404159; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qz67H2QziopzvIbpAdOwNF/pBaaQ95fyoFVZsRKl+KE=;
        b=j29O4yhbeeY7Xi4n2elxBnGJfos0GzSQ+ttTVYAjMCaX44hs+SeP3fNSVwTYESZ6Tu
         Ajod8lAtKoW3Zj+GMqGmUvt8HV8Pruhy+UU93RHz4n7sMiYYuOnUVaAe4fUkZiO5OMh+
         mhi1hLulaVfRrJU4OQS2I8sQtWZB8VxbHX0WX8LuFECPmmxV6t6UCgabUUV/Cso8R9CZ
         K/srzN9tfqQ0A6/UafJiREW8TSQlhg/a+ZreV2BzwqZ9wO66mCM/e+LHTBRvJWQ+XRcq
         LzQiVuNwGYhSlHYudRGSRQwdEE/wEudyPKIWgE0SdtOHHrL+Tp7yIGIeuYRzKZuMu62A
         9pdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753799359; x=1754404159;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qz67H2QziopzvIbpAdOwNF/pBaaQ95fyoFVZsRKl+KE=;
        b=gQAjY7OpuDAE+n1AX025oN0YDHAdGF+/xUwXNUwQARAB2xTmWvO7lEYVRuYkBmXitg
         meJZie/+TIjGL2yZc/1qPqSKgRBLw5xq80TSX+9T2VIX+3XP9/HfzBcC0JriivUeWW1X
         HD6faJPQdGqhPVw9AJI2av6NBgB+MWdIPEwMZ+bG4q+Xr3VaqRLRP0GkZ6eNwngeOqI5
         bSqTviSRWctf08hHKmeb+Jg6U5zisU4ofF8lzgprOu6SMcc52VKF11bjz7a0ehcIACVU
         XL/iVajH/1iah3u0h+uiuScgTX69W77secMjt5g/bx+edWdckXqoR3J7A28nCAkKa/hP
         0whw==
X-Forwarded-Encrypted: i=1; AJvYcCXPnWNWoMgOD+IzPleCAW5eU6pG+yYgPpgwqPPd5Nd2svTNY40zsL/AmaRXW25NjznyPPJBOZo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxkg7NeNQ0r4yAyTTBGniJT6S+YisjleDmkI/y/hvwGjXfkRFAM
	W4vd/wQS9TCnIzN1ybacg3P9Ro2Eutc4VTV9EG2jDX0/rbrBnV6QiydjgYICI+LtE7k=
X-Gm-Gg: ASbGncspXQ3BL3o3uaI3RpR3dnUGr7sSmVQQfN/YWAw+ECCYB1BoOcrEKjhSOtfGC1K
	1RgFYX3CeqoaC1hJthPXnTn2QKZSxJjfqzvmf1dExPc3UaTs3q4PTMM8cUoo3eXg8ep3DyE+Iv2
	EqjfmMARWdPiis+YXdayiZpfFW/OpBUceRc/6IDBqskYQK62LmVDXsv/TDZU0B3Y2ra7AkzcgcI
	3tTjtuYc+63N/9aZCKwhEhLJeKeJ02uephieIotjLvpAeVKUdACi5/hgJbfiFBxS6nf6E4HH/4K
	X/9ybW/71tMvnTlvpJnSA54P3PjAF6Dd5mBXjFXnuAZFs7+juxW9vzshafWxoY8Y2MxXGFbKllH
	ZZ6bwmNsHmOMXE+GVN+jXIs6gQhz2R/De6f/ytiVLPgPts8/mO6hpuXnhrt9aHR9ginD3
X-Google-Smtp-Source: AGHT+IHYkw6eFpxfaIRVF1srsJ9FJ19UlQqBR6yhpID34uYqJijJ/A3tTeVFt7I+4cQKncFmezcccg==
X-Received: by 2002:a05:620a:8386:b0:7e6:65ce:2bb5 with SMTP id af79cd13be357-7e665ce2c46mr224992185a.47.1753799358715;
        Tue, 29 Jul 2025 07:29:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e643897b24sm431209085a.75.2025.07.29.07.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 07:29:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uglKP-00000000JGf-22cn;
	Tue, 29 Jul 2025 11:29:17 -0300
Date: Tue, 29 Jul 2025 11:29:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 06/38] iommufd: Add and option to request for bar
 mapping with IORESOURCE_EXCLUSIVE
Message-ID: <20250729142917.GF26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-7-aneesh.kumar@kernel.org>
 <20250728140841.GA26511@ziepe.ca>
 <yq5a34afbdtl.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5a34afbdtl.fsf@kernel.org>

On Tue, Jul 29, 2025 at 01:58:54PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Mon, Jul 28, 2025 at 07:21:43PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> >
> > Why would we need this?
> >
> > I can sort of understand why Intel would need it due to their issues
> > with MCE, but ARM shouldn't care either way, should it?
> >
> > But also why is it an iommufd option? That doesn't seem right..
> >
> > Jason
> 
> This is based on our previous discussion https://lore.kernel.org/all/20250606120919.GH19710@nvidia.com

I suggested a global option, this is a per-device option, and that
especially seems wrong for iommufd. If it is per-device that is vfio,
if it is global then vfio can pick it up during the early phases of
opening the device.

> IIUC, we intend to request the resource in exclusive mode for secure
> guests—regardless of whether the platform is Intel or ARM. Could you
> help clarify the MCE issue observed on Intel platforms in this context?

As I understand it Intel MCEs if the non-secure side ever reads from
secure'd address space. So there is alot of emphasis there to ensure
there are no CPU mappings.

Jason
