Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD18B3C5537
	for <kvmarm@lists.linux.dev>; Fri, 20 Mar 2026 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774017731; cv=none; b=nubuz1sYWURDzZIt8wIGbcSC24R2Sh5Y2lGbHBecsIIwTEp4ee6mRfXmULZq5mU55o7m97EiEgTalegMrwdK3WiO7zw++XuPa+V0TrfUqGjOmIX/qSJdzbbnQEAVCOr3AEKiQt5QJu0hSRcswbhcwAjz4gBlb5MdY2gDixNE8Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774017731; c=relaxed/simple;
	bh=0uEcE/+wQy++LIEfvvMr1HgyANpigvYJpuUcrEJjgjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYy7V3sBYByHxpwgs4XRohLXVCDk3RaXJawzvlKwsHNdN32VVsOkiIGFYt3Z1b6XV/zpqCLyx2gIE2RfglBw3w6KG4kAblFG0QZ0bbq9e+f6RMDUfoKIJSLMgzyc76zucjuTU2aZQdYQvM3ufSTs47O8K9ISpbKK4C7TnOHx0ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ky6uJnUr; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ky6uJnUr"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48569636800so73205e9.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Mar 2026 07:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774017727; x=1774622527; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aE5NS2sVAN6gNknaAEWjlDcbr30NEPUj8rvRruurI5Q=;
        b=Ky6uJnUreRPaAPQvoJ8thT0ogHG7WuZAppMq6qvpBOW34pD0eZpoNF6gZViuFsbCHx
         Tm17udaqQGI2QkzRLtkuwE2JreZffw8OrehvohWdPKk3DBbU8XlavPL3wWzjULARhjyF
         PNg0I9YPUINSNngj8gDxDPQrEfcXD5Yho83Ru7hBASJoW4rICKy7huQQJX3osgxRNSIo
         j6mzg/ASoml6ALO8RV4qTJaQSBAgzNP9TNXtDS/JDG0xrNJ0RmrKX7ZxMgBsSKVAly31
         Kub/iu61kZc8o32Rt5QwnglrLNyPNihP/DvADTPt+BNHePehZlc7v5hmXaiFs9zSIdzz
         mumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774017727; x=1774622527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aE5NS2sVAN6gNknaAEWjlDcbr30NEPUj8rvRruurI5Q=;
        b=kCaW12G9HfsQgTtCDfa9XKNTDZvIG4Yht47+aB3A9njxQHo3mQk3ERoQ+Y6zHsOpJj
         l344E2rbSqTZPreGq+lMpUUDWTCtcIEkqUWE7y5I2XY2NxSNs6bDa0ZoUsL7edLb+6U1
         dAgwIzPM0sYBLJ7284wYDdyyF2SkXUOZr2WNiwEd83h0uN3QG01f7XDKk3EVmvb9JZ1u
         WZY84nf1gTSmtoAFzsad9cX0DS9pL3f2J27ectSpEo0FiKXwC/rnz4fZDTmiW3Fr5zRT
         g93NKlfrSc9dL6v1jonqcCp6Q/qUNVkCO/OZchD0L1eM43FLnjGhUhpDoYo3tqjgIg0h
         3vqw==
X-Forwarded-Encrypted: i=1; AJvYcCX6vwApJj5wlYWYjwRpuWFzKKYN6jGVQmcyX/gBz2+Mb9r3PNeDlLxLlA64+b/hfI59YJQdun4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8Ah84NfeWJBSCNOHbBOcvXDf6TmpufMMtJ3heXzFkqX69HwA1
	MJXxRNOwUXyFr9rLPeoRyTLx9DJ4A73yXzMli7/Jzz48tgUwWzQoh6R2WcglKD4j6Q==
X-Gm-Gg: ATEYQzxD5/AlCdjWEydhngLDP5W3Y89kj7nyMciZD+/QXS9JWQOD7xFy86zsbj9CfWz
	7POMpQOum9kpcmk+5hbUoYNoL+fPDyxDD8rjfzMDJ6H6+rZ2WU9FMtNQKyELtD7kMqt1sITUo4D
	rUsdFntT9h7+ik6P2ID7Dk4kbNwbHqtHsi4klKSZVvj4sC9bhCpdtTiRwG1u8BTzGfC3AJ6Y0A0
	xcJcFm1N4ue/VQLuXUsU/ycbVFebDDA73lq8fb62+sjw0TpbCFL0skXMtaILiLttVQMSH/bQwrr
	+EGxmE47DOSWvZJpdYsGsTt7km/B0EiPNfmwrzbjVRWTYcWQPSuGCK6gwUqADUqVyr4jGFJgTD8
	oO4pRfyhEFAWJC+8clcsyTVHaAazxbV1xCKI29Az+gEqolbKvD0M+HNcQP1i3mdNVquW+Hluobp
	k0VPbfK2Efr/PN99UqKkotTGS+Az8S+imfO/lccFBN6JWwGnUYlngxGnSPRi+qAM0CR5ycS22ej
	xhLWA==
X-Received: by 2002:a05:600c:8a0a:20b0:485:32b7:5b87 with SMTP id 5b1f17b1804b1-486fea7d654mr701725e9.14.1774017726610;
        Fri, 20 Mar 2026 07:42:06 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe6d9896sm78072995e9.2.2026.03.20.07.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 07:42:06 -0700 (PDT)
Date: Fri, 20 Mar 2026 14:42:02 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	smostafa@google.com, suzuki.poulose@arm.com, tglx@kernel.org,
	vdonnefort@google.com, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [RFC PATCH 00/14] KVM: ITS hardening for pKVM
Message-ID: <ab1cuhrTu-UOTOzm@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <CA+EHjTw3iQnTjKhMn6NP=R9JszitP9KAt0qU=Gdg0kwdcDvYsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw3iQnTjKhMn6NP=R9JszitP9KAt0qU=Gdg0kwdcDvYsA@mail.gmail.com>

On Thu, Mar 12, 2026 at 05:56:22PM +0000, Fuad Tabba wrote:

Hi,

> Hi Sebastian,
> 
> On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
> >
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
> 
> We used the term shadow for the hyp version of structs in an early
> pKVM patch series, but after a bit of discussion, we refer to it as
> the hypervisor state [1]. So please use this terminology instead of
> shadow.
> 
> [1] https://lore.kernel.org/all/YthwzIS18mutjGhN@google.com/

I think it makes sense to call it shadow in the context you pointed out.
In my context it doesn't make sense because the original structures are
manipulated by the hypervisor while the host only interacts with a copy
(eg. thus the shadow naming).

If you disagreee maybe we can call it a copy, I have no strong feelings
about this.

> 
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
> 
> It updates a base address offset, but that's probably what you meant.
> 
> > register. The driver then reads the GITS_CREADR register to see if the
> > command was processed or if the queue is stalled.
> >
> > To create a new command, the emulation layer mirrors the behavior
> > as following:
> >  (i) The host ITS driver creates a command in the shadow queue:
> >         its_allocate_entry() -> builder()
> >  (ii) Notifies the hardware that a new command is available:
> >         its_post_commands()
> >  (iii) Hypervisor traps the write to GITS_CWRITER:
> >         handle_host_mem_abort() -> handle_host_mmio_trap() ->
> >             pkvm_handle_gic_emulation()
> >  (iv) Hypervisor copies the command from the host command queue
> >       to the original queue which is not accessible to the host.
> >       It parses the command and updates the hardware write.
> >
> > The driver allocates space for the original command queue and programs
> > the hardware (GITS_CWRITER). When pKVM becomes available, the driver
> 
> You mean GITS_CBASER, right?
> 
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
> 
> nit: unpredictable behavior. Undefined usually refers to instructions.
>

Ack, will update.

> >
> > A Device Table entry that has the following structure:
> >
> > type DeviceTableEntry is (
> >         boolean Valid,
> >         Address ITT_base,
> >         bits(5) ITT_size
> > )
> 
> Be careful, this might be true for a specific GIC implementation,
> e.g., Arm CoreLink GIC-600, but according to the spec (5.2) the
> formats of the tables in system memory are IMPLEMENTATION DEFINED. If
> the format is relevant to us, then we verify specific GIC
> implementation via GITS_IIDR. If the series depends on this, then we
> must decide what to do in case the specific implementation does not
> match what we expect.
> 
> > This can be maliciously created by an attacker and the ITT_base can be
> > pointed to hypervisor protected memory. The MAPTI command can then be
> > used to write over the ITT_base with an ITE entry.
> 
> You mean it writes to the memory addressed by ITT_base, rather than
> writes over the ITT_base itself.
> 
> > Similarly a vCPU Table entry has the following structure:
> >
> > type VCPUTableEntry is (
> >         boolean Valid,
> >         bits(32) RDbase,
> >         Address VPT_base,
> >         bits(5) VPT_size
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
> 
> It's not a quirk. We should handle this in the next respin, because
> cache maintenance of the command queue is an explicit architectural
> requirement depending on how the hardware is integrated and
> configured.
> 
> According to the spec, the cacheability attributes of the ITS command
> queue are strictly governed by the InnerCache and OuterCache fields of
> the GITS_CBASER register. These fields can be configured for various
> memory types, including Device-nGnRnE or Normal Non-cacheable.
> 
> Because pKVM now takes responsibility for physically writing the
> command packets into the true hardware queue, the hypervisor must obey
> the cacheability attributes programmed into the physical GITS_CBASER.
> 
> If the software provisions GITS_CBASER as Non-cacheable, the
> hypervisor must perform explicit data cache maintenance (such as DC
> CVAU or DC CVAC) after copying the commands to the shadow queue. If
> you don't implement this, the physical ITS hardware (acting as a
> non-coherent bus master) will read stale memory, which will inevitably
> lead to queue stalls or the ITS executing garbage commands.
> 
> Since we are shielding the physical queue from the host, we inherit
> the host's responsibility to manage its cache coherency based on the
> GITS_CBASER configuration.
> 

Right, this will complicate the series a bit. I used the term 'quirk'
because this is how the driver refers to it.

> > Please note that Redistributors trapping hasn't been addressed at all in
> > this series and the solution is not sufficient but this can be extended
> > afterwards.
> > The current series has been tested with Qemu (-machine
> > virt,virtualization=true,gic-version=4) and with Pixel 10.
> 
> It would be helpful to mention that this is based on Linux 7.0-rc3
> (applied cleanly, and confirmed with you offline).
> 
> Also, it would be helpful if you could share how to tested this
> series, and how we could reproduce your tests.
>

I created a simple driver that registers for MSIs and probed it after
boot complete and observed all the commands sent to the ITS being
handled by the hypervisor.

[   60.196235] lpi_test: loading out-of-tree module taints kernel.
[   60.210751] lpi-test-driver test_node: >> probe lpi-test
[   60.212649] [ITS][CMD] >> 0x8
[   60.214780] lpi-test-driver test_node: lpi_test_probe linux lpi irq:
39
[   60.215810] lpi-test-driver test_node: lpi_test_probe linux lpi irq:
40
[   60.216870] [ITS][CMD] >> 0xa
[   60.217297] [ITS][CMD] >> 0x5
[   60.217889] lpi-test-driver test_node: >> msi address_high 0x0,
address_lo 0x8090040, address 0x8090040, data 0x0
[   60.219168] [ITS][CMD] >> 0xc
[   60.219576] [ITS][CMD] >> 0x5
[   60.220874] [ITS][CMD] >> 0xa
[   60.221292] [ITS][CMD] >> 0x5
[   60.221771] lpi-test-driver test_node: >> msi address_high 0x0,
address_lo 0x8090040, address 0x8090040, data 0x1
[   60.223091] [ITS][CMD] >> 0xc
[   60.223405] [ITS][CMD] >> 0x5
[   60.224482] lpi-test-driver test_node: >> probe complete

> Thanks,
> /fuad
> 
> 

Thanks,
Sebastian

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
