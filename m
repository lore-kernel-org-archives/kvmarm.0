Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F5F32145A
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 14:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763130086; cv=none; b=DEFhdoVnv6Lg0uEpwienzx12/Jkrw3MRMcC8kR/9Ln1bfOKEUcWurY0IFCsMfdTIOGTh/1jc/pRinWhaRKY3HjBscH7MQK1ZDxsYKXccgDlOmy5dYJMZRk+iRyL1fDgVfyZCJDWG7UsuvrtU5/sVlRONq4p9T75N2vphx4gsX3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763130086; c=relaxed/simple;
	bh=CRbKex889t15hNnEaJZ2L2WSxzJx+xzomjJ8renljCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d/oZXRvcpj5FQzjObyuuPaw4cm3DeVzytUNzx0mFC/kwC0yy4uR2KgJ8uFmKS2T+zqXb4fs2rHNNIdQ9mEw96M8liKrDoB4UTOazy/XqUxC/dazW1k89CobcPVC1O8YcPLPc1JFzpmv20KIq366CweCJqE33MT1iekZXTYufoGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rgp6Kz/0; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rgp6Kz/0"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed67a143c5so299591cf.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 06:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763130083; x=1763734883; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iebc9wAbiB5E5IOqak411hyeSp97Jf8NhK9FIOstGQ4=;
        b=Rgp6Kz/0tDClGRMklvMhfFqjzqevBPLIG5Y72LT4HPgi9PGbf0jZflhczHLgoYLcrm
         DL3FO30zVdAWEM6six/6zQqIPu2Bp3lKEd8Z4SC+XdSeWqyVOhO8kcnGYSSEJHyw8wBw
         ic5gBoZPo9WRfraKqQ557BFCeusfYSQPAypTALCMIs5gzH571Yr1uGvGEKlYkSX/ExKS
         wm/zzY3TsvgbiLJeJk4qfI7k6A7wI73ryQ5CUNa2CXTvNa27gyRvVBOW28ZeTxi36xuC
         LFkEf/PyIC0jBx19Driti6kVOEXZ2pzOqhkegPAq75F5f7VTXvj7m4waPi3gFUJa3XRM
         LOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763130083; x=1763734883;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iebc9wAbiB5E5IOqak411hyeSp97Jf8NhK9FIOstGQ4=;
        b=ITa3KdBW4Iy23E5uskxZzgA0vrX9cWSTX/hoTsVzCoSCae4TTdEUiDfVcWv33YlaLl
         8pZgYyzJdx1NA3eryll9YfTuuLxT2aeWe1/2PjIW/foXbr6O3YNJU5OyZPc/eg5VQro9
         wWYCamyLH6sdhJKQeZqJhb+0nWL5/Xic2bcNXPgcmqJLVUqe/Lfyx+lrLr+h+Q5CoEXJ
         dROw/A9s1kufTCH3i8tmlZqwwimrJ7xvVwsQFLILNqM4mEybQthUfb3zyPxap1p7ZqBM
         ggtCy623Q9JJBnrQiNI5eilRf0wOi1Y9jie03FrUr41BmIC1FPi1lYaxuJ7cD/WTc9Px
         HhFQ==
X-Gm-Message-State: AOJu0Ywltvq9ODpHrlRqjYoy0LNOyA38LpBA+4GntA5Zxll/H2kv9Xf9
	XALmptSaWvV/sW1P4NmJr8TFPISXuYL7ynzyVUwCiXtOtuX9KBx7M0VXD1c5LsVewaUMssKJnBK
	4EUNnIdUhbUKw6V1eHbL18ltm9l465/gkz7GQBnsq
X-Gm-Gg: ASbGncse5ebyioNOMdyXIhj49DBRTJjfTxhnL7WIcxnuZ0CNTbsukU/R6+uYgNTXn0h
	pRuqLqF8CLw3GtTSyilIvyEXNW4JYFq6Vmn9wZ7ONaCSTkMmisyk0B/vFWkpLEKgWDVVrPVIzZx
	wI/ocTKjffP8WH6AGzd907dL6hamLjHaswUoDIQ/CUYe6MBd70/JHgreqBTvPy2QbmCNjyCBMHj
	m0X4WU50GjroG/HSwWR7iZJISxxSKkTpgS0AZKFafr6CU7h6NOUaDOBAFIFjMcnkeVYEOC73XG8
	evoDm6G1wKzfLYe7
X-Google-Smtp-Source: AGHT+IE5Oe19RaLFBsVRY5odgzBmRaaiSdzxsgMGjxiUojw4mI94n9CHnCtVAFThAGs6iI94m/QfSBQkFZ6pjRXMhQg=
X-Received: by 2002:ac8:580f:0:b0:4e5:7827:f4b9 with SMTP id
 d75a77b69052e-4edf47135camr5213031cf.3.1763130082793; Fri, 14 Nov 2025
 06:21:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251109171619.1507205-1-maz@kernel.org> <20251109171619.1507205-30-maz@kernel.org>
In-Reply-To: <20251109171619.1507205-30-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 14 Nov 2025 14:20:46 +0000
X-Gm-Features: AWmQ_bkph9z6RWKdMnig0aZ2huiMgSjHMys0UY_nuIP5-xDzsPT50bNsv9UL6s8
Message-ID: <CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com>
Subject: Re: [PATCH v2 29/45] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when
 interrupts overflow LR capacity
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 9 Nov 2025 at 17:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we are ready to handle deactivation through ICV_DIR_EL1,
> set the trap bit if we have active interrupts outside of the LRs.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 1026031f22ff9..26e17ed057f00 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -42,6 +42,13 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
>                 ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
>         cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
>                 ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
> +
> +       /*
> +        * Note that we set the trap irrespective of EOIMode, as that
> +        * can change behind our back without any warning...
> +        */
> +       if (irqs_active_outside_lrs(als))
> +               cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
>  }

I just tested these patches as they are on kvmarm/next
2ea7215187c5759fc5d277280e3095b350ca6a50 ("Merge branch
'kvm-arm64/vgic-lr-overflow' into kvmarm/next"), without any
additional pKVM patches. I tried running it with pKVM (non-protected)
and with just plain nVHE. In both cases, I get a trap to EL2 (0x18)
when booting a non-protected guest, which triggers a bug in
handle_trap() arch/arm64/kvm/hyp/nvhe/hyp-main.c:706

This trap is happening because of setting this particular trap (TDIR).
Just removing this trap from vgic_v3_configure_hcr() from the ToT on
kvmarm/next boots fine.

I'm running this on QEMU with '-machine virt,gic-version=3 -cpu max'
and the kernel with 'kvm-arm.mode=protected' and with
'kvm-arm.mode=nvhe'.

Let me know if you need any more info or help testing.

Cheers,
/fuad


>  static bool lr_signals_eoi_mi(u64 lr_val)
> --
> 2.47.3
>
>
