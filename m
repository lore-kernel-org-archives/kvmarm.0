Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB82AD49
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 16:09:02 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-53865bdc1b1so140994067b3.16
        for <kvmarm@lists.linux.dev>; Tue, 07 Mar 2023 08:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678205341;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F/kB0IypJg6aZTqiDMRZ19llJnUhGLwpqU6UaEdUNes=;
        b=Qcv9UAxgt3xsVviKCRDvfMjfSgCYyxThyJGUY1uqeSnXtz2UObx094Vce9b2Sjr0vO
         rZfRWAve4F+sOI/kLHx3odrPVjgMDXWP35fXk5n1l9aOU2uIfHqByiMqkq7HSmz36s8S
         Ry20+D8/KTN8vxqL783LbfpBBCErpSjNNZyuJGb9ZBkimBaGSQYcnFRb6TIz8Vw0ViDY
         tYgvEj3YZUTsjHevcqe4fyqrGGhIfR8AL1vfxndlyfXrDW5BYdt2Lha0/cSM149UKLgt
         BRneD96KqX1yJz9SkiYDDfefLf59pbsFXmMycCg1pu22Nmt2iVGJPrx8KLT98QHVOT0o
         qsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678205342;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F/kB0IypJg6aZTqiDMRZ19llJnUhGLwpqU6UaEdUNes=;
        b=kpnifQwymLOXXrTFca5HF4f+yx8coBGPFpdcfFA4dar1ahm3Jt9y3RHKqFpTnITpdb
         TfA3LqWoZD64Fn3/3C1nEsk/tR1HehupkuYYN8f+RpSs0CNO9zLjzgcLEW8YahGEMo4z
         7W91POV8N1woLruNhFkyobyEo4aHRv7C1LQKr5kg/5ZRg2Z8EOp90JkRpiLRkfNcPgKF
         4r+hTlCSt2VbPHs8seb+hgXqLQLZpaLDwo4e3SDSZIxeMNPuYemKtNtggjaGuQaG5g5v
         /8KcSMp8UzFVnWhdunJmbBR4RuxrQ1WJ+t0x2B32zffyEmn5MQBjVvEouXS0WtltfIDb
         bWDQ==
X-Gm-Message-State: AO0yUKUauZqApQdj3e79yyUUsNoWoxlszCtqEtnPHP+u4h45g6XEy4NQ
	b8WDOtlvJkHwS97MefpmIT03nsF0mLo=
X-Google-Smtp-Source: AK7set/VaM/tRd87+KvjpO4jP7xvodLAwtiDafs6T4TQLSxQiVQL+0JvQJwZHuvJg43BGTQ4mobDppzr77s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b71c:0:b0:536:7529:55b4 with SMTP id
 v28-20020a81b71c000000b00536752955b4mr9597369ywh.3.1678205341764; Tue, 07 Mar
 2023 08:09:01 -0800 (PST)
Date: Tue, 7 Mar 2023 08:09:00 -0800
In-Reply-To: <CAAeT=FyCQxhhFqhfWbFQB9uAcUxmktRa3SC_Yfne2f_MEeXOJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-11-rananta@google.com>
 <CAAeT=FyCQxhhFqhfWbFQB9uAcUxmktRa3SC_Yfne2f_MEeXOJw@mail.gmail.com>
Message-ID: <ZAdhnOzIcjZBWgmc@google.com>
Subject: Re: [REPOST PATCH 10/16] selftests: KVM: aarch64: Add KVM EVTYPE
 filter PMU test
From: Sean Christopherson <seanjc@google.com>
To: Reiji Watanabe <reijiw@google.com>
Cc: Raghavendra Rao Ananta <rananta@google.com>, Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

RESEND is the "standard" tag, not REPOST.

On Mon, Mar 06, 2023, Reiji Watanabe wrote:
> Hi Raghu,
>=20
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > KVM doest't allow the guests to modify the filter types
> > such counting events in nonsecure/secure-EL2, EL3, and
> > so on. Validate the same by force-configuring the bits
> > in PMXEVTYPER_EL0, PMEVTYPERn_EL0, and PMCCFILTR_EL0
> > registers.
> >
> > The test extends further by trying to create an event
> > for counting only in EL2 and validates if the counter
> > is not progressing.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> > +static void guest_evtype_filter_test(void)
> > +{
> > +       int i;
> > +       struct pmc_accessor *acc;
> > +       uint64_t typer, cnt;
> > +       struct arm_smccc_res res;
> > +
> > +       pmu_enable();
> > +
> > +       /*
> > +        * KVM blocks the guests from creating events for counting in S=
ecure/Non-Secure Hyp (EL2),
> > +        * Monitor (EL3), and Multithreading configuration. It applies =
the mask
> > +        * ARMV8_PMU_EVTYPE_MASK against guest accesses to PMXEVTYPER_E=
L0, PMEVTYPERn_EL0,
> > +        * and PMCCFILTR_EL0 registers to prevent this. Check if KVM ho=
nors this using all possible
> > +        * ways to configure the EVTYPER.
> > +        */
>=20
> I would prefer to break long lines into multiple lines for these comments
> (or other comments in these patches), as "Linux kernel coding style"
> suggests.

+1.  And on the other side of the coin, wrap the changelog closer to ~75 ch=
ars,
~54 chars is waaay too aggressive.
