From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v7 0/4] support exception state migration and set
 VSESR_EL2 by user space
Date: Wed, 11 Jul 2018 11:14:37 +0800
Message-ID: <feb40428-c1a3-d756-6f9a-f63e22022237@huawei.com>
References: <20180710164952.23736-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22F924A0D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 23:03:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IcnRJalFN52K for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jul 2018 23:03:53 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D64694065F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 23:03:52 -0400 (EDT)
In-Reply-To: <20180710164952.23736-1-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linuxarm@huawei.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2018/7/11 0:49, James Morse wrote:
> Hi guys,
> 
> This is GengDongjiu's get/set events series[0], with additional plumbing for
> 32bit.

Thanks for the extension to support 32bits platform, it is great

> 
> This series adds the get/set events API to KVM for arm/arm64 so that
> user-space can migrate pending SError, (which KVM may have made pending
> as part of its device emulation), and for RAS make a new SError with a
> specific ESR value pending. (Only systems with the v8.2 RAS Extensions
> can specify an ESR, KVM advertises this capability with a new cap:
> KVM_CAP_ARM_INJECT_SERROR_ESR)
> 
> User-space can use this for emulation of the v8.2 CPU RAS features
> (using error nodes backed by mmio) or as part of NOTIFY_SEI which
> extends a v8.2 RAS SError to also have firmware-first CPER records.
> 
> 
> Thanks,
> 
> James
> 
> [0] https://lists.cs.columbia.edu/pipermail/kvmarm/2018-July/032010.html
> 
> Dongjiu Geng (2):
>   arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
>   arm64: KVM: export the capability to set guest SError syndrome
> 
> James Morse (2):
>   KVM: arm64: Share the parts of get/set events useful to 32bit
>   KVM: arm: Add 32bit get/set events support
> 
>  Documentation/virtual/kvm/api.txt    | 44 +++++++++++++++++++++++---
>  arch/arm/include/asm/kvm_host.h      |  5 +++
>  arch/arm/include/uapi/asm/kvm.h      | 13 ++++++++
>  arch/arm/kvm/guest.c                 | 23 ++++++++++++++
>  arch/arm64/include/asm/kvm_emulate.h |  5 +++
>  arch/arm64/include/asm/kvm_host.h    |  7 +++++
>  arch/arm64/include/uapi/asm/kvm.h    | 13 ++++++++
>  arch/arm64/kvm/guest.c               | 33 +++++++++++++++++++
>  arch/arm64/kvm/inject_fault.c        |  6 ++--
>  arch/arm64/kvm/reset.c               |  4 +++
>  include/uapi/linux/kvm.h             |  1 +
>  virt/kvm/arm/arm.c                   | 47 ++++++++++++++++++++++++++++
>  12 files changed, 194 insertions(+), 7 deletions(-)
> 
