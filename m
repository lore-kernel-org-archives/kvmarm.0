Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4398B1B0421
	for <kvmarm@lists.linux.dev>; Sat, 12 Jul 2025 00:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278409; cv=none; b=rM6DWX3D4RG3b9oT/QatWPT2DbW+wdmrx5iiqCeXO5AJ7eaUlkHeLnFT51s9u0s0V4hzfhBFU5EKWIjSView7IN/7D4p01dwhBcd820ZuirkaH38SoqoT7VJ2ExMQvu71g9uRDP69sHOY0nw6wknW3ftP6b1DYd7hAG14MPskHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278409; c=relaxed/simple;
	bh=PtSvbvn1QcCg0DBk1whBIsA/eSOY+4nsci4fAX624Z0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PU41jcSIT9B0WvFdh8mmoI6o0dTWUWqkYYMEkRDipJCMKuYlT7kv0DxspKho/uBLPLaKizGaMw+OOx14Y+mHxzz8tZziu05eQwdXyuhbB9D6wZZWqANlcra8syWNrlHwLrtxbpQOs0hKdlfNIimwsrd+ADpKTNQmzyQYEWuC8n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wAzwwld3; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wAzwwld3"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-453663b7bf1so27495e9.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 17:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752278406; x=1752883206; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tx2qCtcW1iHm6LrN7B3tW80PWrDcUeBrILrqk51qr+0=;
        b=wAzwwld3TF+Bbvqv2ywITysLzBlgA+rXmGCPvfY/7eFTrG1YUiN7KgdPKWLPYtCw3h
         F+53H1hDqFehGGxmOHNxSEillT90QKyn1YBhU6cA4popy6v2aThN+4reLD0wpE2mkNNv
         e1o89vnlOXIttzYl3jgTuc9QySVW92rQyhxLlc5pBeRTIIAadi7wleuMxVADZa4/5Kc+
         QfUhwKn6JlBYvZp09RDXi8jL2V72NrexPUxJ78PGvdhFarD6CNQny/3FOvbJcly6RUFi
         jJ35r0xDTlUeYU6jJhkn5HL7BdcIRr/gP3P8xI2JTCvzsz6nr9J0pf+OYkN1NXw5BYbS
         qUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752278406; x=1752883206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tx2qCtcW1iHm6LrN7B3tW80PWrDcUeBrILrqk51qr+0=;
        b=wQlfItRyGlCXNDDHFJuP8nQ7IfJbqOnsX5JScAHunmsqSLWzI0yKoWmY/uv4xceAEc
         1HwEXRsFBulC6FYAmLlE6WXWqnUp/peN02Rz5E9X+5zBD81HjgZotDHdfTz4B2hb3h0G
         aaALupYqAKFkeW3eLXMoje303Ae9y0kHMgjgFaCp7NPUMnlrI7YDXqzIZdNPqV2qhEIp
         3hGcqbACOSw2bkg5DIdJW7fKTQTuO2nNWosmX1Q7fk6x9HJmVgmT+SGlkfzuRWz74k0r
         SgswhB3kfvYM/R7YltyuQZLOppFjL90+sWNBijahVEYWTU/DsJ/a65g1vz5jbUkcCNHH
         KdCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWACwzVEUQ8V7GhBpC8xkUQxGoqwaGSmXs/Fo9ZAoavBXtnO0ca/oN5nWKzwcLHfGTioy4pEKE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy14YbBo2tmHDtuCGgX4mRrG02VwciyZwz1DzF6rSnxrx2I4jR
	dk3P1bdKBNCyVpCvIo4W0tV9eQPNxYQNlRlrimyCK/BmgOSAaxnti2CEH+g8zc3myYYpJ8brBw/
	1HrK+SlJNZWTvR2qmcmRrYiGXSucYDcD838bmmZKg
X-Gm-Gg: ASbGncutsW7kSXea3evZy3J8OruFYVbjjdUPIZJWiYgar1FY3siHLcz+vCDfyRVD/nD
	K7BJJv2jSfXcxsgWJG47aYJXn7U7QD89jMD0TeZKI1yK4qZQJ2nz4Y43KghsT/uWppRxkw6IGgd
	/P6JTwOrHimeWYcNrJBwC+Q7ScZQ8P3V61iO0Gnz2dUtHXaVLU3xFj6FU6TNvjjmQGCbOQNm+1c
	SHvx4ORKFXElNY00QhQGNTUt3Oq3IFU4W6MxA==
X-Google-Smtp-Source: AGHT+IGm/4nykkyL/t8NH+t513GwsEYgWr6SSPjErflvI3eUGlmuciPanbhrR0B98Q027GSJ0c2DKA/l/x09XDzmWT0=
X-Received: by 2002:a05:600c:5023:b0:453:79c3:91d6 with SMTP id
 5b1f17b1804b1-45604733553mr315825e9.1.1752278405508; Fri, 11 Jul 2025
 17:00:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250604050902.3944054-1-jiaqiyan@google.com> <20250604050902.3944054-6-jiaqiyan@google.com>
 <aHFpt0qJF-Rvb2bS@linux.dev>
In-Reply-To: <aHFpt0qJF-Rvb2bS@linux.dev>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 11 Jul 2025 16:59:53 -0700
X-Gm-Features: Ac12FXxsGWdg2WMinw3VOi85RWYlMpcQBa3KtW7EiT-XKhADcP3_mP0w71DBbsg
Message-ID: <CACw3F525HQZ81riTQPuhR0moe8tNEst2AycwrGuM5xDq=oJGaw@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: selftests: Test for KVM_CAP_INJECT_EXT_IABT
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 12:45=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Wed, Jun 04, 2025 at 05:09:00AM +0000, Jiaqi Yan wrote:
> > Test userspace can use KVM_SET_VCPU_EVENTS to inject an external
> > instruction abort into guest. The test injects instruction abort at an
> > arbitrary time without real SEA happening in the guest VCPU, so only
> > certain ESR_EL1 bits are expected and asserted.
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>
> I reworked mmio_abort to be a general external abort test, can you add
> your test cases there in the next spin (arm64/external_aborts.c)?

For sure!

>
> Thanks,
> Oliver
>
> > ---
> >  tools/arch/arm64/include/uapi/asm/kvm.h       |  3 +-
> >  tools/testing/selftests/kvm/Makefile.kvm      |  1 +
> >  .../testing/selftests/kvm/arm64/inject_iabt.c | 98 +++++++++++++++++++
> >  3 files changed, 101 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/arm64/inject_iabt.c
> >
> > diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64=
/include/uapi/asm/kvm.h
> > index af9d9acaf9975..d3a4530846311 100644
> > --- a/tools/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/tools/arch/arm64/include/uapi/asm/kvm.h
> > @@ -184,8 +184,9 @@ struct kvm_vcpu_events {
> >               __u8 serror_pending;
> >               __u8 serror_has_esr;
> >               __u8 ext_dabt_pending;
> > +             __u8 ext_iabt_pending;
> >               /* Align it to 8 bytes */
> > -             __u8 pad[5];
> > +             __u8 pad[4];
> >               __u64 serror_esr;
> >       } exception;
> >       __u32 reserved[12];
> > diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/s=
elftests/kvm/Makefile.kvm
> > index 9eecce6b8274f..e6b504ded9c1c 100644
> > --- a/tools/testing/selftests/kvm/Makefile.kvm
> > +++ b/tools/testing/selftests/kvm/Makefile.kvm
> > @@ -149,6 +149,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/arch_timer_edge_cas=
es
> >  TEST_GEN_PROGS_arm64 +=3D arm64/debug-exceptions
> >  TEST_GEN_PROGS_arm64 +=3D arm64/host_sve
> >  TEST_GEN_PROGS_arm64 +=3D arm64/hypercalls
> > +TEST_GEN_PROGS_arm64 +=3D arm64/inject_iabt
> >  TEST_GEN_PROGS_arm64 +=3D arm64/mmio_abort
> >  TEST_GEN_PROGS_arm64 +=3D arm64/page_fault_test
> >  TEST_GEN_PROGS_arm64 +=3D arm64/psci_test
> > diff --git a/tools/testing/selftests/kvm/arm64/inject_iabt.c b/tools/te=
sting/selftests/kvm/arm64/inject_iabt.c
> > new file mode 100644
> > index 0000000000000..0c7999e5ba5b3
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/arm64/inject_iabt.c
> > @@ -0,0 +1,98 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * inject_iabt.c - Tests for injecting instruction aborts into guest.
> > + */
> > +
> > +#include "processor.h"
> > +#include "test_util.h"
> > +
> > +static void expect_iabt_handler(struct ex_regs *regs)
> > +{
> > +     u64 esr =3D read_sysreg(esr_el1);
> > +
> > +     GUEST_PRINTF("Handling Guest SEA\n");
> > +     GUEST_PRINTF("  ESR_EL1=3D%#lx\n", esr);
> > +
> > +     GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_IABT_CUR);
> > +     GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static void guest_code(void)
> > +{
> > +     GUEST_FAIL("Guest should only run SEA handler");
> > +}
> > +
> > +static void vcpu_run_expect_done(struct kvm_vcpu *vcpu)
> > +{
> > +     struct ucall uc;
> > +     bool guest_done =3D false;
> > +
> > +     do {
> > +             vcpu_run(vcpu);
> > +             switch (get_ucall(vcpu, &uc)) {
> > +             case UCALL_ABORT:
> > +                     REPORT_GUEST_ASSERT(uc);
> > +                     break;
> > +             case UCALL_PRINTF:
> > +                     ksft_print_msg("From guest: %s", uc.buffer);
> > +                     break;
> > +             case UCALL_DONE:
> > +                     ksft_print_msg("Guest done gracefully!\n");
> > +                     guest_done =3D true;
> > +                     break;
> > +             default:
> > +                     TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> > +             }
> > +     } while (!guest_done);
> > +}
> > +
> > +static void vcpu_inject_ext_iabt(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_events events =3D {};
> > +
> > +     events.exception.ext_iabt_pending =3D true;
> > +     vcpu_events_set(vcpu, &events);
> > +}
> > +
> > +static void vcpu_inject_invalid_abt(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_events events =3D {};
> > +     int r;
> > +
> > +     events.exception.ext_iabt_pending =3D true;
> > +     events.exception.ext_dabt_pending =3D true;
> > +
> > +     ksft_print_msg("Injecting invalid external abort events\n");
> > +     r =3D __vcpu_ioctl(vcpu, KVM_SET_VCPU_EVENTS, &events);
> > +     TEST_ASSERT(r && errno =3D=3D EINVAL,
> > +                 KVM_IOCTL_ERROR(KVM_SET_VCPU_EVENTS, r));
> > +}
> > +
> > +static void test_inject_iabt(void)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_vm *vm;
> > +
> > +     vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> > +
> > +     vm_init_descriptor_tables(vm);
> > +     vcpu_init_descriptor_tables(vcpu);
> > +
> > +     vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> > +                             ESR_ELx_EC_IABT_CUR, expect_iabt_handler)=
;
> > +
> > +     vcpu_inject_invalid_abt(vcpu);
> > +
> > +     vcpu_inject_ext_iabt(vcpu);
> > +     vcpu_run_expect_done(vcpu);
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +int main(void)
> > +{
> > +     test_inject_iabt();
> > +     return 0;
> > +}
> > --
> > 2.49.0.1266.g31b7d2e469-goog
> >
