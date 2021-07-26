Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A65FC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:41:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99ACE60524
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 99ACE60524
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2800F4A4A0;
	Mon, 26 Jul 2021 09:41:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0HqFwfKnH1II; Mon, 26 Jul 2021 09:41:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8B44A1A5;
	Mon, 26 Jul 2021 09:41:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C0E949F92
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:41:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SC0ziJtgylVv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 09:41:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 185B549E50
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:41:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1627306873;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iwb+gJ5kZupdhuNB/HcDQBwyIfUYDI68vwzalsg6VHw=;
 b=U4X4iDQOSh2zIFRsXKCqbVwmVGSiZxCzDTGoSrqkEa4Y0PysciG6fWM8tdjuxhmzPL0W4/
 3b6TsFbgwaW2UcE/RI54Y3A88HodkoSjXNklDt3UD2dFPtfU7aOc0sPr2iQOMqmIub6nvH
 j2v/Q6d31mtZP0/IpkGA8xENz5CZCxI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-5ekpUF60M_mI05fOikZcSQ-1; Mon, 26 Jul 2021 09:41:12 -0400
X-MC-Unique: 5ekpUF60M_mI05fOikZcSQ-1
Received: by mail-ej1-f72.google.com with SMTP id
 hb18-20020a1709071612b029052883e9de3eso2060187ejc.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 06:41:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=iwb+gJ5kZupdhuNB/HcDQBwyIfUYDI68vwzalsg6VHw=;
 b=UPb93kdgiDXMYWbf0iV5H+ZD4T4DdrY4H27G/onHgEINCy2b47Hse3jORCBw6d1+fH
 /tH3VYMJr96D1xzgxq9e0Vci4YZiOPjhMTxcNZFJwWcbFxsrS6XaYnqsGmfDM6r0Ovca
 UH3EB5jdLW9U0W6hARMMXHv1dljdliR07uUgNiuu05mDGqVUw7MKMrR/3dY3+dcshBWU
 Wvf/zjTIL8QsA3fgoQ3b7v6GETuqZImOwDT/ZpLDwxTGEJ8eMPSrFHxjHpkoN6zRtaxq
 OKkmXtU25TK35oY+B4rVjhbEA2ddW2d+7t7fQHKMKWUyEBdBKmv6nZRtGMuAe+dIUmkE
 OaSg==
X-Gm-Message-State: AOAM530z3Tz/b1FhmehHuLAQbTVqQfLUU9s5bojpl5UKm6MIDqE7t69s
 LHg1N4ATqwgHQP5JMrr5eDtgRAcslwRjL9Ob4WMCODnWijhoTE3bzJcbwJHtIN2gXmLmxm/3Bku
 O1wu5TaFQSi4W46oo/sKTVcYtJ524pXkszZYf6z5q5bkK1Mb7mStgpcL3F7EPCTPCPBiSga7ke6
 Sy
X-Received: by 2002:a17:907:62a7:: with SMTP id
 nd39mr17088044ejc.502.1627306871244; 
 Mon, 26 Jul 2021 06:41:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzT0bYvy/TK8+n6Y6c+hBewPc87dvCIB4DeEysL1icefAhm31DZ7CDgxzd8DglLWWJepno96g==
X-Received: by 2002:a17:907:62a7:: with SMTP id
 nd39mr17088011ejc.502.1627306871006; 
 Mon, 26 Jul 2021 06:41:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id c15sm12639677edu.78.2021.07.26.06.41.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 26 Jul 2021 06:41:10 -0700 (PDT)
Subject: Re: [PATCH 0/6] x86/kvm: add boot parameters for max vcpu configs
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20210701154105.23215-1-jgross@suse.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b05371ad-05e3-9d99-702e-d8296be492f0@redhat.com>
Date: Mon, 26 Jul 2021 15:41:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
 Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Jim Mattson <jmattson@google.com>
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

On 01/07/21 17:40, Juergen Gross wrote:
> In order to be able to have a single kernel for supporting even huge
> numbers of vcpus per guest some arrays should be sized dynamically.
> 
> The easiest way to do that is to add boot parameters for the maximum
> number of vcpus and the highest supported vcpu-id overwriting the
> normal default.
> 
> This patch series is doing that for x86. The same scheme can be easily
> adapted to other architectures, but I don't want to do that in the
> first iteration.
> 
> In the long term I'd suggest to have a per-guest setting of the two
> parameters allowing to spare some memory for smaller guests. OTOH this
> would require new ioctl()s and respective qemu modifications, so I let
> those away for now.
> 
> I've tested the series not to break normal guest operation and the new
> parameters to be effective on x86. For Arm64 I did a compile test only.
> 
> Juergen Gross (6):
>    x86/kvm: fix vcpu-id indexed array sizes
>    x86/kvm: remove non-x86 stuff from arch/x86/kvm/ioapic.h
>    x86/kvm: add boot parameter for maximum vcpu-id
>    x86/kvm: introduce per cpu vcpu masks
>    kvm: allocate vcpu pointer array separately
>    x86/kvm: add boot parameter for setting max number of vcpus per guest
> 
>   .../admin-guide/kernel-parameters.txt         | 18 +++++++
>   arch/arm64/kvm/arm.c                          | 28 +++++++++--
>   arch/x86/include/asm/kvm_host.h               | 22 ++++++---
>   arch/x86/kvm/hyperv.c                         | 25 +++++++---
>   arch/x86/kvm/ioapic.c                         | 14 +++++-
>   arch/x86/kvm/ioapic.h                         |  8 +--
>   arch/x86/kvm/irq_comm.c                       |  9 +++-
>   arch/x86/kvm/x86.c                            | 49 ++++++++++++++++++-
>   include/linux/kvm_host.h                      | 17 ++++++-
>   9 files changed, 160 insertions(+), 30 deletions(-)
> 

Queued patches 1-2, thanks (1 for stable too).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
