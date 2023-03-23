Received: from out-42.mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D46BA54
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 17:38:44 +0000 (UTC)
Date: Thu, 23 Mar 2023 17:38:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679593122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bqk/WMqA2z3DH5fiZifdvkDhajFLkNPYqrc7SvfR2wo=;
	b=HM7P6LWhoSj1zHAI+87ceScFG2KuUx2Gpp0SVulLzrm794SyXlePoe/4irQuf8XCcyPKH+
	OqXW9C4rENUG728dPg+jHq3y5u/hFPSMRplysNLiJyramSHdB5WqzMKlxIGeW/3boDqTRx
	8Bufe3GCzm1a82c8R/p5KB02lLtCZKA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 0/3] KVM: selftests: Fixes for broken tests
Message-ID: <ZByOn79zokUpLGSs@linux.dev>
References: <20230308110948.1820163-1-ryan.roberts@arm.com>
 <4eca298b-411f-e6db-04d2-e8963a0e5d98@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eca298b-411f-e6db-04d2-e8963a0e5d98@arm.com>
X-Migadu-Flow: FLOW_OUT

Hey Ryan,

On Thu, Mar 23, 2023 at 12:56:18PM +0000, Ryan Roberts wrote:
> Hi Oliver,
> 
> Just a polite nudge on this: I was originally hoping to get these into 6.3 since
> I thought they were fairly uncontroversial and clearly fixing bugs. What are my
> chances?

Yes, your changes are indeed uncontroversial :) At least for me, fixes to
selftests take a strictly lower priority than fixes to the kernel outside of
a merge window. AFAICT, only LPA systems are affected by the changes here and
I'm not aware of any of those out in the wild.

So, unless there is a burning issue, I'd like to defer these patches to the
6.4 merge window. Nonetheless, it all looks good to me:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
