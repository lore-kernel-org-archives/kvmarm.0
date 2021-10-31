Return-Path: <SRS0=q2PC=PU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D33DC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 21:40:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C8C360F36
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 21:40:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C8C360F36
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C157B4B270;
	Mon,  1 Nov 2021 17:40:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W5fcrxgtijce; Mon,  1 Nov 2021 17:40:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5FD64B256;
	Mon,  1 Nov 2021 17:40:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC3D4B222
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 18:15:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zBnYBmEOL4vO for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 Oct 2021 18:15:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A46664B177
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 18:15:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635718552;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=C+trWHtpu8oYBXENs5w3b/Qoz24VhlDIgpUGDh1mOJU=;
 b=XHcPXesaDsG+RV8jNnEYgLvztUOo9bsp/bYIdgNPkTYIaOtkp4tX6lQTAsrfTeeoN/8VhQ
 Y/6AIcnmE9wJDU1+Km8O9UBDOJnlvXp4hbNFz/j4ERq5T1ZKutGsxf2c4BRc8y8JgdC+uH
 /6lLDOBUv8VpIEnLK7Q1w6bu5G+IYag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-WYECgU2fMxmEks3noiYjYA-1; Sun, 31 Oct 2021 18:15:48 -0400
X-MC-Unique: WYECgU2fMxmEks3noiYjYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6428F801AE3;
 Sun, 31 Oct 2021 22:15:45 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 292202B0B8;
 Sun, 31 Oct 2021 22:15:28 +0000 (UTC)
Message-ID: <592a315a8932b03f601e4c22d5846e97bd4a1103.camel@redhat.com>
Subject: Re: [PATCH v2 39/43] KVM: VMX: Don't do full kick when triggering
 posted interrupt "fails"
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Date: Mon, 01 Nov 2021 00:15:26 +0200
In-Reply-To: <fdf90c2f-81c8-513b-2e06-a90959f4cd89@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-40-seanjc@google.com>
 <335822ac-b98b-1eec-4911-34e4d0e99907@redhat.com>
 <YXl4mK7CyUBnPaQV@google.com>
 <fdf90c2f-81c8-513b-2e06-a90959f4cd89@redhat.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mailman-Approved-At: Mon, 01 Nov 2021 17:40:12 -0400
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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

On Thu, 2021-10-28 at 00:09 +0200, Paolo Bonzini wrote:
> On 27/10/21 18:04, Sean Christopherson wrote:
> > > > +		/*
> > > > +		 * The smp_wmb() in kvm_make_request() pairs with the smp_mb_*()
> > > > +		 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU
> > > > +		 * is guaranteed to see the event request if triggering a posted
> > > > +		 * interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
> > > 
> > > What this smp_wmb() pair with, is the smp_mb__after_atomic in
> > > kvm_check_request(KVM_REQ_EVENT, vcpu).
> > 
> > I don't think that's correct.  There is no kvm_check_request() in the relevant path.
> > kvm_vcpu_exit_request() uses kvm_request_pending(), which is just a READ_ONCE()
> > without a barrier.
> 
> Ok, we are talking about two different set of barriers.  This is mine:
> 
> - smp_wmb() in kvm_make_request() pairs with the smp_mb__after_atomic() in
> kvm_check_request(); it ensures that everything before the request
> (in this case, pi_pending = true) is seen by inject_pending_event.
> 
> - pi_test_and_set_on() orders the write to ON after the write to PIR,
> pairing with vmx_sync_pir_to_irr and ensuring that the bit in the PIR is
> seen.
> 
> And this is yours:
> 
> - pi_test_and_set_on() _also_ orders the write to ON before the read of
> vcpu->mode, pairing with vcpu_enter_guest()
> 
> - kvm_make_request() however does _not_ order the write to
> vcpu->requests before the read of vcpu->mode, even though it's needed.
> Usually that's handled by kvm_vcpu_exiting_guest_mode(), but in this case
> vcpu->mode is read in kvm_vcpu_trigger_posted_interrupt.

Yes indeed, kvm_make_request() writes the vcpu->requests after the memory barrier,
and then there is no barrier until reading of vcpu->mode in kvm_vcpu_trigger_posted_interrupt.

> 
> So vmx_deliver_nested_posted_interrupt() is missing a smp_mb__after_atomic().
> It's documentation only for x86, but still easily done in v3.
> 
> Paolo
> 

I used this patch as a justification to read Paolo's excellent LWN series of articles on memory barriers,
to refresh my knowledge of the memory barriers and understand the above analysis better.
https://lwn.net/Articles/844224/
 
I agree with the above, but this is something that is so easy to make a mistake
that I can't be 100% sure.
 
Best regards,
	Maxim Levitsky


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
