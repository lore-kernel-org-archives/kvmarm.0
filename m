Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06211C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 21:35:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66B0261075
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 21:35:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66B0261075
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB9844B50C;
	Wed, 31 Mar 2021 17:35:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iAxg1EFanD2Q; Wed, 31 Mar 2021 17:35:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C55794B50F;
	Wed, 31 Mar 2021 17:35:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DB2D4B50D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:35:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zXTxiAEKPhqq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 17:35:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D280A4B50C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:35:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617226542;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QQUIznWNci7QLnwuJm69/wWy4z3NEw65AzCUXnTQPwI=;
 b=B0t700AwuWfk00HLBYsci5Cw25mSrM6nxdaYPYLNBlYc6cZSCq7r3+SIFALdkG/HjLewUH
 AypAYgl+7i+1fE8te8y2RnriywZRo5I04C6XQKGmBR4ZWa8uhPrTJ6Bou+ViC2VxLuhSKk
 ZvsRLkUj7u2JZ0zxJRUjHkVrKb/GBzU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-YPdTcdAnNNCU1UTY3NpUqQ-1; Wed, 31 Mar 2021 17:35:40 -0400
X-MC-Unique: YPdTcdAnNNCU1UTY3NpUqQ-1
Received: by mail-ed1-f70.google.com with SMTP id q25so1786924eds.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 14:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=QQUIznWNci7QLnwuJm69/wWy4z3NEw65AzCUXnTQPwI=;
 b=ro8NjhPIGtb4P/HU2C1bqHrXHhZz73hjyCi8SIosBRp3d62zv6OzSnlx3rfLDYywI/
 HcZCZZHW39mJd76998X6YWgoX/ZhPoJc3c4jTgAakhr2V/AeQYZ6K1p4IoIutH5eCTKM
 hLovIEW1qGoHOxI8t7XdM2yGXSAto01hpFK1hCftv9+6kfxuvU9qsoXGlVHUu87rkPHr
 rLIAGQLjzplmk5uoX0b+UmRqy3vk7UJjwhYAHsgPYU63vi36LYP4IYnnRVURgI8s9H/c
 c13YXuGAurD5sZkdYA4ciDDsDvlifgp4QmunSZMNMbob+RiVliTFOXa3kzzNY9AGCN4L
 XnGg==
X-Gm-Message-State: AOAM533WcHFshPW4fe0ot3JE3JJwhePA+Ftv2xU3FQej7uE+XJZIodXt
 9ISzDITrgwvAkEjzgCz16QikgEGhgE4Cz3e5JQRF+SpLkIA3UW4bvPfvTN7ZWopQTUspVG8wUWD
 dk8jekel/iRl0txPXKG/oBBgj
X-Received: by 2002:a17:906:4d18:: with SMTP id
 r24mr5674567eju.493.1617226539479; 
 Wed, 31 Mar 2021 14:35:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqLuIZRAxqmNZY+xbCQNtWOLNhNwqjzyhv1KwZdcnD5ToTgWvG1r7yCpG0AD5klE6UQn/quw==
X-Received: by 2002:a17:906:4d18:: with SMTP id
 r24mr5674529eju.493.1617226539171; 
 Wed, 31 Mar 2021 14:35:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id h22sm1846899eji.80.2021.03.31.14.35.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 14:35:38 -0700 (PDT)
To: Sean Christopherson <seanjc@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
 <YGTkLMAzk88wOiZm@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <345ab567-386f-9080-f9cb-0e17fa90a852@redhat.com>
Date: Wed, 31 Mar 2021 23:35:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGTkLMAzk88wOiZm@google.com>
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

On 31/03/21 23:05, Sean Christopherson wrote:
>> Wouldn't it be incorrect to lock a mutex (e.g. inside*another*  MMU
>> notifier's invalidate callback) while holding an rwlock_t?  That makes sense
>> because anybody that's busy waiting in write_lock potentially cannot be
>> preempted until the other task gets the mutex.  This is a potential
>> deadlock.
>
> Yes?  I don't think I follow your point though.  Nesting a spinlock or rwlock
> inside a rwlock is ok, so long as the locks are always taken in the same order,
> i.e. it's never mmu_lock -> mmu_notifier_slots_lock.

*Another* MMU notifier could nest a mutex inside KVM's rwlock.

But... is it correct that the MMU notifier invalidate callbacks are 
always called with the mmap_sem taken (sometimes for reading, e.g. 
try_to_merge_with_ksm_page->try_to_merge_one_page->write_protect_page)? 
  We could take it temporarily in install_memslots, since the MMU 
notifier's mm is stored in kvm->mm.

In this case, a pair of kvm_mmu_notifier_lock/unlock functions would be 
the best way to abstract it.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
