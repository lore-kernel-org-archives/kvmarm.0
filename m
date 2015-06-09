From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Tue, 9 Jun 2015 12:24:13 +0100
Message-ID: <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
 <5576C559.2000902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 055BB53F49
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 07:14:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6jw3RU2oUWM7 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2015 07:14:17 -0400 (EDT)
Received: from mail-vn0-f46.google.com (mail-vn0-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC46153F3C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 07:14:17 -0400 (EDT)
Received: by vnbf7 with SMTP id f7so2127083vnb.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Jun 2015 04:24:34 -0700 (PDT)
In-Reply-To: <5576C559.2000902@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 9 June 2015 at 11:52, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 08/06/15 11:52, Peter Maydell wrote:
>> On 8 June 2015 at 11:32, Igor Mammedov <imammedo@redhat.com> wrote:
>>> On Thu, 4 Jun 2015 18:17:39 +0100
>>> Peter Maydell <peter.maydell@linaro.org> wrote:
>>>> On 4 June 2015 at 17:40, Shlomo Pongratz <shlomopongratz@gmail.com> wrote:
>>>>  In order for it to work correctly we must use MPIDR values in
>>>>  the device tree which match the MPIDR values the kernel has picked
>>>>  for the vcpus, so ask KVM what those values are.
>>
>>> Could we set QEMU's generated mpidr in kernel instead of pulling it from kernel,
>>> like we do with APIC ID in x86 and fix kernel not to reset it its own value
>>> (i.e. untie mpidr from vcpuid)?
>>>
>>> Then later we could move setting mpidr from kvm_arch_init_vcpu() into
>>> board code which should be setting it, since it knows/defines what topology it has.
>>
>> This is a question better asked on the kvmarm list (which I have cc'd),
>> because that is where the kernel folks hang out...
>
> Care to provide some context? Why is this required?

The device tree spec says we have to tell the guest kernel the
affinity information for each CPU, in the reg field of the CPU node.
This device tree blob is created by userspace; the MPIDR the guest
actually reads is currently created by the kernel. The kernel's
vgic v3 code may also make assumptions about vcpu_id => affinity
mappings, I'm not sure.

In current code:
 * the kernel has an opinion about vcpu_id => MPIDR mappings
 * QEMU does too, but it's not the same!
   (luckily for 8 or fewer CPUs they agree, but this will not
   do for GICv3 support)

So either:
 * QEMU needs to tell the kernel the MPIDR for each vCPU
 * QEMU needs to ask the kernel the MPIDR for each vCPU

Which is better? The latter is simpler and will work with
existing kernels. The former would let us (for instance)
use KVM when we're modelling (real world) boards which have
particular cluster configurations (which might not match the
kernel's current simplistic "always 16 CPUs at Aff0" setup).

thanks
-- PMM
