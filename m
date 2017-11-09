From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Thu, 09 Nov 2017 18:14:56 +0000
Message-ID: <5A049B20.6000501@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E46B240D25
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Nov 2017 13:14:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7VOXcJKhcBEy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Nov 2017 13:14:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C44F840795
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Nov 2017 13:14:46 -0500 (EST)
In-Reply-To: <20171019145807.23251-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-arm-kernel@lists.infradead.org, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi guys,

On 19/10/17 15:57, James Morse wrote:
> Known issues:
[...]
>  * KVM-Migration: VDISR_EL2 is exposed to userspace as DISR_EL1, but how should
>    HCR_EL2.VSE or VSESR_EL2 be migrated when the guest has an SError pending but
>    hasn't taken it yet...?

I've been trying to work out how this pending-SError-migration could work.

If HCR_EL2.VSE is set then the guest will take a virtual SError when it next
unmasks SError. Today this doesn't get migrated, but only KVM sets this bit as
an attempt to kill the guest.

This will be more of a problem with GengDongjiu's SError CAP for triggering
guest SError from user-space, which will also allow the VSESR_EL2 to be
specified. (this register becomes the guest ESR_EL1 when the virtual SError is
taken and is used to emulate firmware-first's NOTIFY_SEI and eventually
kernel-first RAS). These errors are likely to be handled by the guest.


We don't want to expose VSESR_EL2 to user-space, and for migration it isn't
enough as a value of '0' doesn't tell us if HCR_EL2.VSE is set.

To get out of this corner: why not declare pending-SError-migration an invalid
thing to do?

We can give Qemu a way to query if a virtual SError is (still) pending. Qemu
would need to check this on each vcpu after migration, just before it throws the
switch and the guest runs on the new host. This way the VSESR_EL2 value doesn't
need migrating at all.

In the ideal world, Qemu could re-inject the last SError it triggered if there
is still one pending when it migrates... but because KVM injects errors too, it
would need to block migration until this flag is cleared.
KVM can promise this doesn't change unless you run the vcpu, so provided the
vcpu actually takes the SError at some point this thing can still be migrated.

This does make the VSE machinery hidden unmigratable state in KVM, which is nasty.

Can anyone suggest a better way?


Thanks,

James
