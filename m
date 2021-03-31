Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9DAC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 21:00:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F15261075
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 21:00:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F15261075
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1BDF4B4FE;
	Wed, 31 Mar 2021 17:00:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e966GOm6Mwtj; Wed, 31 Mar 2021 17:00:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE95B4B4D8;
	Wed, 31 Mar 2021 17:00:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 165344B4D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:00:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SkvvO5JqBjIi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 17:00:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EF644B494
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:00:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617224424;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2LQqUVLUZYdl8RcTGPBOfvhnoH130Hf3/RpFvvu9duY=;
 b=XatB7QejBZNsCIdTlnbGqNfhVWokTxeLOX9iNKt5V+JhNXup4AQ1fdSX1vVzrrHeIcUA60
 cPTzpFdkfNCslWHuG7pvw2kagXS13Fjtbcu+mDF5ot8AHT/+QCKijTuwlLG7DQnbqgToJV
 SDCBaoBwyzZjeyCuw3LL8JrX0LknkyU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-zgx7vI5-Pu2auIahrQwEgw-1; Wed, 31 Mar 2021 17:00:22 -0400
X-MC-Unique: zgx7vI5-Pu2auIahrQwEgw-1
Received: by mail-ej1-f70.google.com with SMTP id r26so1352346eja.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 14:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=2LQqUVLUZYdl8RcTGPBOfvhnoH130Hf3/RpFvvu9duY=;
 b=DUtZ7uylv6bN4zweya87Jal+Cid5bt/iHSavHEThXJCXfwAYsBjQ7tv78hbKKw0RtO
 p2OplzymztqgRFE2dyj0PRHCTEpIDAOYe63LlqJRXN4HdBkqe1HtEZcn7Dx/5ttEJy2q
 ftJ0Kjne5hxF/tGRoc2S99rbZWedLybi0/E0YTkfA8PzI8qA7GlrV2UXUfF63S6GOGBz
 k/AlQcEjREqvDAHyGhlImh1Lwq7tFf2XvrnEa1Sf/8OArqQ5EwXK6Y5iiMVqFEu6nkt1
 NcZBeEuVgvxTqdh2LN2WHR9w8k8Di410iV1rqXl3A6PKkvUNgom51h6pZtbRy+t79xtm
 o11w==
X-Gm-Message-State: AOAM531hp5dc9k1rM83k0mGb3YS0fjwvAIjqoZnHek7vaituu7KXDWPl
 mAzgrSyEL02vJJ/GJWQVO58BHCa26mzWcMefvnPaKUYVRPpvsRTK5zOohIgC9XJI8jGq+j21lUB
 7kWZAwZm9Ci8YVNNsyGr1uxz7
X-Received: by 2002:aa7:d3ca:: with SMTP id o10mr6104413edr.374.1617224421716; 
 Wed, 31 Mar 2021 14:00:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw50R87T4Vu7z/jVciLQACACQ+dsOT5/iwXfrDvSvIyaxglINHwXnv99OCNOBQhJmcFA6BI0w==
X-Received: by 2002:aa7:d3ca:: with SMTP id o10mr6104376edr.374.1617224421543; 
 Wed, 31 Mar 2021 14:00:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id x21sm2291820eds.53.2021.03.31.14.00.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 14:00:20 -0700 (PDT)
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To: Sean Christopherson <seanjc@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGTg/AWdieMM/mS7@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <60357fd0-d412-fe47-8023-8107a60ade7e@redhat.com>
Date: Wed, 31 Mar 2021 23:00:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGTg/AWdieMM/mS7@google.com>
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

On 31/03/21 22:52, Sean Christopherson wrote:
> 100% agree with introducing on_lock separately from the conditional locking.
> 
> Not so sure about introducing conditional locking and then converting non-x86
> archs.  I'd prefer to keep the conditional locking after arch conversion.
> If something does go awry, it would be nice to be able to preciesly bisect to
> the conditional locking.  Ditto if it needs to be reverted because it breaks an
> arch.

Ok, that sounds good too.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
