Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1BBC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 21:27:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32C3F4B5F4;
	Fri, 14 Oct 2022 17:27:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L85799zMO2gk; Fri, 14 Oct 2022 17:27:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0867140159;
	Fri, 14 Oct 2022 17:27:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC67340B91
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:27:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nrDJaPuW2vdC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 17:27:10 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 993A94087B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:27:10 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id
 o17-20020a17090aac1100b0020d98b0c0f4so7674106pjq.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 14:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=R7qTg4rvqZImy4oSXdOm12cIKEYmtASg3XAfcAnUDcM=;
 b=l25kqs3a61DaB3+w+wPvWgbq+VuBHGQozUNEFz5hqhixj5qz64yh7XX1XVs5rquKe6
 q7c23KkvieMhgPIT+OOgNM88n2dm7rJY3G4FRhwr/nNv5Rj0Lf6PZI8nP3roPxtXaMdS
 GY+747N44GgC133eQMUHrGiBefoUnge0flfTz6nAAkC+s6tmNU+Hm3EZpwm19cGzXO+d
 fob8k5w0NREvitPeDw5KMEzDaJ089YaSaWx4VLBcY2E4+4GbhauC28MpAFhEjfnGjnCq
 bws1dIeh/bSHr5EhHNDRWYyKNcJGWWzf1+y2ugyae2FIkeB9grWmdYsr2MKh3VmOxyzo
 0zyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=R7qTg4rvqZImy4oSXdOm12cIKEYmtASg3XAfcAnUDcM=;
 b=ucQUVH8k77GLk+3kisGnYoAW9kye/aAH9F9LjiEM28Qt2Pvbz4LqGUmi0ffIpW/dg5
 UAz7sBtmMs/VKj9vTbdGGxSpHgLO52KARnivt7SrZFTrbqwNpmqQRCpQa0pBMByoFpS9
 LHk97KXAUMgrrVGfqELy+K6dOq4Yzv1efMjD3uRDfONzxBl1V8YkW29ajOb+vfKSZwyv
 6VlUY+aQlFMhO2+iN1T4rEhPxO8MacHNGmWhMrnUbqjduSbFSBs+bqzULBXqp9JeuVn6
 XyMxAhKYSFn6dRywCQxd0WDQdnKjByobKYLovjC6pZCz5tXvOF7/peA9NY1mpW72gKNm
 DPNQ==
X-Gm-Message-State: ACrzQf0uabmKBsuZ+qz7J1DntG8Bk2b6ce4Ah93afFa2r3KRRkgZUfQS
 xbnJFhYUnQPN02Wgh2Vo5FBWJw==
X-Google-Smtp-Source: AMsMyM7sKoBkd+EySe6oS9G7uiWefGTirJ2MjX+Dl/2HH/8lz3/GH4/ihrDXbgHaNJ57gQFjt56hDg==
X-Received: by 2002:a17:90b:1a91:b0:20d:268b:eab with SMTP id
 ng17-20020a17090b1a9100b0020d268b0eabmr7681124pjb.177.1665782829503; 
 Fri, 14 Oct 2022 14:27:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 d15-20020a170903230f00b0016be834d54asm2144558plh.306.2022.10.14.14.27.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 Oct 2022 14:27:09 -0700 (PDT)
Date: Fri, 14 Oct 2022 21:27:06 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v9 11/14] KVM: selftests: aarch64: Add userfaultfd tests
 into page_fault_test
Message-ID: <Y0nUKhuCJHUaQukj@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-12-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-12-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Tue, Oct 11, 2022, Ricardo Koller wrote:
>  /* Returns true to continue the test, and false if it should be skipped. */
> +static int uffd_generic_handler(int uffd_mode, int uffd,
> +		struct uffd_msg *msg, struct uffd_args *args,
> +		bool expect_write)

Align.

static int uffd_generic_handler(int uffd_mode, int uffd,
				struct uffd_msg *msg, struct uffd_args *args,
				bool expect_write)

> +static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
> +		struct uffd_desc **pt_uffd, struct uffd_desc **data_uffd)

static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
		       struct uffd_desc **pt_uffd, struct uffd_desc **data_uffd)

> +{
> +	struct test_desc *test = p->test_desc;
> +
> +	setup_uffd_args(vm_get_mem_region(vm, MEM_REGION_PT), &pt_args);
> +	setup_uffd_args(vm_get_mem_region(vm, MEM_REGION_TEST_DATA), &data_args);
> +
> +	*pt_uffd = NULL;
> +	if (test->uffd_pt_handler)
> +		*pt_uffd = uffd_setup_demand_paging(
> +				UFFDIO_REGISTER_MODE_MISSING, 0,
> +				pt_args.hva, pt_args.paging_size,
> +				test->uffd_pt_handler);
> +
> +	*data_uffd = NULL;
> +	if (test->uffd_data_handler)
> +		*data_uffd = uffd_setup_demand_paging(
> +				UFFDIO_REGISTER_MODE_MISSING, 0,
> +				data_args.hva, data_args.paging_size,
> +				test->uffd_data_handler);
> +}
> +
> +static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
> +			struct uffd_desc *data_uffd)

static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
		      struct uffd_desc *data_uffd)

> +static void reset_event_counts(void)
> +{
> +	memset(&events, 0, sizeof(events));
> +}
> +
>  /*
>   * This function either succeeds, skips the test (after setting test->skip), or
>   * fails with a TEST_FAIL that aborts all tests.
>   */
>  static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
> -			  struct test_desc *test)
> +		struct test_desc *test)

Spurious change, and it introduces bad alignment.

static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
			  struct test_desc *test)

>  {
>  	struct ucall uc;
>  
> @@ -453,6 +575,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	struct test_desc *test = p->test_desc;
>  	struct kvm_vm *vm;
>  	struct kvm_vcpu *vcpu;
> +	struct uffd_desc *pt_uffd, *data_uffd;
>  
>  	print_test_banner(mode, p);
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
