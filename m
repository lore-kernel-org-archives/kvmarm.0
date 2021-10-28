Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD589C43219
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 779D6610CA
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 779D6610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 108A94B1FE;
	Thu, 28 Oct 2021 10:09:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QwOmGz-+DALr; Thu, 28 Oct 2021 10:09:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39F454B1E3;
	Thu, 28 Oct 2021 10:09:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2250B4B1AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 06:55:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yEJyYefpxXOI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 06:55:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0844B150
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 06:55:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635418506;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rVBM4WS2LhpDG29Lqha3fLHlxhnITE0Ru8HhYa7oBTo=;
 b=Ut3c3Cbnc3K+t4v3A8GmwvUctdHBSE5oYbeCC7BL843mo28xPQaAw4uNIAuZEbpwXpFVnN
 A2sa8/E/8yk7HhqSO9WzCzIm72i67BO49BU9+EnQgPODs8XbjwydYBAJvOMPRJnDiVgIY6
 zKT4ZO9NGz/18Fh4NBPtQ7KwYNbKjJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-rG3SRiItNtexXrDC84-blA-1; Thu, 28 Oct 2021 06:55:03 -0400
X-MC-Unique: rG3SRiItNtexXrDC84-blA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0F8D18D6A2C;
 Thu, 28 Oct 2021 10:54:59 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 6D81760D30;
 Thu, 28 Oct 2021 10:54:41 +0000 (UTC)
Message-ID: <72804198c24493c95e4a28bcd670bff32b945278.camel@redhat.com>
Subject: Re: [PATCH v2 25/43] KVM: VMX: Save/restore IRQs (instead of
 CLI/STI) during PI pre/post block
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Oct 2021 13:54:40 +0300
In-Reply-To: <20211009021236.4122790-26-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-26-seanjc@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mailman-Approved-At: Thu, 28 Oct 2021 10:09:13 -0400
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
> Save/restore IRQs when disabling IRQs in posted interrupt pre/post block
> in preparation for moving the code into vcpu_put/load(), and thus may be
> called with IRQs already disabled.
> 
> No functional changed intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 239e0e72a0dd..414ea6972b5c 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -140,6 +140,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  {
>  	struct pi_desc old, new;
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> +	unsigned long flags;
>  
>  	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
>  	    !irq_remapping_cap(IRQ_POSTING_CAP) ||
> @@ -147,8 +148,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	    vmx_interrupt_blocked(vcpu))
>  		return 0;
>  
> -	WARN_ON(irqs_disabled());
> -	local_irq_disable();
> +	local_irq_save(flags);
>  
>  	vcpu->pre_pcpu = vcpu->cpu;
>  	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
> @@ -171,19 +171,20 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	if (pi_test_on(pi_desc))
>  		__pi_post_block(vcpu);
>  
> -	local_irq_enable();
> +	local_irq_restore(flags);
>  	return (vcpu->pre_pcpu == -1);
>  }
>  
>  void pi_post_block(struct kvm_vcpu *vcpu)
>  {
> +	unsigned long flags;
> +
>  	if (vcpu->pre_pcpu == -1)
>  		return;
>  
> -	WARN_ON(irqs_disabled());
> -	local_irq_disable();
> +	local_irq_save(flags);
>  	__pi_post_block(vcpu);
> -	local_irq_enable();
> +	local_irq_restore(flags);
>  }
>  
>  /*
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
