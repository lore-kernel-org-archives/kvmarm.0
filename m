Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6917C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:40:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5FE61615E4
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5FE61615E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D56624B303;
	Tue,  5 Oct 2021 09:40:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VHtl42j-mxW3; Tue,  5 Oct 2021 09:40:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A83294B302;
	Tue,  5 Oct 2021 09:40:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E28194B302
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:40:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HHOCnHMGTVsg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:40:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 074E84B2F7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:40:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633441202;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xkZ7lrOc52SpIlQsoFwfbYAFQ2eYBcXDLzHRnbVjlKk=;
 b=XcZ4+rj2yAAOSyJlh8RlYvuPwOzds/sOj2M3yebzFbxNjYM9Fdh9eTS5QkRemdA+pfeW4s
 pTYt0tq5Gz30kXNcp9KVoHsojjIk53IrEZ+scZgS5EuZ8Bsi8eKYP8qZ++hjxdGcUUQZOz
 Gz6Rk3AQL6JsGA9g1OUGM9JJZg+aJ9s=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-qZqtAfW8OtKsWJWoVbrtqQ-1; Tue, 05 Oct 2021 09:40:01 -0400
X-MC-Unique: qZqtAfW8OtKsWJWoVbrtqQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 k10-20020a508aca000000b003dad77857f7so4756466edk.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 06:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xkZ7lrOc52SpIlQsoFwfbYAFQ2eYBcXDLzHRnbVjlKk=;
 b=nAR+xisSoCcyKbqbRFTIdK0cJPnfUtL45ndp2A1LZ2KJW2gKGVLm3RW1GREoAdLXOA
 AOxF+JPyTQie+HwU20AMKVA4c5Xz+eKqL9UuRPsKllSJ8WOihNLPQeF6wH/SWRDOEBaM
 jX7z1jcOczT8xn3XQJ0gWKYhf5ylQtusCoKrXvAGjh7PyUuxNUCVumjheAjjn78AEkhm
 aXSzSReOMzWCb001iyX8hajD/HnrIlqtdQ4ZEjeG/I5cO9V/YJGe0BMRhZozH/8ZszaU
 XWSoH0el/06FbcszMs9MaBKASR5LSuYTAwtq78gdZFW5laJBas9nvGTj2RRyZW30N92s
 bVBQ==
X-Gm-Message-State: AOAM533T+8ISH7vR4l+ZIu+yCFFX4g4iWeEE83TpS8g5G2gPKhPWcnbQ
 EAe45xj0J1NK4J57FyYtr47oF7RS2FpRCT3+knNTjyT0IT1Lowq3V0fJqlvWMFYNEKwtHrvRA6T
 5b0LNZVwVD1X1bkQCNwFNN6JD
X-Received: by 2002:a17:906:12d8:: with SMTP id
 l24mr23896110ejb.126.1633441200358; 
 Tue, 05 Oct 2021 06:40:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz39b9xeb88B+Tq2u6NemnrgpudLSmPjVmR28IuPv0hGV6cYhkyqIPK48utmKUQViIcG4HDIg==
X-Received: by 2002:a17:906:12d8:: with SMTP id
 l24mr23896080ejb.126.1633441200099; 
 Tue, 05 Oct 2021 06:40:00 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id w11sm2174150edl.87.2021.10.05.06.39.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 06:39:59 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:39:57 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 08/11] selftests: KVM: Create helper for making SMCCC
 calls
Message-ID: <20211005133957.q2a52s5mbthj6b4k@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-9-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210923191610.3814698-9-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Sep 23, 2021 at 07:16:07PM +0000, Oliver Upton wrote:
> The PSCI and PV stolen time tests both need to make SMCCC calls within
> the guest. Create a helper for making SMCCC calls and rework the
> existing tests to use the library function.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/psci_test.c | 25 ++++++-------------
>  .../selftests/kvm/include/aarch64/processor.h | 22 ++++++++++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     | 25 +++++++++++++++++++
>  tools/testing/selftests/kvm/steal_time.c      | 13 +++-------
>  4 files changed, 58 insertions(+), 27 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> index 018c269990e1..cebea7356e5a 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> @@ -26,32 +26,23 @@
>  static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
>  			    uint64_t context_id)
>  {
> -	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_CPU_ON;
> -	register uint64_t x1 asm("x1") = target_cpu;
> -	register uint64_t x2 asm("x2") = entry_addr;
> -	register uint64_t x3 asm("x3") = context_id;
> +	struct arm_smccc_res res;
>  
> -	asm("hvc #0"
> -	    : "=r"(x0)
> -	    : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
> -	    : "memory");
> +	smccc_hvc(PSCI_0_2_FN64_CPU_ON, target_cpu, entry_addr, context_id,
> +		  0, 0, 0, 0, &res);
>  
> -	return x0;
> +	return res.a0;
>  }
>  
>  static uint64_t psci_affinity_info(uint64_t target_affinity,
>  				   uint64_t lowest_affinity_level)
>  {
> -	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_AFFINITY_INFO;
> -	register uint64_t x1 asm("x1") = target_affinity;
> -	register uint64_t x2 asm("x2") = lowest_affinity_level;
> +	struct arm_smccc_res res;
>  
> -	asm("hvc #0"
> -	    : "=r"(x0)
> -	    : "r"(x0), "r"(x1), "r"(x2)
> -	    : "memory");
> +	smccc_hvc(PSCI_0_2_FN64_AFFINITY_INFO, target_affinity, lowest_affinity_level,
> +		  0, 0, 0, 0, 0, &res);
>  
> -	return x0;
> +	return res.a0;
>  }
>  
>  static void guest_main(uint64_t target_cpu)
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index c0273aefa63d..e6b7cb65d158 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -132,4 +132,26 @@ void vm_install_sync_handler(struct kvm_vm *vm,
>  
>  #define isb()	asm volatile("isb" : : : "memory")
>  
> +/**
> + * struct arm_smccc_res - Result from SMC/HVC call
> + * @a0-a3 result values from registers 0 to 3
> + */
> +struct arm_smccc_res {
> +	unsigned long a0;
> +	unsigned long a1;
> +	unsigned long a2;
> +	unsigned long a3;
> +};
> +
> +/**
> + * smccc_hvc - Invoke a SMCCC function using the hvc conduit
> + * @function_id: the SMCCC function to be called
> + * @arg0-arg6: SMCCC function arguments, corresponding to registers x1-x7
> + * @res: pointer to write the return values from registers x0-x3
> + *
> + */
> +void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> +	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
> +	       uint64_t arg6, struct arm_smccc_res *res);
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..f77430e2d688 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -426,3 +426,28 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  	assert(vector < VECTOR_NUM);
>  	handlers->exception_handlers[vector][0] = handler;
>  }
> +
> +void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> +	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
> +	       uint64_t arg6, struct arm_smccc_res *res)
> +{
> +	asm volatile("mov   w0, %w[function_id]\n"
> +		     "mov   x1, %[arg0]\n"
> +		     "mov   x2, %[arg1]\n"
> +		     "mov   x3, %[arg2]\n"
> +		     "mov   x4, %[arg3]\n"
> +		     "mov   x5, %[arg4]\n"
> +		     "mov   x6, %[arg5]\n"
> +		     "mov   x7, %[arg6]\n"
> +		     "hvc   #0\n"
> +		     "mov   %[res0], x0\n"
> +		     "mov   %[res1], x1\n"
> +		     "mov   %[res2], x2\n"
> +		     "mov   %[res3], x3\n"
> +		     : [res0] "=r"(res->a0), [res1] "=r"(res->a1),
> +		       [res2] "=r"(res->a2), [res3] "=r"(res->a3)
> +		     : [function_id] "r"(function_id), [arg0] "r"(arg0),
> +		       [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3),
> +		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> +		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> +}
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index ecec30865a74..5d52b82226c5 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -120,17 +120,10 @@ struct st_time {
>  
>  static int64_t smccc(uint32_t func, uint32_t arg)
>  {
> -	unsigned long ret;
> +	struct arm_smccc_res res;
>  
> -	asm volatile(
> -		"mov	x0, %1\n"
> -		"mov	x1, %2\n"
> -		"hvc	#0\n"
> -		"mov	%0, x0\n"
> -	: "=r" (ret) : "r" (func), "r" (arg) :
> -	  "x0", "x1", "x2", "x3");
> -
> -	return ret;
> +	smccc_hvc(func, arg, 0, 0, 0, 0, 0, 0, &res);
> +	return res.a0;
>  }
>  
>  static void check_status(struct st_time *st)
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
