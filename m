Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A02533D8
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677751782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lXbERUV6OXXNEd4Glxe8uKPGB9Paw5omeac0WMLVgtU=;
	b=QcznqyG8F3tv+OUPIm37nztmVItkvFGJblWls/+FSjzqvcODHkrv45zix9aqH6TRSwaaze
	K8KsKCv/grP1PvxowVJJPsJyX7bhrFKtFv6tN0MEQjE7kqZjaKu2DQ3mtc33n5bxr3SFsP
	1YpBCFmO42fsSYKRvqd60sNdSlgo8lg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-502-UCpAtdcWPu6ei8KIr5w9vA-1; Thu, 02 Mar 2023 05:09:41 -0500
X-MC-Unique: UCpAtdcWPu6ei8KIr5w9vA-1
Received: by mail-qk1-f198.google.com with SMTP id x5-20020a05620a01e500b007428997e800so9282241qkn.10
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 02:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677751781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lXbERUV6OXXNEd4Glxe8uKPGB9Paw5omeac0WMLVgtU=;
        b=YTCxPsnpWEdCksnWWQhU6ZDhJbYrmi4uWulH7x8TVk2Uj+LN5JAjtGq8ZVCyTh5BK7
         pPBJq0dzdfrnNDXF3bwnJbvLFw+OKZ7eBlycRSaZaxD38bYukAvBFotYKmHGby92d0w3
         RJbfbTjLRN89g3qa2cmVKdXsRXBpiMgiQRj+txuYZmZVm8X1mgxfdbZZ4CfOChPr5rC0
         kHxqmU80jI+MJI2LyjKLcjAhrTSUTTsgTTbGmLJfAEDqr/6A7rTkSJF4e7S3Ac3ChoHp
         P8Tb7YP9xL4u8+v3yj5a/LXnxCksXjwYs71MmeWTyPncGUSMDOXvLbNroo8xVbWFbPW7
         OCww==
X-Gm-Message-State: AO0yUKV3CxdCSrfvYkw2MG8FNB2Mnn/kZtIx7akX7lmnemWbz1HvXCNe
	YDy2omh0I+bHV/hbA28hBsZGBp8DCB4YF1Ved5I8MqZ5fDGCnYiYah1HHJURbmLWUaSEVAJQ9pD
	i7ZR1udsciiQ9d9Yd
X-Received: by 2002:a05:622a:15d4:b0:3b9:a4d4:7f37 with SMTP id d20-20020a05622a15d400b003b9a4d47f37mr17574703qty.3.1677751781216;
        Thu, 02 Mar 2023 02:09:41 -0800 (PST)
X-Google-Smtp-Source: AK7set/8Saqx1K2uJdBaEuchwtQIsZTeWAw6wUQDOhc6/0sKADQ5BeeC69pCKk48cWVerK4+pDG8yA==
X-Received: by 2002:a05:622a:15d4:b0:3b9:a4d4:7f37 with SMTP id d20-20020a05622a15d400b003b9a4d47f37mr17574677qty.3.1677751780978;
        Thu, 02 Mar 2023 02:09:40 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x7-20020ac87007000000b003c00573aaffsm697711qtm.3.2023.03.02.02.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 02:09:40 -0800 (PST)
Message-ID: <5b019bd3-cc57-017a-e0f6-bf9ebc97ad11@redhat.com>
Date: Thu, 2 Mar 2023 18:09:36 +0800
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

Hi drew,

On 3/1/23 20:50, Andrew Jones wrote:
> On Wed, Mar 01, 2023 at 02:17:37AM -0500, Shaoqin Huang wrote:
>> The qemu script used to detect the testdev is obsoleted, replace it
>> with the modern way to detect if testdev exists.
> 
> Hi Shaoqin,
> 
> Can you please point out the oldest QEMU version for which the modern
> way works?
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
> 

This just remind me if we could also change

if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then

to

if ! $qemu $M -device '?' | grep -q virtconsole; then

And all other place like that.

Thanks,

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

