From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 05/15] KVM: arm/arm64: VGIC: add refcounting for IRQs
Date: Wed, 22 Jun 2016 09:26:12 +0100
Message-ID: <576A4BA4.6090103@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
 <1466165327-32060-6-git-send-email-andre.przywara@arm.com>
 <331a1fa6-1a53-cd83-fba2-6d2018765bba@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0121E49B4A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 04:21:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e6SQ3Iak2Rvy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 04:21:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9C1249B1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 04:21:22 -0400 (EDT)
In-Reply-To: <331a1fa6-1a53-cd83-fba2-6d2018765bba@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/06/16 09:18, Andre Przywara wrote:
> Hi Marc,
> 
> On 17/06/16 13:08, Andre Przywara wrote:
>> In the moment our struct vgic_irq's are statically allocated at guest
>> creation time. So getting a pointer to an IRQ structure is trivial and
>> safe. LPIs are more dynamic, they can be mapped and unmapped at any time
>> during the guest's _runtime_.
>> In preparation for supporting LPIs we introduce reference counting to
>> those structures. Since private IRQs and SPIs are statically allocated,
>> the reqcount never drops to 0 at the moment, but we increase it when an
>> IRQ gets onto a VCPU list and decrease it when it gets removed.
>> Also vgic_get_irq() gets changed to take the irq_lock already, this is
>> later needed to avoid a race between a potential LPI unmap and the
>> window between us getting the pointer and locking the IRQ.
>> This introduces vgic_put_irq(), which just does the unlock and makes
>> the new locking sequence look more symmetrical.
>> This approach deviates from the classical Linux refcounting with using
>> atomic_* types and functions, because the users of vgic_get_irq() take
>> the irq_lock anyway, so we just use an int and adjust the refcount while
>> holding the lock.
> 
> As discussed verbally, I am almost done on an implementation that uses
> the kernel's kref_* infrastructure to implement the ref-counting, on top
> of the existing vgic_irq locking.
> Since we consider the atomic inc/dec operations comparably cheap, that
> shouldn't sacrifice performance, but will increase readability and
> avoids nasty bugs in our own refcounting implementation by using well
> tested and reviewed code.

Indeed. And for further reference, here's the reason why I'm pushing for
kref being used: https://lwn.net/Articles/75920/

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
