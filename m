Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1C8882A
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 19:13:45 +0000 (UTC)
Date: Mon, 12 Jun 2023 21:13:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686597223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HxGQvsB7fcRIz73MLbhBAve1ENUGJm6b0AdpqTHIpqE=;
	b=BmixyGpow9WXKsKoIICxCywoB6nARvJSBuFSil9BVrJYhdu91Q1xEeah/tdb+1jAUSeLgA
	DJoR3p3DSTGXOA+gOefFf1+2ulTBBQGN6Q17ici9wHaPMcpuH6yrGJ1g1JgJUfc7Lz4s/l
	2oaw+m2SXoKHlR5EDs3BwZxhcmhGBvM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mostafa Saleh <smostafa@google.com>
Cc: Will Deacon <will@kernel.org>, maz@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, tabba@google.com,
	kaleshsingh@google.com, catalin.marinas@arm.com,
	yuzenghui@huawei.com, suzuki.poulose@arm.com, james.morse@arm.com
Subject: Re: [PATCH] KVM: arm64: Use different pointer authentication keys
 for pKVM
Message-ID: <ZIduZcSpeA5xw3Yn@linux.dev>
References: <20230516141531.791492-1-smostafa@google.com>
 <ZHEa+HAixbYijQTA@linux.dev>
 <ZHSJ38WATzgJF7SR@google.com>
 <20230608215525.GA2742@willie-the-truck>
 <ZIbjULC2p5aTZu8w@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIbjULC2p5aTZu8w@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Mostafa,

Thank you for bumping this, I didn't see Will's reply.

On Mon, Jun 12, 2023 at 09:20:16AM +0000, Mostafa Saleh wrote:
> On Thu, Jun 08, 2023 at 10:55:26PM +0100, Will Deacon wrote:
> > I appreciate the sentiment, but I think we should avoid adding additional
> > complexity here if it adds no security benefit. If nothing else, it adds
> > pointless overhead, but beyond that it gives the false illusion of a
> > security boundary.
> > 
> > Prior to deprivilege, the kernel can write to the hypervisor text, modify
> > its stage-1 page-table and change its data values. I think the pointer
> > auth keys are the least of our worries if it's compromised...

Ack -- well aware of the other issues there :) My whining as it relates
to security was more focused at the changelog than the diff of the
patch.

My tilt in terms of the functionality is more aimed at limiting the
interactions between pKVM and the host before it deprivilege. Longer
term, it'd be interesting to have pKVM capable of bootstrapping itself,
such that it can possibly be used in other contexts. So, when I saw the
patch I had questioned whether or not the dependency was strictly
necessary.

No reason to boil the ocean as part of this otherwise isolated change.

Tangent: Will you folks need random in EL2 at runtime?

> Thanks a lot Will for explaining this.
> 
> Oliver, what do you think for V2, about it including FEAT_RNG/TRNG in EL2?

The patch itself looks good to me. May I suggest something along these
lines for the changelog? I can do it myself to avoid the need for a v2:

"""
When the use of pointer authentication is enabled in the kernel it
applies to both the kernel itself as well as KVM's nVHE hypervisor. The
same keys are used for both the kernel and the nVHE hypervisor, which is
less than desirable for pKVM as the host is not trusted at runtime.

Naturally, the fix is to use a different set of keys for the hypervisor
when running in protected mode. Have the host generate a new set of keys
for the hypervisor before deprivileging the kernel. While there might be
other sources of random directly available at EL2, this keeps the
implementation simple, and the host is trusted anyways until it is
deprivileged.

Since the host and hypervisor no longer share a set of pointer
authentication keys, start context switching them on the host entry/exit
path exactly as we do for guest entry/exit. There is no need to handle
CPU migration as the nVHE code is not migratable in the first place.
"""

--
Thanks,
Oliver
