From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Fri, 24 Jul 2015 17:06:15 +0100
Message-ID: <55B26277.80205@arm.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <55A93488.9060408@arm.com> <00df01d0c22b$fcaef0d0$f60cd270$@samsung.com>
 <55ACAC73.9090500@arm.com> <03d901d0c44e$beadaa90$3c08ffb0$@samsung.com>
 <55B11AEC.4050804@arm.com> <008f01d0c625$45d91a90$d18b4fb0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B289C59296
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 11:54:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OCv1vlFiSLx3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2015 11:54:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFD265928A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 11:54:02 -0400 (EDT)
In-Reply-To: <008f01d0c625$45d91a90$d18b4fb0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 24/07/15 16:27, Pavel Fedin wrote:
>>>  Ok, let's leave this API alone then for now...
>>>  Will then be a concensus if i tweak the thing a little bit and we just enable KVM without both
> vGIC
>>> and vTimer ? It will be an emulator's problem how to handle them then.
>>
>> Well, let's see the patches first, and how invasive they are.
> 
>  Please, i've just posted an RFC and cc'ed you.
>  I would say the implementation is very small. However, perhaps, it's not going to work with active
> state switching patch, because as far as i understand the whole thing depends on manipulations with
> ARCH_TIMER_CTRL_IT_MASK. Without it i'm going to get multiple interrupts instead of only one. It
> would be possible to signal the interrupt as real level-sensitive (since we will be tracking active
> state), but... it's not possible to know when to deactivate the line, hardware doesn't report that.

Then it is likely to be a lost cause. We need to get rid of the timer
masking crap, as it prevents us from running perfectly valid guests (QNX
being one). It also imposes the same hack on other guests (UEFI was
forced to implement the same horror).

As I said before, not having a VGIC pretty much puts you in an uncharted
territory, and the amount of hacks you have to introduce are not really
worth the effort in mainline.

It is rather sad, but I hope this serves as a lesson for whoever decides
to cut corner on HW implementation while thinking "SW will take care of
it". They usually shoot themselves in the foot.

	M.
-- 
Jazz is not dead. It just smells funny...
