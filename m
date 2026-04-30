Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088043E1CF0
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 08:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777539442; cv=pass; b=M2sMy3q8ayrObUTafyqB9FWNINT4vfbW4d9hW7k+u7bJUsBIF9h6IjIsON8hwOW27eTY3rLS5HFz+IRb6djCF2mOoqyoNSRLVD6K9BIhFnmw3LNrj4f1mPPhT7olQgA9wKe6sdXVwTOD8ZhiSWM7RPyKKKKEH1JvUxdDcQZWBwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777539442; c=relaxed/simple;
	bh=wjFl6GDkmUJl+dKx1Cia494ZvHYp6ty44K36Qbt6DgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rznOAXlFr+ZuuXMfgyAGDUNLUTxu7jwI81AH6HfwCJ6J/urcJY7++0AXozviESGRS16antDzrUTgXmnO637kPFwPSweFQ6TDOd3vfHdzeYuOdgI736hXEpf9NC9RFcpBFmUGgosVvgitPr3guv74944E8zSnIhMqkfUWnQAhwdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DfKKQLqG; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DfKKQLqG"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6501d242e2fso604924d50.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 01:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777539440; cv=none;
        d=google.com; s=arc-20240605;
        b=EY6s7lyaDDF5Tpnvd2s3dS7hDJJMVzu8x8fYUolH1Lk1s3d5jTOmlU0QfN+j1JHpzL
         6O6jKJ8jZl/Qte1y5Nf8jchl7WFzAhHt93fttu0O+0ni75fzYT/UpvEThhZC4Tzg7K+8
         d403WQhhpeVsA1sgarNDR9+8PwN49fhyOgcmpRn4buAf2Ohcoem55eOcNsOZnxXJBida
         DfMcuia8HncAkctp5/qfm+BoLQD/MMUWD6QYjoECK+nIVgTRSXYNYNoLm4EGAKzDuVB6
         prhElXVOqY7wIs/WM5SfUHwhrMSFvf2Gta5DFAMkWn51CJHGKYU8BoxqBMZOqBsAnTft
         yhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WHn7aNKe8Z0UpZANHbjAHiTC29hYbOiQjktEyz/Ro2M=;
        fh=/LN/A1EwizDcfqVO1nhCJeUTr6WxZZi+ucuvuRFE2gQ=;
        b=jRLC2KfXPg+Ny6wnmxh1s0uT/E0eOW1tpV9vAwdWMuVeoOHw8Mkid2pvk5J9ZVzhaq
         ReWgxNQTbjGjQCkrETmejPy/aDdwt8BUIAF8m5ZfWzbmlPk7urGCVsum9N5wbcm2vhac
         PFxe8lmAMv7+cTH2/sn0v8heTrh0BtlSHYYoiPnWsxRLpn9STQmDt3RR7SAboglHaHTc
         QU/th0CwYRag9+QONVi4BjyFngZj9umHaIyf5w8SZc3k0P8I+RWc7LqCDVrQ9eQKcNmA
         nvsTjiRAygYno4Tanf6f3RQYDOOSTh86XXf9mnhi2lNTB9DdltlSPTUfLcGe7dHOVO2U
         terw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1777539440; x=1778144240; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WHn7aNKe8Z0UpZANHbjAHiTC29hYbOiQjktEyz/Ro2M=;
        b=DfKKQLqGPw0ivQqeNPrU+ZGg4/3KXxnukaCbL9G2jg5wK2WG59wn3GQMn+gx0Pzoi3
         5Vy5l1hS5W21gZ/k5Zpe5FgpW8TezsALXqRGqLVP5S3yKS6+i0Uy2pQjqha1AaGddY0g
         GBs1S3PY093MfpuX9h6ahaV3VFnUmpzWzu+V7pGLGsJlpWygBK9MhBnEy4uvmpzJqliI
         k+R5jz8C5wL9GvkdpVqDkLl73ni+24MsgB8MoZYWqVUK72sVOlmhFnd2I7ztVdmrit1j
         muLiE0uSG2yC7VqqNbP8ymJ7mprSYrO6g8OfL6NpZ8ogkP2WAxe/aCeB1pCIjGrm6XaA
         65BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777539440; x=1778144240;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WHn7aNKe8Z0UpZANHbjAHiTC29hYbOiQjktEyz/Ro2M=;
        b=k27LZmzMLIrbWaC2IhZKmQi5wp0QaG0O5m0CsRAu2/fjnBtK44/lz4SZ4NYZEnc9qT
         7JiIAfDIYNRzI/PRyc1JEoMLRqN+J4CoQzUwsHI5sP2FLKMNkpJ6lI3LlBlJmhLe95VZ
         fhzW62+Zw5DkTbyn3Ox/Zd/TPGcxTJYXyxm/UGyouHrySehNXux1d1VAcky7gQT9duy3
         9cV/uPitixn67Bvn5PzyuINgKL7s1KHWSfvjQd45+ZyMfmUUtKzxhPc/9aH+UPP+y8a+
         kFTOhKvqH2WvGIXDpvGqOqWrirS9E4rdKxCemYzgzjZXwoPHAiiYgW11C/HKqySDEXn8
         Z7Lg==
X-Forwarded-Encrypted: i=1; AFNElJ/e6Zc8/nD/kgsbVPGuDJmUNp5g9P0dMUXzO/tN3Zh0LuCQGAeiLb9zI+GGKyrlMhh8tykZb2M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8U6YdBZjj6wiGGj26Ij3Hmsb+K4d+qPaI/TApSrbVKuGf1MMd
	ZhWpKFvtE5agw8tAgx9ahbfgcs85pxQvvJkR+Yrg9VQuq2IeFCaA/qaZ7OcQKMtsP4PN7jB+1Tw
	2UPvY5T7NHDXuHvaL8AoJ8w8d0ypnm1GYqn0xPetSlg==
X-Gm-Gg: AeBDies4/M2K1jRHP6R5iRdYO4a2Vt9WPZI1A6HjOWrLGOPCenQAMs2LDzBYy1Xafpb
	DcECK9S8f7n4yDAaMXsaOO6KiXDZb3TQjYGF+0GjWSG7gCBjjoM9FDDTD5OnK14jPkiy6B7QGB9
	Jt+11gjnA2CiGINpyeGcCTLaf17MVUDkore8H2tdO97nMJEN30g59Dw8Ganl0xuYOHA3oR1Hy8N
	kXtwkfd44pg5ebqlI4jFXFul32P94ox1Qb4ucNMzUAQipV1cYtbw/+1puf4LkMhCknWPhQ6Wn3f
	mJb/uEh2+sfdb09ZO2nWMmhKCzQdyZv/S/f9mgslkf0iowlWbPChZyIlaQJ9MgXxSyHpeuVf2MW
	tDg==
X-Received: by 2002:a05:690e:1698:b0:651:c782:6a8 with SMTP id
 956f58d0204a3-65c18b3e650mr1335368d50.15.1777539439953; Thu, 30 Apr 2026
 01:57:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260427160547.3129448-1-sascha.bischoff@arm.com> <20260427160547.3129448-44-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-44-sascha.bischoff@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 30 Apr 2026 09:57:08 +0100
X-Gm-Features: AVHnY4Jvy3n3XpKrxh1FlvrSB6Vt4VXuFhqD0yDhLAN5iHhEm91Tb3vWrZI7GfM
Message-ID: <CAFEAcA8m1Y-8=+7RZjte1WBwycgnHEx_+yiU_ieriZr5DbQKsQ@mail.gmail.com>
Subject: Re: [PATCH 43/43] Documentation: KVM: Add the VGICv5 IRS save/restore sequences
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 17:22, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> When saving/restoring the state of the GICv5 IRS, it is important that
> it happens in the correct order. Failure to do so will almost
> certainly result in failing to restore a guest that is capable of
> handling interrupts correctly.
>
> On a save, the ISTs must be saved prior to saving the guest's memory
> as the guest's LPI IST is written to guest memory. Conversely, on
> restore the guest's memory must be restored prior to restoring the
> ISTs.
>
> It is important to restore the IRS MMIO registers by first restoring
> the IRS_IDx registers as they define the capabilities of the IRS, and
> are used as part of creating and managing ISTs and SPIs.
>
> In order to restore the ISTs themselves, the IRS_IST_CFGR must be
> restored prior to the IRS_IST_BASER. This is because KVM extracts
> fields from the CFGR to determine the size and structure of the IRS
> created by the guest. The IST itself is created as part of the write
> to the IRS_IST_BASER. At this stage the remaining MMIO registers can
> be restored.
>
> Once the LPI IST has been created (by the aforementioned write to the
> IRS_IST_BASER), the IST state can be restored using
> KVM_DEV_ARM_VGIC_GRP_IST. The SPI IST gets extracted from a userspace
> provided buffer, and is transferred to the host-allocated SPI IST. The
> LPI IST is extracted from guest memory, and is written to the
> host-allocated LPI IST.
>
> As a general rule, the IRS_*_STATUSR registers can be ignored on
> restore. They are not userspace writable.
>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  .../virt/kvm/devices/arm-vgic-v5.rst          | 63 +++++++++++++++++++
>  1 file changed, 63 insertions(+)
>
> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> index 38eef7cc63e3e..1c55f5040757d 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> @@ -201,3 +201,66 @@ Groups:
>        -ENOMEM      Restoring IST state failed while tracking pending interrupts
>        -ETIMEDOUT   An IRS save/VM operation timed out
>        ===========  ============================================================
> +
> +IRS Save Sequence:
> +------------------
> +
> +The following ordering should be followed when saving the virtual GICv5 and
> +IRS:
> +
> +a) Save the ISTs by issuing KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IST.
> +   This MUST happen before the guest's memory is serialised as the LPI IST is
> +   stored directly to guest memory.
> +
> +b) Save the IRS MMIO register state in the following order by issuing
> +   KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
> +
> +     1. Save IRS_IDR0-2 and IRS_IDR5-7 registers.
> +     2. Save IRS_IST_CFGR.
> +     3. Save IRS_IST_BASER.
> +     4. Save the remaining global IRS MMIO registers.
> +     5. For each PE:
> +        - write IRS_PE_SELR
> +        - save IRS_PE_CR0
> +     6. For each SPI:
> +        - write IRS_SPI_SELR
> +        - save IRS_SPI_CFGR
> +
> +IRS Restore Sequence:
> +---------------------
> +
> +The following ordering must be followed when restoring the virtual GICv5 and
> +IRS:
> +
> +a) restore all guest memory and create vcpus
> +b) provide the IRS base address by issuing KVM_SET_DEVICE_ATTR on
> +   KVM_DEV_ARM_VGIC_GRP_ADDR
> +c) initialise the GIC - this sets up the default state and creates the SPI
> +   IST - by issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_CTRL with
> +   KVM_DEV_ARM_VGIC_CTRL_INIT

This isn't going to work for QEMU, if I understand it correctly.
QEMU always creates the whole VM first, including creating the
VCPUs and GIC, telling KVM what its base address is, initializing it,
etc, before it starts an inbound migration. So the memory read
is going to come in after step (c), not right at the start.

> +d) restore the IRS MMIO register state in the following order by issuing
> +   KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
> +
> +     1. Restore IRS_IDR0-2 and IRS_IDR5-7 registers.
> +     2. Restore IRS_IST_CFGR.
> +     3. Restore IRS_IST_BASER - this triggers KVM to create the LPI IST.
> +
> +e) restore the ISTs by issuing KVM_SET_DEVICE_ATTR on
> +   KVM_DEV_ARM_VGIC_GRP_IST.
> +f) restore the remaining IRS MMIO register state in the following order by
> +   issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
> +
> +     1. Restore the remaining global IRS MMIO registers.
> +     2. For each PE:
> +        - write IRS_PE_SELR
> +        - restore IRS_PE_CR0
> +     3. For each SPI:
> +        - write IRS_SPI_SELR
> +        - restore IRS_SPI_CFGR

More generally, if your API involves this much in the way
of complicated ordering dependencies, it's going to be
very bug prone.  From userspace's perspective, this is
not a very helpful way to design the interface :-)

thanks
-- PMM
