Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6117E7
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 02:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677725139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=agMmEvQOhXFEFHDtkSxYfBL1NNPQWWRtgjv9ldmiZF0=;
	b=QisoVaUsj/2BYKUqQi3HzEznckg9V87kFjaNANIkZxLDEvbRv1jzuDouC8zj7lSuQUc4UM
	x4Y9PRxXAVLbUYFMltc7Q9uNkNIhFkMPuxlhInhoAkGqoJAQBag7RUppLcHuUE1tINHIWP
	qUEwrZdSCsSEzjka+MQLB49WEncvTyA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-374-ggnpPmqdP1C2jizBVKOGoA-1; Wed, 01 Mar 2023 21:45:38 -0500
X-MC-Unique: ggnpPmqdP1C2jizBVKOGoA-1
Received: by mail-pf1-f199.google.com with SMTP id a23-20020a62bd17000000b0058db55a8d7aso8027086pff.21
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 18:45:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=agMmEvQOhXFEFHDtkSxYfBL1NNPQWWRtgjv9ldmiZF0=;
        b=hSyBevPmo9qLBplImRrxECTCAnxZu+sk4xZOdAv4IbQXc0S6dhJqrPEWyWZImYlCxw
         zMHrtUV/sWENj6PZhbLf39C7F64AyvmWul+drtCo0CCh175uIR0U3ubAh0s8wHawbKPh
         yHKSFVvCnr1pf1DvbeS97peKc/990W/Po4LPNORvysM4o77OoaDNM+DZ/tJB+kCT9jW/
         fkzEFN0lv+zEWRBDPw89chsP10abMWNUG3X2kaApr2iW49Zc2+7sSYiMaJFKUlu0mQdT
         qxGRCSxnYEO42spZtH5iU+e4xsCnU+oF/cDoc3uzTrW+mqmFDgP6OYA07aMF+5pH5bkT
         r3oQ==
X-Gm-Message-State: AO0yUKU+OaWbEb5DAb8tZmv9B02STff4mm5Z7plMbB3MTP0f11fzlX7j
	TOuSVMnTug3W/FrYthgjEqf8x0a+yCeALimlWnd8Fbmvb3f9hXpmZFLjEQqswapkV6M9FDp/5h0
	bKcJCX0mIDUJooLJH
X-Received: by 2002:a17:902:dace:b0:19a:af51:c282 with SMTP id q14-20020a170902dace00b0019aaf51c282mr9529312plx.0.1677725137248;
        Wed, 01 Mar 2023 18:45:37 -0800 (PST)
X-Google-Smtp-Source: AK7set+A+reeTdq/WElnggT6Nx8GvkrTgiDA90WOBPAEY8OgPArJQ+GuRp2VTFa4Qy7tq7ERH4hgHA==
X-Received: by 2002:a17:902:dace:b0:19a:af51:c282 with SMTP id q14-20020a170902dace00b0019aaf51c282mr9529298plx.0.1677725136863;
        Wed, 01 Mar 2023 18:45:36 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jc18-20020a17090325d200b001994e74c094sm9124572plb.275.2023.03.01.18.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 18:45:36 -0800 (PST)
Message-ID: <e595eb97-9702-e633-ac0e-0c2db2aa1904@redhat.com>
Date: Thu, 2 Mar 2023 10:45:33 +0800
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
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301125004.d5giadtz4yaqdjam@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/1/23 20:50, Andrew Jones wrote:
> On Wed, Mar 01, 2023 at 02:17:37AM -0500, Shaoqin Huang wrote:
>> The qemu script used to detect the testdev is obsoleted, replace it
>> with the modern way to detect if testdev exists.
> 
> Hi Shaoqin,
> 
> Can you please point out the oldest QEMU version for which the modern
> way works?

Hi drew,

This way was introduced by 517b3d4016 (chardev: Add 'help' option to 
print all available chardev backend types). Which the QEMU verison is 
v2.7.50.

> 
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   arm/run | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arm/run b/arm/run
>> index 1284891..9800cfb 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
>>   	exit 2
>>   fi
>>   
>> -if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
>> -		| grep backend > /dev/null; then
>> +if ! $qemu $M -chardev '?' 2>&1 | grep testdev > /dev/null; then
>                                ^ This shouldn't be necessary. afaict,
> 			        only stdio is used
> 
> We can change the 'grep testdev >/dev/null' to 'grep -q testdev'

Thanks for advice. I will change it.

> 
>>   	echo "$qemu doesn't support chr-testdev. Exiting."
>>   	exit 2
>>   fi
>> -- 
>> 2.39.1
>>
> 
> Thanks,
> drew
> 

-- 
Shaoqin

