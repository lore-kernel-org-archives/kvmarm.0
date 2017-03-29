From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Wed, 29 Mar 2017 19:44:12 +0200
Message-ID: <20170329174412.GA4472@cbox>
References: <58DA3F68.6090901@arm.com> <20170328112328.GA31156@cbox>
 <20170328115413.GJ23682@e104320-lin>
 <b1c6e747-2fa7-b7a1-60d5-4a9c480b9dc9@huawei.com>
 <58DA67BA.8070404@arm.com>
 <5b7352f4-4965-3ed5-3879-db871797be47@huawei.com>
 <20170329103658.GQ23682@e104320-lin>
 <CAMj-D2BT3ByY-iFrRVVK7y=G7zhRBtM031VgLn6JzwUE-WCdWQ@mail.gmail.com>
 <20170329144822.GA1020@cbox>
 <fa712d47-4f77-7710-c4f7-cd7eab9fed9e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C41140A69
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 13:42:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D-m9eEbKOUnd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Mar 2017 13:42:14 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7473840962
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 13:42:14 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id w43so25562997wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 10:44:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <fa712d47-4f77-7710-c4f7-cd7eab9fed9e@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Laszlo Ersek <lersek@redhat.com>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, Achin Gupta <achin.gupta@arm.com>, will.deacon@arm.com, qemu-devel@nongnu.org, wuquanming@huawei.com, kvmarm@lists.cs.columbia.edu, gengdongjiu <gengdongjiu@huawei.com>, Leif.Lindholm@linaro.com, huangshaoyu@huawei.com, gengdongjiu <gengdj.1984@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, andre.przywara@arm.com, edk2-devel@lists.01.org, wangxiongfeng2@huawei.com, nd@arm.com, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 29, 2017 at 05:37:49PM +0200, Laszlo Ersek wrote:
> On 03/29/17 16:48, Christoffer Dall wrote:
> > On Wed, Mar 29, 2017 at 10:36:51PM +0800, gengdongjiu wrote:
> >> 2017-03-29 18:36 GMT+08:00, Achin Gupta <achin.gupta@arm.com>:
> 
> >>> Qemu is essentially fulfilling the role of secure firmware at the
> >>> EL2/EL1 interface (as discussed with Christoffer below). So it
> >>> should generate the CPER before injecting the error.
> >>>
> >>> This is corresponds to (1) above apart from notifying UEFI (I am
> >>> assuming you mean guest UEFI). At this time, the guest OS already
> >>> knows where to pick up the CPER from through the HEST. Qemu has
> >>> to create the CPER and populate its address at the address
> >>> exported in the HEST. Guest UEFI should not be involved in this 
> >>> flow. Its job was to create the HEST at boot and that has been
> >>> done by this stage.
> >>
> >> Sorry,  As I understand it, after Qemu generate the CPER table, it
> >> should pass the CPER table to the guest UEFI, then Guest UEFI  place
> >> this CPER table to the guest OS memory. In this flow, the Guest UEFI
> >> should be involved, else the Guest OS can not see the CPER table.
> >>
> > 
> > I think you need to explain the "pass the CPER table to the guest UEFI"
> > concept in terms of what really happens, step by step, and when you say
> > "then Guest UEFI place the CPER table to the guest OS memory", I'm
> > curious who is running what code on the hardware when doing that.
> 
> I strongly suggest to keep the guest firmware's runtime involvement to
> zero. Two reasons:
> 
> (1) As you explained above (... which I conveniently snipped), when you
> inject an interrupt to the guest, the handler registered for that
> interrupt will come from the guest kernel.
> 
> The only exception to this is when the platform provides a type of
> interrupt whose handler can be registered and then locked down by the
> firmware. On x86, this is the SMI.
> 
> In practice though,
> - in OVMF (x86), we only do synchronous (software-initiated) SMIs (for
> privileged UEFI varstore access),
> - and in ArmVirtQemu (ARM / aarch64), none of the management mode stuff
> exists at all.
> 
> I understand that the Platform Init 1.5 (or 1.6?) spec abstracted away
> the MM (management mode) protocols from Intel SMM, but at this point
> there is zero code in ArmVirtQemu for that. (And I'm unsure how much of
> any eligible underlying hw emulation exists in QEMU.)
> 
> So you can't get the guest firmware to react to the injected interrupt
> without the guest OS coming between first.
> 
> (2) Achin's description matches really-really closely what is possible,
> and what should be done with QEMU, ArmVirtQemu, and the guest kernel.
> 
> In any solution for this feature, the firmware has to reserve some
> memory from the OS at boot. The current facilities we have enable this.
> As I described previously, the ACPI linker/loader actions can be mapped
> more or less 1:1 to Achin's design. From a practical perspective, you
> really want to keep the guest firmware as dumb as possible (meaning: as
> generic as possible), and keep the ACPI specifics to the QEMU and the
> guest kernel sides.
> 
> The error serialization actions -- the co-operation between guest kernel
> and QEMU on the special memory areas -- that were mentioned earlier by
> Michael and Punit look like a complication. But, IMO, they don't differ
> from any other device emulation -- DMA actions in particular -- that
> QEMU already does. Device models are what QEMU *does*. Read the command
> block that the guest driver placed in guest memory, parse it, sanity
> check it, verify it, execute it, write back the status code, inject an
> interrupt (and/or let any polling guest driver notice it "soon after" --
> use barriers as necessary).
> 
> Thus, I suggest to rely on the generic ACPI linker/loader interface
> (between QEMU and guest firmware) *only* to make the firmware lay out
> stuff (= reserve buffers, set up pointers, install QEMU's ACPI tables)
> *at boot*. Then, at runtime, let the guest kernel and QEMU (the "device
> model") talk to each other directly. Keep runtime firmware involvement
> to zero.
> 
> You *really* don't want to debug three components at runtime, when you
> can solve the thing with two. (Two components whose build systems won't
> drive you mad, I should add.)
> 
> IMO, Achin's design nailed it. We can do that.
> 
I completely agree.

My questions were intended for gengdongjiu to clarify his/her position
and clear up any misunderstandings between what Achin suggested and what
he/she wrote.

Thanks,
-Christoffer
