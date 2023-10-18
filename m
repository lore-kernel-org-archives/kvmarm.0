Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3944E43A98
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NIh9liS5"
Date: Wed, 18 Oct 2023 18:24:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697653455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZgmiugmq/HuBF5Zgqs1/aVDylBOTyMyklK/nxHkNZ4=;
	b=NIh9liS5bJh/WOPbD55WnlgC/C/wMZrQeknCxk9fU1J9HgF3P7ntRtml/Yf43ORrP9GqDa
	/2lsDFGE/pCnVvkNFcvsmGmTx8jCdyb67VZJMlIhtcdS47Wn0NibkCgIOfo9iHC8OWOmFY
	wKUtYOOZ8ymffr2i2K5EqJHJX9W3dWE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Virtualise PMEVTYPER<n>_EL1.{NSU,NSK}
Message-ID: <ZTAiy7Ijq2UmySyX@linux.dev>
References: <20231013052901.170138-1-oliver.upton@linux.dev>
 <20231013052901.170138-3-oliver.upton@linux.dev>
 <86o7gwm50g.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o7gwm50g.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 18, 2023 at 02:31:11PM +0100, Marc Zyngier wrote:
> On Fri, 13 Oct 2023 06:29:01 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Suzuki noticed that KVM's PMU emulation is oblivious to the NSU and NSK
> > event filter bits. On systems that have EL3 these bits modify the
> > filter behavior in non-secure EL0 and EL1, respectively. Even though the
> > kernel doesn't use these bits, it is entirely possible some other guest
> > OS does.
> 
> But what does it mean for KVM itself? We have no EL3 to speak of as
> far as a guest is concerned. And the moment we allow things like
> NSU/NSK to be set, why don't we allow M as well?

Yeah, we need to have a think about all these extra bits TBH.

KVM doesn't filter the advertised ELs in PFR0, so from the guest POV
both EL2 and EL3 could potentially be implemented by the vCPU. Based
on that I think the bits at least need to be stateful, even though KVM's
emulation will never let the guest count events in a higher EL.

My patches aren't even consistent with the above statement, as NSH gets
RES0 treatment and the NS{U,K} bits do not. So how about this:

 - If EL3 is advertised in the guest's ID registers NS{U,K}, and M can
   be set. NS{U,K} work as proposed, M is ignored in KVM emulation.

 - If EL2 is advertised in the guest's ID registers NSH can be set but
   is ignored in KVM emulation.

Thoughts?

-- 
Thanks,
Oliver
