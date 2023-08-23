Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9C24C75
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 11:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1692789352; x=1724325352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J1ClHpixZj7fuU2joNIT//doEwehogJ3lrBUfMEBCzk=;
  b=LwqQ/6FnhpO2q2maaOrZSuSI1Kky/ZiOEiPxoO8+OhqlWoHnQS0YaGrc
   oibSQOEVxXOAkg8Y70Tsm6wle5dHtJeXqWxNgP5bq+7+eBtNjeBM3envy
   KckFdGpdXQ9M1rGA3QoSvRI7J4F/Ob8NeEeq10eoqhPm6naQvKuMAPp+b
   y8PVRlqX744PB+NoBJnMg4HaUzUYU9qUE6HR1snF0qupHDHBkLIeA/UJW
   kG6fQBpnV5muBpg+GoyN+8LRerndqwqJ4UdxlvJvYM977JG2ANhElTg6e
   FRVMf0PE0snTKllkuHVu6fpVSrvCCEXtVsPmdiej7Xe2RIFpIElPJbLD7
   A==;
X-IronPort-AV: E=Sophos;i="6.01,195,1684792800"; 
   d="scan'208";a="32585053"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 23 Aug 2023 13:15:48 +0200
Received: from steina-w.localnet (steina-w.tq-net.de [10.123.53.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 3ABDB280075;
	Wed, 23 Aug 2023 13:15:48 +0200 (CEST)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, Huang Shijie <shijie@os.amperecomputing.com>, Leo Yan <leo.yan@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: pmu: Resync EL0 state on counter rotation
Date: Wed, 23 Aug 2023 13:15:47 +0200
Message-ID: <4055305.aeNJFYEL58@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <86h6oqf712.wl-maz@kernel.org>
References: <20230820090108.177817-1-maz@kernel.org> <14141350.uLZWGnKmhe@steina-w> <86h6oqf712.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi Marc,

Am Mittwoch, 23. August 2023, 11:21:45 CEST schrieb Marc Zyngier:
> On Wed, 23 Aug 2023 08:15:38 +0100,
>=20
> Alexander Stein <alexander.stein@ew.tq-group.com> wrote:
> > Hi,
> >=20
> > > diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> > > index 08b3a1bf0ef6..6a3d8176f54a 100644
> > > --- a/drivers/perf/arm_pmuv3.c
> > > +++ b/drivers/perf/arm_pmuv3.c
> > > @@ -772,6 +772,8 @@ static void armv8pmu_start(struct arm_pmu *cpu_pm=
u)
> > >=20
> > >  	/* Enable all counters */
> > >  	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
> > >=20
> > > +
> > > +	kvm_vcpu_pmu_resync_el0();
> >=20
> > This breaks if CONFIG_HW_PERF_EVENTS is enabled but CONFIG_KVM is not. =
As
> > in this case arch/arm64/kvm/pmu.c is never compiled, but the dummy inli=
ne
> > in include/kvm/arm_pmu.h for kvm_vcpu_pmu_resync_el0() only depends on
> > CONFIG_HW_PERF_EVENTS.
> > This results in this error:
> >=20
> > aarch64-v8a-linux-gnu-ld: Unexpected GOT/PLT entries detected!
> > aarch64-v8a-linux-gnu-ld: Unexpected run-time procedure linkages detect=
ed!
> > aarch64-v8a-linux-gnu-ld: drivers/perf/arm_pmuv3.o: in function
> > `armv8pmu_start':
> > drivers/perf/arm_pmuv3.c:753: undefined reference to
> > `kvm_vcpu_pmu_resync_el0'
> Huh, that's unexpected. Let's fix it with an adequately sized hammer.
> Does the patch below work for you?

Yes, the patch below does work for me. Thanks.
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>

Best regards,
Alexander

> Thanks,
>=20
> 	M.
>=20
> From 2446f15d355ab7e766291eccf5b670a2060b4c3a Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Wed, 23 Aug 2023 10:14:48 +0100
> Subject: [PATCH] KVM: arm64: pmu: Guard PMU emulation definitions with
>  CONFIG_KVM
>=20
> Most of the internal definitions for PMU emulation are guarded with
> CONFIG_HW_PERF_EVENTS. However, this isn't enough, and leads to
> these definitions leaking if CONFIG_KVM isn't enabled.
>=20
> This leads to some compilation breakage in this exact configuration.
> Fix it by falling back to the dummy stubs if either perf or KVM
> isn't selected.
>=20
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/kvm/arm_pmu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 3a8a70a60794..31029f4f7be8 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -12,7 +12,7 @@
>=20
>  #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
>=20
> -#ifdef CONFIG_HW_PERF_EVENTS
> +#if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
>=20
>  struct kvm_pmc {
>  	u8 idx;	/* index into the pmu->pmc array */


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/


