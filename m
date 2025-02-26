Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596C2F37
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 12:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740573408; cv=none; b=JM7qomkrtYBERGDujo/PgcB995CcBIjFaH0EZclaIQC78eidl+C/JmuG3q+Vsls8QMYwBaQBZiPYYFaeqK+FPvBw4xnKVACcib2/ZhKDB0ZffypbZ3UNj+1OS+L4oHkREu8vszeF6WIoZRYeuKPa2cD3GJv5eQnsDzA3S5eGmIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740573408; c=relaxed/simple;
	bh=Vvc8jahT4heehKvU+6At+7WUVWrdhiuzePjs9Xiatyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Owmo8qgxIyYgr2KtRML2zHpPJw7R5gLEjpN/l8H1O20BWtUUEIWR0v6YPg1zI45DAvpDu+JwRjfRvlTrUhssAn6pcbGG9x/TZ+C/B42/Yemy44XD7jwPKIFcQ3KVD48ZZmWttm0cw5BDjpsW8kXl4QlkFzg1Mw3VmarCOPR0730=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qk4L9qS2; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qk4L9qS2"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-471fa3b19bcso230591cf.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 04:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740573406; x=1741178206; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HoJVZSkyjUmn1nx4mDEJyzPRhyKl3ZXWHT9JGOVfnSI=;
        b=Qk4L9qS2ZT1aGrxR7suK9VSMMQ3eNND+mhLzbmWynysmp15Zia82usmGVYTu88Qk0y
         /2xCwrSU0vKGZv9PDBsHpzbfIuqzFVT8Diyh/7votajtUqhh6TPHuTXQf9znIRmS3tmh
         hfBxM1ILucAxN8cgiNCwZWyurk+NCULBf/A8LiYyJCcVKzoy/ySdEZ/enk7ujmPCkuRE
         ZoBOBAwt3CB103Bi5igov43KL7qCyr2s5tKV3YDuezK6nwwxU1QwFF2SaltmNU672AvH
         suuPa3PMTvc3qh4LeLWui8esatljbYl2X7z5HkvLR+BoEe2VnTr7ONaepBUmL6nOPrOA
         yKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740573406; x=1741178206;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HoJVZSkyjUmn1nx4mDEJyzPRhyKl3ZXWHT9JGOVfnSI=;
        b=pQl+VEABwlhnF8pwvHXaWDQjk3MQuwDCcXLTA9Kha5RLVFV2gMbsM4JVvFLfnVOGud
         svx+t74ettmL1udM8Gw2/6IVgWYIWCwZHxog62vmScDJneesORlGfchZNsy9QRIjMHki
         nUKNmgLVdib8V/BHe47rV2ancJPB8JAKh6ARZHvjC4O2m/FHxj2G/Zm6N4/J8ZhHvK0c
         90uB7H110QwvHsEE58Z3+6RL8X4wADlIWaJxqUaUt6aRFjfIKs9Qn7FgrwTWYpo5Z64K
         zPKadAGTSuVbfXWGcwVYOUoID3JGOfjSA3gNEBrj8tj6BMAWN6DHqpZ1H+dy3h7IEgZX
         rz+Q==
X-Gm-Message-State: AOJu0YxA3pwrzodujQqtUBTSnhQhvwaEdLQvw3G1cut+0KSC8mOMpPAO
	GA2TMstpUicij2EHrwFqyPfAGCp/Vo2vn3A9aiqLbREBmfA5dKhUISUOBbR9VGfyQ+rHP8/9ZN/
	iKG+QGew+V/BYFcPrUhpRAFGJofr7QV0sgKnI
X-Gm-Gg: ASbGncuFXT/oeXwvBJACRwiWloOyuRJCn99a1rW5aj1AF2Gq0WuoW5hgj4uKqXCgYX7
	PP944aJ8GHAOp6whe7s7f/PGIWUYVnTN7uFSF9yP5ZxeHKPVDJq4Tmp7x40PDGYrmj2pa+ph2yo
	pxGvE=
X-Google-Smtp-Source: AGHT+IGQpoOYHGptiR2VD3L+l8sXuhYzvycknZAF+6aEn7jh3aoLIT4QNEieVrCBkZ4ux2peeQiBtg8/jW2baiYhRMs=
X-Received: by 2002:ac8:598b:0:b0:471:939c:a304 with SMTP id
 d75a77b69052e-47376e6f148mr10041761cf.8.1740573405841; Wed, 26 Feb 2025
 04:36:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250214150258.464798-1-tabba@google.com> <20250214150258.464798-2-tabba@google.com>
 <Z77n_Gv0X0bolONW@linux.dev>
In-Reply-To: <Z77n_Gv0X0bolONW@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 26 Feb 2025 04:36:09 -0800
X-Gm-Features: AQ5f1JoIK-v03PmLAeWTFQ7bXIjF-g1Cy1tRsGsXRmbYU1wZIODsNrHvaEpey6E
Message-ID: <CA+EHjTx53+D0jd=73UozNesT=6q+5YsP3fjasM4yN615Rpx2=Q@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, mark.rutland@arm.com, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	broonie@kernel.org, qperret@google.com, vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Wed, 26 Feb 2025 at 02:08, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Fuad,
>
> Series LGTM overall, one comment:
>
> On Fri, Feb 14, 2025 at 03:02:56PM +0000, Fuad Tabba wrote:
> > Initialize and set the traps controlled by the HCRX_EL2 in pKVM
> > when the register is supported by the system.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 46 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 3927fe52a3dd..668ebec27f1b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -58,6 +58,30 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> >               vcpu->arch.hcr_el2 |= HCR_ATA;
> >  }
> >
> > +static void pkvm_vcpu_reset_hcrx(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > +     struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
> > +
> > +     if (!cpus_have_final_cap(ARM64_HAS_HCX))
> > +             return;
> > +
> > +     /*
> > +      * In general, all HCRX_EL2 bits are gated by a feature.
> > +      * The only reason we can set SMPME without checking any
> > +      * feature is that its effects are not directly observable
> > +      * from the guest.
> > +      */
> > +     vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
> > +
>
> The comment isn't wrong, but we don't support SME at all in KVM at this
> point.
>
> Any objection to dropping this bit? I can fix it when applying the
> series, no need to respin.

No objections to dropping it. Regarding respinning though, it depends
on what I need to do to address Marc's comment. On that in my reply to
his email.

Thanks,
/fuad

> Thanks,
> Oliver
