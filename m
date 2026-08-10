Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34374334C5
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 23:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786405326; cv=none; b=HD2gLchLMzKlHshuOAsr5k/Ebvy9WngEtsqi4oStbz2DVDMvjCkeBrK4KHinUQPz+wmJKjeEDIdk9Viy525sx78dg8whlBsGoluLktF24hKcRAOMfTRgB5oRblTt+jGm2uxqXUdIxfEEH41OyLk4sxyVQj/TTgmVpcy9v9JJywc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786405326; c=relaxed/simple;
	bh=WMfoGgEW8aajRtEJ1nuxQxnr7szFPNP4pqx6EOlZNw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I86FYp0FHIOO95YGnQ15mA2grV/egwogXa7h4ElS1UmFesW/+CHmm71nJdQR4o3kASm/r5gyJrz/UuGZ/KqyU1X31OdAo+kVInxMzp+77aAbXdsAOkJfAiJy5NaHr4CW89MEPXuu5LRmCTfA9ntlxGCf525qPKpBBvBpyff7KYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZhxXtB7I; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZhxXtB7I"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84e1da97175so3445344b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 16:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786405323; x=1787010123; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A61U9gaW98E0bIoWCcW/i0GsXSPspOMzgO62CMQ+Bvc=;
        b=ZhxXtB7IubFMoiHVFpMPMyvT3MHgkW/n6QI+x9IdU7c4qFUPmqdho/0u6sVXhT+M7+
         HWqdXdiM9USzytNlQzkvNKhf4LFFG0qjGa0TEV2XafJCSGG9EoHo5KGjbavZwqevrj6Z
         jD/55yGB2nR0cE3uXoOynZsq1klTkPzm0TwRvPrrjGWZjuRnuwgtqbkfV7eYbCi8Drdb
         ptBYNCsSq7wIU5gktarB9caUBMTK88PjbzEJ9sOwfXv26P456c6elG1HVDzjo9JTjhez
         qORDN5CLsEihGAadj7dfXM1MucHz4KZEoSlsoAk/VhJ//nFQMED6mzyyD2lSi90CYlAt
         wQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786405323; x=1787010123;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A61U9gaW98E0bIoWCcW/i0GsXSPspOMzgO62CMQ+Bvc=;
        b=eyuj+nSybBiqrYYRwUuUUNmC4zxR7pTCtxcRFyh+mWhZLoUGuXN64Tq4+ebOsCZapN
         YRc5FSwmh0NaSq42BtOYCHc6Fc6C8NweK9KyNYXNHnTFso3QLyHAd0Ze19dH5drR065M
         MW3I/5FeKzK+HmNurjZF3wruh0A7mKFTDS8dep+ild+RdUP7/Fq1NZ94PT6aJKolNyIn
         SNRh3mZTWbwVpqi5DWIU9rKHVNAD3ePk4UzWS1aXExU3yoJ2a74RcVEf21CJYeonNj7a
         xh5HeuKd7LlZ9knDXqIaAHAk7D7qbg9wmq9T8y1ykmfuhKkoNhJudtGMlzIoXzTPatJB
         xJog==
X-Forwarded-Encrypted: i=1; AHgh+RostZlZV0zN7VT9myQbj47vBJE8EK3JmcvC+LGd1N6E6s1INo83M+R7uZIvKFssp51TMhYjX4E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLaTg5PhXpVfhfiGsNDc36JaXBEGRPhRy1Sw6MbYk9kU5S4EOY
	vI2vSt+pVmNIasmh0/lfitRou8BloXh+jeIJuv5bvV/RaIOA05VkfaSCDkTqgw/FGQ33CDuFqu4
	7ekArdg==
X-Received: from pfblc11.prod.google.com ([2002:a05:6a00:4f4b:b0:84a:1bf6:cb4a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1910:b0:848:4859:a45
 with SMTP id d2e1a72fcca58-84f9c893fe3mr5371451b3a.2.1786405322699; Mon, 10
 Aug 2026 16:42:02 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:42:02 -0700
In-Reply-To: <20260728121138.1103610-6-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-6-tarunsahu@google.com>
Message-ID: <anphyjFv3FhF61iB@google.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
> to serialize and deserialize VM state across kexec live updates.
> 
> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
> of VM preservation.

Why?

> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
> kvm_create_vm_file() and use an atomically incremented ID for the internal
> fdname, as the final fdname assigned by userspace is not yet known during
> retrieval. As this fdname is only used in debugfs infra, This will not break
> any UAPI.
> 
> This infrastructure establishes the foundation for preserving guest_memfd
> instances across live updates, and can be expanded in the future to
> preserve additional VM state.

Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
guest_memfd should be the _last_ thing we support, not the first.  As evidenced
by the last two decades, it's very doable to have KVM VMs without guest_memfd,
but it's rather hard to have VMs without vCPUs.

> Also updates MAINTAINERS to include virt/kvm/kvm_luo.c and
> include/linux/kho/abi/kvm.h.
> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  MAINTAINERS                 |  11 ++
>  include/linux/kho/abi/kvm.h |  39 ++++++++
>  virt/kvm/Makefile.kvm       |   1 +
>  virt/kvm/kvm_luo.c          | 195 ++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c         |   8 ++
>  virt/kvm/kvm_mm.h           |   8 ++
>  6 files changed, 262 insertions(+)
>  create mode 100644 include/linux/kho/abi/kvm.h
>  create mode 100644 virt/kvm/kvm_luo.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a3ed337e827d..0283f0fd6ef4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14539,6 +14539,17 @@ S:	Maintained
>  F:	Documentation/devicetree/bindings/leds/backlight/kinetic,ktz8866.yaml
>  F:	drivers/video/backlight/ktz8866.c
>  
> +KVM LIVE UPDATE
> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
> +M:	Mike Rapoport <rppt@kernel.org>
> +M:	Pratyush Yadav <pratyush@kernel.org>
> +R:	Tarun Sahu <tarunsahu@google.com>
> +L:	kexec@lists.infradead.org
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git

NAK on taking changes through a different tree.  This is KVM code, period.

In general, I'm skeptical of the dedicated MAINTAINERS entry.  It's extremely
difficult to tell since this series is little more than a skeleton (either that
or liveupdate is way simpler that I was expecting), but I suspect that maintaining
liveupdate for KVM (or for any subsystem) will require more subsystem-specific
knowledge than liveupdate knowledge.

E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
is going to be in knowing what to save/restore, and how, which is much more about
KVM than it is about liveupdate.

> +F:	virt/kvm/kvm_luo.c
> +
>  KVM PARAVIRT (KVM/paravirt)
>  M:	Paolo Bonzini <pbonzini@redhat.com>
>  R:	Vitaly Kuznetsov <vkuznets@redhat.com>
> diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
> new file mode 100644
> index 000000000000..718db68a541a
> --- /dev/null
> +++ b/include/linux/kho/abi/kvm.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * Tarun Sahu <tarunsahu@google.com>
> + *
> + * KVM Preservation ABI for Live Update Orchestrator (LUO)
> + */
> +#ifndef _LINUX_KHO_ABI_KVM_H
> +#define _LINUX_KHO_ABI_KVM_H
> +
> +#include <linux/types.h>
> +#include <linux/kho/abi/kexec_handover.h>
> +
> +/**
> + * DOC: KVM Live Update ABI
> + *
> + * KVM uses the ABI defined below for preserving its state
> + * across a kexec reboot using the LUO.
> + *
> + * The state is serialized into a packed structure `struct kvm_luo_ser`
> + * which is handed over to the next kernel via the KHO mechanism.
> + *
> + * This interface is a contract. Any modification to the structure layout
> + * constitutes a breaking change. Such changes require incrementing the
> + * version number in the KVM_LUO_FH_COMPATIBLE compatibility string.
> + */
> +
> +/**
> + * struct kvm_luo_ser - Main serialization structure for a KVM VM.
> + * @type:         The type of VM.
> + */
> +struct kvm_luo_ser {
> +	u64 type;
> +} __packed;
> +
> +/* The compatibility string for KVM VM file handler */
> +#define KVM_LUO_FH_COMPATIBLE	"kvm_vm_luo_v1"
> +
> +#endif /* _LINUX_KHO_ABI_KVM_H */
> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
> index d047d4cf58c9..c1a962159264 100644
> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -13,3 +13,4 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>  kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
>  kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
>  kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
> +kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/kvm_luo.o
> diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
> new file mode 100644
> index 000000000000..025b53151b6a
> --- /dev/null
> +++ b/virt/kvm/kvm_luo.c
> @@ -0,0 +1,195 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * Tarun Sahu <tarunsahu@google.com>
> + *
> + * KVM VM Preservation for Live Update Orchestrator (LUO)
> + */
> +
> +/**
> + * DOC: KVM VM Preservation via LUO
> + *
> + * Overview
> + * ========
> + *
> + * KVM virtual machines (VMs) can be preserved over a kexec reboot using the
> + * Live Update Orchestrator (LUO) file preservation. This allows userspace
> + * to preserve KVM VM state across kexec reboots.
> + *
> + * The preservation is not intended to be fully transparent. Only specific
> + * VM configuration and state are preserved, while other aspects of the VM
> + * must be re-established or re-configured by userspace after retrieval.

IMO, this is not helpful documentation.  Anyone with passing knowledge of LUO
already knows the above.  What people like me don't know are the exact details
of how preserving a KVM guest is expected to work.

> + * Preserved Properties
> + * ====================
> + *
> + * The following properties of the KVM VM are preserved across kexec:
> + *
> + * VM Type
> + *   The VM type (e.g., on x86 architecture, the vm_type parameter) is
> + *   preserved.
> + *
> + * Non-Preserved Properties
> + * ========================
> + *
> + * The preservation does not cover:
> + *
> + * - vCPUs and vCPU states
> + * - Memspots / Memory slot layout (memslots)
> + * - Interrupt controllers and IRQ routings
> + * - Coalesced MMIO zones
> + * - Device bindings (VFIO/Eventfds)
> + * - Active paging or guest registers state
> + * - etc

So... what's the plan?  Bluntly, this series isn't going anywhere without a
clear plan of how all of this is going to fit together.

> +static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
> +{
> +	struct kvm *kvm = args->file->private_data;
> +	struct kvm_luo_ser *ser;

I *really* dislike the "ser" nomenclature.  The abbreviation isn't common, and
IMO it's not intuitive.  This also needs to be more specific, becuase I'm guessing
we'll end up with more than one "kvm" LUO structure.

Maybe something like kvm_vm_luo_state?

> +
> +	if (kvm->vm_dead || kvm->vm_bugged)
> +		return -EINVAL;
> +
> +	ser = kho_alloc_preserve(sizeof(*ser));
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +#if defined(CONFIG_X86)
> +	ser->type = kvm->arch.vm_type;
> +#elif defined(CONFIG_ARM64)
> +	ser->type = kvm_phys_shift(&kvm->arch.mmu);
> +	if (kvm_vm_is_protected(kvm))
> +		ser->type |= KVM_VM_TYPE_ARM_PROTECTED;
> +
> +#else
> +	ser->type = 0;
> +#endif

This needs to be properly supported with arch callbacks.  And per-arch enabling
needs to be done in separate patches.

> +
> +	args->serialized_data = virt_to_phys(ser);
> +	return 0;
> +}
> +
> +static atomic_t restored_vm_id = ATOMIC_INIT(0);
> +
> +static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
> +{
> +	char fdname[ITOA_MAX_LEN + 1];
> +	struct kvm_luo_ser *ser;
> +	struct file *file;
> +	struct kvm *kvm;
> +	int err = 0;
> +
> +	if (!args->serialized_data)
> +		return -EINVAL;
> +
> +	ser = phys_to_virt(args->serialized_data);

KVM generally uses __va() and __pa(), is there a reason to diverge?
