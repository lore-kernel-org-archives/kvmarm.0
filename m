Return-Path: <SRS0=tngP=VU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B237FC7618B
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 11:14:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43EDD21901
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 11:14:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43EDD21901
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7DC24A577;
	Tue, 23 Jul 2019 07:14:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FdkS7CT3240d; Tue, 23 Jul 2019 07:14:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5709A4A527;
	Tue, 23 Jul 2019 07:14:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 728764A525
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 07:14:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cqtOSuN+HK+R for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jul 2019 07:14:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEEA14A511
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 07:14:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 445C9337;
 Tue, 23 Jul 2019 04:14:31 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 586BE3F71A;
 Tue, 23 Jul 2019 04:14:30 -0700 (PDT)
Date: Tue, 23 Jul 2019 12:14:24 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/9] KVM: arm/arm64: vgic: ITS translation cache
Message-ID: <20190723121424.0b632efa@donnerap.cambridge.arm.com>
In-Reply-To: <20190611170336.121706-1-marc.zyngier@arm.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>, "Saidi,
 Ali" <alisaidi@amazon.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, 11 Jun 2019 18:03:27 +0100
Marc Zyngier <marc.zyngier@arm.com> wrote:

Hi,

> It recently became apparent[1] that our LPI injection path is not as
> efficient as it could be when injecting interrupts coming from a VFIO
> assigned device.
> 
> Although the proposed patch wasn't 100% correct, it outlined at least
> two issues:
> 
> (1) Injecting an LPI from VFIO always results in a context switch to a
>     worker thread: no good
> 
> (2) We have no way of amortising the cost of translating a DID+EID pair
>     to an LPI number
> 
> The reason for (1) is that we may sleep when translating an LPI, so we
> do need a context process. A way to fix that is to implement a small
> LPI translation cache that could be looked up from an atomic
> context. It would also solve (2).
> 
> This is what this small series proposes. It implements a very basic
> LRU cache of pre-translated LPIs, which gets used to implement
> kvm_arch_set_irq_inatomic. The size of the cache is currently
> hard-coded at 16 times the number of vcpus, a number I have picked
> under the influence of Ali Saidi. If that's not enough for you, blame
> me, though.
> 
> Does it work? well, it doesn't crash, and is thus perfect. More
> seriously, I don't really have a way to benchmark it directly, so my
> observations are only indirect:
> 
> On a TX2 system, I run a 4 vcpu VM with an Ethernet interface passed
> to it directly. From the host, I inject interrupts using debugfs. In
> parallel, I look at the number of context switch, and the number of
> interrupts on the host. Without this series, I get the same number for
> both IRQ and CS (about half a million of each per second is pretty
> easy to reach). With this series, the number of context switches drops
> to something pretty small (in the low 2k), while the number of
> interrupts stays the same.
> 
> Yes, this is a pretty rubbish benchmark, what did you expect? ;-)
> 
> So I'm putting this out for people with real workloads to try out and
> report what they see.

So I gave that a shot with some benchmarks. As expected, it is quite hard
to show an improvement with just one guest running, although we could show
a 103%(!) improvement of the memcached QPS score in one experiment when
running it in a guest with an external load generator.
Throwing more users into the game showed a significant improvement:

Benchmark 1: kernel compile/FIO: Compiling a kernel on the host, while
letting a guest run FIO with 4K randreads from a passed-through NVMe SSD:
The IOPS with this series improved by 27% compared to pure mainline,
reaching 80% of the host value. Kernel compilation time improved by 8.5%
compared to mainline.

Benchmark 2: FIO/FIO: Running FIO on a passed through SATA SSD in one
guest, and FIO on a passed through NVMe SSD in another guest, at the same
time:
The IOPS with this series improved by 23% for the NVMe and 34% for the
SATA disk, compared to pure mainline.

So judging from these results, I think this series is a significant
improvement, which justifies it to be merged, to receive wider testing.

It would be good if others could also do performance experiments and post
their results.

Cheers,
Andre.

> [1] https://lore.kernel.org/lkml/1552833373-19828-1-git-send-email-yuzenghui@huawei.com/
> 
> * From v1:
> 
>   - Fixed race on allocation, where the same LPI could be cached multiple times
>   - Now invalidate the cache on vgic teardown, avoiding memory leaks
>   - Change patch split slightly, general reshuffling
>   - Small cleanups here and there
>   - Rebased on 5.2-rc4
> 
> Marc Zyngier (9):
>   KVM: arm/arm64: vgic: Add LPI translation cache definition
>   KVM: arm/arm64: vgic: Add __vgic_put_lpi_locked primitive
>   KVM: arm/arm64: vgic-its: Add MSI-LPI translation cache invalidation
>   KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on
>     specific commands
>   KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on
>     disabling LPIs
>   KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on vgic
>     teardown
>   KVM: arm/arm64: vgic-its: Cache successful MSI->LPI translation
>   KVM: arm/arm64: vgic-its: Check the LPI translation cache on MSI
>     injection
>   KVM: arm/arm64: vgic-irqfd: Implement kvm_arch_set_irq_inatomic
> 
>  include/kvm/arm_vgic.h           |   3 +
>  virt/kvm/arm/vgic/vgic-init.c    |   5 +
>  virt/kvm/arm/vgic/vgic-irqfd.c   |  36 +++++-
>  virt/kvm/arm/vgic/vgic-its.c     | 204 +++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |   4 +-
>  virt/kvm/arm/vgic/vgic.c         |  26 ++--
>  virt/kvm/arm/vgic/vgic.h         |   5 +
>  7 files changed, 267 insertions(+), 16 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
