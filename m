Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A61EC43462
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 21:36:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8553A610CE
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 21:36:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8553A610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CF7C4B4E2;
	Wed, 31 Mar 2021 17:36:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TFRytqIzc5C1; Wed, 31 Mar 2021 17:36:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C7C4B4E6;
	Wed, 31 Mar 2021 17:36:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12A7E4B4E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RQaK0DjCxVoa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 17:36:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C7E34B3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:36:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617226602;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CEkfAOJSRgLmrcmogejiwM3z3x7Jp11CwOAYIRJU/eA=;
 b=V1uvJEW0kvpG1M+e31bQhBjicjCjiCOpBWu6AmCYWLLEn9gYeuaAA/YIVSfObeqtNMs4vK
 lF7wCl7/qZJ+SpLyKqyGCy2byrDBJ8vBUrnGSFAchNQpIWttsxac+8pYUUTjl6uZYRoGR+
 SZwhD1XXLesNu+1HtNcUiHw0AcjbaHw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-rgxE6HUZN8-J9m8kxvbeVQ-1; Wed, 31 Mar 2021 17:36:38 -0400
X-MC-Unique: rgxE6HUZN8-J9m8kxvbeVQ-1
Received: by mail-wr1-f70.google.com with SMTP id f3so1623489wrt.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 14:36:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=CEkfAOJSRgLmrcmogejiwM3z3x7Jp11CwOAYIRJU/eA=;
 b=SF9oLxXFNY1qyJWlruShVpyT2cAf4J8cN+Y5UL4A6kHxHZ18zM5kCg2kcifjln+eHn
 udCeOwFrydRgMLZLCQhSxZVnzdOMAEdPlgNowIggJ5L02pRPm2gXICgZOZFi4+kA3M9I
 NfMnKTR0D95nFKMeSrgNIg/jr7bX6jAS/MydLGvqFlRi6FraYbve3IRQP9mxCxs7Oave
 +bR/+NyXc1Ia/0i1SnqFiFT0uKsRIBfdFJXy5v0GBMrF5mZdK14nBFL0SK1vo+P3QNE7
 rCSEgMmeenTtUCf+wCE0PMdPKoXzVfRcnNQ96fb4M0+bKg7DGh791NQlK3wQC/uGrIQo
 orTQ==
X-Gm-Message-State: AOAM532oPoFhQVcW43e5udE49czolTiT8JrmZlvaa5Kgy3K4izMyQoSi
 25eS7a+wgA1l9mHY46q0LogaUy+4mgQDqbcDulSpKsMPAQhTVkvsb7SK3Ueim7RnbU+dlayZZZ2
 gRAF0InxQ2whs6q76wHF0U2P2
X-Received: by 2002:a5d:6a81:: with SMTP id s1mr5824705wru.401.1617226596849; 
 Wed, 31 Mar 2021 14:36:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxj/Cy9ZlL8PU/jQIPYrj7YXyx+xnD7LhAYpJqpR2c8LjROVyn4i4Jg6Wqcll5JYmuGcjgzQ==
X-Received: by 2002:a5d:6a81:: with SMTP id s1mr5824690wru.401.1617226596681; 
 Wed, 31 Mar 2021 14:36:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id u63sm5728603wmg.24.2021.03.31.14.36.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 14:36:36 -0700 (PDT)
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To: Sean Christopherson <seanjc@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
 <YGTkLMAzk88wOiZm@google.com> <YGToGBvdfPiCr3WA@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <743a31e7-03ba-0c64-86ac-c5a0aac4121c@redhat.com>
Date: Wed, 31 Mar 2021 23:36:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGToGBvdfPiCr3WA@google.com>
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

On 31/03/21 23:22, Sean Christopherson wrote:
> On a related topic, any preference on whether to have an explicit "must_lock"
> flag (what I posted), or derive the logic based on other params?
> 
> The helper I posted does:
> 
> 	if (range->must_lock &&
> 	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
> 		goto out_unlock;
> 
> but it could be:
> 
> 	if (!IS_KVM_NULL_FN(range->on_lock) && !range->may_block &&
> 	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
> 		goto out_unlock;
> 
> The generated code should be nearly identical on a modern compiler, so it's
> purely a question of aesthetics.  I slightly prefer the explicit "must_lock" to
> avoid spreading out the logic too much, but it also feels a bit superfluous.

I do as well, but I hope we don't need any lock after all as in the 
email I've just sent.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
