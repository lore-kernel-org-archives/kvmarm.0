From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: check IRQ number on userland injection
Date: Mon, 13 Apr 2015 11:21:30 +0100
Message-ID: <552B98AA.6@arm.com>
References: <1428679079-16499-1-git-send-email-andre.przywara@arm.com>
 <5527EC52.4050500@codeaurora.org> <5527FFB5.9020103@arm.com>
 <20150413100400.GJ6186@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B5C4C398
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 06:13:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ao7pwKZyLUz9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 06:13:50 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 643994C38A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 06:13:49 -0400 (EDT)
In-Reply-To: <20150413100400.GJ6186@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 13/04/15 11:04, Christoffer Dall wrote:
> On Fri, Apr 10, 2015 at 05:52:05PM +0100, Andre Przywara wrote:
>> Hi Christopher,
>>
>> On 10/04/15 16:29, Christopher Covington wrote:
>>> Hi Andre,
>>>
>>> On 04/10/2015 11:17 AM, Andre Przywara wrote:
>>>> When userland injects a SPI via the KVM_IRQ_LINE ioctl we currently
>>>> only check it against a fixed limit, which historically is set
>>>> to 127. With the new dynamic IRQ allocation the effective limit may
>>>> actually be smaller (64).
>>>> So when now a malicious or buggy userland injects a SPI in that
>>>> range, we spill over on our VGIC bitmaps and bytemaps memory.
>>>> I could trigger a host kernel NULL pointer dereference with current
>>>> mainline by injecting some bogus IRQ number from a hacked kvmtool:
>>>
>>>> --- a/arch/arm/include/uapi/asm/kvm.h
>>>> +++ b/arch/arm/include/uapi/asm/kvm.h
>>>> @@ -195,7 +195,11 @@ struct kvm_arch_memory_slot {
>>>>  #define KVM_ARM_IRQ_CPU_IRQ		0
>>>>  #define KVM_ARM_IRQ_CPU_FIQ		1
>>>>  
>>>> -/* Highest supported SPI, from VGIC_NR_IRQS */
>>>> +/*
>>>> + * This used to hold the highest supported SPI, but it is now obsolete
>>>> + * and only here to provide source code level compatibility with older
>>>> + * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
>>>> + */
>>>>  #define KVM_ARM_IRQ_GIC_MAX		127
>>>
>>> If that's the case should it maybe only defined when __KERNEL__ is not defined?
>>
>> Mmmh, I am not sure it's really worth the hassle. Actually it seems like
>> that neither kvmtool nor QEMU use this definition, so it's more or less
>> orphaned by now. I am confident we can avoid it sneaking in in the
>> kernel again.
>>
> TBH, I wouldn't object against Marc enclosing the definition in an
> #ifdef __KERNEL__.

So just to clarify: Isn't this definition part of the userspace API that
we have to maintain forever? That was my understanding when Christopher
suggested to enclose it in #ifndef __KERNEL__ (if I got this correctly).
So we would at least avoid any future kernel code to (ab)use it again.
But putting it inside #ifdef __KERNEL__ does contradict this, doesn't it?

If it is not an API, I'd rather remove it all:
a) it is not used by the kernel anymore after this patch
b) it became meaningless with the introduction of the dynamic NR_IRQS
   allocation
c) none of the two KVM userspace tools (I know of) is using it

So I guess any userspace tool trying to make use of it deserves to not
compile anymore.
But if we somehow promised that any userspace program will compile
forever against even the newest kernel headers, then we have to keep it
in, haven't we?

Or am I totally wrong here?

Cheers,
Andre.
