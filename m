Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598B724169
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689175794;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0wpptoa13iOAA2eHt3VMAIlTNSbRsG5Q+DUZsMk48HA=;
	b=L0CivdoQdcHHLZF1W5g6vv5cbn0p4+ZXncEK8pshV/uUsadDvlyjguATxGbJtoYU87joiZ
	p/skOqhDThbL8EL7KNYQlHeOyrgrA9fgPN0xko1CWjtAWI46J/rx/lIMiolavAeRlwTEJR
	AqVlf644lQQ+UOW2JfZCnNy/sU11dAc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-VddD-l8oO1G4WVCyymScOA-1; Wed, 12 Jul 2023 11:29:49 -0400
X-MC-Unique: VddD-l8oO1G4WVCyymScOA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7659cb9c3b3so693739785a.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 08:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689175769; x=1689780569;
        h=content-transfer-encoding:in-reply-to:references:reply-to:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wpptoa13iOAA2eHt3VMAIlTNSbRsG5Q+DUZsMk48HA=;
        b=DazLMbDLnmD0P23v5gPO1sUXrkHPZCoKyF2JdQzripTNzCABE99hjWSZx+QcQ8XeWp
         JV7tFT00aiHU+7BrrRatHSbAl8vbRpMrsDzpY8LDOuDKvqxt/TpzpCfi8WCwPo4JsIAv
         k7KgsexzspUSxbsKs2BoqzWKqjDIktNmdsD3l5pr2gg239TBo7TEcq2uR9RNKuhZe1ZY
         LbOSkGeWczh5bQoiziYq1XytPT7Hk3wWVe3Adj9RVIFmH4PiP/7EEllM0olqh5z6oC02
         FvzJ6GepQpRE0pq5hH5EhloHuIlL5VWIYksRFXKyUCJ5FqG4r4JQIa+LXO2wpYprbLwL
         su5w==
X-Gm-Message-State: ABy/qLZEut40XOKLn/y42PVEqIJ5Sp4SkEN+++ImuAM4Q7ZYKWwsB3tT
	mF45tJf0f+4YH472uyix8XB6N55ABSpNNZLLIsdTG7AN/LC4QzzSIp4I0ouQAXw0oqljuQ5A/6r
	YgKaZ4SHXlNYIZyiDJ4JvDtI/
X-Received: by 2002:a05:620a:24d3:b0:765:a828:7d02 with SMTP id m19-20020a05620a24d300b00765a8287d02mr21371757qkn.24.1689175769595;
        Wed, 12 Jul 2023 08:29:29 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFwqlGaun9VRfsJk+xBXYQQRWJBoUgTzbPMVWczaf/7qJOdeBt6gjx7mXtgfckw9FV3yiXQSA==
X-Received: by 2002:a05:620a:24d3:b0:765:a828:7d02 with SMTP id m19-20020a05620a24d300b00765a8287d02mr21371739qkn.24.1689175769353;
        Wed, 12 Jul 2023 08:29:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w14-20020a05620a148e00b00767b4fa5d96sm2231565qkj.27.2023.07.12.08.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 08:29:28 -0700 (PDT)
Message-ID: <3501eaf9-5b24-8c4c-939b-79cdc43cfc25@redhat.com>
Date: Wed, 12 Jul 2023 17:29:24 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 00/27] KVM: arm64: NV trap forwarding infrastructure
From: Eric Auger <eric.auger@redhat.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Reply-To: eric.auger@redhat.com, eric.auger@redhat.com
References: <20230712145810.3864793-1-maz@kernel.org>
 <f1e3b52d-bb6b-6d1d-5194-1a445a1d7cf1@redhat.com>
In-Reply-To: <f1e3b52d-bb6b-6d1d-5194-1a445a1d7cf1@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/12/23 17:16, Eric Auger wrote:
> Hi Marc,
> 
> On 7/12/23 16:57, Marc Zyngier wrote:
>> As people are getting tired of seeing the full NV series, I've
>> extracted some of the easy stuff which I'm targeting for 6.6.
>>
>> This implements the so called "trap forwarding" infrastructure, which
>> gets used when we take a trap from an L2 guest and that the L1 guest
>> wants to see the trap for itself.
>>
>> Most of the series is pretty boring stuff, mostly a long list of
>> encodings which are mapped to a set of trap bits. I swear they are
>> correct. Sort of.
>>
>> The interesting bit is around how we compute the trap result, which is
>> pretty complex due to the layers of crap the architecture has piled
>> over the years (a single op can be trapped by multiple coarse grained
>> trap bits, or a fine grained trap bit, which may itself be conditioned
>> by another control bit -- madness).
>>
>> This also results in some rework of both the FGT stuff (for which I
>> carry a patch from Mark) and newly introduced the HCRX support.
>>
>> With that (and the rest of the NV series[1]), FGT gets exposed to guests
>> and the trapping seems to work as expected.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.6-WIP
> 
> I have not received patches 10-27 and I do not see them on lore archive
> https://lore.kernel.org/all/20230712145810.3864793-1-maz@kernel.org/#r

Hum I was too eager to see them. Now I have received everything and they
are all visible on lore.

Sorry for the noise

Eric
> 
> Thanks
> 
> Eric
>>
>> Marc Zyngier (26):
>>   arm64: Add missing VA CMO encodings
>>   arm64: Add missing ERX*_EL1 encodings
>>   arm64: Add missing DC ZVA/GVA/GZVA encodings
>>   arm64: Add TLBI operation encodings
>>   arm64: Add AT operation encodings
>>   arm64: Add debug registers affected by HDFGxTR_EL2
>>   arm64: Add missing BRB/CFP/DVP/CPP instructions
>>   arm64: Fix HFGxTR_EL2 field naming
>>   arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
>>   KVM: arm64: Correctly handle ACCDATA_EL1 traps
>>   KVM: arm64: Add missing HCR_EL2 trap bits
>>   KVM: arm64: nv: Add FGT registers
>>   KVM: arm64: Restructure FGT register switching
>>   KVM: arm64: nv: Add trap forwarding infrastructure
>>   KVM: arm64: nv: Add trap forwarding for HCR_EL2
>>   KVM: arm64: nv: Expose FEAT_EVT to nested guests
>>   KVM: arm64: nv: Add trap forwarding for MDCR_EL2
>>   KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
>>   KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
>>   KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
>>   KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
>>   KVM: arm64: nv: Add SVC trap forwarding
>>   KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
>>   KVM: arm64: nv: Expose FGT to nested guests
>>   KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
>>   KVM: arm64: nv: Add support for HCRX_EL2
>>
>> Mark Brown (1):
>>   arm64: Add feature detection for fine grained traps
>>
>>  arch/arm64/include/asm/kvm_arm.h        |   50 +
>>  arch/arm64/include/asm/kvm_host.h       |    7 +
>>  arch/arm64/include/asm/kvm_nested.h     |    2 +
>>  arch/arm64/include/asm/sysreg.h         |  270 +++-
>>  arch/arm64/kernel/cpufeature.c          |   11 +
>>  arch/arm64/kvm/arm.c                    |    4 +
>>  arch/arm64/kvm/emulate-nested.c         | 1703 +++++++++++++++++++++++
>>  arch/arm64/kvm/handle_exit.c            |   12 +
>>  arch/arm64/kvm/hyp/include/hyp/switch.h |  126 +-
>>  arch/arm64/kvm/nested.c                 |   11 +-
>>  arch/arm64/kvm/sys_regs.c               |   15 +
>>  arch/arm64/kvm/trace_arm.h              |   19 +
>>  arch/arm64/tools/cpucaps                |    1 +
>>  arch/arm64/tools/sysreg                 |  141 +-
>>  14 files changed, 2326 insertions(+), 46 deletions(-)
>>
> 

