Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B0D3234
	for <kvmarm@lists.linux.dev>; Thu, 15 Dec 2022 13:36:33 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id tz12so29642154ejc.9
        for <kvmarm@lists.linux.dev>; Thu, 15 Dec 2022 05:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jT7HJVIoupmg5Y21QSuOncD3NDSjnYDNv89SW9beZ/U=;
        b=fq7i2oQ4kCQIvyyCM2oJDTi5KBfjXOU5mODFRLAI90+YnBCM1rr1s7NbIi5I6vOy2h
         iH6FFu8de9yxfk5Uji5GsMY3TEzTgJLkUsjLIrA9Hs+ZG0IY93f33EWh4+HjgzZvomBr
         TtwGWWZ2QnFQ/Gp2woOKcVM67pr8OkE9Q07CMuc34US4AfkN0YU9W0+Jbai5L7kpzoxm
         WXIwJ4RnMfvWa6JLFOjiB2LEEDEbQ1xyIEG7gkTB1wD3YIvVzgINSGZMTW+DyCOa2ce9
         tuYyzT279ljDfbVS9LvWAx/dukSBSkCiRqtVAzIA714/V4xC4+f16RB2kWFQlidCaWi+
         P8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jT7HJVIoupmg5Y21QSuOncD3NDSjnYDNv89SW9beZ/U=;
        b=NYpgh9unlWBz5DBC1Uh5K0y52GcEnZ+m8vzyaR9xaSHYOTp2495Fat+hYZJYCss3eU
         1HMOBmmOEKddU3g5HKtijfW8xOfq0QnP7zuuUtlt2LlZQUCAEQ6DZi9QmeUtKwZp/+Le
         42T6JzEDvPFauANnsgFy5Zfq8di8D7C5cxUD8h4an2uIm2DSqCS1TSlymH8lkzGQX8Pm
         P3gNcKjGAZbPT8dXvMqlPZUt6Wu53JVGk+3rs7izRUnCgJtthhUUDKuEEOCISCv/c2+P
         ULYzsBzpW6Obr8rGn8JH0twbKM/MuJipmSGsATfNsLKKfUl5aPWChVa2Bo7diujny/Hs
         zjPw==
X-Gm-Message-State: ANoB5plq7S4An8fY96h0RhEkZe1g4O4cbLcShvnm84PIHDiR7fhoY/Ky
	47U6m1Vam0N+eNsz5RkL4Iw=
X-Google-Smtp-Source: AA0mqf5UqnGI8UrmD8MiKudLAv9QQswJ7jkGOHAc+i4PkeipEyUbgd8djmZl9G7Q8dQDDdx+KvnmjQ==
X-Received: by 2002:a17:907:a782:b0:7c1:6e82:35fc with SMTP id vx2-20020a170907a78200b007c16e8235fcmr25025941ejc.40.1671111392045;
        Thu, 15 Dec 2022 05:36:32 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060cc900b007b5903e595bsm7031780ejh.84.2022.12.15.05.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 05:36:31 -0800 (PST)
Message-ID: <90b640af-1d81-64bf-96f7-24aa44cca2dd@gmail.com>
Date: Thu, 15 Dec 2022 21:36:19 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH RFC 1/8] perf/core: Add *group_leader to
 perf_event_create_kernel_counter()
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Fenghua Yu <fenghua.yu@intel.com>, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org
References: <20221212125844.41157-1-likexu@tencent.com>
 <20221212125844.41157-2-likexu@tencent.com>
 <4990ef71-734a-10cf-e7dc-51b33b26fd18@amd.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <4990ef71-734a-10cf-e7dc-51b33b26fd18@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/12/2022 11:52 am, Ravi Bangoria wrote:
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 7f04f995c975..f671b1a9a691 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -12674,12 +12674,14 @@ SYSCALL_DEFINE5(perf_event_open,
>>    * @attr: attributes of the counter to create
>>    * @cpu: cpu in which the counter is bound
>>    * @task: task to profile (NULL for percpu)
>> + * @group_leader: event group leader
>>    * @overflow_handler: callback to trigger when we hit the event
>>    * @context: context data could be used in overflow_handler callback
>>    */
>>   struct perf_event *
>>   perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>>   				 struct task_struct *task,
>> +				 struct perf_event *group_leader,
>>   				 perf_overflow_handler_t overflow_handler,
>>   				 void *context)
>>   {
>> @@ -12694,7 +12696,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>>   	if (attr->aux_output)
>>   		return ERR_PTR(-EINVAL);
>>   
>> -	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
>> +	event = perf_event_alloc(attr, cpu, task, group_leader, NULL,
>>   				 overflow_handler, context, -1);
> 
> Grouping involves lot of complexities. Setting group_leader won't be sufficient.
> Please see perf_event_open() syscall code for more detail.
> 
> Thanks,
> Ravi

This is the main reason why the RFC tag is added. More detailed professional 
reviews is encouraged.

AFAI, there does exist a number of code gaps here to support grouped events in 
the kernel,
but there are also opportunities, as there may be other new use cases bringing 
innovation.

I have to confirm this idea with maintainers first, the alternative is to create 
yet another special
perf_event similar to PMC_IDX_FIXED_VLBR, which schedules perf_metrics MSR for 
KVM stuff.

PeterZ, any input ?
