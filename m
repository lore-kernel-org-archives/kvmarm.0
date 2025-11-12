Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C853B3054C1
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762944990; cv=none; b=CZ3sP9coH8PVDielMHVE8dLZyrfG3jtu1FzM5UCEwQygK1KUponVmdryb+1vXaFhzwjFwVfZO4uAinKUtzMkfeoKyQTK3RL16vQnE3TVsA9GYZWFuQkIGH94HtdG5NgMEeepjRbOxoSnpBZ3PkZv6BK2KC0swwgBaFrDbgDxGgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762944990; c=relaxed/simple;
	bh=ERWjSKQl5W2TyXgyIqCx3YeypOTE707h85554SgO9B8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehiMnzuk0RZ7iSi3oNxMT8GrOA0mDy1xtKQyW5Xvourb1I7Za9GT3DvAAzThKD304rSYYD7rUuf+som29AxMAnYzxFUqdDYxwc2r96dZmrs1YITkGI5QiZKh1iI3NjcVawQNd6RCjVtAwCS/TnlbsAiz5YhM99J/p9EoJc+eKlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 570D11515;
	Wed, 12 Nov 2025 02:56:20 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B71933F66E;
	Wed, 12 Nov 2025 02:56:26 -0800 (PST)
Date: Wed, 12 Nov 2025 10:56:24 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: VHE: Compute fgt traps before activating them
Message-ID: <aRRn2GuSevEplJIW@raptor>
References: <20251112102853.47759-1-alexandru.elisei@arm.com>
 <aRRkD8tAVcGp5zsY@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRRkD8tAVcGp5zsY@kernel.org>

Hi Oliver,

On Wed, Nov 12, 2025 at 02:40:15AM -0800, Oliver Upton wrote:
> Hi Alex,
> 
> On Wed, Nov 12, 2025 at 10:28:53AM +0000, Alexandru Elisei wrote:
> > On VHE, the Fine Grain Traps registers are written to hardware in
> > kvm_arch_vcpu_load()->..->__activate_traps_hfgxtr(), but the fgt array is
> > computed later, in kvm_vcpu_load_fgt(). This can lead to zero being written
> > to the FGT registers the first time a VCPU is loaded.
> 
> Yikes! This is no good, thank you for spotting it.
> 
> > Also, any changes to
> > the fgt array will be visible only after the VCPU is scheduled out, and
> > then back in, which is not the intended behaviour.
> > 
> > Fix it by computing the fgt array just before the fgt traps are written
> > to hardware.
> > 
> > Fixes: fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Reviewed-by: Oliver Upton <oupton@kernel.org>
> 
> > ---
> > 
> > Stumbled upon this when running a Linux guest on FVP with FEAT_S1PIE
> > enabled.  Linux touches PIRE0_EL1 very early during boot, in __cpu_setup().
> > HFGWTR_EL2 was 0 the first time the VCPU was run, KVM would then trap
> > the access to PIR0_EL1 (PIRE0_EL1 is an inverted trap) and trigger the
> > BUG_ON(!r->access) from perform_access().
> > 
> > I hacked __activate_traps_hfgxtr() to print the register value for
> > HFGWTR_EL2. Before this patch, during the first vcpu_load(),
> > HFGWTR_EL2 is 0, then it has the correct value. After this patch, it
> > always has the correct value.
> > 
> > If I were to venture a shot in the dark, it might be that the name is a bit
> > misleading - it's kvm_vpcu_load_fgt(), but it doesn't load anything onto
> > hardware, it just computes values. Might be worth renaming to avoid
> > similar ordering issues in the future.
> 
> Ack, naming isn't quite the best here. The idea was for the name to make
> it obvious that it is meant to be used at vcpu_load().

Actually, having a look at the load functions from kvm_arch_vcpu_load(), the
vast majority don't actually write anything to hardware, so the name is actually
in keeping with the convention, and it was just me being confused by the naming
:)

Thanks,
Alex

> 
> Thanks,
> Oliver
