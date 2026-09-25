Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC323DAAC5
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 11:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790334671; cv=none; b=OsKSTcmytokNHmLFhdhTdZIlf0oj5BhRPkCg8YKLvTTyyzhioKreIZyVPX/79Ck+rtSIc2S4aFq2yMJltRAApgGnfNk9KJwvn9qWWQLuJVpnb+OsgKTBDDkEPYBh6m2FoQVHaskWjV8cg9XspUJxvntiCzJ9Fi6WZeZduOqfC6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790334671; c=relaxed/simple;
	bh=N2l22cU6hjZdTXCeLXNN7l1bDjeGH9QaLf5hOOYj7Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=EH+TaDqrdTFcUjs2tDNEHdATDRhN315X0f3NZBQZKiMmB84/OGP+4tJeIHTWoL1HGtkO6cGV95CZMRYQL72fcryPKe38My6gbozx2golaCPdbDOkdG10eQQPFqdIn4B1IpoMMdZv/4uCJ5Rop0icO5csZco0a3U0xcMcGKqXf+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z+8uZF4N; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z+8uZF4N"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2C95169C;
	Fri, 25 Sep 2026 04:11:05 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABAF73F86F;
	Fri, 25 Sep 2026 04:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790334669; bh=N2l22cU6hjZdTXCeLXNN7l1bDjeGH9QaLf5hOOYj7Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+8uZF4Njs6kOlG5skDs8zujMWlkX2UYsp7L5ncdSVfqBpegS1TVh7+INq+PV8HtX
	 W7F26f9fyfBDw4K02tsMfcKl5pzFKtuvhjijDxMQwZ4d76H0975g+kWvYzNEoBUM4X
	 76fcwWNCaBz7EewbDOBjfBqoUkCuO+Eg3qUW6500=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 10/22] KVM: arm64: Plumb through access descriptor for stage-1
Date: Fri, 25 Sep 2026 12:10:53 +0100
Message-ID: <arZWvUXhHC6ni5u7@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arQ4hu4jKqGLM6BH@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-11-oupton@kernel.org> <arP8cIOl_SMyVRM8@LeoBrasDK> <arQ4hu4jKqGLM6BH@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 23, 2026 at 01:37:26PM -0700, Oliver Upton wrote:
> On Wed, Sep 23, 2026 at 05:21:04PM +0100, Leonardo Bras wrote:
> > > @@ -1459,12 +1461,14 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
> > >  
> > >  	va =  read_vncr_el2(vcpu);
> > >  
> > > -	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, va);
> > > +	access.type = WALK_ACCESS_NV2;
> > > +	access.ia = va;
> > > +	access.write = write_fault;
> > 
> > It's not clear on why we need the proxy var write_fault.
> 
> write_fault gets used immediately below when we fault in the PFN.
> 

Right. My point is that the write_fault gets assigned, and used only once.
Is there any reason not to use kvm_is_write_fault() directly on the 
assignment above, like below?

access.write = kvm_is_write_fault(vcpu);

> > > +
> > > +	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, &access);
> > >  	if (ret)
> > >  		return ret;
> > >  
> > > -	write_fault = kvm_is_write_fault(vcpu);
> > > -
> > >  	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> > >  	smp_rmb();
> > >  
> > > -- 
> > > 2.47.3
> > > 
> > 
> > IIUC:
> > In general terms, change some function signatures to replace va to a struct 
> > pointer that contains extra information, such as walk type and it being a 
> > write fault.
> > 
> > On top of that, there are 2 extra kvm_walk_access flags added here, and I 
> > see them being attributed, but no information on what they do different.
> > 
> > Since there are already flags being treated somewhere, maybe a patch just 
> > adding these new flags and showing what they do differently on the 
> > processing, then adding the remaining of this patch in a new one would make 
> > them easier to understan. 
> > 
> > (I still haven't read what those flags do differently in the next patches, 
> > but seems like a no-op at this point, even though it should be doing 
> > something different here. Please help me understand if I am missing some 
> > context)
> 
> As I mention in the changelog, I'm adding annotations to the stage-1
> translation fetches so later changes to the PTW can emulate the correct
> behavior based on the intent of the translation fetch. These prepatory
> patches are split off to keep the whole series digestable, assuming a
> degree of familiarity with nested.
> 

Sorry, I reread both the commit message and the cover letter, but could not 
find the information you gave above there.

In any case, from above explanantion I understand that you are using those 
flags only to annotate and a next patchset will actually make use of them. 
But wouldn't it make more sense to add them on the future patchset, where 
they should be used, then?

I mean, maybe I am not getting the whole picture, but looking into a 
patch that both adds flags and then makes use of them would make it easier 
to understand what is the proposed mechanism change.

Anyway, thanks for your patience! Talking about your patchset has been 
helping me better understand a lot of stuff.

Thanks!
Leo
