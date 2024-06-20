Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA8A55889
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 22:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718922413; cv=none; b=OewYdoG34gbtZ4Gwkg6vuLlzyHe+ukPc2m/8IEnpNAJK8AlH0j63NCW23oVgny2caafld21dUKNy1QYBJySszuCkjHfykmBP8VTlGSJSwFnBwCAdAmOolDOdesqLmVsoyMeoImrVNAlbOEJ4IboW4uQzszY+Z0Z3Ez7QLwOLLeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718922413; c=relaxed/simple;
	bh=FvUHI+VUbK9QvsBm0bUl9KFIjIfQs/TyEdHPFXxDj4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lVBMyMEIWK252lT2kVWu2jbskAghgHKfC7QuBgPZJj0InA05Ldfn5BNEeeLBI0dsk3wi8thq89rzQnTMTJ0Tpsp1xr8Y2APm/zllg+IkFY94hpj7JDEXJ0DsEMETAlk9NHxApxIbDQYLwiCYZvMgsL4wk+UwU04drxepkB3a1XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ArgNfTZH; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ArgNfTZH"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-443586c2091so171471cf.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 15:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718922410; x=1719527210; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTQciniatudASSh/6rh//JH84EfR5Y6t7KHyoww6Cck=;
        b=ArgNfTZHN8MCYd3B1HR4woezozFv/o7XkTYBDBhvJKPCdO9uUaZlLLeqn8woMiyrmt
         L6i6IJqAPWRmVBIIXxR+S4BxBbXH0NEeUOPvDWrAiJ7fToF2k3PnwpPFUI/e8rWdCYMo
         TiVQXo3u4QYM1Xm3ZjYhU4UESZPBbLon/mIPuUdnh1CclruBu9ymKq5wzNQLFyg/aPJ7
         yt48eoF+7zoDlJSwR0eyPPh4GprdfhqmhpANwcxNl1bzMkC3I0ygfoap4bPiD8Ezk2tn
         13cFeNwSc6FLIoI5DktcgXKHrCo2Huy+8v/79ypseAcyOhlWYVWuRNcqWD0SLIlkCfNV
         S0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718922410; x=1719527210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTQciniatudASSh/6rh//JH84EfR5Y6t7KHyoww6Cck=;
        b=J8KY0YQS17+P8kWzmcTiwMc8A4HvGK4pMAuNuddOXZFhp4c7onRK7ihqc2yZO9Tdwv
         eRbt5rSX4Pqa+epgZqFG8eA8XRE18qMZu4hRIZtS7AOHsmbvEJrFqjAKCMpoisapbiuM
         yOye+0jtkbV2KhWNt4b/DkM+aiRDGFRg5cmtu5e2NoIrXybLUgpFSU60iyUtTFgUxdNW
         VWzj+f3hT+GNc454dnJYZsD2dUrw/jUzPQLrERkp3MGU8to5Kn7wDItp9rCRSanqPEPW
         fhbrhwBCxSvfDhn8ObNB9NSmMaWUV3xWcc5uik4VjDz0G9PPf3dPo119gQh0o/A/0IXt
         FyBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3l+gbfYgWSsX0YRMDE180T7izWiRZppvJ8fCilpo8xEgLhpqKKfh+nEmco8Jaebt8LQjq8r5VCJ6Auc6UB6+nJZCm9dD4
X-Gm-Message-State: AOJu0Yx18yFndWrLuIswjLXoQq0qiQHWPwk5Sv9N5wQrlWL9inAxcoam
	UXPhxcE+8LjrYBIdu463qySnAZCIXlEHT2qxk/y3eKgTBeVxi9ywzH/9q2mY5+xlNNnsqZ1EJxJ
	uHYWxRcye+erSMRv5AOUgowU6grzQ08q52dFa
X-Google-Smtp-Source: AGHT+IHP9NqnX7jOV5DLU9ldDrGPi2k69+82XFA4dAlwWgh6EoZ6XzZ1TesibjCtk0IQ1Tgx25DCvYwEcrFNPq1ySxY=
X-Received: by 2002:a05:622a:14c7:b0:440:3996:84aa with SMTP id
 d75a77b69052e-444c35dcf49mr458631cf.15.1718922409979; Thu, 20 Jun 2024
 15:26:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240619083200.1047073-1-shahuang@redhat.com> <20240619083200.1047073-3-shahuang@redhat.com>
In-Reply-To: <20240619083200.1047073-3-shahuang@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 20 Jun 2024 15:26:35 -0700
Message-ID: <CAJHc60xi7UsLubLUek-sCq9yMyk+R0typEaMB73G+ch+EQrB_Q@mail.gmail.com>
Subject: Re: [PATCH v10 2/3] KVM: selftests: aarch64: Introduce pmu_event_filter_test
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin,

On Wed, Jun 19, 2024 at 1:33=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
> Introduce pmu_event_filter_test for arm64 platforms. The test configures
> PMUv3 for a vCPU, and sets different pmu event filters for the vCPU, and
> check if the guest can see those events which user allow and can't use
> those events which use deny.
>
> This test refactor the create_vpmu_vm() and make it a wrapper for
> __create_vpmu_vm(), which allows some extra init code before
> KVM_ARM_VCPU_PMU_V3_INIT.
>
> And this test use the KVM_ARM_VCPU_PMU_V3_FILTER attribute to set the
> pmu event filter in KVM. And choose to filter two common event
> branches_retired and instructions_retired, and let the guest to check if
> it see the right pmceid register.
>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/pmu_event_filter_test.c       | 314 ++++++++++++++++++
>  2 files changed, 315 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/pmu_event_filter_=
test.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index ac280dcba996..2110b49e7a84 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -153,6 +153,7 @@ TEST_GEN_PROGS_aarch64 +=3D aarch64/aarch32_id_regs
>  TEST_GEN_PROGS_aarch64 +=3D aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 +=3D aarch64/hypercalls
>  TEST_GEN_PROGS_aarch64 +=3D aarch64/page_fault_test
> +TEST_GEN_PROGS_aarch64 +=3D aarch64/pmu_event_filter_test
>  TEST_GEN_PROGS_aarch64 +=3D aarch64/psci_test
>  TEST_GEN_PROGS_aarch64 +=3D aarch64/set_id_regs
>  TEST_GEN_PROGS_aarch64 +=3D aarch64/smccc_filter
> diff --git a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c =
b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
> new file mode 100644
> index 000000000000..308b8677e08e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
> @@ -0,0 +1,314 @@
> +
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * pmu_event_filter_test - Test user limit pmu event for guest.
> + *
> + * Copyright (c) 2023 Red Hat, Inc.
> + *
> + * This test checks if the guest only see the limited pmu event that use=
rspace
> + * sets, if the guest can use those events which user allow, and if the =
guest
> + * can't use those events which user deny.
> + * This test runs only when KVM_CAP_ARM_PMU_V3, KVM_ARM_VCPU_PMU_V3_FILT=
ER
> + * is supported on the host.
> + */
> +#include <kvm_util.h>
> +#include <processor.h>
> +#include <vgic.h>
> +#include <vpmu.h>
> +#include <test_util.h>
> +#include <perf/arm_pmuv3.h>
> +
> +struct pmu_common_event_ids {
> +       uint64_t pmceid0;
> +       uint64_t pmceid1;
> +} max_pmce, expected_pmce;
> +
> +struct vpmu_vm {
> +       struct kvm_vm *vm;
> +       struct kvm_vcpu *vcpu;
> +       int gic_fd;
> +};
> +
> +static struct vpmu_vm vpmu_vm;
> +
> +#define FILTER_NR 10
> +
> +struct test_desc {
> +       const char *name;
> +       struct kvm_pmu_event_filter filter[FILTER_NR];
> +};
> +
> +#define __DEFINE_FILTER(base, num, act)                \
> +       ((struct kvm_pmu_event_filter) {        \
> +               .base_event     =3D base,         \
> +               .nevents        =3D num,          \
> +               .action         =3D act,          \
> +       })
> +
> +#define DEFINE_FILTER(base, act) __DEFINE_FILTER(base, 1, act)
> +
> +#define EVENT_ALLOW(event)     DEFINE_FILTER(event, KVM_PMU_EVENT_ALLOW)
> +#define EVENT_DENY(event)      DEFINE_FILTER(event, KVM_PMU_EVENT_DENY)
> +
> +static void guest_code(void)
> +{
> +       uint64_t pmceid0 =3D read_sysreg(pmceid0_el0);
> +       uint64_t pmceid1 =3D read_sysreg(pmceid1_el0);
> +
> +       GUEST_ASSERT_EQ(expected_pmce.pmceid0, pmceid0);
> +       GUEST_ASSERT_EQ(expected_pmce.pmceid1, pmceid1);
> +
> +       GUEST_DONE();
> +}
> +
> +static void guest_get_pmceid(void)
> +{
> +       max_pmce.pmceid0 =3D read_sysreg(pmceid0_el0);
> +       max_pmce.pmceid1 =3D read_sysreg(pmceid1_el0);
> +
> +       GUEST_DONE();
> +}
> +
> +static void run_vcpu(struct kvm_vcpu *vcpu)
> +{
> +       struct ucall uc;
> +
> +       while (1) {
> +               vcpu_run(vcpu);
> +               switch (get_ucall(vcpu, &uc)) {
> +               case UCALL_DONE:
> +                       return;
> +               case UCALL_ABORT:
> +                       REPORT_GUEST_ASSERT(uc);
> +                       break;
> +               default:
> +                       TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +               }
> +       }
> +}
> +
> +static void set_pmce(struct pmu_common_event_ids *pmce, int action, int =
event)
> +{
> +       int base =3D 0;
> +       uint64_t *pmceid =3D NULL;
> +
> +       if (event >=3D 0x4000) {
> +               event -=3D 0x4000;
> +               base =3D 32;
> +       }
> +
> +       if (event >=3D 0 && event <=3D 0x1F) {
> +               pmceid =3D &pmce->pmceid0;
> +       } else if (event >=3D 0x20 && event <=3D 0x3F) {
> +               event -=3D 0x20;
> +               pmceid =3D &pmce->pmceid1;
> +       } else {
> +               return;
> +       }
> +
> +       event +=3D base;
> +       if (action =3D=3D KVM_PMU_EVENT_ALLOW)
> +               *pmceid |=3D BIT(event);
> +       else
> +               *pmceid &=3D ~BIT(event);
> +}
> +
> +static inline bool is_valid_filter(struct kvm_pmu_event_filter *filter)
> +{
> +       return filter && filter->nevents !=3D 0;
> +}
> +
> +static void prepare_expected_pmce(struct kvm_pmu_event_filter *filter)
> +{
> +       struct pmu_common_event_ids pmce_mask =3D { ~0, ~0 };
> +       int i;
> +
> +       if (is_valid_filter(filter) && filter->action =3D=3D KVM_PMU_EVEN=
T_ALLOW)
> +               memset(&pmce_mask, 0, sizeof(pmce_mask));
> +
> +       while (is_valid_filter(filter)) {
> +               for (i =3D 0; i < filter->nevents; i++)
> +                       set_pmce(&pmce_mask, filter->action,
> +                                filter->base_event + i);
> +               filter++;
> +       }
> +
> +       expected_pmce.pmceid0 =3D max_pmce.pmceid0 & pmce_mask.pmceid0;
> +       expected_pmce.pmceid1 =3D max_pmce.pmceid1 & pmce_mask.pmceid1;
> +}
> +
> +static void pmu_event_filter_init(struct kvm_pmu_event_filter *filter)
> +{
> +       while (is_valid_filter(filter)) {
> +               kvm_device_attr_set(vpmu_vm.vcpu->fd,
> +                                   KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                   KVM_ARM_VCPU_PMU_V3_FILTER,
> +                                   filter);
> +               filter++;
> +       }
> +}
> +
> +/* Create a VM that has one vCPU with PMUv3 configured. */
> +static void create_vpmu_vm_with_filter(void *guest_code,
> +                                      struct kvm_pmu_event_filter *filte=
r)
> +{
> +       uint64_t irq =3D 23;
> +
> +       /* The test creates the vpmu_vm multiple times. Ensure a clean st=
ate */
> +       memset(&vpmu_vm, 0, sizeof(vpmu_vm));
> +
> +       vpmu_vm.vm =3D vm_create(1);
> +       vpmu_vm.vcpu =3D vm_vcpu_add_with_vpmu(vpmu_vm.vm, 0, guest_code)=
;
> +       vpmu_vm.gic_fd =3D vgic_v3_setup(vpmu_vm.vm, 1, 64);
> +       __TEST_REQUIRE(vpmu_vm.gic_fd >=3D 0,
> +                      "Failed to create vgic-v3, skipping");
> +
> +       pmu_event_filter_init(filter);
> +
> +       /* Initialize vPMU */
> +       vpmu_set_irq(vpmu_vm.vcpu, irq);
> +       vpmu_init(vpmu_vm.vcpu);
> +}
> +
> +static void create_vpmu_vm(void *guest_code)
> +{
> +       create_vpmu_vm_with_filter(guest_code, NULL);
> +}
> +
> +static void destroy_vpmu_vm(void)
> +{
> +       close(vpmu_vm.gic_fd);
> +       kvm_vm_free(vpmu_vm.vm);
> +}
> +
> +static void run_test(struct test_desc *t)
> +{
> +       pr_info("Test: %s\n", t->name);
> +
> +       create_vpmu_vm_with_filter(guest_code, t->filter);
> +       prepare_expected_pmce(t->filter);
> +       sync_global_to_guest(vpmu_vm.vm, expected_pmce);
> +
> +       run_vcpu(vpmu_vm.vcpu);
> +
> +       destroy_vpmu_vm();
> +}
> +
> +static struct test_desc tests[] =3D {
> +       {
> +               .name =3D "without_filter",
> +               .filter =3D {
> +                       { 0 }
> +               },
> +       },
> +       {
> +               .name =3D "member_allow_filter",
> +               .filter =3D {
> +                       EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_SW_INCR),
> +                       EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +                       EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_BR_RETIRED),
> +                       { 0 },
> +               },
> +       },
> +       {
> +               .name =3D "member_deny_filter",
> +               .filter =3D {
> +                       EVENT_DENY(ARMV8_PMUV3_PERFCTR_SW_INCR),
> +                       EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
> +                       EVENT_DENY(ARMV8_PMUV3_PERFCTR_BR_RETIRED),
> +                       { 0 },
> +               },
> +       },
> +       {
> +               .name =3D "not_member_deny_filter",
> +               .filter =3D {
> +                       EVENT_DENY(ARMV8_PMUV3_PERFCTR_SW_INCR),
> +                       { 0 },
> +               },
> +       },
> +       {
> +               .name =3D "not_member_allow_filter",
> +               .filter =3D {
> +                       EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_SW_INCR),
> +                       { 0 },
> +               },
> +       },
> +       {
> +               .name =3D "deny_chain_filter",
> +               .filter =3D {
> +                       EVENT_DENY(ARMV8_PMUV3_PERFCTR_CHAIN),
> +                       { 0 },
> +               },
> +       },
> +       {
> +               .name =3D "deny_cpu_cycles_filter",
> +               .filter =3D {
> +                       EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +                       { 0 },
> +               },
> +       },
> +       {
> +               .name =3D "cancel_allow_filter",
> +               .filter =3D {
> +                       EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +                       EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +               },
> +       },
> +       {
> +               .name =3D "cancel_deny_filter",
> +               .filter =3D {
> +                       EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +                       EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
> +               },
> +       },
> +       {
> +               .name =3D "multiple_filter",
> +               .filter =3D {
> +                       __DEFINE_FILTER(0x0, 0x10, KVM_PMU_EVENT_ALLOW),
> +                       __DEFINE_FILTER(0x6, 0x3, KVM_PMU_EVENT_DENY),
> +               },
> +       },
> +       { 0 }
> +};
> +
> +static void run_tests(void)
> +{
> +       struct test_desc *t;
> +
> +       for (t =3D &tests[0]; t->name; t++)
> +               run_test(t);
> +}
> +
> +static int used_pmu_events[] =3D {
> +       ARMV8_PMUV3_PERFCTR_BR_RETIRED,
> +       ARMV8_PMUV3_PERFCTR_INST_RETIRED,
> +       ARMV8_PMUV3_PERFCTR_CHAIN,
> +       ARMV8_PMUV3_PERFCTR_CPU_CYCLES,
> +};
> +
> +static bool kvm_pmu_support_events(void)
> +{
> +       struct pmu_common_event_ids used_pmce =3D { 0, 0 };
> +
> +       create_vpmu_vm(guest_get_pmceid);
> +
> +       memset(&max_pmce, 0, sizeof(max_pmce));
> +       sync_global_to_guest(vpmu_vm.vm, max_pmce);
> +       run_vcpu(vpmu_vm.vcpu);
> +       sync_global_from_guest(vpmu_vm.vm, max_pmce);
> +       destroy_vpmu_vm();
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(used_pmu_events); i++)
> +               set_pmce(&used_pmce, KVM_PMU_EVENT_ALLOW, used_pmu_events=
[i]);
> +
> +       return ((max_pmce.pmceid0 & used_pmce.pmceid0) =3D=3D used_pmce.p=
mceid0) &&
> +              ((max_pmce.pmceid1 & used_pmce.pmceid1) =3D=3D used_pmce.p=
mceid1);
> +}
> +
> +int main(void)
> +{
> +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
> +       TEST_REQUIRE(kvm_pmu_support_events());
> +
> +       run_tests();
> +}
> --
> 2.40.1
>
>
Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>

- Raghavendra
