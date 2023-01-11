Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62E3209
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 17:21:25 +0000 (UTC)
Date: Wed, 11 Jan 2023 17:21:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673457677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0u88J8dfNU/RPu9uPZMrpaWbNvv2e1iTrIGnk2QU/9w=;
	b=nvB5jx+uUEkws3/iF6IjxUL148/2RzcGcXevvD09meuO4lcVvjJwtZ8midJ3jIc6OZUCXd
	b+R8/0BSh8QhWpPgM8b4I4QVqhSzNAhQsiy/tKTwF6uGyr6I3ywvMnQo3rO8WDEgIJ7wNO
	MViTeRhLbPSxrYAZC6bzIJOASbkuBCc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/5] KVM: arm64: Only return attributes from
 stage2_update_leaf_attrs()
Message-ID: <Y77wCeSYo7POSs3z@google.com>
References: <20230111000300.2034799-1-oliver.upton@linux.dev>
 <20230111000300.2034799-4-oliver.upton@linux.dev>
 <87ilhde9me.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilhde9me.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Wed, Jan 11, 2023 at 08:52:25AM +0000, Marc Zyngier wrote:
> [+ Suzuki and Zenghui who are missing from the Cc list]

Doh! Just switched over to working out of a new git tree and didn't move
over my cc-cmd. Apologies to you two.

> On Wed, 11 Jan 2023 00:02:58 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Returning a single PTE from stage2_update_leaf_attrs() doesn't make a
> > great deal of sense given that the function could be used to apply a
> > change to a range of PTEs. Instead, return a bitwise OR of attributes
> > from all the visited PTEs.
> 
> I find this amalgamation of attributes quite confusing, and I have a
> hard time attaching semantics to the resulting collection of bits.
> 
> It also means that you cannot reason about a particular attribute
> being 0 if any of the neighbour PTEs has this bit set.

Very true. What I had really wanted to do was make a walker that allows
software to check the state of specific attribute bit(s) within a range
of memory instead of returning all of them. I decided against it because
it would put more churn on other callers or require a new walker
entirely.

Anyway, I can go about that change to make this a bit easier to reason
about. Thoughts?

> > 
> > As the walker is no longer returning the full PTE, drop the check for a
> > valid PTE in kvm_age_gfn().
> 
> But then what does it mean to check for a potentially invalid PTE?
> 
> The helpers explicitly say:
> 
> /*
>  * The following only work if pte_present(). Undefined behaviour otherwise.
>  */
> #define pte_present(pte)	(!!(pte_val(pte) & (PTE_VALID | PTE_PROT_NONE)))
> #define pte_young(pte)		(!!(pte_val(pte) & PTE_AF))
> 
> and you seem to be violating this requirement.

Indeed I have. It all still works because the call returns 0 if no valid
PTE was found in the walk but that's nowhere near as obvious as what we
had before.

--
Thanks,
Oliver
