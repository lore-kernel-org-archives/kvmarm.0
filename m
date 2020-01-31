Return-Path: <SRS0=qAha=3U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D90C35240
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jan 2020 12:06:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71CFC20705
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jan 2020 12:06:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X5KHvz87"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71CFC20705
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C14164A4F7;
	Fri, 31 Jan 2020 07:06:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NK+wVzNUBX9H; Fri, 31 Jan 2020 07:06:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B81FA4A551;
	Fri, 31 Jan 2020 07:06:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD584A50F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jan 2020 07:06:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yf-Q9MElJlIO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jan 2020 07:06:39 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB43D4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jan 2020 07:06:39 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580472399;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=O8Za+S+RT8N2UwLMl2kq7dZ6BHikmL9Pgno023mZKr8=;
 b=X5KHvz87m8Ema2TsvSEuE2xrHGiaqpy/wYvTZRGTzt+6A/SxjuByjvcZJJgwkzMPu+jupx
 ID2Z0mij6wXO/GMU/KNSEsPS/eqZL899ddI1S3sTul5woYBXEuWmWS3Zlcwi4rHuGtrfDp
 Qyu1FbfQfDU3ZAk2AXEjJ8TBxnpXtgM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-Ih36PAVQOHGA5sgccpxLOw-1; Fri, 31 Jan 2020 07:06:36 -0500
X-MC-Unique: Ih36PAVQOHGA5sgccpxLOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 738599275B;
 Fri, 31 Jan 2020 12:06:33 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 46DCC5C3FA;
 Fri, 31 Jan 2020 12:06:18 +0000 (UTC)
Date: Fri, 31 Jan 2020 13:06:15 +0100
From: Cornelia Huck <cohuck@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 1/5] KVM: Pass kvm_init()'s opaque param to additional
 arch funcs
Message-ID: <20200131130615.3b21b28d.cohuck@redhat.com>
In-Reply-To: <20200130001023.24339-2-sean.j.christopherson@intel.com>
References: <20200130001023.24339-1-sean.j.christopherson@intel.com>
 <20200130001023.24339-2-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Wed, 29 Jan 2020 16:10:19 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Pass @opaque to kvm_arch_hardware_setup() and
> kvm_arch_check_processor_compat() to allow architecture specific code to
> reference @opaque without having to stash it away in a temporary global
> variable.  This will enable x86 to separate its vendor specific callback
> ops, which are passed via @opaque, into "init" and "runtime" ops without
> having to stash away the "init" ops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mips.c       |  4 ++--
>  arch/powerpc/kvm/powerpc.c |  4 ++--
>  arch/s390/kvm/kvm-s390.c   |  4 ++--
>  arch/x86/kvm/x86.c         |  4 ++--
>  include/linux/kvm_host.h   |  4 ++--
>  virt/kvm/arm/arm.c         |  4 ++--
>  virt/kvm/kvm_main.c        | 18 ++++++++++++++----
>  7 files changed, 26 insertions(+), 16 deletions(-)

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index eb3709d55139..5ad252defa54 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4345,14 +4345,22 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
>          return &kvm_running_vcpu;
>  }
>  
> -static void check_processor_compat(void *rtn)
> +struct kvm_cpu_compat_check {
> +	void *opaque;
> +	int *ret;
> +};
> +
> +static void check_processor_compat(void *data)
>  {
> -	*(int *)rtn = kvm_arch_check_processor_compat();
> +	struct kvm_cpu_compat_check *c = data;
> +
> +	*c->ret = kvm_arch_check_processor_compat(c->opaque);
>  }

This function also looks better now :)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Tested-by: Cornelia Huck <cohuck@redhat.com> #s390

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
