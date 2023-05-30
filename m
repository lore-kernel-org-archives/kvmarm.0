Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF2C200BC
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 21:18:15 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-19f7e8f8e3bso1013260fac.3
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 14:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685481495; x=1688073495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRzETm7DZRh6j3+7YODRNJA4sp3Ou2Xy/lhOc2t4wdQ=;
        b=koZyWywsmQYUcG0IF13OhUG5tSYLsoyfy81MoEp6BReL6at9WL/B2KRu7ynRo+pQ/O
         HtaFLm0+EXIAsEVQts50Fw9kF2gMpb2P1iK42Ub4pGRHUwhVggTUMAnaKCIrAGX9V3ZE
         QDL2sqkYMZ4vODDrmr7BzfxGqZyL4wom/7aa8tBv5ZToK7isTJCGNFvjAvenyMboV7IR
         Ln41Oj4kp7FBwLz2xFaKoSXplkeNLUZEp/d3D0KhKfS1aO1Aq1/EwY1WP1wTnLAVX/Lf
         ZG0hdnaHoQOLnn+17KmlgXvZT7yvnTCyTWo9oGZrrqvFTtqRvQJXgjCy3RN6Jhb6jK0g
         kmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685481495; x=1688073495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRzETm7DZRh6j3+7YODRNJA4sp3Ou2Xy/lhOc2t4wdQ=;
        b=P/42uQ/q1ETBK/MDhhX1xhCE6c6B7n7h0np+TDNYt2t+Tk7chKm2Bz1b/yfeXpk5YH
         eX57OXObnRXBiBxHP0jeDxnB0CQyzvb69VfwrGgVAaZvJjFYrS+LwxgS09Mu4YTvWNKe
         1Ce8lX9NJ8y5xjYB89FJ6fbMfJSvktMkl7lTggdUrzP/7s2590TnUqx5xA6F932XX3CP
         L1eZhz0dtIk4qpWeIVgJKSy2y8DwQqTrW8WVBAQ+GqlJX8A7u1e5mHjqIKwCNzV2z7YI
         TE1dtLsGjUXTRcUWkqpL7iecW/YveozEJqc2Tl+Me2j3cW0OYe/rglqYFxYty+IHf9EP
         LbDA==
X-Gm-Message-State: AC+VfDxcg2ONS6l7DQxYOUcOcfOCEQLctK0SKPLxsoVUkknMbXY5vuqm
	gb9pqi91dnD0hNBhZBQsn7pAX9bMlJ/OqYSdKF4KGw==
X-Google-Smtp-Source: ACHHUZ6ExbF+VdRwxySI967Hvme9EaZY2aakRZEWuhIr3Es/isDTPXoAc5pBcmL6L8pZEabAFjeBxyuLVdimlBv/X84=
X-Received: by 2002:a05:6870:44c2:b0:19a:71ce:c9f5 with SMTP id
 t2-20020a05687044c200b0019a71cec9f5mr1365041oai.29.1685481495045; Tue, 30 May
 2023 14:18:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
 <20230522221835.957419-6-jingzhangos@google.com> <87pm6kogx8.wl-maz@kernel.org>
In-Reply-To: <87pm6kogx8.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 30 May 2023 14:18:04 -0700
Message-ID: <CAAdAUtjJ8n8+jt=Y=oJFuRvERzRY4DQr6S7JThobU=wWMOYaRQ@mail.gmail.com>
Subject: Re: [PATCH v10 5/5] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Sun, May 28, 2023 at 4:05=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 22 May 2023 23:18:35 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > specific to ID register.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |   1 +
> >  arch/arm64/kernel/cpufeature.c      |   2 +-
> >  arch/arm64/kvm/sys_regs.c           | 365 ++++++++++++++++++----------
> >  3 files changed, 243 insertions(+), 125 deletions(-)
>
> Reading the result after applying this series, I feel like a stuck
> record. This final series still contains gems like this:
>
> static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>                                const struct sys_reg_desc *rd,
>                                u64 val)
> {
>         u8 csv2, csv3;
>
>         /*
>          * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
>          * it doesn't promise more than what is actually provided (the
>          * guest could otherwise be covered in ectoplasmic residue).
>          */
>         csv2 =3D cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL=
1_CSV2_SHIFT);
>         if (csv2 > 1 ||
>             (csv2 && arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFECTED=
))
>                 return -EINVAL;
>
>         /* Same thing for CSV3 */
>         csv3 =3D cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL=
1_CSV3_SHIFT);
>         if (csv3 > 1 ||
>             (csv3 && arm64_get_meltdown_state() !=3D SPECTRE_UNAFFECTED))
>                 return -EINVAL;
>
>         return set_id_reg(vcpu, rd, val);
> }
>
> Why do we have this? I've asked the question at least 3 times in the
> previous versions, and I still see the same code.
>
> If we have sane limits, the call to arm64_check_features() in
> set_id_reg() will catch the illegal write. So why do we have this at
> all? The whole point of the exercise was to unify the handling. But
> you're actually making it worse.
>
> So what's the catch?
Sorry, I am only aware of one discussion of this code in v8. The
reason I still keep the check here is that the arm64_check_features()
can not catch all illegal writes as this code does.
For example, for CSV2, one concern is:
When arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFECTED, this code
only allows guest CSV2 to be set to 0, any non-zero value would lead
to -EINVAL. If we remove the check here, the guest CSV2 can be set to
any value lower or equal to host CSV2.
Of course, we can set the sane limit of CSV2 to 0 when
arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFECTED in
read_sanitised_id_aa64pfr0_el1(). Then we can remove all the checks
here and no specific set_id function for AA64PFR0_EL1 is needed.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
