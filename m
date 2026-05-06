Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0822D63F8
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 15:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778080234; cv=pass; b=fvF9dSKWuadJtL+61qnEa2vCYVZ9B5Gs3LsDiFovwDnvxVCPUjmJLpdPj7qmg9u3BDEVpkBziWhoOKlecKEsjx4nGifQuv82QZe428X42eF8tHL3N5vWcknt5AU9C9maKk8b5rXwF2vJdz+yaLQHG1o9zzLTpFFjZ9WKsqC7D5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778080234; c=relaxed/simple;
	bh=b8yIQw5Mlbi0bJTVOLMfnQWl/7vG7NcNJ4k3bfS23ZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sg2PbTkEOuyOAdRWEwi8MtPddVvvprZZKGRsylfikT5XUyPFsvLyCMKIIvdSOWewjFfwbAT9JrRKh4OIOnVq6foWgtDNp4XKsnoWQBLnq4Kz2D1XKdyLhm9XnfVG+E4eq7Ef6An0v3WZRlLS2Oe1fN99u6tfqgHJwjKkgfJiiC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hQ2STkxV; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hQ2STkxV"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50d864c23bdso679131cf.1
        for <kvmarm@lists.linux.dev>; Wed, 06 May 2026 08:10:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778080232; cv=none;
        d=google.com; s=arc-20240605;
        b=P8CGn0s9z9cAx3BrMi+25HjDsj+wKRZd/EJA0jUifL8elBPfH2gvSYNuv0WiES6NWf
         xIow2Itjq3c7hXTYw1EtBrtmbE0OZQ36MIdEBarmqyTtD64EESqlFdJFX03qyZ577ECW
         z2Ey/jtOWEOzxCDe3U8BXJ4FzFe5DPG8BjGNHoypzEB+q9zgb4zDZPJw4k5FGqcliGwv
         utxhLj+I0oOfib4gH/ilFowcAFTcmXRiz9GpW72SNc7W0v5/cErwcHCZ407+bu7OUIeu
         Gwp/F11AieAOUH5CojwipJYlcV8/IqY27o5gvg3liYvY8tyhO4xZ6WYPm22FafquFQ+l
         Bkxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uc97my+cmQsKhLzxdnWEgFr7kOoH51/4k3Hl8Nt8XNU=;
        fh=CA37Axgzky5fG221Orj0v6ESIpMj/826xhR2EYy+gss=;
        b=SS4+6g0PwuAdPTrqPRfr63kqf53R5jOCKjIdS0OjuFAwFTG9uyaDEhxex4sqpCK45+
         NnRk4X9h/ebOL6N2YaqkdXk9udA+dgGPGwdD2X1qG3PkVQEeEz7JStAaxomGO+5k1ya3
         kGWbJq8Gb5H4j0Ji8q0zo8N5WNt/gvvY6u5mk0tHuVEmo2grbMyCIKuH7EO1AijvDIKL
         MmUT3MT+wlEB3TPkTJ1TALwYwVU4sVQvLK38VmirXaWqhhr61tg69tRH6q+SHbhDCF1Q
         EsocUfWMr6qzPoXXouXIhXN5vdzvSCAxfELBmTZ/Be6x5y/lLPUibJbUTRGifGBSdbCd
         DH5A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778080232; x=1778685032; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uc97my+cmQsKhLzxdnWEgFr7kOoH51/4k3Hl8Nt8XNU=;
        b=hQ2STkxVeoQIAluBD89Be7p8Ommy8llnq1XLbz06ik218CZkeOfI4W86Kq9qWn55GJ
         JCkL0gJmrirG7T+ck6DxH1MvcxztGJjS+q5Gor33/pugbj2Xp0xjM5Yu/aAnKeG2qJ/3
         Spb9qMqHJSGxHk4eKPlAOXNP3Q41DTqeTuF35m2WFFoECkDFPeWiXhBB/EXNXA1LYkrg
         HAOhmReO9qq4aG2/v6S74nzkCHJlb+JzqhURNAFgPRCluGrsNGFZUn+USMWoir7pbWLX
         UXcbTuY4AQ2z2N+n1N+xVtZ/VJiio5LhcnLvlCkHEeYg1H/J/WeiFfwUcM2/xtxS5fCV
         LhZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778080232; x=1778685032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uc97my+cmQsKhLzxdnWEgFr7kOoH51/4k3Hl8Nt8XNU=;
        b=ABQwZXSDsUCtTMucL/H6AC7MoNCBkMbtqHv9qWZxXxbLr/CYBkQmcXH4jcKkFTmYHW
         WOD6miLnvz1F+Ux1apgZRerPI7Iw0XrT+UmHaPY79lofAJAeoi4GZnhW94INmsMT+SIS
         Hela4V8wuE8OxvyckwQlw87iC/2zQ4Nu14Z0yt1lJkTGvwq48psCe8bEuhnNeH6caPW6
         ixZ+oLzN6ovGizzH+3yfcx3lUxCN+eh68uehjxRvnEl6G2jUs0V5/zuYiov3WMA2hJVo
         7NQN49gIWnIZQF2S9pNcOvlmg9KfN0zuvrY19hwTXl7dUsvp2cRr5ayjQ/RONLOeRZlV
         6C/w==
X-Forwarded-Encrypted: i=1; AFNElJ/qMmqWau4J9P4WcvPO6n02ePXaaDxyWEBs6tw8+jD8bDx0iRmnDiTAxFoJVchUXpfK0X+rcZk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCvPHs8paT05BaBvQlaP7smmqSp6+xiYm3DUlUZiCl8q7C7BPA
	MSVKukrUiDadLRNMPV84VGxUTl6+vsGR/bEhJwb3ZiydNOeukZv9z5HiMVjOHx/B9nIupKt/Jp0
	nKIIlELDqZRxFuQQYq0JaPaEZjrfKAnUSW5ffslkav0NRJvQbBOHboDfj4pc=
X-Gm-Gg: AeBDievXlNBXODXnaonwrb+FaH1bSDjLckoOC+zp6w67NAGsCt2YD08Shdc2ENbQTTb
	ljcHbq8aMXjm2/l47hazaQKEQ+i/XC9vcfgmjPwT6igZtfsTYhPdGeKSfhjqux7VoX/D6M6lgI7
	LKqSYkgwRPy84/2I7B2JezU6dMg+1zXpPdT0g6n3vp1+WqlsFay6VKOV9E/wounZnuuhKLeYqap
	tdTNJiD/1LD17lRNiLaeQsDoTxl6RqPEmDerYa/wqBcYUskAacURnJGLniQlRazU6TFJNNySjE3
	7hfg8PM+Ee0aAAIyC6WIudA3Ni95jwRL+KAcSF9aoyEmuNQugAXJOrUneFY=
X-Received: by 2002:a05:622a:8d0b:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-51460609360mr18117251cf.2.1778080231852; Wed, 06 May 2026
 08:10:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260430103724.2151625-1-smostafa@google.com> <aftYT7BY_9ZdGxmA@google.com>
In-Reply-To: <aftYT7BY_9ZdGxmA@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Wed, 6 May 2026 16:10:20 +0100
X-Gm-Features: AVHnY4JvfF-Rm5qhU_8GJTR4Tqjlts8HwSwhfutueSCgDZO7opguuERjCEmtOYs
Message-ID: <CAFgf54o7pGrtBY1mHuptnCNrRSGVPU=WHW=Qf5v+wGL6Gum-Dg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Harden clock for nvhe/pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 6, 2026 at 4:03=E2=80=AFPM Vincent Donnefort <vdonnefort@google=
.com> wrote:
>
> On Thu, Apr 30, 2026 at 10:37:24AM +0000, Mostafa Saleh wrote:
> > Sashiko(locally) reports possiblity of division by zero and
> > out-of-bounds bitwise shift in trace_clock_update().
> >
> > Although the clock update is untrusted, we should at least have some
> > basic checks to avoid the clock value getting out of sync if the host
> > is buggy.
>
> I am not sure about the gain here. The host can still write values that w=
ill
> make it out of sync anyway.
>
> The timestamp is ultimately fed and read by the host.
>

This is not about having the clock in sync, but to avoid executing
undefined behavior, such as division by zero or large shifts in cases
if the host is buggy and not malicious.
That was reported by Sashiko
https://sashiko.dev/#/patchset/20260501111928.259252-1-smostafa%40google.co=
m

Thanks,
Mostafa

> >
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/clock.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/=
clock.c
> > index 32fc4313fe43..a7fc61976fd0 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> > @@ -35,6 +35,9 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoc=
h_ns, u64 epoch_cyc)
> >       struct clock_data *clock =3D &trace_clock_data;
> >       u64 bank =3D clock->cur ^ 1;
> >
> > +     if (!mult || shift >=3D 64)
> > +             return;
> > +
> >       clock->data[bank].mult                  =3D mult;
> >       clock->data[bank].shift                 =3D shift;
> >       clock->data[bank].epoch_ns              =3D epoch_ns;
> > --
> > 2.54.0.545.g6539524ca2-goog
> >
