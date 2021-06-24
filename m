Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4F4C49EA7
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 09:43:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 855A9613FA
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 09:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 855A9613FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 097584B253;
	Thu, 24 Jun 2021 05:43:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b9L09-+-qQB2; Thu, 24 Jun 2021 05:43:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D09324B25F;
	Thu, 24 Jun 2021 05:43:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7EE14B253
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 05:43:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w+vU5MqbjBDA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 05:43:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7E484B20A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 05:43:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624527817;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qkxHw284a/HcUQKczqJcr3hZxs0a/eNZzaMIqcieCR4=;
 b=N2dmpoXd8h1tJ/1jVQ8EadWoXvdJ00hsKd76ingRURI7ArP7YM3OVAqgd5iCcGtLbxK3C7
 J0rwSiQGm1W62yubsHJcsSZWAiwG+R6YTX3bMtLXDw+7oAc+B11Z/3FqYtBXdPD45Pcc9x
 UB6haCnVbw5AnTQduuhTYeNyrGJRGKk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-7GAwkTWeP4KIrrcSq3hI7Q-1; Thu, 24 Jun 2021 05:43:36 -0400
X-MC-Unique: 7GAwkTWeP4KIrrcSq3hI7Q-1
Received: by mail-ed1-f71.google.com with SMTP id
 v8-20020a0564023488b0290393873961f6so3032647edc.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 02:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=qkxHw284a/HcUQKczqJcr3hZxs0a/eNZzaMIqcieCR4=;
 b=q0QH+fx3122Bqvrw0fLWuoEcHi76p2YDECWIJDCNNisMJeNY7C06ItTpzMkmMxAI1D
 IQJi5lh2dYUhxJagT9OuCu2gGHKUKPGIPlJQpxwCpTqG5INtijuPF5YzScuLKi++Bl58
 lB96/HiweORjTfdB/lkf2EjepuTZ1KYIvFO8zHFMS+s5Rlv/7ZjsC8ixlq1wJRILnh4C
 tsiPybHBQRSwB4x+pq5Bih0UMP+eTSeHPCpk8tdp+U5WXWsnVNTlkzPr7mp9SxBwsvEX
 RFUbq56P2S55qFyJfjFwPSadndWtoI3yYH7qP+is5437M14BhpcowSfOzefLHK4xD4EW
 8AvA==
X-Gm-Message-State: AOAM530aztgZwF8nFB5gv69mGpkIb84iAnwDwTz4MT+lMxnTUeRYVBBs
 pDKAsx9sG9ZOb/3rNzOhGSqQ8vjb3zos7Xtf8VrNz6LWGlmv54zNOxsE3jcE8WHQrSjMvw8vWyM
 92++GGxoYTh14UVYvOl7iBk17
X-Received: by 2002:a05:6402:944:: with SMTP id
 h4mr5798149edz.76.1624527815210; 
 Thu, 24 Jun 2021 02:43:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwD6cFFU4Uspcy5dTYBfn7A0VR+4loxnlaoo/QjHY9IN1nmjQ4mSQ+4egclMkG5+RC1oGdqOg==
X-Received: by 2002:a05:6402:944:: with SMTP id
 h4mr5798117edz.76.1624527814999; 
 Thu, 24 Jun 2021 02:43:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id t17sm1544705edv.75.2021.06.24.02.43.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Jun 2021 02:43:34 -0700 (PDT)
Subject: Re: [PATCH 1/6] KVM: x86/mmu: release audited pfns
To: Nicholas Piggin <npiggin@gmail.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, David Stevens <stevensd@chromium.org>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-2-stevensd@google.com>
 <1624524156.04etgk7zmz.astroid@bobo.none>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4816287a-b9a9-d3f4-f844-06922d696e06@redhat.com>
Date: Thu, 24 Jun 2021 11:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624524156.04etgk7zmz.astroid@bobo.none>
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

On 24/06/21 10:43, Nicholas Piggin wrote:
> Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
>> From: David Stevens <stevensd@chromium.org>
> 
> Changelog? This looks like a bug, should it have a Fixes: tag?

Probably has been there forever... The best way to fix the bug would be 
to nuke mmu_audit.c, which I've threatened to do many times but never 
followed up on.

Paolo

> Thanks,
> Nick
> 
>>
>> Signed-off-by: David Stevens <stevensd@chromium.org>
>> ---
>>   arch/x86/kvm/mmu/mmu_audit.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
>> index cedc17b2f60e..97ff184084b4 100644
>> --- a/arch/x86/kvm/mmu/mmu_audit.c
>> +++ b/arch/x86/kvm/mmu/mmu_audit.c
>> @@ -121,6 +121,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
>>   		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
>>   			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
>>   			     hpa, *sptep);
>> +
>> +	kvm_release_pfn_clean(pfn);
>>   }
>>   
>>   static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
>> -- 
>> 2.32.0.93.g670b81a890-goog
>>
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
