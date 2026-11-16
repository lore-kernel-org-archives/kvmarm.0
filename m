Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794851984;
	b=zRpk+AlKTOaOEfw56pyYErr/3iirJvXLDVX4AbZwGGNUzZeriYQAO67z3rnP19tNXosP
	 IIuPhYjqH2wivxoumHFcR0v2l5k+oV5pVqXDaPMMVFoJqFKlvm3TjdAl4ODQ0On/ZxKj3
	 I6EsY1RUCGlgbT98GjxRUCU/myfga4sq538c+8xR0lbyqeUbvWWtoqdjdpyo/DmgAvWso
	 /flk2S+jqONU9xocuUWHP8ZZD2glVW2G2mK0VILkd6PZrsHEBJzV1abA5mo1EJasne12K
	 AlToxaJrbWnrXFopxE/YOk5p7/1rtNgXql2ytNAMDu/dX+9pqfB5VMh4Y12ba+rwMxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794851984;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Hx/zwz9ol4l1LDJ7Dd/bGQfgA1YUM37wVvRIuAH27ZI=;
	b=kGIRit5sXOWhjNQNt76Lr0yGHMqrf1yZ8Hrl0z3HOMr1CK6u51IUsBW2a7jtlxzKJ01B
	 ynigfn9T1IAb1aS6D34kzlQZ+wP3cWXAZ8zjWWJFzuept28TBH9DGg+C1JKiuLhimUCDX
	 kag7zKjC+bTYwXrvmesqHgWb1QXN8n8JCDnqi/XA29Cks+ldt1x2g/VveZ7t+Fw7lRFQe
	 ZQkexixboua6lXnlH/dNGB8bXWkkGHx4uMS/mz47M4px8yyb10HwKSYOxcurDdO49jTCe
	 2EL5rqVylpNvJPIko8rbv1Vrz97uqG7CEQE/z2KbgfV5XuLCLwhHAeu/mQ4UMFdb0Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eLJVFGak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E056606A33E;
	Mon, 16 Nov 2026 17:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eLJVFGak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9CC1F000CC;
	Mon, 16 Nov 2026 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794851984;
	bh=Hx/zwz9ol4l1LDJ7Dd/bGQfgA1YUM37wVvRIuAH27ZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eLJVFGakU4VSc4iWqh0M+dGNOpQzetPnRCEVSi6rgv/tiL8L8piS5IooI/qP9Blps
	 AhmrhJQrCmNZg383iGl7FcR5WU4AXnJzQ4OMfA5DuitD1n+DX8lqD1s5Gqv6Mf7PL1
	 OZ29uW8hHtpor9dJSN8UqUzLNIGNWY4zuQ8/1ZMdxTcoRxfoJ9dQQw5ddxBPKXAMbW
	 E9JRDKpbOLFj499hFhuVGnPiXhcRPyj0c1CaF4A+DRAHr/G1furIFGBV583s1yVDkW
	 HnXcBkFZ9Zjp2L/oooUPrmIVu0wY4S9E1M0UM5uiikYAd1W8ofp3YYjNOVOcEQbxHM
	 YES16R7BXG2IA==
Date: Mon, 16 Nov 2026 17:59:07 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 07/28] KVM: arm64: Add KVM_ARM_VCPU_SPE VCPU
 feature
Message-ID: <avtEJaF27eHb_Ryd@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-8-alexandru.elisei@arm.com>
 <atIr8IWcXcrjQ0wF@gremlin>
 <avX0-TDCOlQq-4iX@raptor>
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
In-Reply-To: <avX0-TDCOlQq-4iX@raptor>

On Thu, Nov 12, 2026 at 05:18:49PM +0000, Alexandru Elisei wrote:
> Hi Lorenzo,
>
> On Fri, Oct 16, 2026 at 03:23:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 03, 2026 at 05:06:02PM +0100, Alexandru Elisei wrote:
> > > Add a new VCPU feature that enables SPE virtualization when set by
> > > userspace. KVM_VCPU_MAX_FEATURE will be bumped and the feature will
> > > become selectable by userspace once SPE support in KVM is implemented.
> >
> > I guess it's also limited currently at this point in the series by
> > KVM_CAP_ARM_SPE being unselectable as it stands I think?
>
> Yes, indirectly - KVM_CAP_ARM_SPE is advertised only when
> kvm_supports_spe() is true, and KVM_ARM_VCPU_SPE also depends on
> kvm_supports_spe(). CONFIG_KVM_ARM_SPE=y is required, but not sufficient,
> for kvm_supports_spe() to be true. So all of this depends on the Kconfig
> option, maybe I should document that in the capability doc.

Thanks that'd be good.

>
> >
> > Maybe worth mentioning here that you're adding KVM_ARM_VPCU_SPE to the uapi,
> > updating docs, etc.?
>
> I can mention it, but the short diff should speak for itself?

I think it's worth giving the intent of your changes in the commit message, it
doesn't have to be much like 'Export to UAPI, document' etc. etc.

>
> >
> > >
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > I wonder if there are any dependencies that need expressing in
> > arch/arm64/kvm/config.c?
> >
> > In any case all LGTM, with mega-nit below addressed :):
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > > ---
> > >  Documentation/virt/kvm/api.rst    | 2 ++
> > >  arch/arm64/include/asm/kvm_spe.h  | 5 +++++
> > >  arch/arm64/include/uapi/asm/kvm.h | 1 +
> > >  arch/arm64/kvm/arm.c              | 7 +++++++
> > >  4 files changed, 15 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index 1ed5c389c7a4..654736fac78c 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -3591,6 +3591,8 @@ Possible features:
> > >  	  Depends on KVM_CAP_ARM_EL2_E2H0.
> > >  	  KVM_ARM_VCPU_HAS_EL2 must also be set.
> > >
> > > +        - KVM_ARM_VCPU_SPE: Enable SPE for the CPU. Depends on KVM_CAP_ARM_SPE.
> >
> > Super nitty, sorry, but it seems other parts of the docs use tabs, whereas this
> > uses spaces?
>
> Fixed.

Thanks!

>
> Thanks,
> Alex

--
Cheers, Lorenzo
