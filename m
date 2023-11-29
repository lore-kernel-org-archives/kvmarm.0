Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51705DF06
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 18:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYSsNZZD"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5d10f5bf5d9so901637b3.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 10:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701282665; x=1701887465; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c1rLIdwfJP37garEzWHrWFHBXDQvp3tQ1Ff7Pa+0bvQ=;
        b=tYSsNZZD7T6HWCYsi/FX162jsCnCsdwF+4JGzm2gnngBsvx4NHHtk2L4VKddkSQlIf
         InKWh453eDX3JBVrTHyTMnZ7zzUN8FroqDxXWOOQJ5h+6pBARAuUsPkQPIb8zKGN+w0Y
         P66Uq3M4kl40ZP0BesiFEcCexxKj4fMVfCl+TMiKFAkLlij+dvhqW2QqqJCHlLijYdKN
         N6T/4SXSrXrFjXX8LX9iw0GMzZBbjgqcEjrCfEJ2C2pyyYjEPXHx3FOpSo68DSZ6k3aI
         fEjuLaR85E3i2frMTgXnr7f691DIlcgs2K5NVdz4TbYs2ZAMFJKoz5AQKqJ/PyLF44jt
         88+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701282665; x=1701887465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c1rLIdwfJP37garEzWHrWFHBXDQvp3tQ1Ff7Pa+0bvQ=;
        b=BEYv+4mQ3ICeWQKJAUa++x7m/nzFPlUd9A3Aw6lpPQRk2F5RKsd+crRs7oyozD6LLA
         KW7TVZ7bhCO2F5NwZL2Lw8klhgW8YmffIVci96VU7kU2T7ci2WcYSLHSNc5cYDylLRF/
         IC/fQMBoeL6X4VDaDxI8bvQclrTbN6XlvrgnjKdbtcaj13Slp7c+uPis7GzXhTb+8AuC
         IiwjXWPd7Ab/UlGbAELkhMawrNHlcickpQ0MiAW6lum2BQjXuurAYhVZcdlG7BzAvARS
         OQdvnutqZnf9pN8To+VLh+pUodsuOsigIR5/aLOWXd5rztT+IeEFN4+n6TtIOgTUa/31
         hyCA==
X-Gm-Message-State: AOJu0YzYjaH5nT1L7I83GE99kHt3BZnZnIxC5L2IfsUbhkHjCOsh1ago
	Bsx2IRfS8M8CcHI/JbjCED7aZ9KmZ1s=
X-Google-Smtp-Source: AGHT+IHxpKv+Onni3jsljSwKzH8uXIhuxnoTBESUxuFhb+PRCSSwYQqIrFh/Htrp8TEW9pXbXT6mJDicqaY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:480d:b0:5ce:a88:8436 with SMTP id
 hc13-20020a05690c480d00b005ce0a888436mr522497ywb.10.1701282664859; Wed, 29
 Nov 2023 10:31:04 -0800 (PST)
Date: Wed, 29 Nov 2023 10:31:03 -0800
In-Reply-To: <20231129124821.GU436702@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
 <87edgy87ig.fsf@mail.lhotse> <ZWagNsu1XQIqk5z9@google.com> <20231129124821.GU436702@nvidia.com>
Message-ID: <ZWeDZ76VkRMbHEGl@google.com>
Subject: Re: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c
 unless VFIO is selected
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, James Morse <james.morse@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	Marc Zyngier <maz@kernel.org>, Ingo Molnar <mingo@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, 
	x86@kernel.org, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 29, 2023, Jason Gunthorpe wrote:
> On Tue, Nov 28, 2023 at 06:21:42PM -0800, Sean Christopherson wrote:
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 454e9295970c..a65b2513f8cd 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -289,16 +289,12 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
> >  /*
> >   * External user API
> >   */
> > -#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  struct iommu_group *vfio_file_iommu_group(struct file *file);
> > +
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  bool vfio_file_is_group(struct file *file);
> >  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> >  #else
> > -static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
> > -{
> > -       return NULL;
> > -}
> > -
> >  static inline bool vfio_file_is_group(struct file *file)
> >  {
> >         return false;
> > 
> 
> So you symbol get on a symbol that can never be defined? Still says to
> me the kconfig needs fixing :|

Yeah, I completely agree, and if KVM didn't already rely on this horrific
behavior and there wasn't a more complete overhaul in-flight, I wouldn't suggest
this.

I'll send the KVM Kconfig/Makefile cleanups from my "Hide KVM internals from others"
series separately (which is still the bulk of the series) so as to prioritize
getting the cleanups landed.
