Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C934C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48254610F8
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 48254610F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFA3D4B1DD;
	Thu, 28 Oct 2021 10:09:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZnHhKEqEQGUA; Thu, 28 Oct 2021 10:09:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 648E44B1EF;
	Thu, 28 Oct 2021 10:09:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A5D64B1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 07:28:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PZ6hCVmQPdg2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 07:28:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C07D4B104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 07:28:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635420532;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MHpIfrYfSW8Oruu5gZzONXfOs5cqhayPI05VEPrlFqI=;
 b=ZXK1SsScmTgtnETpIVi2QXHMMs18RzTZPLNJsMQPBJZrv9133Un6zEiD04wYDmRLk8iqrN
 iuZX4yT7S6TUZoHT9hESffo8pukWCq5lQV0yzXImlSkMPgQqKPN/CyfuhIr/OGE6dxfDS+
 vegJ1oDUxlGxo3f0//TYGU5zmJ/np9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-eJZbxn5mNyK61ySDSBCRrA-1; Thu, 28 Oct 2021 07:28:46 -0400
X-MC-Unique: eJZbxn5mNyK61ySDSBCRrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF9359F92B;
 Thu, 28 Oct 2021 11:28:42 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 108AF5DA61;
 Thu, 28 Oct 2021 11:28:30 +0000 (UTC)
Message-ID: <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
Subject: Re: [PATCH v2 27/43] KVM: VMX: Move Posted Interrupt ndst
 computation out of write loop
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Oct 2021 14:28:29 +0300
In-Reply-To: <20211009021236.4122790-28-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-28-seanjc@google.com>
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
> Hoist the CPU => APIC ID conversion for the Posted Interrupt descriptor
> out of the loop to write the descriptor, preemption is disabled so the
> CPU won't change, and if the APIC ID changes KVM has bigger problems.
> 
> No functional change intended.

Is preemption always disabled in vmx_vcpu_pi_load? vmx_vcpu_pi_load is called from vmx_vcpu_load,
which is called indirectly from vcpu_load which is called from many ioctls,
which userspace does. In these places I don't think that preemption is disabled.

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index fea343dcc011..2b2206339174 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -51,17 +51,15 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		goto after_clear_sn;
>  	}
>  
> -	/* The full case.  */
> +	/* The full case.  Set the new destination and clear SN. */
> +	dest = cpu_physical_id(cpu);
> +	if (!x2apic_mode)
> +		dest = (dest << 8) & 0xFF00;
> +
>  	do {
>  		old.control = new.control = READ_ONCE(pi_desc->control);
>  
> -		dest = cpu_physical_id(cpu);
> -
> -		if (x2apic_mode)
> -			new.ndst = dest;
> -		else
> -			new.ndst = (dest << 8) & 0xFF00;
> -
> +		new.ndst = dest;
>  		new.sn = 0;
>  	} while (cmpxchg64(&pi_desc->control, old.control,
>  			   new.control) != old.control);
> @@ -103,15 +101,14 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
>  	     "Wakeup handler not enabled while the vCPU was blocking");
>  
> +	dest = cpu_physical_id(vcpu->cpu);
> +	if (!x2apic_mode)
> +		dest = (dest << 8) & 0xFF00;
> +
>  	do {
>  		old.control = new.control = READ_ONCE(pi_desc->control);
>  
> -		dest = cpu_physical_id(vcpu->cpu);
> -
> -		if (x2apic_mode)
> -			new.ndst = dest;
> -		else
> -			new.ndst = (dest << 8) & 0xFF00;
> +		new.ndst = dest;
>  
>  		/* set 'NV' to 'notification vector' */
>  		new.nv = POSTED_INTR_VECTOR;


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
