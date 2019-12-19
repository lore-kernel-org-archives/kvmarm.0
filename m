Return-Path: <SRS0=v2jq=2J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C86C43603
	for <kvmarm@archiver.kernel.org>; Thu, 19 Dec 2019 19:28:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5289224672
	for <kvmarm@archiver.kernel.org>; Thu, 19 Dec 2019 19:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFHb9ppA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5289224672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9164A7FE;
	Thu, 19 Dec 2019 14:28:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZpC-d3nyjZyS; Thu, 19 Dec 2019 14:28:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3A54A5A6;
	Thu, 19 Dec 2019 14:28:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F37404A523
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Dec 2019 14:28:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UhbpvP0n8pWo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Dec 2019 14:28:52 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 151684A4F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Dec 2019 14:28:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576783731;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vAIxDhFZG4KNnWbcoM1z/eNh1hoZhidyKE5sG/UkD5w=;
 b=PFHb9ppAZSdrztzN13AkJXfJwoQ4HSUioSSeXLQYd1I6WwVi74SRjdBcWFfaprsyLpqZrx
 7fHiuZ1lBmwi7PBidNlFEv6Bg2/gXdNBvK2u2D5YtknNCz41xYPos9aReo8fAXZ7lU1BHL
 nSiqfJu8QSBS3SnXFsyFIlfUDzdDets=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-7KuzwdpAO0uhdJbA8J3gpA-1; Thu, 19 Dec 2019 14:28:48 -0500
X-MC-Unique: 7KuzwdpAO0uhdJbA8J3gpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B2CA18FF698;
 Thu, 19 Dec 2019 19:28:45 +0000 (UTC)
Received: from gondolin (ovpn-117-134.ams2.redhat.com [10.36.117.134])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 01C375DA70;
 Thu, 19 Dec 2019 19:28:37 +0000 (UTC)
Date: Thu, 19 Dec 2019 20:28:35 +0100
From: Cornelia Huck <cohuck@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 24/45] KVM: Add kvm_arch_vcpu_precreate() to handle
 pre-allocation issues
Message-ID: <20191219202835.06fc6f2f.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-25-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-25-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

On Wed, 18 Dec 2019 13:55:09 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Add a pre-allocation arch hook to handle checks that are currently done
> by arch specific code prior to allocating the vCPU object.  This paves
> the way for moving the allocation to common KVM code.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mips.c       |  5 +++++
>  arch/powerpc/kvm/powerpc.c |  5 +++++
>  arch/s390/kvm/kvm-s390.c   | 12 ++++++++----
>  arch/x86/kvm/x86.c         | 14 +++++++++-----
>  include/linux/kvm_host.h   |  1 +
>  virt/kvm/arm/arm.c         | 21 +++++++++++----------
>  virt/kvm/kvm_main.c        |  4 ++++
>  7 files changed, 43 insertions(+), 19 deletions(-)
> 

(...)

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d9e6bf3d54f0..57c6838dff37 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3035,15 +3035,19 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
>  	return rc;
>  }
>  
> +int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> +{
> +	if (!kvm_is_ucontrol(kvm) && !sca_can_add_vcpu(kvm, id))
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  				      unsigned int id)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct sie_page *sie_page;
> -	int rc = -EINVAL;
> -
> -	if (!kvm_is_ucontrol(kvm) && !sca_can_add_vcpu(kvm, id))
> -		goto out;
> +	int rc;

You might want to make this

int rc = -ENOMEM;

instead.

>  
>  	rc = -ENOMEM;
>  

(...)

Regardless,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
