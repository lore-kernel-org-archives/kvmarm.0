From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 28 Mar 2017 15:40:15 +0200
Message-ID: <20170328134015.GB20211@cbox>
References: <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox> <58D17AF0.2010802@arm.com>
 <20170321193933.GB31111@cbox> <58DA3F68.6090901@arm.com>
 <20170328112328.GA31156@cbox> <20170328115413.GJ23682@e104320-lin>
 <20170328122229.GA31789@cbox> <20170328132455.GK23682@e104320-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 867D640A6A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:38:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EYOlc7XMyyHY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 09:38:19 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07E3D40966
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:38:18 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id w43so91337030wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 06:40:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170328132455.GK23682@e104320-lin>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Achin Gupta <achin.gupta@arm.com>
Cc: Leif.Lindholm@linaro.com, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, gengdongjiu <gengdongjiu@huawei.com>, wangxiongfeng2@huawei.com, wuquanming@huawei.com, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, huangshaoyu@huawei.com, nd@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 28, 2017 at 02:24:55PM +0100, Achin Gupta wrote:
> On Tue, Mar 28, 2017 at 02:22:29PM +0200, Christoffer Dall wrote:
> > On Tue, Mar 28, 2017 at 12:54:13PM +0100, Achin Gupta wrote:
> > > On Tue, Mar 28, 2017 at 01:23:28PM +0200, Christoffer Dall wrote:
> > > > On Tue, Mar 28, 2017 at 11:48:08AM +0100, James Morse wrote:
> > > > > Hi Christoffer,
> > > > >
> > > > > (CC: Leif and Achin who know more about how UEFI fits into this picture)
> > > > >
> > > > > On 21/03/17 19:39, Christoffer Dall wrote:
> > > > > > On Tue, Mar 21, 2017 at 07:11:44PM +0000, James Morse wrote:
> > > > > >> On 21/03/17 11:34, Christoffer Dall wrote:
> > > > > >>> On Tue, Mar 21, 2017 at 02:32:29PM +0800, gengdongjiu wrote:
> > > > > >>>> On 2017/3/20 23:08, James Morse wrote:
> > > > > >>>>>>>> On 20/03/17 07:55, Dongjiu Geng wrote:
> > > > > >>>>>>>>> In the RAS implementation, hardware pass the virtual SEI
> > > > > >>>>>>>>> syndrome information through the VSESR_EL2, so set the virtual
> > > > > >>>>>>>>> SEI syndrome using physical SEI syndrome el2_elr to pass to
> > > > > >>>>>>>>> the guest OS
> > > > > >>>>>
> > > > > >>>>> How does this work with firmware first?
> > > > > >>>>
> > > > > >>>> I explained it in previous mail about the work flow.
> > > > > >>>
> > > > > >>> When delivering and reporting SEIs to the VM, should this happen
> > > > > >>> directly to the OS running in the VM, or to the guest firmware (e.g.
> > > > > >>> UEFI) running in the VM as well?
> > > > > >>
> > > > > >> 'firmware first' is the ACPI specs name for x86's BIOS or management-mode
> > > > > >> handling the error. On arm64 we have multiple things called firmware, so the
> > > > > >> name might be more confusing than helpful.
> > > > > >>
> > > > > >> As far as I understand it, firmware here refers to the secure-world and EL3.
> > > > > >> Something like ATF can use SCR_EL3.EA to claim SErrors and external aborts,
> > > > > >> routing them to EL3 where secure platform specific firmware generates CPER records.
> > > > > >> For a guest, Qemu takes the role of this EL3-firmware.
> > >
> > > +1
> > >
> > > > > >>
> > > > > > Thanks for the clarification.  So UEFI in the VM would not be involved
> > > > > > in this at all?
> > > > >
> > > > > On the host, part of UEFI is involved to generate the CPER records.
> > > > > In a guest?, I don't know.
> > > > > Qemu could generate the records, or drive some other component to do it.
> > > >
> > > > I think I am beginning to understand this a bit.  Since the guet UEFI
> > > > instance is specifically built for the machine it runs on, QEMU's virt
> > > > machine in this case, they could simply agree (by some contract) to
> > > > place the records at some specific location in memory, and if the guest
> > > > kernel asks its guest UEFI for that location, things should just work by
> > > > having logic in QEMU to process error reports and populate guest memory.
> > > >
> > > > Is this how others see the world too?
> > >
> > > I think so!
> > >
> > > AFAIU, the memory where CPERs will reside should be specified in a GHES entry in
> > > the HEST. Is this not the case with a guest kernel i.e. the guest UEFI creates a
> > > HEST for the guest Kernel?
> > >
> > > If so, then the question is how the guest UEFI finds out where QEMU (acting as
> > > EL3 firmware) will populate the CPERs. This could either be a contract between
> > > the two or a guest DXE driver uses the MM_COMMUNICATE call (see [1]) to ask QEMU
> > > where the memory is.
> > >
> > > This is the way I expect it to work at the EL3/EL2 boundary. So I am
> > > extrapolating it to the guest/hypervisor boundary. Do shout if I am missing
> > > anything.
> >
> > No that sounds like a resonable comparison.
> >
> > I'm not entirely sure what a HEST or GHES is, but I think the only place
> > where I'm still not clear is if when the guest kernel is notified of
> > errors does it (a) just traverse memory by following some pointers
> > (which it may have pre-loaded at boot from UEFI), or (b) run UEFI code
> > which can call into QEMU and generate error records on demand?
> 
> So HEST is the ACPI Harware Error Source Table. It has entries in it for Generic
> HW Error Sources (GHES) amongst other types of error sources (x86 MCE etc). Each
> Error source specifies an address where the address of the CPER created by
> firmware will be populated. OS upon receipt of an error reads the CPERs to find
> the error source. It uses the addresses specified in the GHES entries of the
> HEST. This is closer to (a) above. HEST has the pointers preloaded at boot by
> UEFI.
> 
Thanks for the explanation.  Sounds to me like QEMU, through whatever
abstractions and proper methods they have to do that, must populate
memory more or less directly.

I guess this is up to whoever will actually implement support for this
to figure out.

-Christoffer
