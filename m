Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495833A83B1;
	Tue,  7 Jul 2026 06:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406171; cv=none; b=JwHCSRUgD312L3ziblx7S4HvmzBYe3Ed6UwK6CCB8EWZEfUPinfasjz0Jaq8nCnOSE4xmb154hrf5twKoQojLMkeRWtWDhhgcMlsTOfQaKYp3M5zKEkp4UwtRCMui9QMwXr4zRQwC1OB4UqhqUVBV1IFmHaeqmGNfZwvMxjB7Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406171; c=relaxed/simple;
	bh=wqFSelyxZxpxPkjTSfTq1sO9DImGxd/os/yrHD2RROM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uoUWGzba0OGAt7EOgQuy6QzkYETayH4In643CfVpNJ4h1FMithoA9M9E14+ZsOD32qQGPzZCPydlRjh8yMf4Wm4hy6DBoDGD9+HVP1VEfuzJS4F950xck5tytiV3hbaHbcXxvagbGdoB4cqZ4xoCsoshlyuaUvbTxplvo1/c5ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBMMQ+hf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBMMQ+hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74181F000E9;
	Tue,  7 Jul 2026 06:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406170;
	bh=VA6hRI3hbiq0ArbSD1G7iFQw3+knszMjw4fdTdB16GY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GBMMQ+hfSSFbdU3T0z9wE/HVRIq7VvYl/FgG0nW2om20zFQ0ctNNZYTL5j+27HVas
	 F5GdlMJv8AS0sAUCcK9epMGD40oNeghDnf2stZteCOJpQKSAf/ZMJTNPrw6H6KIY6/
	 sM1wJr2VzFLWjWMdMYMYFt6Ov+CVRZ5LKHZ3RV6eNdaVRR8vv4fRXZ/17e3AoiZezN
	 ZFFhg0qoyUHT5OFkfosUcON3pXWMm4HmEF4hhcBnhbzRIkkWcYq92u3hvsLP5/bU68
	 qzHZ5ePPZwZT/fMgQ476BsGX0SwF3vg9+A2G2FJNjpUj4XcDYs1Z5fSGHaFQCLfZdI
	 e26Q2TII9nV0Q==
Date: Mon, 6 Jul 2026 23:36:08 -0700
From: Oliver Upton <oupton@kernel.org>
To: Tangnianyao <tangnianyao@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, "guoyang (C)" <guoyang2@huawei.com>,
	"huanglingyan (A)" <huanglingyan2@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
Message-ID: <akyeWPzrMDuAGRXP@kernel.org>
References: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
 <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
 <292b5734-9005-6db0-da08-3da04628e620@huawei.com>
 <86o6gkpokm.wl-maz@kernel.org>
 <21eb51aa-443c-4d08-b4dd-3f813bbc9880@huawei.com>
 <86jyr8pkw8.wl-maz@kernel.org>
 <5685cdb9-95d8-9ead-4d24-d6ad06dd9547@huawei.com>
 <akvKvePWiu4pB47Q@J2N7QTR9R3.cambridge.arm.com>
 <7d97b19a-ef56-dea1-cd99-056e0e34a7fa@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d97b19a-ef56-dea1-cd99-056e0e34a7fa@huawei.com>

On Tue, Jul 07, 2026 at 10:41:35AM +0800, Tangnianyao wrote:
> On 7/6/2026 23:33, Mark Rutland wrote:
> > If *both* of the vCPUs set TTBRn_EL1.CnP, then surely that is
> > indistinguishable from physical CPUs:
> >
> >     PE0(core0,smt0)         PE1(core0,smt1)
> >     cpu0 va->pa0        
> >                             cpu1 flush local tlb
> >                             cpu1 modify desc to va->pa1
> >     cpu0 hit *va->pa1*
> >
> > Mark. 
> >
> > .
> >
> Thanks for the clarification.
> Stage-1 CnP determines whether Stage-1 translation entries may be shared
> across vCPUs, and the hardware is responsible for enforcing the
> architectural semantics.
> 
> Given that, why does KVM still need to guarantee that TLBs are private to
> each vCPU?
> 
> Assuming VTTBR_EL2.CnP == 1:
> If TTBRx_EL1.CnP == 1, the guest is responsible for ensuring that the
> translations referenced by TTBRx_EL1 are shareable, as required by the
> architecture.
> If TTBRx_EL1.CnP == 0, the hardware must ensure that Stage-1 translations
> are not shared, again according to the architectural definition.
> 
> The reason I'm asking is the potential performance impact. In a scenario
> where multiple vCPUs of the same VM are scheduled onto a single PE, this
> TLB flush may prevent a vCPU from reusing its previously populated
> translation entries, potentially increasing TLB misses.

The problem is you can't infer the state of the TLB based on the current
value of CnP at stage-1. CnP only applies to the current TTBR;
nothing stops the guest from using a mix of CnP=0/1 for different TTBRs.

KVM still needs to invalidate in the case that the PE retained a CnP=0
TLB entry for a different stage-1 context than the one configured at
the time of vcpu_load().

Thanks,
Oliver
