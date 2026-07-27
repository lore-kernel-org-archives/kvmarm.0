Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CE351C28
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 18:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785178635; cv=none; b=sx+eFFF3pven0UFQ8mBiy70DwTyiWOd/xmPOLHPHPzi/6D51G98MolxDKNi+48CoYqDIRqolp4csxDj0otss7at7q8ym+eQm8tTAemusAyXY6RS+ATEqtd+0cIjHZEQtQXndp8cOGJv0FCtGMB3pf4RxBJ171sKhoPDB8MVJWic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785178635; c=relaxed/simple;
	bh=bqOvEoA0wbjyhBGt0+ID4SuwhzJGpC13q9w3ojc1bJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B5ByZi1jK8dVbGt+iHe8BaK2gcCOiXgXo3Yif53uXdZfxvVhN6N8lzYeIZAsUnfaUTXpZ3t7ddLSuUBsHhUFsiS2FhPXaMnUnHJ4M+1ByjZjxIDU3Vx+tybQREixs/oNzfrmtp0SpngP24eRmS4vk4BI4n7SgIgiimkvVYTA6hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D+MjbT0G; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D+MjbT0G"
X-Forwarded-Encrypted: i=1; AHgh+Rpd3Nwd1Nk7LcvE6pM7J+bqEjKjLLjuEhK3IZ5us7DI+oQcTtMbZh+ko5ajBsdrpRl0ARq3sOY=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785178631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gm6ClMxDHl1RHD/LYyh3fIvbnsL96xbpC1rOSYoANHM=;
	b=D+MjbT0GTMuu3nrsrZaHHwmangFHcdnvZC+Ue3aYJPcF/ANA0RX/T9h+6ngs+ukqZa8+EF
	W5LsL6zUltqSnTm9FJo/MLppOpANKqN6U9Eg7W6Q4YZQoU7XQ8IUA4fJUa361aSvLB/1mq
	Gh9OG/Ie2pekoq86ln+azgq7lGD5AnE=
X-Gm-Message-State: AOJu0YyZQRuCy91ohugP+fK/ZX6by5zlxk/tEZAY59r4rk68Z3gia4Qy
	IEH7pM62GPWpfU2qq8QpYqjIrE5WnvvDrUP8mffVVWjavabocL0jI/OW2isons3ujWXlUzrkasb
	842DsNhsI2CfTKmOFEjynHk2XAOtd29IcV6ZPckd1
X-Received: by 2002:a05:622a:8c17:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-529a5be6c10mr43504311cf.0.1785178617971; Mon, 27 Jul 2026
 11:56:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260724104819.1296803-1-sascha.bischoff@arm.com> <20260724104819.1296803-36-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-36-sascha.bischoff@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 27 Jul 2026 19:56:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwrx6Ce4LMHFz9MNGo87PvFFHxEOY7Dqrk85j3W+wDtxQ@mail.gmail.com>
X-Gm-Features: AUfX_mwQzqMQPZddkwxbGWErEu-Qxdpoh07vMkc0A1I1hb4UcJBkVU3n5eDAtDc
Message-ID: <CA+EHjTwrx6Ce4LMHFz9MNGo87PvFFHxEOY7Dqrk85j3W+wDtxQ@mail.gmail.com>
Subject: Re: [PATCH v4 35/48] KVM: arm64: gic-v5: Implement save/restore
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

On Fri, 24 Jul 2026 at 11:58, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
...

> +/*
> + * Save the LPI IST to userspace memory.
> + *
> + * The LPI IST may be linear or two-level, so host iteration depends on the
> + * allocated host shape.
> + */
> +int vgic_v5_save_lpi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_attr)
> +{
> +       struct vgic_v5_ist_desc ist;
> +       u32 __user *uaddr;
> +       int ret;
> +
> +       ret = vgic_v5_get_lpi_ist_desc(kvm, &ist);
> +       if (ret)
> +               return ret;
> +
> +       if (!ist.present)
> +               return 0;
> +
> +       uaddr = (u32 __user *)(unsigned long)ist_attr->lpi_ist_addr;
> +
> +       if (!ist.vmi->h_lpi_ist_structure)
> +               return vgic_v5_save_linear_ist(&ist, uaddr,
> +                                              BIT(ist.id_bits));
> +
> +       return vgic_v5_save_two_level_ist(&ist, uaddr);
> +}

This bounds the walk with the ID_BITS stamped into the VMTE when the
host IST was allocated...

...

> +static int vgic_v5_validate_ist_attr(struct kvm *kvm,
> +                                    const struct kvm_vgic_v5_ist *ist_attr)
> +{
> +       unsigned int id_bits;
> +       int ret;
> +
> +       /* We always have SPIs to save */
> +       ret = vgic_v5_validate_ist_user_buffer(ist_attr->spi_ist_addr,
> +                                       ist_attr->spi_ist_size,
> +                                       kvm->arch.vgic.nr_spis * sizeof(__u32));
> +       if (ret)
> +               return ret;
> +
> +       /* We don't always have LPIs to save */
> +       ret = vgic_v5_irs_lpi_ist_id_bits(kvm, &id_bits);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* No LPI IST */
> +       if (!ret) {
> +               if (ist_attr->lpi_ist_addr || ist_attr->lpi_ist_size)
> +                       return -EINVAL;
> +
> +               return 0;
> +       }
> +
> +       return vgic_v5_validate_ist_user_buffer(ist_attr->lpi_ist_addr,
> +                                              ist_attr->lpi_ist_size,
> +                                              BIT(id_bits) * sizeof(__u32));
> +}

... and this sizes the buffer from the emulated IRS_IST_CFGR. I think
the two are using different values, and I could not find anything that
re-syncs them.

The two writers of IRS_IST_CFGR differ: `vgic_v5_mmio_write_irs_ist()`
returns early while `ist_baser.valid` is set,
`vgic_v5_mmio_uaccess_write_irs()` does not. So userspace can restore
the IST, stamping the VMTE from the larger LPI_ID_BITS, rewrite
IRS_IST_CFGR smaller, and then save with the matching smaller buffer.
`vgic_v5_ist_cfgr_valid()` accepts down to IRS_IDR2.MIN_LPI_ID_BITS,
so on a part reporting 0 that is BIT(16) entries into a buffer
validated at 4 bytes. `test_vgic_v5_ist_save_restore()` in patch 48
already restores and then re-saves before any vCPU runs, it just does
not write IRS_IST_CFGR in that window.

arm-vgic-v5.rst says the LPI buffer size must be BIT(lpi_id_bits) *
sizeof(__u32), "where lpi_id_bits is the LPI ID width configured in
IRS_IST_CFGR", which is the value the validation uses and not the one
the walk uses.

Adding the `ist_baser.valid` check to the uaccess path would break
restore, since the same file says the IRS registers may be restored in
any order. Validating against the value the walk uses, or rejecting a
save when the register and the VMTE disagree,
both look workable. Bounding the walk by the register instead would
read past the host allocation whenever the register is the larger of
the two, so I do not think that direction works.

`put_user()` targets the caller's own mapping and the host-side reads
stay in bounds, so I think this is a correctness problem rather than a
security one. The SPI save uses `nr_spis` on both sides and restore
stamps the VMTE from the value it validated,
so only the LPI save looks affected, linear and two-level alike.

Cheers,
/fuad
