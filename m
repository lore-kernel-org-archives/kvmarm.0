Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5108B2F8BC3
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 10:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764153402; cv=none; b=jP9O1zawKTmZISS6e616rkIw3lHIe4GwRPXv4cEZ6CB8QnMO2xhDy6sZNMQB5ZNY9gzcaD5NCId75DpaM8uIi5py8IU5EUeUqW75DvOzePkMviwPLvy6GJj2P20G7idS7tnktEmAQQ4C1SWnt2yzUJijqiCd7Psh7V+OWSbQQUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764153402; c=relaxed/simple;
	bh=xCxvtYb6dGsNaT+EoBR6622rea3oJyuAS/8ZK5qSnok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iwE+jpfonL7sBIdQVcF06EjVULdocxe2z0VvxoNV7Q/PLbQuJZ/FzXoJqdWyczvXtkqJyl5InqiaFxIBRNjc6OOR/oherYyJylj+Jl1zLmhxYiW3B452TP9DM17sWAO2CzS7HpO1K1/XmY5JRwwozUvWHiyOf9ktG8nH+YYVtVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U20qom/v; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U20qom/v"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4edb8d6e98aso319171cf.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 02:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764153400; x=1764758200; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P7pHNmd+OftDcBNWJEe007EP303xNpyOITe1eHb8D48=;
        b=U20qom/vwyVajTRQdCM88LCMW7M/Occqc9CHVR63M5itTJ6xj+BCFvjPYITzmn1OuK
         dPDUhujyUZb1Z0RZYBHaU7lU7yOldW66757psw2m3R+EfSgi13GjaAi30bcEgwIrsU82
         HOlLJV3L6xoRkwJP97JOtKTscR4I8W4RRBquxhT2GbS7v4zzKV/ko6FR2noRWQNUfl2h
         gV9w/yn6i473KJfhAbzevct8g/G3eUzyMTXOpW14eVeMy51WRxXSu2yFMmErON1yN17y
         2X3092WGxhMpZcvSbmwZaZY3t7t8AI3jsRgC015hcObJzJzstlWyqyj87rORcgmr6HuL
         ChSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764153400; x=1764758200;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7pHNmd+OftDcBNWJEe007EP303xNpyOITe1eHb8D48=;
        b=Ee7Uv6uRRro1bdjl9oNZzBQxDG0nLYpe9Ve3O/7Pc8VIl3SexET+K7Kw4Asky/wR3+
         03VLg1Pnlrs4e0WYGwxPIDlyV5TimxOqk2f3orpcLDWczsUrBzn6RK2ZFEgj85ZsUQA5
         4SFHR1YwRVh/8O/GhCaKTU9uv+kochb8/3VpXjahyIy5cYClY0aw9Y8VJa4RzcjJrSDJ
         yaJXNFq2XIP2HiwiRI9KOA0B8Z0kbMsX98/mbKnbVTsB2UZGopXdgQI+bPwFxDE4+zlq
         qPlyPeghcHgqL6YsvANQ6HZU1b7YBUD/urqOzqZWnyyzD8eC0ncUEaYE+N8A7J7M805C
         xfcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbO67wkyL1RLw9tMhB/W+ztFAER/zCKXUPk8dTSeNb5Ty/rLtDFaWjGzHhEIo+4DyUXD+1gM8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yye9cLpHqKi4cApUWCv0wDrbuTa/yEJLaY4CK/PFwm/OIu/9BWU
	00I3ZDbbhchaURv8UUjFC7x00hiWa26W0QYx3x5pmb6eCQCZQ0yf2tbmrppHmvO/EZ9o920pZOs
	kwhJ5EOuqTe05bw71lyTVYToBm5M4NYzmmgnJltFQ
X-Gm-Gg: ASbGncu9XicBQDiiZZKxWPMz57WNJ5QO00ebQ4JiDq6gFJR7OxDkuAdYRbv0P6pX6z8
	PSOUGIRwbjBB1cKWovDqe6oALIyusbEw/NA4ojS7j9hOa3N2PqdQdCWEYaRn1OFQqZ7Ec0aYaEH
	iLJvOjvkLUXKDlW88hUpH6UL3nPWMSrnSoyg6vgq6qcm2/ApLyP9cJMZu6SCGh3VXk0kSwSCATb
	yAtXQBzHP0YVCCDk4lHP5zp+VJAqB9Gj+CZhyLDqQv51R0/sDDyW0WoeRK82bwBS+l3cpmZbFVt
	3qwwJMxx3yjWgk4ZE8VakKC6
X-Google-Smtp-Source: AGHT+IGkh9T1GrCUEpS5l062Fy5pAu9uCk7G2i8OmKE8/iyKVeVmXdLFKhDA+YJ8ohA/lcPy/RaaxUQsbDdHP1RbJY0=
X-Received: by 2002:a05:622a:14d1:b0:4e8:b245:fba0 with SMTP id
 d75a77b69052e-4efc6c8b9d2mr4049881cf.14.1764153399930; Wed, 26 Nov 2025
 02:36:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com> <20251118103807.707500-3-tabba@google.com>
 <868qftqehe.wl-maz@kernel.org> <d94e17d3-41db-42f8-8039-e1d6a694788c@linaro.org>
In-Reply-To: <d94e17d3-41db-42f8-8039-e1d6a694788c@linaro.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 26 Nov 2025 10:36:03 +0000
X-Gm-Features: AWmQ_bk-AItuaclLZ-cyhTHY0J1L0Rx-tqJp1c-Q_vTQeqTrS2IzHT0qxOGJA1I
Message-ID: <CA+EHjTzizVuHXeULzyiV8cetcGMXHro=-UeqWb=cFKf1tR0aZw@mail.gmail.com>
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: James Clark <james.clark@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi James,

On Wed, 26 Nov 2025 at 10:29, James Clark <james.clark@linaro.org> wrote:
>
>
>
> On 26/11/2025 10:23 am, Marc Zyngier wrote:
> > On Tue, 18 Nov 2025 10:37:59 +0000,
> > Fuad Tabba <tabba@google.com> wrote:
> >>
> >> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> >> register accesses. These accesses are trapped to EL2 when the bits are
> >> clear.
> >>
> >> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> >> had the polarity inverted. When a guest did not support the Trace Buffer
> >> feature, the code was setting E2TB. This incorrectly disabled the trap,
> >> potentially allowing a protected guest to access registers for a feature
> >> it was not given.
> >>
> >> Fix this by inverting the operation.
> >>
> >> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> >> Signed-off-by: Fuad Tabba <tabba@google.com>
> >> ---
> >>   arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >> index 8d06a246dfd1..f6f8996c4f97 100644
> >> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> >>              val |= MDCR_EL2_TTRF;
> >>
> >>      if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
> >> -            val |= MDCR_EL2_E2TB_MASK;
> >> +            val &= ~MDCR_EL2_E2TB_MASK;
> >
> > This does not only change the trapping logic (bit 24). It also change
> > the ownership of the buffer (bit 25). I wonder whether you should do
> > something for that, maybe by clearing TRBLIMITR_EL1.E, because
> > otherwise, you keep tracing, but using an EL2 VA. What could possibly
> > go wrong?
> >
> > Overall, I'm very uneasy about TRBE in the context of pKVM.
> >
> > Thanks,
> >
> >       M.
> >
>
> Don't we already clear TRBLIMITR_EL1.E in __trace_needs_drain() for pKVM
> when switching to the guest?

I don't think so:
https://elixir.bootlin.com/linux/v6.18-rc7/source/arch/arm64/kvm/hyp/nvhe/debug-sr.c#L60

Cheers,
/fuad
> James
>
