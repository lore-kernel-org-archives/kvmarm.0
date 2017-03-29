From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Wed, 29 Mar 2017 16:48:22 +0200
Message-ID: <20170329144822.GA1020@cbox>
References: <58D17AF0.2010802@arm.com>
 <20170321193933.GB31111@cbox>
 <58DA3F68.6090901@arm.com>
 <20170328112328.GA31156@cbox>
 <20170328115413.GJ23682@e104320-lin>
 <b1c6e747-2fa7-b7a1-60d5-4a9c480b9dc9@huawei.com>
 <58DA67BA.8070404@arm.com>
 <5b7352f4-4965-3ed5-3879-db871797be47@huawei.com>
 <20170329103658.GQ23682@e104320-lin>
 <CAMj-D2BT3ByY-iFrRVVK7y=G7zhRBtM031VgLn6JzwUE-WCdWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMj-D2BT3ByY-iFrRVVK7y=G7zhRBtM031VgLn6JzwUE-WCdWQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: Achin Gupta <achin.gupta@arm.com>, gengdongjiu <gengdongjiu@huawei.com>, lersek@redhat.com, ard.biesheuvel@linaro.org, edk2-devel@lists.01.org, qemu-devel@nongnu.org, zhaoshenglong@huawei.com, James Morse <james.morse@arm.com>, xiexiuqi@huawei.com, Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, will.deacon@arm.com, christoffer.dall@linaro.org, rkrcmar@redhat.com, suzuki.poulose@arm.com, andre.przywara@arm.com, mark.rutland@arm.com, vladimir.murzin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, Leif.Lindholm@linaro.comnd@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 29, 2017 at 10:36:51PM +0800, gengdongjiu wrote:
> Hi Achin,
>   Thanks for your mail and  answer.
> 
> 2017-03-29 18:36 GMT+08:00, Achin Gupta <achin.gupta@arm.com>:
> > Hi gengdongjiu,
> >
> > On Wed, Mar 29, 2017 at 05:36:37PM +0800, gengdongjiu wrote:
> >>
> >> Hi Laszlo/Biesheuvel/Qemu developer,
> >>
> >>    Now I encounter a issue and want to consult with you in ARM64 platform，
> >> as described below:
> >>
> >>    when guest OS happen synchronous or asynchronous abort, kvm needs to
> >> send the error address to Qemu or UEFI through sigbus to dynamically
> >> generate APEI table. from my investigation, there are two ways:
> >>
> >>    (1) Qemu get the error address, and generate the APEI table, then
> >> notify UEFI to know this generation, then inject abort error to guest OS,
> >> guest OS read the APEI table.
> >>    (2) Qemu get the error address, and let UEFI to generate the APEI
> >> table, then inject abort error to guest OS, guest OS read the APEI table.
> 
> The description may be not precise, I update it
> 
>    (1) Qemu get the error address, and generate the CPER table, then
> notify guest UEFI to place this CPER table to Guest OS memory, then
> Qemu let KVM inject abort error to guest OS, guest OS read the CPER
> table.
> 
>  (2) Qemu get the error address, and let guest UEFI to directly
> generate the CPER
> table and place this table to the guest OS memory, not let Qemu gerate
> it. then KVM inject abort error to guest OS, guest OS read the CPER
> table.
> 

I don't understand how you are going to notify the guest UEFI instance
of anything or run the guest UEFI instance without going through the
guest kernel.

AFAIU, the guest UEFI instance is just a blob of software running at EL1
together with the guest kernel, and you're notification mechanism from
QEMU to the VM is pretty much limited to injecting a virtual interrupt
(of some kind) which is initially handled by the guest kernel.

> >
> > Just being pedantic! I don't think we are talking about creating the APEI
> > table
> > dynamically here. The issue is: Once KVM has received an error that is
> > destined
> > for a guest it will raise a SIGBUS to Qemu. Now before Qemu can inject the
> > error
> > into the guest OS, a CPER (Common Platform Error Record) has to be
> > generated
> > corresponding to the error source (GHES corresponding to memory subsystem,
> > processor etc) to allow the guest OS to do anything meaningful with the
> > error. So who should create the CPER is the question.
> >
> > At the EL3/EL2 interface (Secure Firmware and OS/Hypervisor), an error
> > arrives
> > at EL3 and secure firmware (at EL3 or a lower secure exception level) is
> > responsible for creating the CPER. ARM is experimenting with using a
> > Standalone
> > MM EDK2 image in the secure world to do the CPER creation. This will avoid
> > adding the same code in ARM TF in EL3 (better for security). The error will
> > then
> > be injected into the OS/Hypervisor (through SEA/SEI/SDEI) through ARM
> > Trusted
> > Firmware.
> >
> > Qemu is essentially fulfilling the role of secure firmware at the EL2/EL1
> > interface (as discussed with Christoffer below). So it should generate the
> > CPER
> > before injecting the error.
> >
> > This is corresponds to (1) above apart from notifying UEFI (I am assuming
> > you
> > mean guest UEFI). At this time, the guest OS already knows where to pick up
> > the
> > CPER from through the HEST. Qemu has to create the CPER and populate its
> > address
> > at the address exported in the HEST. Guest UEFI should not be involved in
> > this
> > flow. Its job was to create the HEST at boot and that has been done by this
> > stage.
> 
>  Sorry,  As I understand it, after Qemu generate the CPER table, it
> should pass the CPER table to the guest UEFI, then Guest UEFI  place
> this CPER table to the guest OS memory. In this flow, the Guest UEFI
> should be involved, else the Guest OS can not see the CPER table.
> 

I think you need to explain the "pass the CPER table to the guest UEFI"
concept in terms of what really happens, step by step, and when you say
"then Guest UEFI place the CPER table to the guest OS memory", I'm
curious who is running what code on the hardware when doing that.


Thanks,
-Christoffer
