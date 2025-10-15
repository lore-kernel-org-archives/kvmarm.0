Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621A323401
	for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 11:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760529048; cv=none; b=RAsI3iZ76lrg4+9bWkuApalkAFNQVwPv8FEv+FUEN+dqk5SAGjhOF5MVIIuU6JLt8fvv3jCjC0rcXfbVsJtbMH+05QJlBKhm9jaXeoYwhtnsVskrFk8RrrGAUOW1dqJj0j/yUiIz5gFVgvRZRdrLGwtk3oIiVgoHmTe2pXqNdAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760529048; c=relaxed/simple;
	bh=tmowLdt/N2nbXuZaInudOLZY9PCI7SbE+aZIEDGepoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmDsSvz5xDbo5lO2EF2F+epJBqF7ZoxFA8i+o/a5fL+pHXH9+u4GaTAAZmlWlVZcXtgGe1pK5Hz5p7Ht9iYJE6CAMl35n1/7pdYdEbcJvvGl0Ox2bW0uRdHHr9X2EWkazSlkQUVcyfG7ZY2Bv75gwSgm6B+0ECkJYkoKnb9eKgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=J8v5UROM; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="J8v5UROM"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-43f715b18caso3228640b6e.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 04:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1760529046; x=1761133846; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vHmKb0ZIzx4zdIs4Lr+2KFKimyOcsEmfGR6+OHZivpc=;
        b=J8v5UROM8/mA13gwpEeh5FCfFK97QihhfTblXY7Ohoq0JuzT+F8XmDSHNWDPEdBnhN
         Ghhd/Pl+hQJAMnuaqfoxqoWwFT5CeT/QE/kX5sIxZc8gVwbvlBHAutY1/Z131vfsE0T4
         vkd65eh/fmtRFGUxYF3zIXVUwZVatFxiGxBMcbh06RzcP6GylIeWBb5AoabFO4HX2Aeg
         tYPgWfXPMGg9/Jt5Qfond5f6GqfVbm7AAzol19wmv5ODV17bbtC0Z2IoiTg/pibWHCiY
         Fu45X4AA1ZrwkATAhQ3r4wPmetpkt9AtgPj3dAE5srZNm08KTlzAxPXjgBxzygmaDppa
         fqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760529046; x=1761133846;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHmKb0ZIzx4zdIs4Lr+2KFKimyOcsEmfGR6+OHZivpc=;
        b=qKQ1bAiAH08mZMuNX/xx/QugXaW9XZ0mrXPJfBTeg/GHcYSuHFHD8r8pwST/NYmuul
         GCh5F+T+Zf6IpOqg4UvG6AJPNTeplMu4ikYcIyHr5Z759RXUhKMotvAChlZMToGwl9hJ
         3xJjSi8fsOnz27fEBi3DFNqZfXLFO+97QIWdKoT41/Gpbs8vExQ6AuDGchgiEV1JIiha
         3eL/iRh2xxcBI6CNCfn9gHVpnS7Yk60I+6N8fjmLv5lEIiob0dPM6fay8CrdvRby7NpJ
         l08jhd4Ct1/Shl11hjgp7TKVC7XoOB/wsrD12X8rPYEh12JuNOE2w8Nip5+eK/w8jVz2
         ctLw==
X-Forwarded-Encrypted: i=1; AJvYcCVHuCAqbdq8RoMR3cZyduzhCekh5xHi5pkPPB0a23C3EgDsr+qqSMsFV1w0LAemo7AhjjUXyOk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLyQ7XmruoKvKFULz3HqkasLdyhY9ifHOSGphmB2M+h28Uf6P7
	XVaw1QdjQ7cLNBUwxMz/HzE/Jtr+n2/SD4jCHV2L99LYzgA33squQqJadPbklk3sgxk=
X-Gm-Gg: ASbGnctqZ2roirDvKcKNkL3WybOVWS8yU7ZInkULmGNBG7hBvKdt3h8MtgQKSbPBJ8D
	My56BKcDBFEAqEepb9leop0/rJh9hDOFxxP+n5BllNRQ18Cl7uxHnugkLSztHAs4oty3k24YeY0
	dFUNd5fORzIa0/etNjIk01ApjMJiVItsN6hk2M7t8/oBw6uky6oVEEg5JwFscTBgI81TB5Itl/O
	EnIAbEysp2z4vVeTVOKTOlngHB+0bGxBYmcvBlec4Xi4KIrP9ampZL45pmULaUg+UTeAqRCftun
	a8MYwHfPV7j1D0fteljYVE3UQoWDw57TQ49Xpd6lWJ5ODGax6kyl1VHSp8c8VpRd7OdjAr+vNog
	cwDiIN3gJy9pzQYxYzrW2NSEfiA==
X-Google-Smtp-Source: AGHT+IF06YM32w1B97BvNmrLzOYC8WHnzl3Ay7SwG+FkmHKb9v+2SSicrsaLo8CLc8NQ8NePlRs7aQ==
X-Received: by 2002:a05:6808:4486:b0:43f:5f5f:370e with SMTP id 5614622812f47-4417b2f0ca9mr13602594b6e.19.1760529045662;
        Wed, 15 Oct 2025 04:50:45 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-441ca023222sm2814641b6e.11.2025.10.15.04.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 04:50:45 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v901k-0000000HOR5-14cb;
	Wed, 15 Oct 2025 08:50:44 -0300
Date: Wed, 15 Oct 2025 08:50:44 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
Message-ID: <20251015115044.GE3938986@ziepe.ca>
References: <20250729181045.0000100b@huawei.com>
 <20250729231948.GJ26511@ziepe.ca>
 <yq5aqzxy9ij1.fsf@kernel.org>
 <20250730113827.000032b8@huawei.com>
 <20250730132333.00006fbf@huawei.com>
 <2025073035-bulginess-rematch-b92e@gregkh>
 <b3ec55da-822a-4098-b030-4d76825f358e@arm.com>
 <20251010135922.GC3833649@ziepe.ca>
 <yq5a347kmqzn.fsf@kernel.org>
 <2025101523-evil-dole-66a3@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025101523-evil-dole-66a3@gregkh>

On Wed, Oct 15, 2025 at 11:58:25AM +0200, Greg KH wrote:
> On Wed, Oct 15, 2025 at 03:22:28PM +0530, Aneesh Kumar K.V wrote:
> > Jason Gunthorpe <jgg@ziepe.ca> writes:
> > 
> > > On Fri, Oct 10, 2025 at 07:10:58AM -0500, Jeremy Linton wrote:
> > >> > Yes, use faux_device if you need/want a struct device to represent
> > >> > something in the tree and it does NOT have any real platform resources
> > >> > behind it.  That's explicitly what it was designed for.
> > >> 
> > >> Right, but this code is intended to trigger the kmod/userspace module
> > >> loader.
> > >
> > > Faux devices are not intended to be bound, it says so right on the label:
> > >
> > >  * A "simple" faux bus that allows devices to be created and added
> > >  * automatically to it.  This is to be used whenever you need to create a
> > >  * device that is not associated with any "real" system resources, and do
> > >  * not want to have to deal with a bus/driver binding logic.  It is
> > >                         ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >  * intended to be very simple, with only a create and a destroy function
> > >  * available.
> > >
> > > auxiliary_device is quite similar to faux except it is intended to be
> > > bound to drivers, supports module autoloading and so on.
> > >
> > > What you have here is the platform firmware provides the ARM SMC
> > > (Secure Monitor Call Calling Convention) interface which is a generic
> > > function call multiplexer between the OS and ARM firmware.
> > >
> > > Then we have things like the TSM subsystem that want to load a driver
> > > to use calls over SMC if the underlying platform firmware supports the
> > > RSI group of SMC APIs. You'd have a TSM subsystem driver that uses the
> > > RSI call group over SMC that autobinds when the RSI call group is
> > > detected when the SMC is first discovered.
> > >
> > > So you could use auxiliary_device, you'd consider SMC itself to be the
> > > shared HW block and all the auxiliary drivers are per-subsystem
> > > aspects of that shared SMC interface. It is not a terrible fit for
> > > what it was intended for at least.
> > >
> > 
> > IIUC, auxiliary_device needs a parent device, and the documentation
> > explains that it’s intended for cases where a large driver is split into
> > multiple dependent smaller ones.

Which is the case here, you have a SMC interface that you want to
fracture into multiple subsystems.

> > If we want to use auxiliary_device for this case, what would serve as
> > the parent device?

You probably need to make a platform device for the discovered PSCI
interface from the firmware. Looks like DT will already have one, ACPI
could invent one..
 
> The real device that has the resources you wish to share access to.  Are
> there physical resources here you are sharing?  If so, that device is
> the parent.  If there is no such thing, then just make a bunch of faux
> devices and be done with it :)

At the very bottom of the stack it looks like the PSCI interface is
discovered first through DT/ACPI. The PSCI interface has RPCs that are
then used to discover if SMC/etc/etc are present and along the way it
makes platform devices to plug in subsystems to it based on what it
can discover.

It is just not sharing "resources" in the traditional sense, PSCI has
no registers or interrupts, yet it is a service provided by the
platform firmare.

Again faux devices don't serve the need here to load modules and do
driver binding.

Jason
