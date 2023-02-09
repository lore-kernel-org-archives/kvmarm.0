Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C6D160
	for <kvmarm@lists.linux.dev>; Thu,  9 Feb 2023 00:15:57 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id h24so260586qta.12
        for <kvmarm@lists.linux.dev>; Wed, 08 Feb 2023 16:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K2g6mB0/Sbx4Gs5Si9V+xdYfL/m4mgF6UDvbmxWdXlE=;
        b=l0Y++TGmrtgNClFRLplnapK9EDwNRif6MD/CsaYnGYPcMhfEol/WrTBbcyjlARr23u
         5wcc81hnLoOcxCCj8oUR0pBo/eoaxVgjt60MvgipZxOsxV7s+7C3Qww5ztM7wYTr4JBW
         GRKXbrxa2xjCw+zGy3fZRj1EKP2vw5u5cz5AOdEcS3JznmDqlMFe20aTZBMzkBzHJEbs
         gNEVc2z/wovT4MeLD73AwxfqwejRdr/aBx9s72jQ5h1cY7Vma1XAFDM6vmxqP4xqPNm1
         Oy0vpsYMsdzQLJdzt0gjqWhRG/HDZXVUmGiy/8cyYkZnvStb2sy4TmLuzKJCu7mFvt0C
         /Ysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K2g6mB0/Sbx4Gs5Si9V+xdYfL/m4mgF6UDvbmxWdXlE=;
        b=KnRAN3MlghdNGCFlivwd/uu5qiQVBNJDyvf/NhStsQrLtXGayDJC1SPeMedsnqGcLp
         I+V0MLm+J5lOWSWMANU3iwC82Emem4pUj3yEWZJOo35yPs/7kK5HJErpsRt4LOCLvGL6
         jPg5mDfNIvVVoRZrMgC2xHqG5jCwYjVcIhr8Ke0UYhDJYKO+DSQglytcZe/UGdZvxCiu
         lZkUGJ1cSGEEJ5Iz8plBqHRKLOM/KSZXY8QowNqcwfK7NpZLXktSy8HZFSoHYbbPke+i
         kD2tYcQ5NEDxJ0iIohgdeg0WlhSx1i6NrGo1iDo1vTgKdecG1QusFJxp4IxNB+W4Iedg
         kK2g==
X-Gm-Message-State: AO0yUKVJCZ0+f5dD6nUOKev024PWe3WJDKGFEX1ImrzS43FZBOcHRj4q
	rao5pu0JbX55cR7eyU2/yao=
X-Google-Smtp-Source: AK7set+fesB0uqos8P2kUQ4mFFM5Nr5bh777x1pGzlQ0PUr7JyxfE3l0HEJ/8JqI9U4CiTIgm35WrQ==
X-Received: by 2002:ac8:5f06:0:b0:3b8:6b30:7e30 with SMTP id x6-20020ac85f06000000b003b86b307e30mr12964744qta.54.1675901756717;
        Wed, 08 Feb 2023 16:15:56 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u9-20020ac87509000000b003b646a99aa6sm167464qtq.77.2023.02.08.16.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 16:15:55 -0800 (PST)
Message-ID: <6abb6cef-a9b3-7542-6e8a-fb463449ddf6@gmail.com>
Date: Wed, 8 Feb 2023 16:15:51 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/8] perf: arm: Make PMUv3 driver available for aarch32
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Zaid Al-Bassam <zalbassam@google.com>
Cc: Jesus Sanchez-Palencia <jesussanp@google.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
References: <20230126204444.2204061-1-zalbassam@google.com>
 <86fsbgyutf.wl-maz@kernel.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <86fsbgyutf.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/8/23 08:40, Marc Zyngier wrote:
> On Thu, 26 Jan 2023 20:44:36 +0000,
> Zaid Al-Bassam <zalbassam@google.com> wrote:
>>
>> Currently, PMUv3 driver is only available for ARMv8 aarch64
>> platforms, ARMv8 running in aarch32 mode dont have access to
>> the driver. This is, especially, a problem for ARMv8 platforms
>> that only have aarch32 support, like the Cortex-A32.
> 
> FWIW, I've pushed out my own interpretation of this series to [1],
> including the changes I suggested. The results seems to correctly work
> in a 32bit guest on a 64bit host, which is what I (used to) care
> about.
> 
> Feel free to pick it up.

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian

