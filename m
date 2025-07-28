Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6738926D4FB
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753712226; cv=none; b=ZW0HQUlQkMZ7RUlCBGWChKa4nu6IMVjnkRDIjPXAh+81ZcwurCZYpqpJLjUARsM47KL52kF17R4PpIybNUTVANa5iaRnUtED6IEMRXhFd7RxJY67NwgcdZa7XrIj/zl+HZ2YzFEB6mxhOdeqI8zDKigoH7iYwMywDenjbUwUcUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753712226; c=relaxed/simple;
	bh=+sQ9t0gn5L4GrZDYwNd4uW4hApI7Q8x2B8KZ36bnLW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqFtcpH6K+H/SRQ+fVeqRfBSk/MCHsfqKkgcNPi676A3WYtiB5dv1Tcau4rAhkQCDhdoxdLtwR8ZkJzMYZ8NA+sWFLDATSmgRvbVSHhmP6DKpzMNGw7EJG8ywdelUaK5F8Zj6LlPCV/jA5+JS2F/H2oj4AvS/pVg513OuCSvO/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=dL+HajTc; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dL+HajTc"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab71ac933eso40336221cf.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 07:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753712223; x=1754317023; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+sQ9t0gn5L4GrZDYwNd4uW4hApI7Q8x2B8KZ36bnLW8=;
        b=dL+HajTcPYW298bIf5D+tIQ0MNl8GCIrMNgW6Z+VnHsfd6YFV9HR5/hUfGonXZPhmn
         gJjlXaegXxNv5IPiU/me3fjaifRO4FUFp8Xex21vGGR1QRHbrUnJLN3WjoMLZ0rSFOLZ
         gjJjC6MFOmM9uWzXCkvhZPXGCGL8V81+hnocoGHmBJ20kSdBpbLrKzVrzPtGzZUllVjO
         SEluEJzE9tLXfu9807ngz7xaSHa0T7DbHHR4CM6os6+Jh4PR+ffnXGNf5mDL4gBeAZAF
         b8PZVegG0ACt5MMaGSettRiHxD2C/o6dUjuTCoF7cT5HNBEHYCqzmY7eNduYBO33jb9i
         I57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753712223; x=1754317023;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+sQ9t0gn5L4GrZDYwNd4uW4hApI7Q8x2B8KZ36bnLW8=;
        b=diH+sbuXBlnatOrn9oaFsBvp5vQbYiODVVYjgYjM2o5SPRAXMOCEFbrLjSCubPIrTt
         2It2uiDb2l4FJsYppo+yiVyLC+GPpWWWn9PfkMBOKYxwN7Cwkvp+U1OhLSIm3ICa9IzO
         qqwc27MxjouEBrDNWlHqGqb9LTPY06WpKc4V5IDIpeBS+Zu/CJduQ1wQI9sKJ+0ZXHPc
         8ItOy51heLwMbIR4Xnu+htKlvh5HR9Sp3Ibru+HzUYw0PRIS4Gmp49xAc7gKMJAUO16D
         huSU7Tg9/wQCx8JsUrWgp9jN0dPvaPeEWh94U5rRytQbhPpsSMZ+1vObJhf5eP2sG/8C
         Rxyw==
X-Forwarded-Encrypted: i=1; AJvYcCUkb4ItejyxD7oBCitWEqllGyiZESHprjW2p1/1h+5ZqmIA8fMc62zH0PbFxRbtdvdSHXOHw48=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGAEdOyTx3peuUpQgornvYpl6FnJZ5+uMKz8zl9tA4KC8keS5z
	8Uq3LKCNzvzyrCMw9OP4mM8aXYFT+tF8OQ2A9viSe3R5YbsSQvL38b9euEiHvGsoAsY=
X-Gm-Gg: ASbGncvagPbsCuCorRx6lvjU6tLGTjIgH5QpiWZgUo/e9TpFla3pMC79a0tPHoLOzBp
	zlPnes8F1h5mFlXcHAEDDRtg1jrpsHjAO83ZLjnhHSCmjsu7K8pvPQx2D6/Rwpz+k6eRr8aHXIN
	EqCNwwLNt6tlZ7GAUueuE423LzXdilBCW6KVcBadv/mJBhGYsHh/SuxzM0D0oB67lxWWyAFImXK
	yLRBS262OTEsFijXtEzKQU3Qrslf3B3Br2YPUC8TT55BwZAq5YszQeuX6Ki1Yfv53OFJqgbdA9s
	42TdqdxPfHMcb3ikvtxGEiktNrpxJNATZHDFmHoae6CFk3n1ZhVofsNoZMoPi5tDG8e5Bmfv0qT
	l5dyudw7yGEDqMje/XFB12SaW1/tR9yGm08g3G7+sWK+re2eJYGlcdUWpbDTEjVkmdr5k
X-Google-Smtp-Source: AGHT+IGJsSVbXjLNIqrlIEbk/gUzNYQYHSbjL32ASxGtiy6zgoFXF/rrvq7tro5LsCceIcXyRKliEg==
X-Received: by 2002:a05:622a:1104:b0:4a3:fcc7:c72e with SMTP id d75a77b69052e-4ae8ef5c18emr158029941cf.9.1753712222972;
        Mon, 28 Jul 2025 07:17:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae99516fcesm35769401cf.9.2025.07.28.07.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 07:17:02 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ugOez-00000000ATD-3mT3;
	Mon, 28 Jul 2025 11:17:01 -0300
Date: Mon, 28 Jul 2025 11:17:01 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 10/38] iommufd/vdevice: Add TSM map ioctl
Message-ID: <20250728141701.GC26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-11-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728135216.48084-11-aneesh.kumar@kernel.org>

On Mon, Jul 28, 2025 at 07:21:47PM +0530, Aneesh Kumar K.V (Arm) wrote:
> With passthrough devices, we need to make sure private memory is
> allocated and assigned to the secure guest before we can issue the DMA.
> For ARM RMM, we only need to map and the secure SMMU management is
> internal to RMM. For shared IPA, vfio/iommufd DMA MAP/UNMAP interface
> does the equivalent

I'm not really sure what this is about? It is about getting KVM to pin
all the memory and commit it to the RMM so it can be used for DMA?

But it looks really strange to have an iommufd ioctl that just calls a
KVM function. Feeling this should be a KVM function, or a guestmfd
behavior??

I was kind of thinking it would be nice to have a guestmemfd mode that
was "pinned", meaning the memory is allocated and remains almost
always mapped into the TSM's page tables automatically. VFIO using
guests would set things this way.

Jason
