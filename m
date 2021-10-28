Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51388C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE0566115A
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CE0566115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D5054B1D7;
	Thu, 28 Oct 2021 10:09:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gNEJM1oH4dZX; Thu, 28 Oct 2021 10:09:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2168D4B1DC;
	Thu, 28 Oct 2021 10:09:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 255114B1AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 06:53:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aLyXgT9-YuvT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 06:53:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FDD34B150
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 06:53:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635418428;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3Wt6hQz793bEAWB8qvBHsZDv2D0O8mIxXIVFLmn+riQ=;
 b=OpExUOFNwSiqkV5V2hcHeonpVvnGz56auQ79W5/hKo09kFpWz6eHC6SfEHF3CKpmOwuPto
 iFF0Oyl/INjXfMV0WxsJVr/bQ0D8BFpZanX2U+Ng85RSPKRiDQxWAJwV223V6kPWOUwjUM
 ng34/S9RktR9kebIx3vXZJ6/TQEBGRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-jwGpmWEnPaGeb-7ShF0kxw-1; Thu, 28 Oct 2021 06:53:45 -0400
X-MC-Unique: jwGpmWEnPaGeb-7ShF0kxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52A2A1006AA2;
 Thu, 28 Oct 2021 10:53:42 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3BBCF5DA61;
 Thu, 28 Oct 2021 10:53:28 +0000 (UTC)
Message-ID: <fcd7739536029260a340247e2528de12293d8ebe.camel@redhat.com>
Subject: Re: [PATCH v2 24/43] KVM: VMX: Drop pointless PI.NDST update when
 blocking
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Oct 2021 13:53:27 +0300
In-Reply-To: <20211009021236.4122790-25-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-25-seanjc@google.com>
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
> Don't update Posted Interrupt's NDST, a.k.a. the target pCPU, in the
> pre-block path, as NDST is guaranteed to be up-to-date.  The comment
> about the vCPU being preempted during the update is simply wrong, as the
> update path runs with IRQs disabled (from before snapshotting vcpu->cpu,
> until after the update completes).
> 
> The vCPU can get preempted _before_ the update starts, but not during.
> And if the vCPU is preempted before, vmx_vcpu_pi_load() is responsible
> for updating NDST when the vCPU is scheduled back in.  In that case, the
> check against the wakeup vector in vmx_vcpu_pi_load() cannot be true as
> that would require the notification vector to have been set to the wakeup
> vector _before_ blocking.
> 
> Opportunistically switch to using vcpu->cpu for the list/lock lookups,
> which presumably used pre_pcpu only for some phantom preemption logic.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 23 +++--------------------
>  1 file changed, 3 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 1688f8dc535a..239e0e72a0dd 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -130,7 +130,6 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>   * - Store the vCPU to the wakeup list, so when interrupts happen
>   *   we can find the right vCPU to wake up.
>   * - Change the Posted-interrupt descriptor as below:
> - *      'NDST' <-- vcpu->pre_pcpu
>   *      'NV' <-- POSTED_INTR_WAKEUP_VECTOR
>   * - If 'ON' is set during this process, which means at least one
>   *   interrupt is posted for this vCPU, we cannot block it, in
> @@ -139,7 +138,6 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>   */
>  int pi_pre_block(struct kvm_vcpu *vcpu)
>  {
> -	unsigned int dest;
>  	struct pi_desc old, new;
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> @@ -153,10 +151,10 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	local_irq_disable();
>  
>  	vcpu->pre_pcpu = vcpu->cpu;
> -	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
>  	list_add_tail(&vcpu->blocked_vcpu_list,
> -		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
> -	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
> +	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
>  
>  	WARN(pi_desc->sn == 1,
>  	     "Posted Interrupt Suppress Notification set before blocking");
> @@ -164,21 +162,6 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	do {
>  		old.control = new.control = pi_desc->control;
>  
> -		/*
> -		 * Since vCPU can be preempted during this process,
> -		 * vcpu->cpu could be different with pre_pcpu, we
> -		 * need to set pre_pcpu as the destination of wakeup
> -		 * notification event, then we can find the right vCPU
> -		 * to wakeup in wakeup handler if interrupts happen
> -		 * when the vCPU is in blocked state.
> -		 */
> -		dest = cpu_physical_id(vcpu->pre_pcpu);
> -
> -		if (x2apic_mode)
> -			new.ndst = dest;
> -		else
> -			new.ndst = (dest << 8) & 0xFF00;
> -
>  		/* set 'NV' to 'wakeup vector' */
>  		new.nv = POSTED_INTR_WAKEUP_VECTOR;
>  	} while (cmpxchg64(&pi_desc->control, old.control,
Reviewed-by : Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
