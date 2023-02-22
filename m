Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B03E3239
	for <kvmarm@lists.linux.dev>; Wed, 22 Feb 2023 20:42:43 +0000 (UTC)
Date: Wed, 22 Feb 2023 20:42:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1677098561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kD+XppnfLP0E2iO1C7ruilUpekZwlEOlQK4WHR1kf+Q=;
	b=W9gFc4CfCTYwQDXk138UV69Yq2TsLPPEsIqcKsb6iicowcIbtY+j4q2Fb7ivGZZRFtDfGT
	Tt8eko0kRCo1vi6aKPEhg2lfXYeBQDFtwZxGwH/VfKpgCVFSFqFe5NoV1LDxOY+W2EbDx2
	8AzxaJpFZCTvEjznVnFpuD+3b61QGBY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	kvmarm@lists.cs.columbia.edu,
	Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm
 s2
Message-ID: <Y/Z+PfF4Dv/1hi9R@linux.dev>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <Y5pvzKYdZK79nyZw@google.com>
 <c19594a6-358b-c0de-b1f5-84de38015379@arm.com>
 <Y5tjfmJRFY2pFlr4@google.com>
 <Y6H+uXrIrQjdntA4@google.com>
 <e16ec8cd-3b00-0b64-8a44-7cf8f34c771a@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e16ec8cd-3b00-0b64-8a44-7cf8f34c771a@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Ryan,

On Mon, Feb 20, 2023 at 02:17:30PM +0000, Ryan Roberts wrote:
> Hi Oliver,
> 
> Apologies for having gone quiet on this. I came back to this work today only to
> notice that you sent the below response on the 20th Dec but it did not get
> picked up by my mail client somehow (although I'm sure it was operator error). I
> just spotted it on lore.kernel.org.

Huh, sounds like the arm mail server is not a fan of me... Alex reported
my messages arriving in spam as well. I'll let you decide what that
means about what I have to say :)

> I'm planning to post a second version soon-ish, with all your comments
> addressed. I think everything except the below is pretty clear and straight forward.

Great!

> On 20/12/2022 18:28, Oliver Upton wrote:
> > Ryan, you say that it is possible for hardware to support LPA2 for a
> > single stage of translation. Are you basing that statement on something
> > in the Arm ARM or the fact that there are two different enumerations
> > for stage-1 and stage-2?
> 
> Its based on there being 2 separate enumerations. I've dug into this with our
> architecture folks; while it is clearly possible that the HW (or L0 hyp) to
> present an ID register that says one stage supports LPA2 and the other doesn't,
> the real intention behind having the 2 fields separated out is for an L0 hyp to
> be able to limit the stage2 granule sizes that it advertises to guest
> hypervisors. There are no anticipated use cases where HW or L0 hypervisor might
> want to advertise support for LPA2 in one stage and not the other.

Yep, this is exactly what I was getting at. My impression of the stage-2
enumerations was that they solely exist for choking down the supported
granule size, I was quite surprised to see LPA2 show up in both fields
independently.

> So on that basis, it sounds to me like we should just test for LPA2 support in
> both stages and require both to be supported. That simplifies things
> significantly - I can just use a static key to globally flip between pte
> formats, and a bunch of the noisy refactoring disappears.

Whoever wants to take advantage of split support is welcome to share
their use case and upstream the patches. Otherwise, I think the simpler
approach to enlightening KVM of LPA2 reduces friction on actually
getting the initial enablement done.

-- 
Thanks,
Oliver
