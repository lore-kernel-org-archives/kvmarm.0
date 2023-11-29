Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C4161673
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 21:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="advf6d5S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701294337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s3xWVWUZPbk5MGMDQz7HZH6VD2zILEgQvXP9r7AbwIo=;
	b=advf6d5SvMQTxKgLR94MJFrWxVMxBSHl6Q6566Imrfkl17ydS1gPDufdTDkFKk1PkhSMCV
	7+yvri+ti+zYdSdhh8FYFwkORgHG2Zly5cvgFn0NfnnGqMbqWAEpjFSuDzuav/KmzRPhoB
	yQR3cVtzwKk7c8Dhyt5xrF2f0qwCo2I=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-ukA7yHOqN7C9OLxoqQroyQ-1; Wed, 29 Nov 2023 16:45:33 -0500
X-MC-Unique: ukA7yHOqN7C9OLxoqQroyQ-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-58d11a85f90so301609eaf.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 13:45:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701294333; x=1701899133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s3xWVWUZPbk5MGMDQz7HZH6VD2zILEgQvXP9r7AbwIo=;
        b=uZIXCvkPj5sReyGKiHCCjDXzQRVrQ7KYRYgLb2n0TCD1sI5VM7MMNZcn2gTR4gWVDR
         wOPE23s7wYvxrOMUXKpdKZJuNdpWMfgmI3XCxhAq0or3VSqOORcbJYUoM2Ctp7Y/zqA/
         2jNNfxFIuEUgCXAE3lzKxau4YED6enxrloV78PCqspKYPhWU2cs/Tb9fEZ4rJyYaF5OJ
         xWlOefcqSXTNQWPKa6M7GQcfK2OHNtP2OksRtsLR1g0rpB7Oxj0cE5YbuGxoXS8Qi0l8
         d8mK7Y/Ftz7U4zIZEu58L8j3e7lTEm9V9w1wz9YvVaTQvEgeOFRjqs86sZj2vFzIYvJd
         NpIw==
X-Gm-Message-State: AOJu0Yxrzlb/YyyAxbO4Clreqf5qLuZcv8U595fZ6Oo98laKy9KTkY4u
	+P/7MUWyu21OHY/LGvFiYPp0G9G0MB14rpJkev9m84cQKIY579ukAcJsjnnaGZ3P2OlYix3T8xX
	RKGAYw7+fNdldTKBk
X-Received: by 2002:a05:6820:513:b0:58d:6217:795e with SMTP id m19-20020a056820051300b0058d6217795emr19629091ooj.8.1701294332978;
        Wed, 29 Nov 2023 13:45:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiX/Tvc+toAwd/tY9Rv762mlPV5wQvlo/Dm5/DrBUxi70aCrX/U4468O+1d5CLlBkm80dRJw==
X-Received: by 2002:a05:6820:513:b0:58d:6217:795e with SMTP id m19-20020a056820051300b0058d6217795emr19629065ooj.8.1701294332763;
        Wed, 29 Nov 2023 13:45:32 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id u38-20020a4a8c29000000b0057bb326cad4sm2486047ooj.33.2023.11.29.13.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 13:45:32 -0800 (PST)
Date: Wed, 29 Nov 2023 14:45:30 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Borislav Petkov <bp@alien8.de>, Catalin
 Marinas <catalin.marinas@arm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Janosch Frank
 <frankja@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, James Morse <james.morse@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, Marc Zyngier <maz@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Oliver Upton
 <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, Sven
 Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Will
 Deacon <will@kernel.org>, x86@kernel.org, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c
 unless VFIO is selected
Message-ID: <20231129144530.16c18552.alex.williamson@redhat.com>
In-Reply-To: <ZWeDZ76VkRMbHEGl@google.com>
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
	<87edgy87ig.fsf@mail.lhotse>
	<ZWagNsu1XQIqk5z9@google.com>
	<20231129124821.GU436702@nvidia.com>
	<ZWeDZ76VkRMbHEGl@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Nov 2023 10:31:03 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Nov 29, 2023, Jason Gunthorpe wrote:
> > On Tue, Nov 28, 2023 at 06:21:42PM -0800, Sean Christopherson wrote:  
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index 454e9295970c..a65b2513f8cd 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -289,16 +289,12 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
> > >  /*
> > >   * External user API
> > >   */
> > > -#if IS_ENABLED(CONFIG_VFIO_GROUP)
> > >  struct iommu_group *vfio_file_iommu_group(struct file *file);
> > > +
> > > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> > >  bool vfio_file_is_group(struct file *file);
> > >  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> > >  #else
> > > -static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
> > > -{
> > > -       return NULL;
> > > -}
> > > -
> > >  static inline bool vfio_file_is_group(struct file *file)
> > >  {
> > >         return false;
> > >   
> > 
> > So you symbol get on a symbol that can never be defined? Still says to
> > me the kconfig needs fixing :|  
> 
> Yeah, I completely agree, and if KVM didn't already rely on this horrific
> behavior and there wasn't a more complete overhaul in-flight, I wouldn't suggest
> this.
> 
> I'll send the KVM Kconfig/Makefile cleanups from my "Hide KVM internals from others"
> series separately (which is still the bulk of the series) so as to prioritize
> getting the cleanups landed.
> 

Seems we have agreement and confirmation of the fix above as an
interim, do you want to post it formally and I can pick it up for
v6.7-rc?  Thanks,

Alex

