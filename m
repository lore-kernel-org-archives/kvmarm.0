Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA8626AC5;
	Tue,  7 Jul 2026 18:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783448408; cv=none; b=hCulSriXt3FgexwqVI9uphryGEol5GMOQRVTZG6NNCBz/ZtxWVf+zNtuj/+5McE8WFcyHoo12RdcgOIspXFp62L5RDjPLv392g36BfxkkEvzXJ/n3178tUiKMsacTmuurtidUVcPkSSSl4p+1TGxwRr5Da4qp6d5UnLgsFUeznQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783448408; c=relaxed/simple;
	bh=I86E8RIIAR6boEDHK81W0I51tU6/MnrPYSU5+rKgpT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CB36AO/ByDNDm2HQevYjQjOXGz6RRwbBeDWMtz6vHgXVTK778sTYFxizk6cjSl/iyngWtTlHw6Lb0cGJqOz/qZKtN+RErFCJnl5Heh2nknRzYQm+sOwwQ4UlSh3UevOYILiZ8dG/cF/2c/+EMbIkeQS4MFwsnSlth5npYaayCps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ep0suLij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ep0suLij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF961F000E9;
	Tue,  7 Jul 2026 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783448407;
	bh=AWIzIpH8a00nMIO23YrefbZEhT8NbDGs3/Ve9oenG9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ep0suLijWN3eWlVd2Fpqz+yCycdYo+MNXSN0RmNnb84pJ7Ym/zvlHhZ+yQCzN7Fln
	 mBRJ2yMJDx9RWbXnfb1dBoY+nskN7XRxrU3hfUM99tCczOI2mCyvieaC61VDUbyyml
	 1z2swx2WCvXQFjqpB3T2YArm4OfIGpw0hV9mr5reikdj4MpRhuK3BSQt/l3/RwWO9V
	 PxLSCgIAFC2hf+yYA+dBuRxho7Qh57l7zrQNFjmhlgUP7aSj597ytZycegiTG+FMuq
	 RS8diYtYN1HGOY9ZestohQsiYB9rBLFD+L8zfbiw6Zsf5p/TJoaARjDEFzGzGrAGL4
	 UaN10YmI1I4mw==
Date: Tue, 7 Jul 2026 11:20:05 -0700
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 1/7] KVM: arm64: Disallow vPMU when pPMUs do not cover
 all CPUs
Message-ID: <ak1DVUs0bgkpZh0N@kernel.org>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-1-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <akvgIWqBjAp_VA_A@kernel.org>
 <e03f17b2-a765-4912-adf6-3da26e7eeecd@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e03f17b2-a765-4912-adf6-3da26e7eeecd@rsg.ci.i.u-tokyo.ac.jp>

On Tue, Jul 07, 2026 at 08:08:03PM +0900, Akihiko Odaki wrote:
> On 2026/07/07 2:04, Oliver Upton wrote:
> > Hi,
> > 
> > On Mon, Jul 06, 2026 at 07:03:24PM +0900, Akihiko Odaki wrote:
> > > Commit ec3eb9ed6081 ("KVM: arm64: PMU: Disallow vPMU on non-uniform
> > > PMUVer") made KVM reject vPMU unless the system-wide PMUVer is usable.
> > > That covers systems where PMUv3 is absent or non-uniform, as well as
> > > systems where IMPDEF PMUv3 sysreg traps are unavailable.
> > > 
> > > However, KVM can still accept vPMU when all CPUs uniformly trap PMUv3
> > > sysregs, but the pPMUs registered with KVM only cover a subset of
> > > possible CPUs.
> > > 
> > > Reject vPMU unless the registered pPMUs cover every possible CPU.
> > > This avoids carrying support for partial pPMU coverage into the
> > > fixed-counters-only UAPI introduced later in the series.
> > 
> > Doesn't CPU hotplug screw this up? I could online a CPU that doesn't
> > have a PMU after creating the VM.>
> > I'd rather just change ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS to become a
> > system feature. That way any CPU which breaks the system-wide assumption
> > cannot be onlined.
> 
> ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS only says that IMPDEF PMUv3 sysregs are
> trapped. It does not say that KVM has a driver-backed PMU usable for PMUv3
> emulation. This patch checks that extra requirement.
> 
> I re-checked CPU hotplug. Onlining a CPU without a PMU later does not make
> an accepted VM unsafe, since the check is against cpu_possible_mask.

Sorry, I missed that this was against the possible mask.

> The problem is the reverse case on ACPI: this check can disable vPMU when a
> possible CPU is offline. DT populates supported_cpus at boot, while ACPI
> initially populates it only from online CPUs and grows it as matching CPUs
> come online.
> 
> That makes this patch too conservative. In practice, I do not expect systems
> to mix CPUs with and without a usable PMU. A better approach is probably to
> treat such a host as out of spec and add TAINT_CPU_OUT_OF_SPEC. We already
> do that for architectural PMUv3 by detecting mismatches in
> ID_AA64DFR0_EL1.PMUVer; we can do the same for
> ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS with non-standard PMUs.

The presence of the workaround is, by definition, out of spec. I just
never bothered tainting the kernel because these machines are already
TAINT_CPU_OUT_OF_SPEC by way of the broken VGIC.

Ok, so how about you keep the check that you're doing here and promote
IMPDEF_TRAPS to a system-wide feature? That would satisfy the two
preconditions we have for PMU emulation, which is system register traps
and a backing arm_pmu that understands PMUv3 events.

Thanks,
Oliver
