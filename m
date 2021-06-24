Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD75BC49EA5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 09:42:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DF85613F9
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 09:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DF85613F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0C54B25C;
	Thu, 24 Jun 2021 05:42:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ph6XaBrhPzOL; Thu, 24 Jun 2021 05:42:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 969864B25D;
	Thu, 24 Jun 2021 05:42:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 702B04B248
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 05:42:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id chnkpSOz8R3X for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 05:42:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 985B34B245
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 05:42:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624527759;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jyD4vH5kMZavgg+0al23ybbW1mNcrfB3c+Wxr6kYX38=;
 b=Dg09Q1JBF1FT2yGNlpUzg5ZmMVjnOBAvUUr/3l3rEgNzCEWl6NxXAbpZOaTky7eftJRdKJ
 oLpHNwtWiHd3s5w1WybrIvw/U5xAXkcr7IYk7Yf6x3VaO8BxsZglrteqpEmK2bmTaeJjz8
 YWZIaYY8hOjiyj/sr/s0Lnv4p8Zlgy0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-J-JkuRHpPOKHqIr5IpQt2A-1; Thu, 24 Jun 2021 05:42:38 -0400
X-MC-Unique: J-JkuRHpPOKHqIr5IpQt2A-1
Received: by mail-ed1-f72.google.com with SMTP id
 j15-20020a05640211cfb0290394f9de5750so2458223edw.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 02:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=jyD4vH5kMZavgg+0al23ybbW1mNcrfB3c+Wxr6kYX38=;
 b=S4b8omS5Fwofl4YxWXr29fG/DqLG34J4XphaepiGxjWWrPGpFHwMz67SSFtxKKJ/bW
 I74vY1rG1qT+kNMlV24SzBW6sZu9sykVbhgC0Bt4I0NuUDYTDMt6aLQ5jW+AOnPch8/x
 MQrAx4CcmVHOC/RiSMU2pwmcQDPabBDLqtpHT++v1eELygeIVl4E31TCOBiAWAc6MALB
 7T4bJ7+To3d8vjVWPqWAXtYcPy6U+qBRO0IS15pl+8i3bg7wKfVp9coIjmsaKyLO4cni
 BJ4jljjAIUGMhee1nTEq4WxgioDsj4IHIoKqq8jsATqTYJcDkum1qVL0S0bdNjXMc6m0
 qgyA==
X-Gm-Message-State: AOAM531PEJ5kEwEBmwgrjyCh4k8K9lPNLkHv7NrGj6A5odclfMKClOpa
 A8UTZu7YpZ0kV5ewgXoBe49pDYP5DMqSoANbJ4jpP8Ney/8M+gK4j5AgkkJFBzQQcYJ/R01BxcU
 UhvW7SSCkSj9TQol6ff1LXb2d
X-Received: by 2002:a05:6402:54c:: with SMTP id
 i12mr5909991edx.64.1624527756951; 
 Thu, 24 Jun 2021 02:42:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUADYaxbQu5a0ZM6V5UX0tysDgP0Lb+XMxpzsUfVTNQ4yl7MEG7UQrmtC4bLiXvUVljS3Ohw==
X-Received: by 2002:a05:6402:54c:: with SMTP id
 i12mr5909945edx.64.1624527756727; 
 Thu, 24 Jun 2021 02:42:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id jz27sm944475ejc.33.2021.06.24.02.42.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Jun 2021 02:42:35 -0700 (PDT)
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To: Nicholas Piggin <npiggin@gmail.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, David Stevens <stevensd@chromium.org>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-3-stevensd@google.com>
 <1624524331.zsin3qejl9.astroid@bobo.none>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
Date: Thu, 24 Jun 2021 11:42:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624524331.zsin3qejl9.astroid@bobo.none>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 kvm-ppc@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mips@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org, Joerg Roedel <joro@8bytes.org>,
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

On 24/06/21 10:52, Nicholas Piggin wrote:
>> For now, wrap all calls to gfn_to_pfn functions in the new helper
>> function. Callers which don't need the page struct will be updated in
>> follow-up patches.
> Hmm. You mean callers that do need the page will be updated? Normally
> if there will be leftover users that don't need the struct page then
> you would go the other way and keep the old call the same, and add a new
> one (gfn_to_pfn_page) just for those that need it.

Needing kvm_pfn_page_unwrap is a sign that something might be buggy, so 
it's a good idea to move the short name to the common case and the ugly 
kvm_pfn_page_unwrap(gfn_to_pfn(...)) for the weird one.  In fact I'm not 
sure there should be any kvm_pfn_page_unwrap in the end.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
