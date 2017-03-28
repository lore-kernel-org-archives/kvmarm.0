From: Achin Gupta <achin.gupta@arm.com>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 28 Mar 2017 12:54:13 +0100
Message-ID: <20170328115413.GJ23682@e104320-lin>
References: <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com>
 <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox>
 <58D17AF0.2010802@arm.com>
 <20170321193933.GB31111@cbox>
 <58DA3F68.6090901@arm.com>
 <20170328112328.GA31156@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170328112328.GA31156@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: James Morse <james.morse@arm.com>, gengdongjiu <gengdongjiu@huawei.com>, xiexiuqi@huawei.com, Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, will.deacon@arm.com, christoffer.dall@linaro.org, rkrcmar@redhat.com, suzuki.poulose@arm.com, andre.przywara@arm.com, mark.rutland@arm.com, vladimir.murzin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, Leif.Lindholm@linaro.comnd@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 28, 2017 at 01:23:28PM +0200, Christoffer Dall wrote:
> On Tue, Mar 28, 2017 at 11:48:08AM +0100, James Morse wrote:
> > Hi Christoffer,
> >
> > (CC: Leif and Achin who know more about how UEFI fits into this picture)
> >
> > On 21/03/17 19:39, Christoffer Dall wrote:
> > > On Tue, Mar 21, 2017 at 07:11:44PM +0000, James Morse wrote:
> > >> On 21/03/17 11:34, Christoffer Dall wrote:
> > >>> On Tue, Mar 21, 2017 at 02:32:29PM +0800, gengdongjiu wrote:
> > >>>> On 2017/3/20 23:08, James Morse wrote:
> > >>>>>>>> On 20/03/17 07:55, Dongjiu Geng wrote:
> > >>>>>>>>> In the RAS implementation, hardware pass the virtual SEI
> > >>>>>>>>> syndrome information through the VSESR_EL2, so set the virtual
> > >>>>>>>>> SEI syndrome using physical SEI syndrome el2_elr to pass to
> > >>>>>>>>> the guest OS
> > >>>>>
> > >>>>> How does this work with firmware first?
> > >>>>
> > >>>> I explained it in previous mail about the work flow.
> > >>>
> > >>> When delivering and reporting SEIs to the VM, should this happen
> > >>> directly to the OS running in the VM, or to the guest firmware (e.g.
> > >>> UEFI) running in the VM as well?
> > >>
> > >> 'firmware first' is the ACPI specs name for x86's BIOS or management-mode
> > >> handling the error. On arm64 we have multiple things called firmware, so the
> > >> name might be more confusing than helpful.
> > >>
> > >> As far as I understand it, firmware here refers to the secure-world and EL3.
> > >> Something like ATF can use SCR_EL3.EA to claim SErrors and external aborts,
> > >> routing them to EL3 where secure platform specific firmware generates CPER records.
> > >> For a guest, Qemu takes the role of this EL3-firmware.

+1

> > >>
> > > Thanks for the clarification.  So UEFI in the VM would not be involved
> > > in this at all?
> >
> > On the host, part of UEFI is involved to generate the CPER records.
> > In a guest?, I don't know.
> > Qemu could generate the records, or drive some other component to do it.
>
> I think I am beginning to understand this a bit.  Since the guet UEFI
> instance is specifically built for the machine it runs on, QEMU's virt
> machine in this case, they could simply agree (by some contract) to
> place the records at some specific location in memory, and if the guest
> kernel asks its guest UEFI for that location, things should just work by
> having logic in QEMU to process error reports and populate guest memory.
>
> Is this how others see the world too?

I think so!

AFAIU, the memory where CPERs will reside should be specified in a GHES entry in
the HEST. Is this not the case with a guest kernel i.e. the guest UEFI creates a
HEST for the guest Kernel?

If so, then the question is how the guest UEFI finds out where QEMU (acting as
EL3 firmware) will populate the CPERs. This could either be a contract between
the two or a guest DXE driver uses the MM_COMMUNICATE call (see [1]) to ask QEMU
where the memory is.

This is the way I expect it to work at the EL3/EL2 boundary. So I am
extrapolating it to the guest/hypervisor boundary. Do shout if I am missing
anything.

hth,
Achin

>
> >
> > Leif and Achin are the people with the UEFI/bigger picture.
> >
> >
>
> Thanks!
> -Christoffer

[1] http://infocenter.arm.com/help/topic/com.arm.doc.den0060a/DEN0060A_ARM_MM_Interface_Specification.pdf
