Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF31C2D0D2
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 09:51:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FD0124679
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 09:51:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fgooKVkS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FD0124679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5854A586;
	Fri, 20 Dec 2019 04:51:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nCUe9nClHEbR; Fri, 20 Dec 2019 04:51:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4F484A7FF;
	Fri, 20 Dec 2019 04:51:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61C2D4A51F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 04:51:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tUvjkcKYTWpm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 04:51:02 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62B854A51C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 04:51:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576835462;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=99eauVFberJXv2fQAwZtixMy3egbUdn3Of2y1/7QSBo=;
 b=fgooKVkS8DgFItdqw/1Y2ojvhm0lhPxyIlPkpuWKc+ptPp5CEJsLyxg4DMYwwYon+u8bIG
 Nl73DbqRQzs8xGzXzr6X5dUVMy35LOuVrHW7kgJmR1KjIEePvflVdPcdsZbq4v6WPjtcj/
 fU6nXn3M3wmWINjEsaTHvKLfnqbQbg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-KSOnSj7mOiGqSWdMbp1wmw-1; Fri, 20 Dec 2019 04:51:00 -0500
X-MC-Unique: KSOnSj7mOiGqSWdMbp1wmw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04477189CD00;
 Fri, 20 Dec 2019 09:50:58 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B0B7C26FC4;
 Fri, 20 Dec 2019 09:50:51 +0000 (UTC)
Date: Fri, 20 Dec 2019 10:50:49 +0100
From: Cornelia Huck <cohuck@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 32/45] KVM: Move initialization of preempt notifier
 to kvm_vcpu_init()
Message-ID: <20191220105049.3fbdbbcc.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-33-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-33-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

On Wed, 18 Dec 2019 13:55:17 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Initialize the preempt notifier immediately in kvm_vcpu_init() to pave
> the way for removing kvm_arch_vcpu_setup(), i.e. to allow arch specific
> code to call vcpu_load() during kvm_arch_vcpu_create().
> 
> Back when preemption support was added, the location of the call to init
> the preempt notifier was perfectly sane.  The overall vCPU creation flow
> featured a single arch specific hook and the preempt notifer was used
> immediately after its initialization (by vcpu_load()).  E.g.:
> 
>         vcpu = kvm_arch_ops->vcpu_create(kvm, n);
>         if (IS_ERR(vcpu))
>                 return PTR_ERR(vcpu);
> 
>         preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
> 
>         vcpu_load(vcpu);
>         r = kvm_mmu_setup(vcpu);
>         vcpu_put(vcpu);
>         if (r < 0)
>                 goto free_vcpu;
> 
> Today, the call to preempt_notifier_init() is sandwiched between two
> arch specific calls, kvm_arch_vcpu_create() and kvm_arch_vcpu_setup(),
> which needlessly forces x86 (and possibly others?) to split its vCPU
> creation flow.  Init the preempt notifier prior to any arch specific
> call so that each arch can independently decide how best to organize
> its creation flow.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
