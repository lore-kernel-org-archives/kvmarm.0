Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB7219923
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 18:01:24 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-33b1e83e1daso9281315ab.0
        for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 11:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685556084; x=1688148084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oj2Fw5dSQp63bUWr4posajG7QB7Mr0N7IRLnkyA+AtY=;
        b=k5PC0F1hcx5sRmsEGcmbJqNkl0AiZ0u3z0554PODRPKEAe8W/IWSFsDzrSJbzclnNn
         sX9RvnOcZQCROQuPBAkjUSBjYPo1m0GOqQS8ZyXS0BHKVdiHbe15U1zd4I62YGYIT3Eh
         QL7oevgaQCQE1IAX0mP4c37pKHyfnj0fwLTl8fRWrHLzfU2eVnesmVamMn4DXqpLnEKY
         DhTau8tSMxb+Gz6FH2QV97A7vvKND+MXCncccX3LIQDhSevqdCsGYqVx1NCLNSXkq5zI
         ojlX+qYIZc3afyzV++768XR6VVrSqf2325c+cVxc8GbGopg5s5KhhVsKuMsvZRYje+yt
         A9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685556084; x=1688148084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oj2Fw5dSQp63bUWr4posajG7QB7Mr0N7IRLnkyA+AtY=;
        b=WfVcSwxh4W1vw5DwHhmp3/pqZLnTUhpLYae3/5OEQPFPleKdhmOrsprsjswcvCG21o
         R183jr+mbNHy1YQOn/9uASkdxEcS5ORBbrztU59R0+07jDCxdQjNtymc4zgBFabS3Ou+
         eBZlONmjkFJEsbX+G38zrCp12akrTDG+1QKTSTH40M2F2YNxdPjJHwzNrRJY1ht+d+2s
         1Nz1IvD1QI/nP4eNVID2DvIe8P6nsT3PXRs4O9Ut9URFpipjXdeT+U9el/maY2XjQDSI
         jm0ba7D13mqfiDbGV+1SBczIRs6RwMw4Oer1fy/6rkrP2Q051RlDMu1EwvdGZY8g9TJf
         NOHQ==
X-Gm-Message-State: AC+VfDxGKTP9W9j0GLShoSVOp6rbUQuyARONXOKR/uzrm3bHBh3qzlAH
	vopwZz+0NIyGqqKuu4th30n2RIXkny1mj17CiRvTKbVsgSb1KssLhBs=
X-Google-Smtp-Source: ACHHUZ7Ghm57psekUGggVXvqnjraOCgCTG4YKtIkmK4ZGcFmqhIkYJecoxryMwL62EWPoE+z7qd/cpdMv+pG2CN0RE0=
X-Received: by 2002:a05:6870:e606:b0:19f:45a1:b5a2 with SMTP id
 q6-20020a056870e60600b0019f45a1b5a2mr3974220oag.49.1685554176435; Wed, 31 May
 2023 10:29:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
 <20230522221835.957419-6-jingzhangos@google.com> <87pm6kogx8.wl-maz@kernel.org>
 <CAAdAUtjJ8n8+jt=Y=oJFuRvERzRY4DQr6S7JThobU=wWMOYaRQ@mail.gmail.com> <86353dc5yr.wl-maz@kernel.org>
In-Reply-To: <86353dc5yr.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 31 May 2023 10:29:24 -0700
Message-ID: <CAAdAUtjj3MEzGPxVayezcd9x7_4EMsp2UUXZZHJWKLqbz75p5g@mail.gmail.com>
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

On Wed, May 31, 2023 at 12:31=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 30 May 2023 22:18:04 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sun, May 28, 2023 at 4:05=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Mon, 22 May 2023 23:18:35 +0100,
> > > Jing Zhang <jingzhangos@google.com> wrote:
> > > >
> > > > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > > > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > > > specific to ID register.
> > > >
> > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/cpufeature.h |   1 +
> > > >  arch/arm64/kernel/cpufeature.c      |   2 +-
> > > >  arch/arm64/kvm/sys_regs.c           | 365 ++++++++++++++++++------=
----
> > > >  3 files changed, 243 insertions(+), 125 deletions(-)
> > >
> > > Reading the result after applying this series, I feel like a stuck
> > > record. This final series still contains gems like this:
> > >
> > > static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > >                                const struct sys_reg_desc *rd,
> > >                                u64 val)
> > > {
> > >         u8 csv2, csv3;
> > >
> > >         /*
> > >          * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long a=
s
> > >          * it doesn't promise more than what is actually provided (th=
e
> > >          * guest could otherwise be covered in ectoplasmic residue).
> > >          */
> > >         csv2 =3D cpuid_feature_extract_unsigned_field(val, ID_AA64PFR=
0_EL1_CSV2_SHIFT);
> > >         if (csv2 > 1 ||
> > >             (csv2 && arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFE=
CTED))
> > >                 return -EINVAL;
> > >
> > >         /* Same thing for CSV3 */
> > >         csv3 =3D cpuid_feature_extract_unsigned_field(val, ID_AA64PFR=
0_EL1_CSV3_SHIFT);
> > >         if (csv3 > 1 ||
> > >             (csv3 && arm64_get_meltdown_state() !=3D SPECTRE_UNAFFECT=
ED))
> > >                 return -EINVAL;
> > >
> > >         return set_id_reg(vcpu, rd, val);
> > > }
> > >
> > > Why do we have this? I've asked the question at least 3 times in the
> > > previous versions, and I still see the same code.
> > >
> > > If we have sane limits, the call to arm64_check_features() in
> > > set_id_reg() will catch the illegal write. So why do we have this at
> > > all? The whole point of the exercise was to unify the handling. But
> > > you're actually making it worse.
> > >
> > > So what's the catch?
> > Sorry, I am only aware of one discussion of this code in v8. The
> > reason I still keep the check here is that the arm64_check_features()
> > can not catch all illegal writes as this code does.
> > For example, for CSV2, one concern is:
> > When arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFECTED, this code
> > only allows guest CSV2 to be set to 0, any non-zero value would lead
> > to -EINVAL. If we remove the check here, the guest CSV2 can be set to
> > any value lower or equal to host CSV2.
>
> Sorry, this doesn't make sense. Lower is always fine. If you meant
> 'higher', then I agree that it would be bad. But that doesn't make
> keeping this code the right outcome.
Got it. Then it would be good to remove the check here. Will do that.
>
> > Of course, we can set the sane limit of CSV2 to 0 when
> > arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFECTED in
> > read_sanitised_id_aa64pfr0_el1(). Then we can remove all the checks
> > here and no specific set_id function for AA64PFR0_EL1 is needed.
>
> This is what I have been asking for all along: the "sanitised" view of
> the register *must* return the absolute limit for the fields that are
> flagged as writable by "mask".
>
> If we need extra code, then something is really wrong. The core
> feature code manages that without any special casing, and we should be
> able to reach the same level.
Understood.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
