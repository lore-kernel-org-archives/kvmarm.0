Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890D9C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 16:47:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 026F96103D
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 16:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 026F96103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6436C4B467;
	Wed, 31 Mar 2021 12:47:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6h0zDWdoCWzj; Wed, 31 Mar 2021 12:47:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0C34B473;
	Wed, 31 Mar 2021 12:47:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E624B465
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 12:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GKAsiIMhBEdY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 12:47:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D604B3A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 12:47:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617209267;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0ix2mfUcEg/DOypNDwaacoOT966lSJ+UT8pzFrJ6uHI=;
 b=VTPeHIDD/uPp9CsY4tysGMAe6xtFzZpTYWx0dq2IW5mjsKc0ik6xI/z80di2ozirgxoLIx
 yRy7fPZdZLv0MHj0BeVxgg0rTjImk8q2TzW2nIoG+JogbTZMW5Upyg4IW1FOVXn1mtZR2J
 /3ZEI6JPQoVRtn39GxAzebkkrjrwRM4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-bms1F1X1MvmYEa5xziLiUA-1; Wed, 31 Mar 2021 12:47:45 -0400
X-MC-Unique: bms1F1X1MvmYEa5xziLiUA-1
Received: by mail-ej1-f72.google.com with SMTP id gn30so1064021ejc.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 09:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=0ix2mfUcEg/DOypNDwaacoOT966lSJ+UT8pzFrJ6uHI=;
 b=dPNb+AA32Sj17L175qtOrKafhuMKJFD9EbPuHvgmaj2wQzmtTg2gDTzxsMsQj57cxu
 sLixg/wLFJqKyWWG8UeINHptF8rM7WyyNDiSciOtzLfoZ0/P2G0cM20O3w/sFVwbFL8y
 xpTQdUuwzOtwuW0JestnvoQLzrQrGBkV3rYXR+9q84+a+X0oFE+1qIgW4SLKFnSv1QVr
 8gJu+y34b9FZqVghYPMG+WuPbvikVjEmdRNkUq9085bvzLnB/X1tUUMpEOrgbWQF5br0
 4546GzVXvCFZMg0BHezFBcvQnHi1hnJS99aHsB94T9Q4p6jAUykMVhBfUcII1MVBFmfv
 0rNA==
X-Gm-Message-State: AOAM530538dH0bf5qP8sFo4NTulfRvxOHpd5np1ckLKhrCYy98EFujqd
 uQm9EZL53fxVFWv7wl6VUMcbw8TTrhXYF2N7f1fOQXmYxMO6Sg/S7vPKhnshyEc0IRANVp7Xvt9
 V4HCxNpxc/RXXAszsbIvVYIFF
X-Received: by 2002:a17:906:1182:: with SMTP id
 n2mr4597710eja.234.1617209264780; 
 Wed, 31 Mar 2021 09:47:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymG2hf8oxiTqtfGgyXFzM/nXfYjs4CdYmJnVTC5zNGPoNEIpchzu0nS+pvIuCk4GHAjhT9jA==
X-Received: by 2002:a17:906:1182:: with SMTP id
 n2mr4597673eja.234.1617209264605; 
 Wed, 31 Mar 2021 09:47:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id p24sm2057269edt.5.2021.03.31.09.47.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 09:47:43 -0700 (PDT)
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To: Sean Christopherson <seanjc@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
Date: Wed, 31 Mar 2021 18:47:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGSmMeSOPcjxRwf6@google.com>
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

On 31/03/21 18:41, Sean Christopherson wrote:
>> That said, the easiest way to avoid this would be to always update
>> mmu_notifier_count.
> Updating mmu_notifier_count requires taking mmu_lock, which would defeat the
> purpose of these shenanigans.

Okay; I wasn't sure if the problem was contention with page faults in 
general, or just the long critical sections from the MMU notifier 
callbacks.  Still updating mmu_notifier_count unconditionally is a good 
way to break up the patch in two and keep one commit just for the rwsem 
nastiness.

>>> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>>> +	down_write(&kvm->mmu_notifier_slots_lock);
>>> +#endif
>>>   	rcu_assign_pointer(kvm->memslots[as_id], slots);
>>> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>>> +	up_write(&kvm->mmu_notifier_slots_lock);
>>> +#endif
>> Please do this unconditionally, the cost is minimal if the rwsem is not
>> contended (as is the case if the architecture doesn't use MMU notifiers at
>> all).
> It's not the cost, it's that mmu_notifier_slots_lock doesn't exist.  That's an
> easily solved problem, but then the lock wouldn't be initialized since
> kvm_init_mmu_notifier() is a nop.  That's again easy to solve, but IMO would
> look rather weird.  I guess the counter argument is that __kvm_memslots()
> wouldn't need #ifdeffery.

Yep.  Less #ifdefs usually wins. :)

> These are the to ideas I've come up with:
> 
> Option 1:
> 	static int kvm_init_mmu_notifier(struct kvm *kvm)
> 	{
> 		init_rwsem(&kvm->mmu_notifier_slots_lock);
> 
> 	#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> 		kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
> 		return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
> 	#else
> 		return 0;
> 	#endif
> 	}

Option 2 is also okay I guess, but the simplest is option 1 + just init 
it in kvm_create_vm.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
