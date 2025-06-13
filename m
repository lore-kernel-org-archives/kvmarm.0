Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E936C24A069
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 20:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749848004; cv=none; b=LrDY2Qa1G619JPOuiZThMG3amGM7kt+kW9RF1U2KQOvMYepSrrLJzkJS8MPoxaN9qRGUZ9zgsIkheLY/+Y7jjSnZW/xqELwC+XUn3+80NvYa0I2liKygQWGXJENhKoqzo4V8EnAtv8i5izoeVgeBOVRqFqOa7yp8LpQr3d6B9Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749848004; c=relaxed/simple;
	bh=B5/IFja4RVVEVHRpLRymgFk1+5qawt7Y2fr5pwUM4K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRm8pOHxPLs4cxOdn6DI4Un+zY4NBudHEbmYGXA6DzQpXvF6+hf1FVAPQ7MBLMH1SR6DOM6ytnTs2QbTv2k3vQ/M0G7GGyr3mW/bgO/pnJsEPyotVY3mrKPao/6nCxbB1/G8+XSr7kt35DM2nS2/hSd+nYtbBKephbQV9Xdnb6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pVR5GWgk; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pVR5GWgk"
Date: Fri, 13 Jun 2025 13:53:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749847991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fKlTMyrwwqDx/wAU3aYigDU8KWuXM98SDm/vlqdsd+M=;
	b=pVR5GWgkNqzsvtdbkN7JjzMCt22LvsxgOGhb/+msVanV1s7cBRUoJZ6bsNyRtYMjiXXiS3
	Jq95S+FMYqTB1feRQVAKEXu5wBaWE70jcJPnTo+rKRHdUgxmCbgd5muA55kq8S8KAcj3Ev
	bzi2e9zImCp9gL0sj9glDsWQV/2sN1A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/4] KVM: arm64: Add attribute to control
 GICD_TYPER2.nASSGIcap
Message-ID: <aEyPswyvfJ2-oC3l@linux.dev>
References: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 13, 2025 at 03:52:34PM +0000, Raghavendra Rao Ananta wrote:
> A shortcoming of the GIC architecture is that there's an absolute limit on
> the number of vPEs that can be tracked by the ITS. It is possible that
> an operator is running a mix of VMs on a system, only wanting to provide
> a specific class of VMs with hardware interrupt injection support.
> 
> The series introduces KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap vGIC attribute to allow
> the userspace to control GICD_TYPER2.nASSGIcap (GICv4.1) on a per-VM basis.
> 
> v1: https://lore.kernel.org/kvmarm/20250514192159.1751538-1-rananta@google.com/
> 
> v1 -> v2: https://lore.kernel.org/all/20250531012545.709887-1-oliver.upton@linux.dev/
>  - Drop all use of GICv4 in the UAPI and KVM-internal helpers in favor
>    of nASSGIcap. This changes things around to model a guest feature,
>    not a host feature.
> 
>  - Consolidate UAPI into a single attribute and expect userspace to use
>    to read the attribute for discovery, much like we do with the ID
>    registers
> 
>  - Squash documentation together with implementation
> 
>  - Clean up maintenance IRQ attribute handling, which I ran into as part
>    of reviewing this series
> 
> v2 -> v3:
>  - Update checks in vgic-v3.c and vgic-v4.c to also include nASSGIcap (via
>    vgic_supports_direct_sgis()) that's configured by the userspace. (Oliver)
> 
> Oliver Upton (2):
>   KVM: arm64: Disambiguate support for vSGIs v. vLPIs
>   KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling

Make sure you run checkpatch next time before sending out, it should've
warned you about sending patches w/o including your SOB.

Thanks,
Oliver
