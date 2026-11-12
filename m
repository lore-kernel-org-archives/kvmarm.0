Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794503935;
	b=qV0CL3V+dun/EAa/zRnnz/nMHCSO6foZMD4RJ7vtvd3LSN/jo1VWWIr5BYY8fh7v/Y6j
	 NGwb7r77+BqdwmN68XlZ935dzoaVZKzHe/m7EShXtUwxho8lndhiYXLhJAP2U6ACfG2t+
	 voZopATODYzDuwcfUBU+WCfcpqmwc9bKDle8rqTX4y3OwU+x3LMTJlsau/1ek9t5QbiGn
	 o9IforgerpHGBzVCRcgTBdPUJ3UeOt+A31rVPbQgGjv9pFBZpNGErz4upN/VwsHmm9Ybi
	 p8n2vYSrYo7yULg3V5VQZd+S11yX1l1CsiGaxFsuofGfX+/xSwZa8aGUdJKsGSDip0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794503935;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BlY58mh9Hw/tgSMH5z15/+c8H0ljlIKjWB31zCng0sM=;
	b=v2pkpd2nFTOXlEzUp9FfSXoxQUz34ihTXFPHYWVBpXcvPAEGZ6XM1l7ppBTBDzmokPNo
	 b1jS7yteGLWdhbXjCSaqcw/FdN/cfscgZ7qHOTmj2QQerwav0Pc2JYCJHEgZL/F9YLeo/
	 ygM6aqqXvY6qtOoX1X78ol3KV+Hs5g4Z53eb8PXgeraNCpZv9acapo0zFzjVtx4hTP75g
	 iGaBbLd9pm2IZmS3LsEpqyliN6eDEsXPozs7DMmh6OpBxUiAf1u1GbE98AjAStcWDYzua
	 evu1iXWusvHorxUQ8u7nB5ptuvVno9R6Vg1Cx/d0QIcmcsWVGgSAI4y9yJmCYLVy0rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="u/Jt9bDL";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB8CF606A32A
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 17:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB8CF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=u/Jt9bDL
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 305411516;
	Thu, 12 Nov 2026 09:18:51 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE7693F632;
	Thu, 12 Nov 2026 09:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794503934; bh=PMnroKYZu+m0u0h/6B9jMwGrR1fmbzde9UqBEKf/0sA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u/Jt9bDLrv1f6QNL1AEOhElHFgK1s4fLaLHscOU9PjRzYui4BbMl8SJka2h6VikLY
	 WJNC5gWbUoj1lZkjG+3kKbiM+UE2gl1/nt0oVpl+q+zL1RUd5J1qTihCq3E8Y5acfI
	 Rkht22WSzistnaD4kF7Nya7bqy8yDEr6UcYYWwb8=
Date: Thu, 12 Nov 2026 17:18:49 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org, catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: Re: [RFC PATCH v7 07/28] KVM: arm64: Add KVM_ARM_VCPU_SPE VCPU
 feature
Message-ID: <avX0-TDCOlQq-4iX@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-8-alexandru.elisei@arm.com>
 <atIr8IWcXcrjQ0wF@gremlin>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atIr8IWcXcrjQ0wF@gremlin>

Hi Lorenzo,

On Fri, Oct 16, 2026 at 03:23:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 03, 2026 at 05:06:02PM +0100, Alexandru Elisei wrote:
> > Add a new VCPU feature that enables SPE virtualization when set by
> > userspace. KVM_VCPU_MAX_FEATURE will be bumped and the feature will
> > become selectable by userspace once SPE support in KVM is implemented.
> 
> I guess it's also limited currently at this point in the series by
> KVM_CAP_ARM_SPE being unselectable as it stands I think?

Yes, indirectly - KVM_CAP_ARM_SPE is advertised only when
kvm_supports_spe() is true, and KVM_ARM_VCPU_SPE also depends on
kvm_supports_spe(). CONFIG_KVM_ARM_SPE=y is required, but not sufficient,
for kvm_supports_spe() to be true. So all of this depends on the Kconfig
option, maybe I should document that in the capability doc.

> 
> Maybe worth mentioning here that you're adding KVM_ARM_VPCU_SPE to the uapi,
> updating docs, etc.?

I can mention it, but the short diff should speak for itself?

> 
> >
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> I wonder if there are any dependencies that need expressing in
> arch/arm64/kvm/config.c?
> 
> In any case all LGTM, with mega-nit below addressed :):
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> > ---
> >  Documentation/virt/kvm/api.rst    | 2 ++
> >  arch/arm64/include/asm/kvm_spe.h  | 5 +++++
> >  arch/arm64/include/uapi/asm/kvm.h | 1 +
> >  arch/arm64/kvm/arm.c              | 7 +++++++
> >  4 files changed, 15 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 1ed5c389c7a4..654736fac78c 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -3591,6 +3591,8 @@ Possible features:
> >  	  Depends on KVM_CAP_ARM_EL2_E2H0.
> >  	  KVM_ARM_VCPU_HAS_EL2 must also be set.
> >
> > +        - KVM_ARM_VCPU_SPE: Enable SPE for the CPU. Depends on KVM_CAP_ARM_SPE.
> 
> Super nitty, sorry, but it seems other parts of the docs use tabs, whereas this
> uses spaces?

Fixed.

Thanks,
Alex
