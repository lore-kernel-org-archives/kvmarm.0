Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761943A453B
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301577; cv=none; b=YChRDtswtL+7m5TS5r5QtBYaWxiSDOTKf8DQWs+cNkuJtkqULPNfwweNxvLrZievYz3dLp9RNC5Jk2bobaYzJMth7vHNZKfqmDsqOrXA34jg8D55DBTLq044Fyu8RgB7BnQumz+oc8ReLemIvym22wu+hjHHDktgQR9hPNfeU+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301577; c=relaxed/simple;
	bh=KfVCUOzlOKuQDDmZGcfEL3pjr/D3Mv2Q8Ct8bDxLoqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gk2iw9twvfss2ES03XCrEQrkSuQSToKO0khMyQHPMRYgEPNpXF30VUW9yhEmD2LF2WbvkXb0FuMu1vcQeuKEaPWOqjzmVfbG6ztBQCqJlRXWmCpI8OJUkG8mZj7w9FR4hN1I/Z0PklLbFVknCJb38cMbrDQcRa7Pe5htLMMbjVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOs8pp//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOs8pp//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3049E1F00899;
	Wed, 20 May 2026 18:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779301576;
	bh=UtBDzQiTvTUic8H2WMvD7VO/oD+0Jf4bASTEX4hnFCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KOs8pp//UUBrbRCAKAHUxFpTLwhToz+ZsQ+ABWasVNkoYZEZHrhgVSWzwuMXoAxcW
	 X2+xbVi3Ku/QeWmWBwfjaJFeXKP3couyY/Kn1yzRM4d8wY9TKG+8X+fQSWzMfF61p8
	 2jr4orvctQmcApqwgkPR5lyvlEydA0K/CZ7Ev9DtfT35kwQopsvBVEBTK54+HGJjfm
	 SDaQOg8nhMRSWnZLfWjXpL9pzwedGoQ6/4SqSMb5DFAtw9HrxIoodDlXxQUjjs6d+H
	 n3c41O4lSRmd2Dner1YC1OU0s8IbjDYXlBspsTFC5yWm+HSyLMDutEGOa5XG58m68h
	 8a32ejOCEYtrQ==
Date: Wed, 20 May 2026 11:26:14 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 0/6] KVM: arm64: Don't perform vgic-v2 lazy init on
 timer injection
Message-ID: <ag38xu7sd_TT8uzu@kernel.org>
References: <20260520100200.543845-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520100200.543845-1-maz@kernel.org>

On Wed, May 20, 2026 at 11:01:54AM +0100, Marc Zyngier wrote:
> This is the third version of this series aiming at fixing issues with
> vgic-v2 being initialised from non-preemptible context.
> 
> * From v2 [2]:
> 
>   - Remove the PMU's irq level cache which was hidding in plain sight
> 
>   - Simplify the userspace notification of interrupt level update
> 
>   - Additional comment clarification in patch #1
> 
>   - Collected RB, with thanks
> 
> * From v1 [1]:
> 
>   - Repaint kvm_timer_irq_can_fire() to kvm_timer_enabled()
> 
>   - Drop duplicate kvm_timer_update_status() call
> 
>   - Force lazy init on the irqfd slow-path for SPIs
> 
> [1] https://lore.kernel.org/r/20260417124612.2770268-1-maz@kernel.org
> [2] https://lore.kernel.org/r/20260422100210.3008156-1-maz@kernel.org
> 
> Marc Zyngier (6):
>   KVM: arm64: timer: Repaint kvm_timer_{should,irq_can}_fire() to
>     kvm_timer_{pending,enabled}()
>   KVM: arm64: Simplify userspace notification of interrupt state
>   KVM: arm64: timer: Kill the per-timer irq level cache
>   KVM: arm64: pmu: Kill the PMU interrupt level cache
>   KVM: arm64: vgic-v2: Force vgic init on injection outside the run loop
>   KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt
>     injection

s/how/now/ on the first line of the changelog in the last patch... Too
lazy to draft another mail.

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
