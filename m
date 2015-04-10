From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: check IRQ number on userland injection
Date: Fri, 10 Apr 2015 18:43:57 +0200
Message-ID: <5527FDCD.70507@redhat.com>
References: <1428679079-16499-1-git-send-email-andre.przywara@arm.com>
 <5527EB5F.6080500@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 913C44C17F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 12:36:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PU0PlCduIy4d for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 12:36:23 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D5A24C169
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 12:36:22 -0400 (EDT)
Received: by wiaa2 with SMTP id a2so3474242wia.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 09:44:01 -0700 (PDT)
In-Reply-To: <5527EB5F.6080500@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 10/04/2015 17:25, Marc Zyngier wrote:
> On 10/04/15 16:17, Andre Przywara wrote:
>> When userland injects a SPI via the KVM_IRQ_LINE ioctl we currently
>> only check it against a fixed limit, which historically is set
>> to 127. With the new dynamic IRQ allocation the effective limit may
>> actually be smaller (64).
>> So when now a malicious or buggy userland injects a SPI in that
>> range, we spill over on our VGIC bitmaps and bytemaps memory.
>> I could trigger a host kernel NULL pointer dereference with current
>> mainline by injecting some bogus IRQ number from a hacked kvmtool:
>> -----------------
>> ....
>> DEBUG: kvm_vgic_inject_irq(kvm, cpu=0, irq=114, level=1)
>> DEBUG: vgic_update_irq_pending(kvm, cpu=0, irq=114, level=1)
>> DEBUG: IRQ #114 still in the game, writing to bytemap now...
>> Unable to handle kernel NULL pointer dereference at virtual address 00000000
>> pgd = ffffffc07652e000
>> [00000000] *pgd=00000000f658b003, *pud=00000000f658b003, *pmd=0000000000000000
>> Internal error: Oops: 96000006 [#1] PREEMPT SMP
>> Modules linked in:
>> CPU: 1 PID: 1053 Comm: lkvm-msi-irqinj Not tainted 4.0.0-rc7+ #3027
>> Hardware name: FVP Base (DT)
>> task: ffffffc0774e9680 ti: ffffffc0765a8000 task.ti: ffffffc0765a8000
>> PC is at kvm_vgic_inject_irq+0x234/0x310
>> LR is at kvm_vgic_inject_irq+0x30c/0x310
>> pc : [<ffffffc0000ae0a8>] lr : [<ffffffc0000ae180>] pstate: 80000145
>> .....
>>
>> So this patch fixes this by checking the SPI number against the
>> actual limit. Also we remove the former legacy hard limit of
>> 127 in the ioctl code.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> CC: <stable@vger.kernel.org> # 4.0, 3.19, 3.18
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> It is getting really tight for 4.0, but hopefully I can squeeze it in a
> second pull request together with the missing barrier on 32bit.

I doubt I'll be able to send the pull request to Linus.  Can't it really
wait a couple of weeks?  I'll include it in the second pull request for
4.1, together with (if you want) the lazy (lazier) FP/SIMD save/restore.

Paolo
