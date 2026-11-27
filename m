Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791745;
	b=PywJXfo3W/SOIaLOpQaZYRcWDtglYLj5NTAsULAY96tFiza1TyAGEratl+kPd4jyZlSo
	 I1fsACatlKXL/uVzWs6a7Fc0OxnFn752VcAJFwmJ39mQNkgr9UhMzrl+1u4qxr1jtE7dA
	 lMY37AWVM2CKlQQtAwH7zs9yGtWtSDcJM4ZUlaQxNVu9tSOeu7M6pYD1KwWxACYxfrcD5
	 5kqd6ZRcJfkQT8CB5oKMoXVWu8n/pzDMfYWBF1iabsk1iFvapSTKlzhU8iN1ATlCvjoho
	 /n8z4a7UkHZziwKgwZ9MpBqtpIezNC9987+E2kSrBSZ1FiVWIqw6k+umrERQDkr4DtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791745;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=y4eKG9taiB9eB/Qf2Z8j0/REU4SNPEh0gD95UBGC7uc=;
	b=JVNE2AVP9o1dk2mRZ5bErMaEXsKMKrimQzFNuCGXDpzewDvoW/bKmkZu/+GOnmPeWvNi
	 hAClQdjOEpYKGwaKb3vIVfbCeWBdXcaKisdgXrtY+tq+ctEYVYVFjfCCKwAsgXcIEIeeJ
	 feh2n7S2Rv+es/TSLAmHRhNw6GzRuW+DMlhpmBQtrzR2d6MngNzI3D92aaUCoxt5L4DSN
	 jx18yH+hRHIls5Qpd+BuIl/mZm2Q8TwP0vdOmziEZzsVAGUQ4HkxuixYU9zWSrieLfEHN
	 cuZIpLdYEJftZJjW9ivP3hYseDu2gd7E49dC1pUne7F1/c3A98C9RG/100dlOIrpWOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=uL1YJ1vk;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D3A606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 15:02:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55D3A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=uL1YJ1vk
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5BAF169E;
	Fri, 27 Nov 2026 07:02:21 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB2833F86C;
	Fri, 27 Nov 2026 07:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795791744; bh=/60+uV6MGkmJY4+B30J1nI4Z6rYXY4H1P3pCsqHWBGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uL1YJ1vkIAfsGkACGt/UNCS3ATBt/W/Wv6CgV5Ir54xLJrjZjX/hJyTaPnhdQS4wD
	 ngvmEScfqauFVKfF1WZSooj0roxgqrFW7T7kG9QGRDYTLJ8x3LWjL8GbZXGL3Rvj0d
	 NGApLgCsm5zNnhrT4b7wY3/LM3Jo4rlA2jhQL19k=
Date: Fri, 27 Nov 2026 15:02:19 +0000
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
Message-ID: <awmbe4dRgEkgqL-O@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-8-alexandru.elisei@arm.com>
 <atIr8IWcXcrjQ0wF@gremlin>
 <avX0-TDCOlQq-4iX@raptor>
 <avtEJaF27eHb_Ryd@gremlin>
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
In-Reply-To: <avtEJaF27eHb_Ryd@gremlin>

Hi Lorenzo,

On Mon, Nov 16, 2026 at 05:59:07PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 12, 2026 at 05:18:49PM +0000, Alexandru Elisei wrote:
> > Hi Lorenzo,
> >
> > On Fri, Oct 16, 2026 at 03:23:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Sep 03, 2026 at 05:06:02PM +0100, Alexandru Elisei wrote:
> > > > Add a new VCPU feature that enables SPE virtualization when set by
> > > > userspace. KVM_VCPU_MAX_FEATURE will be bumped and the feature will
> > > > become selectable by userspace once SPE support in KVM is implemented.
> > >
> > > I guess it's also limited currently at this point in the series by
> > > KVM_CAP_ARM_SPE being unselectable as it stands I think?
> >
> > Yes, indirectly - KVM_CAP_ARM_SPE is advertised only when
> > kvm_supports_spe() is true, and KVM_ARM_VCPU_SPE also depends on
> > kvm_supports_spe(). CONFIG_KVM_ARM_SPE=y is required, but not sufficient,
> > for kvm_supports_spe() to be true. So all of this depends on the Kconfig
> > option, maybe I should document that in the capability doc.
> 
> Thanks that'd be good.

I documented the dependency between KVM_CAP_ARM_SPE and CONFIG_KVM_ARM_SPE in
the previous patch, where KVM_CAP_ARM_SPE is introduced.

> 
> >
> > >
> > > Maybe worth mentioning here that you're adding KVM_ARM_VPCU_SPE to the uapi,
> > > updating docs, etc.?
> >
> > I can mention it, but the short diff should speak for itself?
> 
> I think it's worth giving the intent of your changes in the commit message, it
> doesn't have to be much like 'Export to UAPI, document' etc. etc.

Done.

Thanks,
Alex

> 
> >
> > >
> > > >
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > >
> > > I wonder if there are any dependencies that need expressing in
> > > arch/arm64/kvm/config.c?
> > >
> > > In any case all LGTM, with mega-nit below addressed :):
> > >
> > > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > >
> > > > ---
> > > >  Documentation/virt/kvm/api.rst    | 2 ++
> > > >  arch/arm64/include/asm/kvm_spe.h  | 5 +++++
> > > >  arch/arm64/include/uapi/asm/kvm.h | 1 +
> > > >  arch/arm64/kvm/arm.c              | 7 +++++++
> > > >  4 files changed, 15 insertions(+)
> > > >
> > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > index 1ed5c389c7a4..654736fac78c 100644
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -3591,6 +3591,8 @@ Possible features:
> > > >  	  Depends on KVM_CAP_ARM_EL2_E2H0.
> > > >  	  KVM_ARM_VCPU_HAS_EL2 must also be set.
> > > >
> > > > +        - KVM_ARM_VCPU_SPE: Enable SPE for the CPU. Depends on KVM_CAP_ARM_SPE.
> > >
> > > Super nitty, sorry, but it seems other parts of the docs use tabs, whereas this
> > > uses spaces?
> >
> > Fixed.
> 
> Thanks!
> 
> >
> > Thanks,
> > Alex
> 
> --
> Cheers, Lorenzo
> 
