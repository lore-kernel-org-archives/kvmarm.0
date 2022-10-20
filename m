Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D477E
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 08:36:06 +0000 (UTC)
Date: Thu, 20 Oct 2022 11:35:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666254959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4bFmitmS0e0DfzO3u2Vz/2OAVtqGb2XuvT7fYH4csp4=;
	b=gdBGORDykXgxNOmBPdP5jxs2zgIt7+2yLsb9L5Loojh51BmO9Bhp5sbXOZYcs2wOL5nFou
	3usATUday8HjdXJBureCI2ohWaixAFeplEUvxR9+F8baHiLfoFuegG0YhtUezyXFW61Xe+
	Sy2IkrG1hDqhkDtSUxXERJ4D86HQ/20=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 15/15] KVM: arm64: Handle stage-2 faults in parallel
Message-ID: <Y1EIar1OGgxMKzSf@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007233253.460257-1-oliver.upton@linux.dev>
 <Y1CJFLVnnbX4Ck85@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1CJFLVnnbX4Ck85@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221020083554.G0v0Eh_-bT4LvEWE-0g7dRKt0t0XHpzg7sX8W1Vv7Tc@z>

On Wed, Oct 19, 2022 at 11:32:36PM +0000, Sean Christopherson wrote:
> On Fri, Oct 07, 2022, Oliver Upton wrote:
> > @@ -1534,7 +1517,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  	 */
> >  	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
> >  			       PAGE_SIZE, __pfn_to_phys(pfn),
> > -			       KVM_PGTABLE_PROT_R, NULL);
> > +			       KVM_PGTABLE_PROT_R, NULL, KVM_PGTABLE_WALK_SHARED);
> 
> All MMU notifier events acquire mmu_lock for write when invoking arch code, i.e.
> this isn't a shared walk.

Derp, didn't intend to set the flag here. I'll fix it in v3.

--
Thanks,
Oliver
