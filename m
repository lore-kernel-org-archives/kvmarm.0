Return-Path: <SRS0=NHQQ=I4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4AAC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 19:49:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6592A619B9
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 19:49:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6592A619B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B564B19B;
	Tue, 30 Mar 2021 15:48:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sDhup82LkQnM; Tue, 30 Mar 2021 15:48:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E9B4B324;
	Tue, 30 Mar 2021 15:48:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04DD04B322
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 15:48:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7TO1PjeNx3-k for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Mar 2021 15:48:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4504B303
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 15:48:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617133735;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OzWHBGLRQSImyi4e0nOZKdQoWKxewGVgAE+CFb4wwPc=;
 b=iSlCGRs6VCjQoCeBwC0vXZ0lDdqTqqW3cQT5ZJy9e9xTJ2Hp9tMYBi+gH4uaHVycwz2wQC
 0SgkHVHjJFNnhaWQLAgOU++Cdhi5uNX/riq3rBL00yFO37amxwAzIu5uEiDhZPEtebPK0U
 7KAq4R3SdvXRzm85kUAmme1vH0pLPyM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-LjnVoENhMVaShXgtDdbTfQ-1; Tue, 30 Mar 2021 15:48:53 -0400
X-MC-Unique: LjnVoENhMVaShXgtDdbTfQ-1
Received: by mail-wm1-f70.google.com with SMTP id c7so1035784wml.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 12:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=OzWHBGLRQSImyi4e0nOZKdQoWKxewGVgAE+CFb4wwPc=;
 b=TBR3H2x1FHutW/fOOcVbijxjRgJM1JQCSJONdzXBcgFJL4gbuu/iqJubHJdzh+GTYr
 2RPpozgJl8MUJ0lUS74xDCsbrCc0EloIHCJmnVzeqQ+3ENS8QjcAvqmQR8xey8U8GZrG
 6CSeKljw1OSk61y2wDbuGCDuskEtrdeBZHphqUUnAIQaAdEljlesGrk+uWkirsFoHKDl
 VYLsM6xZJJtqqilIRKGnYsaxogI8PaUuyMo8L6nBZ0lziCqWkRQ2fdSwVHX8KsSuW1NB
 KqJlIyC0lHQKFLHRdbVH8fYuA+efx+/bJYjYP4QnG+6XxdmKOnBeAmZZWwFvbcW8nNAK
 aDBg==
X-Gm-Message-State: AOAM5330z+NTcU44gXYPSWM+dv+CgCoUM6vxcGJnnqu0J4GTxf85v+2l
 qWxgokgltxkk4GKjC8i9IaUaW/hXUzEbZ+wY0DHLVR5ujA7I3rwfrAW8x0ychrE/z3WKfbK94ek
 JaJ2yUddZ+CiyoZSw+geCUpIz
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr5514404wmh.11.1617133732295;
 Tue, 30 Mar 2021 12:48:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrWDuYw2HfRbOt7weQUpuJCXUwrbqFmeFadK3gLejd+/RrcU8+0Fo4iU0Fj3iEAf2A+hbNXA==
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr5514373wmh.11.1617133732072;
 Tue, 30 Mar 2021 12:48:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id w11sm37459472wrv.88.2021.03.30.12.48.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 30 Mar 2021 12:48:50 -0700 (PDT)
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
To: Ben Gardon <bgardon@google.com>, Sean Christopherson <seanjc@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3a1dd877-7421-7628-4214-30483c4de10f@redhat.com>
Date: Tue, 30 Mar 2021 21:48:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On 30/03/21 20:32, Ben Gardon wrote:
>> Patches 1-7 are x86 specific prep patches to play nice with moving
>> the hva->gfn memslot lookups into common code.  There ended up being waaay
>> more of these than I expected/wanted, but I had a hell of a time getting
>> the flushing logic right when shuffling the memslot and address space
>> loops.  In the end, I was more confident I got things correct by batching
>> the flushes.
>>
>> Patch 8 moves the existing API prototypes into common code.  It could
>> technically be dropped since the old APIs are gone in the end, but I
>> thought the switch to the new APIs would suck a bit less this way.
> Patches 1-8 look good to me. Feel free to add my Reviewed-by tag to those.
> I appreciate the care you took to make all those changes tiny and reviewable.
> 

Just finished reviewing that part too, they were very nice and I've 
queued them.  I'll continue tomorrow with the rest.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
