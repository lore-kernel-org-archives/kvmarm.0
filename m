Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB7015ACE
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F+SLyeE5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697634382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xDPf6ZClz1qisizpypkqehRk5MT7Q/Peay1tAP2fVMM=;
	b=F+SLyeE5aNBFLClh8JWCXJT4LEeB8jB+we1jiqG3JsvaAJxOPJ/50afzmIXsoOBDQAwI7E
	a7QjQKO+FqcrUeW6g47gmTlqtW7hVNYT51VwdfoKriwepuDLKsEwJoX0f7RbuX7oorz4wP
	TFIUaWG7a0iNuzYVRUHoddmEGuV0gl8=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-sxAs_8-YPBOyc-l4Y4VcZw-1; Wed, 18 Oct 2023 09:06:20 -0400
X-MC-Unique: sxAs_8-YPBOyc-l4Y4VcZw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3ae30e1ad6cso10696722b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 06:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697634380; x=1698239180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDPf6ZClz1qisizpypkqehRk5MT7Q/Peay1tAP2fVMM=;
        b=EunmJAfXHeVLKyaMtX5aRd1DSDYn7G610BHw5xv77dNg7RqgXbbMdGDCcP7VIrYmYq
         gOaGsjDtyHxhvyKwfDbCZp1EoUL1dsunWFmBqLDnRYBbIHupmz2QWiX3hGV0JOylBxfF
         JCixL6Kfr74Q7Py8Ss6nveIuxoMjYsg/8+jOj+D8QtxVUUntycf4+UNgT2v+BlTT1XTD
         nr+2AWnUYl2mlpb6jKBrO0qyrvaNAdJaNVo1jXcxEH1c7TiFxE2Xjt1g57yU6yeLTTiM
         dR4TJ3En44in+qzqZ/unLTIZdBuZGjEBRsD5Zke46iFh/OmFp5yBbyr3f68G8+C2Wogw
         JMpA==
X-Gm-Message-State: AOJu0YwYP7wGVcnCRuoDe8O44ME0OcLkQtk3FRJewd6OU7/VX6MEciJh
	hZ51v/pLDF47zQkvfxRCTj2cmoTnPjIAvLYS7bcv4iWHTMH96vobrgrltRi9W1b6AITo1XiJAU5
	yI4YIdhWx7ep/W6B8
X-Received: by 2002:a9d:7651:0:b0:6bc:8930:a1d4 with SMTP id o17-20020a9d7651000000b006bc8930a1d4mr4729128otl.15.1697634380058;
        Wed, 18 Oct 2023 06:06:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF28cwHOtFQEM5xgFaOvInzipiKqUbKufB+2pe6ZuBmbmYYz/MbPBWWD8uzmf2D4Eu9+1qKxA==
X-Received: by 2002:a9d:7651:0:b0:6bc:8930:a1d4 with SMTP id o17-20020a9d7651000000b006bc8930a1d4mr4729102otl.15.1697634379644;
        Wed, 18 Oct 2023 06:06:19 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.189.211])
        by smtp.gmail.com with ESMTPSA id a28-20020a05620a16dc00b007778503ebf4sm1375071qkn.16.2023.10.18.06.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 06:06:18 -0700 (PDT)
Message-ID: <8baca35a-9154-97e6-d682-032fc69d2da6@redhat.com>
Date: Wed, 18 Oct 2023 15:06:12 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 4/5] tools headers arm64: Update sysreg.h with kernel
 sources
To: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-perf-users@vger.kernel.org, Jing Zhang <jingzhangos@google.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>,
 Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-5-oliver.upton@linux.dev>
 <73b94274-4561-1edd-6b1e-8c6245133af2@redhat.com>
 <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark, Oliver,

On 10/18/23 14:16, Mark Brown wrote:
> On Wed, Oct 18, 2023 at 01:57:31PM +0200, Eric Auger wrote:
>> On 10/11/23 21:57, Oliver Upton wrote:
> 
>>>  #define set_pstate_pan(x)		asm volatile(SET_PSTATE_PAN(x))
>>>  #define set_pstate_uao(x)		asm volatile(SET_PSTATE_UAO(x))
>>>  #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
>>> +#define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
> 
>> could you comment on the *DIT* addictions, what is it for?
> 
> DIT is data independent timing, this tells the processor to ensure that
> instructions take a constant time regardless of the data they are
> handling.

> 
> Note that this file is just a copy of arch/arm64/include/asm/gpr-num.h,
> the main purpose here is to sync with the original.

Ah thanks. that's helpful for me to understand where this gpr-num.h
comes from. This could be documented in the commit msg though.

Something like:

adding tools/arch/arm64/include/asm/gpr-num.h matching linux
arch/arm64/include/asm/gpr-num.h

and syncing tools/arch/arm64/include/asm/sysreg.h with the fellow header
in the linux tree.

tbh I did not initially understand that all this diffstat was aimed to
match the linux arch/arm64/include/asm/sysreg.h. Now diffing both I have
some diffs. Doesn't it need a refresh?

Thanks

Eric
> 
>>> +/*
>>> + * Automatically generated definitions for system registers, the
>>> + * manual encodings below are in the process of being converted to
>>> + * come from here. The header relies on the definition of sys_reg()
>>> + * earlier in this file.
>>> + */
>>> +#include "asm/sysreg-defs.h"
> 
>> strange to have this include in the middle of the file
> 
> It relies on defines from earlier in the header.

