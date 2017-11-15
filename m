From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Wed, 15 Nov 2017 18:25:26 +0000
Message-ID: <5A0C8696.7020002@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
 <5A0B13B5.3000205@arm.com> <e0dea261-a9ef-9d00-682a-a4449d1de5ec@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F04949D1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Nov 2017 13:25:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e+J6xorUYunH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Nov 2017 13:25:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20944406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Nov 2017 13:25:02 -0500 (EST)
In-Reply-To: <e0dea261-a9ef-9d00-682a-a4449d1de5ec@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Jonathan.Zhang@cavium.com, Christoffer Dall <cdall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 15/11/17 09:15, gengdongjiu wrote:
> On 2017/11/15 0:03, James Morse wrote:
>>> Hope this helps?
>> Yes, I'll go looking for a way to expose VSESR_EL2 to user-space.
> 
> what is the purpose to expose VSESR_EL2?
> do you mean set its value after migration?

Yes. Ideally Qemu would know the value it supplied last, and we just need to
tell it if 'the' inject SError has been delivered. But kvm_inject_vabt() makes
this impossible as Qemu can't know whose injected error this is.


> May be we can use similar below Mechanism
> https://www.spinics.net/lists/arm-kernel/msg603525.html

> when user-space sync the register status, it will get these register value.
> it will reuse the IOCTL KVM_GET_ONE_REG and no need to add extra API.

The maintainer NAKed "any patch that will expose _EL2 registers outside of
nested virtualization": https://patchwork.kernel.org/patch/9886019/

Why? If we 'spend' VSESR_EL2's name and encoding on 'the register we will give
to the guest when it can next take an SError', we will need a new name (and
encoding!) for systems with nested virtualization as now the guest has an
VSESR_EL2 too. The sys_reg/get_one_reg stuff is for guest registers. This thing
is part of the hypervisor's state.

Exposing VSESR_EL2 directly wouldn't be enough: A value of all-zeroes doesn't
tell us if an SError is pending, we need HCR_EL2.VSE too.


Your 'give me register' is a very raw interface, it makes it difficult to change
in the future: What if we get a new way to inject SError? We may not be able to
use it if user-space is poking CPU registers directly.
What happens if all those RES0 bits (and there are a lot of them) mean something
on future CPUs? Should we expose them? Should user-space be allowed to set them?
What if we need an errata workaround, based on something user-space can't know?

What about 32bit? The register names and sizes are different. User-space would
need a separate implementation to drive this. This is easier for the kernel to do.

We should have an API specific to the feature we are offering user-space. We are
offering a way to trigger an SError, with a specified ESR if the system supports
that. To be migrated it needs to be able to read this information back.

This way we can change the implementation without changing the API.



Thanks,

James
