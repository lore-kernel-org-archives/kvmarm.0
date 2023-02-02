Received: from out-123.mta1.migadu.com (out-123.mta1.migadu.com [95.215.58.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A549E7E4
	for <kvmarm@lists.linux.dev>; Thu,  2 Feb 2023 22:30:10 +0000 (UTC)
Date: Thu, 2 Feb 2023 22:08:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675375727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ri0ixrRnBJz51tqdw2dEYbyYaop8al0dLnoodDlR2Q=;
	b=YiE5pVYNpD/EFN17HMjB1tCGe2zH3724HpNQ1pxb98oSScMsEGN2zf6G36XC0nhz5QsnLL
	2uBuveADeK6w2OM1IF6H7XYv3Ch+frZnm/o+2ytPz9/JdozxmJuu0LeGiwusxrTupuW5HO
	/6f+r5Xo/gq3nz5wYkb0VbocvkWBa1Y=
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
Message-ID: <Y9w0ZYVXRgpTKuFD@google.com>
References: <20230111000300.2034799-1-oliver.upton@linux.dev>
 <20230111000300.2034799-4-oliver.upton@linux.dev>
 <87ilhde9me.wl-maz@kernel.org>
 <Y77wCeSYo7POSs3z@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y77wCeSYo7POSs3z@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 11, 2023 at 05:21:13PM +0000, Oliver Upton wrote:
> Hey Marc,
> 
> On Wed, Jan 11, 2023 at 08:52:25AM +0000, Marc Zyngier wrote:
> > [+ Suzuki and Zenghui who are missing from the Cc list]
> 
> Doh! Just switched over to working out of a new git tree and didn't move
> over my cc-cmd. Apologies to you two.
> 
> > On Wed, 11 Jan 2023 00:02:58 +0000,
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> > > 
> > > Returning a single PTE from stage2_update_leaf_attrs() doesn't make a
> > > great deal of sense given that the function could be used to apply a
> > > change to a range of PTEs. Instead, return a bitwise OR of attributes
> > > from all the visited PTEs.
> > 
> > I find this amalgamation of attributes quite confusing, and I have a
> > hard time attaching semantics to the resulting collection of bits.
> > 
> > It also means that you cannot reason about a particular attribute
> > being 0 if any of the neighbour PTEs has this bit set.
> 
> Very true. What I had really wanted to do was make a walker that allows
> software to check the state of specific attribute bit(s) within a range
> of memory instead of returning all of them. I decided against it because
> it would put more churn on other callers or require a new walker
> entirely.
> 
> Anyway, I can go about that change to make this a bit easier to reason
> about. Thoughts?

LOL, I thought I hadn't replied which is why I didn't hear anything
back. Ball is in your court, Marc, any thoughts?

--
Thanks,
Oliver
