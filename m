Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EB610971
	for <kvmarm@lists.linux.dev>; Tue, 16 Jan 2024 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLno0I9d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705385960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dv3YKC3c8DPTgoEFA32x0UGDsvE1JRMlM1qKabmoCgU=;
	b=DLno0I9drdeMXOZOc06WfDGJ/LYtBZ6hwnZu1GLFY2t0F86bPo3zVqVo2S9xYbMFhATlIY
	VjOj0l8NCFRC268W6AW4M6Qd1BjGtQgYcB+vPRxiJYCd95RR58I55TH3UtZ8eKVSe2Wpya
	Jq9qUKdd1LIOysWMhA0rLV4ihyO8XdY=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-LHOqHDfQOmGO_fSqfzEJLw-1; Tue, 16 Jan 2024 01:19:13 -0500
X-MC-Unique: LHOqHDfQOmGO_fSqfzEJLw-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-35fbab97a5cso16016735ab.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 22:19:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705385952; x=1705990752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dv3YKC3c8DPTgoEFA32x0UGDsvE1JRMlM1qKabmoCgU=;
        b=JDkiz1qzAquqhOMdeVY6HIJbMhrDQOATSH+/qFv0jPd9EshOQPxaV46/Ox4q1DJMpt
         6wjPp1OlDLu6/M7f862/+cQed3ppYY0q26XOaW1yJudGM3KWII0pED9RbbuQkyyOkvTY
         shSgm5Kjra84lQkmM2aqWb7UnGSv+aNu9sp6RiymLlp11kxqXdfdKGGO+8ASfRPhrmvC
         F3d5c2tsAYpz0xBi30EU+d6RkVYrJ2sjNs979N/OyNQkN48Co0/WNnzTxG1w2EKUVIRD
         3NiYkoFl5m4kllAl0HQtCCk+4pYHCmXa4D2o498b0BZTwsjMftx+ZvhH89Bh+tEX7S53
         DMsg==
X-Gm-Message-State: AOJu0YxFvkFCf8Mlyk7fjmT8HEjRZMI3Qyc/CENZ5igGjkYAc0wWxIUK
	WSMg81dNJEAwyGBrwCMLBTa3yfQfPsA5mQ1sG475D15GA8yzISloXJkzCaVBHczeL2P4ODZz4vX
	X5FUxKzMBdtDlIWx9ggzqix6H
X-Received: by 2002:a92:c561:0:b0:35f:fa79:644 with SMTP id b1-20020a92c561000000b0035ffa790644mr12233621ilj.3.1705385952616;
        Mon, 15 Jan 2024 22:19:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHI3QmE1AD6Z+nAbVNM3OMCvfP7YDFhM98TU6JD0h2wwcYA9GNa4rUkzp3YjnsgmsSb1OQfOQ==
X-Received: by 2002:a92:c561:0:b0:35f:fa79:644 with SMTP id b1-20020a92c561000000b0035ffa790644mr12233612ilj.3.1705385952371;
        Mon, 15 Jan 2024 22:19:12 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t1-20020a02b181000000b0046e759037f4sm1510591jah.33.2024.01.15.22.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jan 2024 22:19:11 -0800 (PST)
Message-ID: <16c774cc-090e-4a81-8d49-1c2a369adb8c@redhat.com>
Date: Tue, 16 Jan 2024 14:19:05 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/3] runtime: arm64: Skip the migration
 tests when run on EFI
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, Thomas Huth <thuth@redhat.com>,
 Nico Boehr <nrb@linux.ibm.com>, Colton Lewis <coltonlewis@google.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
References: <20231130032940.2729006-1-shahuang@redhat.com>
 <20231130032940.2729006-3-shahuang@redhat.com>
 <20240115-92ecda86253ec8b52f348eda@orel>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240115-92ecda86253ec8b52f348eda@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/15/24 20:25, Andrew Jones wrote:
> On Wed, Nov 29, 2023 at 10:29:39PM -0500, Shaoqin Huang wrote:
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
>>   scripts/runtime.bash | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index c73fb024..64d223e8 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -156,6 +156,10 @@ function run()
>>   
>>       cmdline=$(get_cmdline $kernel)
>>       if find_word "migration" "$groups"; then
>> +        if [ "{CONFIG_EFI}" == "y" ]; then
>> +            print_result "SKIP" $testname "" "migration tests are not supported with efi"
>> +            return 2
>> +        fi
>>           cmdline="MIGRATION=yes $cmdline"
>>       fi
>>       if find_word "panic" "$groups"; then
>> -- 
>> 2.40.1
>>
> 
> This isn't arm-specific, so we should drop the arm64 prefix from the patch
> summary and get an ack from x86 people.
> 

Ok, I can fix it and respin.

> Thanks,
> drew
> 

-- 
Shaoqin

