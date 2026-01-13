Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED9D38E5FB
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 12:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768308511; cv=none; b=ACsS+SA4U6Vsyeo/R5pxtNZPHWo5XmJIBgZ/vsfz2zPblktppBmH0pn6HYV3vIJ497bV4Km1IQOVdEOd7NIywBYfeBXgyoQnd1NsRyIKhUqLyJDnMUv26yN6F0RV4mxDEcg22JrA01ik/lvaLC7e1buIrqfkEqW9jTtyfU7VIJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768308511; c=relaxed/simple;
	bh=SaXvwV/cVBPZ20DeAZx7bxdfUTNhM0j5tTacSDfg/Uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWBvjUPLujnJPG1gPDv8eRFVi1Y1XRokt/p7O8T7UaIXH0dRjCKIa0o2Rc3uRCxBTEtjFuWTVXDra+eT+eh5q+QSjCD1P0WdCrZq2drJ+H8J47D5ujqITVFlFAbILufsXDlIv9ny6cjbI+h92DmiIhJgVnEnT3ucNVuphgCkcRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5932A497;
	Tue, 13 Jan 2026 04:48:22 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 462EE3F59E;
	Tue, 13 Jan 2026 04:48:27 -0800 (PST)
Date: Tue, 13 Jan 2026 12:48:24 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v6 19/35] KVM: arm64: Trap PMBIDR_EL1 and PMSIDR_EL1
Message-ID: <aWY_GGzNW85ZR7dP@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-20-alexandru.elisei@arm.com>
 <f7d73dc3-aa4a-4c32-aabb-21a61a2f773f@linaro.org>
 <aWTa76KXpIwzPh4k@raptor>
 <adacaff6-c6c7-47a5-993a-29f006fe1b86@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adacaff6-c6c7-47a5-993a-29f006fe1b86@linaro.org>

Hi James,

On Mon, Jan 12, 2026 at 11:54:05AM +0000, James Clark wrote:
> 
> 
> On 12/01/2026 11:28 am, Alexandru Elisei wrote:
> > Hi James,
> > 
> > On Fri, Jan 09, 2026 at 04:29:37PM +0000, James Clark wrote:
> > > 
> > > 
> > > On 14/11/2025 4:07 pm, Alexandru Elisei wrote:
> > > > PMBIDR_EL1 and PMSIDR_EL1 are read-only registers that describe the SPE
> > > > implementation. Trap reads to allow KVM to control how SPE is described to
> > > > a virtual machine. In particular, this is needed to:
> > > > 
> > > > - Advertise the maximum buffer size set by userspace in
> > > >     PMBIDR_EL1.MaxBuffSize.
> > > > - Hide in PMSIDR_EL1, if necessary, the presence of FEAT_SPE_FDS and
> > > >     FEAT_SPE_FnE, both of which add new registers which are already
> > > >     trapped via the FGU mechanism.
> > > > 
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > ---
> > > >    arch/arm64/include/asm/kvm_spe.h |  4 +-
> > > >    arch/arm64/kvm/config.c          | 13 ++++-
> > > >    arch/arm64/kvm/spe.c             | 82 +++++++++++++++++++++++++++++++-
> > > >    arch/arm64/kvm/sys_regs.c        | 13 +++--
> > > >    4 files changed, 103 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> > > > index 3506d8c4c661..47b94794cc5f 100644
> > > > --- a/arch/arm64/include/asm/kvm_spe.h
> > > > +++ b/arch/arm64/include/asm/kvm_spe.h
> > > > @@ -40,7 +40,7 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> > > >    int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> > > >    bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
> > > > -u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
> > > > +u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding);
> > > >    #else
> > > >    struct kvm_spe {
> > > >    };
> > > > @@ -78,7 +78,7 @@ static inline bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
> > > >    {
> > > >    	return true;
> > > >    }
> > > > -static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
> > > > +static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding)
> > > >    {
> > > >    	return 0;
> > > >    }
> > > > diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> > > > index 24bb3f36e9d5..ed6b167b7aa8 100644
> > > > --- a/arch/arm64/kvm/config.c
> > > > +++ b/arch/arm64/kvm/config.c
> > > > @@ -6,6 +6,7 @@
> > > >    #include <linux/kvm_host.h>
> > > >    #include <asm/kvm_emulate.h>
> > > > +#include <asm/kvm_spe.h>
> > > >    #include <asm/kvm_nested.h>
> > > >    #include <asm/sysreg.h>
> > > > @@ -1489,6 +1490,16 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
> > > >    		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
> > > >    }
> > > > +static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	__compute_fgt(vcpu, HDFGRTR_EL2);
> > > > +
> > > > +	if (vcpu_has_spe(vcpu)) {
> > > > +		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= HDFGRTR_EL2_PMBIDR_EL1;
> > > > +		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= HDFGRTR_EL2_PMSIDR_EL1;
> > > > +	}
> > > > +}
> > > > +
> > > >    static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
> > > >    {
> > > >    	__compute_fgt(vcpu, HDFGWTR_EL2);
> > > > @@ -1505,7 +1516,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
> > > >    	__compute_fgt(vcpu, HFGRTR_EL2);
> > > >    	__compute_hfgwtr(vcpu);
> > > >    	__compute_fgt(vcpu, HFGITR_EL2);
> > > > -	__compute_fgt(vcpu, HDFGRTR_EL2);
> > > > +	__compute_hdfgrtr(vcpu);
> > > >    	__compute_hdfgwtr(vcpu);
> > > >    	__compute_fgt(vcpu, HAFGRTR_EL2);
> > > > diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> > > > index 5b3dc622cf82..92eb46276c71 100644
> > > > --- a/arch/arm64/kvm/spe.c
> > > > +++ b/arch/arm64/kvm/spe.c
> > > > @@ -22,10 +22,16 @@ struct arm_spu_entry {
> > > >    	struct arm_spe_pmu *arm_spu;
> > > >    };
> > > > +static u64 max_buffer_size_to_pmbidr_el1(u64 size);
> > > > +
> > > >    void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
> > > >    {
> > > >    	struct arm_spu_entry *entry;
> > > > +	/* PMBIDR_EL1 cannot be trapped without FEAT_FGT. */
> > > > +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> > > > +		return;
> > > > +
> > > 
> > > Isn't this only required if you want to report a different PMBIDR value? If
> > > the value in hardware is already what you want to give to guests then it's
> > > not strictly required. Maybe it's something we can do as an addition later
> > > to make it usable in more places.
> > 
> > The maximum buffer size is advertised in PMBIDR_EL1.
> > 
> > Thanks,
> > Alex
> > 
> 
> I know, but 0 "unlimited" is a valid value, and that's what's already in
> PMBIDR. You only need to trap if the value doesn't match what's already
> there.
> 
> You can also "probe" the maximum buffer size without this by attempting to
> set the limit pointer and looking at the buffer management error code.
> 
> The first thing I did when I went to use this was comment this out because
> my hardware doesn't support FGT. But the rest of it works fine without,
> maybe other people could benefit in the future too.

I could add a new capability for setting the maximum buffer size (or to set a
buffer size different than what the hardware advertises), enabled when FEAT_FGT
is implement by the hardware. But that means not allowing KVM SPE on Neoverse
because of erratum 3023823 [1]. So I don't think you would be able to use KVM
SPE out of the box on your hardware anyway (if I understood correctly that
you've been using a Neoverse CPU to test the series).

[1] https://developer.arm.com/documentation/SDEN-885747/34-0

Thanks,
Alex
