Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC12575
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 14:11:39 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-55b5a3915f5so2716395a12.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 07:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688479899; x=1691071899;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVWqdQakMSUsv5oj8nSg9QczQrmrUO38b67MhpmWVYY=;
        b=dtC1ItQT3bOdvrLdBB5GlaktkLycKL2qXYMZGyPYbRcPKAINuXOdSi2pqWbjq0X2W8
         FJjgtv2EtoiykvX97reTkJxxZeuJs3WZOwefzGzDbU0evEKjgmI/jUYrfDmodLb5ujZR
         IDNuDDfIbzp9KEFSDRldGRlbp37xZsMcZmNqVi9edx2cPqEMJO5BiRTJMS9MWVb9DiUk
         CAVwBPqCfqHq5fO0w4TfTFcAMhpG6snZISS2MwRRtMOQs0nMwzjWybJGo8z+MHUmiegG
         l2ufETKraXLzTX+a+KbDouUu1MKuuAcKyRPT3ygmk8y0Y8+JVJecVFqx6Ajudq148KrX
         5cfg==
X-Gm-Message-State: AC+VfDy0OfXQfczz8xHeppXM8/zuPF2SdYr+wdVNMMizEV+QEFEcWS3+
	1GFurOLV9whMef9S7tTRCZw=
X-Google-Smtp-Source: ACHHUZ4mKI72SACTkxfTB3tQ6Ji13XYniCvY2MHAxg/n5JeT4DfHtHYI7qLyK+rPyEqNoEPYk2/cWg==
X-Received: by 2002:a05:6a20:1456:b0:12c:d9cc:340e with SMTP id a22-20020a056a20145600b0012cd9cc340emr10681222pzi.5.1688479899229;
        Tue, 04 Jul 2023 07:11:39 -0700 (PDT)
Received: from [192.168.50.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e26-20020a62aa1a000000b00682a9325ffcsm1178509pff.5.2023.07.04.07.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 07:11:38 -0700 (PDT)
Message-ID: <739807cf-4551-4760-83e0-a94026b5c1b8@acm.org>
Date: Tue, 4 Jul 2023 07:11:37 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [linux-next:master] BUILD REGRESSION
 296d53d8f84ce50ffaee7d575487058c8d437335
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 kunit-dev@googlegroups.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-usb@vger.kernel.org,
 netdev@vger.kernel.org
References: <202307032309.v4K1IBoR-lkp@intel.com>
 <7d3d61c694c0e57b096ff7af6277ed6b@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7d3d61c694c0e57b096ff7af6277ed6b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/4/23 00:15, Marc Zyngier wrote:
> On 2023-07-03 16:11, kernel test robot wrote:
>> tree/branch:
>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>> master
>> branch HEAD: 296d53d8f84ce50ffaee7d575487058c8d437335  Add linux-next
>> specific files for 20230703
>>
> 
> [...]
> 
>> Unverified Error/Warning (likely false positive, please contact us if
>> interested):
>>
>> arch/arm64/kvm/mmu.c:147:3-9: preceding lock on line 140
> 
> This *is* a false positive. The function is entered with a lock
> held, it will exit with the lock held as well. Inside the body
> of the function, we release and reacquire the lock.

Which tool reported this message? If this message was reported by 
sparse, has it been considered to add a __must_hold() annotation?

Thanks,

Bart.

