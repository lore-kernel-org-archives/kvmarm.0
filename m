Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EABA350291
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768323816; cv=none; b=DARtwcj16O9TTjG0g3UCTeXWMVs+qjMvYcU6lZmxjVreIhazZBDYz8+eZU+5TetNDUuh2/H0KZeWoHLIGfuC3EhXFdzy4Fn63ZzibF2J7DVX7ixELZkWHIRBOp3K/p2kV9ZXI3M5/3swYp6NHa7VdbGjjSy/2vpqiqOscf7gpxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768323816; c=relaxed/simple;
	bh=lrdbt2o24sdBLfhOSzTNromel7XSWRN5qQXf5Fx7W30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbOdCPo33X0d/nDJsfmsyILLky82BaMSC3IGCJgw7U4MLDjJ0cM+jkVLCPfk5L1yz64ErCGQJb34RAbaQPPqpzohKI7Dwt5VuJXy4sKEJitDUOu1xcd+xRrr4zX8vx5f2dygwltzsioRANVJRKUcarO2UUXmKTWikPlg9GhokPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D421497;
	Tue, 13 Jan 2026 09:03:26 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26FA03F632;
	Tue, 13 Jan 2026 09:03:30 -0800 (PST)
Date: Tue, 13 Jan 2026 17:03:28 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v6 03/35] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
Message-ID: <aWZ64AaWctSjkCFv@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-4-alexandru.elisei@arm.com>
 <1aaffbcd-ba0c-4371-80d7-ce59ac7f13a9@linaro.org>
 <aWTaXBse_R_LjJE-@raptor>
 <d7db9f17-012e-43d7-a0a5-58b254dd7e33@linaro.org>
 <aWUQ3bYuxpMEWTUk@raptor>
 <aWYdob5IfyOQcu6I@raptor>
 <43ec5e82-88a6-4c7b-983a-b5aa32673913@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43ec5e82-88a6-4c7b-983a-b5aa32673913@linaro.org>

Hi James,

On Tue, Jan 13, 2026 at 03:00:34PM +0000, James Clark wrote:
> 
> 
> On 13/01/2026 10:25 am, Alexandru Elisei wrote:
> > Hi James,
> > 
> > On Mon, Jan 12, 2026 at 03:18:53PM +0000, Alexandru Elisei wrote:
> > > Hi James,
> > > 
> > > On Mon, Jan 12, 2026 at 12:09:19PM +0000, James Clark wrote:
> > > > 
> > > > 
> > > > On 12/01/2026 11:26 am, Alexandru Elisei wrote:
> > > > > Hi James,
> > > > > 
> > > > > On Fri, Jan 09, 2026 at 04:29:50PM +0000, James Clark wrote:
> > > > > > 
> > > > > > 
> > > > > > On 14/11/2025 4:06 pm, Alexandru Elisei wrote:
> > > > > > > Add a new configuration option that will be used for KVM SPE emulation.
> > > > > > > CONFIG_KVM_ARM_SPE depends on the SPE driver being builtin because:
> > > > > > > 
> > > > > > > 1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
> > > > > > >       and that will be used by KVM to emulate SPE on heterogeneous systems.
> > > > > > > 
> > > > > > > 2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
> > > > > > >       level.
> > > > > > > 
> > > > > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > > > > ---
> > > > > > >     arch/arm64/kvm/Kconfig | 8 ++++++++
> > > > > > >     1 file changed, 8 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > > > > > > index 4f803fd1c99a..31388b5b2655 100644
> > > > > > > --- a/arch/arm64/kvm/Kconfig
> > > > > > > +++ b/arch/arm64/kvm/Kconfig
> > > > > > > @@ -83,4 +83,12 @@ config PTDUMP_STAGE2_DEBUGFS
> > > > > > >     	  If in doubt, say N.
> > > > > > > +config KVM_ARM_SPE
> > > > > > > +	bool
> > > > > > > +	depends on KVM && ARM_SPE_PMU=y
> > > > > > 
> > > > > > I think the most common configuration is module, so requiring built-in isn't
> > > > > > great. If there's any way of avoiding it, even if it costs a little bit of
> > > > > > pain, it would be good for adoption.
> > > > > 
> > > > > I'm not sure how that could be done. You need the buffer maintenance interrupt
> > > > > to do a VM exit so KVM can inject the virtual interrupt back into the guest,
> > > > > otherwise there's a possibility of a large blackout window when the buffer is
> > > > > full.
> > > > 
> > > > Without expanding more I don't see how injecting an interrupt is strongly
> > > > related to the way it's compiled.
> > > 
> > > It's the SPE driver that enables the hardware interrupt in the GIC.
> > > 
> > > > 
> > > > > 
> > > > > The code also relies on the SPE driver to probe all the SPUs in the system.
> > > > > 
> > > > 
> > > > I don't think that's a hard requirement either, the KVM code could fairly
> > > > easily do this itself. Inline the common code and put it in a shared header
> > > > etc. I'm sure there are lots of creative ways to flip the dependencies that
> > > > might not be "proper" software engineering. But like I said a bit of pain
> > > > here might be beneficial overall.
> > > 
> > > Userspace gets the maximum buffer size and the SPE instance id from the sysfs
> > > files.
> > > 
> > > So KVM would have to parse the DTB, read PMBIDR_EL1 and PMSIDR_EL1 on each
> > > physical CPU in the system, create the sysfs files (at least 'type', 'cpumask'
> > > and 'max_buffer_size' or whatever that ends up being named) and install a dummy
> > > IRQ handler before the SPE driver is loaded.
> > > 
> > > Then when the SPE driver is loaded, the driver would have to remove the IRQ
> > > handler and install its own, and create the rest of the sysfs files.
> > > 
> > > That's assuming that the SPE driver is loaded after KVM. I think it's possible
> > > for the SPE driver to be loaded first. So both KVM and SPE would have be able to
> > > communicate with one other in case the other probed first.
> > > 
> > > Is having to change the symbol ARM_SPE_PMU from 'm' to 'y' worth this? I am not
> > > convinced and I don't see much use for going down this rabbit hole at this stage
> > > of the series.
> 
> No, definitely not something that needs to be done at this point.
> 
> > > 
> > > Also, since KVM would partially populate the sysfs directory for each SPE
> > > instance, would it be reasonable for software to assume that the SPE driver is
> > > loaded based on this and start using it? For example, how does perf detect the
> > > presence of the arm_spe event?
> > 
> > Coming back to this, I do understand and agree with your concerns, so after
> > talking in private I came up with exporting the symbol kvm_host_spe_init() -
> > that's the function which adds the SPE instance to the list of SPUs.
> > 
> > With this change the SPE driver can be built as a module, but SPE for a VM is
> > available only as long as the driver is loaded.
> > 
> > I hope that improves the adoption story :)
> > 
> > Thanks,
> > Alex
> 
> Nice, if it's not too horrible we should try it. If it turns out to be
> horrible then yes we'll have to ask people to change their configs.

It was only a few lines of code:

+void kvm_spe_add_instance(struct arm_spe_pmu *arm_spu)
+{
+       struct arm_spu_entry *entry;
+
+       guard(mutex)(&arm_spus_lock);
+
+       entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+       if (!entry)
+               return;
+
+       entry->arm_spu = arm_spu;
+       list_add_tail(&entry->link, &arm_spus);
+}
+EXPORT_SYMBOL_FOR_MODULES(kvm_spe_add_instance, "arm_spe_pmu");
+
+void kvm_spe_remove_instance(struct arm_spe_pmu *arm_spu)
+{
+       struct arm_spu_entry *entry, *tmp;
+
+       guard(mutex)(&arm_spus_lock);
+
+       if (list_empty(&arm_spus))
+               return;
+
+       list_for_each_entry_safe(entry, tmp, &arm_spus, link) {
+               if (entry->arm_spu == arm_spu) {
+                       list_del(&entry->link);
+                       break;
+               }
+       }
+}
+EXPORT_SYMBOL_FOR_MODULES(kvm_spe_remove_instance, "arm_spe_pmu");
+
+bool kvm_supports_spe(void)
+{
+       return !list_empty(&arm_spus);
+}

Thanks,
Alex
