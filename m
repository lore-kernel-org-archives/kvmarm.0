Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FD4C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 15:26:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 121E7611EE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 15:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 121E7611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DAEE4A19F;
	Wed, 22 Sep 2021 11:26:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L50uIzlLDRND; Wed, 22 Sep 2021 11:26:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE4F4A500;
	Wed, 22 Sep 2021 11:26:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45ADF4A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 11:26:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gUU-GxeIfoW4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 11:26:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B01CB4025B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 11:26:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02B10113E;
 Wed, 22 Sep 2021 08:26:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 402223F718;
 Wed, 22 Sep 2021 08:26:22 -0700 (PDT)
Message-ID: <58cfa897-7e8e-44a8-fda4-6f8ddb582644@arm.com>
Date: Wed, 22 Sep 2021 16:27:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v8 0/8] KVM: arm64: Add idempotent controls to migrate
 guest counter
Content-Language: en-US
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210916181510.963449-1-oupton@google.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Hi Oliver,

This looks interesting, I am going to try to do my best to review the series. I
haven't followed the patches until this version, so I might be missing part of the
context when I post my comments.

Thanks,

Alex

On 9/16/21 19:15, Oliver Upton wrote:
> Currently, on KVM/arm64, we only allow a VMM to migrate the guest's
> virtual counter by-value. Saving and restoring the counter by value is
> problematic in the fact that the recorded state is not idempotent.
> Furthermore, we obfuscate from userspace the fact that the architecture
> actually provides offset-based controls.
>
> Another issue is that KVM/arm64 doesn't provide userspace with the
> controls of the physical counter-timer. This series aims to address both
> issues by adding offset-based controls for the virtual and physical
> counters.
>
> Patches 1-2 are refactor changes required to provide offset controls to
> userspace and putting in some generic plumbing to use for both physical
> and virtual offsets.
>
> Patch 3 is a minor refactor, creating a helper function to get the
> number of timer registers for a particular vCPU.
>
> Patch 4 exposes a vCPU's virtual offset through the KVM_*_ONE_REG
> ioctls. When NV support is added to KVM, CNTVOFF_EL2 will be considered
> a guest system register. So, it is safe to expose it now through that
> ioctl.
>
> Patch 5 adds a cpufeature bit to detect 'full' ECV implementations,
> providing EL2 with the ability to offset the physical counter-timer.
>
> Patch 6 exposes a vCPU's physical offset as a vCPU device attribute.
> This is deliberate, as the attribute is not architectural; KVM uses this
> attribute to track the host<->guest offset.
>
> Patch 7 is a prepatory change for the sake of physical offset emulation,
> as counter-timer traps must be configured separately for each vCPU.
>
> Patch 8 allows non-ECV hosts to support the physical offset vCPU device
> attribute, by trapping and emulating the physical counter registers.
>
> This series was tested on an Ampere Mt. Jade system (non-ECV, VHE and
> nVHE). I did not test this on the FVP, as I need to really figure out
> tooling for it on my workstation.
>
> Applies cleanly to v5.15-rc1
>
> v7: http://lore.kernel.org/r/20210816001217.3063400-1-oupton@google.com
>
> v7 -> v8:
>  - Only use ECV if !VHE
>  - Only expose CNTVOFF_EL2 register to userspace with opt-in
>  - Refer to the direct_ptimer explicitly
>
> Oliver Upton (8):
>   KVM: arm64: Refactor update_vtimer_cntvoff()
>   KVM: arm64: Separate guest/host counter offset values
>   KVM: arm64: Make a helper function to get nr of timer regs
>   KVM: arm64: Allow userspace to configure a vCPU's virtual offset
>   arm64: cpufeature: Enumerate support for FEAT_ECV >= 0x2
>   KVM: arm64: Allow userspace to configure a guest's counter-timer
>     offset
>   KVM: arm64: Configure timer traps in vcpu_load() for VHE
>   KVM: arm64: Emulate physical counter offsetting on non-ECV systems
>
>  Documentation/arm64/booting.rst         |   7 +
>  Documentation/virt/kvm/api.rst          |  23 +++
>  Documentation/virt/kvm/devices/vcpu.rst |  28 ++++
>  arch/arm64/include/asm/kvm_host.h       |   3 +
>  arch/arm64/include/asm/sysreg.h         |   5 +
>  arch/arm64/include/uapi/asm/kvm.h       |   2 +
>  arch/arm64/kernel/cpufeature.c          |  10 ++
>  arch/arm64/kvm/arch_timer.c             | 196 +++++++++++++++++++++---
>  arch/arm64/kvm/arm.c                    |   9 +-
>  arch/arm64/kvm/guest.c                  |  28 +++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  32 ++++
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  11 +-
>  arch/arm64/tools/cpucaps                |   1 +
>  include/clocksource/arm_arch_timer.h    |   1 +
>  include/kvm/arm_arch_timer.h            |  14 +-
>  include/uapi/linux/kvm.h                |   1 +
>  16 files changed, 337 insertions(+), 34 deletions(-)
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
