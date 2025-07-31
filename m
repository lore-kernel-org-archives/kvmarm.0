Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E43C1D86FB
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 16:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753980379; cv=none; b=i8H73BI1jGkmbUbcK9Q46R2PfnRRfNncyumWwV9mbzZ1rBltx5u0p/yWwgHMAhLgWuGgZM/llFXQ0Z4C/BikOtav5fN6GCOQE2OQgSLRc9WI1II0qZ2U885mTvehrcF4le5duSOwIyDR440qODOLwcc4wN2BeLAVmzylpUPiMAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753980379; c=relaxed/simple;
	bh=+FrCI5uL2Giy/28rG23V4GontptDjw0pDWs+MPinD0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eeS/tsvbAEiK6yM7voHyiW6VAwG+OFlV6TNXa/AyC3X6VcaSQ01xyAaA/hPakHdWJKTVXFpehZstPdLTmyOknbdD1/Gnbhcf48aIHs5GFN9TvvcZPE7WlgBjoRAVVzdj1cbocSiz4cc1woCxIZ74ysRNK65e4N2XN1gryTsR4J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TY0htxM8; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TY0htxM8"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-30008553e7eso670802fac.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 09:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753980376; x=1754585176; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TVWJZKfyKQDHRhqzJs/Kg9r++4Vk+GwOwj6f2ybO59E=;
        b=TY0htxM8eBasa1RYXIGzgijpH63NCB8Aiuz4Gr3Hc/HuSshvXyVSS5IzGtnteQ+yK7
         tH3ofLczqjlaxyzh2egVNY5TOgCJTLynpUfevjvW/FS3hJxJ5bBz0CrnZDlxP4TklZVm
         M5+9KkKJe4GDhiJo9vl37id/U6NhP20P7j17KJwrU8XOHz5A8BB4t1ymAn5uVtUzKYkG
         mMi1UWuGR3M131ic3414Qi8/dUYVTDDa0QMCMGzpkfIK2JGv9HjdoyfO6g48fvTNhF8c
         qYzAEmU+CDLmZf/S8I/BUcxVfi08gYuG8G9aVazvmXeEuLpOYHw5DAxOJRLwjsUEF6Yu
         lfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753980376; x=1754585176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVWJZKfyKQDHRhqzJs/Kg9r++4Vk+GwOwj6f2ybO59E=;
        b=c7Y4ltROneu+938nCO+VnH+2uN//DS32C5nTM4Hh/Ea5Yz0W3iDDregJKuIhxkoxNc
         zTmut7SvZ5Vpad++TdVGlzeYt1sO9XqDGqt3mDzoDbJd1Y/1ndG+0NN0px4X5dDDde22
         vN4zMaGjUuk6XxYXXiB0+NrDXsxSf++9ADv6CGyRNVmnXRz+yL0VtA58msnL4ZJ2mvUP
         NMJIRSHGeMJ6jq3NMiRsTjAJ0GsFT3YjvGOGPF+0wMZNyC2VgnY3EQRvEYq0iweTrP7f
         Z7Sm0lit4ckafDusHhih3tB0jwhZQcDwP5o39qMClIdLOrzNqi5a9pnez0VNpd+VofbY
         Tc2A==
X-Forwarded-Encrypted: i=1; AJvYcCW435kp0g6mts1B7TrHxT5mqt6CzmN+r1mPD2yFRTchgkP03+AU54kzDISBaAXfKHwTWZF0a/Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yze7hp173DXA4Hh/lnt7GIxCWdP4JY3O8pOKhavlL/CAPzOg6B7
	My4syFAik3kRSHp+UCmyodRkbg4kQqIghW5P46iGhiMhg2yQ8J8X0ICoDvE4tiXcKU5rN/XuET0
	RrZv2
X-Gm-Gg: ASbGncszMo4idl370B1xY6wp2F2yn2MXW1okTbpHPHwdIa1hpsu5Iot+YM6xtGstoSd
	4hfen0Are5K7OGgcY8nyCRWVVmKfok5aYEPpqeyDslV3eVGwOp0/OQ/9qm624xKNyeYEwXQzAF2
	lXzgI4cnj2GrsQPet+QBauBmI0YCrjEJ1kdVuj9bR0GkSABdhCwrKUvHf4EIAeEPGcDDJIerr3u
	9xudhTliqWcv79IJLl1P9Vop0Rrv16N/liPIoqwbxHxVRLWxnrmF3uWea3RYte8NhJKLU2eB0uS
	aj6f2i6JM3pSOtQTqfPLdKOwTSeG9aw8DuHjUBl4FQacoy6YkKbDXJvml/E60MW8QiV64Cgy6OT
	8sESJKNgD84uMjW5/v4T4NMcRmBxCSifTjhRy5+CSQXKMHWbwEjwqVznjQIHLAsp4Qp4Q
X-Google-Smtp-Source: AGHT+IEpTxrw+qyeAY5Lp6kRk/WUmkLbgGvbTXBtHkfN647e6IUlWw+YixxIUWu/5H4+fgQL7IJOaQ==
X-Received: by 2002:a05:620a:430b:b0:7e6:43ae:930e with SMTP id af79cd13be357-7e66f3edca2mr1175700385a.61.1753980364295;
        Thu, 31 Jul 2025 09:46:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f70659asm104688085a.52.2025.07.31.09.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 09:46:03 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhWPr-00000000qBd-1OwT;
	Thu, 31 Jul 2025 13:46:03 -0300
Date: Thu, 31 Jul 2025 13:46:03 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, aik@amd.com, lukas@wunner.de,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, gregkh@linuxfoundation.org
Subject: Re: [RFC PATCH v1 11/38] KVM: arm64: CCA: register host tsm platform
 device
Message-ID: <20250731164603.GX26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-12-aneesh.kumar@kernel.org>
 <20250729181045.0000100b@huawei.com>
 <20250729231948.GJ26511@ziepe.ca>
 <yq5aqzxy9ij1.fsf@kernel.org>
 <20250730113827.000032b8@huawei.com>
 <20250731121133.GP26511@ziepe.ca>
 <20250731142250.00005651@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731142250.00005651@huawei.com>

On Thu, Jul 31, 2025 at 02:22:50PM +0100, Jonathan Cameron wrote:

> If you mean create a class device with no parent, that's also something
> we are slowly trying to fix.  Reminds me that fixing up more perf devices
> is still on my todo list.

IIRC if you create a class device with no parent it gets placed on the
virtual bus...

Do you mean we should not do that?

> Should be a child of something, so maybe that is a good reason for a
> faux_device here if there is nothing else to use.

Don't see such a big difference to have it be the child of a faux
device on the faux bus than to just be directly on the virtual bus?

Jason
