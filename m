Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214D4550DB1
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087093; cv=none; b=mk4ENYdIQoiV9nm6XxyJzhNodA0mgpxonAteMq32kSk8IQqr6kOBPoWTfTiF3gxc4r8ayDkPXQOHx9obs/vrCSDwmwPyRW2kuhvVJSZn5diEJpmUb+PhNS5Ac9WvRdT0fkp/h04h0X81Ha64CZtS0bvnMrRp1c1PobaiZxL033s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087093; c=relaxed/simple;
	bh=u/g5efqH+jc8ciQaTB35dBHovDc5O+i+qioI2dmQUZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=hffJ7Z7nllv1Sf/3/lCbO6bWONsXcWTxXwoS9u4AGKMiq2lo0nzHRAwZn8vVik1IsClO417HNp1BPr7OilX2wFvQx+4smj7DSQnz84iFLqSDjOqjyF6CzFL2DrvxU6bQZHu4GeYh1Wm+5Ft7wnceTX9WEJ4seQWh/lxJn8jBBaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iLCfD13P; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iLCfD13P"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA5E11595;
	Tue, 22 Sep 2026 07:24:46 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B52803F632;
	Tue, 22 Sep 2026 07:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790087090; bh=u/g5efqH+jc8ciQaTB35dBHovDc5O+i+qioI2dmQUZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLCfD13PVOi4mAY9kiqxVhYlvcUYxmV5/K11mBTxYJNdBkBNQdTERlnqGtgWdd9GR
	 HNdVis5ZmyJbt+MPbXOLv2cVPPJLT+GPgheryqKhcnbTKVgn93rHJ/cBTOwYJavPl5
	 wkQvdhN1lYbQfiQM2xpf4kMenHNu/PeCRAgABhEM=
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
Subject: Re: [PATCH 05/22] KVM: arm64: nv: Pass an access descriptor for stage-2 walks
Date: Tue, 22 Sep 2026 15:24:46 +0100
Message-ID: <arKPdReKg0XreEFp@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arGllj6E0C33cc20@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-6-oupton@kernel.org> <arFpUtyq7sphiJzw@LeoBrasDK> <arGllj6E0C33cc20@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Sep 21, 2026 at 02:45:58PM -0700, Oliver Upton wrote:
> On Mon, Sep 21, 2026 at 06:28:50PM +0100, Leonardo Bras wrote:
> > > @@ -1642,9 +1655,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> > >  		return 0;
> > >  
> > >  	/* Do the stage-2 translation */
> > > -	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
> > > +	access.type = WALK_ACCESS_AT;
> > > +	access.ia = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
> > 
> > What does this mask represent?
> 
> Keep in mind, this is pre-existing code... This mask is taking the GFN
> from the output address of stage-1 translation and using it as the input
> for stage-2.
> 
> Keep in mind nested only supports up to 48 bits of PA space.

Humm, I see.
Maybe adding a define for that bitmask would be a better idea, then, as a 
new define could make the limitation clear, and even be easier to change if 
nested gets to support more than 48 bits of PA space.

> 
> > 
> > IIUC, in general terms most of the changes are adapting the typing on 
> > kvm_walk_nested_s2() & co to make use of the new struct kvm_walk_access 
> > instead of just a PA.
> > 
> > I also see that flags & write are also added here, but not used anywhere.
> > Maybe it would  be worth moving them to the patch that makes use of them, 
> > instead leaving them here?
> 
> I can do that
> 

Awesome, thanks!
Leo
