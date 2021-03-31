Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1C1C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 20:30:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17C9661002
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 20:30:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17C9661002
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65DFE4B4F3;
	Wed, 31 Mar 2021 16:30:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3xkwcTzKx2ER; Wed, 31 Mar 2021 16:30:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EEC74B4F8;
	Wed, 31 Mar 2021 16:30:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B01C04B4A8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 16:30:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C3nlPKSiTV8U for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 16:30:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D657E4B099
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 16:30:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617222613;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iGV1jFbUJjDZ0xr5aZ9Ku/VANnkkq23LGJCjyuxNq8E=;
 b=LITFMoL/Jw/Httq0f3b6tjTkcCyEpk5UbTvSxnHrZA9qEPK07v8nX6n/M52frmw1OEp+Jj
 hIUizs7NwiCpwyu5xnDupDJdjsfHOo3tWGqkWobBJunXacVfxsM3XIlKYCaRlPNvIlp2pb
 VAyP/i8WOJixUMBSW7jwUow+2Bst3hQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-Rub-1n80PySOk9xyWfpSQA-1; Wed, 31 Mar 2021 16:30:09 -0400
X-MC-Unique: Rub-1n80PySOk9xyWfpSQA-1
Received: by mail-ej1-f70.google.com with SMTP id p11so1328270eju.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 13:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=iGV1jFbUJjDZ0xr5aZ9Ku/VANnkkq23LGJCjyuxNq8E=;
 b=lj3Hwurq1FHcLfXtrLzjHVE23kF7XFyS1VptTazMPZRXjTFWYxGukCP87SCsc8baVK
 6MTD17rV47bHVVfmLMhxoVdImLED5JT0FeDJuLa6jOwZIUWGd3GecBKVOFxUE5fpbZHl
 ifenNr/R9XdoR84yBMQujiqCEGuMY34KQ2IJjCcEbBnMMY5mQUGpv65j3xajf5c9uOCB
 2J4hrGEJiztHr3IAwexQBdU/O0MBB4VrTh37Yo00Olitd8FzC3r9b8Xxo/RjCWTPiiIJ
 N9doB4NAGXo9h7FHfQD0aeqs3A9TGzNMTgaje12Wmt/OtSSmSwC7RJsXPMfhhWMZ7ca2
 8RHw==
X-Gm-Message-State: AOAM531bvUoDqnN8cGvHoeFfQca6RZdotATjVH5bpEIy/pWDWzfqQvPs
 vzb5maF7Etf/JOeYyZUrzXLLKIQfjZduCqfuID6Cwo+S9A9iqefomg9C4CdowUSay5lXsepILae
 mIV7tTpwGsx4RygxqCTjzsLdC
X-Received: by 2002:a17:906:d787:: with SMTP id
 pj7mr5461245ejb.257.1617222608610; 
 Wed, 31 Mar 2021 13:30:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtvybwxaq/xUKBgYLNjG4mX/vnDB42i0fSfVNTPr5tTgAMfXL6m32uLgH+xDN6PSnJCPYqCg==
X-Received: by 2002:a17:906:d787:: with SMTP id
 pj7mr5461218ejb.257.1617222608403; 
 Wed, 31 Mar 2021 13:30:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id q10sm2264030eds.67.2021.03.31.13.30.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 13:30:07 -0700 (PDT)
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To: Sean Christopherson <seanjc@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGTYf9sWVIJqqswq@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fdd5bfb1-8abc-7658-b288-dc9943a6e04c@redhat.com>
Date: Wed, 31 Mar 2021 22:30:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGTYf9sWVIJqqswq@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On 31/03/21 22:15, Sean Christopherson wrote:
> On Wed, Mar 31, 2021, Paolo Bonzini wrote:
>> On 26/03/21 03:19, Sean Christopherson wrote:
>>> +	/*
>>> +	 * Reset the lock used to prevent memslot updates between MMU notifier
>>> +	 * range_start and range_end.  At this point no more MMU notifiers will
>>> +	 * run, but the lock could still be held if KVM's notifier was removed
>>> +	 * between range_start and range_end.  No threads can be waiting on the
>>> +	 * lock as the last reference on KVM has been dropped.  If the lock is
>>> +	 * still held, freeing memslots will deadlock.
>>> +	 */
>>> +	init_rwsem(&kvm->mmu_notifier_slots_lock);
>>
>> I was going to say that this is nasty, then I noticed that
>> mmu_notifier_unregister uses SRCU to ensure completion of concurrent calls
>> to the MMU notifier.  So I guess it's fine, but it's better to point it out:
>>
>> 	/*
>> 	 * At this point no more MMU notifiers will run and pending
>> 	 * calls to range_start have completed, but the lock would
>> 	 * still be held and never released if the MMU notifier was
>> 	 * removed between range_start and range_end.  Since the last
>> 	 * reference to the struct kvm has been dropped, no threads can
>> 	 * be waiting on the lock, but we might still end up taking it
>> 	 * when freeing memslots in kvm_arch_destroy_vm.  Reset the lock
>> 	 * to avoid deadlocks.
>> 	 */
> 
> An alternative would be to not take the lock in install_new_memslots() if
> kvm->users_count == 0.  It'd be weirder to document, and the conditional locking
> would still be quite ugly.  Not sure if that's better than blasting a lock
> during destruction?

No, that's worse...

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
