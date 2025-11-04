Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6CE163
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 13:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762264207; cv=none; b=Vr+tEq54pLoieSRILKhM+zuKMsjw2pbHju3o3UrSA81tX8N+RSy5JtLQH8Ef2iT2cFbW19MXg+6EjH+ChBSSwsevv/gCLqE0+9KC/ssGUu76wbogZwvGVqpmsFUNJN76EvSYWFcAyAuK96qS3zpViN9cCp578/y5KNMpFYa/fRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762264207; c=relaxed/simple;
	bh=sqT2t7VcSbwbr2pC7P2ignTzairw08b+9P/v3ynnETM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M0XEzk2xE2Kdg37VB5es25Gd/0X7b7PsCGRcuP4fTpBcWPg2zR1/qraLmTD3yGEqZfsbtyxOnKYl8lsU3rh+/M8r9E+TufUBCNTez95hJ6Sw0Rxzu8s6j0re5Odr2pZiaN8R2b7ILi8ZVjUhhs/aoi8MdQ/1vAEeK0BATLxW35M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zQqeJGJh; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zQqeJGJh"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso334381cf.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 05:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762264203; x=1762869003; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e4PZUJriZ6o5oZdswvVmoADliWthbllAlriaIosIncM=;
        b=zQqeJGJhdlf8eFIHyJGbmaA+JJVwEH4+1WihTyNR3l8cANd7wtpMF8NBgAUmgu806+
         ZLTSSHWbA+cCPXG1EeoKVdOyea4ZxSFAySGyBYt/5OhHMqu4bjYrUCUwlINdFA0oHspt
         GWDqSC4ViW/cIfUVyyXmgsqGzGH1dyfxziM4YeA3WvRYlDclwKUB1T9rqakcQd1h8R1N
         hM9mhcalYzt8WWWJ5FAT1nplyqF20sZfa47WoYaU7n/Tgv5eABMP5kcDjy0cmsEv6lCk
         CBThq8aGiqrLLyumVCRCV1o+eiMOceVL9b3xyCJC2CEYHC+g+tCXNt0WsZ6L0m81GG2G
         paxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762264203; x=1762869003;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4PZUJriZ6o5oZdswvVmoADliWthbllAlriaIosIncM=;
        b=rDDiorLfEar2Cc7S0ejFC7WxmpIqjEgIqwBvgt1iAn29SmywSVvweHxbFLcqS6bJsi
         3JeNa03z8OqxqJi0xrZ7Zufk/kETmzKigVkBV37axZqZHjSqfznhClEe6LRcEGHMREon
         bp+UljOnNgful1cWVMBs0znVWH6lRNZ/CEIL7TCNexMaedTIdr3CQADEcMl8hV6vgwvw
         lZscUNMukTYEi0YiocPD0QFiZukpNMMZKcyiwJbvccEhHpZGg+SjfS/HsapShUjgxOwR
         CmknxB47yA+Ih+6BPNPGQHK7CVlg90I8T/c1q+2jXtIgkbRJqe9jSHf3dHFmeKeTWXIQ
         +MLA==
X-Gm-Message-State: AOJu0YwJqt+s9oZZ2nUPIpn94Uwf6SlFwYsWyA/f8Mt0fiC9DvqK6XBz
	0LZz5yOaeT8Hg4M4b3b93/01XxP8Osq4CeHt5xz5jVGQhgoqE0CdTaRZ2AbaVVbYOYUj966N+OI
	Twds08sKIHuUAKuelR7+zghW2J6dX8u97Uc9Pod14
X-Gm-Gg: ASbGncv4kiKl0RNGqTnXggdinWBk7vsOI1zHuQsLUxLUSLgtSaJiy7i9r45xnis88km
	ldKKlRWv5ZZ0VkVe2gYn6PTBtFtW+Ll3zuzo/lbqlQHyp82O8CMcn4dMXq8KC/lOJQweAyO4qkA
	cVxl/i4UXtJIM7ze85CQHQPg7vtYRVefNudV+sTNH8VKCJBMYLDMELz5PMHvESWdyZhNYbY+I3s
	r68VVY88Ufx/YyT35rHoMXTxp+1dRGKUVEV2c4nhnJjk+lmlaInkEtCOV5fE8TDcl08fhR0yekc
	MODB1jMKzKnUrJuqfw+Od14=
X-Google-Smtp-Source: AGHT+IGTBq9V0fTn68K5+VaRr10xjLMseLr8sKIiRzYHVvyriGiMAPU0QHrZo65E9fUodm9ZFPFCOW1IRZkY1g2Qwjg=
X-Received: by 2002:ac8:5796:0:b0:4e4:6a1b:1148 with SMTP id
 d75a77b69052e-4ed61c2b012mr7863361cf.6.1762264195039; Tue, 04 Nov 2025
 05:49:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com> <20251104125906.1919426-2-tabba@google.com>
 <20251104134439.GA285975@e124191.cambridge.arm.com>
In-Reply-To: <20251104134439.GA285975@e124191.cambridge.arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Nov 2025 13:49:18 +0000
X-Gm-Features: AWmQ_bn0Qp35aVsUEeieVb2P4NkOnkj_isUo2GmXSf1FLIHtXP--Xilm07LyOK8
Message-ID: <CA+EHjTw6bQOnGczLCJGmz_cbwj_Sd42pU9DOxLarkETzWfLS3w@mail.gmail.com>
Subject: Re: [PATCH v1 1/8] KVM: arm64: Route MOPS exceptions to EL2 when
 guest lacks support
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Joey,

On Tue, 4 Nov 2025 at 13:44, Joey Gouly <joey.gouly@arm.com> wrote:
>
> Hi Fuad,
>
> On Tue, Nov 04, 2025 at 12:58:59PM +0000, Fuad Tabba wrote:
> > MOPS exceptions must be routed to the hypervisor (EL2) when the guest
> > does not support the feature. If the guest does support MOPS, exceptions
> > should be handled by the guest at EL1.
> >
> > The existing logic was inverted: exceptions were trapped to EL2 (by
> > setting HCRX_EL2_MCE2) when the guest supported MOPS, and left to be
> > handled at EL1 when it did not.
> >
>
> This doesn't seem quite right? Check the commit message of 2de451a329:
>
>   A KVM guest may use the instructions at EL1 at times when the guest is
>   not able to handle the exception, expecting that the instructions will
>   only run on one CPU (e.g. when running UEFI boot services in the guest).
>   As KVM may reschedule the guest between different types of CPUs at any
>   time (on an asymmetric system), it needs to also handle the resulting
>   exception itself in case the guest is not able to. A similar situation
>   will also occur in the future when live migrating a guest from one type
>   of CPU to another.
>
> So it's intentionally trapping MOPS to EL2.
>
> Also with HCRX_EL2.MSCEn=0, execution of the MOPS instructions are UNDEFINED at
> EL0/EL1, so you wouldn't take any MOPS exceptions to EL2 anyway.

Thanks for the clarification, you're right. I'll drop this patch.

Cheers,
/fuad

> Thanks,
> Joey
>
> > Fix this by moving the setting of HCRX_EL2_MCE2 from the feature-check
> > block to the 'else' block, ensuring exceptions are only trapped to EL2
> > when the guest cannot handle them.
> >
> > Fixes: 84de212d739e ("KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index c9eab316398e..0f8311263edf 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -684,7 +684,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
> >               vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
> >
> >               if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
> > -                     vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
> > +                     vcpu->arch.hcrx_el2 |= HCRX_EL2_MSCEn;
> > +             else
> > +                     vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
> >
> >               if (kvm_has_tcr2(kvm))
> >                       vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
> > --
> > 2.51.2.997.g839fc31de9-goog
> >
