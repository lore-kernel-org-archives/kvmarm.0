Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C63C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 17:16:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C96D2610E5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 17:16:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C96D2610E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2404B1D3;
	Thu, 28 Oct 2021 13:16:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y4X+KMHLCwuE; Thu, 28 Oct 2021 13:16:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6980D4B1EF;
	Thu, 28 Oct 2021 13:16:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C923C4B1DA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 11:17:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MnY46PtVhaaU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 11:17:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19A664B1A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 11:17:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635434221;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DVtdqDXww3KgKAYnCusxuLMUzDOnQrWVlJbyjA+vsRU=;
 b=gPjdPwe+/dQQApVozTccKru8Z7yTs10NqTYTLMoUaiwU/wZp/C4jVZNE5EP7qqOKGtcaav
 ybmJ77PccO0LBblYbytt5fUNLZrfdl7QmS19gEmBsEznkLSS3uu6Y1fPZjAfdZBp23Pjdu
 5jeJzpb09HryIvwGV0tiqmzFviBYahw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-MW_4YzIxOem6d6CcDHBrfA-1; Thu, 28 Oct 2021 11:16:52 -0400
X-MC-Unique: MW_4YzIxOem6d6CcDHBrfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E298B19200C1;
 Thu, 28 Oct 2021 15:16:48 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id BF85560BF1;
 Thu, 28 Oct 2021 15:16:37 +0000 (UTC)
Message-ID: <ea79dbabd67c09b76ca3409d2d7d4934dc4de2c1.camel@redhat.com>
Subject: Re: [PATCH v2 30/43] KVM: Drop unused kvm_vcpu.pre_pcpu field
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Oct 2021 18:16:36 +0300
In-Reply-To: <20211009021236.4122790-31-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-31-seanjc@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mailman-Approved-At: Thu, 28 Oct 2021 13:15:59 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Remove kvm_vcpu.pre_pcpu as it no longer has any users.  No functional
> change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_host.h | 1 -
>  virt/kvm/kvm_main.c      | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1fa38dc00b87..87996b22e681 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -304,7 +304,6 @@ struct kvm_vcpu {
>  	u64 requests;
>  	unsigned long guest_debug;
>  
> -	int pre_pcpu;
>  	struct list_head blocked_vcpu_list;
>  
>  	struct mutex mutex;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c870cae7e776..2bbf5c9d410f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -426,7 +426,6 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  #endif
>  	kvm_async_pf_vcpu_init(vcpu);
>  
> -	vcpu->pre_pcpu = -1;
>  	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
>  
>  	kvm_vcpu_set_in_spin_loop(vcpu, false);



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
