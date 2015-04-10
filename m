From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: check IRQ number on userland injection
Date: Fri, 10 Apr 2015 17:52:05 +0100
Message-ID: <5527FFB5.9020103@arm.com>
References: <1428679079-16499-1-git-send-email-andre.przywara@arm.com>
 <5527EC52.4050500@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 654404C198
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 12:44:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1cnnOhKPieZb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 12:44:34 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D4524C195
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 12:44:33 -0400 (EDT)
In-Reply-To: <5527EC52.4050500@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christopher,

On 10/04/15 16:29, Christopher Covington wrote:
> Hi Andre,
> 
> On 04/10/2015 11:17 AM, Andre Przywara wrote:
>> When userland injects a SPI via the KVM_IRQ_LINE ioctl we currently
>> only check it against a fixed limit, which historically is set
>> to 127. With the new dynamic IRQ allocation the effective limit may
>> actually be smaller (64).
>> So when now a malicious or buggy userland injects a SPI in that
>> range, we spill over on our VGIC bitmaps and bytemaps memory.
>> I could trigger a host kernel NULL pointer dereference with current
>> mainline by injecting some bogus IRQ number from a hacked kvmtool:
> 
>> --- a/arch/arm/include/uapi/asm/kvm.h
>> +++ b/arch/arm/include/uapi/asm/kvm.h
>> @@ -195,7 +195,11 @@ struct kvm_arch_memory_slot {
>>  #define KVM_ARM_IRQ_CPU_IRQ		0
>>  #define KVM_ARM_IRQ_CPU_FIQ		1
>>  
>> -/* Highest supported SPI, from VGIC_NR_IRQS */
>> +/*
>> + * This used to hold the highest supported SPI, but it is now obsolete
>> + * and only here to provide source code level compatibility with older
>> + * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
>> + */
>>  #define KVM_ARM_IRQ_GIC_MAX		127
> 
> If that's the case should it maybe only defined when __KERNEL__ is not defined?

Mmmh, I am not sure it's really worth the hassle. Actually it seems like
that neither kvmtool nor QEMU use this definition, so it's more or less
orphaned by now. I am confident we can avoid it sneaking in in the
kernel again.

Cheers,
Andre.
