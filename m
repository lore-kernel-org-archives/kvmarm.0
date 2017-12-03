From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [PATCH 37/37] KVM: arm/arm64: Avoid VGICv3 save/restore on VHE
 with no IRQs
Date: Sun, 3 Dec 2017 21:38:02 +0100
Message-ID: <20171203203802.GC32397@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-38-christoffer.dall@linaro.org>
 <20171130183330.x7jc6m2yffcxcvkz@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69A7249D5E
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Dec 2017 15:34:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MQM5TIoffn7A for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Dec 2017 15:34:56 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F8CA40651
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Dec 2017 15:34:56 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id 64so10980362wme.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Dec 2017 12:38:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171130183330.x7jc6m2yffcxcvkz@yury-thinkpad>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Yury,

On Thu, Nov 30, 2017 at 09:33:30PM +0300, Yury Norov wrote:
> On Thu, Oct 12, 2017 at 12:41:41PM +0200, Christoffer Dall wrote:
> > We can finally get completely rid of any calls to the VGICv3
> > save/restore functions when the AP lists are empty on VHE systems.  This
> > requires carefully factoring out trap configuration from saving and
> > restoring state, and carefully choosing what to do on the VHE and
> > non-VHE path.
> > 
> > One of the challenges is that we cannot save/restore the VMCR lazily
> > because we can only write the VMCR when ICC_SRE_EL1.SRE is cleared when
> > emulating a GICv2-on-GICv3, since otherwise all Group-0 interrupts end
> > up being delivered as FIQ.
> > 
> > To solve this problem, and still provide fast performance in the fast
> > path of exiting a VM when no interrupts are pending (which also
> > optimized the latency for actually delivering virtual interrupts coming
> > from physical interrupts), we orchestrate a dance of only doing the
> > activate/deactivate traps in vgic load/put for VHE systems (which can
> > have ICC_SRE_EL1.SRE cleared when running in the host), and doing the
> > configuration on every round-trip on non-VHE systems.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm/include/asm/kvm_hyp.h   |   2 +
> >  arch/arm/kvm/hyp/switch.c        |   8 ++-
> >  arch/arm64/include/asm/kvm_hyp.h |   2 +
> >  arch/arm64/kvm/hyp/switch.c      |   8 ++-
> >  virt/kvm/arm/hyp/vgic-v3-sr.c    | 116 +++++++++++++++++++++++++--------------
> >  virt/kvm/arm/vgic/vgic-v3.c      |   6 ++
> >  virt/kvm/arm/vgic/vgic.c         |   7 +--
> >  7 files changed, 101 insertions(+), 48 deletions(-)
> 
> [...]
> 
> > diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> > index ed5da75..34d71d2 100644
> > --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> > +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> > @@ -208,15 +208,15 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> >  	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> > -	u64 val;
> >  
> >  	/*
> >  	 * Make sure stores to the GIC via the memory mapped interface
> > -	 * are now visible to the system register interface.
> > +	 * are now visible to the system register interface when reading the
> > +	 * LRs, and when reading back the VMCR on non-VHE systems.
> >  	 */
> > -	if (!cpu_if->vgic_sre) {
> > -		dsb(st);
> > -		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
> > +	if (used_lrs || !has_vhe()) {
> > +		if (!cpu_if->vgic_sre)
> > +			dsb(st);
> >  	}
> 
> Nit:
> 	if ((used_lrs || !has_vhe()) && !cpu_if->vgic_sre)
> 		dsb(st);
> 

I don't think that's easier to read and I'm not paying for vertical
space, so I'm going to keep it as is.

Thanks,
-Christoffer
