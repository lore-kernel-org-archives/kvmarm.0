Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8B8EAE3
	for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 09:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3IwFE3R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700125526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HW09tjosuLlc9IkvvasWeHjFLCSejIF+D/lcOlPe2PY=;
	b=T3IwFE3R5jlitHrH4h8E6uJay4d9Y6S9UDCBQS+mb1NYqNO3znN7pqLB6AGAsvlBwMC9NI
	+YSuJCLi346Xq5isCgPOxb3yx6cB+m4jvExb6GHsYtT69A/7x6NVP6NIpSCjDwo45+1Cdo
	ft4XbZFw93A6xQZ1h/p3l6za3zHg1NE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-xEHNTc7YOtmGbNoDdFJlRw-1; Thu, 16 Nov 2023 04:05:24 -0500
X-MC-Unique: xEHNTc7YOtmGbNoDdFJlRw-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6c345cfcd6cso166983b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 01:05:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700125523; x=1700730323;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HW09tjosuLlc9IkvvasWeHjFLCSejIF+D/lcOlPe2PY=;
        b=l38lcPE1SjA9oKiefzhX7DulIvYxnNW03spf/q8uHTv2QwCvTY5eRVJM7OIVwDtpfY
         OqiwSW1vklKrAkabQM0dkkxa8nd4vCvKyG/pq/IbNdi6DxaEo6C7Xl5gN9J//VrQkPNQ
         ZCQciIJ7hjtHlsPNg/gmq8GCQY33phU4VRZIf5S95sRBb71HDmOrkpH6vhVqA+zmGcRi
         LJ6+nwMVenlLZVbxj12lIxbDJTECNDypSmoKyXbWI+GfEDSxvGyF2KSxOo7f1RpYoW56
         8LNWvW8m+Xuxh36Ij919NqakpXcVqPag7K0HBLm899BOV3yiMVScAkD0ri+4NdIijFOW
         DXhA==
X-Gm-Message-State: AOJu0YwsowUK4IyVRNMNRILj/7vRssAVOJRRYwVy/kU5H8YMMKgn5vCt
	qRaD+UAHWieH8D+pRCd+wFGXEXVXN51YrzSBCpJIinN0g8ubI7M1BMnWpOq5QObCvK1uoKd+Jaj
	qmZy3zWwWGwse1D6E
X-Received: by 2002:a05:6a20:da85:b0:185:ffb1:2776 with SMTP id iy5-20020a056a20da8500b00185ffb12776mr5777476pzb.4.1700125523606;
        Thu, 16 Nov 2023 01:05:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpzJ8NCXgCdrgY9veZ9iNfzdjqjrlFzdYTsmckCamkB75PNTPATHoLb/gCB8hW7r3u59OTaQ==
X-Received: by 2002:a05:6a20:da85:b0:185:ffb1:2776 with SMTP id iy5-20020a056a20da8500b00185ffb12776mr5777452pzb.4.1700125523306;
        Thu, 16 Nov 2023 01:05:23 -0800 (PST)
Received: from [10.72.112.142] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g16-20020a056a00079000b006bd9422b279sm4067107pfu.54.2023.11.16.01.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 01:05:22 -0800 (PST)
Message-ID: <ffb47630-44eb-5b6c-5fc5-c8b007c391c5@redhat.com>
Date: Thu, 16 Nov 2023 17:05:18 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: arm64: selftests: Clean up the GIC[D,R]_BASE_GPA
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231115153449.17815-1-shahuang@redhat.com>
 <ZVTmk-u-zUKC4Nrw@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZVTmk-u-zUKC4Nrw@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/15/23 23:41, Oliver Upton wrote:
> On Wed, Nov 15, 2023 at 10:34:48AM -0500, Shaoqin Huang wrote:
>> The GIC[D,R]_BASE_GPA has been defined in multiple files with the same
>> value, define it in one place to make the code clean.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> 
> Colton already posted a fix for this as part of his selftests series
> 
> https://lore.kernel.org/kvmarm/20231103192915.2209393-2-coltonlewis@google.com/
> 

I see. Thanks for notification.

-- 
Shaoqin

