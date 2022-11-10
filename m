Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA07362
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 03:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668051648;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kMNMhK+l7O2W6jwx6YWenB9Bua4Y3uubwLIQcGRNGbE=;
	b=Fsz3rgeVRbC5JdLZQHFyWbM1EO5m3Vpwu9Io+90fTZjFdySDhxwmqlnwa/2OUdFOkakknr
	5IScUN5Q5YQQi3uXH5ncwlvNDUXVUtWXwyA3QXpUUYgnmn063empvHjiHQCK01IBbnj8ZQ
	/+V4Ay31+HtTmJEZXWV2WamSt8L42aU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-0xCH7MJkMH-kGtSj_pgaVg-1; Wed, 09 Nov 2022 22:40:42 -0500
X-MC-Unique: 0xCH7MJkMH-kGtSj_pgaVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71544833A09;
	Thu, 10 Nov 2022 03:40:41 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AA2420290AE;
	Thu, 10 Nov 2022 03:40:36 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 01/14] KVM: arm64: Combine visitor arguments into a
 context structure
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
 Ricardo Koller <ricarkol@google.com>, David Matlack <dmatlack@google.com>,
 Quentin Perret <qperret@google.com>, Ben Gardon <bgardon@google.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-2-oliver.upton@linux.dev>
 <190fd3d3-bf86-23cf-0424-336577655e8f@redhat.com>
 <Y2xI+bw8i2iboHxL@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <d62db27c-f13a-1770-f896-b4a38b404d67@redhat.com>
Date: Thu, 10 Nov 2022 11:40:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y2xI+bw8i2iboHxL@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Message-ID: <20221110034033.cStq2imozpEF_q2QtRPlD8yQE_dv5FPhojFF6tvb5rU@z>

Hi Oliver,

On 11/10/22 8:42 AM, Oliver Upton wrote:
> On Thu, Nov 10, 2022 at 08:23:36AM +0800, Gavin Shan wrote:
>> On 11/8/22 5:56 AM, Oliver Upton wrote:
>>> Passing new arguments by value to the visitor callbacks is extremely
>>> inflexible for stuffing new parameters used by only some of the
>>> visitors. Use a context structure instead and pass the pointer through
>>> to the visitor callback.
>>>
>>> While at it, redefine the 'flags' parameter to the visitor to contain
>>> the bit indicating the phase of the walk. Pass the entire set of flags
>>> through the context structure such that the walker can communicate
>>> additional state to the visitor callback.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>>> ---
>>>    arch/arm64/include/asm/kvm_pgtable.h  |  15 +-
>>>    arch/arm64/kvm/hyp/nvhe/mem_protect.c |  10 +-
>>>    arch/arm64/kvm/hyp/nvhe/setup.c       |  16 +-
>>>    arch/arm64/kvm/hyp/pgtable.c          | 269 +++++++++++++-------------
>>>    4 files changed, 154 insertions(+), 156 deletions(-)
>>>
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>> One nit below.
>>
>>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>>> index 3252eb50ecfe..607f9bb8aab4 100644
>>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>>> @@ -199,10 +199,17 @@ enum kvm_pgtable_walk_flags {
>>>    	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
>>>    };
>>> -typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
>>> -					kvm_pte_t *ptep,
>>> -					enum kvm_pgtable_walk_flags flag,
>>> -					void * const arg);
>>> +struct kvm_pgtable_visit_ctx {
>>> +	kvm_pte_t				*ptep;
>>> +	void					*arg;
>>> +	u64					addr;
>>> +	u64					end;
>>> +	u32					level;
>>> +	enum kvm_pgtable_walk_flags		flags;
>>> +};
>>> +
>>> +typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
>>> +					enum kvm_pgtable_walk_flags visit);
>>
>> Does it make sense to reorder these fields in the context struct based on
>> their properties.
> 
> The ordering was a deliberate optimization for space. Your suggestion
> has 8 bytes of implicit padding:
> 

Right, so how about to rearrange these fields like below? It makes
more sense to have @arg after addr/end/ptep.

    struct kvm_pgtable_visit_ctx {
           enum kvm_pgtable_walk_flags     flags;
           u32                             level;
           u64                             addr;
           u64                             end;
           kvm_pte_t                       *ptep;
           void                            *arg;
    };


[...]

Thanks,
Gavin

