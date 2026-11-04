Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793813309;
	b=W8kMIZz7I0VGrRlXsapbQ8S7j4tudK1Tz8BjfVXGatFbHXk9nob/poHB5BcZmkRRlZnP
	 H2Bo8j3O0c/VdTxR4+QWP9nNWJW0IetqRWAD7KWGrLX+eDLdhz2TUQGf7QZ10UvoGzuhm
	 P7tFt8VsGmd/VDw8xqLwKrP1HZ1N7AQFLhN675YmXOHS3m5przvatGVMgj4SHtmtaV2IM
	 NYUHJSiL3CR6hMCpf06GyPOKk/f88uBW7NMvmKoVwfF+95AGqMkCZKMJS4KDzTPOYJhuR
	 ZaOfrsjn2yNM71J3ahvOAJYOMHe7FczpNT4nwudgrwpUkQZuK3t6qBCxRHvVrM2J0Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813309;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=MbGDQ79XOJsWbrarLy6UZgG0J7LePN3LYCTNyetHbqU=;
	b=KkK64WZp4zEwD+IfzcrGIUVENRjkAdbhhOOChZWx3R/b5W5meumDF7hQEHwXf5+vs8kg
	 VobIR9ZA+8uVaVF+xp/BVXlM9SpyZ/NR9kX4YDmJHNqIjqoEtXd1QdolUnaponpY6C97n
	 zWFLr7LgKczmnI3gr6ArSyBFkJqFVbyDbk7Lw6bAiVlNh0ZEQ8HlS5a5U5WHoHTOFzlt8
	 b3JmcTngAON+VwixV+sq8T5h/vx33V61z5XFt5nhUqsHuuf4kYiyc2Ai2sCbN/qeuWRR/
	 E1lYHn5j5X0rSWB7UE3V5kJCgQZnaqxB5GhZFnlSSwrDZPhnFwprtv2rBAeE0dwexUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cM0bNd+L;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54DA1606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 17:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54DA1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cM0bNd+L
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E82C1BB0;
	Wed,  4 Nov 2026 09:28:25 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33DEE3F673;
	Wed,  4 Nov 2026 09:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793813308; bh=1I/AQNjq3637SQ/+F9OivWZbWR+CwWp0IZ4SZGWPxhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM0bNd+LHrROBruNBdI6ytosYUdiZbbZ4c8gc4Dl2xiJQjNmIlNWIiuR1gJbpsipM
	 ilUSj4Qnm+wTXQNalZwBg8mM/ByofbMRUWEWPSWKsyskSLLpyE4tWd4+SaiYUtw7IM
	 1/ORo1dZlMiaBtYIMCftr7fWfz7IAFaRTqtHUoj8=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 18/28] KVM: arm64: nv: Emulate CMOs via writable-clean translations as NOPs
Date: Wed,  4 Nov 2026 17:28:24 +0000
Message-ID: <autrOLZWT-s4Ailc@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <autp0cVkXwvSXPGC@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-19-oupton@kernel.org> <autJUntFMhCoqZeH@LeoBrasDK> <autp0cVkXwvSXPGC@kernel.org>
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
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 09:22:25AM -0800, Oliver Upton wrote:
> On Wed, Nov 04, 2026 at 03:03:46PM +0000, Leonardo Bras wrote:
> > > +		/*
> > > +		 * Plug your nose for a moment.
> > > +		 *
> > > +		 * Writable-clean translations are shadowed using a read-only
> > > +		 * mapping so KVM can set the dirty state on the L1 descriptor
> > > +		 * before installing a writable mapping.
> > > +		 *
> > > +		 * Certain cache maintenance instructions require a write
> > > +		 * permission check but leave the translation in a writable-clean
> > > +		 * state, meaning KVM is on the hook to emulate CMOs that use a
> > > +		 * writable-clean translation.
> > > +		 *
> > > +		 * "Emulate" the CMO as a NOP, as KVM only exposes FEAT_HAFDBS
> > > +		 * when FEAT_S2FWB is present and the I-cache is coherent.
> > > +		 */
> > > +		if (kvm_vcpu_dabt_is_cm(vcpu) && trans->writable && !trans->dirty) {
> > > +			kvm_incr_pc(vcpu);
> > > +			return -EAGAIN;
> > > +		}
> > > +
> > >  		forward_fault = ((write_fault && !trans->writable) ||
> > >  				 (!write_fault && !trans->readable));
> > >  	}
> > 
> > Maybe it's just to messy or plain wrong, but could we make the descriptor 
> > WC, then run the said DC instruction, then make it RO again?
> > 
> > I mean, maybe I got it wrong, but if we can't enable HAFDBS for the 
> > nested guest, as updating a shadow PTE from WC->WD would require us to 
> > take a fault to update the PTE inside the guest hypervisor, we could have 
> > the PTE as WC without risking it to be promoted to WD by hardware.
> > 
> > I am probably missing something.
> 
> The writable-clean state is nonexistent when VTCR_EL2.HD=0 in the direct
> permission model. So we have no way to construct a translation in the
> stage-2 that satisfies our requirements.

Since other vcpus will have VTCR_EL2.HD=0, couldn't we enable it just for 
the sake of processing this CMO?

I guess it would need to either decode the instruction or single-step this 
vcpu just to make sure it does not write to the same page we just did mark 
WC.

> 
> The other way to do this would likely involve halting all vCPUs in the
> VM and attempting to single-step which has a near 100% chance of blowing
> up in our face.

Sorry, why all vCPUs?

I know for all vCPUs it would be terrible for performance, what else 
do you mean by "blowing up in our face"? 

Thanks!
Leo
