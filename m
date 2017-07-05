From: Christoffer Dall <cdall@linaro.org>
Subject: Re: How to trap a real interrupt to EL2 ?
Date: Wed, 5 Jul 2017 08:23:34 +0200
Message-ID: <20170705062334.GA18106@cbox>
References: <CAPB=Z-o0-fGEvaxmwUVnSUTUAVWa0GgWupaaFcjJNecpeX3mrQ@mail.gmail.com>
 <20170704111212.GQ4066@cbox>
 <CAPB=Z-oZtJyOewtAMsK7iSWnhrhv5iX90HmV0FMj_E5DHy7d-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C951E40A80
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 02:23:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ACmPN+aNFPx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jul 2017 02:23:17 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1156240427
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 02:23:16 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id 62so212420511wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jul 2017 23:23:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-oZtJyOewtAMsK7iSWnhrhv5iX90HmV0FMj_E5DHy7d-g@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Raz <raziebe@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 04, 2017 at 07:32:37PM +0000, Raz wrote:
> The entry woken in the vector is IRQ 64-bit EL1 ( same as el1_irq in
> kvn/hyp.S ).
> ESR_EL2.EC =  0x16 -" HVC executed in EL2".  It does not change.

ESR_EL2 doesn't say anything meaningful if you're taking an asynchronous
exception, like the IRQ.

> 
> Jintack
> CPSR.I is 1 , but I do not think I can just clear it, if that what you
> mean...

CPSR.I will mask virtual interrupts at EL1 when HCR_EL2.IMO is set, not
physical interrupts.

The only way to run code in EL1 when having the IMO bit set and
interrupts arriving would involve either actually handling those
interrupts at EL2, or taking more drastic measures like disabling
physical interrupts entirely by disabling the interrupt controller or
something like that.

> 
> Chrtistoph

 *Christoffer*

> 
> You deactivate traps in kvm_vcpu_return( called from el1_irq).
> Does it mean we cannot exit-enter the hypervisor when hcr_el2.IMO is
> enabled ?

Not sure what you're asking, but the deactivate_traps function is a
result of the split-mode virtualization design of KVM, where we have two
modes of running things in EL1, either the host hypervisor, or the VM.
Therefore, when we run the VM, we enable traps on all sorts of things to
EL2, and when we go back to the host, we disable those traps again,
making EL1 for the host more privileged.

In terms of IRQs, what we do in practice is:

  disable_interrupts(); /* sets CPSR.I.  HCR_EL2.IMO is 0 here. */
  jump_to_el2();
  enable_traps(); /* set HCR_EL2.IMO = 1 */
  jump_to_vm_in_el1();
  handle_exception_from_vm();
  disable_traps(); /* set HCR_EL2.IMO = 0 */
  return_to_host_el1(); /* CPSR.I is still set */
  enable_interrupts(); /* clears CPSR.I.  Raises new exception, now
                          handled at EL1 by Linux default mechanism */

Overall, I recommend you study the ARM Architecture Reference Manual
(ARM ARM) more closely to understand how the hardware works, and you can
also read one of these to get a better understanding of how the KVM design
works:

http://www.cs.columbia.edu/~cdall/pubs/asplos019-dall.pdf
https://lwn.net/Articles/557132/

Hope this helps,
-Christoffer
