Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CCD3126D7
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773415089; cv=none; b=eEpVbK+FZ4zOOwknwHaf6oXuHMogtBIICLUGy1z1MWewBa9tc1g7166DucONaFlt3pUMJVqKpsFlCb0f+y0JcSYRSzM1yGynAHJvvHCh3L9pCQ8vLoKwU57EYGz13jAy9ERU9B/d5+FYpQazcj8QWdw4JAcM+e5WQ/tRRjuyZIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773415089; c=relaxed/simple;
	bh=mt7YK9R/kzlK44x0oqR4iKfajWUb2HIKjQ1ASuTrSHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvwd3n8k5hj6X80s6VdC+vRMy+c4fOKZDsAw4/rvEiIcRcmBkhLc+ettBIHujtVuAqRin7+DA+RDAypST1Ryl9yLwOPpCNZd4RHo6aqytiUib53iQFELL3AGNw3XwCVlTRUyBdwlRvfOQ0EB9xYs0tqC8VAXcACoYbZ4D9fRBIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fEHFRsad; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fEHFRsad"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-485317b6bd0so66505e9.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 08:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773415086; x=1774019886; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ta2Ou5gCtU/aepAMrwAyagN15663lqpJZVH28HIpAIg=;
        b=fEHFRsad5+uBlrHE7NFr2OjkV5l0eC6GF5+ukfNHc/ebARZGdIB+WsUBFH/eGgQyH7
         OZCGm06N9ONIFKTeIX+LhxplJASJBhEBtcuCWAM+2lkJzOBmMsm1wYdGxGaI8KxZfQVQ
         Z9e1M18gurgfRLtSLRhZLZmIgzxyUS5VcAt3g7dTQuJsFIQVVJ2T9/l/fPg/KnecMqmh
         3l+HYYtTjLR/cCOo8DPwVo2z6e3Tx+vM3ppQcBXKsNs7ixFw17nBsbudDq0mHD+k8o04
         Mk9BeAex4oq0NJezsccfFqP2B8XSExfKYrJ0wk4Dgh8yC+sUOCETRXi2giHIv7wUhLCg
         Qh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773415086; x=1774019886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ta2Ou5gCtU/aepAMrwAyagN15663lqpJZVH28HIpAIg=;
        b=a9ZX4RkTZwI5aPxcKDZYvT9gCgh7++EV9A9vz0z9oBKiawwaFjbfn5Q/XKqg0JmLdV
         CMQAB1LNPpYm6l37KOoaZYgHSzyq1NQHnQdha1V/li3moN5EL4iNZeDvQnQEaVXUPTbl
         ukg6bNPxPj1nK2vplWE9dmMP+cZ1rqBGqAmYHzcaBbo55XpicVPLm2BNGnlonXuYS2/U
         UtfvNNmu+du13mMnUVPFx+/F9AnRbTprF2sSAbGPahcf4KyQpUrZ3lnA3CZ5DlJWnYr8
         S/tcw5zVtFDb/3xeLVfdHjB0W03AyMr2VpLFQnCaNh5vowOr5kRGQkNRZQrXcOVNs/Av
         Zg1A==
X-Forwarded-Encrypted: i=1; AJvYcCW0gUXQFvClzybGPu12NIz/eMQEeV7I5Z4q3OkhWb2OHzLqmwWEGj8XzyPByx565UXIFSHBV5U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXqT6i2TIFlQ1HBjQ+tprrVnbj8WnnjFhE6FT7XBgKJ8L5tncY
	q7NSU/7A4QKjm6RqMGPrgeXlUQXCoh9uqKJaA895oDaHG1xb9rFMveylT5vHvq0ZaqNBg8dIZBH
	g1P96qw==
X-Gm-Gg: ATEYQzzfV0cI1A8qYMnYFlNQ+VWIMSkAgOwupnCV5G1CA48W7+sj/Q+jnhlzrTLPk+5
	zmjd+S7xhbEgBQR5NJEgCNokg+gkG9hwkCi5HuJJFx8+UShYvH4Luxaq+7m62zSYfVsjBHkx7kQ
	1+qxZb6iLL1BgGFv1vkg32Ew1JB/U7j174q4p8t2aNj3EH4e/Ii8PxO3sSBGQWpb8szrR2VpeR5
	9Vdd6yZEWaDx5wgnRSpyK5+Oo3+IdbaLPzrFBqD/YwgP8w3Tfn6VGh578ulUYykC/cv+9BWBBlK
	OYu5KTKhXYAXmpJK7ezi0uoboGgCMBQuiPyri2dU7Q4XlOOyp77yYfpqMC8ArmyJClAlum9oZe8
	7NjxJywlNSkdVYxCnTuMPrWgUCgplg55GUQMO8krMLt2p1lqQYY6M7CK2usLZLmR/ZfTydnY8PT
	oWJiEP6mFGl2Dy34lhXWci49N71Wf6phRvqw/0R1OtCJoHBwqnDBsqCSZW
X-Received: by 2002:a05:600c:2148:b0:483:1093:f29b with SMTP id 5b1f17b1804b1-4855670e644mr774745e9.8.1773415084951;
        Fri, 13 Mar 2026 08:18:04 -0700 (PDT)
Received: from google.com (54.95.38.34.bc.googleusercontent.com. [34.38.95.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541b6f708sm455930345e9.11.2026.03.13.08.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 08:18:04 -0700 (PDT)
Date: Fri, 13 Mar 2026 15:18:01 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sebastian Ene <sebastianene@google.com>
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
Message-ID: <abQqqTYvmrtGp9l7@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>

Hi Seb,

On Tue, Mar 10, 2026 at 12:49:19PM +0000, Sebastian Ene wrote:
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
> 
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
> register. The driver then reads the GITS_CREADR register to see if the
> command was processed or if the queue is stalled.
>  
> To create a new command, the emulation layer mirrors the behavior
> as following:
>  (i) The host ITS driver creates a command in the shadow queue:
> 	its_allocate_entry() -> builder()
>  (ii) Notifies the hardware that a new command is available:
> 	its_post_commands()
>  (iii) Hypervisor traps the write to GITS_CWRITER:
> 	handle_host_mem_abort() -> handle_host_mmio_trap() ->
>             pkvm_handle_gic_emulation()
>  (iv) Hypervisor copies the command from the host command queue
>       to the original queue which is not accessible to the host.
>       It parses the command and updates the hardware write.
> 
> The driver allocates space for the original command queue and programs
> the hardware (GITS_CWRITER). When pKVM becomes available, the driver
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
> 
> A Device Table entry that has the following structure:
> 
> type DeviceTableEntry is (
> 	boolean Valid,
> 	Address ITT_base,
> 	bits(5) ITT_size
> ) 
> 
> This can be maliciously created by an attacker and the ITT_base can be
> pointed to hypervisor protected memory. The MAPTI command can then be
> used to write over the ITT_base with an ITE entry.
> 
> Similarly a vCPU Table entry has the following structure:
> 
> type VCPUTableEntry is (
> 	boolean Valid,
> 	bits(32) RDbase,
> 	Address VPT_base,
> 	bits(5) VPT_size
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
> 
> Please note that Redistributors trapping hasn't been addressed at all in
> this series and the solution is not sufficient but this can be extended
> afterwards. 
> The current series has been tested with Qemu (-machine
> virt,virtualization=true,gic-version=4) and with Pixel 10.
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

I tested the patches on Lenovo ideacenter Mini X Gen 10 Snapdragon,
and the kernel hangs at boot for me with messags the following log:

[    2.735838] ITS queue timeout (1056 1024)
[    2.739969] ITS cmd its_build_mapd_cmd failed
[    4.776344] ITS queue timeout (1120 1024)
[    4.780472] ITS cmd its_build_mapti_cmd failed
[    6.816677] ITS queue timeout (1184 1024)
[    6.820806] ITS cmd its_build_mapti_cmd failed
[    8.857009] ITS queue timeout (1248 1024)
[    8.861129] ITS cmd its_build_mapti_cmd failed

I am happy to do more debugging, let me know if I can try anything.

Thanks,
Mostafa

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
