Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FD9C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 22:09:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 444AA60240
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 22:09:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 444AA60240
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BDDB4B16F;
	Wed, 27 Oct 2021 18:09:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jDb7A+b3v-nw; Wed, 27 Oct 2021 18:09:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8694B172;
	Wed, 27 Oct 2021 18:09:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE7C44B163
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 18:09:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y9B3-xHZL-iz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 18:09:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18C8E4B150
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 18:09:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635372588;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vPTDsq9RY16fTCCoMhEcqKhkYxR/hT5AGgzHMhJ6ojY=;
 b=QcVXeKEmQ69d40jmh2rSlNCMAvXOH8wEQoTteJ2ZCqaUPE4nawlaLMza2KM3ogSDNOdNQb
 oeaI2FD7I3OqFzJ4HzDzFD70xp76Q0GpA6eYqCtDeKeky1jkdGvhqa2AErGIdMdRegP/TC
 kn9G2knclNOUrf26owqjCl4DcZczWE0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-DyDWeTxqOqKQ2yoavIaRYA-1; Wed, 27 Oct 2021 18:09:45 -0400
X-MC-Unique: DyDWeTxqOqKQ2yoavIaRYA-1
Received: by mail-ed1-f69.google.com with SMTP id
 g6-20020a056402424600b003dd2b85563bso3656252edb.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 15:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=vPTDsq9RY16fTCCoMhEcqKhkYxR/hT5AGgzHMhJ6ojY=;
 b=aD6hdjHxPKuijGUOAd0HVKyFZ7iYnlZOprmMvygyCLoPKaUYDr3+ldRHvhCNWoBk/K
 DvXh0iMjq/Oq8CGy+E0HMJy9s9yrciKvrTrVjd5O7I/irGf5gHbhUZeF5fp4XLCOYlS7
 dRZS1gNq0SD7kBFS0Bra3oV22I2f6bMeJfNvyrq2+V7BDj3EKQwKWikPzIoOrHQJN+eJ
 HGwukd66oWMCx5aJchre8VuN7YNrolNuLmdpcaV39uWbjPtZsNICcWSSpBVinU0eRR1d
 K+TJjspRBNRxDt20NcI7lNwRGplQG5xRDUtZ8ZeTfQiEgC0l+E/Tw63YELOOqtzdVCgO
 rKdw==
X-Gm-Message-State: AOAM530VXoL0QLZSDARoyZN47T0U2rgW82pg/scb0w9mn/5LKCMdqmEZ
 jgbYkBtkuElA2SQiw0Cny3czTNyx606zuDOa1K7dJYesVsi8cBJlpSaG3RZyf097w7kVD9fYup7
 mSdnlPP64oE2AinfxSYentbfR
X-Received: by 2002:a17:906:3f95:: with SMTP id
 b21mr341853ejj.368.1635372584298; 
 Wed, 27 Oct 2021 15:09:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoBx4vKjR30o+Kgjfdb4KsDUE6yjTUINxxdU8F5+6sRGk01DyvRy4bEl13EnJPgWSCV29mNQ==
X-Received: by 2002:a17:906:3f95:: with SMTP id
 b21mr341810ejj.368.1635372584078; 
 Wed, 27 Oct 2021 15:09:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id a9sm675279edm.31.2021.10.27.15.09.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Oct 2021 15:09:43 -0700 (PDT)
Message-ID: <fdf90c2f-81c8-513b-2e06-a90959f4cd89@redhat.com>
Date: Thu, 28 Oct 2021 00:09:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 39/43] KVM: VMX: Don't do full kick when triggering
 posted interrupt "fails"
To: Sean Christopherson <seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-40-seanjc@google.com>
 <335822ac-b98b-1eec-4911-34e4d0e99907@redhat.com>
 <YXl4mK7CyUBnPaQV@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXl4mK7CyUBnPaQV@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 27/10/21 18:04, Sean Christopherson wrote:
>>> +		/*
>>> +		 * The smp_wmb() in kvm_make_request() pairs with the smp_mb_*()
>>> +		 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU
>>> +		 * is guaranteed to see the event request if triggering a posted
>>> +		 * interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
>>
>> What this smp_wmb() pair with, is the smp_mb__after_atomic in
>> kvm_check_request(KVM_REQ_EVENT, vcpu).
>
> I don't think that's correct.  There is no kvm_check_request() in the relevant path.
> kvm_vcpu_exit_request() uses kvm_request_pending(), which is just a READ_ONCE()
> without a barrier.

Ok, we are talking about two different set of barriers.  This is mine:

- smp_wmb() in kvm_make_request() pairs with the smp_mb__after_atomic() in
kvm_check_request(); it ensures that everything before the request
(in this case, pi_pending = true) is seen by inject_pending_event.

- pi_test_and_set_on() orders the write to ON after the write to PIR,
pairing with vmx_sync_pir_to_irr and ensuring that the bit in the PIR is
seen.

And this is yours:

- pi_test_and_set_on() _also_ orders the write to ON before the read of
vcpu->mode, pairing with vcpu_enter_guest()

- kvm_make_request() however does _not_ order the write to
vcpu->requests before the read of vcpu->mode, even though it's needed.
Usually that's handled by kvm_vcpu_exiting_guest_mode(), but in this case
vcpu->mode is read in kvm_vcpu_trigger_posted_interrupt.

So vmx_deliver_nested_posted_interrupt() is missing a smp_mb__after_atomic().
It's documentation only for x86, but still easily done in v3.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
