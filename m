Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3480CED5
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 02:44:36 +0000 (UTC)
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-763ac8282a3so42242585a.0
        for <kvmarm@lists.linux.dev>; Mon, 19 Jun 2023 19:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687229076; x=1689821076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LfUNRUM1h2YyuDNdLgmHc3JvRKvju4SHuCqjDXIk+uc=;
        b=bC3AfGTQCUYFohvPkc4osyRXMzjjHYkDArvFOabW9zNPBUQOOq4ppfLK/JxFduK3Uz
         OrojvYYuTK/vAWl2lY4RL86o8C6W76b4g8my6f5tYxLouqz3o/F5CU1IMAroLnxaVwkm
         WnSWscZ6qcdqJK6gGwFz8JOpNfn3QqwRWrXpG73q3jA692UkiGbfjORWYzOCkp0773xE
         YK9ajY9qFP9KImfrIl+nkXEIapxJJskUzqM1GUgW6ywWpMqtKrY9sfjbgWK7zk+M7r+t
         Mj+MPzW3CL8uotm6zhD+1IbHU801DBPjN1d//kpPbSJSW383LLcki5V+Nq/UmD2o0i3m
         Hngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687229076; x=1689821076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LfUNRUM1h2YyuDNdLgmHc3JvRKvju4SHuCqjDXIk+uc=;
        b=aBtgC9i1VBDfmnFox0up7stKnOG0wFVP6cmoRfJvg9gEBPHuld0s7Z6CxJTveLkODx
         YTYzE+hq/xU62b0io/GGBthnKpqlU20Y2UntTvGMAUB/O/DxbPIZrdMgOQ8yplot6Zpo
         /6tZWP5Rblcl28bOHkCcyxk8yCk93/4OObAjPRKqKB0HD7n3QqiIZXVFVuOw6Sw1cbA2
         8EbybFkRKKug/jfJSxCJ6z3NN9OrG/uEYKX5zh3Htb2XxEO/LH3KHDazxlKWiZr9CrPN
         BhLkjeGJqs/H/1rnvScmx5ex+KDUgehd5x64wDWejhcH4tFhPXcMKK8CmcpvzAqgIAYj
         SgrA==
X-Gm-Message-State: AC+VfDzgDMMcFaKNqny/xGgZSgXXhXJ0zkbdbpdXuOFaOlJRXqwPZC4g
	/bXKeJpCEoQfSbz7tT2EUBU=
X-Google-Smtp-Source: ACHHUZ4hB8VltlKYkQ7lgdVOdmNZdYf1Ired4GhNDWRF0gJLtQ7F2RZrt3wZiREni2gqvCMujgRHYw==
X-Received: by 2002:a05:620a:1b8b:b0:760:7da5:ef2a with SMTP id dv11-20020a05620a1b8b00b007607da5ef2amr12265723qkb.36.1687229075937;
        Mon, 19 Jun 2023 19:44:35 -0700 (PDT)
Received: from [172.27.224.21] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm460364plh.97.2023.06.19.19.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 19:44:35 -0700 (PDT)
Message-ID: <7ca95d15-43c8-b9f5-a419-07bb4c27862f@gmail.com>
Date: Tue, 20 Jun 2023 10:44:29 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 16/16] KVM: selftests: Handle memory fault exits in
 demand_paging_test
Content-Language: en-US
To: Anish Moorthy <amoorthy@google.com>, seanjc@google.com,
 oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, jthoughton@google.com,
 bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
 axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
 isaku.yamahata@gmail.com
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-17-amoorthy@google.com>
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20230602161921.208564-17-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/3/2023 12:19 AM, Anish Moorthy wrote:
[...]
>   static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
>   {
>   	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
>   	int vcpu_idx = vcpu_args->vcpu_idx;
>   	struct kvm_run *run = vcpu->run;
> -	struct timespec start;
> -	struct timespec ts_diff;
> +	struct timespec last_start;
> +	struct timespec total_runtime = {};
>   	int ret;
>   
> -	clock_gettime(CLOCK_MONOTONIC, &start);
>   
> -	/* Let the guest access its memory */
> -	ret = _vcpu_run(vcpu);
> -	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
> -	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
> -		TEST_ASSERT(false,
> -			    "Invalid guest sync status: exit_reason=%s\n",
> -			    exit_reason_str(run->exit_reason));
> -	}
> +	while (true) {
> +		clock_gettime(CLOCK_MONOTONIC, &last_start);
> +		/* Let the guest access its memory */
> +		ret = _vcpu_run(vcpu);
> +		TEST_ASSERT(ret == 0
> +			    || (errno == EFAULT
> +				&& run->exit_reason == KVM_EXIT_MEMORY_FAULT),
> +			    "vcpu_run failed: %d\n", ret);
>   
> -	ts_diff = timespec_elapsed(start);
> +		total_runtime = timespec_add(total_runtime,
> +					     timespec_elapsed(last_start));
> +		if (ret != 0 && get_ucall(vcpu, NULL) != UCALL_SYNC) {
> +
> +			if (run->exit_reason == KVM_EXIT_MEMORY_FAULT) {
> +				ready_page(run->memory_fault.gpa);
> +				continue;
> +			}
> +
> +			TEST_ASSERT(false,
> +				    "Invalid guest sync status: exit_reason=%s\n",
> +				    exit_reason_str(run->exit_reason));
> +		}
> +		break;
> +	}
>   	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
> -		       ts_diff.tv_sec, ts_diff.tv_nsec);
> +			total_runtime.tv_sec, total_runtime.tv_nsec);
>   }

Can include number of #PF handled by vcpu worker in PER_VCPU_DEBUG output.

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c 
b/tools/testing/selftests/kvm/demand_paging_test.c
index 4b79c88cb22d..8841150b0e2b 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -91,7 +91,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
         struct timespec last_start;
         struct timespec total_runtime = {};
         int ret;
-
+       int pages = 0;

         while (true) {
                 clock_gettime(CLOCK_MONOTONIC, &last_start);
@@ -108,6 +108,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)

                         if (run->exit_reason == KVM_EXIT_MEMORY_FAULT) {
                                 ready_page(run->memory_fault.gpa);
+                               pages++;
                                 continue;
                         }

@@ -117,8 +118,8 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
                 }
                 break;
         }
-       PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
-                       total_runtime.tv_sec, total_runtime.tv_nsec);
+       PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds, %d page faults 
handled\n", vcpu_idx,
+                       total_runtime.tv_sec, total_runtime.tv_nsec, pages);
  }


