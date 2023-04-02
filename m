Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F473C39
	for <kvmarm@lists.linux.dev>; Sun,  2 Apr 2023 13:48:07 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id h25so34775924lfv.6
        for <kvmarm@lists.linux.dev>; Sun, 02 Apr 2023 06:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680443286; x=1683035286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZIXaofmVFR+Ci0Qtn7ZztnlykUDzyjzm26l4+VTLcI=;
        b=Llz7KJ0Ft4xJymfR4oMMk9RDdyP+iaAT0YXqzHxQb2jmYU9bxEkmM+0EnOebfhXEf9
         Vt013bHivQKmbsQo3a6tjj/V6/11Wzsxy2XXrdUo6abl0JLZUxoefj4q65D48fOQS7i3
         6+f6eV1grmqF5Wfl1Y9W+yuCw8aWY0lFynP9D5k820Qt/lxhZQhDHP2Nhc6HM1CVRvRS
         EsLUL6ZrqoBkP/qEPEeqQC+hUht8LvhoPQ1t74+wL6JVDHE1+YolJQntSgqmpNs5VkeH
         WEpO2JvxnWldLT5iUd5qTGWpu5FisTyF7k8hTx+NXibwEAK7fZ0sCraCKIDjE7TQE+Pm
         BihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680443286; x=1683035286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZIXaofmVFR+Ci0Qtn7ZztnlykUDzyjzm26l4+VTLcI=;
        b=Mg81yIsaqMUjDu0nwrxjMcU9qcDrRYdQ+TN4D02iakLlUfXxwuTSzYqich+5OD8NeK
         PPIONSplhB3jJZ1p5KyozNOtNN2KqSwGNjxqtc4NynMSZn7cpOKztEZ74YF+Q39zaenp
         4BvkPubRP3EcZ7ZzVJW7Coltz2klsIMm851mm/AtTW7oGrMyQN+8SGa+ahWg/n7E+mM3
         Be/CId7kVDAp36c+D201S4SoklLNgEvwIONBYT+xea7P2MaV+RiLvPb92gXpouicREpJ
         D0+o/BwRyXfN59JWEkjcIYONrdjQrbyZbIhFh9PJK5HSmMRdEIaNYj7Y0chRqSB1HGO1
         N1/A==
X-Gm-Message-State: AAQBX9dnW0Hm0rn1PsYstaL0jUeoye7NIBTzzqUohXtin8gPaZQvepWo
	rT9+5lUQc3aj65TqFwKLVdV/x1NF2feZeJNzoKDkDg==
X-Google-Smtp-Source: AKy350a+dRQoGQicHT5dFjHmh3TK5gLTMdPYFS9Sc1I3ti8yDOsOmt4vkO2KK84OHXikpiUuMosDs5z2o5aRAIIUWQY=
X-Received: by 2002:ac2:5e81:0:b0:4e8:5371:c884 with SMTP id
 b1-20020ac25e81000000b004e85371c884mr9852027lfq.5.1680443285812; Sun, 02 Apr
 2023 06:48:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230331131218.2063233-1-tabba@google.com> <ZCcGD+El90tBpexd@linux.dev>
In-Reply-To: <ZCcGD+El90tBpexd@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 2 Apr 2023 14:47:29 +0100
Message-ID: <CA+EHjTy0EhfEUWieqJbdxmrAVE=+cF4GZcYrnDebG=mv9y5Cew@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to
 protected VMs
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oupton@google.com, will@kernel.org, 
	pbonzini@redhat.com, james.morse@arm.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, reijiw@google.com, ricarkol@google.com, 
	rananta@google.com, jingzhangos@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

Thanks for your comments.

On Fri, Mar 31, 2023 at 5:11=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Fuad,
>
> Thanks for catching the masking issue in v2. Few comments:
>
> On Fri, Mar 31, 2023 at 02:12:18PM +0100, Fuad Tabba wrote:
> > The existing pKVM code attempts to do that using a value
>
> nit: it is more readable if you restate what 'that' is in the changelog,
> even if it is already in the shortlog.

Will do when I repost this.

>
> > initialized to 0, but never set. To advertise csv2/3 to protected
> > guests, pass the csv values to hyp when initializing hyp's view
> > of guests' ID_AA64PFR0_EL1.
> >
> > Similar to non-protected KVM, these are system-wide, rather than
> > per cpu, for simplicity.
> >
> > Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System =
Registers")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > Changes from V2: Fix masking not to affect bits other than CSV2/3.
>
> Commentary like this that you don't want to appear in the commit when
> applied should appear below the '---'
>
> > ---
>
> I.e. right here.

Ack!
>
> >  arch/arm64/kvm/arm.c                          | 24 ++++++++++++++++++-
> >  .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 +++-
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  7 ------
> >  3 files changed, 27 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..0ae927c99fa1 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1889,9 +1889,31 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
> >       return ret;
> >  }
> >
> > +static u64 get_hyp_id_aa64pfr0_el1(void)
> > +{
> > +     u64 mask =3D ~0ULL;
> > +
> > +     /*
> > +      * Track whether the system isn't affected by spectre/meltown in =
the
> > +      * hypervisor's view of id_aa64pfr0_el1, used for protected VMs.
> > +      * Although this is per-CPU, we make it global for simplicity, e.=
g., not
> > +      * to have to worry about vcpu migration.
> > +      *
> > +      * Unlike for non-protected VMs, userspace cannot override this f=
or
> > +      * protected VMs.
> > +      */
> > +     if (arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFECTED)
> > +             mask &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > +
> > +     if (arm64_get_meltdown_state() !=3D SPECTRE_UNAFFECTED)
> > +             mask &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
>
> Doesn't this introduce a subtle change to the way that the CSV[23] values
> are constrained in KVM? At least for 'normal' VMs we constrain both field=
s
> to having a max value of 1.

You're right. I'll fix this and resend the patch.

Thanks again,
/fuad

> --
> Thanks,
> Oliver
