From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 13/45] KVM: arm/arm64: vgic-new: Export register
 access interface
Date: Tue, 12 Apr 2016 14:52:37 +0200
Message-ID: <20160412125237.GE3039@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-14-git-send-email-andre.przywara@arm.com>
 <20160331092446.GS4126@cbox> <570B85FD.8090204@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B37B94011D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:50:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 05mzg7KApZ-b for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2016 08:50:41 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E9AD400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:50:41 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id n3so26841129wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 05:52:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570B85FD.8090204@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 11, 2016 at 12:09:49PM +0100, Andre Przywara wrote:
> Hej,
> 
> On 31/03/16 10:24, Christoffer Dall wrote:
> > On Fri, Mar 25, 2016 at 02:04:36AM +0000, Andre Przywara wrote:
> >> Userland can access the emulated GIC to save and restore its state
> >> for initialization or migration purposes.
> >> The kvm_io_bus API requires an absolute gpa, which does not fit the
> >> KVM_DEV_ARM_VGIC_GRP_DIST_REGS user API, that only provides relative
> >> offsets. So we explicitly iterate our register list to connect
> >> userland to the VGIC.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> Reviewed-by: Eric Auger <eric.auger@linaro.org>
> >> ---
> >>  virt/kvm/arm/vgic/vgic.h      |  2 ++
> >>  virt/kvm/arm/vgic/vgic_mmio.c | 45 +++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 47 insertions(+)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> >> index 53730ba..a462e2b 100644
> >> --- a/virt/kvm/arm/vgic/vgic.h
> >> +++ b/virt/kvm/arm/vgic/vgic.h
> >> @@ -25,6 +25,8 @@ void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
> >>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
> >>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
> >>  void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
> >> +int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
> >> +			int offset, int len, void *val);
> >>  
> >>  #ifdef CONFIG_KVM_ARM_VGIC_V3
> >>  void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr);
> >> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> >> index 26c46e7..e1fd17f 100644
> >> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> >> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> >> @@ -113,6 +113,51 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
> >>  		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
> >>  };
> >>  
> >> +/*
> >> + * Using kvm_io_bus_* to access GIC registers directly from userspace does
> >> + * not work, since we would need the absolute IPA address of the register
> >> + * in question, but the userland interface only provides relative offsets.
> >> + * So we provide our own dispatcher function for that purpose here.
> >> + */
> >> +static int vgic_mmio_access(struct kvm_vcpu *vcpu,
> >> +			    struct vgic_register_region *region, int nr_regions,
> >> +			    bool is_write, int offset, int len, void *val)
> >> +{
> > 
> > I suspect this is going to get rewored based on previous discussions
> > with the IO api...
> > 
> >> +	int i;
> >> +	struct vgic_io_device dev;
> >> +
> >> +	for (i = 0; i < nr_regions; i++) {
> >> +		int reg_size = region[i].len;
> >> +
> >> +		if (!reg_size)
> >> +			reg_size = (region[i].bits_per_irq * 1024) / 8;
> >> +
> >> +		if ((offset < region[i].reg_offset) ||
> >> +		    (offset + len > region[i].reg_offset + reg_size))
> >> +			continue;
> >> +
> >> +		dev.base_addr	= region[i].reg_offset;
> >> +		dev.redist_vcpu	= vcpu;
> >> +
> >> +		if (is_write)
> >> +			return region[i].ops.write(vcpu, &dev.dev,
> >> +						   offset, len, val);
> >> +		else
> >> +			return region[i].ops.read(vcpu, &dev.dev,
> >> +						  offset, len, val);
> >> +	}
> >> +
> >> +	return -ENODEV;
> >> +}
> >> +
> >> +int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
> >> +			int offset, int len, void *val)
> >> +{
> >> +	return vgic_mmio_access(vcpu, vgic_v2_dist_registers,
> >> +				ARRAY_SIZE(vgic_v2_dist_registers),
> >> +				is_write, offset, len, val);
> >> +}
> >> +
> > 
> > this makes me wonder if the v2 region declarations and functions like
> > this should go in a separate file?  vgic/mmio-v2.c ?
> 
> But we actually share a lot of functions like all the PENDING, ENABLED,
> ACTIVE, PRIORITY, IGROUP register handlers. So we would need to export
> them in order to be used by both the v2 and v3 emulation. This is what I
> did for the existing v3 emulation, but I didn't like it very much.
> Now we keep all of this private and static, both the handler functions
> and the structures declaring the respective register layout.
> I found this more appropriate now that v2 and v3 emulation are developed
> hand in hand.
> I see that the file gets pretty big, but it's still only roughly half
> the size of the old vgic.c and also smaller than the combined old
> vgic-v2-emul.c and vgic-v3-emul.c.
> 
> So I guess those 37K are just the price we need to pay for the beast
> that the GIC actually is.
> 
ok, that's a convincing argument.

Thanks,
-Christoffer
