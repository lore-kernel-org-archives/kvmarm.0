From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 09/13] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Thu, 11 Jun 2015 16:46:11 +0100
Message-ID: <5579AD43.6070407@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-10-git-send-email-andre.przywara@arm.com>
 <55770D4A.9090801@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BF1F5431A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2015 11:35:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6fHb0FoSxJdb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2015 11:35:35 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98D1654306
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2015 11:35:35 -0400 (EDT)
In-Reply-To: <55770D4A.9090801@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Salut Eric,

On 06/09/2015 04:59 PM, Eric Auger wrote:
> On 05/29/2015 11:53 AM, Andre Przywara wrote:
>> As the actual LPI number in a guest can be quite high, but is mostly
>> assigned using a very sparse allocation scheme, bitmaps and arrays
>> for storing the virtual interrupt status are a waste of memory.
>> We use our equivalent of the "Interrupt Translation Table Entry"
>> (ITTE) to hold this extra status information for a virtual LPI.
>> As the normal VGIC code cannot use it's fancy bitmaps to manage
>> pending interrupts, we provide a hook in the VGIC code to let the
>> ITS emulation handle the list register queueing itself.
>> LPIs are located in a separate number range (>=8192), so
>> distinguishing them is easy. With LPIs being only edge-triggered, we
>> get away with a less complex IRQ handling.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/arm_vgic.h      |  2 ++
>>  virt/kvm/arm/its-emul.c     | 66 +++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/its-emul.h     |  3 ++
>>  virt/kvm/arm/vgic-v3-emul.c |  2 ++
>>  virt/kvm/arm/vgic.c         | 68 +++++++++++++++++++++++++++++++++------------
>>  5 files changed, 124 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index fa17df6..de19c34 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -147,6 +147,8 @@ struct vgic_vm_ops {
>>  	int	(*init_model)(struct kvm *);
>>  	void	(*destroy_model)(struct kvm *);
>>  	int	(*map_resources)(struct kvm *, const struct vgic_params *);
>> +	bool	(*queue_lpis)(struct kvm_vcpu *);
>> +	void	(*unqueue_lpi)(struct kvm_vcpu *, int irq);
>>  };
>>  
>>  struct vgic_io_device {
>> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
>> index f0f4a9c..f75fb9e 100644
>> --- a/virt/kvm/arm/its-emul.c
>> +++ b/virt/kvm/arm/its-emul.c
>> @@ -50,8 +50,26 @@ struct its_itte {
>>  	struct its_collection *collection;
>>  	u32 lpi;
>>  	u32 event_id;
>> +	bool enabled;
>> +	unsigned long *pending;
> allocated in later patch. does not ease the review of the life cycle but
> I guess it is accepted/acceptable.

I tried to move some bits around a bit and ran into several issues, so I
guess we have to live with that.

> Isn't it somehow redundant to have a bitmap here where the collection
> already indicates the target cpu id on which the LPI is pending?

Unfortunately only "somewhat", as Marc taught me the other day ;-)
First, the spec shows that the pending bitmap is allocated _per CPU_, so
we have to model this here appropriately.
Second, you could have an LPI pending on one distributor, then change
the associated collection to another distributor and trigger that
interrupt again. This would make it pending on two VCPUs.
Admittedly not the most prominent use case, but possible.

Cheers,
Andre.
