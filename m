Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758DAC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5836610D2
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E5836610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 591CE4B1CA;
	Thu, 28 Oct 2021 10:09:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9C8BQhdb9tBx; Thu, 28 Oct 2021 10:09:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D33F4B1D7;
	Thu, 28 Oct 2021 10:09:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D5864B195
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 06:21:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 82hkrx-Dn27o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 06:21:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35DF14B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 06:21:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635416467;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WNjfMGWJgQRyrsFW4O+8W6gSms2YGqJfs44+x3miEeo=;
 b=dn+F1h9sd2rXyk58ZExJg4PTuOrSS+5gBZXg2FVPLM05riz5QUQXTzv7tfd159TNr4Vqq1
 RG+/Uc0Ini8RwNnajebjLvfjUPv5oshq662jUlJpbN5bJpd10ZOXoDJiO6S8uNAM/SjQKs
 98MfhyVbxfgTo1DizFLYXNMC9Lgg9Cw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-0q32FwVmMIWh3L38BGVE8w-1; Thu, 28 Oct 2021 06:21:05 -0400
X-MC-Unique: 0q32FwVmMIWh3L38BGVE8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F27B7802682;
 Thu, 28 Oct 2021 10:21:00 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B194417CE1;
 Thu, 28 Oct 2021 10:20:21 +0000 (UTC)
Message-ID: <6b2bdfad87e268e861b6cc331d25790dade8e27b.camel@redhat.com>
Subject: Re: [PATCH v2 21/43] KVM: VMX: Clean up PI pre/post-block WARNs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Oct 2021 13:20:20 +0300
In-Reply-To: <20211009021236.4122790-22-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-22-seanjc@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
> Move the WARN sanity checks out of the PI descriptor update loop so as
> not to spam the kernel log if the condition is violated and the update
> takes multiple attempts due to another writer.  This also eliminates a
> few extra uops from the retry path.
> 
> Technically not checking every attempt could mean KVM will now fail to
> WARN in a scenario that would have failed before, but any such failure
> would be inherently racy as some other agent (CPU or device) would have
> to concurrent modify the PI descriptor.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 351666c41bbc..67cbe6ab8f66 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -100,10 +100,11 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  	struct pi_desc old, new;
>  	unsigned int dest;
>  
> +	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
> +	     "Wakeup handler not enabled while the vCPU was blocking");
> +
>  	do {
>  		old.control = new.control = pi_desc->control;
> -		WARN(old.nv != POSTED_INTR_WAKEUP_VECTOR,
> -		     "Wakeup handler not enabled while the VCPU is blocked\n");
>  
>  		dest = cpu_physical_id(vcpu->cpu);
>  
> @@ -161,13 +162,12 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>  	}
>  
> +	WARN(pi_desc->sn == 1,
> +	     "Posted Interrupt Suppress Notification set before blocking");
> +
>  	do {
>  		old.control = new.control = pi_desc->control;
>  
> -		WARN((pi_desc->sn == 1),
> -		     "Warning: SN field of posted-interrupts "
> -		     "is set before blocking\n");
> -
>  		/*
>  		 * Since vCPU can be preempted during this process,
>  		 * vcpu->cpu could be different with pre_pcpu, we

Don't know for sure if this is desired. I'll would just use WARN_ON_ONCE instead
if the warning spams the log.

If there is a race I would rather want to catch it even if rare.

Best regards,
	Maxim Levitsky

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
