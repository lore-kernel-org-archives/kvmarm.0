Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D6D41CB38
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 12:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784552303; cv=none; b=tNHvLy0d4rWxCK6Ru1KuzzGEdn4h9SauHYlbDfjD3DTC6WAy5KSgYpMgMfauA7cLfQkJFxV2I3h5stFuFchzHXyjeegXkYpd7EnVECcdVOEb0zFWLmOyStTz/4Klm1p7DvOzyy5+kql+LgJnNKHmyF+kBUgwjatY5EbgzYijSII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784552303; c=relaxed/simple;
	bh=ZqPwJpCJATgTe20c3VTfaUAxSjzvzDGaSBrLCg2jYwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=MbO97mcsqL44DoxoJAcmI39IG+S4mz2dJtnfrfkzbHwkp/VyIcNX8tqf5jTQFTumPNFUqiDhQwDaSqkss8RlLhtMZ7tgAV3+HifshT8Z8jkXRUFDuIrQ3Mz7QvrQLzC3sFBt5f8BWzNBnGUqvmRFDJmpp0Vdpac8WDmsFfZpi3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hJ0ugiQO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hJ0ugiQO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8385A2B;
	Mon, 20 Jul 2026 05:58:17 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56FCB3F99C;
	Mon, 20 Jul 2026 05:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784552301; bh=ZqPwJpCJATgTe20c3VTfaUAxSjzvzDGaSBrLCg2jYwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJ0ugiQO9nentJNGljJ4OzLltjO/3B7nfWwZAG6NQTFgaZ1zDbTIsgmgDLGDdVavX
	 FrWPiAaVBlEHM+RGdQoGZCJEZxGKtwj5PK5ppgIMGf2I7ymo4svGpYHgXT8ik/uFcK
	 VwAeILCBvAPDU3TkgoL0CJ855zNpp3sxTdgz6E3w=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware dirty tracking
Date: Mon, 20 Jul 2026 13:58:09 +0100
Message-ID: <al4bYajWE-v6wofu@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <alpIfIOFfrudBzD5@LeoBrasDK>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-4-zhengtian10@huawei.com> <aliKo7dTZzKcWHzI@kernel.org> <0943eb14-9ffb-4dbb-9219-060e97bca2a7@huawei.com> <alpIfIOFfrudBzD5@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jul 17, 2026 at 04:21:32PM +0100, Leonardo Bras wrote:
> On Fri, Jul 17, 2026 at 11:58:06AM +0800, Tian Zheng wrote:
> > 
> > On 7/16/2026 3:39 PM, Oliver Upton wrote:
> > > Hi Tian,
> > > 
> > > On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
> > > > -	if (prot & KVM_PGTABLE_PROT_W)
> > > > +	if (prot & KVM_PGTABLE_PROT_W) {
> > > >   		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > > > 
> > > > +		/*
> > > > +		 * No DEVICE filter needed here: relax_perms is only called
> > > > +		 * on FSC_PERM faults. Device pages always get full RW from
> > > > +		 * initial mapping and are never write-protected during
> > > > +		 * migration, so they never trigger a permission fault.
> > > > +		 */
> > > > +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> > > > +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > > > +	} else {
> > > > +		/*
> > > > +		 * Clear DBM on W→RO downgrade to prevent hardware from
> > > > +		 * silently upgrading RO+DBM back to W+dirty, which would
> > > > +		 * bypass KVM's write tracking and cause data corruption.
> > > > +		 */
> > > > +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > > > +	}
> > > > +
> > > This block makes it pretty evident that the DBM bit really *is* the
> > > write permission bit. I'd much rather we introduce the concept of dirty
> > > state to the page table library and migrate the abstract write
> > > permission to the DBM field, even if we don't have FEAT_HAFDBS.
> > >
> 
> Ohh, that's an amazing idea!

Thinking about that again...
If we adopt the encoding with DBM being the write-permission bit, and all 
PTEs have it since the start, how can we have lazy-splitting happening?

Only way I think of is removing both DBM and S2_S2AP_W bit from writable 
PTEs during dirty-track enable, and re-adding them during the first write 
fault. If we don't remove the DBM bit, systems with HDBSS would just dirty 
it by hardware, without causing a fault.

DBM=0 would need to happen only in the first write-protect (only on 
lazy-splitting). All other write-protecting would just clean the S2_S2AP_W 
bit, as everything is already split.  

Is that what was intended?

Thanks!
Leo
