Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6444FC43603
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 10:05:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4B2C2465E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 10:05:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JDIe9Q96"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4B2C2465E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ABD94A959;
	Fri, 20 Dec 2019 05:05:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lHWwCwiBg4uk; Fri, 20 Dec 2019 05:05:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3334C4A7FF;
	Fri, 20 Dec 2019 05:05:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEAE04A524
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 05:05:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7TZsjyefXKEU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 05:05:00 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2FDE4A521
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 05:05:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576836300;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QvzvT9KTfyHDuiqD0CTUkv7t6l7JQ96ZSNVZ4d8CIR8=;
 b=JDIe9Q96TibzSJ0B5gco8g9cXQpCfAs9Inl7IzZ2jxRWc9H96nJXhhuJNut0SVFo0IxGm9
 P5ZKR0d74k7vIOUQtaFQ1aQo/3op6tlfTC4vZ/wAplIQYYIJV3rkw2Z/mVtoWuQNl+Qiya
 V1BiVxfG0w1cR3z9DCz0mpCzOugbgt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-Z1PL8IVtM1GYv6o7quyz3w-1; Fri, 20 Dec 2019 05:04:56 -0500
X-MC-Unique: Z1PL8IVtM1GYv6o7quyz3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D83A911F0;
 Fri, 20 Dec 2019 10:04:54 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id EB85060C18;
 Fri, 20 Dec 2019 10:04:47 +0000 (UTC)
Date: Fri, 20 Dec 2019 11:04:45 +0100
From: Cornelia Huck <cohuck@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 35/45] KVM: s390: Manually invoke vcpu setup during
 kvm_arch_vcpu_create()
Message-ID: <20191220110445.3a42041a.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-36-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-36-sean.j.christopherson@intel.com>
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

On Wed, 18 Dec 2019 13:55:20 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Rename kvm_arch_vcpu_setup() to kvm_s390_vcpu_setup() and manually call
> the new function during kvm_arch_vcpu_create().  Define an empty
> kvm_arch_vcpu_setup() as it's still required for compilation.  This
> is effectively a nop as kvm_arch_vcpu_create() and kvm_arch_vcpu_setup()
> are called back-to-back by common KVM code.  Obsoleting
> kvm_arch_vcpu_setup() paves the way for its removal.
> 
> Note, gmap_remove() is now called if setup fails, as s390 was previously
> freeing it via kvm_arch_vcpu_destroy(), which is called by common KVM
> code if kvm_arch_vcpu_setup() fails.

Yes, this looks like the only thing that needs to be undone
(sca_add_vcpu() is done later in the process.)

Maybe mention that gmap_remove() is for ucontrol only? I was confused
for a moment :)


> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
