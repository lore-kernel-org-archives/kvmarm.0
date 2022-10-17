Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D557F
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 22:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666045161;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J22Buvx1QUdA1KfjsZHS/HHBKp3etxDqB4gvS2Hya9U=;
	b=XZF2VhGdq3IhiXgxQz0F3loLAMYBYRpHHXdGso6+qv6rGxIgmwQpeM7iJ52R6DE2DTaqTV
	pK+NTvs0rz4obGiBNfXDjZRPalhGxYfTrrpJk/VztnoiYayILQjX9rXPhoypGtfjtMj9kJ
	/ffwcLIQrvewAjTw8Suzk+MR8HgLDlU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-6odBANwtM_CYot3N0g1dxg-1; Mon, 17 Oct 2022 18:19:18 -0400
X-MC-Unique: 6odBANwtM_CYot3N0g1dxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11E3A1C1436E;
	Mon, 17 Oct 2022 22:19:02 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7C2640C206B;
	Mon, 17 Oct 2022 22:18:41 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 3/6] KVM: selftests: memslot_perf_test: Probe memory slots
 for once
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
 pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
 oliver.upton@linux.dev, seanjc@google.com, peterx@redhat.com,
 ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-4-gshan@redhat.com>
 <fb3926da-a683-2811-71a4-31fe36a9cb50@maciej.szmigiero.name>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <b720dbad-4b8b-a617-f782-7f95bcdb3d54@redhat.com>
Date: Tue, 18 Oct 2022 06:18:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fb3926da-a683-2811-71a4-31fe36a9cb50@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Message-ID: <20221017221839.VlJIz8p1oz6ZzPVEWalmbZ6hi_o7lvLucQfU7WUUXkU@z>

On 10/18/22 1:34 AM, Maciej S. Szmigiero wrote:
> On 14.10.2022 09:19, Gavin Shan wrote:
>> prepare_vm() is called in every iteration and run. The allowed memory
>> slots (KVM_CAP_NR_MEMSLOTS) are probed for multiple times. It's not
>> free and unnecessary.
>>
>> Move the probing logic for the allowed memory slots to parse_args()
>> for once, which is upper layer of prepare_vm().
>>
>> No functional change intended.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   .../testing/selftests/kvm/memslot_perf_test.c | 29 ++++++++++---------
>>   1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
>> index dcb492b3f27b..d5aa9148f96f 100644
>> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
>> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
>> @@ -245,27 +245,17 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
>>                  void *guest_code, uint64_t mempages,
>>                  struct timespec *slot_runtime)
>>   {
>> -    uint32_t max_mem_slots;
>>       uint64_t rempages;
>>       uint64_t guest_addr;
>>       uint32_t slot;
>>       struct timespec tstart;
>>       struct sync_area *sync;
>> -    max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
>> -    TEST_ASSERT(max_mem_slots > 1,
>> -            "KVM_CAP_NR_MEMSLOTS should be greater than 1");
>> -    TEST_ASSERT(nslots > 1 || nslots == -1,
>> -            "Slot count cap should be greater than 1");
>> -    if (nslots != -1)
>> -        max_mem_slots = min(max_mem_slots, (uint32_t)nslots);
>> -    pr_info_v("Allowed number of memory slots: %"PRIu32"\n", max_mem_slots);
>> -
>>       TEST_ASSERT(mempages > 1,
>>               "Can't test without any memory");
>>       data->npages = mempages;
>> -    data->nslots = max_mem_slots - 1;
>> +    data->nslots = nslots;
>>       data->pages_per_slot = mempages / data->nslots;
>>       if (!data->pages_per_slot) {
>>           *maxslots = mempages + 1;
>> @@ -885,8 +875,8 @@ static bool parse_args(int argc, char *argv[],
>>               break;
>>           case 's':
>>               targs->nslots = atoi(optarg);
>> -            if (targs->nslots <= 0 && targs->nslots != -1) {
>> -                pr_info("Slot count cap has to be positive or -1 for no cap\n");
>> +            if (targs->nslots <= 1 && targs->nslots != -1) {
>> +                pr_info("Slot count cap must be larger than 1 or -1 for no cap\n");
>>                   return false;
>>               }
>>               break;
>> @@ -932,6 +922,19 @@ static bool parse_args(int argc, char *argv[],
>>           return false;
>>       }
>> +    /* Memory slot 0 is reserved */
>> +    if (targs->nslots == -1) {
>> +        targs->nslots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS) - 1;
>> +        if (targs->nslots < 1) {
>> +            pr_info("KVM_CAP_NR_MEMSLOTS should be greater than 1\n");
>> +            return false;
>> +        }
>> +    } else {
>> +        targs->nslots--;
>> +    }
>> +
>> +    pr_info_v("Number of memory slots: %d\n", targs->nslots);
>> +
> 
> Can't see any capping of the command line provided slot count to
> KVM_CAP_NR_MEMSLOTS value, like the old code did.
> 

Indeed. I wanted to avoid extra variable @max_mem_slots and the
capping is missed. I will fix it up in next revision.

>>       return true;
>>   }

Thanks,
Gavin

