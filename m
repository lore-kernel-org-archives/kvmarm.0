Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55330DF58
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 17:49:13 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1bb571ea965so5559435fac.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 10:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690998552; x=1691603352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jkqdJMsvnVrRBo60+NUWMzNrzTaghjxAkAcp9NTjI7U=;
        b=qYZLszf+G832APU0iLQ9SDhHuPTE3ItqB1h1SOE36kWmrQQh/dmguNVkGU45Hq9yf8
         5Js/rXDP2hz8lYlp/9XADzFOJco2hlateqHcVjgHvYC4GYJf0t8UwSqdjPywq3+AycOG
         DLfaBn4hqTCglB9+hqaHj82XmSBWOK9qQy7g0rsnvV8MmKA9ddPuNhmHC1zRbfrv7eXd
         Tl3vbF0u8sTrlLURWVKPy9WenP7SMBeciiCChg/IuMi68UstzQEuAv1tqf7zvQ6jkoaS
         qIBqUxNkywVThWo0kz0nOjX4udk2CB6WnKuY7oDVs9biFODpN2r212df2uGyWVwLI6NH
         B4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690998552; x=1691603352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jkqdJMsvnVrRBo60+NUWMzNrzTaghjxAkAcp9NTjI7U=;
        b=WYRYnLA3MAFvl48BV0vVomNRDvOeE3ifhIRXmB1JVtCxbU8dMq66+y2PahOWrttg5X
         NBbHRZH3ulRGz314X0LVVfg9PFPABeJ2QkiCgaVlB56yNg1HqXxVQSBGdUPuCUM9ht6X
         uP24zlHo3o1iFBChOkd2cT7XDW2vAivpsxCDeVVjKccdnKicDCoEbPpwA48OXEUPscaL
         twAmCZnOgcHCFap8pI/2Vp/ok3AALzaTtXsNGyU/LRgt9WonH9wf8kVOPAzw2mi6Q1Fq
         VlmMiT0X+q8Cye7pfFOA/ZsW7B1qBratudKHRqC6Ax4MHPRw0uIvas0l8LlbPyTRrgvF
         og1Q==
X-Gm-Message-State: ABy/qLaBzeL04Dj/qLbZl7D119G3PAVswPwSZ1q7WWojQ27pxtFCPaR1
	Jy4ytm1ZMOP3NTQv/9EteER2tXIpIwUgevnyxcwj1B56lSnBsm8D1Vw=
X-Google-Smtp-Source: APBJJlF+hW45L4zt+hV6v1CvORUlP0mnh2MB6RDtiOS9QHnRZhAqJKTZsof6tHpAhnXoQnSabSlwJi5om+C3bOdNWqI=
X-Received: by 2002:a05:6870:f102:b0:1ba:63b2:899d with SMTP id
 k2-20020a056870f10200b001ba63b2899dmr18481008oac.32.1690998552110; Wed, 02
 Aug 2023 10:49:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com> <ZMmdnou5Pk/9V1Gs@linux.dev>
 <CAAdAUtj-6tk53TE6p0TYBfmFghj94g+Sg2KK_80Gar18kJ=5OA@mail.gmail.com> <ZMqMofRCmB14XUZr@linux.dev>
In-Reply-To: <ZMqMofRCmB14XUZr@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 2 Aug 2023 10:48:59 -0700
Message-ID: <CAAdAUtiemHnLK-y4AmEa53bw4ZhvRsebQWAMjV5dTSxEG0BUJA@mail.gmail.com>
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
To: Oliver Upton <oliver.upton@linux.dev>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>, 
	Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 2, 2023 at 10:04=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Aug 02, 2023 at 08:55:43AM -0700, Jing Zhang wrote:
> > > > +#define ARM64_FEATURE_ID_SPACE_SIZE  (3 * 8 * 8)
> > > > +
> > > > +struct feature_id_writable_masks {
> > > > +     __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
> > > > +};
> > >
> > > This UAPI is rather difficult to extend in the future. We may need to
> > > support describing the masks of multiple ranges of registers in the
> > > future. I was thinking something along the lines of:
> > >
> > >         enum reg_mask_range_idx {
> > >                 FEATURE_ID,
> > >         };
> > >
> > >         struct reg_mask_range {
> > >                 __u64 idx;
> > >                 __u64 *masks;
> > >                 __u64 rsvd[6];
> > >         };
> > >
> > Since have the way to map sysregs encoding to the index in the mask
> > array, we can extend the UAPI by just adding a size field in struct
> > feature_id_writable_masks like below:
> > struct feature_id_writable_masks {
> >          __u64 size;
> >          __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
> > };
> > The 'size' field can be used as input for the size of 'mask' array and
> > output for the number of masks actually read in.
> > This way, we can freely add more ranges without breaking anything in us=
erspace.
> > WDYT?
>
> Sorry, 'index' is a bit overloaded in this context. The point I was
> trying to get across is that we might want to describe a completely
> different range of registers than the feature ID registers in the
> future. Nonetheless, we shouldn't even presume the shape of future
> extensions to the ioctl.
>
>         struct reg_mask_range {
>                 __u64 addr;     /* pointer to mask array */
>                 __u64 rsvd[7];
>         };
>
> Then in KVM we should require ::rsvd be zero and fail the ioctl
> otherwise.
Got it. Will add the ::rsvd for future expansion.

Thanks,
Jing
>
> --
> Thanks,
> Oliver
