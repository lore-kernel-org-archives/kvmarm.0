Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5555221
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 21:42:15 +0000 (UTC)
Date: Mon, 9 Jan 2023 21:42:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673300528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PpqONOelb/4WFMSICcyp4oeONFQwc1P6ct10ZznkhDM=;
	b=Q5kFqH5okr/ceLAYL9gUYXZyYyVMdF4baPjIBag9JppXXX/M1SOD9phKJ/QlgEyyDzpJPz
	wqpW1HFtQH+iIaU7OXuJ1PG+9ZQxiFHJah+80Gsq7hiq7Tbevuy/7Md87LZOScqQlZsS3O
	hWDaKwCpiXcqxbVn/At0C8Q0RBexf5w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
	reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y7yKLI2m+SL1BNgg@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-2-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109211754.67144-2-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 09, 2023 at 09:17:51PM +0000, Ricardo Koller wrote:
> PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> for overflowing at 32 or 64-bits. The consequence is that tests that check
> the counter values after overflowing should not assume that values will be
> wrapped around 32-bits: they overflow into the other half of the 64-bit
> counters on PMUv3p5.
> 
> Fix tests by correctly checking overflowing-counters against the expected
> 64-bit value.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
