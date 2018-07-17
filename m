From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v8 1/4] arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
Date: Tue, 17 Jul 2018 17:33:01 +0100
Message-ID: <CAFEAcA-t8U-GmkCtAcAN8tj4UAaynCZhgTi1Cg1RhaarGUOJfg@mail.gmail.com>
References: <20180713154751.18131-1-james.morse@arm.com>
 <20180713154751.18131-2-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6154A0C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 12:20:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z1Ey3hC3jFxH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jul 2018 12:20:20 -0400 (EDT)
Received: from mail-oi0-f68.google.com (mail-oi0-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 396644A054
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 12:20:20 -0400 (EDT)
Received: by mail-oi0-f68.google.com with SMTP id s198-v6so3179142oih.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 09:33:22 -0700 (PDT)
In-Reply-To: <20180713154751.18131-2-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Linuxarm <linuxarm@huawei.com>, gengdongjiu <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 July 2018 at 16:47, James Morse <james.morse@arm.com> wrote:
> From: Dongjiu Geng <gengdongjiu@huawei.com>
>
> For the migrating VMs, user space may need to know the exception
> state. For example, in the machine A, KVM make an SError pending,
> when migrate to B, KVM also needs to pend an SError.
>
> This new IOCTL exports user-invisible states related to SError.
> Together with appropriate user space changes, user space can get/set
> the SError exception state to do migrate/snapshot/suspend.
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Reviewed-by: James Morse <james.morse@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt    | 33 +++++++++++++++++---
>  arch/arm64/include/asm/kvm_emulate.h |  5 +++
>  arch/arm64/include/asm/kvm_host.h    |  7 +++++
>  arch/arm64/include/uapi/asm/kvm.h    | 13 ++++++++
>  arch/arm64/kvm/guest.c               | 46 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/inject_fault.c        |  6 ++--
>  arch/arm64/kvm/reset.c               |  1 +
>  virt/kvm/arm/arm.c                   | 21 +++++++++++++
>  8 files changed, 125 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index d10944e619d3..e3940f8715a5 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -835,11 +835,13 @@ struct kvm_clock_data {
>
>  Capability: KVM_CAP_VCPU_EVENTS
>  Extended by: KVM_CAP_INTR_SHADOW
> -Architectures: x86
> -Type: vm ioctl
> +Architectures: x86, arm64
> +Type: vcpu ioctl
>  Parameters: struct kvm_vcpu_event (out)
>  Returns: 0 on success, -1 on error
>
> +X86:
> +
>  Gets currently pending exceptions, interrupts, and NMIs as well as related
>  states of the vcpu.
>
> @@ -881,15 +883,32 @@ Only two fields are defined in the flags field:
>  - KVM_VCPUEVENT_VALID_SMM may be set in the flags field to signal that
>    smi contains a valid state.
>
> +ARM64:
> +
> +Gets currently pending SError exceptions as well as related states of the vcpu.

Any chance of expanding this to explain what this state actually is?
(ie something you could use to implement or review the userspace
code which has to manipulate it).

> +
> +struct kvm_vcpu_events {
> +       struct {
> +               __u8 serror_pending;
> +               __u8 serror_has_esr;
> +               /* Align it to 8 bytes */
> +               __u8 pad[6];
> +               __u64 serror_esr;
> +       } exception;
> +       __u32 reserved[12];
> +};
> +
>  4.32 KVM_SET_VCPU_EVENTS

thanks
-- PMM
