Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286FAC2D0D2
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 09:33:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C8F12146E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 09:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dmfoYz46"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C8F12146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E327E4A8E8;
	Fri, 20 Dec 2019 04:33:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H37uwXf9cLz9; Fri, 20 Dec 2019 04:33:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B168D4A51C;
	Fri, 20 Dec 2019 04:33:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7134A51C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 04:33:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iVEE6pDhcZ5i for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 04:33:43 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DB684A4A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 04:33:43 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576834423;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=kARvpg6EeSn47uf+HJvOWWm63eTYV3jwqH0aHeRURHY=;
 b=dmfoYz46vqGDwzCGWVXsIk7DJL75u101QNyfXVFnhsbvnkRG/jGbI60XZR8UYR2B82cquP
 vC2qZ3Too5AMHq+B+fcpMd3z/xA3GrR75oI0IkdzPhG3xjYotEymY1oTgQEfwsvAEUwL/o
 d++1lYbeESfG61eRHrfEca3zcIeCeLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-euuv6RBAMwGCsT-Q338LuQ-1; Fri, 20 Dec 2019 04:33:41 -0500
X-MC-Unique: euuv6RBAMwGCsT-Q338LuQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 444D1911EB;
 Fri, 20 Dec 2019 09:33:38 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 82CC560BF3;
 Fri, 20 Dec 2019 09:33:27 +0000 (UTC)
Date: Fri, 20 Dec 2019 10:33:25 +0100
From: Cornelia Huck <cohuck@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 30/45] KVM: Move vcpu alloc and init invocation to
 common code
Message-ID: <20191220103325.34fc2bf0.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-31-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-31-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, James Hogan <jhogan@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Wed, 18 Dec 2019 13:55:15 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Now that all architectures tightly couple vcpu allocation/free with the
> mandatory calls to kvm_{un}init_vcpu(), move the sequences verbatim to
> common KVM code.
> 
> Move both allocation and initialization in a single patch to eliminate
> thrash in arch specific code.  The bisection benefits of moving the two
> pieces in separate patches is marginal at best, whereas the odds of
> introducing a transient arch specific bug are non-zero.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mips.c       | 33 ++++++---------------------------
>  arch/powerpc/kvm/powerpc.c | 27 ++++-----------------------
>  arch/s390/kvm/kvm-s390.c   | 31 +++++--------------------------
>  arch/x86/kvm/x86.c         | 28 ++--------------------------
>  include/linux/kvm_host.h   |  2 +-
>  virt/kvm/arm/arm.c         | 29 ++---------------------------
>  virt/kvm/kvm_main.c        | 21 ++++++++++++++++++---
>  7 files changed, 38 insertions(+), 133 deletions(-)

(...)

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8543d338a06a..2ed76584ebd9 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2530,9 +2530,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	if (vcpu->kvm->arch.use_cmma)
>  		kvm_s390_vcpu_unsetup_cmma(vcpu);
>  	free_page((unsigned long)(vcpu->arch.sie_block));
> -
> -	kvm_vcpu_uninit(vcpu);
> -	kmem_cache_free(kvm_vcpu_cache, vcpu);
>  }
>  
>  static void kvm_free_vcpus(struct kvm *kvm)
> @@ -3014,29 +3011,15 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>  	return 0;
>  }
>  
> -struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
> -				      unsigned int id)
> +int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *vcpu;
>  	struct sie_page *sie_page;
>  	int rc;
>  
> -	rc = -ENOMEM;
> -
> -	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> -	if (!vcpu)
> -		goto out;
> -
> -	rc = kvm_vcpu_init(vcpu, kvm, id);
> -	if (rc)
> -		goto out_free_cpu;
> -
> -	rc = -ENOMEM;
> -
>  	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
>  	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
>  	if (!sie_page)
> -		goto out_uninit_vcpu;
> +		return -ENOMEM;
>  
>  	vcpu->arch.sie_block = &sie_page->sie_block;
>  	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
> @@ -3087,15 +3070,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  		 vcpu->arch.sie_block);
>  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
>  
> -	return vcpu;
> +	return 0;
> +
>  out_free_sie_block:
>  	free_page((unsigned long)(vcpu->arch.sie_block));
> -out_uninit_vcpu:
> -	kvm_vcpu_uninit(vcpu);
> -out_free_cpu:
> -	kmem_cache_free(kvm_vcpu_cache, vcpu);
> -out:
> -	return ERR_PTR(rc);
> +	return rc;

This is getting a bit hard to follow across the patches, but I think rc
is now only set for ucontrol guests. So this looks correct right now,
but feels a bit brittle... should we maybe init rc to 0 and always
return rc instead?

>  }
>  
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)

Otherwise, looks good.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
