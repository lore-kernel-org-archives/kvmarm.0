Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851AE11CA4
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 19:28:54 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-1b0719dd966so44071fac.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 12:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688585333; x=1691177333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLrsHezBug65PcONUHn1f5HHWgpCWcfxqLzQdqELU2A=;
        b=K03+CQUr9jXt/Co6K4kLl47G15ki/W5LqVbnLNfi0nG3M/F0G2nw1TQT1GabfwbMNf
         NKi1fYYK0BbpQF5JDaBBqrLQJJHnSur/t7fMhds3LeeR5WIKIDa7vWD2dp18/uHdqb7G
         wp6WWFdU0s2SX82VRJ9Av8ID3Cfo2Be3HnAKid4bg6Qkjuch7Wnb01wRsQeGzYifWjzm
         ibNZL2Ss720VXIxSdvp7wxkHbZkrrjMa+kMQt5t5dUhGtdPx5ebZTjnEaqv7/4zqyJTZ
         fRwGShKlS0iZtmrB3RqCodljVZnyyD1WMVMFvpzrSuHvDRc/hwVFONcG9MCrGsqIzf/n
         p/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688585333; x=1691177333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HLrsHezBug65PcONUHn1f5HHWgpCWcfxqLzQdqELU2A=;
        b=fJdQBTxI9BeySOuJoySkd4/AtmzfaHmiFr5d6saREUVkHSz68IYVKQCfJWVlSHZNmv
         SH1tUGY+sZqETGiQj/cp9TPaa2erXJqTQWF/g3SoY/vG+cZn9XRLYSfw8Unf+HDJpV7Y
         Sk8b68y9z3XSq0rWJbg6dk4tVt7f4d/Is7pjGaWobUmtQbwNGrSvHlSByAOWXPjpgSGR
         SEUB8dn2g2iTO1W67z5z0Sz1H87sxDxbHk4pKkk54SVpUCgnVt/kg0ZIYj3M4YLVc72g
         jezK021FSu03+dj8Zg1ghxRT6fJPxVZO/gBsS9ZJGfwScm/1SaB1JIM3lNWG6FASZ2zT
         +JdQ==
X-Gm-Message-State: AC+VfDz9+FjuNsPszvZ1pSTHrhWpXx/aQOzmuugz/x8H37QFmkru+NJ+
	4dLfLZI557D3RXYh8AEwo3qicNWDhRVzLHBcd3flpA==
X-Google-Smtp-Source: ACHHUZ7VAcBk6R/KAQdJO88sTq8HC12Qx+miqE5979bop8jAG5XWFZ1QxXSr/eBI9Et+Rc1u3hHuszt0JUg2m0TqehU=
X-Received: by 2002:a05:6871:4089:b0:1b0:60ff:b73f with SMTP id
 kz9-20020a056871408900b001b060ffb73fmr20131561oab.8.1688585333345; Wed, 05
 Jul 2023 12:28:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-2-jingzhangos@google.com> <ZJm+Kj0C5YySp055@linux.dev>
 <874jmjiumh.fsf@redhat.com> <ZKRC80hb4hXwW8WK@thinky-boi> <87o7kq3fra.fsf@redhat.com>
In-Reply-To: <87o7kq3fra.fsf@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 5 Jul 2023 12:28:42 -0700
Message-ID: <CAAdAUthVLKynPSAez6HB_Wx5u9H-cxDbwq0a_HzLehoN5xT4NQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
To: Cornelia Huck <cohuck@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, KVM <kvm@vger.kernel.org>, 
	KVMARM <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver, Cornelia,

Thanks for the discussion about the cross-field validation. I'm happy
to know that we all agree to avoid that. I'll remove those validations
for later posts.

Thanks,
Jing

On Wed, Jul 5, 2023 at 1:49=E2=80=AFAM Cornelia Huck <cohuck@redhat.com> wr=
ote:
>
> On Tue, Jul 04 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> > Hi Cornelia,
> >
> > On Tue, Jul 04, 2023 at 05:06:30PM +0200, Cornelia Huck wrote:
> >> On Mon, Jun 26 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
> >>
> >> > On Wed, Jun 07, 2023 at 07:45:51PM +0000, Jing Zhang wrote:
> >> >> + brps =3D FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
> >> >> + ctx_cmps =3D FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
> >> >> + if (ctx_cmps > brps)
> >> >> +         return -EINVAL;
> >> >> +
> >> >
> >> > I'm not fully convinced on the need to do this sort of cross-field
> >> > validation... I think it is probably more trouble than it is worth. =
If
> >> > userspace writes something illogical to the register, oh well. All w=
e
> >> > should care about is that the advertised feature set is a subset of
> >> > what's supported by the host.
> >> >
> >> > The series doesn't even do complete sanity checking, and instead wor=
ks
> >> > on a few cherry-picked examples. AA64PFR0.EL{0-3} would also require
> >> > special handling depending on how pedantic you're feeling. AArch32
> >> > support at a higher exception level implies AArch32 support at all l=
ower
> >> > exception levels.
> >> >
> >> > But that isn't a suggestion to implement it, more of a suggestion to
> >> > just avoid the problem as a whole.
> >>
> >> Generally speaking, how much effort do we want to invest to prevent
> >> userspace from doing dumb things? "Make sure we advertise a subset of
> >> features of what the host supports" and "disallow writing values that
> >> are not allowed by the architecture in the first place" seem reasonabl=
e,
> >> but if userspace wants to create weird frankencpus[1], should it be
> >> allowed to break the guest and get to keep the pieces?
> >
> > What I'm specifically objecting to is having KVM do sanity checks acros=
s
> > multiple fields. That requires explicit, per-field plumbing that will
> > eventually become a tangled mess that Marc and I will have to maintain.
> > The context-aware breakpoints is one example, as is ensuring SVE is
> > exposed iff FP is too. In all likelihood we'll either get some part of
> > this wrong, or miss a required check altogether.
>
> Nod, this sounds like more trouble than it's worth in the end.
>
> >
> > Modulo a few exceptions to this case, I think per-field validation is
> > going to cover almost everything we're worried about, and we get that
> > largely for free from arm64_check_features().
> >
> >> I'd be more in favour to rely on userspace to configure something that
> >> is actually usable; it needs to sanitize any user-provided configurati=
on
> >> anyway.
> >
> > Just want to make sure I understand your sentiment here, you'd be in
> > favor of the more robust sanitization?
>
> In userspace. E.g. QEMU can go ahead and try to implement the
> user-exposed knobs in a way that the really broken configurations are
> not even possible. I'd also expect userspace to have a more complete
> view of what it is trying to instantiate (especially if code is shared
> between instantiating a vcpu for use with KVM and a fully emulated
> vcpu -- we probably don't want to go all crazy in the latter case,
> either.)
>
> >
> >> [1] I think userspace will end up creating frankencpus in any case, bu=
t
> >> at least it should be the kind that doesn't look out of place in the
> >> subway if you dress it in proper clothing.
> >
> > I mean, KVM already advertises a frankencpu in the first place, so we'r=
e
> > off to a good start :)
>
> Indeed :)
>
