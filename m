Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EFFC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 14:05:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41D0461B48
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 14:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41D0461B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D074B10C;
	Tue, 16 Nov 2021 09:05:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xTVK0Mia+xxR; Tue, 16 Nov 2021 09:05:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C854B0B6;
	Tue, 16 Nov 2021 09:05:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6994B086
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 09:05:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S6TkjDEQTKOu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 09:05:01 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5B604A500
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 09:05:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637071501;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hBtk2aPZbU2pteLbgMkZkjDkjfuxdJX2rybR87y4uZ4=;
 b=fQXchlOqjb3ZCi5ZqTO8/iS2U2Kyj7GLqNkRqkJ3CXNPR6wXL9PwSq6li9PZX3POzy1/7R
 a5W94jTjDkiXPIat8kohq+6E2mtFTkLd41AOpT6flVzYCWr4vLQ3UEd7T7Fe+n8HBfnd0x
 wxFQjQ4C6+yc5GmS4nnDHjcBAYMNzVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-L8W_GkDdPby-uiSCgnu-Aw-1; Tue, 16 Nov 2021 09:05:00 -0500
X-MC-Unique: L8W_GkDdPby-uiSCgnu-Aw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85E8880DDE4;
 Tue, 16 Nov 2021 14:04:57 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A662F10023B8;
 Tue, 16 Nov 2021 14:04:48 +0000 (UTC)
Message-ID: <330eb780-1963-ac1f-aaad-908346112f28@redhat.com>
Date: Tue, 16 Nov 2021 15:04:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/5] KVM: x86: Use kvm_get_vcpu() instead of open-coded
 access
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-5-maz@kernel.org> <YYWOKTYHhJywwCRk@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YYWOKTYHhJywwCRk@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: Juergen Gross <jgross@suse.com>, Anup Patel <anup.patel@wdc.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Huacai Chen <chenhuacai@kernel.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, kernel-team@android.com,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/5/21 21:03, Sean Christopherson wrote:
> But I think even that is flawed, as APICv can be dynamically deactivated and
> re-activated while the VM is running, and I don't see a path that re-updates
> the IRTE when APICv is re-activated.  So I think a more conservative check is
> needed, e.g.
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 5f81ef092bd4..6cf5b2e86118 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -272,7 +272,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
> 
>          if (!kvm_arch_has_assigned_device(kvm) ||
>              !irq_remapping_cap(IRQ_POSTING_CAP) ||
> -           !kvm_vcpu_apicv_active(kvm->vcpus[0]))
> +           !irqchip_in_kernel(kvm) || !enable_apicv)
>                  return 0;
> 
>          idx = srcu_read_lock(&kvm->irq_srcu);

What happens then if pi_pre_block is called and the IRTE denotes a 
posted interrupt?

I might be wrong, but it seems to me that you have to change all of the 
occurrences this way.  As soon as enable_apicv is set, you need to go 
through the POSTED_INTR_WAKEUP_VECTOR just in case.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
