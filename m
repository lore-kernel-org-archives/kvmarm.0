Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C71C94E
	for <kvmarm@lists.linux.dev>; Thu,  9 Mar 2023 22:19:19 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id c11so2865461oiw.2
        for <kvmarm@lists.linux.dev>; Thu, 09 Mar 2023 14:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678400358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jym0nUiEEbOOCFzlnlOfW+LijEktB+G0Iqs6BtQtNZI=;
        b=s+CvGVw1kC4Rp4CiFuDvNherDkdkqI71dca1eQMFFKnt/ztNDdolfJ3V/EFzX9CoGL
         Zmq3uiPhG+DhMSodJ1+x/pYKXPB0TcR6piRswV/C6I7kOvMB6XwoZqw7DDrCIEVmLqzV
         jhoWc1JhFiRfIowkQ3YowN/5iBUTsmvT8jLRN7ZBntHzDbRcNk//PIuhxaOwSB5IoAJX
         ZXgoIlisxtV8sMd5bsquQc7mP1euMQy32d4gKV6OPnhst+oRTpfIx+BB/ATMzOVtB2T2
         uPqSHkcOMPRvQwCC69BQ4qqfYios5ZgcNabJL4CGaGrNYoZfdRiPpe94s/+VKEb7Yaft
         kNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678400358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jym0nUiEEbOOCFzlnlOfW+LijEktB+G0Iqs6BtQtNZI=;
        b=BRzrv3m6peXH9Jbg4aCBJKTZ6kRtjjyxIX7jpBBxhQZn9tb3/yS7lImoT74rUcM0b1
         snZmPAeX8CSTZ/k23i9Itut4wiPU/NNpt3e88dOGGmyJBQ9xVgBrY1dZSExcNtc673yi
         R4PfhmlaJYmC7JIZAfTvp29lWXDmfjdwNVVVr0GQvKIoiq50rv68lpWHWIVie7szbyw4
         +cAycZmo4maA1eHqh+03K0meEYi2U6Oe4AXJkzZljX8hfD8BJ/VLPBzTsYHmH/t35C9d
         Js7Q9amrq65AKVy0YiuIgO9yARIoQuPn7nMwyOJYODYEA98onpQs4ePb7SBhAn1nSPlm
         pvwQ==
X-Gm-Message-State: AO0yUKV3xBXMcneImH9I16gYZRqFIKl6H4DVY926pa33yjkWskCXLr4q
	SrLdhnv37pYUNgOPKIdcATTxhp7XAJbZJETQd6gguQ==
X-Google-Smtp-Source: AK7set+PZFyz/IkkqHj3/hze6nBpdrjOZL7Z92InN2k9JiBNkaLuMMQTPuvGBxTXFbyreldmu/TdVrCVAIl6lmnmJy4=
X-Received: by 2002:a54:4102:0:b0:37f:ab56:ff42 with SMTP id
 l2-20020a544102000000b0037fab56ff42mr8087904oic.9.1678400358006; Thu, 09 Mar
 2023 14:19:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-8-rananta@google.com>
 <CAAeT=FxVyHVRTj_78Jebz9nsc79yfYcbOu2c2hcekJTLgKFFaQ@mail.gmail.com>
In-Reply-To: <CAAeT=FxVyHVRTj_78Jebz9nsc79yfYcbOu2c2hcekJTLgKFFaQ@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Mar 2023 14:19:07 -0800
Message-ID: <CAJHc60w7gwUJ_rh6B3F_9SD_uxEDMRLFyahowGpCi54-84y3Hg@mail.gmail.com>
Subject: Re: [REPOST PATCH 07/16] selftests: KVM: aarch64: Add PMU cycle
 counter helpers
To: Reiji Watanabe <reijiw@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Reiji,

On Thu, Mar 2, 2023 at 7:06=E2=80=AFPM Reiji Watanabe <reijiw@google.com> w=
rote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Add basic helpers for the test to access the cycle counter
> > registers. The helpers will be used in the upcoming patches
> > to run the tests related to cycle counter.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vpmu_test.c | 40 +++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/te=
sting/selftests/kvm/aarch64/vpmu_test.c
> > index d72c3c9b9c39f..15aebc7d7dc94 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > @@ -147,6 +147,46 @@ static inline void disable_counter(int idx)
> >         isb();
> >  }
> >
> > +static inline uint64_t read_cycle_counter(void)
> > +{
> > +       return read_sysreg(pmccntr_el0);
> > +}
> > +
> > +static inline void reset_cycle_counter(void)
> > +{
> > +       uint64_t v =3D read_sysreg(pmcr_el0);
> > +
> > +       write_sysreg(ARMV8_PMU_PMCR_C | v, pmcr_el0);
> > +       isb();
> > +}
> > +
> > +static inline void enable_cycle_counter(void)
> > +{
> > +       uint64_t v =3D read_sysreg(pmcntenset_el0);
> > +
> > +       write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenset_el0);
> > +       isb();
> > +}
>
> You might want to use enable_counter() and disable_counter()
> from enable_cycle_counter() and disable_cycle_counter() respectively?
>
Yes, that should work. I'll do that.

Thank you.
Raghavendra

> Thank you,
> Reiji
>
> > +
> > +static inline void disable_cycle_counter(void)
> > +{
> > +       uint64_t v =3D read_sysreg(pmcntenset_el0);
> > +
> > +       write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenclr_el0);
> > +       isb();
> > +}
> > +
> > +static inline void write_pmccfiltr(unsigned long val)
> > +{
> > +       write_sysreg(val, pmccfiltr_el0);
> > +       isb();
> > +}
> > +
> > +static inline uint64_t read_pmccfiltr(void)
> > +{
> > +       return read_sysreg(pmccfiltr_el0);
> > +}
> > +
> >  static inline uint64_t get_pmcr_n(void)
> >  {
> >         return FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
