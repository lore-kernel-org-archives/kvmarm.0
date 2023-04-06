Received: from out-24.mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28357A94F
	for <kvmarm@lists.linux.dev>; Thu,  6 Apr 2023 16:24:02 +0000 (UTC)
Date: Thu, 6 Apr 2023 16:23:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680798240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zWTa+WmjvRizEenNCYTpznSZcah8zt6cqf7cKCxX7a0=;
	b=YpT2Fq4n3IHoq0NhqGWEGK0xXZgdwSqB4fNw/EmbCwH+l+E/MrrjoaME/5opFFWMdi+c+R
	ZE4p8Y5lVIJD1YkvcVRijUkT7UmIcs5v809lkhdseoQq1syH+eK2vgk7gXhKeHpyl6Zl0Z
	QMSkBoDf4Wai6xmXfI6vbezrnWtEGTE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] KVM: selftests: Fix spelling mistake
 "KVM_HYPERCAL_EXIT_SMC" -> "KVM_HYPERCALL_EXIT_SMC"
Message-ID: <ZC7yHC+FIJgE4APf@linux.dev>
References: <20230406080226.122955-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406080226.122955-1-colin.i.king@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 06, 2023 at 09:02:26AM +0100, Colin Ian King wrote:
> There is a spelling mistake in a test assert message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  tools/testing/selftests/kvm/aarch64/smccc_filter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/smccc_filter.c b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
> index 0f9db0641847..82650313451a 100644
> --- a/tools/testing/selftests/kvm/aarch64/smccc_filter.c
> +++ b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
> @@ -211,7 +211,7 @@ static void expect_call_fwd_to_user(struct kvm_vcpu *vcpu, uint32_t func_id,
>  			    "KVM_HYPERCALL_EXIT_SMC is not set");
>  	else
>  		TEST_ASSERT(!(run->hypercall.flags & KVM_HYPERCALL_EXIT_SMC),
> -			    "KVM_HYPERCAL_EXIT_SMC is set");
> +			    "KVM_HYPERCALL_EXIT_SMC is set");
>  }
>  
>  /* SMCCC calls forwarded to userspace cause KVM_EXIT_HYPERCALL exits */
> -- 
> 2.30.2
> 

-- 
Thanks,
Oliver
