Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33308748C
	for <kvmarm@lists.linux.dev>; Thu,  3 Aug 2023 03:32:59 +0000 (UTC)
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-56c711a889dso324662eaf.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 20:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691033579; x=1691638379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTNE6qlcxM1i0PcHskgHEnRcd+f44VUJz3njSknkI/s=;
        b=py+/eIrs5YCHB2Oru937Ea5D9UcfiN/pYPSrGRSjlN5KRXVdRMr3zW2/QZwekX97Jl
         ZKoJ101PAqdJL5I+GVwi7u0Ju+p8HlCzcMMEc6UoTqlPi3N50mdWSxppSbG88yT3LzrH
         6GN0yxzA46ArrgGZno/fWmRkkGf5LgMsq72s2ZPWbv2XpurXxvKBfDUIHRx9ydxoopkz
         goFtPDafSSeXEo+B05Huc8HDZaWPPxGowzbN8Ama1QI8JYrLsv2ePXukU4Vh9ACPpp5i
         aeeRtUNbVJFpJiJOGSIVMcH76Ht7QhynrQMlNQvVjsnY8rxrxhuEJGT/IF3D2duEruaI
         lAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691033579; x=1691638379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTNE6qlcxM1i0PcHskgHEnRcd+f44VUJz3njSknkI/s=;
        b=ACbcpCKcyMysy5RYwLK4+oQCdLrIRLV68MnA7RMluYIAOVPkhHxrGYRxlkxITODveC
         tzkz6uHIqe4DbF3oJql9rmlA4nJjdPLUxgLH7Tp5kHSiRQtE9WGJsmnj+EaQ1go73T69
         OoF4DIkpcZDaTHOmZJK9KOz+i+sikYh9eK1xjnYky9vyIvqyatnKyMtjZegzbX729ULX
         Edl7zgP7nfvrWxyFjTaJAOfeMUeYccqDAX49ilfsiUr3xh07scHfkZ879lGt0IN0NzIT
         rs3IJoGCXd6cEmMzuUBFxpoLBE9yYEC/DebofR2Bkqlhd8yS6HIQ/ej0EwUGU3eXU+fz
         04vA==
X-Gm-Message-State: AOJu0Ywew2txymM/+iIjdRHpRVWRBoU8PFz3sSjZd5yVjY8hLdtrLxjJ
	PrDEKPtjB1cWOzYX1DYX9nnk8GizSHnoJmb79KPHyA==
X-Google-Smtp-Source: AGHT+IHcxC0wvEo7xcqzzTyr9+/Mog6eIkUZeINgRRrAOqEuqwJbtV9No/bOrCbt+PPGuk6wsh7lHk3XeTMAxzxvgJg=
X-Received: by 2002:a05:6870:560e:b0:1bf:7b28:a4b3 with SMTP id
 m14-20020a056870560e00b001bf7b28a4b3mr677047oao.13.1691033578965; Wed, 02 Aug
 2023 20:32:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230726044652.2169513-1-jingzhangos@google.com> <ZMrVBWg+c3PSUilR@google.com>
In-Reply-To: <ZMrVBWg+c3PSUilR@google.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 2 Aug 2023 20:32:46 -0700
Message-ID: <CAAdAUthkeu-_5MeR689boGkzkkCbtz+Hrhm0XxQZh0a7S96jaQ@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Test pointer authentication
 support in KVM guest
To: Sean Christopherson <seanjc@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 2, 2023 at 3:13=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Jul 25, 2023, Jing Zhang wrote:
> > Add a selftest to verify the support for pointer authentication in KVM
> > guest.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>
> ...
>
> > +     /* Shouldn't be here unless the pac_corruptor didn't do its work =
*/
> > +     GUEST_SYNC(FAIL);
>
> FYI, I'm fast tracking guest printf support along with a pile of GUEST_AS=
SERT()
> changes through kvm-x86/selftests[*].  At a glance, this test can probabl=
y use
> e.g. GUEST_FAIL() to make things easier to debug.
>
> [*] https://lore.kernel.org/all/20230729003643.1053367-1-seanjc@google.co=
m

Thanks for the heads up, Sean!

Jing
