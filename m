Received: from out-55.mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFBE23AD
	for <kvmarm@lists.linux.dev>; Sat,  1 Jul 2023 11:36:56 +0000 (UTC)
Date: Sat, 1 Jul 2023 13:36:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1688211414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YBvC6sOrm4wRWuwcqWzdggFaCdorVGVrRBynMg0oiWk=;
	b=rhh57uYrqwtoXOc2YgD3mDla4psJPn+fvpp/Elx3LRx9eU9FAwnKJ3YcMm9RXe0EYr/4dO
	WDqS+ML1qVlQO4jhmgYxwI4xMbp0uBNIYQaPvMFx1mfQbRQAWohaRt1Ys6Hlw4hwWoNxIh
	eMEPpOmhhz0Aie/lCbKR7HYzwyzh42Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	maz@kernel.org, will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com, 
	reijiw@google.com, alexandru.elisei@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 5/6] arm: pmu: Add
 pmu-mem-access-reliability test
Message-ID: <20230701-daff0cec48c2329abd7ede9f@orel>
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <20230619200401.1963751-6-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619200401.1963751-6-eric.auger@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 19, 2023 at 10:04:00PM +0200, Eric Auger wrote:
...
> @@ -1201,6 +1257,9 @@ int main(int argc, char *argv[])
>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>  		run_event_test(argv[1], test_basic_event_count, false);
>  		run_event_test(argv[1], test_basic_event_count, true);
> +	} else if (strcmp(argv[1], "pmu-mem-access-reliability") == 0) {
> +		run_event_test(argv[1], test_mem_access_reliability, false);
> +		run_event_test(argv[1], test_mem_access_reliability, true);

This breaks compilation for arm since this patch is missing the stub.
I've added it.

Thanks,
drew
