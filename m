Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A763F7872
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774456015; cv=none; b=h0fOs/dlVhxFI2/Hwu/Ko9bt9bcxfYrK5jYJMkmHXyk/BIxAJ3RSIVhzNZhNxdbqLf0Mb0jtnAUcq9VH0wcoBXUiuuzvPto8r3FKwYqwl0chyElpTwBqmPt1Rx2Bzp6/DJcvZqusr4wtTy9TEFCh8JaRj400KeG9K5dmse4aLU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774456015; c=relaxed/simple;
	bh=TOk2JwR1ghzWN3+hsOG03i7KAAvI4/RzVNzUzbIJ6LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQsvyHz/305QW7zuc6hyTdcwHc0Vitj7I+qUhzDAdKSQv3wcnqO0Bdtlmm+GPwycbt/6t/YeI9ZGNuIjvZ5T4Gf0vUCdDwAEwbgLCOCKh95GoiorZ3WJR5XBviDO5t25yd0ucSm3uNZNW5SMrfyHjGdqikFgBWFVz7z3oZPK4hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kJKRQbt6; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kJKRQbt6"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4852ef20fe8so73225e9.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 09:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774456009; x=1775060809; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0bBkY1eP+Ct3GuF+0/JrP6geka8T7n6XtITHRDXyqFk=;
        b=kJKRQbt6PvKkY3F4+FEJ5BzU4+6i63JsCxA3OELOBTaWCK6PNxY4uJMok6PgU41WgT
         BEL/OOv44PkRIbeUibckWcUUHuZCUMWy7Y0xgrK72Yq8rY5LvAMVHTAv93Mt1A7Khcc5
         G09//RT+9mScNo8z9NzJa/D5DcNpOK6UDQsbY/TqVK06M+cMxcNSmSvSB7spAwmoXiME
         omesvaecNdP72DEnfuGOD25zeUu54B8odwICMNwJE9WDo/4syRit4gi1RmXApNg97gcm
         wN+RLaH0F99M29uapkgBy8qMPwZTnc1nNSeXK8u0CEScw9TYdid0Uz1TflQ7bDOAuN80
         9P9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774456009; x=1775060809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bBkY1eP+Ct3GuF+0/JrP6geka8T7n6XtITHRDXyqFk=;
        b=SaOB+d4P/dokFMRRMQxMq6bG58QNpme7NuA6IPIMEzpIFmOjotJqn1le1G0Kwdwfcj
         aIKXfXVzr3lAgsuaq7ra2fIUq4nB8CasXXcuihEdNwsFm+zfT0CAUk3S0v5N3kt3BOoN
         rIBCcFumVocSoxcu5FcqzzxTK+QL26i3ru4JwPy+ELJMqWnRvLu3oEL32bF2O1OPv/ob
         uAxZK5zBuxchysU90wanGSo3iOrVBOw4ANHH3wzd7jgd7qzrU+rvWuODreN5QrYfAipB
         izoxLk3xz0Nkp5yegBiosSUPPPFFGwWlC6ZIm/k/VXTpVWjl4peJNiZ6c9hqNcDU2JSJ
         L/jA==
X-Forwarded-Encrypted: i=1; AJvYcCWvjE54K3ARh1NibqAlW2glB9DJZxtA39bCoItAniCpbD22YmgM7ly6eigE8T61QWkg3F+IDOI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyik3QnHmBjpz6TydHrvDZvyeyTLwuBMfarKlqrumvZvIwNjo5A
	He7mVIm7bf+C6NKbgmjmW3PP8CT8uMA6d5gvIYftyKm7niKttIdqZqmzLkIBub9Zwg==
X-Gm-Gg: ATEYQzynlaatJIjK338vwv9NY7zeJjHr2pr1eX+cYZAhASBQIfsXoCkIFwYFjJw/lVS
	MJQ7+0Q4Lg6lzXg3zN0kXB3/c+K7JlOwrNkRkKArEJsI47UXt2nIls/pjMVoXpd9964lIyso6Pu
	48jxassHQjEV/ZF2mcfItgiNExyMh96Zw0crqUolY89Uvg7i5eJ1GcnbDEw9lz5+2iPQdoL3lsx
	v74wIra9AI9CMQSmATp1m+7Ibwyfpc9Pv0IN3JRyFOq/U2a1AetcQCHSIfRP7ccKIAnfv2Ra6g3
	wk1r92MoPmDbUpjf1C+wmEWNk29HrPNhbmpdmZQiWTwcLQWqa8LiCIAzom9GAN/hE9KfdeNyxmx
	AYe3B2yopYYsz54CWhRvUOWIJMctF6Gr+b531gdfmhxQC0NIgaGZad9JhptM0QeiCrRhi1ORP2S
	CpUOpFAlV298eVkw2PyIp8WxbsCuSgs0acijKpi6yMl9UmDQamMXu33WVGKYXKXkZ4exw=
X-Received: by 2002:a05:600c:2251:b0:477:255c:bea8 with SMTP id 5b1f17b1804b1-4871787d822mr759325e9.7.1774456008193;
        Wed, 25 Mar 2026 09:26:48 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919588e6sm814549f8f.16.2026.03.25.09.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 09:26:47 -0700 (PDT)
Date: Wed, 25 Mar 2026 16:26:43 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	suzuki.poulose@arm.com, tabba@google.com, tglx@kernel.org,
	vdonnefort@google.com, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [RFC PATCH 00/14] KVM: ITS hardening for pKVM
Message-ID: <acQMwzA-cLAtHsvU@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <abQqqTYvmrtGp9l7@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abQqqTYvmrtGp9l7@google.com>

On Fri, Mar 13, 2026 at 03:18:01PM +0000, Mostafa Saleh wrote:

Hi Mostafa,

> Hi Seb,
> 
> On Tue, Mar 10, 2026 at 12:49:19PM +0000, Sebastian Ene wrote:
> > This series introduces the necessary machinery to perform trap & emulate
> > on device access in pKVM. Furthermore, it hardens the GIC/ITS controller to
> > prevent an attacker from tampering with the hypervisor protected memory
> > through this device. 
> > 
> > In pKVM, the host kernel is initially trusted to manage the boot process but
> > its permissions are revoked once KVM initializes. The GIC/ITS device is
> > configured before the kernel deprivileges itself. Once the hypervisor
> > becomes available, sanitize the accesses to the ITS controller by
> > trapping and emulating certain registers and by shadowing some memory
> > structures used by the ITS.
> > 
> > This is required because the ITS can issue transactions on the memory
> > bus *directly*, without having an SMMU in front of it, which makes it
> > an interesting target for crossing the hypervisor-established privilege
> > boundary.
> > 
> > 
> > Patch overview
> > ==============
> > 
> > The first patch is re-used from Mostafa's series[1] which brings SMMU-v3
> > support to pKVM.
> > 
> > [1] https://lore.kernel.org/linux-iommu/20251117184815.1027271-1-smostafa@google.com/#r
> > 
> > Some of the infrastructure built in that series might intersect and we
> > agreed to converge on some changes. The patches [1 - 3] allow unmapping
> > devices from the host address space and installing a handler to trap
> > accesses from the host. While executing in the handler, enough context
> > has to be given from mem-abort to perform the emulation of the device
> > such as: the offset, the access size, direction of the write and private
> > related data specific to the device. 
> > The unmapping of the device from the host address space is performed
> > after the host deprivilege (during _kvm_host_prot_finalize call).
> > 
> > The 4th patch looks up the ITS node from the device tree and adds it to
> > an array of unmapped devices. It install a handler that forwards all the
> > MMIO request to mediate the host access inside the emulation layer and
> > to prevent breaking ITS functionality. 
> > 
> > The 5th patch changes the GIC/ITS driver to exposes two new methods
> > which will be called from the KVM layer to setup the shadow state and
> > to take the appropriate locks. This one is the most intrusive as it
> > changes the current GIC/ITS driver. I tried to avoid creating a
> > dependency with KVM to keep the GIC driver agnostic of the virtualization
> > layer but I am happy to explore other options as well. 
> > To avoid re-programming the ITS device with new shadow structures after
> > pKVM is ready, I exposed two functions to change the
> > pointers inside the driver for the following structures:
> > - the command queue points to a newly allocated queue
> > - the GITS_BASER<n> tables configured with an indirect layout have the
> >   first layer shadowed and they point to a new memory region
> > 
> > Patch 6 adds the entry point into the emulation setup and sets up the
> > shadow command queue. It adds some helper macros to define the offset
> > register and the associate action that we want to execute in the
> > emulation. It also unmaps the state passed from the host kernel
> > to prevent it from playing nasty games later on. The patch
> > traps accesses to CWRITER register and copies the commands from the
> > host command queue to the shadow command queue. 
> > 
> > Patch 7 prevents the host from directly accessing the first layer of the
> > indirect tables held in GITS_BASER<n>. It also prevents the host from
> > directly accesssing the last layer of the Device Table (since the entries
> > in this table hold the address of the ITT table) and of the vPE Table
> > (since the vPE table entries hold the address of the virtual LPI pending
> > table.
> > 
> > Patches [8-10] sanitize the commands sent to the ITS and their
> > arguments.
> > 
> > Patches [11-13] restrict the access of the host to certain registers
> > and prevent undefined behaviour. Prevent the host from re-programming
> > the tables held in the GITS_BASER register.
> > 
> > The last patch introduces an hvc to setup the ITS emulation and calls
> > into the ITS driver to setup the shadow state. 
> > 
> > 
> > Design
> > ======
> > 
> > 
> > 1. Command queue shadowing
> > 
> > The ITS hardware supports a command queue which is programmed by the driver
> > in the GITS_CBASER register. To inform the hardware that a new command
> > has been added, the driver updates an index into the GITS_CWRITER
> > register. The driver then reads the GITS_CREADR register to see if the
> > command was processed or if the queue is stalled.
> >  
> > To create a new command, the emulation layer mirrors the behavior
> > as following:
> >  (i) The host ITS driver creates a command in the shadow queue:
> > 	its_allocate_entry() -> builder()
> >  (ii) Notifies the hardware that a new command is available:
> > 	its_post_commands()
> >  (iii) Hypervisor traps the write to GITS_CWRITER:
> > 	handle_host_mem_abort() -> handle_host_mmio_trap() ->
> >             pkvm_handle_gic_emulation()
> >  (iv) Hypervisor copies the command from the host command queue
> >       to the original queue which is not accessible to the host.
> >       It parses the command and updates the hardware write.
> > 
> > The driver allocates space for the original command queue and programs
> > the hardware (GITS_CWRITER). When pKVM becomes available, the driver
> > allocates a new (shadow) queue and replaces its original pointer to
> > the queue with this new one. This is to prevent a malicious host from
> > tampering with the commands sent to the ITS hardware.
> > 
> > The entry point of our emulation shares the memory of the newly
> > allocated queue with the hypervisor and donates the memory of the
> > original queue to make it inaccesible to the host.
> > 
> > 
> > 2. Indirect tables first level shadowing
> > 
> > The ITS hardware supports indirection to minimize the space required to
> > accommodate large tables (eg. deviceId space used to index the Device Table
> > is quite sparse). This is a 2-level indirection, with entries from the
> > first table pointing to a second table.
> > 
> > An attacker in control of the host can insert an address that points to
> > the hypervisor protected memory in the first level table and then use
> > subsequent ITS commands to write to this memory (MAPD).
> > 
> > To shadow this tables, we rely on the driver to allocate space for it
> > and we copy the original content from the table into the copy. When
> > pKVM becomes available we switch the pointers that hold the orginal
> > tables to point to the copy.
> > To keep the tables from the hypervisor in sync with what the host
> > has, we update the tables when commands are sent to the ITS.
> > 
> > 
> > 3. Hiding the last layer of the Device Table and vPE Table from the host
> > 
> > An attacker in control of the host kernel can alter the content of these
> > tables directly (the Arm IHI 0069H.b spec says that is undefined behavior
> > if entries are created by software). Normally these entries are created in
> > response of commands sent to the ITS.
> > 
> > A Device Table entry that has the following structure:
> > 
> > type DeviceTableEntry is (
> > 	boolean Valid,
> > 	Address ITT_base,
> > 	bits(5) ITT_size
> > ) 
> > 
> > This can be maliciously created by an attacker and the ITT_base can be
> > pointed to hypervisor protected memory. The MAPTI command can then be
> > used to write over the ITT_base with an ITE entry.
> > 
> > Similarly a vCPU Table entry has the following structure:
> > 
> > type VCPUTableEntry is (
> > 	boolean Valid,
> > 	bits(32) RDbase,
> > 	Address VPT_base,
> > 	bits(5) VPT_size
> > )
> > 
> > VPT_base can be pointed to hypervisor protected memory and then a
> > command can be used to raise interrupts and set the corresponding
> > bit. This would give a 1-bit write primitive so is not "as generous"
> > as the others.
> > 
> > 
> > Notes
> > =====
> > 
> > 
> > Performance impact is expected with this as the emulation dance is not
> > cost free.
> > I haven't implemented any ITS quirks in the emulation and I don't know
> > whether we will need it ? (some hardware needs explicit dcache flushing
> > ITS_FLAGS_CMDQ_NEEDS_FLUSHING). 
> > 
> > Please note that Redistributors trapping hasn't been addressed at all in
> > this series and the solution is not sufficient but this can be extended
> > afterwards. 
> > The current series has been tested with Qemu (-machine
> > virt,virtualization=true,gic-version=4) and with Pixel 10.
> > 
> > 
> > Thanks,
> > Sebastian E.
> > 
> > Mostafa Saleh (1):
> >   KVM: arm64: Donate MMIO to the hypervisor
> > 
> > Sebastian Ene (13):
> >   KVM: arm64: Track host-unmapped MMIO regions in a static array
> >   KVM: arm64: Support host MMIO trap handlers for unmapped devices
> >   KVM: arm64: Mediate host access to GIC/ITS MMIO via unmapping
> >   irqchip/gic-v3-its: Prepare shadow structures for KVM host deprivilege
> >   KVM: arm64: Add infrastructure for ITS emulation setup
> >   KVM: arm64: Restrict host access to the ITS tables
> >   KVM: arm64: Trap & emulate the ITS MAPD command
> >   KVM: arm64: Trap & emulate the ITS VMAPP command
> >   KVM: arm64: Trap & emulate the ITS MAPC command
> >   KVM: arm64: Restrict host updates to GITS_CTLR
> >   KVM: arm64: Restrict host updates to GITS_CBASER
> >   KVM: arm64 Restrict host updates to GITS_BASER
> >   KVM: arm64: Implement HVC interface for ITS emulation setup
> 
> I tested the patches on Lenovo ideacenter Mini X Gen 10 Snapdragon,
> and the kernel hangs at boot for me with messags the following log:
> 
> [    2.735838] ITS queue timeout (1056 1024)
> [    2.739969] ITS cmd its_build_mapd_cmd failed
> [    4.776344] ITS queue timeout (1120 1024)
> [    4.780472] ITS cmd its_build_mapti_cmd failed
> [    6.816677] ITS queue timeout (1184 1024)
> [    6.820806] ITS cmd its_build_mapti_cmd failed
> [    8.857009] ITS queue timeout (1248 1024)
> [    8.861129] ITS cmd its_build_mapti_cmd failed
> 
> I am happy to do more debugging, let me know if I can try anything.

I managed to reproduce it on this Lenovo machine. I will have to dig a bit more
because I am not seeing this under Qemu. As a quick try I used
gic_flush_dcache_to_poc after adding commands to the ITS queue but it
didn't make any difference.

> 
> Thanks,
> Mostafa
> 

Thanks for trying it,
Sebastian
> > 
> >  arch/arm64/include/asm/kvm_arm.h              |   3 +
> >  arch/arm64/include/asm/kvm_asm.h              |   1 +
> >  arch/arm64/include/asm/kvm_pkvm.h             |  20 +
> >  arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  17 +
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
> >  arch/arm64/kvm/hyp/nvhe/Makefile              |   3 +-
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  14 +
> >  arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 653 ++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 134 ++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c               |  28 +
> >  arch/arm64/kvm/hyp/pgtable.c                  |   9 +-
> >  arch/arm64/kvm/pkvm.c                         |  60 ++
> >  drivers/irqchip/irq-gic-v3-its.c              | 177 ++++-
> >  include/linux/irqchip/arm-gic-v3.h            |  36 +
> >  14 files changed, 1126 insertions(+), 31 deletions(-)
> >  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > 
> > -- 
> > 2.53.0.473.g4a7958ca14-goog
> > 
