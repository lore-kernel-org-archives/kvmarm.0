Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A945381
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 12:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677759164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HtFtaTLhkJtMXijEa58s2Y5EfyyTLMzyM1VpQwrQ+Qo=;
	b=GHz7KT/P0CLHdLU2zCtn3X5czG+KTSHYZ0gyprkHdow7QWG0IiAOkCIMHsH8r2F3bqV7N8
	K+821IPbcJiW7FX6Nf0Uaztm9+cvYX7qQDT5VKyhAI2OZcH+DpG+sbPFtg74PMJWfk0WO6
	QlKmuCpzroxpWbFkz+5aXcCsHdPLdPE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-zgLF52TDMF-9WwSdFTYzEA-1; Thu, 02 Mar 2023 07:12:40 -0500
X-MC-Unique: zgLF52TDMF-9WwSdFTYzEA-1
Received: by mail-pf1-f200.google.com with SMTP id i7-20020a626d07000000b005d29737db06so8639183pfc.15
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 04:12:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtFtaTLhkJtMXijEa58s2Y5EfyyTLMzyM1VpQwrQ+Qo=;
        b=K8il+v1wNoyzidOzukm5Wk73xdVArm92QJOgcdJKPftrWRYBTgjobQfkpX6i0mh+rm
         S2b6HhQ/SV0OE2JQhRZ5Doia/ndCjUeYs+xLsnmgb1Jiou40dr96eRVeGze46jgIuexv
         BGiJ+VJKeWiOt8Z/3TMV0PfnZTb527vsRbLSIl9cekoMePfva8Kd8/8oNqdPHkHaX+y5
         AFQ7mTJj+t3FHArZajgDRa2cKJjE9dHNHujIMVwFhcDoDgQvSbvnWtRAGEmPaycv2JiB
         GioeemFqRVeF18GzuUIGIzriQ6v16QH+epjrRLHMMefJXWkwsvWDX8OFa6LD4RN9hLb5
         EVhg==
X-Gm-Message-State: AO0yUKV/oSt/wZtAuXUVAYZILRv/KuVDjLG2sgPPDGOEJ5Iq35ig29Sd
	TwEy7Xbjt6d89nPEt55Hp1m9SFXgUZ8ksGK9otUhW2MbqGdsVyGV9PQqmpdAKXR6pzS8NL6/rUt
	XzdX8qN7yDOp8s7Om
X-Received: by 2002:a17:902:e74b:b0:19a:7217:32af with SMTP id p11-20020a170902e74b00b0019a721732afmr10871196plf.5.1677759159784;
        Thu, 02 Mar 2023 04:12:39 -0800 (PST)
X-Google-Smtp-Source: AK7set+lXh2ywAgxrTS03JOo9a92Dl/Rl74r2ipF/QnKaPY4SUvG5hHopddPLoVn4ctTSEg6aXiXHQ==
X-Received: by 2002:a17:902:e74b:b0:19a:7217:32af with SMTP id p11-20020a170902e74b00b0019a721732afmr10871190plf.5.1677759159516;
        Thu, 02 Mar 2023 04:12:39 -0800 (PST)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y9-20020a1709027c8900b00186a2274382sm10156720pll.76.2023.03.02.04.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 04:12:39 -0800 (PST)
Message-ID: <ae1f6ef0-2566-ad82-17b3-5637141be40e@redhat.com>
Date: Thu, 2 Mar 2023 20:12:35 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests] arm: Replace the obsolete qemu script
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, "open list:ARM" <kvm@vger.kernel.org>
References: <20230301071737.43760-1-shahuang@redhat.com>
 <20230301125004.d5giadtz4yaqdjam@orel>
 <5b019bd3-cc57-017a-e0f6-bf9ebc97ad11@redhat.com>
 <20230302115229.cphrnp5qaxmdg6wz@orel>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230302115229.cphrnp5qaxmdg6wz@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/23 19:52, Andrew Jones wrote:
> On Thu, Mar 02, 2023 at 06:09:36PM +0800, Shaoqin Huang wrote:
>> Hi drew,
>>
>> On 3/1/23 20:50, Andrew Jones wrote:
>>> On Wed, Mar 01, 2023 at 02:17:37AM -0500, Shaoqin Huang wrote:
>>>> The qemu script used to detect the testdev is obsoleted, replace it
>>>> with the modern way to detect if testdev exists.
>>>
>>> Hi Shaoqin,
>>>
>>> Can you please point out the oldest QEMU version for which the modern
>>> way works?
>>>
>>>>
>>>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>>>> ---
>>>>    arm/run | 3 +--
>>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>>
>>>> diff --git a/arm/run b/arm/run
>>>> index 1284891..9800cfb 100755
>>>> --- a/arm/run
>>>> +++ b/arm/run
>>>> @@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
>>>>    	exit 2
>>>>    fi
>>>> -if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
>>>> -		| grep backend > /dev/null; then
>>>> +if ! $qemu $M -chardev '?' 2>&1 | grep testdev > /dev/null; then
>>>                                 ^ This shouldn't be necessary. afaict,
>>> 			        only stdio is used
>>>
>>> We can change the 'grep testdev >/dev/null' to 'grep -q testdev'
>>>
>>
>> This just remind me if we could also change
>>
>> if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
>>
>> to
>>
>> if ! $qemu $M -device '?' | grep -q virtconsole; then
>>
>> And all other place like that.
> 
> Yup.
> 
> Also, unrelated, but can you change your patch prefix to
> 
>    kvm-unit-tests PATCH
> 
> as suggested in the README? My filters are looking for 'PATCH'.
> 

Hi drew,

My bad. Has update it.

Thanks,
Shaoqin

> Thanks,
> drew
> 
>>
>> Thanks,
>>
>>>>    	echo "$qemu doesn't support chr-testdev. Exiting."
>>>>    	exit 2
>>>>    fi
>>>> -- 
>>>> 2.39.1
>>>>
>>>
>>> Thanks,
>>> drew
>>>
>>
>> -- 
>> Shaoqin
>>
> 

-- 
Shaoqin

