Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2B04680
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 21:27:10 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so9098800pjs.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 14:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=juq3eMPgW+JKi0eo3kzhK1m0U+pXdFdrfMEkd8SLEbxmI8aRCD8ZU37aRcvWuU/sh2
         26Kr9T2c3w2oWcLSO8jjVf12rThkBAczSOc+oQNnpi2wwisgfafwbULCRmqM99i+xyWI
         n7Z87GjayfFfuL0LYEuWYdchfnG8P3G6E0LJe5FuROOGLlAqjAb7fawiLvERTOmDXV3V
         jG+qfrOjX7S7ZR6A7dzfay6xy1lzp+GOumyd4oHqK8gqXfagvsDUG0grxcHM+FF776Jb
         OBYxmVkaLcQak0Pgm8HiTgv7oWnAEYS6CIuSdvrFGXUY3a3ZLDiu0gXtZ5fRssFp111c
         iRZw==
X-Gm-Message-State: ACrzQf0TKl06QmuAMAut7/beXjxuc2Upwma/rSS5fStv5B3pltJmv6z3
	Cx0LKr8yHuML/MfTEoA9x/MdIHiOBg3TVA==
X-Google-Smtp-Source: AMsMyM7sKoBkd+EySe6oS9G7uiWefGTirJ2MjX+Dl/2HH/8lz3/GH4/ihrDXbgHaNJ57gQFjt56hDg==
X-Received: by 2002:a17:90b:1a91:b0:20d:268b:eab with SMTP id ng17-20020a17090b1a9100b0020d268b0eabmr7681124pjb.177.1665782829503;
        Fri, 14 Oct 2022 14:27:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d15-20020a170903230f00b0016be834d54asm2144558plh.306.2022.10.14.14.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:27:09 -0700 (PDT)
Date: Fri, 14 Oct 2022 21:27:06 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, dmatlack@google.com,
	axelrasmussen@google.com
Subject: Re: [PATCH v9 11/14] KVM: selftests: aarch64: Add userfaultfd tests
 into page_fault_test
Message-ID: <Y0nUKhuCJHUaQukj@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-12-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-12-ricarkol@google.com>
Message-ID: <20221014212706.bTO3O_hE3HBXEXT_kI7st8XnhI8utDXlAXwlV-kFlT4@z>

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

