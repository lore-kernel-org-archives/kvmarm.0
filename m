From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Thu, 25 Jun 2015 10:00:14 +0200
Message-ID: <20150625080014.GC28244@cbox>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
 <5576C559.2000902@arm.com>
 <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E636056F76
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 03:49:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S3jGYQhEmr2D for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2015 03:49:15 -0400 (EDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD90256F65
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 03:49:15 -0400 (EDT)
Received: by lacny3 with SMTP id ny3so39810998lac.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 01:00:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

[sorry for reviving this thread late]

On Tue, Jun 09, 2015 at 12:24:13PM +0100, Peter Maydell wrote:
> On 9 June 2015 at 11:52, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > On 08/06/15 11:52, Peter Maydell wrote:
> >> On 8 June 2015 at 11:32, Igor Mammedov <imammedo@redhat.com> wrote:
> >>> On Thu, 4 Jun 2015 18:17:39 +0100
> >>> Peter Maydell <peter.maydell@linaro.org> wrote:
> >>>> On 4 June 2015 at 17:40, Shlomo Pongratz <shlomopongratz@gmail.com> wrote:
> >>>>  In order for it to work correctly we must use MPIDR values in
> >>>>  the device tree which match the MPIDR values the kernel has picked
> >>>>  for the vcpus, so ask KVM what those values are.
> >>
> >>> Could we set QEMU's generated mpidr in kernel instead of pulling it from kernel,
> >>> like we do with APIC ID in x86 and fix kernel not to reset it its own value
> >>> (i.e. untie mpidr from vcpuid)?
> >>>
> >>> Then later we could move setting mpidr from kvm_arch_init_vcpu() into
> >>> board code which should be setting it, since it knows/defines what topology it has.
> >>
> >> This is a question better asked on the kvmarm list (which I have cc'd),
> >> because that is where the kernel folks hang out...
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

Does this option work for all configurations?  What if you're running on
a hardware with two clusters [8, 8] and QEMU asks KVM for a [12, 2]
configuration, for example.  Will it not be impossible for KVM to
maintain correct semantics for coherency guarantees across what seems to
the guest to be the same cluster, but really is two different clusters?

Of course, KVM can deny an unsupported configuration, but I am wondering
if we really think anybody will care about the 'model such specific
hardware' aspect with KVM, or if we should only consider the 'I want a
VM with x VCPUs' scenario, in which case the second option below seems
simpler to me.

Are there any concerns to think about wrt. migration here as well?

Thanks,
-Christoffer

>  * QEMU needs to ask the kernel the MPIDR for each vCPU
> 
> Which is better? The latter is simpler and will work with
> existing kernels. The former would let us (for instance)
> use KVM when we're modelling (real world) boards which have
> particular cluster configurations (which might not match the
> kernel's current simplistic "always 16 CPUs at Aff0" setup).
> 
> thanks
> -- PMM
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
