Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24F41A282
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 10:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A/u1NyJ+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701252917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lw81hUSol2mnRdZFW1ktXcFKebpoP3acx2OX3rITVMY=;
	b=A/u1NyJ+oyFjbq67ju3jZjdLrL4vNHv3kVI9OmmxpubfSsjxfBkWpQkOWjQYKi0W/MqssH
	0wB+6QtJR5SzTNzbNIgaB1BhJEYLTH1C2D0NJVJOpM5Q3lRmOfvSqPTHhory6k5O05l8wd
	0EQGOGidMOqleJmfMkirzMOZTYIoZIY=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-g5rtfxcANniRyujZo95kdA-1; Wed, 29 Nov 2023 05:15:11 -0500
X-MC-Unique: g5rtfxcANniRyujZo95kdA-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6cdc01c02a4so224843b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 02:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701252910; x=1701857710;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lw81hUSol2mnRdZFW1ktXcFKebpoP3acx2OX3rITVMY=;
        b=MilyCwoGxehjH2cJPvfYx3uWGiAcEWqXluU5ZGuV02zJf74AlHDDmx4wwZtA5Sy9LL
         UN4AQauSj7FY7nnBa943P2bvjsHmyJ4/5dFzM5wU03a19Fzr/L9y/YxkHibTbu2v678E
         TWsFmFZGc98VlFSPpzxKnKwaErIQGrlT769FB/Zt55H9sWxHY2OMi5GhpcFq3JUrORua
         AgB/eRayGAkbDo41zmI+PTeBY8W/X+O5hYJjpkzQ8vpIJHlLm53qU7cFB8CEBps5Rd6G
         GRGAmxOLGKV7hRGkuWBwV5m32alVbT8kqsi7D+l7CdSWcEbK4VyHKxhIxCG6V5jOexK4
         TK5Q==
X-Gm-Message-State: AOJu0YxI8ApIF5V5ODqyQ5gHaPwLAwElHjg9dyY99mg3+d9AF+x9tEaJ
	Oq86xCKbQS+LH55AnwvbYtchTjRgBS8Wb3dY4y+SFdbY/TfupYvtZWi2KnBIP7+XxQluyHJUDhX
	HKYEdFC3TFW4Q5dDP
X-Received: by 2002:a05:6a21:a598:b0:18b:d26a:375c with SMTP id gd24-20020a056a21a59800b0018bd26a375cmr24956377pzc.1.1701252910308;
        Wed, 29 Nov 2023 02:15:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyzhTLYvGONc6oDui6z5dfWFKSQScpc0Ja4inxUPFDmsrawMYPVPrzhuQh+FmrKCMQPVEA7Q==
X-Received: by 2002:a05:6a21:a598:b0:18b:d26a:375c with SMTP id gd24-20020a056a21a59800b0018bd26a375cmr24956366pzc.1.1701252909984;
        Wed, 29 Nov 2023 02:15:09 -0800 (PST)
Received: from [10.72.112.34] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v1-20020a63d541000000b005b18c53d73csm10273696pgi.16.2023.11.29.02.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 02:15:09 -0800 (PST)
Message-ID: <261cdc3d-9882-a81d-57ff-6c88a2b0695a@redhat.com>
Date: Wed, 29 Nov 2023 18:15:06 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1 1/3] runtime: Fix the missing last_line
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, Thomas Huth <thuth@redhat.com>,
 Nico Boehr <nrb@linux.ibm.com>, Ricardo Koller <ricarkol@google.com>,
 Colton Lewis <coltonlewis@google.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
References: <20231129032123.2658343-1-shahuang@redhat.com>
 <20231129032123.2658343-2-shahuang@redhat.com>
 <20231129-54301cf86283b3d5a5a249ea@orel>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231129-54301cf86283b3d5a5a249ea@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi drew,

On 11/29/23 17:11, Andrew Jones wrote:
> On Tue, Nov 28, 2023 at 10:21:21PM -0500, Shaoqin Huang wrote:
>> The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
>> This lead to when SKIP test, the reason is missing. Fix the problem by
>> adding last_line back.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> 
> Fixes: 2607d2d6 ("arm64: Add an efi/run script")
> 

Will add it.

>> ---
>>   scripts/runtime.bash | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index fc156f2f..d7054b80 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -148,6 +148,8 @@ function run()
>>               fi
>>           fi
>>   
>> +	last_line=$(tail -1 <<<"$log")
>> +
>>           if [ ${skip} == true ]; then
>>               print_result "SKIP" $testname "" "$last_line"
> 
> We can just change this one use of $last_line to $(tail -1 <<<"$log")
> 

Got it. Looks good.

Thanks,
Shaoqin

>>               return 77
>> -- 
>> 2.40.1
>>
> 
> Thanks,
> drew
> 

-- 
Shaoqin

