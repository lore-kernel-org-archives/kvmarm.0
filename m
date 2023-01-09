Received: from out-241.mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2956523A3
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 22:37:15 +0000 (UTC)
Date: Mon, 9 Jan 2023 21:43:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673300638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xbCLhBUzavGvG6c3ScGTHtSjvbga3hu28++gvcUxwl8=;
	b=IhklmKxUzNJ2e4QpxD/W8OMcGp0a3IW5OMC1sGupanX/e1/QFm7yotMJqNQH29goylwigJ
	39N107C5oISicBdIdMKHJL1+LSlFTQMm0hqUOrSf+7eMpZK/wwAxDZu77ts9oPbcrTniTt
	E2viycKhsStBMASDzut8GxmLOk/x4VM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
	reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 4/4] arm: pmu: Print counter values as
 hexadecimals
Message-ID: <Y7yKmr3pGnIJyxdX@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-5-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109211754.67144-5-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 09, 2023 at 09:17:54PM +0000, Ricardo Koller wrote:
> The arm/pmu test prints the value of counters as %ld.  Most tests start
> with counters around 0 or UINT_MAX, so having something like -16 instead of
> 0xffff_fff0 is not very useful.
> 
> Report counter values as hexadecimals.
> 
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
