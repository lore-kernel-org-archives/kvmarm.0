Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E57EC
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 07:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675150923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pOekOPQEicd305LCzeaI3ahxQ6p+zMshj5HVCg0TAMQ=;
	b=iPFVZuOtoEBABaIKyiSfzFGpCS3lC4MiFYq7tBvZ+wPkznvVgcW3Ht3kFu9gDcDp27OUgG
	1Bmf7FtPfsTzbIaoD3WI9FuthuDHfFx91zzYDjCQBmluwE8I0/gAG5mozUdhlK0i5nOxTR
	IOcWSBI6ThJr/nIERD66Ex303vy4F2Q=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-283-BTYxD9q7MQawyOVQXm7iHg-1; Tue, 31 Jan 2023 02:41:44 -0500
X-MC-Unique: BTYxD9q7MQawyOVQXm7iHg-1
Received: by mail-qv1-f71.google.com with SMTP id ib5-20020a0562141c8500b0053c23b938a0so3185248qvb.17
        for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 23:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pOekOPQEicd305LCzeaI3ahxQ6p+zMshj5HVCg0TAMQ=;
        b=UIf0Fu9k+KN/0N5q7oECcJvshUQT7+r1fVOVT/HDYABnftGyTLp6ZqmjLKemCYuJPz
         F69nEh28TAT2SvW+HGPayadZmJ7OBshPVS5CWoXdnrgBX9/Fwh2lu1cFNfQnkp6LXw+N
         9ExleyMkYsoQxmDKlU5FZJRX8opgNFwSRU70/IW5PlPF/Cjsxr7WlKvSTB/kMaCJlU0G
         wZeOIDiB5/b812swHFnHCmTmQpiVUDfwR0EwchViAVLjiNhCLr53JEo86mtdHhlYWrqM
         XNWWKWq3K1MLfNNrbLGB2nB03PDB7GFfo1ut+bvn26n3SaPqkBjCi7FpzKc9ZHPmQQzM
         o2rg==
X-Gm-Message-State: AO0yUKWmuAfNZnQPRxQKE/uqcVxtQ8RS2WV77eWTZw0Y4JCH4AfTh/XO
	Q84l/D1f03mkjuz2uarI6NXjhuyzvcXcuXDDRwu5NVVbI1awp5PytIJqfOpbSvzGFqt06ZuNtVQ
	RfA0EOE49I4yoziaK
X-Received: by 2002:a05:622a:1316:b0:3b8:4a9e:7445 with SMTP id v22-20020a05622a131600b003b84a9e7445mr13398950qtk.21.1675150903772;
        Mon, 30 Jan 2023 23:41:43 -0800 (PST)
X-Google-Smtp-Source: AK7set8vKgpqG5EZrQ39ZZwl0nxZEVrPjxIbjUt/DuiD8RTXQH5Ffm24PmuSXQoKgbfm1kG+1FG/IA==
X-Received: by 2002:a05:622a:1316:b0:3b8:4a9e:7445 with SMTP id v22-20020a05622a131600b003b84a9e7445mr13398938qtk.21.1675150903529;
        Mon, 30 Jan 2023 23:41:43 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-155.web.vodafone.de. [109.43.176.155])
        by smtp.gmail.com with ESMTPSA id e11-20020ac8010b000000b003b630ea0ea1sm9406960qtg.19.2023.01.30.23.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 23:41:42 -0800 (PST)
Message-ID: <03662bf9-1c92-085b-7418-f3a218093051@redhat.com>
Date: Tue, 31 Jan 2023 08:41:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
To: Andrew Jones <andrew.jones@linux.dev>,
 Colton Lewis <coltonlewis@google.com>
Cc: pbonzini@redhat.com, nrb@linux.ibm.com, imbrenda@linux.ibm.com,
 marcorr@google.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20230130195700.729498-1-coltonlewis@google.com>
 <20230130195700.729498-2-coltonlewis@google.com>
 <20230131063203.67qgjf2ispi2k6hd@orel>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230131063203.67qgjf2ispi2k6hd@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/01/2023 07.32, Andrew Jones wrote:
> On Mon, Jan 30, 2023 at 07:57:00PM +0000, Colton Lewis wrote:
>> Replace the MAX_SMP probe loop in favor of reading a number directly
>> from the QEMU error message. This is equally safe as the existing code
>> because the error message has had the same format as long as it has
>> existed, since QEMU v2.10. The final number before the end of the
>> error message line indicates the max QEMU supports. A short awk
> 
> awk is not used, despite the comment also being updated to say it's
> being used.
> 
>> program is used to extract the number, which becomes the new MAX_SMP
>> value.
>>
>> This loop logic is broken for machines with a number of CPUs that
>> isn't a power of two. This problem was noticed for gicv2 tests on
>> machines with a non-power-of-two number of CPUs greater than 8 because
>> tests were running with MAX_SMP less than 8. As a hypthetical example,

s/hypthetical/hypothetical/

>> a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
>> 6. This can, in rare circumstances, lead to different test results
>> depending only on the number of CPUs the machine has.
>>
>> A previous comment explains the loop should only apply to kernels
>> <=v4.3 on arm and suggests deletion when it becomes tiresome to
>> maintian. However, it is always theoretically possible to test on a

s/maintian/maintain/

>> machine that has more CPUs than QEMU supports, so it makes sense to
>> leave some check in place.
>>
>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   scripts/runtime.bash | 16 +++++++---------
>>   1 file changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index f8794e9a..587ffe30 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -188,12 +188,10 @@ function run()
>>   # Probe for MAX_SMP, in case it's less than the number of host cpus.
>>   #
>>   # This probing currently only works for ARM, as x86 bails on another
> 
> It just occurred to me that this code runs on all architectures, even
> though it only works for Arm. We should wrap this code in $ARCH
> checks or put it in a function which only Arm calls. That change
> should be a separate patch though.

Or we just grep for "max CPUs", since this seems to be used on other 
architectures, too:

$ qemu-system-x86_64 -smp 12345
qemu-system-x86_64: Invalid SMP CPUs 12345. The max CPUs supported by 
machine 'pc-i440fx-8.0' is 255

?

  Thomas

