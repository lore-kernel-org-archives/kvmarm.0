Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64007C433ED
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 10:46:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 988EC61452
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 10:45:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 988EC61452
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E841D4B3B1;
	Fri, 23 Apr 2021 06:45:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R9OkySk5AhXB; Fri, 23 Apr 2021 06:45:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC06F4B380;
	Fri, 23 Apr 2021 06:45:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 653E84B380
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 06:45:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cCkpoqIgoo7c for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Apr 2021 06:45:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 730084B2DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 06:45:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619174752;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6QtPk8mqfGCCjiJxQkyFECGv6tkF4PR5uLMRyrjcM1s=;
 b=FndYtML8xDtwLe7TVqdYXPkyvxq4KJqAmFeMSRWncNfM6u+v6H6t7d7JdpuYhBtq5fc9F0
 fmKlZu0rWe0Y9wYNEuMMCnzp5Sur5LJlikDHJGE+Z1xxk6NM26p36I5OYulyWD9Z2O9kWO
 ebkfu6HEmv9Nbf0zoSaXGpThGHvAxR8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-Af74E_xtOqqvMdnWBBAf0w-1; Fri, 23 Apr 2021 06:45:50 -0400
X-MC-Unique: Af74E_xtOqqvMdnWBBAf0w-1
Received: by mail-wm1-f71.google.com with SMTP id
 g21-20020a1c4e150000b0290125a227e5bbso6877534wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 03:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6QtPk8mqfGCCjiJxQkyFECGv6tkF4PR5uLMRyrjcM1s=;
 b=QU0UePzMVZMa7dvd6QEM8LP6gBgZO75eHTuBox3HwC3nAN9E/2Oe6AIFCEyQJYRp9E
 d4VtpMwPAjHH7uUDfBbWoScM9IxQ2sHT8/CwI8F5P1+dNUkyIx83NUhnY6KGLK/bEC6r
 eKzSjqGQoaFx2Xh3IyV6ovRHKOI+OqkgPOvVA+/HFfAkjUecyQpYbnB7kwWCrjpkRZwP
 akKkTATPNbPnd1/NQlvywoltIhWtDWmats7+8C9Rpk7gEusHTGYyooe6pxwcRqLEZftt
 RxlYIouY4yZsD5OtQb2L7DfppYJSQMvtDBUQAEMLwrWZ48IX689LGWvilnqg2Aby6Gd3
 GXPg==
X-Gm-Message-State: AOAM531qoKzIr1ct6EbuKNRe528nFR+cJLvSCmsi0S56O8J1bmOURHDK
 LZITpXBxoSGvxBEcouvs/1iD1dMwuI4Tw4Giongffp5ONGHB29CG0tVLED98urnKSqV66656+IA
 2P0sjn7njhMPaKfuusFkYFS/J
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr3909870wrd.126.1619174749100; 
 Fri, 23 Apr 2021 03:45:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiTCIXkknwotYShXVUIfCR1XjC5N9LEkvoMraN8zKz1jILoa5ubv9ZrlbWmnmcXme3CJv+uQ==
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr3909838wrd.126.1619174748828; 
 Fri, 23 Apr 2021 03:45:48 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id 66sm12106746wmb.36.2021.04.23.03.45.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Apr 2021 03:45:47 -0700 (PDT)
Date: Fri, 23 Apr 2021 12:45:45 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Use a ucall for x86 unhandled vector
 reporting
Message-ID: <20210423104545.dthezamjvogcpwbt@gator>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-4-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210423040351.1132218-4-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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


Hi Ricardo,

It may be nicer to introduce UCALL_UNHANDLED with this patch and have it
come fist in the series.

Thanks,
drew


On Thu, Apr 22, 2021 at 09:03:51PM -0700, Ricardo Koller wrote:
> x86 reports unhandled vectors using port IO at a specific port number,
> which is replicating what ucall already does for x86.  Aarch64, on the
> other hand, reports unhandled vector exceptions with a ucall using a
> recently added UCALL_UNHANDLED ucall type.
> 
> Replace the x86 unhandled vector exception handling to use ucall
> UCALL_UNHANDLED instead of port IO.
> 
> Tested: Forcing a page fault in the ./x86_64/xapic_ipi_test
> 	halter_guest_code() shows this:
> 
> 	$ ./x86_64/xapic_ipi_test
> 	...
> 	  Unexpected vectored event in guest (vector:0xe)
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h      |  2 --
>  .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++---------
>  2 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 0b30b4e15c38..379f12cbdc06 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -53,8 +53,6 @@
>  #define CPUID_PKU		(1ul << 3)
>  #define CPUID_LA57		(1ul << 16)
>  
> -#define UNEXPECTED_VECTOR_PORT 0xfff0u
> -
>  /* General Registers in 64-Bit Mode */
>  struct gpr64_regs {
>  	u64 rax;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..284d26a25cd3 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
>  
>  void kvm_exit_unexpected_vector(uint32_t value)
>  {
> -	outl(UNEXPECTED_VECTOR_PORT, value);
> +	ucall(UCALL_UNHANDLED, 1, value);
>  }
>  
>  void route_exception(struct ex_regs *regs)
> @@ -1260,16 +1260,13 @@ void vm_handle_exception(struct kvm_vm *vm, int vector,
>  
>  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
>  {
> -	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
> -		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
> -		&& vcpu_state(vm, vcpuid)->io.size == 4) {
> -		/* Grab pointer to io data */
> -		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
> -			+ vcpu_state(vm, vcpuid)->io.data_offset;
> +	struct ucall uc;
>  
> +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
> +		uint64_t vector = uc.args[0];
>  		TEST_ASSERT(false,
> -			    "Unexpected vectored event in guest (vector:0x%x)",
> -			    *data);
> +			    "Unexpected vectored event in guest (vector:0x%lx)",
> +			    vector);
>  	}
>  }
>  
> -- 
> 2.31.1.498.g6c1eba8ee3d-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
