From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Tue, 09 Jun 2015 15:00:23 +0100
Message-ID: <5576F177.3090903@arm.com>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
 <5576C559.2000902@arm.com>
 <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
 <5576DBB5.3010100@arm.com>
 <CAFEAcA_y9DNLJTe+4kMBYObuKD82y0a05gsx6gOYZ8=Oo5LBGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B6B53F88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 09:50:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9YNStgHtguiN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2015 09:50:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7901353F2C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 09:50:10 -0400 (EDT)
In-Reply-To: <CAFEAcA_y9DNLJTe+4kMBYObuKD82y0a05gsx6gOYZ8=Oo5LBGA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/06/15 14:16, Peter Maydell wrote:
> On 9 June 2015 at 13:27, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 09/06/15 12:24, Peter Maydell wrote:
>>> So either:
>>>  * QEMU needs to tell the kernel the MPIDR for each vCPU
>>>  * QEMU needs to ask the kernel the MPIDR for each vCPU
>>>
>>> Which is better? The latter is simpler and will work with
>>> existing kernels. The former would let us (for instance)
>>> use KVM when we're modelling (real world) boards which have
>>> particular cluster configurations (which might not match the
>>> kernel's current simplistic "always 16 CPUs at Aff0" setup).
>>
>> Given that it is userspace that provides the description of the
>> platform, it feels natural to let userspace set MPIDR accordingly.
>>
>> This will require some interesting rework in the kernel, but this
>> doesn't feel too bad.
> 
> On the other hand QEMU needs to keep working with current kernels,
> so we need the "ask the kernel" code at least for the moment.
> Probably needs a capability for "kernel allows userspace to
> set MPIDR" so we can adapt.

Yeah, what I had in mind was something along the lines of:
- kernel computes its "default MPDIR"
- kernel exposes a new capability "KVM_ARM_ALLOW_MPIDR_OVERRIDE" (or
something along those lines)
- userspace does the right thing.

	M.
-- 
Jazz is not dead. It just smells funny...
