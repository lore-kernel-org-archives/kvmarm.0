Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050EAC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 16:48:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D4BA61545
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 16:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6D4BA61545
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 001FF49FE6;
	Tue, 16 Nov 2021 11:48:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XvEEMfwpXEQ0; Tue, 16 Nov 2021 11:48:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5CD44B11F;
	Tue, 16 Nov 2021 11:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C5849FE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 11:48:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZpPzec1FlFej for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 11:48:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E59F49F8F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 11:48:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637081321;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Cg0A/Tqzd8C8bvQHxDRqW8bNEhwYvKBZVV4KLqiN8xQ=;
 b=edZGYdhS8GFKntWtV/1tzUKNKQJIR8Iu5/nmSI6P6BFUx4TbmMwBjYEU8AAe2Q64PPiNQT
 OsN5JNW47Wlx/iG4Xl1hbx7s68PgZfvORdDvSFoX+fdu78hyOPHtyjmuwyDn5GvPOGfDkx
 zW1QTYFXBMl73xlPZPxYVARv6x7KDMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-p3SenisWPY62m1a-Emj8qQ-1; Tue, 16 Nov 2021 11:48:39 -0500
X-MC-Unique: p3SenisWPY62m1a-Emj8qQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F53487D542;
 Tue, 16 Nov 2021 16:48:37 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 757005FC13;
 Tue, 16 Nov 2021 16:48:20 +0000 (UTC)
Message-ID: <58fcf40e-75f5-f092-5aee-29d018f6bf67@redhat.com>
Date: Tue, 16 Nov 2021 17:48:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/5] KVM: x86: Use kvm_get_vcpu() instead of open-coded
 access
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-5-maz@kernel.org> <YYWOKTYHhJywwCRk@google.com>
 <330eb780-1963-ac1f-aaad-908346112f28@redhat.com>
 <YZPXU3eBT8j0fUPs@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZPXU3eBT8j0fUPs@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: Juergen Gross <jgross@suse.com>, Anup Patel <anup.patel@wdc.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu
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

On 11/16/21 17:07, Sean Christopherson wrote:
>>>           if (!kvm_arch_has_assigned_device(kvm) ||
>>>               !irq_remapping_cap(IRQ_POSTING_CAP) ||
>>> -           !kvm_vcpu_apicv_active(kvm->vcpus[0]))
>>> +           !irqchip_in_kernel(kvm) || !enable_apicv)
>>>                   return 0;
>>>
>>>           idx = srcu_read_lock(&kvm->irq_srcu);
>> What happens then if pi_pre_block is called and the IRTE denotes a posted
>> interrupt?
>>
>> I might be wrong, but it seems to me that you have to change all of the
>> occurrences this way.  As soon as enable_apicv is set, you need to go
>> through the POSTED_INTR_WAKEUP_VECTOR just in case.
> Sorry, I didn't grok that at all.  All occurences of what?

Of the !assigned-device || !VTd-PI || !kvm_vcpu_apicv_active(vcpu) 
checks.  This way, CPUs are woken up correctly even if you have 
!kvm_vcpu_apicv_active(vcpu) but the IRTE is a posted-interrupt one.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
