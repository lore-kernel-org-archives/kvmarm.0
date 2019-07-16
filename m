Return-Path: <SRS0=eCDF=VN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A26C7618F
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 18:50:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EA972064B
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 18:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EA972064B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B915D4A544;
	Tue, 16 Jul 2019 14:50:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Qdz7YKKrGbE; Tue, 16 Jul 2019 14:50:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D1B74A54D;
	Tue, 16 Jul 2019 14:50:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B70FF4A544
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 14:50:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FUIwUlslikYM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jul 2019 14:50:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3564A532
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 14:50:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FEEF2B;
 Tue, 16 Jul 2019 11:50:46 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB7E83F59C;
 Tue, 16 Jul 2019 11:50:45 -0700 (PDT)
Date: Tue, 16 Jul 2019 19:50:44 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 kvm_pmu_get_canonical_pmc+0x48/0x78
Message-ID: <20190716185043.GV7227@e119886-lin.cambridge.arm.com>
References: <644e3455-ea6d-697a-e452-b58961341381@huawei.com>
 <f9d5d18a-7631-f3e2-d73a-21d8eee183f1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f9d5d18a-7631-f3e2-d73a-21d8eee183f1@huawei.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Jul 16, 2019 at 11:14:37PM +0800, Zenghui Yu wrote:
> =

> On 2019/7/16 23:05, Zenghui Yu wrote:
> > Hi folks,
> > =

> > Running the latest kernel with KASAN enabled, we will hit the following
> > KASAN BUG during guest's boot process.
> > =

> > I'm in commit 9637d517347e80ee2fe1c5d8ce45ba1b88d8b5cd.
> > =

> > Any problems in the chained PMU code? Or just a false positive?
> > =

> > ---8<---
> > =

> > [=A0 654.706268]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [=A0 654.706280] BUG: KASAN: slab-out-of-bounds in
> > kvm_pmu_get_canonical_pmc+0x48/0x78
> > [=A0 654.706286] Read of size 8 at addr ffff801d6c8fea38 by task
> > qemu-kvm/23268
> > =

> > [=A0 654.706296] CPU: 2 PID: 23268 Comm: qemu-kvm Not tainted 5.2.0+ #1=
78
> > [=A0 654.706301] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58
> > 10/24/2018
> > [=A0 654.706305] Call trace:
> > [=A0 654.706311]=A0 dump_backtrace+0x0/0x238
> > [=A0 654.706317]=A0 show_stack+0x24/0x30
> > [=A0 654.706325]=A0 dump_stack+0xe0/0x134
> > [=A0 654.706332]=A0 print_address_description+0x80/0x408
> > [=A0 654.706338]=A0 __kasan_report+0x164/0x1a0
> > [=A0 654.706343]=A0 kasan_report+0xc/0x18
> > [=A0 654.706348]=A0 __asan_load8+0x88/0xb0
> > [=A0 654.706353]=A0 kvm_pmu_get_canonical_pmc+0x48/0x78
> =

> I noticed that we will use "pmc->idx" and the "chained" bitmap to
> determine if the pmc is chained, in kvm_pmu_pmc_is_chained().
> =

> Should we initialize the idx and the bitmap appropriately before
> doing kvm_pmu_stop_counter()?  Like:

Hi Zenghui,

Thanks for spotting this and investigating - I'll make sure to use KASAN
in the future when testing...

> =

> =

> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 3dd8238..cf3119a 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -224,12 +224,12 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  	int i;
>  	struct kvm_pmu *pmu =3D &vcpu->arch.pmu;
> =

> +	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
> +
>  	for (i =3D 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> -		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
>  		pmu->pmc[i].idx =3D i;
> +		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
>  	}
> -
> -	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  }

We have to be a little careful here, as the vcpu may be reset after use.
Upon resetting we must ensure that any existing perf_events are released -
this is why kvm_pmu_stop_counter is called before bitmap_zero (as
kvm_pmu_stop_counter relies on kvm_pmu_pmc_is_chained).

(For example, by clearing the bitmap before stopping the counters, we will
attempt to release the perf event for both pmc's in a chained pair. Whereas
we should only release the canonical pmc. It's actually OK right now as we
set the non-canonical pmc perf_event will be NULL - but who knows that this
will hold true in the future. The code makes the assumption that the
non-canonical perf event isn't touched on a chained pair).

The KASAN bug gets fixed by moving the assignment of idx before =

kvm_pmu_stop_counter. Therefore I'd suggest you drop the bitmap_zero hunks.

Can you send a patch with just the idx assignment hunk please?

Thanks,

Andrew Murray

> =

>  /**
> =

> =

> Thanks,
> zenghui
> =

> > [=A0 654.706358]=A0 kvm_pmu_stop_counter+0x28/0x118
> > [=A0 654.706363]=A0 kvm_pmu_vcpu_reset+0x60/0xa8
> > [=A0 654.706369]=A0 kvm_reset_vcpu+0x30/0x4d8
> > [=A0 654.706376]=A0 kvm_arch_vcpu_ioctl+0xa04/0xc18
> > [=A0 654.706381]=A0 kvm_vcpu_ioctl+0x17c/0xde8
> > [=A0 654.706387]=A0 do_vfs_ioctl+0x150/0xaf8
> > [=A0 654.706392]=A0 ksys_ioctl+0x84/0xb8
> > [=A0 654.706397]=A0 __arm64_sys_ioctl+0x4c/0x60
> > [=A0 654.706403]=A0 el0_svc_common.constprop.0+0xb4/0x208
> > [=A0 654.706409]=A0 el0_svc_handler+0x3c/0xa8
> > [=A0 654.706414]=A0 el0_svc+0x8/0xc
> > =

> > [=A0 654.706422] Allocated by task 23268:
> > [=A0 654.706429]=A0 __kasan_kmalloc.isra.0+0xd0/0x180
> > [=A0 654.706435]=A0 kasan_slab_alloc+0x14/0x20
> > [=A0 654.706440]=A0 kmem_cache_alloc+0x17c/0x4a8
> > [=A0 654.706445]=A0 kvm_arch_vcpu_create+0xa0/0x130
> > [=A0 654.706451]=A0 kvm_vm_ioctl+0x844/0x1218
> > [=A0 654.706456]=A0 do_vfs_ioctl+0x150/0xaf8
> > [=A0 654.706461]=A0 ksys_ioctl+0x84/0xb8
> > [=A0 654.706466]=A0 __arm64_sys_ioctl+0x4c/0x60
> > [=A0 654.706472]=A0 el0_svc_common.constprop.0+0xb4/0x208
> > [=A0 654.706478]=A0 el0_svc_handler+0x3c/0xa8
> > [=A0 654.706482]=A0 el0_svc+0x8/0xc
> > =

> > [=A0 654.706490] Freed by task 0:
> > [=A0 654.706493] (stack is not available)
> > =

> > [=A0 654.706501] The buggy address belongs to the object at ffff801d6c8=
fc010
> >  =A0which belongs to the cache kvm_vcpu of size 10784
> > [=A0 654.706507] The buggy address is located 8 bytes to the right of
> >  =A010784-byte region [ffff801d6c8fc010, ffff801d6c8fea30)
> > [=A0 654.706510] The buggy address belongs to the page:
> > [=A0 654.706516] page:ffff7e0075b23f00 refcount:1 mapcount:0
> > mapping:ffff801db257e480 index:0x0 compound_mapcount: 0
> > [=A0 654.706524] flags: 0xffffe0000010200(slab|head)
> > [=A0 654.706532] raw: 0ffffe0000010200 ffff801db2586ee0 ffff801db2586ee0
> > ffff801db257e480
> > [=A0 654.706538] raw: 0000000000000000 0000000000010001 00000001ffffffff
> > 0000000000000000
> > [=A0 654.706542] page dumped because: kasan: bad access detected
> > =

> > [=A0 654.706549] Memory state around the buggy address:
> > [=A0 654.706554]=A0 ffff801d6c8fe900: 00 00 00 00 00 00 00 00 00 00 00 =
00 00
> > 00 00 00
> > [=A0 654.706560]=A0 ffff801d6c8fe980: 00 00 00 00 00 00 00 00 00 00 00 =
00 00
> > 00 00 00
> > [=A0 654.706565] >ffff801d6c8fea00: 00 00 00 00 00 00 fc fc fc fc fc fc=
 fc
> > fc fc fc
> > [=A0 654.706568]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^
> > [=A0 654.706573]=A0 ffff801d6c8fea80: fc fc fc fc fc fc fc fc fc fc fc =
fc fc
> > fc fc fc
> > [=A0 654.706578]=A0 ffff801d6c8feb00: fc fc fc fc fc fc fc fc fc fc fc =
fc fc
> > fc fc fc
> > [=A0 654.706582]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
