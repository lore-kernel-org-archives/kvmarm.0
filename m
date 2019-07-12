Return-Path: <SRS0=lVnl=VJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC00C742D2
	for <kvmarm@archiver.kernel.org>; Fri, 12 Jul 2019 15:58:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5EC221670
	for <kvmarm@archiver.kernel.org>; Fri, 12 Jul 2019 15:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="BUptkUbB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5EC221670
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E97A4A52F;
	Fri, 12 Jul 2019 11:58:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VAbwVC7TzgSi; Fri, 12 Jul 2019 11:58:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 065FB4A531;
	Fri, 12 Jul 2019 11:58:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50A434A52F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jul 2019 11:58:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dVNsm3b9IA0P for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jul 2019 11:58:30 -0400 (EDT)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com
 [207.171.190.10])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 315294A4EA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jul 2019 11:58:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
 t=1562947110; x=1594483110;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:mime-version: content-transfer-encoding;
 bh=Xv6oMdRCDU5+Rbt92DK7ZqXDl23JyeTh31Mje6oJEeA=;
 b=BUptkUbBsw/1MQUzYSTzxK6Y7fJxNeJhT0qJd6SxDMBuTKZ0ZfCVlHT3
 4xJ7OLHp3yNF2DEf7zXmCQFmWYVHEk2VPT2gi61Le1rkQAjy6N807VHWf
 H945+GlXJDMAn4+sO6ngnFFTTfP8RCS7ml5pP9SmVGPPKn71rFZVRqwhk k=;
X-IronPort-AV: E=Sophos;i="5.62,483,1554768000"; d="scan'208";a="810893324"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO
 email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.22.38])
 by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP;
 12 Jul 2019 15:58:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com
 (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
 by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS
 id 819EEA2452; Fri, 12 Jul 2019 15:58:25 +0000 (UTC)
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 12 Jul 2019 15:58:24 +0000
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13D01EUB003.ant.amazon.com (10.43.166.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 12 Jul 2019 15:58:24 +0000
Received: from EX13D01EUB003.ant.amazon.com ([10.43.166.248]) by
 EX13D01EUB003.ant.amazon.com ([10.43.166.248]) with mapi id 15.00.1367.000;
 Fri, 12 Jul 2019 15:58:24 +0000
From: "Raslan, KarimAllah" <karahmed@amazon.de>
To: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: arm/arm64: Properly check for MMIO regions
Thread-Topic: [PATCH] KVM: arm/arm64: Properly check for MMIO regions
Thread-Index: AQHVOIsEiyNRFKEvKk+KpgFJVWRN7KbHJC2A
Date: Fri, 12 Jul 2019 15:58:23 +0000
Message-ID: <1562947103.19043.1.camel@amazon.de>
References: <1562919728-642-1-git-send-email-karahmed@amazon.de>
In-Reply-To: <1562919728-642-1-git-send-email-karahmed@amazon.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.54]
Content-ID: <5D2353EA90095E4081DA8A6D66A19A79@amazon.com>
MIME-Version: 1.0
Precedence: Bulk
Cc: "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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

On Fri, 2019-07-12 at 10:22 +0200, KarimAllah Ahmed wrote:
> Valid RAM can live outside kernel control (e.g. using "mem=" command-line
> parameter). This memory can still be used as valid guest memory for KVM. So
> ensure that we validate that this memory is definitely not "RAM" before
> assuming that it is an MMIO region.

This patch actually suffers from the same problem pointed out here:
https://lkml.org/lkml/2019/7/12/760

.. so I will need to rework them together.

> 
> One way to use memory outside kernel control is:
> 
> 1- Pass 'mem=' in the kernel command-line to limit the amount of memory managed
>    by the kernel.
> 2- Map this physical memory you want to give to the guest with:
>    mmap("/dev/mem", physical_address_offset, ..)
> 3- Use the user-space virtual address as the "userspace_addr" field in
>    KVM_SET_USER_MEMORY_REGION ioctl.
> 
> One of the limitations of the current /dev/mem for ARM is that it would map
> this memory as uncached without this patch:
> https://lkml.org/lkml/2019/7/11/684
> 
> This work is similar to the work done on x86 here:
> https://lkml.org/lkml/2019/1/31/933
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Julien Thierry <julien.thierry@arm.com>
> Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
> ---
>  virt/kvm/arm/mmu.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 06180c9..2105134 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -8,6 +8,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/io.h>
>  #include <linux/hugetlb.h>
> +#include <linux/memblock.h>
>  #include <linux/sched/signal.h>
>  #include <trace/events/kvm.h>
>  #include <asm/pgalloc.h>
> @@ -89,7 +90,7 @@ static void kvm_flush_dcache_pud(struct kvm *kvm,
>  
>  static bool kvm_is_device_pfn(unsigned long pfn)
>  {
> -	return !pfn_valid(pfn);
> +	return !memblock_is_memory(__pfn_to_phys(pfn));
>  }
>  
>  /**
> @@ -949,6 +950,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>  	do {
>  		struct vm_area_struct *vma = find_vma(current->mm, hva);
>  		hva_t vm_start, vm_end;
> +		gpa_t gpa;
>  
>  		if (!vma || vma->vm_start >= reg_end)
>  			break;
> @@ -959,11 +961,14 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>  		vm_start = max(hva, vma->vm_start);
>  		vm_end = min(reg_end, vma->vm_end);
>  
> -		if (!(vma->vm_flags & VM_PFNMAP)) {
> -			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
> -			unmap_stage2_range(kvm, gpa, vm_end - vm_start);
> -		}
>  		hva = vm_end;
> +
> +		if ((vma->vm_flags & VM_PFNMAP) &&
> +		    !memblock_is_memory(__pfn_to_phys(vma->vm_pgoff)))
> +			continue;
> +
> +		gpa = addr + (vm_start - memslot->userspace_addr);
> +		unmap_stage2_range(kvm, gpa, vm_end - vm_start);
>  	} while (hva < reg_end);
>  }
>  
> @@ -2329,7 +2334,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  		vm_start = max(hva, vma->vm_start);
>  		vm_end = min(reg_end, vma->vm_end);
>  
> -		if (vma->vm_flags & VM_PFNMAP) {
> +		if ((vma->vm_flags & VM_PFNMAP) &&
> +		    !memblock_is_memory(__pfn_to_phys(vma->vm_pgoff))) {
>  			gpa_t gpa = mem->guest_phys_addr +
>  				    (vm_start - mem->userspace_addr);
>  			phys_addr_t pa;



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
