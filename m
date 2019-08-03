Return-Path: <SRS0=TbXc=V7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D83C433FF
	for <kvmarm@archiver.kernel.org>; Sat,  3 Aug 2019 18:13:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52BF02087C
	for <kvmarm@archiver.kernel.org>; Sat,  3 Aug 2019 18:13:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52BF02087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D004A562;
	Sat,  3 Aug 2019 14:13:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IkNoQ-C95aaS; Sat,  3 Aug 2019 14:13:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FC514A523;
	Sat,  3 Aug 2019 14:13:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57DDB4A51E
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Aug 2019 14:13:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oKTIZo92I4hR for <kvmarm@lists.cs.columbia.edu>;
 Sat,  3 Aug 2019 14:13:30 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 057734A4E6
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Aug 2019 14:13:30 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1htyWw-0002Em-AQ; Sat, 03 Aug 2019 20:13:22 +0200
Date: Sat, 3 Aug 2019 19:13:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 4/9] KVM: arm64: Support stolen time reporting via
 shared structure
Message-ID: <20190803191303.02e9bcc9@why>
In-Reply-To: <20190803185817.11285b2a@why>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-5-steven.price@arm.com>
 <20190803185817.11285b2a@why>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: steven.price@arm.com, kvm@vger.kernel.org,
 catalin.marinas@arm.com, linux-doc@vger.kernel.org, linux@armlinux.org.uk,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sat, 3 Aug 2019 18:58:17 +0100
Marc Zyngier <maz@kernel.org> wrote:

> On Fri,  2 Aug 2019 15:50:12 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
> > Implement the service call for configuring a shared structre between a
> > VCPU and the hypervisor in which the hypervisor can write the time
> > stolen from the VCPU's execution time by other tasks on the host.
> > 
> > The hypervisor allocates memory which is placed at an IPA chosen by user
> > space. The hypervisor then uses WRITE_ONCE() to update the shared
> > structre ensuring single copy atomicity of the 64-bit unsigned value
> > that reports stolen time in nanoseconds.
> > 
> > Whenever stolen time is enabled by the guest, the stolen time counter is
> > reset.
> > 
> > The stolen time itself is retrieved from the sched_info structure
> > maintained by the Linux scheduler code. We enable SCHEDSTATS when
> > selecting KVM Kconfig to ensure this value is meaningful.
> > 
> > Signed-off-by: Steven Price <steven.price@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 13 +++++-
> >  arch/arm64/kvm/Kconfig            |  1 +
> >  include/kvm/arm_hypercalls.h      |  1 +
> >  include/linux/kvm_types.h         |  2 +
> >  virt/kvm/arm/arm.c                | 18 ++++++++
> >  virt/kvm/arm/hypercalls.c         | 70 +++++++++++++++++++++++++++++++
> >  6 files changed, 104 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f656169db8c3..78f270190d43 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -44,6 +44,7 @@
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> >  #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
> > +#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
> >  
> >  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >  
> > @@ -83,6 +84,11 @@ struct kvm_arch {
> >  
> >  	/* Mandated version of PSCI */
> >  	u32 psci_version;
> > +
> > +	struct kvm_arch_pvtime {
> > +		void *st;
> > +		gpa_t st_base;
> > +	} pvtime;
> >  };
> >  
> >  #define KVM_NR_MEM_OBJS     40
> > @@ -338,8 +344,13 @@ struct kvm_vcpu_arch {
> >  	/* True when deferrable sysregs are loaded on the physical CPU,
> >  	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
> >  	bool sysregs_loaded_on_cpu;
> > -};
> >  
> > +	/* Guest PV state */
> > +	struct {
> > +		u64 steal;
> > +		u64 last_steal;
> > +	} steal;
> > +};
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> >  #define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
> >  				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index a67121d419a2..d8b88e40d223 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -39,6 +39,7 @@ config KVM
> >  	select IRQ_BYPASS_MANAGER
> >  	select HAVE_KVM_IRQ_BYPASS
> >  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
> > +	select SCHEDSTATS
> >  	---help---
> >  	  Support hosting virtualized guest machines.
> >  	  We don't support KVM with 16K page tables yet, due to the multiple
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index 35a5abcc4ca3..9f0710ab4292 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -7,6 +7,7 @@
> >  #include <asm/kvm_emulate.h>
> >  
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> > +int kvm_update_stolen_time(struct kvm_vcpu *vcpu);
> >  
> >  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> >  {
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index bde5374ae021..1c88e69db3d9 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -35,6 +35,8 @@ typedef unsigned long  gva_t;
> >  typedef u64            gpa_t;
> >  typedef u64            gfn_t;
> >  
> > +#define GPA_INVALID	(~(gpa_t)0)
> > +
> >  typedef unsigned long  hva_t;
> >  typedef u64            hpa_t;
> >  typedef u64            hfn_t;
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index f645c0fbf7ec..ebd963d2580b 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -40,6 +40,10 @@
> >  #include <asm/kvm_coproc.h>
> >  #include <asm/sections.h>
> >  
> > +#include <kvm/arm_hypercalls.h>
> > +#include <kvm/arm_pmu.h>
> > +#include <kvm/arm_psci.h>
> > +
> >  #ifdef REQUIRES_VIRT
> >  __asm__(".arch_extension	virt");
> >  #endif
> > @@ -135,6 +139,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >  	kvm->arch.max_vcpus = vgic_present ?
> >  				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
> >  
> > +	kvm->arch.pvtime.st_base = GPA_INVALID;
> >  	return ret;
> >  out_free_stage2_pgd:
> >  	kvm_free_stage2_pgd(kvm);
> > @@ -371,6 +376,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  	kvm_vcpu_load_sysregs(vcpu);
> >  	kvm_arch_vcpu_load_fp(vcpu);
> >  	kvm_vcpu_pmu_restore_guest(vcpu);
> > +	kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> >  
> >  	if (single_task_running())
> >  		vcpu_clear_wfe_traps(vcpu);
> > @@ -617,6 +623,15 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
> >  	smp_rmb();
> >  }
> >  
> > +static void vcpu_req_record_steal(struct kvm_vcpu *vcpu)
> > +{
> > +	int idx;
> > +
> > +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > +	kvm_update_stolen_time(vcpu);
> > +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +}
> > +
> >  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> >  {
> >  	return vcpu->arch.target >= 0;
> > @@ -636,6 +651,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  		 * that a VCPU sees new virtual interrupts.
> >  		 */
> >  		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
> > +
> > +		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
> > +			vcpu_req_record_steal(vcpu);  
> 
> Something troubles me. Here, you've set the request on load. But you
> can be preempted at any time (preemption gets disabled just after).
> 
> I have the feeling that should you get preempted right here, you'll
> end-up having accumulated the wrong amount of steal time, as the
> request put via load when you'll get scheduled back in will only get
> processed after a full round of entry/exit/entry, which doesn't look
> great.

Ah, no. We're saved by the check for pending requests right before we
jump in the guest, causing an early exit and the whole shebang to be
restarted.

	M.
-- 
Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
