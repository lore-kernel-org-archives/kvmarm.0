Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2B0BA28
	for <kvmarm@lists.linux.dev>; Tue, 29 Nov 2022 21:15:27 +0000 (UTC)
Date: Tue, 29 Nov 2022 21:15:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1669756525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FtYFpXu5/fa0TaYiI4P0+GO9iWhqJmCXUsHphTqwjGw=;
	b=oE86JcLcGxsicJ5+/muPqhDr7FrTiNs6WD8LcTD34Qo6fvG4ULczduWra99AnJWXD8Xtg0
	garTf7J0LX7RmBFNAhjKicG/NVDNgHM7JNlVsJIgPMT0ZyHg3SMpR3SR8h5DHbZkmS+wfD
	UYYEx/SftPydGa+lK+iguxXp2/OPh14=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4Z2aWVEnluy+d3+@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Zw/J3srTsZ57P7@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221129211521.domT0FWh7AhJfCbpFTU1LEQLuHF4vt9mfGMymwdqihE@z>

Hi Ricardo,

Thanks for having a look.

On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:

[...]

> > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > +				       &pte, NULL, 0);
> > +	if (!ret)
> > +		dsb(ishst);
> 
> At the moment, the only reason for stage2_update_leaf_attrs() to not
> update the PTE is if it's not valid:
> 
> 	if (!kvm_pte_valid(pte))
> 			return 0;
> 
> I guess you could check that as well:
> 
> +	if (!ret || kvm_pte_valid(pte))
> +		dsb(ishst);

Thanks for catching this.

Instead of pivoting on the returned PTE value, how about we return
-EAGAIN from the early return in stage2_attr_walker()? It would better
match the pattern used elsewhere in the pgtable code.

--
Thanks,
Oliver
