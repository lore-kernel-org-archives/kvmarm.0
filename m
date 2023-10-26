Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0387DC134
	for <kvmarm@lists.linux.dev>; Thu, 26 Oct 2023 05:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ws5wdsdi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698299701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cjg6DeVHVHA93PGNMB0fOahjVGtCb1cn+p/l3CnIPTk=;
	b=Ws5wdsdiqvtijJ840hH7+AwnzHhOinWxV3kfs3YO+qUymLdCg7AvzPlio/zJHKl/Dj3rO9
	ui3LwMkr2rTmFdDL21ShrN1gOT3tBAv7O8N2hYrlyXKAcMgScncjtPxiVbe0A0yz80uzKa
	TGxJuAW8ZjgwA39XKXhhzDZ64O8Vcvg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-UQLfnVQcOkqz0k3Knf9-QA-1; Thu, 26 Oct 2023 01:55:00 -0400
X-MC-Unique: UQLfnVQcOkqz0k3Knf9-QA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6be0f482eb3so160705b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Oct 2023 22:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698299699; x=1698904499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cjg6DeVHVHA93PGNMB0fOahjVGtCb1cn+p/l3CnIPTk=;
        b=bB5OUVbIs/U8U41k2HSFGjKwn9aTqooH2WvbD7++ssc1QZ72asuulB/Q3B3tucgZBF
         RdELTHpIxOJGdU3kYwwdF6DMQboc6cJ5IvVbgsOQdLYUwfKV+Bf580hRj+v7kN2RNxDg
         2D7Eg14114dCasMTq2fy7sy7Nd7zlz+eWNt1md6KT2QwbTYVR6OnqdpWgbBKGT4XrHHf
         gBjUeO+tAfrj7TNLT9CPAGqk9SL5XmM+QF+1ytjI6JEXURhOpS0cmAxCiFNElJ9h3Ob2
         S1cryefHM1qjosKdMAqe0PUR8cv/YI0sioaauqtSsyplSloiL6J2r/SWP/2YkXPn7gAt
         PuNg==
X-Gm-Message-State: AOJu0YxUxlZzTCITZX3LqzjnW42hZz7yg6EHBm9q6/wC/gMyftovGg3J
	nuDLUrnYpsSwcv7n0yX1JoIePjAk0s+ly31VzwHcDbcGVSJ2MEnaaetYi2wMANX59X6l0J/Wh7d
	GABoecNekdfMM5RGc
X-Received: by 2002:a05:6a20:c188:b0:15a:2c0b:6c81 with SMTP id bg8-20020a056a20c18800b0015a2c0b6c81mr20697457pzb.3.1698299699295;
        Wed, 25 Oct 2023 22:54:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZIE9oSBGnpBc+/dOEbUzvR6MHa5tqGFrzsXG6ZL6CNPU7Mv41W8vbMDxYflPpTKr3D98sTg==
X-Received: by 2002:a05:6a20:c188:b0:15a:2c0b:6c81 with SMTP id bg8-20020a056a20c18800b0015a2c0b6c81mr20697446pzb.3.1698299698974;
        Wed, 25 Oct 2023 22:54:58 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id iy10-20020a170903130a00b001c613091aeesm10171465plb.293.2023.10.25.22.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 22:54:58 -0700 (PDT)
Message-ID: <9052ed87-e5cf-4d89-b480-54da4d8216c7@redhat.com>
Date: Thu, 26 Oct 2023 13:54:55 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1] configure: arm64: Add support for
 dirty-ring in migration
To: Thomas Huth <thuth@redhat.com>, andrew.jones@linux.dev,
 kvmarm@lists.linux.dev
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
 Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
References: <20231026034042.812006-1-shahuang@redhat.com>
 <e318cd46-b871-448a-b95a-01647d8afc43@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <e318cd46-b871-448a-b95a-01647d8afc43@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/26/23 13:12, Thomas Huth wrote:
> On 26/10/2023 05.40, Shaoqin Huang wrote:
>> Add a new configure option "--dirty-ring-size" to support dirty-ring
>> migration on arm64. By default, the dirty-ring is disabled, we can
>> enable it by:
>>
>>    # ./configure --dirty-ring-size=65536
>>
>> This will generate one more entry in config.mak, it will look like:
>>
>>    # cat config.mak
>>      :
>>    ACCEL=kvm,dirty-ring-size=65536
>>
>> With this configure option, user can easy enable dirty-ring and specify
>> dirty-ring-size to test the dirty-ring in migration.
> 
> Do we really need a separate configure switch for this? If it is just 
> about setting a value in the ACCEL variable, you can also run the tests 
> like this:
> 
> ACCEL=kvm,dirty-ring-size=65536 ./run_tests.sh
> 
>   Thomas
> 

Hi Thomas,

You're right. We can do it by simply set the ACCEL when execute 
./run_tests.sh. I think maybe add a configure can make auto test to set 
the dirty-ring easier? but I'm not 100% sure it will benefit to them.

Thanks,
Shaoqin

-- 
Shaoqin

