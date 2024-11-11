Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8462D1AA78C
	for <kvmarm@lists.linux.dev>; Mon, 11 Nov 2024 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731354372; cv=none; b=KQ5OxOzKqlyVn3qSqf9okiF/EryxRrCR8kn94uNJlXnvnjsU1jtGUZoU/mRDrGENY1l/JKpc1+FxVZCd62IXpfhHDzcrMTgmXa3UtqnrS7cP7lLgmOrMwtAnSMxkyoq81AqMsRVZ+xXSCGd4yx3AHH6qljFPZpC0Dq9UtOg78Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731354372; c=relaxed/simple;
	bh=zzsh8xbAExzpTl7RmvKZVBJwdrA4bo0aOmm8ecSZV7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewFHTMTj2AyXnDjX1aD+2mEYVB3w/fA8ZRF/Fp+rcFkJOUsl68w18vympWm6Te/H/mIB4dXqAy7ri4Db+ejzMDSQbJMKypiT5ddtasiEUuN7r2ehFAU52r9O/QtMgLFXHOmhhFHNEvKE5mcBOkwZiV0Q35wbQlXesyZDO5LKB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XstHiunX; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XstHiunX"
Date: Mon, 11 Nov 2024 19:46:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731354367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XUuDuupGQlT2PNCZA4fo4MUNDmEa7x9ZBSyXrNwdB0=;
	b=XstHiunXfX/kI93pTsClk1nInTezzpFM6T8o+mZVhjfCpTDGcFJFdHq75QEI0mFuCJD1B+
	Wwu+MleW5ke4SrQD2jrjnyPqusIvqQNX073R3YQBBEh78JVBUtOB+Ch1P21Oolv7IXVa8K
	j65VM0NX/HbCozPWZJK/Ex/ixldWUws=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	broonie@kernel.org, maz@kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, joey.gouly@arm.com, shuah@kernel.org,
	pbonzini@redhat.com
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
Message-ID: <ZzJe-ju6pleqTfS8@linux.dev>
References: <20241107094000.70705-1-eric.auger@redhat.com>
 <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com>
 <Zy0QFhFsICeNt8kF@linux.dev>
 <Zy0bcM0m-N18gAZz@google.com>
 <Zy0fPgwymCdBwLd_@linux.dev>
 <Zy0ihQlkexIWc1fq@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy0ihQlkexIWc1fq@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 07, 2024 at 12:26:45PM -0800, Sean Christopherson wrote:
> On Thu, Nov 07, 2024, Oliver Upton wrote:
> > On Thu, Nov 07, 2024 at 11:56:32AM -0800, Sean Christopherson wrote:
> > > ---
> > > From: Sean Christopherson <seanjc@google.com>
> > > Date: Thu, 7 Nov 2024 11:39:59 -0800
> > > Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
> > >  freeing VMs
> > > 
> > > When freeing a VM, don't call into KVM to manually remove each memslot,
> > > simply cleanup and free any userspace assets associated with the memory
> > > region.  KVM is ultimately responsible for ensuring kernel resources are
> > > freed when the VM is destroyed, deleting memslots one-by-one is
> > > unnecessarily slow, and unless a test is already leaking the VM fd, the
> > > VM will be destroyed when kvm_vm_release() is called.
> > > 
> > > Not deleting KVM's memslot also allows cleaning up dead VMs without having
> > > to care whether or not the to-be-freed VM is dead or alive.
> > 
> > Can you add a comment to kvm_vm_free() about why we want to avoid ioctls
> > in that helper? It'd help discourage this situation from happening again
> > in the future in the unlikely case someone wants to park an ioctl there.
> > 
> > > Reported-by: Eric Auger <eric.auger@redhat.com>
> > > Reported-by: Mark Brown <broonie@kernel.org>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > I'm assuming you want to take this, happy to grab it otherwise.
> 
> You take it.  Unless my git foo is off the rails, this is needs to go into 6.12,
> along with a fix for the vGIC test.  That, and I already sent Paolo a pull request
> for rc7; I don't want to overwork myself ;-)

Fine -- I _guess_ I'll do it then :) It'll just go in the 6.13 pull
request.

https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=next&id=5afe18dfa47daead88517b095b6e0ce012f031f8

-- 
Thanks,
Oliver
