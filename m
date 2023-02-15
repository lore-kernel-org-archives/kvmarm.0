Received: from out-84.mta1.migadu.com (out-84.mta1.migadu.com [95.215.58.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1FB7B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 07:27:27 +0000 (UTC)
Date: Wed, 15 Feb 2023 07:27:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676446040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BBsS0LU51sudtTJzcO7HsMXZXsP2PU3wT8Kb8RSnELI=;
	b=PZo4KslmRH/7r83EpN/GbO2gvlpuJ9DA+VmoVLh7e+ItJCqVEDXj7sDam/u/QWYai5ZEhH
	wWR3OfDzdBw+IuUZqG9VhkTGibwNwebvfDKD+IWhqaRYR5EDRLi3QzORF7deLHqT16tdEr
	NyO9o1Y0R20SABIqLvZdEtTme4MnY9s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Ben Gardon <bgardon@google.com>,
	David Matlack <dmatlack@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/8] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
Message-ID: <Y+yJU2pE4IyuIwOQ@linux.dev>
References: <20230215011614.725983-1-amoorthy@google.com>
 <20230215011614.725983-2-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215011614.725983-2-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Anish,

On Wed, Feb 15, 2023 at 01:16:07AM +0000, Anish Moorthy wrote:
> Currently we're dividing tv_nsec by 1E8, not 1E9.
> 
> Reported-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index b0e1fc4de9e29..6809184ce2390 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
>  	pr_info("Overall demand paging rate: %f pgs/sec\n",
>  		memstress_args.vcpu_args[0].pages * nr_vcpus /
> -		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
> +		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 1E9));

Use NSEC_PER_SEC instead so the conversion taking place is immediately
obvious.

-- 
Thanks,
Oliver
