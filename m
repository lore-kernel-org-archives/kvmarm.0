From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 14/15] KVM: arm64: implement MSI injection in ITS
 emulation
Date: Sun, 2 Aug 2015 21:20:49 +0100
Message-ID: <55BE7BA1.40403@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-15-git-send-email-andre.przywara@arm.com>
 <55BB7678.5080105@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0FA359BBF
 for <kvmarm@lists.cs.columbia.edu>; Sun,  2 Aug 2015 16:12:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fW+fg2WKtvDP for <kvmarm@lists.cs.columbia.edu>;
 Sun,  2 Aug 2015 16:12:10 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 356F059BBA
 for <kvmarm@lists.cs.columbia.edu>; Sun,  2 Aug 2015 16:12:09 -0400 (EDT)
In-Reply-To: <55BB7678.5080105@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/07/15 14:22, Eric Auger wrote:

Salut Eric,

> On 07/10/2015 04:21 PM, Andre Przywara wrote:
>> When userland wants to inject a MSI into the guest, we have to use
>> our data structures to find the LPI number and the VCPU to receive
>> the interrupt.
>> Use the wrapper functions to iterate the linked lists and find the
>> proper Interrupt Translation Table Entry. Then set the pending bit
>> in this ITTE to be later picked up by the LR handling code. Kick
>> the VCPU which is meant to handle this interrupt.
>> We provide a VGIC emulation model specific routine for the actual
>> MSI injection. The wrapper functions return an error for models not
>> (yet) implementing MSIs (like the GICv2 emulation).
>> We also provide the handler for the ITS "INT" command, which allows a
>> guest to trigger an MSI via the ITS command queue.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/arm_vgic.h      |  1 +
>>  virt/kvm/arm/its-emul.c     | 65 +++++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/its-emul.h     |  2 ++
>>  virt/kvm/arm/vgic-v3-emul.c |  1 +
>>  4 files changed, 69 insertions(+)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 323c33a..9e1abf9 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -149,6 +149,7 @@ struct vgic_vm_ops {
>>  	int	(*map_resources)(struct kvm *, const struct vgic_params *);
>>  	bool	(*queue_lpis)(struct kvm_vcpu *);
>>  	void	(*unqueue_lpi)(struct kvm_vcpu *, int irq);
>> +	int	(*inject_msi)(struct kvm *, struct kvm_msi *);
>>  };
>>  
>>  struct vgic_io_device {
>> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
>> index 89534c6..a1c12bb 100644
>> --- a/virt/kvm/arm/its-emul.c
>> +++ b/virt/kvm/arm/its-emul.c
>> @@ -323,6 +323,55 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
>>  }
>>  
>>  /*
>> + * Translates an incoming MSI request into the redistributor (=VCPU) and
>> + * the associated LPI number. Sets the LPI pending bit and also marks the
>> + * VCPU as having a pending interrupt.
>> + */
>> +int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	struct vgic_its *its = &dist->its;
>> +	struct its_itte *itte;
>> +	int cpuid;
>> +	bool inject = false;
>> +	int ret = 0;
>> +
>> +	if (!vgic_has_its(kvm))
>> +		return -ENODEV;
>> +
>> +	if (!(msi->flags & KVM_MSI_VALID_DEVID))
>> +		return -EINVAL;
> I am currently reworking the GSI routing series according to latest
> comments (flag usage on userside and removal of EXTENDED_MSI type on
> kernel side as you suggested). Given the data path,
> 
> kvm_send_userspace_msi (kvm_msi*)
> |_ kvm_set_msi (kvm_kernel_irq_routing_entry *)
> 	|_ kvm->arch.vgic.vm_ops.inject_msi (kvm_msi *)
> 
> the above check is useless I think since in kvm_set_msi I need to
> populate a kvm_msi struct from a kernel routing entry struct. The kernel
> routing entry struct has no info about the validity of devid so I
> systematically sets the flag in kvm_msi.
> 
> I am still dubious about not storing the KVM_MSI_VALID_DEVID info
> somewhere in the kernel routing entry struct.

When I reworked our code to only use a flag and not a separate routing
type I ended up with the flag only guarding assignments, which wouldn't
hurt if done unconditionally (since they are all u32's). So the whole
usage of the flag is somewhat in jeopardy now.
Either the eventual MSI consumer requires a DevID (ITS emulation, which
will not work without it) or the consumer does not care at all and can
totally ignore it (GICv2m). So I think we can always pass on the DevID
field and let the final function decide whether to use it or not. But
somehow this doesn't sound right to me, so maybe I am missing something
here?

Cheers,
Andre.
