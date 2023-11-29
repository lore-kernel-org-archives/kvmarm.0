Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B8E1A26B
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 10:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SbY2Haq7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701252955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKJh8ZUiWfqI0I6/F7Kc1Om4LSAq3XHUbO7C+UF6QjY=;
	b=SbY2Haq76E89BPp+/GbjUgbFAwvfDwL1+wm5QAjMtwpSrxzZbSlxFaw8rBeLybHdehb8ht
	OC4SeJ334wnDFwzWrjOAXqVjsQ6gCxyp6gX1osVldaslf/0/Hl4L18eZmepnMZpKwnuUgf
	wxMpsPPe/DcaQg+PabhLfvNUQVGdrwU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-2fPY6SbOMruH9x5sFuppXg-1; Wed, 29 Nov 2023 05:15:51 -0500
X-MC-Unique: 2fPY6SbOMruH9x5sFuppXg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1cfcdda90cdso7869275ad.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 02:15:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701252950; x=1701857750;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GKJh8ZUiWfqI0I6/F7Kc1Om4LSAq3XHUbO7C+UF6QjY=;
        b=kqD+uI+obsywS4iOoQO8HB5c6kRQSupaH/qk8hBVfiGOFo945vtaeTJXEhbtH2bpcm
         o0wAFtuqoEbe6MccgYdtOQvQDkti7KayIHoJFMJVfW+AKyrHYXJtMbHWlCNXZtEMSvyb
         tgpI2MKN/C3SQyk8/Z/4PNg3NC5dY+xczp8hiVyZr/mu52Jmjz2NbfD+sLIVtBoaXDMb
         1Ns7LdwQWpxqKzJ14tiPyXhMfJbXxZ4MUmqJ4+BS3gFe+9fZwRH6VugG51zgEz/dVYuE
         ehnNGlNAhS4b2buhcTeuLSRAc496KxdTUtYYGStPdfbA4Ncrt1Zf8LcZOg4vtGKnYAZY
         9vaQ==
X-Gm-Message-State: AOJu0Yw955Dp+fmelwAT7C7D4YQClzWOASAE3XGskbLnhiGM/UuA+Zvt
	k2T7zOh3E8BpXLbmy4Gh6Dmvdvc/HXa9JFFGKNQu6kp5aBD4kI/uuPTGNNSAbeZhK1JgGl1BIj8
	3zrNoVVamjForsv/n
X-Received: by 2002:a17:902:8685:b0:1cf:ce83:3b5d with SMTP id g5-20020a170902868500b001cfce833b5dmr9984264plo.6.1701252950014;
        Wed, 29 Nov 2023 02:15:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEYs2Kkp0qERKYUxgS3sb29TzL24JH9DiuNAKvoB5ZhAdyIZrdkwnewDpwyANVasXuxm7E46Q==
X-Received: by 2002:a17:902:8685:b0:1cf:ce83:3b5d with SMTP id g5-20020a170902868500b001cfce833b5dmr9984257plo.6.1701252949774;
        Wed, 29 Nov 2023 02:15:49 -0800 (PST)
Received: from [10.72.112.34] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c20c00b001cfb52ebffdsm8127759pll.148.2023.11.29.02.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 02:15:49 -0800 (PST)
Message-ID: <b6868010-fa10-0d30-2e88-f3b0383cd862@redhat.com>
Date: Wed, 29 Nov 2023 18:15:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1 2/3] runtime: arm64: Skip the migration
 tests when run on EFI
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, Thomas Huth <thuth@redhat.com>,
 Nico Boehr <nrb@linux.ibm.com>, Ricardo Koller <ricarkol@google.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
References: <20231129032123.2658343-1-shahuang@redhat.com>
 <20231129032123.2658343-3-shahuang@redhat.com>
 <20231129-bb64bea98b2259adec0636f2@orel>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231129-bb64bea98b2259adec0636f2@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi drew,

On 11/29/23 17:16, Andrew Jones wrote:
> On Tue, Nov 28, 2023 at 10:21:22PM -0500, Shaoqin Huang wrote:
>> When running the migration tests on EFI, the migration will always fail
>> since the efi/run use the vvfat format to run test, but the vvfat format
>> does not support live migration. So those migration tests will always
>> fail.
>>
>> Instead of waiting for fail everytime when run migration tests on EFI,
>> skip those tests if running on EFI.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   scripts/runtime.bash | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index d7054b80..b7105c19 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -156,6 +156,11 @@ function run()
>>           fi
>>       }
>>   
>> +    if [ "${CONFIG_EFI}" == "y" ] && find_word "migration" "$groups"; then
>> +        print_result "SKIP" $testname "" "migration test is not support in efi"
> 
> migration tests are not supported with efi
> 
>> +        return 2
>> +    fi
>> +
>>       cmdline=$(get_cmdline $kernel)
>>       if find_word "migration" "$groups"; then
>>           cmdline="MIGRATION=yes $cmdline"
> 
> 
> We don't need to do the find_word twice,
> 
>        cmdline=$(get_cmdline $kernel)
>        if find_word "migration" "$groups"; then
>            if [ "${CONFIG_EFI}" == "y" ]; then
> 	      print_result "SKIP" $testname "" "migration tests are not supported with efi"
> 	      return 2
> 	  fi
>            cmdline="MIGRATION=yes $cmdline"
> 

Thanks for your better solution. I can do that.

Thanks,
Shaoqin

>> -- 
>> 2.40.1
>>
> 
> Thanks,
> drew
> 

-- 
Shaoqin

