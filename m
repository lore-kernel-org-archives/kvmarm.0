Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E66010949
	for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 17:23:57 +0000 (UTC)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2b962535808so103509271fa.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 10:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692206635; x=1692811435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PN9U96sXQ/WhiZQpYWPMVe4BliphD8Rxbde/Icx+5GY=;
        b=3vCMtSNBvuTAdBXCc6sG59/G95pF+bcwRLTaLl0+A+RoE7y5JkvVhWXuV+2msQYTW5
         fT/ueq2vahIb4KQqCzkJcQSbgxUZa8KO6JGgJ2kguacmllPqRLJGgQjutWURVSgGK9Zq
         adCBaucGEX6BhAR3CYJ1d4rQkS7YtZcUlEl1y6RkpGaWhSUiG5+m2jZuSrE1JlrdZBjQ
         TGe2J90BeKNRJAuvnFC50HVKmN5xHhx7qvJZzwx39u/G4AHpRxSHCeZUWIivNZKx6Kma
         o52/6KfMnnxyR5CzNMGPXDtXzK9ThW8nWV5phFFqyPmxwORO2u0xTMFK20et7EGloK72
         oDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692206635; x=1692811435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PN9U96sXQ/WhiZQpYWPMVe4BliphD8Rxbde/Icx+5GY=;
        b=Qf36FBeyoUOEMNpmZ9/LUkVkQIVmUf1YZbNw97s9x5MVS51XqBIVrzxfA04Z7m+bba
         L6bcs/mkM0wgzdJm9z9Y61fTJkgfkRG/c1rEsy/AvsAaMSb4kPBPIdZyh1k/LQJzUiJK
         AftiHk6xyxAVBkVYVYcj/ixfOKWKvx/MS/ZTY0TKzfIlHc65JXN9MPZNFpqR8kvxSxLE
         MxArHebVPN99kHW4fPwVzF0M72I3J36J3mRGkU7g0YDn7zjE1ZzkLaHzZDQA4Nqm+TlU
         SGcHA6WOUt+IHAYN/3BKZqYW+80YKk9bY3sV+UrrSMxj4h/F8Jx14b82FAg3rsNiqTsN
         F2aQ==
X-Gm-Message-State: AOJu0Yyr/Dm5MeTagi0Mzq5/WHHiFFS/at1YRHxDMVMfrVn52Si00gKq
	bWXmFSqcEwmX+W2Oa55hHJBjfYVyH5zoN3y1denLXA==
X-Google-Smtp-Source: AGHT+IF4RUG2j9sLmcTd2hL11fGmibz3EFlXCoe4A3lVSlT8nFACvdbT546I78Gp4RBecCTFJVE21OgKXGhMdNQjWY0=
X-Received: by 2002:a2e:90cb:0:b0:2b8:3a1e:eec9 with SMTP id
 o11-20020a2e90cb000000b002b83a1eeec9mr1955969ljg.36.1692206635158; Wed, 16
 Aug 2023 10:23:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-12-jingzhangos@google.com> <268054f7-e2f5-37fb-187c-3b2cca41b31a@redhat.com>
In-Reply-To: <268054f7-e2f5-37fb-187c-3b2cca41b31a@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 16 Aug 2023 10:23:43 -0700
Message-ID: <CAAdAUthLunQxN+q+PQxLp1cB=cSn5q_y5DM8av+GTKgkZw+sbQ@mail.gmail.com>
Subject: Re: [PATCH v8 11/11] KVM: arm64: selftests: Test for setting ID
 register from usersapce
To: Shaoqin Huang <shahuang@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>, 
	Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin,

On Tue, Aug 15, 2023 at 11:58=E2=80=AFPM Shaoqin Huang <shahuang@redhat.com=
> wrote:
>
> Hi Jing,
>
> On 8/8/23 00:22, Jing Zhang wrote:
> > Add tests to verify setting ID registers from userapce is handled
> > correctly by KVM. Also add a test case to use ioctl
> > KVM_ARM_GET_REG_WRITABLE_MASKS to get writable masks.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >   tools/testing/selftests/kvm/Makefile          |   1 +
> >   .../selftests/kvm/aarch64/set_id_regs.c       | 453 +++++++++++++++++=
+
> >   2 files changed, 454 insertions(+)
> >   create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
> >
> > +
> > +static void test_guest_reg_read(struct kvm_vcpu *vcpu)
> > +{
> > +     struct ucall uc;
> > +     bool done =3D false;
> > +
> > +     while (!done) {
> > +             vcpu_run(vcpu);
> > +
> > +             switch (get_ucall(vcpu, &uc)) {
> > +             case UCALL_ABORT:
> > +                     REPORT_GUEST_ASSERT(uc);
> > +                     break;
> > +             case UCALL_SYNC:
> > +                     uint64_t val;
> aarch64/set_id_regs.c:408:4: error: a label can only be part of a
> statement and a declaration is not a statement.
>
> I can encounter a compiler error at this line. Why not just put the
> uint64_t at the beginning of the function.

Sure. Will move it to the beginning of the function.

>
> Thanks,
> Shaoqin
>
> > +
> > +                     /* Make sure the written values are seen by guest=
 */
> > +                     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(uc.args[2]),=
 &val);
> > +                     ASSERT_EQ(val, uc.args[3]);
> > +                     break;
> > +             case UCALL_DONE:
> > +                     done =3D true;
> > +                     break;
> > +             default:
> > +                     TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> > +             }
> > +     }
> > +}
> > +
> > +int main(void)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_vm *vm;
> > +     bool aarch64_only;
> > +     uint64_t val, el0;
> > +     int ftr_cnt;
> > +
> > +     vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> > +
> > +     /* Check for AARCH64 only system */
> > +     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> > +     el0 =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
> > +     aarch64_only =3D (el0 =3D=3D ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
> > +
> > +     ksft_print_header();
> > +
> > +     ftr_cnt =3D ARRAY_SIZE(ftr_id_aa64dfr0_el1) + ARRAY_SIZE(ftr_id_d=
fr0_el1)
> > +               + ARRAY_SIZE(ftr_id_aa64pfr0_el1) + ARRAY_SIZE(ftr_id_a=
a64mmfr0_el1)
> > +               + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) + ARRAY_SIZE(ftr_id_=
aa64mmfr2_el1)
> > +               + ARRAY_SIZE(ftr_id_aa64mmfr3_el1) - ARRAY_SIZE(test_re=
gs);
> > +
> > +     ksft_set_plan(ftr_cnt);
> > +
> > +     test_user_set_reg(vcpu, aarch64_only);
> > +     test_guest_reg_read(vcpu);
> > +
> > +     kvm_vm_free(vm);
> > +
> > +     ksft_finished();
> > +}
>
> --
> Shaoqin
>

Thanks,
Jing
