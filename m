Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904983207
	for <kvmarm@lists.linux.dev>; Sat,  2 Aug 2025 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754144274; cv=none; b=X0DvNvJwmGJ+dpA+jp/dqvHHWS+LEL0v/9tv4SA63VV0zM6xxYp+WIFg7B6ekcSdNQREEVAmphRt9IMxs/94/7G9lm2DniU+nlWWFobFdphwUY/e1oI/JfBiJMGIZDRV1IczJPGdvc9DjsBNoety5fmKp7fj+JUSyKsLcsq+ZDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754144274; c=relaxed/simple;
	bh=FQ39B9jERPUAW3pWSgAAeA1QG0tXEiueP0zJxCjCnZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1EVo9k4T/tWpKOp+oVIoOSAvChuZ+Fs2APOmiIMxzbhYL6PC4J/jU/VLYlqpwNYekpQrPb1dxyz/oei+rIud0U8QDTs+ecVKO+j02TwBS5RhQQKJdqUkAqnuG0sGGZ3orry4WPB+dBqQPBAMb3Ywbq1UBmT3xsHH9h5Q0k2OJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=F0YwNw5P; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="F0YwNw5P"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7e32c9577ddso155433485a.0
        for <kvmarm@lists.linux.dev>; Sat, 02 Aug 2025 07:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754144271; x=1754749071; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XAht3BlYnywuDydAQFgQqb1h2JGOGBLyurA+IzlOJa4=;
        b=F0YwNw5PQmdNPXnkbLaXVZMePCR0ppt8lnntTMVZjEWi61r1FzkPtGEXmmr9BEDTmO
         adksgrISpxGDxY3NlK4pP9ULYquqPB3SLwCSeuS9rp6r7sTbldK+9V2z1iPZbYmf7WT2
         UHTzR8oGDUNwnf3f7iBsx07oohxx5MQ1zT8LrW/EPIfNE547LdKEaLPJgKhO8Mg2pY+z
         rIE+S42CpJYYeiEryFZrtk1PMSSQx3Q+kPnFGIhw9iZdFV3IgPXVYBWHPEQ2mhwd5b2J
         yK2OeXLewtMZ0HIYlabLzVOFDosPMQ4emoonatyb3qeaeRFvK5eXy57oTi86SIi99VJv
         NpUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754144271; x=1754749071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAht3BlYnywuDydAQFgQqb1h2JGOGBLyurA+IzlOJa4=;
        b=eBhYHjGjjWsZzzh0x2e0rsU8vGcS7glKabv9gGiTpM3OLaMHjoL2Nrfx5eEVyGaTJv
         agyrI/3UVdkhe+GnWKui3SAGm9+sQL1ler4bjrUWydtBC8EWWXISU6CnrXYMbQT+SucD
         frpk2nhRwY0Gclswd54iUeXWUfdjDYMcNihj+aIp+XQWv5gLPiy/4H/R1mptWYf4/vph
         ZwAY7pBysFXKJJp4HaZd/WZUCCTIfoh28zDoyZg6a8OZuF0cokvNKUcwdOtD5ljCWxfk
         GVWtenkniOOiIvpwLudIW1TWJSDYfPsNpPeuUZ1YB8aACkLjbYMeLZk8gSeMYM7+DFYA
         tmaw==
X-Forwarded-Encrypted: i=1; AJvYcCWCd7npWPV0GjKUlvM7VjtHnP+D3Fzai8Xq5J4+v0h1skHhZaxA+an3w9lwbn7zqHjJUHM1rAY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIIjEzJ1ipvodJzYdSzMu8ceuyI6cAy28Mw0v+LsqYAtPuTHPL
	utS/Oz7ibdUDPkK2lp3qLC2JtuAXISQVvAGA658RX8uqpEGoT9LvNDH8QUCrjG35W40=
X-Gm-Gg: ASbGncswMdVhrmQWVC8NEIpTwrQGDcdZ9f6ItClIc9F8qow++3JRpOxW7nmflGBFpy5
	kPEet0ZNqgu51VprJAmXUdtLpjcRnTIdTSFqZ25FzdzpsEMqMW6jjveQ/x2I1wRfVbUbNMVympl
	0ep5ruvPmVfSH/NBZqVAyr9cIqQ9DAVc/koaPd1sAJucoewexx3ZQOBW4aJ8mmCSoMqYC8XtVea
	O2WXLoQkWuSaU1BM5QVkr/lytONT6SfLH1zo7/XOwU+xQLzZuTYDmz9OS14nm/1OIBTV/tHhpZc
	D/INx9a23gIV0wZUiTQhdVUrxHf4uYHPxw6KkXfP8lSBgQAJZ0C2m7yHwtKGhzeI4dG1+AdL4o+
	iC0u4IKyaGJislgnb4kf5k5UB+3ejmEhkaNjyc9Ul8nOOpVLsWEm43WuocwrJi5hTwhSv
X-Google-Smtp-Source: AGHT+IGdPAmPi73Qx9Dpc4yn7AJ3AWkRwpu/Z2rB1pE3w5ZLbSl1DPKWIHYygsiQ4vWMpbzVE9HS0A==
X-Received: by 2002:a05:620a:1645:b0:7e3:39c2:9856 with SMTP id af79cd13be357-7e696268352mr406724785a.1.1754144271303;
        Sat, 02 Aug 2025 07:17:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e681c8c727sm313508585a.78.2025.08.02.07.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 07:17:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uiD3W-00000001AEi-0hrF;
	Sat, 02 Aug 2025 11:17:50 -0300
Date: Sat, 2 Aug 2025 11:17:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: dan.j.williams@intel.com
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
Subject: Re: [RFC PATCH v1 00/38] ARM CCA Device Assignment support
Message-ID: <20250802141750.GL26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <688c2155849a2_cff99100dd@dwillia2-xfh.jf.intel.com.notmuch>
 <20250801155104.GC26511@ziepe.ca>
 <688d2f7ac39ce_cff9910024@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <688d2f7ac39ce_cff9910024@dwillia2-xfh.jf.intel.com.notmuch>

On Fri, Aug 01, 2025 at 02:19:54PM -0700, dan.j.williams@intel.com wrote:

> On the host this establishes an SPDM session and sets up link encryption
> (IDE) with the physical device. Leave VMs out of the picture, this
> capability in isolation is a useful property. It addresses the similar
> threat model that Intel Total Memory Encryption (TME) or AMD Secure
> Memory Encryption (SME) go after, i.e. interposer on a physical link
> capturing data in flight. 

Okay, maybe connect is not an intuitive name for opening IDE
sessions..

> I started this project with "all existing T=0 drivers 'just work'" as a
> goal and a virtue. I have been begrudgingly pulled away from it from the
> slow drip of complexity it appears to push into the PCI core.

Do you have some examples? I don't really see what complexity there is
if the solution it simply not auto bind any drivers to TDISP capable
devices and userspace is responsible to manually bind a driver once it
has reached T=1.

This seems like the minimum possible simplicitly for the kernel as
simply everything is managed by userspace, and there is really no
special kernel behavior beyond switching the DMA API of an unbound
driver on the T=0/1 change.

> The concern is neither userspace nor the PCI core have everything it
> needs to get the device to T=1. 

Disagree, I think userspace can have everything. It may need some
per-device userspace support in difficult cases, but userspace can
deal with it..

> PCI core knows that the device is T=1 capable, but does not know how
> to preconfigure the device-specific lock state,

Userspace can do this. Can we define exactly what is needed to do this
"pre-configure the device specific lock state"? At the very worst, for
the most poorly designed device, userspace would have to bind a T=0
driver and then unbind it.

Again, I am trying to make something simple for the kernel that gets
us to a working solution before we jump ahead to far more complex in
the kernel models, like aware drivers that can toggle themselves
between T=0/1.

> Userspace might be able to bind a new driver that leaves the device in a
> lockable state on unbind, but that is not "just works" that is,

I wouldn't have the kernel leave the device in the locked state. That
should always be userspace. The special driver may do whatever special
setup is needed, then unbind and leave a normal unlocked device
"prepped" for userspace locking without doing a FLR or
something. Realistically I expect this to be a very rare requirement,
I think this coming up just reflects the HW immaturity of some early
TDISP devices.

Sensible mature devices should have no need of a pre-locking step. I
think we should design toward that goal as the stable future and only
try to enable a hacky work around for the problematic early devices. I
certainly am not keen on seeing significant permanent kernel
complexity to support this device design defect.

> driver that expects the device arrives already running. Also, that main
> driver needs to be careful not to trigger typically benign actions like
> touch the command register to trip the device into ERROR state, or any
> device-specific actions that trip ERROR state but would otherwise be
> benign outside of TDISP."

As I said below, I disagree with this. You can't touch the *physical*
command register but the cVM can certainly touch the *virtualized*
command register. It up to the VMM To ensure this doesn't cause the
device to fall out of RUN as part of virtualization.

I'd also say that the VMM should be responsible to set pBME=1 even if
vBME=0? Shouldn't it? That simplifies even more things for the guest.

> > From that principal the kernel should NOT auto probe drivers to T=0
> > devices that can be made T=1. Userspace should handle attaching HW to
> > such devices, and userspace can sequence whatever is required,
> > including the attestation and verifying.
> 
> Agree, for PCI it would be simple to set a no-auto-probe policy for T=1
> capable devices.

So then it is just a question of what does a userspace component need
to do.

> I do not want to burden the PCI core with TDISP compatibility hacks and
> workarounds if it turns out only a small handful of devices ever deploy
> a first generation TDISP Device Security Manager (DSM). L1 aiding L2, or
> TDISP simplicity improvements to allow the PCI core to handle this in a
> non-broken way, are what I expect if secure device assignment takes off.

Same feeling about pre-configuration :)

> > The starting point must have the core code do this sequence
> > for every driver. Once that is working we can talk about if other
> > flows are needed.
> 
> Do you agree that "device-specific-prep+lock" is the problem to solve?

Not "the" problem, but an design issue we need to accommodate but not
endorse.

> > But I think we can start with the idea that such RAS failures have to
> > reload the driver too and work on improvements. Realistically few
> > drivers have the sort of RAS features to consume this anyhow and maybe
> > we introduce some "enhanced" driver mode to opt-into down the road.
> 
> Hmm, having trouble not reading that back supporting my argument above:
> 
> Realistically few devices support TDISP lets require enhanced drivers to
> opt-into TDISP for the time being.

I would be comfortable if hitless RAS recovery for TDISP devices
requires some kernel opt-in. But also I'm not sure how this should
work from a security perspective. Should userspace also have to
re-attest before allowing back to RUN? Clearly this is complicated.

Also, I would be comfortable to support this only for devices that do
not require pre-configuration.

Jason
