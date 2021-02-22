Return-Path: <SRS0=UwAz=HY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E0FC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 18:17:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AB9264F48
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 18:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AB9264F48
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD95D4B100;
	Mon, 22 Feb 2021 13:17:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5MqndBQVpq9; Mon, 22 Feb 2021 13:17:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC9A94B16E;
	Mon, 22 Feb 2021 13:17:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A6D64B0EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 13:17:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9O4dR9yhJaHd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2021 13:17:12 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF234B0EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 13:17:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1614017831;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=M1O2O9X5RXSfF+m5PX0DyBo6+zLejZgNhGtzl18mwLU=;
 b=BpLHvwK+O0WLRdZh7iss5uIrieQbaCXZ+pCQJS2XC/fMRp07GvFEyuozyGJSgXckQVi05b
 ZIveQ+Q2y2ovnrPtbiIbk39C1KcXMmt6eaZlAuvHvt67VohkOL3Gx8PsIG29PxCJYX/V57
 hp8abx2vwtE9w7adVGWoKLy3Q8/5/AQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-KV5OxUQKOCytqyICIYI06A-1; Mon, 22 Feb 2021 13:17:09 -0500
X-MC-Unique: KV5OxUQKOCytqyICIYI06A-1
Received: by mail-ed1-f71.google.com with SMTP id t18so5682296edr.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 10:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=M1O2O9X5RXSfF+m5PX0DyBo6+zLejZgNhGtzl18mwLU=;
 b=MbyYwhhObpKx32xvl18Baa3HUZfaosjopFL6qaLqcm7SbL13AOZzvHwZOi4BMeSY/E
 JJUpguqrnX8G6KchB2kjC4lVFuUBIgSDNR8DZLQhxrjYcVJJekRDRh6CQAChQXorDgMe
 YGcQ7BodIrzWpN6TmqLUntcc5Df4KhZbaU7SK0Vpn2A4s3lgAXu7p/SoBtsAZx6dPtUP
 YBuO7F2xvfzWZaTyIeIqmVaM9KIWs+TtCqZt4xlqbd53qmvwhMfD1l4sLEPdGkqeLnKi
 IOJ2CFz3nPhXGxVY1Ne9GF+uuy14orGtF5lUCFMzhkbUpnwA/53hT3PLbvfcPoqoG3v+
 MDZw==
X-Gm-Message-State: AOAM533SuHSh14sdkfGB/wIulJzOYiorwJt0XPxf+sC6I6Wzdecj58qt
 yJ8CfmuQNtW5KLGl3n8b4LQA98PK9CaZ4RlvP5zd1qTL7HedId7SVIjv9J0+y1TRliy+T9vm9pd
 vTCwQCxIhzGCzBUrspLl2bXy8
X-Received: by 2002:a17:906:1c4f:: with SMTP id
 l15mr11171188ejg.148.1614017828702; 
 Mon, 22 Feb 2021 10:17:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzT03kSWOr2tXOOmqkmqccMekugd1GPN0H9nHYrXxVs3CozSxxVXGpHmYF/OdiWxYx0Hw1ilw==
X-Received: by 2002:a17:906:1c4f:: with SMTP id
 l15mr11171153ejg.148.1614017828484; 
 Mon, 22 Feb 2021 10:17:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id d5sm12773936edu.12.2021.02.22.10.17.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 22 Feb 2021 10:17:07 -0800 (PST)
Subject: Re: [PATCH v4 0/2] KVM: x86/mmu: Skip mmu_notifier changes when
 possible
To: David Stevens <stevensd@chromium.org>,
 Sean Christopherson <seanjc@google.com>
References: <20210222024522.1751719-1-stevensd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7fe10f74-e183-411a-468b-93fcdf786bb6@redhat.com>
Date: Mon, 22 Feb 2021 19:17:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222024522.1751719-1-stevensd@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, David Stevens <stevensd@google.com>,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
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

On 22/02/21 03:45, David Stevens wrote:
> These patches reduce how often mmu_notifier updates block guest page
> faults. The primary benefit of this is the reduction in the likelihood
> of extreme latency when handling a page fault due to another thread
> having been preempted while modifying host virtual addresses.
> 
> v3 -> v4:
>   - Fix bug by skipping prefetch during invalidation
> 
> v2 -> v3:
>   - Added patch to skip check for MMIO page faults
>   - Style changes
> 
> David Stevens (1):
>    KVM: x86/mmu: Consider the hva in mmu_notifier retry
> 
> Sean Christopherson (1):
>    KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault
> 
>   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
>   arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
>   arch/x86/kvm/mmu/mmu.c                 | 23 ++++++++++++++------
>   arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
>   include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
>   virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
>   6 files changed, 72 insertions(+), 16 deletions(-)
> 

Rebased, and queued with the fix that Sean suggested.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
