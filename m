Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E885C139F
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 13:28:37 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-3f6d3f83d0cso74253685e9.2
        for <kvmarm@lists.linux.dev>; Wed, 07 Jun 2023 06:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686144516; x=1688736516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NCR0Rk6m49JCUnfFidBMgakEp3k+e1YUOo/bxDNnCyg=;
        b=qlx4HGb3g1M8KIQ7tSfdrAabKQYEXrZznam6R2hO1jgi58Xrv6Qw+qG+kq+WFTjL2q
         A7cxSjK8Y1C4oZYyyLcBHkc/QnkHxETzFVUu04q+42jEKKLH8RymeFHcq38ZjEdrdRa2
         nM/Y0JYk6NSR3/goE3XcnjjZ/bE620Fj963hAXDwWQbXdGfE/rNaokMzedlAdDCkw7Kg
         zafDCEEfyqFIeqOb3Wjx2qhQei9ya8JhsD5lIlzC32fYJe/T3CIjKX7hpBkBzKfoAf/i
         ++gzDXgeawjf7Ep0uzFO5NHZZpoMDPzAQKQVMMNUuA5VcbA3S5wtQUFeSIeTGjCOyPAY
         m1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686144516; x=1688736516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCR0Rk6m49JCUnfFidBMgakEp3k+e1YUOo/bxDNnCyg=;
        b=UamOMUPWIZbDXtGpHl4mQXYpD5MaY2zN5JkvQ/yKPxfeVTO4FKMkZVCbumDTJ3Y0zU
         VDlBu4sk806CoYkF4vUJr3GCrv/vhe4KDfrQnZshpPAnM29BGtMWpa0dJo0QYQANKSVI
         OUe0r1Z+WhweH4scxZuf/tt1188KdrDowMiBLwGJXEfgdIM8UDuWA0zRkZtwFXvn9xuo
         JmQ0+oHxyP4EJlgE6eYgX11DdCDawYVprUXDuFkcbZD4CdVDNifDLoe/qQEI2tL4K05z
         gZrB5iuHLmJJ2IVJiC5ldIaM9IS2ejFv1ELkU5ydke+0Zx8+50a6BvbHPS0DFUAK5n2H
         S57A==
X-Gm-Message-State: AC+VfDwn0QzZ/bdyyrYdgBQjLNfrf3nr1zcv3ztPxw6iXSwA1uZfeaCq
	WNRJoGQe22rPh6Xv2NREV2jqlg==
X-Google-Smtp-Source: ACHHUZ5nu5UMw2zXQy7pWjoHQNbAcv+sR+coiEHan62nqyjEaqy1g+18b28XjsCCSB5vi90X94WvMQ==
X-Received: by 2002:a7b:cd10:0:b0:3f7:e65f:7adf with SMTP id f16-20020a7bcd10000000b003f7e65f7adfmr5755472wmj.14.1686144515975;
        Wed, 07 Jun 2023 06:28:35 -0700 (PDT)
Received: from myrica (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id a4-20020a05600c224400b003f5ffba9ae1sm2182683wmm.24.2023.06.07.06.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 06:28:35 -0700 (PDT)
Date: Wed, 7 Jun 2023 14:28:19 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Fix a circular locking issue
Message-ID: <20230607132819.GA1086197@myrica>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
 <20230518100914.2837292-2-jean-philippe@linaro.org>
 <20230606221525.GA2269598@dev-arch.thelio-3990X>
 <ZIAUTD9Og0ccyzrv@linux.dev>
 <87h6rjoeh7.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6rjoeh7.wl-maz@kernel.org>

On Wed, Jun 07, 2023 at 09:37:08AM +0100, Marc Zyngier wrote:
> > > After this change landed in 6.4-rc5 as commit 59112e9c390b
> > > ("KVM: arm64: vgic: Fix a circular locking issue"), my QEMU Fedora VM on
> > > my SolidRun Honeycomb fails to get to GRUB.
> > 
> > [...]
> > 
> > > I built a kernel with CONFIG_PROVE_LOCKING=y but I do not see any splats
> > > while this is occurring. Additionally, neither my Raspberry Pi 4 or my
> > > Ampere Altra system have any issues, so it is possible this could be a
> > > platform specific problem. I am more than happy to provide any
> > > additional information and test kernels and patches to help get to the
> > > bottom of this. My kernel configuration is attached.
> > 
> > I was unable to reproduce the issues you're seeing on 6.4-rc5, but I
> > don't have any different machines from you available atm. Based on
> > your description it sounds like your VM was able to do _something_
> > since it sounds like a few escape codes got out over serial...
> > I'm wondering if you're getting wedged somewhere on a VGIC MMIO access.
> > 
> > We don't have a precise tracepoint for VGIC accesses, but kvm:kvm_mmio
> > should do the trick. So, given that you're the lucky winner at
> > reproducing this bug right now, do you mind collecting a dump from that
> > tracepoint and sharing the access that happens before your VM gets
> > wedged?
> > 
> > Curious if Marc has any additional insight, since (unsurprisingly) he
> > has a lot more experience in dealing with the GIC than I. In the
> > meantime I'll stare at the locking flows and see if anything stands
> > out.
> 
> RPI4 is GICv2 nVHE, the NXP machine is GICv3 nVHE, and the Altra is
> GICv3 VHE. Not sure this is relevant here, but that's one data point.
> 
> Having been able to start the guest means that we should have fully
> initialised the GIC. So a lockup is likely be an interaction with the
> GIC emulation itself, either because we failed to release a lock
> during initialisation, or due to some logic error in the GIC emulation
> (which is not necessarily MMIO...).
> 
> I've just given 6.4-rc5 a go on my Synquacer, which is the closest
> thing I have to Nathan's NXP box, and I can't spot anything odd.
> 
> It would also help to get access to the EDK2 build. It wouldn't be the
> first time that a change in KVM breaks some EDK2 behaviour.

I found a build here:
https://koji.fedoraproject.org/koji/buildinfo?buildID=2204660
edk2-aarch64-20230301gitf80f052277c8-31.fc39.noarch.rpm
usr/share/edk2/aarch64/QEMU_EFI-silent-pflash.raw

Haven't managed to reproduce the issue yet, but I can only test with QEMU
emulating the cortex-a72 and GICv3 at the moment, and I still need to
reproduce the VMM command-line exactly. I think it would be helpful to get
the exact grub image as well, right now I'm using
Fedora-Server-KVM-38-1.6.aarch64.qcow2

Thanks,
Jean

> 
> Finally, on top of the traces that Oliver asked above, looking at
> where the QEMU vcpu threads are would be interesting (I assume they'd
> be sleeping in the kernel).
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
