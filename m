From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 25/26] KVM: arm/arm64: GICv4: Prevent heterogenous
 systems from using GICv4
Date: Sun, 29 Oct 2017 03:16:50 +0100
Message-ID: <20171029021650.GH2166@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-26-marc.zyngier@arm.com>
 <20171026154839.ebtmqzcy7jjyejul@salmiak> <868tfxaxiv.fsf@arm.com>
 <20171027073728.taejncafoehkfzuc@salmiak> <86r2tp9g2s.fsf@arm.com>
 <20171027080421.m3ruegg6liflcvro@salmiak> <86mv4d9elr.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87BA340A74
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Oct 2017 22:15:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tZWIR7MFBOwa for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 Oct 2017 22:15:32 -0400 (EDT)
Received: from mail-lf0-f68.google.com (mail-lf0-f68.google.com
 [209.85.215.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07C9640638
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Oct 2017 22:15:32 -0400 (EDT)
Received: by mail-lf0-f68.google.com with SMTP id l23so11096479lfk.10
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Oct 2017 19:17:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <86mv4d9elr.fsf@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 09:31:12AM +0100, Marc Zyngier wrote:
> On Fri, Oct 27 2017 at  9:04:21 am BST, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Fri, Oct 27, 2017 at 08:59:23AM +0100, Marc Zyngier wrote:
> >> On Fri, Oct 27 2017 at  8:37:28 am BST, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > On Fri, Oct 27, 2017 at 07:57:12AM +0100, Marc Zyngier wrote:
> >> >> On Thu, Oct 26 2017 at  4:48:39 pm BST, Mark Rutland <mark.rutland@arm.com> wrote:
> >> >> > On Fri, Oct 06, 2017 at 04:34:00PM +0100, Marc Zyngier wrote:
> >> >
> >> >> >> @@ -485,8 +495,21 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
> >> >> >>  	kvm_vgic_global_state.can_emulate_gicv2 = false;
> >> >> >>  	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
> >> >> >>  
> >> >> >> -	/* GICv4 support? */
> >> >> >> +	/*
> >> >> >> +	 * GICv4 support? We need to check on all CPUs in case of some
> >> >> >> +	 * extremely creative form of big-little brain damage...
> >> >> >> +	 */
> >> >> >>  	if (info->has_v4) {
> >> >> >> +		int cpu;
> >> >> >> +
> >> >> >> +		for_each_online_cpu(cpu) {
> >> >> >> +			bool enable;
> >> >> >> +
> >> >> >> +			smp_call_function_single(cpu, vgic_check_v4_cpuif,
> >> >> >> +						 &enable, 1);
> >> >> >> +			gicv4_enable = gicv4_enable && enable;
> >> >> >> +		}
> >> >> >
> >> >> > With maxcpus=N on the command line, CPUs can be brought online late, so we
> >> >> > might need this in a hotplug callback (and/or in the arm64 cpufeature
> >> >> > framework) to handle that case.
> >> >> 
> >> >> I'm afraid that won't be enough. If the CPU is brought up once we've
> >> >> already started a VM, we're screwed, as we cannot retroactively decide
> >> >> to drop GICv4 on the floor and nuke the guest. Or did you have something
> >> >> more radical in mind? Panic?
> >> >
> >> > If you teach the arm64 cpufeature framework about this, it can abort bringing a
> >> > !GICv4 CPU online late.
> >> 
> >> You wish.
> >> 
> >> There is all kind of difficulties with that. This requires checking an
> >> EL2 register (ICH_VTR_EL2) when we've not initialised KVM yet (so no HYP
> >> call facility). We could make it an additional hyp-stub feature, but
> >> that feels pretty involved.
> >
> > Aargh; I'd assumed we could probe this from EL1 somewhow.
> >
> >> Effectively, GICv4 support having it supported on the redistributors,
> >> the ITSs, and the CPUs. The cpufeature framework only addresses the
> >> first one. So unless the solution encompasses all the elements in the
> >> chain, any checking feels pretty pointless.
> >
> > Sure thing. :/
> 
> How are we taking this further?
> 
> I can drop this altogether (after all, you will get what you deserve if
> you design a broken system). The alternative would be to add a hotplug
> notifier here, and spit out a warning if we're going to be in
> trouble. We still run into the risk of messing with a VM that's already
> been started before the non-v4 CPU.
> 
> Thoughts anyone?
> 
I think it's fine to drop the check like you do in v5, and if platforms
that actually have this problem show up and we need to detect against
bringing certain CPUs online, we can have a look at building a massive
control-infrastructure then.

Thanks,
-Christoffer
