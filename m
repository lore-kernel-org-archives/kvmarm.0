From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 15/21] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Mon, 23 Oct 2017 16:26:39 +0100
Message-ID: <59EE0A2F.8050703@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-16-james.morse@arm.com>
 <CAMj-D2AMy1_SPrLGti9U=oz1JvBDHvRAMsBtw51B3JK0omLyXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F47D41185
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 11:27:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bspXnwlYS-uB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Oct 2017 11:27:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 366F040795
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 11:27:07 -0400 (EDT)
In-Reply-To: <CAMj-D2AMy1_SPrLGti9U=oz1JvBDHvRAMsBtw51B3JK0omLyXg@mail.gmail.com>
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
Cc: Jonathan.Zhang@cavium.com, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, Xiongfeng Wang <wangxiongfeng2@huawei.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 20/10/17 17:44, gengdongjiu wrote:
> 2017-10-19 22:58 GMT+08:00 James Morse <james.morse@arm.com>:
>> Prior to v8.2's RAS Extensions, the HCR_EL2.VSE 'virtual SError' feature
>> generated an SError with an implementation defined ESR_EL1.ISS, because we
>> had no mechanism to specify the ESR value.
>>
>> On Juno this generates an all-zero ESR, the most significant bit 'ISV'
>> is clear indicating the remainder of the ISS field is invalid.
>>
>> With the RAS Extensions we have a mechanism to specify this value, and the
>> most significant bit has a new meaning: 'IDS - Implementation Defined
>> Syndrome'. An all-zero SError ESR now means: 'RAS error: Uncategorized'
>> instead of 'no valid ISS'.
> 
> consider again.

> I still consider that it is not better set  "Implementation Defined
> Syndrome" here.

Do you agree KVM does this today?
ddb3d07cfe90 ("arm64: KVM: Inject a Virtual SError if it was pending")

All I've changed here is that you don't get a RAS error passed into the guest.
Its either deemed non-blocking and ignored, or we kick the guest with an impdef
SError.

To do any better we need kernel first support, or a firmware first notification.


> I know your meaning that An all-zero SError means Uncategorized

Uncategorized RAS error. RAS errors should be handled by the host, we should not
inject them into the guest on a path like this.

Which impdef ESR would you like to use, and why does it matter?


> From the beginning,  our starting point is KVM is the architecture
> related and Qemu/kvmtool is platform related.
> Qemu/kvmtool is the role of host firmware.
> so we let Qemu to create APEI/GHES table and record CPER,

> and also injects SEA/SEI in the Qemu.

For RAS events it generated all by itself, or was notified by the kernel using
signals.

This is not one of those cases. But that's fine as we aren't injecting a RAS error.


> About the vsesr_el2 which is used to specify the guest ESR,   also all
> set by Qemu/kvmtool are better.
> including the three cases  even the ESR are  all-zero(uncategorized).
> 1. IMPLEMENTATION DEFINED
> 2  categorized,
> 3  uncategorized,

I can't work out what you're saying here.

If you're suggesting Qemu should set a default 'unknown' ESR for use when KVM
doesn't know what to do, and SError is pretty much its only option:

Why would Qemu set anything other than impdef:all-zeros?

The only use would be to fake this back into a RAS error. Qemu isn't involved
here so this can't be used to emulate NOTIFY_SEI without the kernel support. We
don't have support for emulating the RAS ERR registers either, so this can't be
used to emulate kernel first.


If you're suggesting Qemu should specify a set of ESR values for the different
cases where KVM doesn't know what do: this would be an early shortcut that burns
us in the future, these things are going to be changed. This is too specific to
KVMs internals:

When we add NOTIFY_SEI support, we will call out of this KVM code and APEI
should 'claim' any SError that arrived with CPER records.

I expect this code to change dramatically if/when we add kernel first support.


The KVM patches on the end of this series are just the minimum needed to enable
IESB and keep the status quo for all other behaviour. And this is just so we can
tackle the other bits of support that depends on the cpufeature without
reposting all the same code.



James


> For this case, Qemu just set the ESR, nothing else, not passing
> RAS-error to userspace.
