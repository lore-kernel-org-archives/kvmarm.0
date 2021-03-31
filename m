Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88DEC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 20:42:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F22B61073
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 20:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F22B61073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 988E74B4DE;
	Wed, 31 Mar 2021 16:42:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id atfGtMyzsJSf; Wed, 31 Mar 2021 16:42:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB204B4F6;
	Wed, 31 Mar 2021 16:42:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1CC4B4DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 16:42:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JllIjvSxmpu0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 16:42:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 386634B36D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 16:42:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617223356;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NNGnbExYiLuLZaTb/olJYdDzkOfEQoR57OqAJHWnBDw=;
 b=jB5Mut5bRNfcGg/ZtfE+V4n+LmeFqEtNMUT1aKjcRc6yTpcg/Dl95RJ7Vtu3yRz0qtt6KK
 LSPhRUyxitGjU40FCMp0F5lhgxmIaUmVKl6Uk4c2Y13wiieg2GnJRUDTF5oKvskjRyHXWE
 EZhQjQzLV3FND/2GNzMND7H8dWIej0E=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-H2td8RI1PK2YLu9yrxnpYg-1; Wed, 31 Mar 2021 16:42:33 -0400
X-MC-Unique: H2td8RI1PK2YLu9yrxnpYg-1
Received: by mail-ed1-f72.google.com with SMTP id h2so1732803edw.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 13:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=NNGnbExYiLuLZaTb/olJYdDzkOfEQoR57OqAJHWnBDw=;
 b=SBd8VIHqiWRNzmHSQy8vgbmdHZQib0WCISp7BypqI/hnZkcMwziiKdb5lx/Kz3FPtk
 lXNjGMQtwqZtICUJ8nLm2iWb5Pdpbt5sAajMDCm3cQ0It6jSXTAXmfmZrALSgf4HwGek
 qQY0OztYwhu5zQJIOOI621xBXAnTgZKGii9ElB+AnlVkvQKK4n9EjXTt3+cHXMRjKx4O
 sFlFsMQHVYkUZNMOYzZ4YhPcyIwt5tok6AvXfK3df0fXJaTV+XHdJC9lRIIZE1BCjkGB
 LcHc1hHu6ArJExAbJH35rFvkkOLEWxWx76RIW/GB8o8Xey6f5rZ4NRzf674iVTDx8Hcx
 qPiQ==
X-Gm-Message-State: AOAM533qiDasNa9tnxi0g4ph3jNv4wA+dwLERlAUmRwId2sy6qaebA4q
 HzFayFM8wTsA2KvMIDFfZVgFm8vBR07Vu4fPbPQle6OD+zSOtek5nvhzS4X88/DRN8jKeX1Kt2T
 FyKf0x/4loSHT4bPq/O0GYpD/
X-Received: by 2002:a17:906:b2cd:: with SMTP id
 cf13mr5620149ejb.181.1617223352355; 
 Wed, 31 Mar 2021 13:42:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqxL3J7jbjShgrs5EgrNAd2B78hY43Jwyx1rE3bLvbATiArdEjVf/0Kcaqy2JK8oqTSMxLyw==
X-Received: by 2002:a17:906:b2cd:: with SMTP id
 cf13mr5620121ejb.181.1617223352197; 
 Wed, 31 Mar 2021 13:42:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id ak20sm1761857ejc.72.2021.03.31.13.42.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 13:42:31 -0700 (PDT)
To: Sean Christopherson <seanjc@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
Date: Wed, 31 Mar 2021 22:42:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGTRzf/4i9Y8XR2c@google.com>
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

On 31/03/21 21:47, Sean Christopherson wrote:
> Rereading things, a small chunk of the rwsem nastiness can go away.  I don't see
> any reason to use rw_semaphore instead of rwlock_t.

Wouldn't it be incorrect to lock a mutex (e.g. inside *another* MMU 
notifier's invalidate callback) while holding an rwlock_t?  That makes 
sense because anybody that's busy waiting in write_lock potentially 
cannot be preempted until the other task gets the mutex.  This is a 
potential deadlock.

I also thought of busy waiting on down_read_trylock if the MMU notifier 
cannot block, but that would also be invalid for the opposite reason 
(the down_write task might be asleep, waiting for other readers to 
release the task, and the down_read_trylock busy loop might not let that 
task run).

> And that's _already_ the worst case since notifications are currently
> serialized by mmu_lock.

But right now notifications are not a single critical section, they're 
two, aren't they?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
