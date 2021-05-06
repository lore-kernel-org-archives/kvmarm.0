Return-Path: <SRS0=4Pzf=KB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D775EC43460
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 12:27:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 381DD613DA
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 12:27:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 381DD613DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AADC74B6B7;
	Thu,  6 May 2021 08:27:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KkQYzAXbTVlk; Thu,  6 May 2021 08:27:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6F74B5DA;
	Thu,  6 May 2021 08:27:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 462814B5D4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 08:27:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RsPR58IUSQiF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 May 2021 08:27:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A1D84B5D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 08:27:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620304074;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xgSadxMph4w8kdj7Ae9ltL+71dKAfC6hOMn4oBADA6s=;
 b=duF880NsH6XOTjXx7o85BlP1WXPPCITnzLqN+jtZclU1xT/K2M18IRvr63CnEbZvR1uKBh
 fmto0JhqBkRGmKi6aB84MRcL2jQoiJfsOcFP2o+4yhBudZt3otV3/NMhyNlNMZKHkVQcmP
 INiVTdgltHjnMF8CLIrA0QHTtbQHShA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-5rKzy72EOz-gMj98MzJ5Pw-1; Thu, 06 May 2021 08:27:51 -0400
X-MC-Unique: 5rKzy72EOz-gMj98MzJ5Pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7578881840B;
 Thu,  6 May 2021 12:27:49 +0000 (UTC)
Received: from [10.36.113.191] (ovpn-113-191.ams2.redhat.com [10.36.113.191])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2254910023AB;
 Thu,  6 May 2021 12:27:43 +0000 (UTC)
Subject: Re: [PATCH v2 1/5] KVM: selftests: Rename vm_handle_exception
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-2-ricarkol@google.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <0e0e8341-9c4d-13e8-f037-e84f0ee291dd@redhat.com>
Date: Thu, 6 May 2021 14:27:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210430232408.2707420-2-ricarkol@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: pbonzini@redhat.com, maz@kernel.org
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

On 5/1/21 1:24 AM, Ricardo Koller wrote:
> Rename the vm_handle_exception function to a name that indicates more
> clearly that it installs something: vm_install_vector_handler.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 +-
>  tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 2 +-
>  .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 8 ++++----
>  tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 +-
>  5 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 0b30b4e15c38..12889d3e8948 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -391,7 +391,7 @@ struct ex_regs {
>  
>  void vm_init_descriptor_tables(struct kvm_vm *vm);
>  void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
> -void vm_handle_exception(struct kvm_vm *vm, int vector,
> +void vm_install_vector_handler(struct kvm_vm *vm, int vector,
>  			void (*handler)(struct ex_regs *));
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..e156061263a6 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1250,8 +1250,8 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
>  
> -void vm_handle_exception(struct kvm_vm *vm, int vector,
> -			 void (*handler)(struct ex_regs *))
> +void vm_install_vector_handler(struct kvm_vm *vm, int vector,
> +			       void (*handler)(struct ex_regs *))
>  {
>  	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> index 732b244d6956..5ae5f748723a 100644
> --- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> @@ -227,7 +227,7 @@ int main(void)
>  
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);
> -	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
> +	vm_install_vector_handler(vm, GP_VECTOR, guest_gp_handler);
>  
>  	enter_guest(vm);
>  	kvm_vm_free(vm);
> diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> index 72c0d0797522..20c373e2d329 100644
> --- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> @@ -574,7 +574,7 @@ static void test_msr_filter_allow(void) {
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);
>  
> -	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
> +	vm_install_vector_handler(vm, GP_VECTOR, guest_gp_handler);
>  
>  	/* Process guest code userspace exits. */
>  	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
> @@ -588,12 +588,12 @@ static void test_msr_filter_allow(void) {
>  	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
>  	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
>  
> -	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
> +	vm_install_vector_handler(vm, UD_VECTOR, guest_ud_handler);
>  	run_guest(vm);
> -	vm_handle_exception(vm, UD_VECTOR, NULL);
> +	vm_install_vector_handler(vm, UD_VECTOR, NULL);
>  
>  	if (process_ucall(vm) != UCALL_DONE) {
> -		vm_handle_exception(vm, GP_VECTOR, guest_fep_gp_handler);
> +		vm_install_vector_handler(vm, GP_VECTOR, guest_fep_gp_handler);
>  
>  		/* Process emulated rdmsr and wrmsr instructions. */
>  		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
> diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> index 2f964cdc273c..ded70ff465d5 100644
> --- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> @@ -462,7 +462,7 @@ int main(int argc, char *argv[])
>  
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
> -	vm_handle_exception(vm, IPI_VECTOR, guest_ipi_handler);
> +	vm_install_vector_handler(vm, IPI_VECTOR, guest_ipi_handler);
>  
>  	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA, 0);
>  
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
