From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Tue, 09 Jun 2015 11:52:09 +0100
Message-ID: <5576C559.2000902@arm.com>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0439D53F7D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 06:41:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pXMi7Gs67Kyx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2015 06:41:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0E7353F78
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 06:41:56 -0400 (EDT)
In-Reply-To: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/06/15 11:52, Peter Maydell wrote:
> On 8 June 2015 at 11:32, Igor Mammedov <imammedo@redhat.com> wrote:
>> On Thu, 4 Jun 2015 18:17:39 +0100
>> Peter Maydell <peter.maydell@linaro.org> wrote:
>>> On 4 June 2015 at 17:40, Shlomo Pongratz <shlomopongratz@gmail.com> wrote:
>>>  In order for it to work correctly we must use MPIDR values in
>>>  the device tree which match the MPIDR values the kernel has picked
>>>  for the vcpus, so ask KVM what those values are.
> 
>> Could we set QEMU's generated mpidr in kernel instead of pulling it from kernel,
>> like we do with APIC ID in x86 and fix kernel not to reset it its own value
>> (i.e. untie mpidr from vcpuid)?
>>
>> Then later we could move setting mpidr from kvm_arch_init_vcpu() into
>> board code which should be setting it, since it knows/defines what topology it has.
> 
> This is a question better asked on the kvmarm list (which I have cc'd),
> because that is where the kernel folks hang out...

Care to provide some context? Why is this required?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
