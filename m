Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D6610E5
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 19:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738955313; cv=none; b=IA2RMUSPjrQuV8B6EH86IxSDPed3PW0lio/LQySVajNGpg7+a2Hg20ShDNHVKD2CfK07ZnCK6Hbnw7vcYV0f1Z13HZ/BiaBy6Yo5EZ7qNDYclZsXxPhA1ygqXPKmqB5u5uB1FUNiSDVrKmsJjd4iiWzEKpxfiz68iQa6v66lKi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738955313; c=relaxed/simple;
	bh=IRIdsHo2f6s+8U6OjOmHN3XuXiXtRoErFCPo7YRIvzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMzqkHgAKm/V9zeuh4qxCCV8YcJkSQ6iHc9qk3+WgY6YtyfW2AAfEXrWOR/4BN+P+48iI+D/hKa6Y0Sc/7QEK/1mw75LcFesR2VGf9yiGw9e5c2c5R+1wGVUGT6OIIG6osQOJyT2t/v4Sa/kZRR+LjgeJchq9kSDFkfa8zSKyCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SMDXcW6C; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SMDXcW6C"
Date: Fri, 7 Feb 2025 11:08:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738955303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U0hzUnHzdhCo2y6/Zd0m67AYnch7xq5CWs11SS1frqA=;
	b=SMDXcW6C8ljTR21eTp2x0+eWZlmxR3qfLrtZHahBQAHzrBnFfq/SeM0H+atDZAAsjOQz5m
	gXSxkybAbiEROU7ZuFuiPPPJcVIrzEGMDZeEwHZws+N1vazLNlfHjfMA51O7DjjTQyfAbD
	sMKNHNGEWC9UK9SMaK7BSzbXZqLU/DI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	kvmarm <kvmarm@lists.linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	christoffer.dall@arm.com, suzuki.poulose@arm.com, will@kernel.org,
	catalin.marinas@arm.com, coltonlewis@google.com, joey.gouly@arm.com,
	yuzenghui@huawei.com, darren@os.amperecomputing.com,
	vishnu@os.amperecomputing.com
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If
 timer expired
Message-ID: <Z6ZaIVtZ2k798Dn0@linux.dev>
References: <4d443db1-85b1-4071-acd5-3187deb9cb17@redhat.com>
 <2f6b2cb1-3d32-480a-9801-9b993ae74e2d@os.amperecomputing.com>
 <152d262e-641d-4bb1-9656-a13e049d62c4@redhat.com>
 <86h661wje4.wl-maz@kernel.org>
 <4a9fbdd9-ad23-44bc-8ba5-399f08068db4@redhat.com>
 <86cygpwfy0.wl-maz@kernel.org>
 <b22d5916-8b55-43bc-a256-2136d66ad25f@redhat.com>
 <86frkptzr6.wl-maz@kernel.org>
 <Z6ZMdv8jJUvYwQzT@linux.dev>
 <86bjvdtxb5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjvdtxb5.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 07, 2025 at 06:38:22PM +0000, Marc Zyngier wrote:
> On Fri, 07 Feb 2025 18:09:58 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hey,
> > 
> > On Fri, Feb 07, 2025 at 05:45:33PM +0000, Marc Zyngier wrote:
> > > I found at least one issue that could fail the migration. Before the
> > > VM starts running, we limit the feature set to the subset we actually
> > > support with NV.
> > > 
> > > By doing this, we also change the value of IDreg fields that are not
> > > writable, because they describe features that we don't support.
> > > Obviously, that fails on restore.
> > > 
> > > I need to have a think...
> > 
> > We spoke about this a while ago (and I forgot til now), but I was
> > wondering if we could use vCPU feature flags to describe NV, including
> > the selection between FEAT_E2H0 and FEAT_VHE.
> > 
> > I think this might match userspace expectations a bit more closely where
> > the state of the ID registers after init gives the actual feature set
> > supported by the VM.
> 
> I'm not sure that's enough. Let me give you an example:
> 
> My host has FEAT_XNX, described in ID_AA64MMFR1_EL1.XNX. For whatever
> reason, we don't allow this field to be written to, even out of NV
> context. This is odd, because for an EL1 VM, this field means nothing
> at all.
> 
> However, we don't yet support FEAT_XNX with NV (it requires some extra
> surgery in the S2 walker, in the S2 shadowing code and in AT).
> 
> How would you manage this field if you had a vcpu flag saying E2H0 or
> not? I don't think it helps, at least not in that particular case. It
> may help for some things, but not all.
> 
> It feels that we need to define the field limit (and what is writable
> or not) based on the NV/!NV support, and maybe E2H0/VHE as well.

I think we're both aiming in the right direction, I just didn't make my
point clear.

The ID registers we make visible to userspace after KVM_ARM_VCPU_INIT
*must* describe a feature set we will actually honor for the VM. No late
masking of features (i.e. first KVM_RUN), since it pretty much
guarantees userspace won't be able to save/restore correctly.

While we describe NV up front, we've been talking about allowing
userspace to make the E2H0 v. VHE selection through the ID registers as
well. My suggestion is that we have userspace select the flavor of NV
it wants (E2H0 v. VHE) up front and completely nuke from orbit the idea
of late feature fixups.

This would solve your example of XNX, as we'd apply NV enforcement early
and not expose the feature. Same would also hold for VHE-only features,
such as recursive NV.

Hopefully I made more sense this time around :)

-- 
Thanks,
Oliver
