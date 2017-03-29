From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [edk2] [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Wed, 29 Mar 2017 17:37:49 +0200
Message-ID: <fa712d47-4f77-7710-c4f7-cd7eab9fed9e@redhat.com>
References: <58D17AF0.2010802@arm.com> <20170321193933.GB31111@cbox>
 <58DA3F68.6090901@arm.com> <20170328112328.GA31156@cbox>
 <20170328115413.GJ23682@e104320-lin>
 <b1c6e747-2fa7-b7a1-60d5-4a9c480b9dc9@huawei.com> <58DA67BA.8070404@arm.com>
 <5b7352f4-4965-3ed5-3879-db871797be47@huawei.com>
 <20170329103658.GQ23682@e104320-lin>
 <CAMj-D2BT3ByY-iFrRVVK7y=G7zhRBtM031VgLn6JzwUE-WCdWQ@mail.gmail.com>
 <20170329144822.GA1020@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.01.org>
In-Reply-To: <20170329144822.GA1020@cbox>
List-Unsubscribe: <https://lists.01.org/mailman/options/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/edk2-devel/>
List-Post: <mailto:edk2-devel@lists.01.org>
List-Help: <mailto:edk2-devel-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.01.org
Sender: "edk2-devel" <edk2-devel-bounces@lists.01.org>
To: Christoffer Dall <cdall@linaro.org>, gengdongjiu <gengdj.1984@gmail.com>
Cc: kvm@vger.kernel.org, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, qemu-devel@nongnu.org, wuquanming@huawei.com, kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com, gengdongjiu <gengdongjiu@huawei.com>, Leif.Lindholm@linaro.com, huangshaoyu@huawei.com, vladimir.murzin@arm.com, xiexiuqi@huawei.com, Marc Zyngier <marc.zyngier@arm.com>, andre.przywara@arm.com, edk2-devel@lists.01.org, wangxiongfeng2@huawei.com, nd@arm.com, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/29/17 16:48, Christoffer Dall wrote:
> On Wed, Mar 29, 2017 at 10:36:51PM +0800, gengdongjiu wrote:
>> 2017-03-29 18:36 GMT+08:00, Achin Gupta <achin.gupta@arm.com>:

>>> Qemu is essentially fulfilling the role of secure firmware at the
>>> EL2/EL1 interface (as discussed with Christoffer below). So it
>>> should generate the CPER before injecting the error.
>>>
>>> This is corresponds to (1) above apart from notifying UEFI (I am
>>> assuming you mean guest UEFI). At this time, the guest OS already
>>> knows where to pick up the CPER from through the HEST. Qemu has
>>> to create the CPER and populate its address at the address
>>> exported in the HEST. Guest UEFI should not be involved in this 
>>> flow. Its job was to create the HEST at boot and that has been
>>> done by this stage.
>>
>> Sorry,  As I understand it, after Qemu generate the CPER table, it
>> should pass the CPER table to the guest UEFI, then Guest UEFI  place
>> this CPER table to the guest OS memory. In this flow, the Guest UEFI
>> should be involved, else the Guest OS can not see the CPER table.
>>
> 
> I think you need to explain the "pass the CPER table to the guest UEFI"
> concept in terms of what really happens, step by step, and when you say
> "then Guest UEFI place the CPER table to the guest OS memory", I'm
> curious who is running what code on the hardware when doing that.

I strongly suggest to keep the guest firmware's runtime involvement to
zero. Two reasons:

(1) As you explained above (... which I conveniently snipped), when you
inject an interrupt to the guest, the handler registered for that
interrupt will come from the guest kernel.

The only exception to this is when the platform provides a type of
interrupt whose handler can be registered and then locked down by the
firmware. On x86, this is the SMI.

In practice though,
- in OVMF (x86), we only do synchronous (software-initiated) SMIs (for
privileged UEFI varstore access),
- and in ArmVirtQemu (ARM / aarch64), none of the management mode stuff
exists at all.

I understand that the Platform Init 1.5 (or 1.6?) spec abstracted away
the MM (management mode) protocols from Intel SMM, but at this point
there is zero code in ArmVirtQemu for that. (And I'm unsure how much of
any eligible underlying hw emulation exists in QEMU.)

So you can't get the guest firmware to react to the injected interrupt
without the guest OS coming between first.

(2) Achin's description matches really-really closely what is possible,
and what should be done with QEMU, ArmVirtQemu, and the guest kernel.

In any solution for this feature, the firmware has to reserve some
memory from the OS at boot. The current facilities we have enable this.
As I described previously, the ACPI linker/loader actions can be mapped
more or less 1:1 to Achin's design. From a practical perspective, you
really want to keep the guest firmware as dumb as possible (meaning: as
generic as possible), and keep the ACPI specifics to the QEMU and the
guest kernel sides.

The error serialization actions -- the co-operation between guest kernel
and QEMU on the special memory areas -- that were mentioned earlier by
Michael and Punit look like a complication. But, IMO, they don't differ
from any other device emulation -- DMA actions in particular -- that
QEMU already does. Device models are what QEMU *does*. Read the command
block that the guest driver placed in guest memory, parse it, sanity
check it, verify it, execute it, write back the status code, inject an
interrupt (and/or let any polling guest driver notice it "soon after" --
use barriers as necessary).

Thus, I suggest to rely on the generic ACPI linker/loader interface
(between QEMU and guest firmware) *only* to make the firmware lay out
stuff (= reserve buffers, set up pointers, install QEMU's ACPI tables)
*at boot*. Then, at runtime, let the guest kernel and QEMU (the "device
model") talk to each other directly. Keep runtime firmware involvement
to zero.

You *really* don't want to debug three components at runtime, when you
can solve the thing with two. (Two components whose build systems won't
drive you mad, I should add.)

IMO, Achin's design nailed it. We can do that.

Laszlo
