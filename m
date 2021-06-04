Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA24C07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 07:24:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80B776141B
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 07:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80B776141B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02DB14B0AC;
	Fri,  4 Jun 2021 03:24:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 72b8lVw-T9QK; Fri,  4 Jun 2021 03:24:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA53F4B0CF;
	Fri,  4 Jun 2021 03:24:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B25594B0AC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 03:24:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BfbMR1wo+FT6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 03:24:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1D1049E8A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 03:24:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622791477;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ElFb664kDca3zTUpMXZCL5Csjp2/nyoNDD9HukhmOHM=;
 b=Hx865z71gJmprjb+XL1Tl7gvzPz+HIenXswn+tkR/+yzDdetufr1QTkKXa4o9pXxuKqsqR
 +d+5XwhIe6lmL9pysrF3IUfOhoqamyGE6fqBKYFsY5rTu4bhsc7Eqp803nupZvjPNgkB06
 0M+nyGIavzYkfOtZkVq+HKQFOuE2Xlw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-zGwiLl80NYuvoT7X4PHWnA-1; Fri, 04 Jun 2021 03:24:34 -0400
X-MC-Unique: zGwiLl80NYuvoT7X4PHWnA-1
Received: by mail-ej1-f69.google.com with SMTP id
 p5-20020a17090653c5b02903db1cfa514dso3034022ejo.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jun 2021 00:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=ElFb664kDca3zTUpMXZCL5Csjp2/nyoNDD9HukhmOHM=;
 b=hxuN6fH/z8d21xpcOa1xMetN7/svhXzNGGnA+E4qWTK/P1FuUa3ncQb8AvS4l6GII+
 7V4kB7QSPcX0h7PCqgDzEB7pMxQZ8pR7SuO1a6sJpwRSLvZJjwVrBi0gESCTESijXoMb
 9dzorNTXywTgfna6ypfFRp1ibHME+URSJsjrkCzKm6r3Z52QhZsykorZAPKvYggi0tK3
 jjFyuyaT73cB4GbEUPr76dzSacFQj/q+xx+69h1P9UV9kiYVo8wUSovL29QUtQsC0n2Q
 IEVJe+FYV6KuftH3PjcwIG8PICdTIVPdOZc89AA2yMM/h0naOCqTWGNLRAIZOp2jRSKR
 5WJQ==
X-Gm-Message-State: AOAM531Rq3KkcBL7f12k7DGMLtqljrczTFCy3kws+nn+eonOWOv7bbnS
 UDYVVY9egEJ71LPRlP5DZ0xvEpGn10uTkYQj9woJ9t0zigFZqKLl+lna0TnMbrGqSOvuu8VLyf6
 c4Hz941fHuScOBzzNUjpm4lQl
X-Received: by 2002:a17:906:1401:: with SMTP id
 p1mr2849924ejc.526.1622791472804; 
 Fri, 04 Jun 2021 00:24:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf6cQzWkBIEpZuWDj8mD3YKNJZw3J7U1/Ic7+UpRFaWTIKLqYoDPaxKjav78eW5CkReqQfnw==
X-Received: by 2002:a17:906:1401:: with SMTP id
 p1mr2849903ejc.526.1622791472650; 
 Fri, 04 Jun 2021 00:24:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id nc26sm2296091ejc.106.2021.06.04.00.24.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 04 Jun 2021 00:24:32 -0700 (PDT)
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <87a6o614dn.fsf@vitty.brq.redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e4b4e872-4b22-82b7-57fc-65a7d10482c0@redhat.com>
Date: Fri, 4 Jun 2021 09:24:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87a6o614dn.fsf@vitty.brq.redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: linux-s390@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Sean Christopherson <seanjc@google.com>,
 Suleiman Souhlal <suleiman@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On 04/06/21 09:21, Vitaly Kuznetsov wrote:
>>   
>>   	preempt_notifier_inc();
>> +	kvm_init_pm_notifier(kvm);
>>   
> You've probably thought it through and I didn't but wouldn't it be
> easier to have one global pm_notifier call for KVM which would go
> through the list of VMs instead of registering/deregistering a
> pm_notifier call for every created/destroyed VM?

That raises questions on the locking, i.e. if we can we take the 
kvm_lock safely from the notifier.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
