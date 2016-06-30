From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 00/17] KVM: arm64: GICv3 ITS emulation
Date: Thu, 30 Jun 2016 14:03:48 +0200
Message-ID: <a32c24fa-15f8-72ad-098f-e40ebe525502@redhat.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <DB5PR04MB0997B9A41C3C79F45CAC6C989A230@DB5PR04MB0997.eurprd04.prod.outlook.com>
 <eab8b632-1a00-9a0c-808d-55d5cc161c22@arm.com>
 <20160630114032.sixxueviddx3uqoq@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160630114032.sixxueviddx3uqoq@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: Bharat Bhushan <bharat.bhushan@nxp.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 30/06/2016 13:40, Andrew Jones wrote:
> On Thu, Jun 30, 2016 at 11:09:30AM +0100, Andre Przywara wrote:
>> Hi,
>>
>> On 29/06/16 05:43, Bharat Bhushan wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-
>>>> bounces@lists.cs.columbia.edu] On Behalf Of Andre Przywara
>>>> Sent: Tuesday, June 28, 2016 6:02 PM
>>>> To: Marc Zyngier <marc.zyngier@arm.com>; Christoffer Dall
>>>> <christoffer.dall@linaro.org>; Eric Auger <eric.auger@redhat.com>
>>>> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
>>>> kvm@vger.kernel.org
>>>> Subject: [PATCH v7 00/17] KVM: arm64: GICv3 ITS emulation
>>>>
>>>> Hi,
>>>>
>>>> another try on the KVM ITS emulation support.
>>>> It allows those KVM guests that use an emulated GICv3 to use LPIs as well,
>>>> though in the moment this is limited to emulated PCI devices.
>>>> This is based on kvm-arm-for-v4.7-rc2 and relies on the new VGIC
>>>> implementation.
>>>>
>>>> Compared to the last drop there have been some changes to the code:
>>>> The reference counting has been rewritten to use the kref infrastructure.
>>>> This has some implications on the rest of the code, for instance the locking
>>>> for the LPI list got changed. There is no RCU usage anymore, instead the LPI
>>>> list is now protected by a spinlock. To overcome the problem where we need
>>>> to access guest memory while holding the lock, we create a snapshot of the
>>>> LPI list, so we can iterate over LPIs with the lock dropped.
>>>> Also the base register sanitisation has been reworked completely, which
>>>> includes some changes to the arm-gic-v3.h header file (as a separate patch
>>>> 07/17). I hope I covered all the subtleties of those bits.
>>>> Also the MMIO framework saw some changes, we now tag the different GIC
>>>> regions explicitly and are able to call the different handlers explicitly.
>>>> Also Patch 05/17 extends the kvm-io-bus framework with a small function to
>>>> get the kvm_io_device structure for a given MMIO address. This allows us to
>>>> keep the knowledge of all the ITSes in this framework, but still get the
>>>> respective ITS pointer easily without reverting to "fake" MMIO accesses.
>>>> Also all the smaller review comments have been addressed.
>>>>
>>>> You can find all of this code (and the prerequisites) in the
>>>> its-emul/v7 branch of my repository [1].
>>>> This has been briefly tested on the model and on GICv3 hardware.
>>>> If you have GICv3 capable hardware, please test it on your setup.
>>>
>>> We have GICv3 capable hardware and we can test these on that.
>>> How you are testing these changes? QEMU side changes are also required, can you share those changes?
>>
>> I don't have any QEMU patches, that is on Linaro's plate, as far as I
> 
> I think Eric Auger is looking at this. He's planning on doing a respin
> of Pavel Fedin's series[*]
> 
> [*] https://lists.gnu.org/archive/html/qemu-devel/2015-11/msg05197.html
Yes working on it.

Best Regards

Eric
> 
> drew
> 
>> can tell. I don't know what the status is there. For real patches we
>> would need to agree on the userland interface, I guess.
>> However hacking something in QEMU shouldn't be too hard, you basically
>> have to inject the ITS DT node and reserve some space in the memory map.
>> Then tell QEMU to use KVM_SIGNAL_MSI to trigger IRQs.
>> You can look at the kvmtool patches to get an idea on what to cover.
>>
>> Further below I gave some hints on testing this series with kvmtool.
>>
>> ....
>>
>>>>
>>>> For the time being this series gives us the ability to use emulated PCI devices
>>>> that can use MSIs in the guest. Those have to be triggered by letting the
>>>> userland device emulation simulate the MSI write with the
>>>> KVM_SIGNAL_MSI ioctl. This will be translated into the proper LPI by the ITS
>>>> emulation and injected into the guest in the usual way (just with a higher IRQ
>>>> number).
>>>>
>>>> This series is based on kvm-arm-for-v4.7-rc2 and can be found at the
>>>> its-emul/v7 branch of this repository [1].
>>>> For this to be used you need a GICv3 host machine (a fast model would do),
>>>> though it does not rely on any host ITS bits (neither in hardware or software).
>>>>
>>>> To test this you can use the kvmtool patches available in the "its-v6"
>>>> branch here [2].
>>>> Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
>>>> and see the ITS being used for instance by the virtio devices.
>>
>> ^^^^ here you go.
>>
>> Cheers,
>> Andre.
>>
>>>>
>>>> [1]: git://linux-arm.org/linux-ap.git
>>>>      http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-
>>>> emul/v7
>>>> [2]: git://linux-arm.org/kvmtool.git
>>>>      http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its-v6
>>>> [3]:
>>>> http://arminfo.emea.arm.com/help/topic/com.arm.doc.ihi0069a/IHI0069A_g
>>>> ic_architecture_specification.pdf
>>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
