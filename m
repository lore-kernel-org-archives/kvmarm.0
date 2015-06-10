From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: should KVM or userspace be the one which decides
 what MIPIDR/affinity values to assign to vcpus?
Date: Wed, 10 Jun 2015 11:31:33 +0100
Message-ID: <55781205.90303@arm.com>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>	<5576C559.2000902@arm.com>	<CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>	<5576DBB5.3010100@arm.com>	<CAFEAcA_y9DNLJTe+4kMBYObuKD82y0a05gsx6gOYZ8=Oo5LBGA@mail.gmail.com>	<5576F177.3090903@arm.com>	<CAFEAcA-GAsd7vWsmmZm6ikw+rRK2p7S3uNWBwYzTUGum12pyNA@mail.gmail.com>	<5576F9A9.6010501@arm.com>
	<20150610115420.4319da55@nial.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <20150610115420.4319da55@nial.brq.redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Igor Mammedov <imammedo@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Drew <drjones@redhat.com>, Radim <rkrcmar@redhat.com>, Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/06/15 10:54, Igor Mammedov wrote:
> On Tue, 09 Jun 2015 15:35:21 +0100
> Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
>> On 09/06/15 15:01, Peter Maydell wrote:
>>> On 9 June 2015 at 15:00, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>>
>>>> Yeah, what I had in mind was something along the lines of:
>>>> - kernel computes its "default MPDIR"
>>>> - kernel exposes a new capability "KVM_ARM_ALLOW_MPIDR_OVERRIDE" (or
>>>> something along those lines)
>>>> - userspace does the right thing.
>>>
>>> You forgot the "???" step :-)
>>
>> Indeed. I also missed the step that says "kernel is able to convert
>> arbitrary MPIDR to vcpu_id in an efficient manner...". GICv3 is
>> definitely going to require this.
> x86 probably already has code that does this for APIC ID -> vcpu_id

Apparently not. kvm_irq_delivery_to_apic seems to iterate over the vcpus
to find a match, and kvm_irq_delivery_to_apic_fast seems to rely on
knowing some form of topology (and some more iteration).

Overall, this looks awfully architecture specific, so it seems unlikely
we can reuse that aspect. I'm inclined to go for an rbtree mapping
MPIDRs to vcpus. As this is likely to be on the fast path, I'd like this
to me as lockless as possible though, which probably means that MPIDR
would become RO as soon as any vcpu has started executing.

	M.
-- 
Jazz is not dead. It just smells funny...
