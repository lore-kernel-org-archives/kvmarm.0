Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD3B23404
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 11:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Jzcx+R+c6UOqzz0gVG07uUa29kOBvr3x5e8X9TFuwcA=; b=oQ8d4cw3GAx07aySlQ39lT4A8H
	prkDbHMJybq15SDspPHtVe9iiG+gfjkElttDpsY8z8UlgWtby1L64wWiDvn4LCC+WTcKHkzU2uCVU
	Il3IG6TJVbBw9F0wcsP4EFmQr1my4e2Wh0UYpw8cam+gBKhpQJY7tpxiPeVWY1yhA82CNY6Fx9I5x
	mM91gUzo12SNrcaM9a68ZIINX0H2/ZLb74OaH9RebDzycs3fze5p/lWol2AQOXOyvokCXPilqkWa5
	+nhi4EoTnMscy882WT5oR/Y5l8hR6D2t88nbMSI93A02rL9M7UpKAB5iPK226BszP0ZiYxjDrPS8Q
	i7+Eq3vg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1q4gM0-00H940-1R;
	Thu, 01 Jun 2023 11:20:28 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 34D6630031F;
	Thu,  1 Jun 2023 13:20:27 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2450C202BDCB6; Thu,  1 Jun 2023 13:20:27 +0200 (CEST)
Date: Thu, 1 Jun 2023 13:20:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Richter <tmricht@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Nathan Chancellor <nathan@kernel.org>, namhyung@kernel.org,
	eranian@google.com, acme@kernel.org, mark.rutland@arm.com,
	jolsa@kernel.org, bp@alien8.de, kan.liang@linux.intel.com,
	adrian.hunter@intel.com, maddy@linux.ibm.com, x86@kernel.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandipan.das@amd.com, ananth.narayan@amd.com,
	santosh.shukla@amd.com, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 3/4] perf/core: Remove pmu linear searching code
Message-ID: <20230601112027.GI38236@hirez.programming.kicks-ass.net>
References: <CAP-5=fWYbzmTETgqJ11y22=JaXDM0gnb4qR6KYeRGmFXw08f-Q@mail.gmail.com>
 <86jzwtdhmk.wl-maz@kernel.org>
 <CAP-5=fVW6KbUbbEfF3mEFvTfFDC5yKSjSpa+w3D55dG3CNUERw@mail.gmail.com>
 <86h6rxd3gh.wl-maz@kernel.org>
 <0075d8a9-2df4-86eb-8171-8995f59904e0@linux.ibm.com>
 <CAP-5=fXo0t+buDrmf7SyTD97gmTWGoDAO2YXWyav+_79O3MZ0w@mail.gmail.com>
 <a1f27798-0b06-7dc3-028b-038512947306@linux.ibm.com>
 <CAP-5=fVw3vSEu7yGFDnZi8c3VUFJu_XEZtY9ZcTsD7ip2imR6Q@mail.gmail.com>
 <aa2f8581-6440-87c0-1578-157719f7543e@linux.ibm.com>
 <20230601111856.GW4253@hirez.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601111856.GW4253@hirez.programming.kicks-ass.net>

On Thu, Jun 01, 2023 at 01:18:56PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 01, 2023 at 01:02:30PM +0200, Thomas Richter wrote:
> 
> > PS: I have the feeling, it gets complicated to have multiple hardware PMUs
> > per platform.
> 
> Recently someone was poking around giving the pmu device a parent, this
> would, I think, result in sysfs links, which could be used to decide
> what's what.
> 
> Core pmus would have the CPU device as their parent, while memory
> controller thingies would link to the relevant node or something.
> 
> Ofc. all that's future-work/pending.

https://lkml.kernel.org/r/20230404134225.13408-1-Jonathan.Cameron%40huawei.com

https://lkml.kernel.org/r/20230531110011.13963-2-Jonathan.Cameron%40huawei.com
