From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 21 Mar 2017 20:39:33 +0100
Message-ID: <20170321193933.GB31111@cbox>
References: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
 <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com>
 <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox> <58D17AF0.2010802@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6935F40BE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:37:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3DwmJVSacBok for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 15:37:47 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50C3440BDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:37:47 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id t189so20337615wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 12:39:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <58D17AF0.2010802@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, gengdongjiu <gengdongjiu@huawei.com>, wangxiongfeng2@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

[resending as clear text - I thought GMail supported that - sorry]

On Tue, Mar 21, 2017 at 07:11:44PM +0000, James Morse wrote:
> Hi Christoffer,
> 
> On 21/03/17 11:34, Christoffer Dall wrote:
> > On Tue, Mar 21, 2017 at 02:32:29PM +0800, gengdongjiu wrote:
> >> On 2017/3/20 23:08, James Morse wrote:
> >>>>>> On 20/03/17 07:55, Dongjiu Geng wrote:
> >>>>>>> In the RAS implementation, hardware pass the virtual SEI
> >>>>>>> syndrome information through the VSESR_EL2, so set the virtual
> >>>>>>> SEI syndrome using physical SEI syndrome el2_elr to pass to
> >>>>>>> the guest OS
> >>>
> >>> How does this work with firmware first?
> >>
> >> I explained it in previous mail about the work flow.
> > 
> > When delivering and reporting SEIs to the VM, should this happen
> > directly to the OS running in the VM, or to the guest firmware (e.g.
> > UEFI) running in the VM as well?
> 
> 'firmware first' is the ACPI specs name for x86's BIOS or management-mode
> handling the error. On arm64 we have multiple things called firmware, so the
> name might be more confusing than helpful.
> 
> As far as I understand it, firmware here refers to the secure-world and EL3.
> Something like ATF can use SCR_EL3.EA to claim SErrors and external aborts,
> routing them to EL3 where secure platform specific firmware generates CPER records.
> For a guest, Qemu takes the role of this EL3-firmware.
> 
Thanks for the clarification.  So UEFI in the VM would not be involved
in this at all?

My confusion here comes from not thinking about QEMU or KVM as firmware,
but as the machine, so it would be sort of like the functionality is
baked into hardware rather than firmware.

Note that to the VM, the environment will look like hardware without EL3
and without a secure world, so any software assuming there's something
'hidden' behind the available non-secure modes must not decide to
disable features if discovering the lack of a secure world.

Thanks,
-Christoffer
