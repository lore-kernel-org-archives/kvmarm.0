Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3F13AE4E
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686155440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HekEEfWls+yjC0wx5sh4Q+X+c3/wbXjytqzkk9aIR5M=;
	b=MU+D4HnJ9jjaW06ub0slbO3v2deRIkmQq8smdDPXDsR1vGFyWQJBPkCUp3ViC23pN828Hy
	OraYfegQMxoJ6b6iuUyDfgPBleiiZ4TzumcT2f0WbThqbH2wzeuha8L+Fi4N5wH45rUgO8
	fLKP2b47EbJ6KB9mbGsZ53ZwOtjUM70=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-GPqXZxDbMEWi1gu6GEOu5g-1; Wed, 07 Jun 2023 12:30:39 -0400
X-MC-Unique: GPqXZxDbMEWi1gu6GEOu5g-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30ae4ed92eeso3311871f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Jun 2023 09:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686155438; x=1688747438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HekEEfWls+yjC0wx5sh4Q+X+c3/wbXjytqzkk9aIR5M=;
        b=U9LFP8ktuQUHqAJvtAn1sg0XngMmFJaDxN+Kq7GgKGBBfVNWp7+ah04Fo8sgT0TOu5
         S6aTn253YSqHuo2vhv1J/JzD7oQxJtHolrdU4DB8Ks7hlbHvW9TjIMc42T8BKvonstmj
         SK4xzW5m8N9fTh0/weWWpFormEm44G+LovfJlZseO3mEDWbkq0SXgX9LBZYjSjXNtw+y
         GJ9Q1fZhyPiodOfgoRH124ABCzfpcHVIXIegIB+Ki3iunsdF2SwMlL+rwMcg1tZGMB0+
         dHZKVG70drdTJR5rKAiQ6pZHHvOS8H+PV34F+teTynulPJnEZru1HwCDZBYpZD6xZFGJ
         40ng==
X-Gm-Message-State: AC+VfDydEIiu3umU0yH87sWl03Cb1GJwbtaP4Q7OAqxzZjd+LVEVm9+6
	NHZYJnCRiOz1s+SSgd/5CFrmfYN20fsSEW1IIuYPzEE3RGgYMgcq0d3sS52tDt3e+J61W+n5nmw
	bLEHNDJnlBqwN9Zbf
X-Received: by 2002:adf:ec4b:0:b0:2f5:9800:8d3e with SMTP id w11-20020adfec4b000000b002f598008d3emr4750016wrn.47.1686155438133;
        Wed, 07 Jun 2023 09:30:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4VO0yXsaDCa13QI5VCRbwasu1zCREpbQXmBes0MME4iDLfvpzAqo1Bs6btj/3l4HLCo7DP3Q==
X-Received: by 2002:adf:ec4b:0:b0:2f5:9800:8d3e with SMTP id w11-20020adfec4b000000b002f598008d3emr4750000wrn.47.1686155437820;
        Wed, 07 Jun 2023 09:30:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q15-20020a5d574f000000b0030e5a63e2dbsm2290628wrw.80.2023.06.07.09.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 09:30:37 -0700 (PDT)
Message-ID: <4b0bbd22-6fce-b8a7-1df5-f06778a0d28f@redhat.com>
Date: Wed, 7 Jun 2023 18:30:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <9cf2356b-f990-1cd2-c7e6-a984e9f604c6@redhat.com>
 <87r0qpnj2t.wl-maz@kernel.org>
 <c46da9eb-a02d-1b1d-9c1b-9f900a5e9e6d@redhat.com>
 <87o7lso91y.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <87o7lso91y.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 6/6/23 18:22, Marc Zyngier wrote:
> On Tue, 06 Jun 2023 10:29:36 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>> On 6/6/23 09:30, Marc Zyngier wrote:
>>> Hey Eric,
>>>
>>> On Mon, 05 Jun 2023 12:28:12 +0100,
>>> Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 5/15/23 19:30, Marc Zyngier wrote:
>>>>> This is the 4th drop of NV support on arm64 for this year.
>>>>>
>>>>> For the previous episodes, see [1].
>>>>>
>>>>> What's changed:
>>>>>
>>>>> - New framework to track system register traps that are reinjected in
>>>>>   guest EL2. It is expected to replace the discrete handling we have
>>>>>   enjoyed so far, which didn't scale at all. This has already fixed a
>>>>>   number of bugs that were hidden (a bunch of traps were never
>>>>>   forwarded...). Still a work in progress, but this is going in the
>>>>>   right direction.
>>>>>
>>>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>>>   the L0 IPA space. This fixes a number of subtle issues, depending on
>>>>>   how the initial guest was created.
>>>>>
>>>>> - Consequently, the patch series has gone longer again. Boo. But
>>>>>   hopefully some of it is easier to review...
>>>>>
>>>>> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
>>>>>
>>>>> Andre Przywara (1):
>>>>>   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
>>>>
>>>> I guess you have executed kselftests on L1 guests. Have all the tests
>>>> passed there? On my end it stalls in the KVM_RUN.
>>>
>>> No, I hardly run any kselftest, because they are just not designed to
>>> run at EL2 at all. There's some work to be done there, but I just
>>> don't have the bandwidth for that (hint, wink...)
>>
>> oh OK, I missed that point. If nobody is working on this I can start
>> looking at it. Would be interesting to run them on nested guest too.
> 
> If you want to pick this up, it would be extremely helpful. And no,
> nobody is really looking into it at the moment, so it's all yours!

OK I will study that then :-)

Eric
> 
> Thanks,
> 
> 	M.
> 

