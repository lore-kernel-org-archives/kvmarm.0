Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7357B7F8
	for <kvmarm@lists.linux.dev>; Sun, 23 Apr 2023 06:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682232972;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=79SvA4Eb3KYtaWkRdo50y3k1slLWmFEZdz091B6WM8s=;
	b=GtQejRq9qlOzSZKYgeATHKWYhQynSNHi99phg1w469SnldWEakptO1Z2XDUNpTtybSgBiY
	H8jT2rGnaZGtr3rtwRMtEoKmrkweq/sqJrj9PyB5NlPo8CA2LCsaWs0zoBrhlL+e01J8T2
	SJtgTwpOGz+TfkJcJ+3PAErp/aBfNT8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-aPWh8nwBPRm5eD0hPF7VvQ-1; Sun, 23 Apr 2023 02:56:08 -0400
X-MC-Unique: aPWh8nwBPRm5eD0hPF7VvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4E043813F22;
	Sun, 23 Apr 2023 06:56:07 +0000 (UTC)
Received: from [10.72.12.189] (ovpn-12-189.pek2.redhat.com [10.72.12.189])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9955D40C2064;
	Sun, 23 Apr 2023 06:55:57 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
To: Ricardo Koller <ricarkol@google.com>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
 yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, eric.auger@redhat.com, reijiw@google.com,
 rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
 Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-5-ricarkol@google.com>
 <9cb621b0-7174-a7c7-1524-801b06f94e8f@redhat.com>
 <ZEQ+9kyXcQS+1i81@google.com> <ZEREQrqmZeLtgbPw@linux.dev>
 <ZERFpWDUt3WkI5kp@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <49be7cf3-d549-7ef6-4833-3f755d476dcd@redhat.com>
Date: Sun, 23 Apr 2023 14:55:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZERFpWDUt3WkI5kp@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

On 4/23/23 4:37 AM, Ricardo Koller wrote:
> On Sat, Apr 22, 2023 at 08:32:02PM +0000, Oliver Upton wrote:
>> On Sat, Apr 22, 2023 at 01:09:26PM -0700, Ricardo Koller wrote:
>>> On Mon, Apr 17, 2023 at 02:18:26PM +0800, Gavin Shan wrote:
>>>>> +	/* .addr (the IPA) is irrelevant for an unlinked table */
>>>>> +	struct kvm_pgtable_walk_data data = {
>>>>> +		.walker	= &walker,
>>>>> +		.addr	= 0,
>>>>> +		.end	= kvm_granule_size(level),
>>>>> +	};
>>>>
>>>> The comment about '.addr' seems incorrect. The IPA address is still
>>>> used to locate the page table entry, so I think it would be something
>>>> like below:
>>>>
>>>> 	/* The IPA address (.addr) is relative to zero */
>>>>
>>>
>>> Extended it to say this:
>>>
>>>           * The IPA address (.addr) is relative to zero. The goal is to
>>> 	   * map "kvm_granule_size(level) - 0" worth of pages.
>>
>> I actually prefer the original wording, as Gavin's suggestion makes this
>> comment read as though the IPA of the walk bears some degree of
>> validity, which it does not.
>>
>> The intent of the code is to create some *ambiguous* input address
>> range, so maybe:
>>
>> 	/*
>> 	 * The input address (.addr) is irrelevant for walking an
>> 	 * unlinked table. Construct an ambiguous IA range to map
>> 	 * kvm_granule_size(level) worth of memory.
>> 	 */
>>
> 
> OK, this is the winner. Will go with this one in v8. Gavin, let me know
> if you are not OK with this.
> 

Looks good to me either.

Thanks,
Gavin

