Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40300C352BE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 15:56:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5BD4221F7
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 15:56:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ID5DZtvH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5BD4221F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B3904B192;
	Thu, 16 Apr 2020 11:56:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e9gemXNIYJ9P; Thu, 16 Apr 2020 11:56:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 978054B145;
	Thu, 16 Apr 2020 11:56:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55E124B142
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 11:56:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QIQLOAKf8D2Y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 11:56:01 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9344B141
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 11:56:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587052561;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nvu+MW6oZUAc4Rt+d0KHMjWiSPVqXx7NpVhFclBCSuA=;
 b=ID5DZtvH9sTXEpFaffj3HRg4lfpKkzt5Eql5S3WZluccUKLn/MODDhQWE18HIm5N2+o4W6
 asQly0N2VAinsyOyxwMOkrAU2pfROdRYIjOTof9z9sYOK4B87LKnuPmwemuOcnsvGp8xcS
 DnzXGw1KxO02JWd4zJwfczZdXbSCFPY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-Rp0032PYP22EacD_DxQ8zg-1; Thu, 16 Apr 2020 11:55:59 -0400
X-MC-Unique: Rp0032PYP22EacD_DxQ8zg-1
Received: by mail-wr1-f72.google.com with SMTP id e5so1915179wrs.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 08:55:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=nvu+MW6oZUAc4Rt+d0KHMjWiSPVqXx7NpVhFclBCSuA=;
 b=JskTQkJrY3gVnDGZj/jIVCsouCGZaMW1d3hn9Rg43Fk3MUDOcykZuleR301P1/nJc0
 3lzXKxzIImmhCsDHspaJ+XbACkt0qdxCU192+DboGp6ZEvQQDuo2Axb7fWc8r1A+I8fX
 RfLUZp79/rSO+kYttFUZV2nJopMtUGq1DXMxX4F/CY+c/IfqOOZywCbYK+DUs7TRzmRU
 94cxEWemRy6kLW6ucPg8dN7BAcsRLa2Nfmm3dNppDf8nRHwtjzuV2arMQ3zs6x2WQMjD
 GdLn7iMKINkjavCdqgB2lqNHh4hE2PizJxDwQzkvJH9QwDmSDkGUHahPmQhrx2TvZjNM
 Jd6w==
X-Gm-Message-State: AGi0PuYIYyCZAGXZOEG47f9ofTgshhKzfzV4gsDxmmcno8TXWTufvkwH
 gWiTk1pNEgprZtHKOymLcVflrJtiLtiTbVCD0Gv6QCbxajxAFZNmuSbExHeRHb1yqX4LDpPOxU3
 omhLHdM1agQcz+IGmIFJb7qye
X-Received: by 2002:a5d:4442:: with SMTP id x2mr18151640wrr.101.1587052558415; 
 Thu, 16 Apr 2020 08:55:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypIL1Ng21KPZXq7/mqYvYnYksD3lb24Jyd1BsaIZ28zHv5VGpa6h6z5Fa+Khf5lPYqGvRQv9/g==
X-Received: by 2002:a5d:4442:: with SMTP id x2mr18151609wrr.101.1587052558056; 
 Thu, 16 Apr 2020 08:55:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d?
 ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
 by smtp.gmail.com with ESMTPSA id 5sm4231405wmg.34.2020.04.16.08.55.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 16 Apr 2020 08:55:57 -0700 (PDT)
Subject: Re: [PATCH v2] KVM/arm64: Support enabling dirty log gradually in
 small chunks
To: Marc Zyngier <maz@kernel.org>
References: <20200413122023.52583-1-zhukeqian1@huawei.com>
 <be45ec89-2bdb-454b-d20a-c08898e26024@redhat.com>
 <20200416160939.7e9c1621@why>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <442f288e-2934-120c-4994-5357e3e9216b@redhat.com>
Date: Thu, 16 Apr 2020 17:55:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200416160939.7e9c1621@why>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Jay Zhou <jianjay.zhou@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 16/04/20 17:09, Marc Zyngier wrote:
> On Wed, 15 Apr 2020 18:13:56 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
>> On 13/04/20 14:20, Keqian Zhu wrote:
>>> There is already support of enabling dirty log graually in small chunks
>>> for x86 in commit 3c9bd4006bfc ("KVM: x86: enable dirty log gradually in
>>> small chunks"). This adds support for arm64.
>>>
>>> x86 still writes protect all huge pages when DIRTY_LOG_INITIALLY_ALL_SET
>>> is eanbled. However, for arm64, both huge pages and normal pages can be
>>> write protected gradually by userspace.
>>>
>>> Under the Huawei Kunpeng 920 2.6GHz platform, I did some tests on 128G
>>> Linux VMs with different page size. The memory pressure is 127G in each
>>> case. The time taken of memory_global_dirty_log_start in QEMU is listed
>>> below:
>>>
>>> Page Size      Before    After Optimization
>>>   4K            650ms         1.8ms
>>>   2M             4ms          1.8ms
>>>   1G             2ms          1.8ms
>>>
>>> Besides the time reduction, the biggest income is that we will minimize
>>> the performance side effect (because of dissloving huge pages and marking
>>> memslots dirty) on guest after enabling dirty log.
>>>
>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>> ---
>>>  Documentation/virt/kvm/api.rst    |  2 +-
>>>  arch/arm64/include/asm/kvm_host.h |  3 +++
>>>  virt/kvm/arm/mmu.c                | 12 ++++++++++--
>>>  3 files changed, 14 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index efbbe570aa9b..0017f63fa44f 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -5777,7 +5777,7 @@ will be initialized to 1 when created.  This also improves performance because
>>>  dirty logging can be enabled gradually in small chunks on the first call
>>>  to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
>>>  KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
>>> -x86 for now).
>>> +x86 and arm64 for now).
>>>  
>>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
>>>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 32c8a675e5a4..a723f84fab83 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -46,6 +46,9 @@
>>>  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>>>  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>>>  
>>> +#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>>> +				     KVM_DIRTY_LOG_INITIALLY_SET)
>>> +
>>>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>>  
>>>  extern unsigned int kvm_sve_max_vl;
>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>> index e3b9ee268823..1077f653a611 100644
>>> --- a/virt/kvm/arm/mmu.c
>>> +++ b/virt/kvm/arm/mmu.c
>>> @@ -2265,8 +2265,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>>  	 * allocated dirty_bitmap[], dirty pages will be be tracked while the
>>>  	 * memory slot is write protected.
>>>  	 */
>>> -	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
>>> -		kvm_mmu_wp_memory_region(kvm, mem->slot);
>>> +	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>>> +		/*
>>> +		 * If we're with initial-all-set, we don't need to write
>>> +		 * protect any pages because they're all reported as dirty.
>>> +		 * Huge pages and normal pages will be write protect gradually.
>>> +		 */
>>> +		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
>>> +			kvm_mmu_wp_memory_region(kvm, mem->slot);
>>> +		}
>>> +	}
>>>  }
>>>  
>>>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>   
>>
>> Marc, what is the status of this patch?
> 
> I just had a look at it. Is there any urgency for merging it?

No, I thought I was still replying to the v1.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
