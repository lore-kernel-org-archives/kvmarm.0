From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [Qemu-devel] [PATCH] hw/arm/virt: gicv3: use all target-list bits
Date: Mon, 27 Jun 2016 08:51:43 +0100
Message-ID: <5770DB0F.8050203@arm.com>
References: <1466535515-18092-1-git-send-email-drjones@redhat.com>
 <CAFEAcA-56LUe_jYK=V-H890WVL12YuDeRSZn9FK3yReiJ4p2Hw@mail.gmail.com>
 <20160624160321.nvn5run4kmywk7kc@hawk.localdomain>
 <20160624161513.zgqxspxhdre3d67c@hawk.localdomain>
 <CAFEAcA8xQV3PJ7BgFa=ohYDGqyVEtQ9bssoB+0JkGaGJqtaK=w@mail.gmail.com>
 <20160624172223.gxbd7nsna6spflxt@hawk.localdomain>
 <CAFEAcA9o57GET+mWOfrVhdRo=5a1w-AJeRPwssmJG1BcD4Ag8Q@mail.gmail.com>
 <20160627064154.h3npws4voswo3z7d@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F83040FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 03:46:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gVC7KPJk4OMW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 03:46:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3266040F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 03:46:39 -0400 (EDT)
In-Reply-To: <20160627064154.h3npws4voswo3z7d@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-arm <qemu-arm@nongnu.org>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 27/06/16 07:41, Andrew Jones wrote:
> On Fri, Jun 24, 2016 at 06:27:20PM +0100, Peter Maydell wrote:
>> On 24 June 2016 at 18:22, Andrew Jones <drjones@redhat.com> wrote:
>>> On Fri, Jun 24, 2016 at 05:41:55PM +0100, Peter Maydell wrote:
>>>> KVM AArch32 is 4 CPUs per cluster:
>>>> http://lxr.free-electrons.com/source/arch/arm/kvm/coproc.c#L109
>>>
>>> Hmm... yes, it should use coproc.c, but here's what I get when I
>>> test
>>>
>>> qemu-system-aarch64 \
>>>   -machine virt,gic-version=2,accel=kvm \
>>>   -cpu host,aarch64=off \
>>>   -device virtio-serial-device \
>>>   -device virtconsole,chardev=ctd \
>>>   -chardev testdev,id=ctd \
>>>   -display none -serial stdio \
>>>   -kernel arm/selftest.flat \
>>>   -append smp -smp 8
>>
>> This suggests that 32-bit-guest-on-64-bit-host and
>> 32-bit-guest-on-32-bit-host differ...
> 
> Yes, this is the case. I just looked at KVM and, it shouldn't use coproc.c
> (that's not one of the shared files between 32 and 64 bit hosts), and
> there's no special handing in reset_mpidr for KVM_ARM_VCPU_EL1_32BIT.
> The only special handing is in handlers for trapped coproc accesses,
> which MPIDR is not.
> 
> I think it makes sense that the 32bit guest view be consistent. This
> means we need one of two patches in KVM. Either
> 
>  a) decide we don't need to emulate clusters of 4, and just use the
>     max the gic supports, or
>  b) modify arm64's reset_mpidr to change behavior based on
>     KVM_ARM_VCPU_EL1_32BIT.
> 
> If the clusters of 4 thing is a hard requirement, then we should go
> that way. If not, as it doesn't seem to break guests today (aarch64=off
> and tcg guests have never done it) then I say we stop doing it on 32bit
> hosts too, as it will increase SGI efficiency.

I've never been fond of the 32bit behaviour, to be honest, and I'd
rather stick to the default being to max Aff0 on 64bit hosts (and before
anyone asks, yes, GICv3 support is coming to 32bit as well).

What I think we should have though is a way for userspace to override
the defaults presented by KVM. That way, 64bit userspace can enforce 4
CPU clusters if it sees fit.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
