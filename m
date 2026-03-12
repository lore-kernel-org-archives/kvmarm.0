Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DA73FE66B
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773338223; cv=pass; b=AOGqATlese9wzyeidCkNnzDPy12u1dw2cWalDxHvPAJNSw4NPdebJIo+xCwheTbPtrF2ewZY/NcheOSLtEcOEOHO9ORd44/2khRq/p7xJzoPLecx0IJ3W0qeUpYGNPXeEekSTFVdkRJ6RW0Zn0jFipuY/kQDwUDzSkuZdSHAXo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773338223; c=relaxed/simple;
	bh=otr96St+pr69820FnroIlMpOY5+VoVMXnrzkuc9SYs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JYo8VSfNWHZW01rWCaP3TpING8QZxatmks2PSDc/KT71UjC18pUkj52unOu8qFTdZhC6w5YJg6qOzv9ll76Alzk47n5R5HdnixhmNSAoY0v8B60mIM/2jedg8O1Sws2ZP7S2LTiml2yPzygVBk4I2f4nJJbOEr8usM1tPIeIYOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tmk1lmng; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tmk1lmng"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-509069a7a7fso61451cf.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 10:57:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773338221; cv=none;
        d=google.com; s=arc-20240605;
        b=c/vwQT9AoaAqfoF35CHoFVkEAiE6H9m+ct/2xotpvfM2BasVlHQI43esiJoNri8rxH
         mwrzmKMDaPr/7ZC84PdWCFOr2qBGKr9ebT7+vxewUvdWGOcvmRZIbf6/gCVGYlobOFdV
         ZKjLP0HLap0qyu/9AYWuZP9tvJ0qa+HGCJ0x7TyU6hKkwMXlXGP3Ig8Wg37/YMuPfU/8
         a2xcLtUQhctuBrXFHycccn/jmswbdMyXy2MKLf0bYuuG3XGlGgXHv02WFFw9/yL3JjoY
         qegCyTfyodsdMAEbundiunA+3h+QfmJr/7Ok+iRHsDbJjmcosq698dadM3fkH/ERdhwT
         abSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0mvUG/Z2/uZ5c2fN5XPa/W3Zus8cUWVYIvf3QqsJFUI=;
        fh=fOnopmH+DpMtMnjO/YE2EsrIcYbxzkA2YJt+k/AJxZY=;
        b=Z0NKuCKS0nZRK9tkaXnRQoZvMwc024GAyArjKL3gQJ9RBYBclGbrBu6RSlHCU+K7rS
         TwyxJHuGMAkH0lZL6LG7xBDluDD5hp6Mep/HNx0PTHNMhh3GyfWEg4s9BbpfMHk183JF
         /+3ZrvMBLefWfVQeIer8bq33tNy2FuKPdnh9VdTAKSiGKU70LhMy8rhII1YsKi1htygN
         Tj/RTg3/CTfi+T9cqo0yxcZmdG7QLGSPMKc4640nglwhsVhKrgq2aUhaLLAk14MQY8df
         /i2pvoKWIkAp98l/lBTYAW0Zl4Q4C47d//u9fLwUp5AUweNBIe34plUg7wDvMbmR8DgG
         kZOg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773338221; x=1773943021; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0mvUG/Z2/uZ5c2fN5XPa/W3Zus8cUWVYIvf3QqsJFUI=;
        b=tmk1lmngZtP5MbVsosR0rfNN1AM91VF1WPGEoQqOMWF7ioy1Mhf74di6pMqL3LFGo/
         jQ/PQ6ikVECO4tarfgJtFoLJ5qcgnlL1fMY0k4fQAxiXzXT/+68DKuCJul9ErHGYx97K
         vTVn6uVgeRzOFlliIdvDPE7ylxa2r8BKhAGGQ2IYHrBMeC1PVQjSe4szNpSM06GG2GZc
         Qd3CT5O8ptn577IUX4dmgEgYj4Ogg5uvSVLSXr4QzQfIV+LjAlxEhbeOAuYKTQ8dsYKG
         QHBZv6CiPCXT0csGKKqNrLEz/PmaxUySK1T56qA9FsfVTcaRHlghT5/0E6Jl6z4NXHG2
         jYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773338221; x=1773943021;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0mvUG/Z2/uZ5c2fN5XPa/W3Zus8cUWVYIvf3QqsJFUI=;
        b=sQd8STGY4gTA1vf3pUIJSVuKPK/yB/1nCp7vhtLC1QiJjqRxYRj9PNHaeRGSvkCdFL
         d9NizXHWOQ99S4bByO/dm2U4fsYh5HzcRNTMAVrMXXY1lwANmu14ZQ5IXLmZX13wfSRG
         Rr85zpmyKM84GK9RpjBrGBxe0yg64ivDgpeOEpjZlKdJje7BTlroWleb4zObbJKBAucm
         KZAO7ww7SMJcYBz7ITSjHEY2dSuoAlmCSazpZRKJ9MrvvXNYdrTuros5G16rRczumeP4
         V91P882THjPGvqqr3Gs27JLl60zFm4mXJxZn7K/GmmWjXeGkGRgmMS8kbxn5j/iSC0UC
         g+gg==
X-Forwarded-Encrypted: i=1; AJvYcCVruRZmLuZFBsSSCxuUuRYIRQH8M1SEbS2bimeY2z3Vyr0/FxRVYvT74wwQA2KPCzv9bkLKYO0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8YR/7FZyAAZZFy07eTwVjWOeWfzobvrOjSWjmwFa9MX2BE2VT
	+cMqqEPTedkkgkp0xXoAA0J8qCpKUd0husErT/TjgzsKciS7W1ssZBIHX3jnUN53t5tbPE9kzMJ
	25ndF8qRh6QbDJnE2EbMLtucZpDpkuN3FgT21oIHm
X-Gm-Gg: ATEYQzwxhcdrt5NdqBIdbsBC9iZ7wXGRPFvx6qwdTvrfUSDPz2uDOiN76eE3qBi8ZmB
	UBwldmIN022ljD/CawfzBHr8XMeL2bVtIuOAmKD+ng/Zx792dd/9bNeuB3TlSZLMFIykCMVysX2
	YBa/OBXfEHwPSuAesCqqsirW0W1dgFyfLqGc/F163gHdFJFp0oWE1sEY/rpNbIA+WN6op+vykHg
	hEEqKsOaj+EU4vlulsoX6aIyqmqFSQ7vMOL5ktLRka+8JeO/wPZFZjq2XTJvSP1E6feow1N2dh4
	L/t5u7u59a9rfO+QIhI=
X-Received: by 2002:a05:622a:1988:b0:509:25d8:9991 with SMTP id
 d75a77b69052e-509584f4fdcmr880951cf.16.1773338219853; Thu, 12 Mar 2026
 10:56:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Mar 2026 17:56:22 +0000
X-Gm-Features: AaiRm53G1nU7Kj2nfUNM3RM8KCK0SKWeGFwz4CDwwTgLZgN0Ex1zKGhkAGVfKhA
Message-ID: <CA+EHjTw3iQnTjKhMn6NP=R9JszitP9KAt0qU=Gdg0kwdcDvYsA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/14] KVM: ITS hardening for pKVM
To: Sebastian Ene <sebastianene@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, catalin.marinas@arm.com, dbrazdil@google.com, 
	joey.gouly@arm.com, kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, 
	oupton@kernel.org, perlarsen@google.com, qperret@google.com, 
	rananta@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi Sebastian,

On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
>
> This series introduces the necessary machinery to perform trap & emulate
> on device access in pKVM. Furthermore, it hardens the GIC/ITS controller to
> prevent an attacker from tampering with the hypervisor protected memory
> through this device.
>
> In pKVM, the host kernel is initially trusted to manage the boot process but
> its permissions are revoked once KVM initializes. The GIC/ITS device is
> configured before the kernel deprivileges itself. Once the hypervisor
> becomes available, sanitize the accesses to the ITS controller by
> trapping and emulating certain registers and by shadowing some memory
> structures used by the ITS.
>
> This is required because the ITS can issue transactions on the memory
> bus *directly*, without having an SMMU in front of it, which makes it
> an interesting target for crossing the hypervisor-established privilege
> boundary.
>
>
> Patch overview
> ==============
>
> The first patch is re-used from Mostafa's series[1] which brings SMMU-v3
> support to pKVM.
>
> [1] https://lore.kernel.org/linux-iommu/20251117184815.1027271-1-smostafa@google.com/#r
>
> Some of the infrastructure built in that series might intersect and we
> agreed to converge on some changes. The patches [1 - 3] allow unmapping
> devices from the host address space and installing a handler to trap
> accesses from the host. While executing in the handler, enough context
> has to be given from mem-abort to perform the emulation of the device
> such as: the offset, the access size, direction of the write and private
> related data specific to the device.
> The unmapping of the device from the host address space is performed
> after the host deprivilege (during _kvm_host_prot_finalize call).
>
> The 4th patch looks up the ITS node from the device tree and adds it to
> an array of unmapped devices. It install a handler that forwards all the
> MMIO request to mediate the host access inside the emulation layer and
> to prevent breaking ITS functionality.
>
> The 5th patch changes the GIC/ITS driver to exposes two new methods
> which will be called from the KVM layer to setup the shadow state and
> to take the appropriate locks. This one is the most intrusive as it
> changes the current GIC/ITS driver. I tried to avoid creating a
> dependency with KVM to keep the GIC driver agnostic of the virtualization
> layer but I am happy to explore other options as well.
> To avoid re-programming the ITS device with new shadow structures after
> pKVM is ready, I exposed two functions to change the
> pointers inside the driver for the following structures:
> - the command queue points to a newly allocated queue
> - the GITS_BASER<n> tables configured with an indirect layout have the
>   first layer shadowed and they point to a new memory region

We used the term shadow for the hyp version of structs in an early
pKVM patch series, but after a bit of discussion, we refer to it as
the hypervisor state [1]. So please use this terminology instead of
shadow.

[1] https://lore.kernel.org/all/YthwzIS18mutjGhN@google.com/

> Patch 6 adds the entry point into the emulation setup and sets up the
> shadow command queue. It adds some helper macros to define the offset
> register and the associate action that we want to execute in the
> emulation. It also unmaps the state passed from the host kernel
> to prevent it from playing nasty games later on. The patch
> traps accesses to CWRITER register and copies the commands from the
> host command queue to the shadow command queue.
>
> Patch 7 prevents the host from directly accessing the first layer of the
> indirect tables held in GITS_BASER<n>. It also prevents the host from
> directly accesssing the last layer of the Device Table (since the entries
> in this table hold the address of the ITT table) and of the vPE Table
> (since the vPE table entries hold the address of the virtual LPI pending
> table.
>
> Patches [8-10] sanitize the commands sent to the ITS and their
> arguments.
>
> Patches [11-13] restrict the access of the host to certain registers
> and prevent undefined behaviour. Prevent the host from re-programming
> the tables held in the GITS_BASER register.
>
> The last patch introduces an hvc to setup the ITS emulation and calls
> into the ITS driver to setup the shadow state.
>
>
> Design
> ======
>
>
> 1. Command queue shadowing
>
> The ITS hardware supports a command queue which is programmed by the driver
> in the GITS_CBASER register. To inform the hardware that a new command
> has been added, the driver updates an index into the GITS_CWRITER

It updates a base address offset, but that's probably what you meant.

> register. The driver then reads the GITS_CREADR register to see if the
> command was processed or if the queue is stalled.
>
> To create a new command, the emulation layer mirrors the behavior
> as following:
>  (i) The host ITS driver creates a command in the shadow queue:
>         its_allocate_entry() -> builder()
>  (ii) Notifies the hardware that a new command is available:
>         its_post_commands()
>  (iii) Hypervisor traps the write to GITS_CWRITER:
>         handle_host_mem_abort() -> handle_host_mmio_trap() ->
>             pkvm_handle_gic_emulation()
>  (iv) Hypervisor copies the command from the host command queue
>       to the original queue which is not accessible to the host.
>       It parses the command and updates the hardware write.
>
> The driver allocates space for the original command queue and programs
> the hardware (GITS_CWRITER). When pKVM becomes available, the driver

You mean GITS_CBASER, right?

> allocates a new (shadow) queue and replaces its original pointer to
> the queue with this new one. This is to prevent a malicious host from
> tampering with the commands sent to the ITS hardware.
>
> The entry point of our emulation shares the memory of the newly
> allocated queue with the hypervisor and donates the memory of the
> original queue to make it inaccesible to the host.
>
>
> 2. Indirect tables first level shadowing
>
> The ITS hardware supports indirection to minimize the space required to
> accommodate large tables (eg. deviceId space used to index the Device Table
> is quite sparse). This is a 2-level indirection, with entries from the
> first table pointing to a second table.
>
> An attacker in control of the host can insert an address that points to
> the hypervisor protected memory in the first level table and then use
> subsequent ITS commands to write to this memory (MAPD).
>
> To shadow this tables, we rely on the driver to allocate space for it
> and we copy the original content from the table into the copy. When
> pKVM becomes available we switch the pointers that hold the orginal
> tables to point to the copy.
> To keep the tables from the hypervisor in sync with what the host
> has, we update the tables when commands are sent to the ITS.
>
>
> 3. Hiding the last layer of the Device Table and vPE Table from the host
>
> An attacker in control of the host kernel can alter the content of these
> tables directly (the Arm IHI 0069H.b spec says that is undefined behavior
> if entries are created by software). Normally these entries are created in
> response of commands sent to the ITS.

nit: unpredictable behavior. Undefined usually refers to instructions.

>
> A Device Table entry that has the following structure:
>
> type DeviceTableEntry is (
>         boolean Valid,
>         Address ITT_base,
>         bits(5) ITT_size
> )

Be careful, this might be true for a specific GIC implementation,
e.g., Arm CoreLink GIC-600, but according to the spec (5.2) the
formats of the tables in system memory are IMPLEMENTATION DEFINED. If
the format is relevant to us, then we verify specific GIC
implementation via GITS_IIDR. If the series depends on this, then we
must decide what to do in case the specific implementation does not
match what we expect.

> This can be maliciously created by an attacker and the ITT_base can be
> pointed to hypervisor protected memory. The MAPTI command can then be
> used to write over the ITT_base with an ITE entry.

You mean it writes to the memory addressed by ITT_base, rather than
writes over the ITT_base itself.

> Similarly a vCPU Table entry has the following structure:
>
> type VCPUTableEntry is (
>         boolean Valid,
>         bits(32) RDbase,
>         Address VPT_base,
>         bits(5) VPT_size
> )
>
> VPT_base can be pointed to hypervisor protected memory and then a
> command can be used to raise interrupts and set the corresponding
> bit. This would give a 1-bit write primitive so is not "as generous"
> as the others.
>
>
> Notes
> =====
>
>
> Performance impact is expected with this as the emulation dance is not
> cost free.
> I haven't implemented any ITS quirks in the emulation and I don't know
> whether we will need it ? (some hardware needs explicit dcache flushing
> ITS_FLAGS_CMDQ_NEEDS_FLUSHING).

It's not a quirk. We should handle this in the next respin, because
cache maintenance of the command queue is an explicit architectural
requirement depending on how the hardware is integrated and
configured.

According to the spec, the cacheability attributes of the ITS command
queue are strictly governed by the InnerCache and OuterCache fields of
the GITS_CBASER register. These fields can be configured for various
memory types, including Device-nGnRnE or Normal Non-cacheable.

Because pKVM now takes responsibility for physically writing the
command packets into the true hardware queue, the hypervisor must obey
the cacheability attributes programmed into the physical GITS_CBASER.

If the software provisions GITS_CBASER as Non-cacheable, the
hypervisor must perform explicit data cache maintenance (such as DC
CVAU or DC CVAC) after copying the commands to the shadow queue. If
you don't implement this, the physical ITS hardware (acting as a
non-coherent bus master) will read stale memory, which will inevitably
lead to queue stalls or the ITS executing garbage commands.

Since we are shielding the physical queue from the host, we inherit
the host's responsibility to manage its cache coherency based on the
GITS_CBASER configuration.

> Please note that Redistributors trapping hasn't been addressed at all in
> this series and the solution is not sufficient but this can be extended
> afterwards.
> The current series has been tested with Qemu (-machine
> virt,virtualization=true,gic-version=4) and with Pixel 10.

It would be helpful to mention that this is based on Linux 7.0-rc3
(applied cleanly, and confirmed with you offline).

Also, it would be helpful if you could share how to tested this
series, and how we could reproduce your tests.

Thanks,
/fuad


>
>
> Thanks,
> Sebastian E.
>
> Mostafa Saleh (1):
>   KVM: arm64: Donate MMIO to the hypervisor
>
> Sebastian Ene (13):
>   KVM: arm64: Track host-unmapped MMIO regions in a static array
>   KVM: arm64: Support host MMIO trap handlers for unmapped devices
>   KVM: arm64: Mediate host access to GIC/ITS MMIO via unmapping
>   irqchip/gic-v3-its: Prepare shadow structures for KVM host deprivilege
>   KVM: arm64: Add infrastructure for ITS emulation setup
>   KVM: arm64: Restrict host access to the ITS tables
>   KVM: arm64: Trap & emulate the ITS MAPD command
>   KVM: arm64: Trap & emulate the ITS VMAPP command
>   KVM: arm64: Trap & emulate the ITS MAPC command
>   KVM: arm64: Restrict host updates to GITS_CTLR
>   KVM: arm64: Restrict host updates to GITS_CBASER
>   KVM: arm64 Restrict host updates to GITS_BASER
>   KVM: arm64: Implement HVC interface for ITS emulation setup
>
>  arch/arm64/include/asm/kvm_arm.h              |   3 +
>  arch/arm64/include/asm/kvm_asm.h              |   1 +
>  arch/arm64/include/asm/kvm_pkvm.h             |  20 +
>  arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  17 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
>  arch/arm64/kvm/hyp/nvhe/Makefile              |   3 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  14 +
>  arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 653 ++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 134 ++++
>  arch/arm64/kvm/hyp/nvhe/setup.c               |  28 +
>  arch/arm64/kvm/hyp/pgtable.c                  |   9 +-
>  arch/arm64/kvm/pkvm.c                         |  60 ++
>  drivers/irqchip/irq-gic-v3-its.c              | 177 ++++-
>  include/linux/irqchip/arm-gic-v3.h            |  36 +
>  14 files changed, 1126 insertions(+), 31 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c
>
> --
> 2.53.0.473.g4a7958ca14-goog
>
