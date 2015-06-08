From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
Date: Mon, 08 Jun 2015 09:23:12 +0100
Message-ID: <557550F0.5070106@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com> <01ad01d0a1b7$d4d4fe40$7e7efac0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <01ad01d0a1b7$d4d4fe40$7e7efac0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, Andre Przywara <Andre.Przywara@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 08/06/15 07:53, Pavel Fedin wrote:
>  Hello everybody!
> 
>> The GICv3 ITS (Interrupt Translation Service) is a part of the
>> ARM GICv3 interrupt controller used for implementing MSIs.
>> It specifies a new kind of interrupts (LPIs), which are mapped to
>> establish a connection between a device, its MSI payload value and
>> the target processor the IRQ is eventually delivered to.
>> In order to allow using MSIs in an ARM64 KVM guest, we emulate this
>> ITS widget in the kernel.
> 
>  I have tested the patch and got some more ideas for future extension...
> 
>  First of all, it would be nice to have a possibility to directly inject LPIs by number.
> This will be useful for irqfd support in qemu.

Well, that poses the question of what we emulate. We expose the
emulation of an ITS, hence no direct access to the LPI space. What we
could do would be allow LPI injection if not ITS is instantiated in the
kernel. But a mix of the two is likely to in contradiction with the
architecture.

>  Next, irqfd support currently poses a problem. We need to somehow know IRQ number from
> MSI-X data (device ID plus event ID). ITS has all this information, so it would be nice to
> be able to query for the translation from within userspace. The question is - how to do
> it? Should we add some ioctl for this purpose? Currently i am experimenting with extra
> KVM_TRANSLATE_MSI ioctl which, given MSI data, would return LPI number.

I'm afraid this is not enough. A write to GICR_TRANSLATER (DID+EID)
results in a (LPI,CPU) pair. Can you easily express the CPU part in
irqfd (this is a genuine question, I'm not familiar enough with that
part of the core)?

>  Actually before your patch came out i have almost done the same thing. But instead i
> decided to implement ITS in qemu while leaving LPI handling to kernel. In this case my
> qemu would have everything needed.
>  By the way, why did you decide to put everything into kernel? Yes, in-kernel emulation is
> faster, but ITS is not accessed frequently.

It may be interesting to find out what would be the implications if we
were to put it in userspace.

The obvious one would be that we'd have to duplicate the code in both
QEMU and kvmtool, and I don't think anyone fancies that. Another concern
would be the support of GICv4, which relies on the command queue
handling to be handled in the kernel (the GICv4 handling is basically a
command translation system, and I'm not prepared to let userspace inject
commands in the host ITS).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
