Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A211E4FB9B7;
	Fri, 16 Oct 2026 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168059; cv=none; b=TlbWaLVfgeY7xJURkEFfFMkeaZ7gBaNBXBQEM/KvbbrqV6EUG8b0OY1YGZF5tTRL6eymRXZuYnSKsImYncxlgWIpm8KwHb45v+gvZBDhOJX7AOv/nR0H11A7mJZDcZX234kydR2TAHy3lljho9m3SOCAPY36lVLI9iw4RBgiUgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168059; c=relaxed/simple;
	bh=NodLDflt73PzbIVjrOPERJBgvsJMrrR6eLVxUvVw6ko=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=R5pSQX9CKLHJX04rrMiWdK0p2qYJHPucGuTGNjjqTV/YpKBX9Bc+OxOgFdBGeWv/oJVBb7bFzNwUP/aF6GC0NPfuQHjv4y9d61W0jhW8WL4zADvJnOGqU/tGcd09a12ox+sympaVyRsQnCSiXyzvPl6Oc13QeiRQJhOJAZ+twnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVvkme1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVvkme1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EAB1F000C6;
	Fri, 16 Oct 2026 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792168052;
	bh=PwEbXykUVagMexY0AJfJiX7+5vWB4ZehKXrXKc202C8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FVvkme1An90OFRWrFoOYUfw+chuxa/J/KWZZAsZyZcDL0x5kautZiyu+f4ZOOnV65
	 QLsacmIi7IPbCQk2SKSkGVPobAtcVyVC/JDb+aPjj+S4Rq9x3s7jZkymwij8EAQ0n0
	 Im+bL3APT0Rr3pesF/d3BgmEUf06VHdhQzQETF1CUE6JlCBYhxCddKNIkcFg5I8cpT
	 JfxZRmqSyjBYkjC+Y6wD6uHC/DHzcrMj0OsZB3UeqjdWFOHIFzHNAW+6JfV0l5bnmX
	 EULhwuckoXqByDN4U1z60rtx74a3LoHjBr6Xa21iz6ZPhEafFSTxsf3einlp/X+Hdy
	 oHbGixltfMrNA==
Message-ID: <sashiko-outbox-174640@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/16] KVM: arm64: gic-v5: Document ITS userspace ABI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-17-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-17-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:27:30 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: arm64: gic-v5: userspace writes to READ_EVENT_DATAR are sil=
ently ignored causing state loss
--

commit 3a4606444ec9f90ae2360e066a229c789d9eca15
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Document ITS userspace ABI

Document the GICv5 ITS device and its userspace ABI, including the
MMIO address, reset control, register attributes, and MSI requirements.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5-its.rst b/Documen=
tation/virt/kvm/devices/arm-vgic-v5-its.rst
> new file mode 100644
> index 0000000000000..250057e4445d7
> --- /dev/null
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5-its.rst

[ ... ]

> +KVM_DEV_ARM_VGIC_GRP_ITS_REGS
> +-----------------------------
> +
> +  Attributes:
> +    The attr field of kvm_device_attr contains the ITS register offset f=
rom
> +    the control frame base address. kvm_device_attr.addr points to a __u=
64,
> +    regardless of whether the register is 32 or 64 bits wide. A 64-bit
> +    register must be addressed at its base offset; userspace cannot acce=
ss
> +    its upper or lower half separately. Guest MMIO may use aligned 32-bit
> +    accesses to DT_BASER, DIDR, READ_EVENT_DATAR, and GEN_EVENT_DIDR.
> +
> +    The ITS base address must be configured before this group can be use=
d.
> +    Writes to read-only registers are ignored. Writes to DT_CFGR and DT_=
BASER

[Severity: Medium]
Does this design violate the rule that read-only attributes must return an
error on set?

A device attribute documented as read-only whose set path does not return an
error can lead to silent migration state loss. For example, READ_EVENT_DATAR
is a stateful register that holds the result of the READ_EVENTR command. If
userspace restores this state during migration, but the write path returns 0
while ignoring the value, the restored state is silently dropped, corrupting
the guest's view of the command result upon resume.

Looking at the implementation, READ_EVENT_DATAR is defined without a uaccess
write override in vgic_v5_its_registers() and uses vgic_v5_mmio_write_its_w=
i.
The userspace attribute set path in vgic_v5_its_attr_regs_access() defaults
to calling the guest its_write handler, which invokes the Write Ignore stub
and successfully returns 0 instead of returning -EINVAL or -EPERM.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D16
