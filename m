Received: from out-48.mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B818810FD
	for <kvmarm@lists.linux.dev>; Thu,  2 Feb 2023 08:53:25 +0000 (UTC)
Date: Thu, 2 Feb 2023 09:01:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675324890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vox5D44kH5MDAFbCq9MCAQQB3B4oIlJzuk/ZpbnnsEQ=;
	b=NWQxg4fiXxnIFla94/48Hbm+7rSIhYESWNTsSlSWZOoFGH1g7WXwpFyZDzbEr0zdYOZC4d
	plQmbGlvklTtoYo/AWvlaeWG0IJzPasOUerbAKeJXrxJFRQNC/8fSqMwG03yaHsmJ4Yu4x
	TZkL00rK/mUYJDeXUvcY0UJfN5gGJuM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
	imbrenda@linux.ibm.com, marcorr@google.com,
	alexandru.elisei@arm.com, oliver.upton@linux.dev,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v4 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Message-ID: <20230202080122.2kbtmsbcu45pzr4f@orel>
References: <20230201172110.1970980-1-coltonlewis@google.com>
 <20230201172110.1970980-2-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201172110.1970980-2-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 01, 2023 at 05:21:10PM +0000, Colton Lewis wrote:
> Replace the MAX_SMP probe loop in favor of reading a number directly
> from the QEMU error message. This is equally safe as the existing code
> because the error message has had the same format as long as it has
> existed, since QEMU v2.10. The final number before the end of the
> error message line indicates the max QEMU supports.
> 
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. This problem was noticed for gicv2 tests on
> machines with a non-power-of-two number of CPUs greater than 8 because
> tests were running with MAX_SMP less than 8. As a hypothetical example,
> a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.
> 
> A previous comment explains the loop should only apply to kernels
> <=v4.3 on arm and suggests deletion when it becomes tiresome to
> maintain. However, it is always theoretically possible to test on a
> machine that has more CPUs than QEMU supports, so it makes sense to
> leave some check in place.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  scripts/runtime.bash | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f8794e9a..587ffe30 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -188,12 +188,10 @@ function run()
>  # Probe for MAX_SMP, in case it's less than the number of host cpus.
>  #
>  # This probing currently only works for ARM, as x86 bails on another
> -# error first. Also, this probing isn't necessary for any ARM hosts
> -# running kernels later than v4.3, i.e. those including ef748917b52
> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
> -# point when maintaining the while loop gets too tiresome, we can
> -# just remove it...
> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> -		|& grep -qi 'exceeds max CPUs'; do
> -	MAX_SMP=$((MAX_SMP >> 1))
> -done
> +# error first. The awk program takes the last number from the QEMU

I point this awk reference out in the last review. I also stated
we should do something else, which is not done in this version.
Go read the last review comments again.

> +# error message, which gives the allowable MAX_SMP.
> +if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> +      |& grep 'exceeds max CPUs'); then
> +	smp=${smp##*(}
> +	MAX_SMP=${smp:0:-1}
> +fi
> -- 
> 2.39.1.456.gfc5497dd1b-goog
> 
