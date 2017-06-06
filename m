From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 05/25] KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
Date: Tue, 6 Jun 2017 11:41:00 +0200
Message-ID: <20170606094100.GK9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-6-marc.zyngier@arm.com>
 <20170604202528.GH9464@cbox>
 <5b8acdaf-e5a5-25fd-fffe-5ff42d501ee0@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9186D40962
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 05:37:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EYbrJO97Nknd for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 05:37:09 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CF764095A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 05:37:09 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id x70so32952252wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 02:41:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5b8acdaf-e5a5-25fd-fffe-5ff42d501ee0@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 05, 2017 at 10:58:57AM +0100, Marc Zyngier wrote:
> On 04/06/17 21:25, Christoffer Dall wrote:
> > On Thu, Jun 01, 2017 at 11:20:57AM +0100, Marc Zyngier wrote:
> >> Add a handler for reading/writing the guest's view of the ICC_BPR1_EL1
> >> register, which is located in the ICH_VMCR_EL2.BPR1 field.
> >>
> >> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  virt/kvm/arm/hyp/vgic-v3-sr.c | 51 +++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 51 insertions(+)
> >>
> >> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> >> index 943bf11252d9..6254eaf72a77 100644
> >> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> >> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> >> @@ -375,6 +375,51 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
> >>  
> >>  #ifdef CONFIG_ARM64
> >>  
> >> +static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
> >> +{
> >> +	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> >> +}
> >> +
> >> +static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
> >> +{
> >> +	unsigned int bpr;
> >> +
> >> +	if (vmcr & ICH_VMCR_CBPR_MASK) {
> >> +		bpr = __vgic_v3_get_bpr0(vmcr);
> >> +		if (bpr < 7)
> >> +			bpr++;
> >> +	} else {
> >> +		bpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
> >> +	}
> >> +
> >> +	return bpr;
> >> +}
> >> +
> >> +static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> >> +{
> >> +	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
> >> +}
> >> +
> >> +static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> >> +{
> >> +	u64 val = vcpu_get_reg(vcpu, rt);
> >> +	u8 bpr_min = 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> > 
> > I can't seem to find where this behavior is documented, is it that 8 is
> > the theoretical max, and it's the upper preemption levels that apply, so
> > it must be 8 - number supported?
> 
> I took inspiration from the VPriorityGroup() helper in the GICv3
> pseudocode. You can also deduct this from the table described in the
> ICC_BPR0_EL1 documentation, though that's admittedly not very clear.
> 

Ah, yes, now I understand this. Since you can at most support
ICH_VTR_EL2.PREbits than the minimal value must be one that doesn't
define more preemmption levels.  I don't know why this was so hard for
me to realize.

Thanks,
-Christoffer
