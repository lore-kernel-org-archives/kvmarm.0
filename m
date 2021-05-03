Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4329C433B4
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 11:09:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60EF361244
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 11:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60EF361244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96E6D4B405;
	Mon,  3 May 2021 07:09:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id caEppBDPkBKm; Mon,  3 May 2021 07:09:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4979D4B3B3;
	Mon,  3 May 2021 07:09:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CF6A4B394
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 07:09:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q3bH6c24Dn8r for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 07:09:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BCF54B377
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 07:09:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620040154;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/TtbraNaumD0Cl9ygYI6NPc6Ttc7ibmS10zSQgMklFQ=;
 b=TFJzqRnlyyKWFttNQcqPwA9N9b4GWBBty6ZCWoIjMtxLhJzeT63IW3EUO1KBdkCMCdbmYU
 KPS++h6zVfyMx8S7cmrgzAATHRervPeKcUw+rhLtY5ZiBU0Fwv/lI2yDYFoEDw6/UaiIop
 jBsyvCCdmwDdYQ0ThbyTOnTXeoG37vA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-eEInHhwJM4ucLXBF9oRfcQ-1; Mon, 03 May 2021 07:09:12 -0400
X-MC-Unique: eEInHhwJM4ucLXBF9oRfcQ-1
Received: by mail-wr1-f72.google.com with SMTP id
 q18-20020adfc5120000b029010c2bdd72adso3726905wrf.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 May 2021 04:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/TtbraNaumD0Cl9ygYI6NPc6Ttc7ibmS10zSQgMklFQ=;
 b=JMsejsSsXN8bZzb081rG91TuY1bsJ5ksiGLuVY6Nk90Aav912k9aYQs9z6sIjvyZ7s
 72++C9q1E4y6q3ib2eIm64SYK8y933B0pi0pP5M442NKwMVxWgka4TonOHLcHSZL6S8+
 ImAeQdRrl05rL24D0VmY8Gi0CBw4WQCoi90RTRj1tAwy4oMpGfizjRjV3MnvuFxbkf4g
 Ax9pk0TEL8UE9kNjJZZ6j7J3yH3Cf6QchjQS+eQ0ScnoHE2s4jj5lMDqW/q0HujlIBAU
 hfnhIhon0QdBhOYLVs3LZS5fu9oURDNAw311ZaZzYbJmF/wEkT/eCjOREwimHdAYUmEI
 /UGQ==
X-Gm-Message-State: AOAM533n0seV3wQZWUPgGaKsW7fDJ0+mteJ9ATuZUjovI0P3SXlL2uwl
 TP3jJV1y81JjpYPoNu/VTqG4dyrfmntAD/Hg2kAwfC5CHPO9gZ4nPmH4Vy8eCZktH78xqguAj/v
 NbymMIDwGRC7xwl4KfJqp84E4
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr32346747wma.31.1620040151855; 
 Mon, 03 May 2021 04:09:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcvJLPDIMztZ/pkM3vUQ8uhHe9Kz0grAWyDXSQnMj971ADuUbBalhXfCmbcQiVMQ1hW4A5gg==
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr32346722wma.31.1620040151657; 
 Mon, 03 May 2021 04:09:11 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id g25sm4180634wmk.43.2021.05.03.04.09.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 03 May 2021 04:09:11 -0700 (PDT)
Date: Mon, 3 May 2021 13:09:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 2/5] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
Message-ID: <20210503110909.n7chjg2run6gaeq3@gator.home>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-3-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210430232408.2707420-3-ricarkol@google.com>
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

On Fri, Apr 30, 2021 at 04:24:04PM -0700, Ricardo Koller wrote:
> x86, the only arch implementing exception handling, reports unhandled
> vectors using port IO at a specific port number. This replicates what
> ucall already does.
> 
> Introduce a new ucall type, UCALL_UNHANDLED, for guests to report
> unhandled exceptions. Then replace the x86 unhandled vector exception
> reporting to use it instead of port IO.  This new ucall type will be
> used in the next commits by arm64 to report unhandled vectors as well.
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
>  tools/testing/selftests/kvm/include/kvm_util.h    |  1 +
>  .../selftests/kvm/include/x86_64/processor.h      |  2 --
>  .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++---------
>  3 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index bea4644d645d..7880929ea548 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -347,6 +347,7 @@ enum {
>  	UCALL_SYNC,
>  	UCALL_ABORT,
>  	UCALL_DONE,
> +	UCALL_UNHANDLED,
>  };
>  
>  #define UCALL_MAX_ARGS 6
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 12889d3e8948..ff4da2f95b13 100644
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
> index e156061263a6..96e2bd9d66eb 100644
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
> @@ -1260,16 +1260,13 @@ void vm_install_vector_handler(struct kvm_vm *vm, int vector,
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

nit: Could have changed this TEST_ASSERT(false, ...) to TEST_FAIL while
touching it.

>  	}
>  }
>  
> -- 
> 2.31.1.527.g47e6f16901-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
