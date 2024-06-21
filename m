Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A1326AD5
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 06:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718951976; cv=none; b=IcOxdWWzuiV/tep949z7XslZdNY80PszS9CUh9BqYdJFDix/uHzb2thxh2d27XdXG5IZOxLdetBX368JvPyOmVUfomjM747baFpWukUD1EpvoY7+pm59qTaGh+o7lSoyj0dNbz2h9trykyKrcPShTERwbl/su1LtRY4ArrvT3Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718951976; c=relaxed/simple;
	bh=Rp2PfkHlqQlKsw+0QvH8Cch/MT+BEXRe2hgJqjgeP8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTtZXYm1VS7r2msKLzBdC45kkPLQhIfwoKRjf/Temv6J6qHyy9Tf+TeJbrcPGGxKkwECAbAQF2bnA01yP2XUR7LGJlvEBH0Ac1kR4imxiZ76av2nfuY90iooO2iPaZ5CnQGs+pKJav4eB3xE8f1wiubn69z8GCjcoY5sablGAQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uz//xHny; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uz//xHny"
X-Envelope-To: jiangkunkun@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718951970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/rGr0WknPRR6M1jYoCS1tGH+uD6OvxVso60P4Qdv+c=;
	b=uz//xHnyvplYyjijHTY6adMHi+pCmk9Jy8g9YToZ8QvYqkm6/bid8DjFvEQTGGor7bt1D0
	LakgR05jXzpmTSobKau3KnS/tn2NOa0hHf88A2d50iCpgPbon1ufY5IqWYyLXk1OwLebBw
	IVF1PIhmwHKFCmg1En29Fid8gAiUI6A=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: rdunlap@infradead.org
X-Envelope-To: eauger@redhat.com
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: wanghaibin.wang@huawei.com
X-Envelope-To: lishusen2@huawei.com
Date: Fri, 21 Jun 2024 06:39:25 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Eric Auger <eauger@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	wanghaibin.wang@huawei.com, lishusen2@huawei.com
Subject: Re: [PATCH 1/3] KVM: arm64: vgic-its: Add a data length check in
 vgic_its_save_*
Message-ID: <ZnUgHVCewM4CS09w@linux.dev>
References: <20240620130650.1279-1-jiangkunkun@huawei.com>
 <20240620130650.1279-2-jiangkunkun@huawei.com>
 <ZnSsPmfBXMGRYPmL@linux.dev>
 <50f18621-96a4-cf6e-9fc0-a4e69f77054c@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50f18621-96a4-cf6e-9fc0-a4e69f77054c@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 21, 2024 at 09:43:05AM +0800, Kunkun Jiang wrote:
> > static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
> > {
> >         struct its_collection *collection;
> >         struct kvm *kvm = its->dev->kvm;
> >         u32 target_addr, coll_id;
> >         u64 val;
> >         int ret;
> > 
> >         BUG_ON(esz > sizeof(val));
> >         ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
> It should also be modified synchronously, right?

Do you mean replacing the other BUG_ON()'s in the ITS code with the
pattern I'd recommended earlier?

That'd be great if you could do that.

> > >   	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
> > >   }
> > > @@ -2246,6 +2247,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
> > >   	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
> > >   		(dev->num_eventid_bits - 1));
> > >   	val = cpu_to_le64(val);
> > > +	BUG_ON(dte_esz > sizeof(dte_esz));
> > Did you even test this? A bit of substitution arrives at:
> > 
> > 	BUG_ON(8 > sizeof(unsigned int));
> > 
> > See the issue?
> > 
> > Please do not test these sort of untested patches on the list, it is a
> > waste of everyone's time.
> Sorry, there is a problem here. I will pay attention to it in the future.
> Thank you for your correction.

Apologies for being firm on this, but outside of RFCs the expectation is
that the author test changes before posting to the list.

In that spirit, a reproducer for the issue you observe in KVM selftests
would be great. We have some minimal support for dealing with an ITS
over there now.

-- 
Thanks,
Oliver
