Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D0246C4A5
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648567; cv=none; b=RSvhy88zUeS2mRSTyy3VVlvOSnSOhO7BAFoRuxBt63l7y98KOnz5NtwBFd2Wdc2Lgpq9rSKfiCvuPgODPrUMhqaqQBNA4ZYQi+KRKKkQud2r8Euoq88vND9TkCIHpt0Ow/BuLg1MJq2N321s4mnYMCv07XJn56/7DBit2SI0vR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648567; c=relaxed/simple;
	bh=dEg/xk5pG1vBiItxvEEZyeqvpuox2nryklNQjghqD3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aVtAFa0HClHNPA+XpjOHnFHQ2LoHys2MHETcxiYRD5/9kmteFGWqkJ8sGX3E1y5qewAUeYQMb6DbG1aNV5ZE4OrZx0yLCW4ehRGASXOlx0c+/qAHiwZNsgpQ0cKd4f+k4h0LA2ILdV4TDR3VHNOtQJbgYpJk/NFguh3mnXvLSAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U3AA/wH5; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U3AA/wH5"
X-Forwarded-Encrypted: i=1; AHgh+RrfyZuQ6e77lszY/GC3AJ5nN8E3IrTtk3gpg3sZKPNsBx5Fs0ZEiiHYB9tiTeANHet0E83ij4w=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784648562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fWBKtHpQs7Mjv5sBBU83pNN7Nd/6AUX8CaJlXFspUiY=;
	b=U3AA/wH5WZnLIBNlitthruHFWkjR6ddCZliEqBbSd9q64wY/ycGV3SR0hgl8YAVLoP8Le1
	JUPioe0ib0hVmTmaWsy5CMTdjvBiGg4zE4B6HQ3OUHgKLu9LnIkS7lk88QGaCWihm5xNb7
	786RtQDEsUgDXWWGOS02SVwqDb2QFTI=
X-Gm-Message-State: AOJu0YwtdpuMwJFcgvhsNjBzmsSpF5iBHLm52FTyydirQ4Z8MLHT9NmY
	0825gKdkEhQZxCf82Fm9ZxNvHgd8B+y7l5Ev0iT7rs3WfZKT7SSGBLZ6Wwb+suDCa2nsmTa0HtW
	O5jsXgfL9SgfKhIWDnTGAhogs47Fl8Vq870cT81ML
X-Received: by 2002:a05:622a:d0e:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-52601f03537mr16476711cf.12.1784648547786; Tue, 21 Jul 2026
 08:42:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260703154811.3355680-1-sascha.bischoff@arm.com> <20260703154811.3355680-37-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-37-sascha.bischoff@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 21 Jul 2026 16:42:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTybDSAgr44jXNFnssnYq_vVeuZ+1qORS8f4dtQgMzOZ5A@mail.gmail.com>
X-Gm-Features: AUfX_mxjsFrqC8Gpjv6b_a6EYXug8lYIGCF5p9ytlWNhOuKnl9fC4c65x8uK9Mc
Message-ID: <CA+EHjTybDSAgr44jXNFnssnYq_vVeuZ+1qORS8f4dtQgMzOZ5A@mail.gmail.com>
Subject: Re: [PATCH v3 36/40] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>, 
	Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Sascha,

Two things about the new KVM_DEV_ARM_VGIC_GRP_IST interface. Both are
about the userspace ABI rather than the mechanism.

...

> +int vgic_v5_save_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +    u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
...
> +    for (unsigned int i = 0; i < kvm->arch.vgic.nr_spis; ++i) {
...
> +        __le32 *h_iste_addr = ist.base + i * ist.iste_size;
> +
> +        h_iste = READ_ONCE(*h_iste_addr);
> +        ret = put_user(h_iste, uaddr);
> +        if (ret)
> +            return ret;
> +
> +        uaddr++;
> +    }

The kernel writes nr_spis * 4 bytes into attr->addr, but struct
kvm_device_attr has no length field, so userspace has no way to
declare how large its buffer is and the kernel has no way to check it.
The size is implied by nr_spis, which userspace set earlier through
KVM_DEV_ARM_VGIC_GRP_NR_IRQS, or never set, in which case it defaulted
to 32.

put_user() has no idea how large the caller's buffer is. It only fails
if the address itself is not writable, so writes past the end of a
short buffer land in whatever happens to be next, with no error
reported. The documentation states the required size, but nothing
enforces it.

It is also the only variable length buffer in the VGICv5 interface.
GRP_IRS_REGS is a __u64, USERSPACE_PPIS is a __u64[2], GRP_NR_IRQS is
a __u32, and none of those can be got wrong.

kvm_device_attr itself is fixed, so no length can be added there.
Changing what addr points at is still possible while this is unmerged,
but would not be afterwards. Would it make sense for addr to point at
a small structure carrying an explicit size, so that the kernel can
reject a mismatch?

The second point is the LPI IST going into guest memory. I understand
from the commit message that the shadowing is deliberate and that the
guest has already allocated the storage, so this is about the
interface rather than that decision.

Saving the ISTs is a KVM_GET_DEVICE_ATTR, and it writes into guest
memory. Several of the documented ordering constraints are enforced,
with -EBUSY when the VGIC is not initialised or when a restore is
attempted after the VM has run. This one cannot be, because it is
about when the VMM serialises guest memory:

> These two steps may be performed in either order. However, the guest memory
> must be serialised after the ISTs have been saved, as saving the LPI IST writes
> the IST state back into guest memory.

A VMM that snapshots guest memory before saving the ISTs gets no
error, and the IST contents simply never reach the destination. Live
migration looks fine to me, since kvm_write_guest() marks the pages
dirty and a later pass picks them up, but a stop and copy save done in
the natural order would lose them silently.

Was a userspace buffer considered for the LPI IST as well, the way the
SPI IST already works? That would remove the ordering requirement
entirely, and by my reading the worst case is 65536 entries at 32
bits, so 256 KiB, given the 16 bit clamp on the guest's LPI ID bits.

Cheers,
/fuad
