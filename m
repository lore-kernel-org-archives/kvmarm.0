Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9288A433A6
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 22:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702969; cv=none; b=lGouRYLvBHhZJz2wYE5Fc2eByr9TGx/oSp4nFVdieP09fhr24XnDgaPCtSpZE8NOjXD7puwfhIO+TBvFgvzowigJWfaE7npK8TD8vNAhXxxRrH3luR+KnOL79JVxyPvmB6BlXsS6UfayLNWUR/2fMI4bxGif/0yE6STxXof6jec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702969; c=relaxed/simple;
	bh=pHkGzG7uY0hK1agTCuiDlZZKkMXpmtSgWgjAy8SNNHY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CUPbBTtlVng5JFWQw6u+QP+cOMJYCYa2v+n8NE7Jtr3aURCFPwvW62EpQwz82mCcPmLjPtS8sTvRRppD4YFIk8GksfCbwiRl3VUkVxpH+On28FsIhVcBdYUUCUQEBxX/2Ts9rBkjM82UZlXMbBc2SVmm9hOOHRYuk8xeax2NLZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M8s7KdCZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M8s7KdCZ"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso4372361a12.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 15:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712702967; x=1713307767; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X7BDOAdXGb6PM9j/Ro0cuDsmudWi0lw4fAoXWjZNUDM=;
        b=M8s7KdCZBHaN5qwwGGq0xnEDTiv+oNHZ4ny7o5sZJh724nI4icSHWSPrKuABRMMyAg
         hVgOW8rEubzriV9B9GcVou9AFHj1M4ONIogellAuT/cBZRNpQ+5l4GqdJ3wOsC54hth7
         D6LC+LQDhg+VbxUrTFDWyJsznJisYhNOdFCLMxrvRwAKkv3H8gjS0/cd1vicTRpFh3JQ
         dB3spjxL2fOi040Tdt3sQbz2JvO7ALyD9/j1uynbvGe7tVP3OmI1URIj/1NxVZei9LJQ
         jatJ1faHjoG6Eehw330BqVPDDzamk9IOHKDDU+DdFSEZgAINlQjHMJwbYLky6w1lrwn1
         Pxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712702967; x=1713307767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7BDOAdXGb6PM9j/Ro0cuDsmudWi0lw4fAoXWjZNUDM=;
        b=bDL4hUH5Y60cs7uJmI8pcleVxipZHGu2kd4IysDNKMmWwREqRan99gPd+qp0OtyGtm
         UOZ6x492Evvq0DLvYGtmiD6We9kEnoQ7lpATTw5XmuMsp5Vy2JR6T5Zml2ebbT5YAv3I
         TM3TLDQPkXhAFvY1MQ+lJDdFgPIceIQFfUP6myE1M9WQ2OotRT3/3231K5AEsAcg8euD
         4qTpwekEmvdKBNBkxQX3jrBqS5Uiq/MpUff3BJETDCG06eDwaJkv8IMhm5NNIAntRkog
         zm4IVALoD4gponBb6bykzmWF274aN83/QB4tYDZ3sW6D+ZRBmd3AaKnIlRU465Gwe/tr
         yxVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiLV1u5NS1RUGHXTLo4EhJvs5ZklfZS1AXprRRWE/867BAgOjLIHOQUnr3lydkLMVKgcktBLSwjpouDtSU/7gyYiZLPnq1
X-Gm-Message-State: AOJu0YzsUC4AqM/2iS73G+a81BUe+dwOnRxSqU6ZSUfrqLHTa8p0aVSp
	uPn0ojbYC2rCgFljon98PnvGXaVCFsB2xkpRn0Ek9zl+1elHS80y+G5r+0SoVbDKwpJkybOlad6
	SWA==
X-Google-Smtp-Source: AGHT+IGuB80kepjVY6GU7N10vM5dzh4IgkERFfdumXmvvWAycN/WJPPjMEVepXbJZUSB39DoOq+2y2AV3HE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6c16:0:b0:5dc:4a5f:a5ee with SMTP id
 y22-20020a656c16000000b005dc4a5fa5eemr27846pgu.1.1712702966899; Tue, 09 Apr
 2024 15:49:26 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:49:25 -0700
In-Reply-To: <20240215235405.368539-11-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-11-amoorthy@google.com>
Message-ID: <ZhXF9QTBgKHVO0ay@google.com>
Subject: Re: [PATCH v7 10/14] KVM: selftests: Report per-vcpu demand paging
 rate from demand paging test
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
> Using the overall demand paging rate to measure performance can be
> slightly misleading when vCPU accesses are not overlapped. Adding more
> vCPUs will (usually) increase the overall demand paging rate even
> if performance remains constant or even degrades on a per-vcpu basis. As
> such, it makes sense to report both the total and per-vcpu paging rates.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 09c116a82a84..6dc823fa933a 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -135,6 +135,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	struct timespec ts_diff;
>  	struct kvm_vm *vm;
>  	int i;
> +	double vcpu_paging_rate;
>  
>  	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
>  				 p->src_type, p->partition_vcpu_memory_access);
> @@ -191,11 +192,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  			uffd_stop_demand_paging(uffd_descs[i]);
>  	}
>  
> -	pr_info("Total guest execution time: %ld.%.9lds\n",
> +	pr_info("Total guest execution time:\t%ld.%.9lds\n",
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
> -	pr_info("Overall demand paging rate: %f pgs/sec\n",
> -		memstress_args.vcpu_args[0].pages * nr_vcpus /
> -		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
> +
> +	vcpu_paging_rate =
> +		memstress_args.vcpu_args[0].pages
> +		/ ((double)ts_diff.tv_sec
> +			+ (double)ts_diff.tv_nsec / NSEC_PER_SEC);

*sigh*

For the umpteenth time, please follow kernel coding style.  Either

	vcpu_paging_rate = memstress_args.vcpu_args[0].pages /
			   ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC);

or

	vcpu_paging_rate = memstress_args.vcpu_args[0].pages /
			   ((double)ts_diff.tv_sec +
			    (double)ts_diff.tv_nsec / NSEC_PER_SEC);

I don't have a strong preference, so I'll go with the first one when applying.
