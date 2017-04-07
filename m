From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Fri, 07 Apr 2017 17:12:32 +0100
Message-ID: <58E7BA70.4040004@arm.com>
References: <20170315160727.16465-1-james.morse@arm.com>
 <CAMj-D2A2QyvjUvbEcnaPcPsgySvAguWFkZSS1WxxT+T3uNU7aw@mail.gmail.com>
 <58E6096E.4060206@arm.com>
 <CAMj-D2AKzp-J97ZZGYdtgMvUR7o=sDw5n-Ygy7amvRk6k1p9aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81D6040C50
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 12:10:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 224m3wQosvkW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Apr 2017 12:10:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4639C40C4F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 12:10:37 -0400 (EDT)
In-Reply-To: <CAMj-D2AKzp-J97ZZGYdtgMvUR7o=sDw5n-Ygy7amvRk6k1p9aQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, gengdongjiu <gengdongjiu@huawei.com>, wuquanming@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 06/04/17 16:06, gengdongjiu wrote:
> Below is my previous idea:
>   When signalling Qemu, Qemu generate GHES ,then  Qemu/kvmtool  inject
> the SEA/SEI to guest OS. For different reason, Qemu/.KVMtool injects
> diferent notification type. if inject SEA/SEI/IRQ, guest OS handle the
> guest SEA/SEI/IRQ. handling guest OS SEA/SEI and IRQ guest OS software
> logical is  different.
> for example, guest OS call API "ghes_notify_sea" when happening SEA;
> call API  "ghes_notify_sei" when happening SEI.

Sounds reasonable. Qemu shouldn't have to care what the guest OS is so the
injecting notifications should stick to KVM APIs.


> so what is your suggested way to notify guest OS after Qemu generating the CPER?
[...]
> so for the notification guest OS, I think Qemu uses IOCTL to let KVM
> inject error may be better.

I agree.

Synchronous External Abort is something that can always be delivered, Qemu can
make it look like SEA was taken on a vcpu by modifying the registers using KVM's
KVM_SET_ONE_REG ioctl(). The pseudo code for what is required is in the
ARM-ARM's 'AArch64.TakeException'.


SError Interrupt is more complicated as it can be masked. Fortunately the
architecture has a way to inject SError into a guest using HCR_EL2.VSE, I think
KVM should allow users-space to inject SError with this. Marc and Christoffer
will have the best idea about how such an API should work. To be useful for
injecting SEI we need to be able to set VSESR_EL2 along with the HCR_EL2.VSE bit.
KVM will need to know about the RAS extensions to save/restore some of the new
registers listed in A1.7.5 of the new ARM-ARM.


Thanks,

James
