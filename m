Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4C9C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 12:48:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20D9564DE4
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 12:48:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20D9564DE4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42E894B18B;
	Thu, 28 Jan 2021 07:48:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 001zFoXoeTH8; Thu, 28 Jan 2021 07:48:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49DEB4B15B;
	Thu, 28 Jan 2021 07:48:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E00C4B15B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 07:48:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oh1A9BwQ7PEa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 07:48:34 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08C14B10E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 07:48:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1611838114;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EUPoogxEubiZKmDpms6g+giQK6dPAk2ieocombt6yus=;
 b=NQw/EP0itxRlf6dO9mdq7J1v92xAlW3AaxdVtLdllHih6kj7RjVw1DGwZZDnv/1kGJdsut
 DgKbnmWH1nuLGXenmHT0Ac2/ZSZGItdDUr3537IPvsh34fxlxEOGprfMcXNu1RUa1ocVRf
 MpHZTzfHaihVR2RS3XUIs1y0qRc+E2Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-8Q3v-sJdNOKaDc3hKUYnNA-1; Thu, 28 Jan 2021 07:48:30 -0500
X-MC-Unique: 8Q3v-sJdNOKaDc3hKUYnNA-1
Received: by mail-ed1-f71.google.com with SMTP id r4so3116312eds.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 04:48:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=EUPoogxEubiZKmDpms6g+giQK6dPAk2ieocombt6yus=;
 b=hXhEIqJvkaegTP+xc7+uwbFgnGdNR82bW/ReBfpbEjPoV5RWcKHKgSIXZHH61bMKc/
 +3zw4Ui2T0ipq84c7pDsWsXdsvTDtL6eKgPP5AKpNeXEBJyDR9AegIkeGd43WJNuYBAW
 IA6gLKrel2yAYQujO18PwJnCL6J9F/qnaIfjqky/KIW/lezuwcLavSozJFaF8qqqHdx3
 CUzmZ/mNOUv8WiqHIhXcjYPQ31zaRe646l3sS6JnY6qhMYAcEp+My2An8yOEBBVxvZ5x
 izuyDYz/C5BmdRy/HXqimlAJ3QAnn/9zdaQfmO7/b1sftIwcHnEGP3GmjIDla9TDZUGv
 MkRw==
X-Gm-Message-State: AOAM5305oZ0kRYw4nZu+z2Lf7qGPOT0CvoqWWqVW1JgKwZGbStnOJrV6
 vglGxHqZOkcvfPUp/ipRPug2c3kwfuQ1NWqeklky+dlqckMu1dw/FFnL0QKprECg2vrie/hZmpZ
 n/0P+vYMmo+JdYsqj+uHOge/0
X-Received: by 2002:a17:906:1741:: with SMTP id
 d1mr11214356eje.182.1611838109749; 
 Thu, 28 Jan 2021 04:48:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/JAyUJF7PPPKqjMCwpTENChv61cKhvZqdnrTgL4rLTXUDksn14ITZ3hGVKqvIogwfrKLeYA==
X-Received: by 2002:a17:906:1741:: with SMTP id
 d1mr11214320eje.182.1611838109554; 
 Thu, 28 Jan 2021 04:48:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id x9sm2247425ejd.99.2021.01.28.04.48.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 Jan 2021 04:48:28 -0800 (PST)
Subject: Re: [PATCH v3 0/2] KVM: x86/mmu: Skip mmu_notifier changes when
 possible
To: David Stevens <stevensd@chromium.org>,
 Sean Christopherson <seanjc@google.com>
References: <20210128060515.1732758-1-stevensd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c01b01dc-c636-1d1b-fb42-df718e23d20a@redhat.com>
Date: Thu, 28 Jan 2021 13:48:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210128060515.1732758-1-stevensd@google.com>
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

On 28/01/21 07:05, David Stevens wrote:
> These patches reduce how often mmu_notifier updates block guest page
> faults. The primary benefit of this is the reduction in the likelihood
> of extreme latency when handling a page fault due to another thread
> having been preempted while modifying host virtual addresses.
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
>   arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++------
>   arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
>   include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
>   virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
>   6 files changed, 65 insertions(+), 16 deletions(-)
> 

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
