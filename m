From: Igor Mammedov <imammedo@redhat.com>
Subject: Re: should KVM or userspace be the one which decides
 what MIPIDR/affinity values to assign to vcpus?
Date: Tue, 9 Jun 2015 13:54:21 +0200
Message-ID: <20150609135421.0c001a46@igors-macbook-pro.local>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
	<5576C559.2000902@arm.com>
	<CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 9 Jun 2015 12:24:13 +0100
Peter Maydell <peter.maydell@linaro.org> wrote:

> On 9 June 2015 at 11:52, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > On 08/06/15 11:52, Peter Maydell wrote:
> >> On 8 June 2015 at 11:32, Igor Mammedov <imammedo@redhat.com> wrote:
> >>> On Thu, 4 Jun 2015 18:17:39 +0100
> >>> Peter Maydell <peter.maydell@linaro.org> wrote:
> >>>> On 4 June 2015 at 17:40, Shlomo Pongratz
> >>>> <shlomopongratz@gmail.com> wrote: In order for it to work
> >>>> correctly we must use MPIDR values in the device tree which
> >>>> match the MPIDR values the kernel has picked for the vcpus, so
> >>>> ask KVM what those values are.
> >>
> >>> Could we set QEMU's generated mpidr in kernel instead of pulling
> >>> it from kernel, like we do with APIC ID in x86 and fix kernel not
> >>> to reset it its own value (i.e. untie mpidr from vcpuid)?
> >>>
> >>> Then later we could move setting mpidr from kvm_arch_init_vcpu()
> >>> into board code which should be setting it, since it
> >>> knows/defines what topology it has.
> >>
> >> This is a question better asked on the kvmarm list (which I have
> >> cc'd), because that is where the kernel folks hang out...
> >
> > Care to provide some context? Why is this required?
> 
> The device tree spec says we have to tell the guest kernel the
> affinity information for each CPU, in the reg field of the CPU node.
> This device tree blob is created by userspace; the MPIDR the guest
> actually reads is currently created by the kernel. The kernel's
> vgic v3 code may also make assumptions about vcpu_id => affinity
> mappings, I'm not sure.
> 
> In current code:
>  * the kernel has an opinion about vcpu_id => MPIDR mappings
>  * QEMU does too, but it's not the same!
>    (luckily for 8 or fewer CPUs they agree, but this will not
>    do for GICv3 support)
> 
> So either:
>  * QEMU needs to tell the kernel the MPIDR for each vCPU
that's what we do for KVM on x86 with APIC ID.
x86 KVM doesn't assume that vcpu_id is ACPI ID anymore,
it's just opaque id nowdays.

it's possible to make it working with existing kernels with
a little bit of compat code in QEMU. Newer kernels could advertise
KVM_CAP_SET_MPIDR feature and in absence of it userspace could revert
to old codepath.

>  * QEMU needs to ask the kernel the MPIDR for each vCPU
This would need some interface to feed topology info to kernel
so it could makeup MPIDR value, when we come to that point.

> Which is better? The latter is simpler and will work with
> existing kernels. The former would let us (for instance)
> use KVM when we're modelling (real world) boards which have
> particular cluster configurations (which might not match the
> kernel's current simplistic "always 16 CPUs at Aff0" setup).
> 
> thanks
> -- PMM
