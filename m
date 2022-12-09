Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D49C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 16:57:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2809E4B99C;
	Fri,  9 Dec 2022 11:57:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1-WUSjhB-Biz; Fri,  9 Dec 2022 11:57:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 049EA4B9B8;
	Fri,  9 Dec 2022 11:57:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EA8B4B99C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 11:57:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yB3a7FVcgYAU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 11:57:07 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E154B971
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 11:57:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670605026;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=kutSohfRuT0cPTr7xUVGydvOQR8mvu7/B/e5xyo3DzI=;
 b=eBWMJhM3vrGrhy//bdsu2z9RtFNRqzp3cqXBcrkhgKC6M2cX1UvUnJgGOCUGVfUY5bV3Bi
 xkB5I5TkctHgflji4SAdAqxfNcKtH6/4+OCs1RSGfpHrZs6iruTVbXBCFmYXtlnH/2Pqpx
 n7Wb6XH464Cf7LyyuIWIjL8QTgWHJXw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-FUjqlEOKPMyHKsoXZ9bILw-1; Fri, 09 Dec 2022 11:57:05 -0500
X-MC-Unique: FUjqlEOKPMyHKsoXZ9bILw-1
Received: by mail-ed1-f72.google.com with SMTP id
 w22-20020a056402269600b0046b00a9ee5fso1714979edd.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Dec 2022 08:57:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=kutSohfRuT0cPTr7xUVGydvOQR8mvu7/B/e5xyo3DzI=;
 b=oF9BefcaiThnqIrAQs+kwDEeYcDxUa4XG4SfZly7ro/i4VkxW0ssE9TTsIDTjqjSjh
 yLdAOE5Z+OYLe4BOsygG5pV95MqGye0zn6W0hG8CH+2R8B1ch11pHo+6KYD9VwC/8+XZ
 1fCZe2xpGAyq3dfyUdxH930/80FfiLGhogYj+1ovpFfgiXaiCsEcOBITqYp5rZLiEE1Y
 vdN3CF38SPF98dal0vJPGu/BEFxB0mxgbaCAdSvgdGd/3U1VLI0Bkz7bD1Rxu2t1wIaQ
 Ol1o2rFmXNfR925lhtZjE4Vj/CQuKdhUbwODnGKsIuMAdO6oD+wXjdx91T0O7exscnxE
 Ig3g==
X-Gm-Message-State: ANoB5pnROBumev3ViY0AGYG58eAHyvkvls7aHLsmAPL+BS0FgF5SVCFc
 TrrEjHERm13cA8Ni3KK4W+7/CMrcXxq9ILDHFm4MVu8FKiNdlSdwi1v7Vzp76exSutmkqtf5sDk
 ot4w/92zbIbGHFk+RosrZm2RB
X-Received: by 2002:a05:6402:183:b0:461:56b2:943 with SMTP id
 r3-20020a056402018300b0046156b20943mr5551482edv.40.1670605024508; 
 Fri, 09 Dec 2022 08:57:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5xY78xD8gU/6JmFuYoh837GurNRUBVaPbDjK9T5d+0vb14K3ITW6tzQi++uHMCwlogdk44yg==
X-Received: by 2002:a05:6402:183:b0:461:56b2:943 with SMTP id
 r3-20020a056402018300b0046156b20943mr5551438edv.40.1670605024259; 
 Fri, 09 Dec 2022 08:57:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c?
 ([2001:b07:6468:f312:1c09:f536:3de6:228c])
 by smtp.googlemail.com with ESMTPSA id
 i21-20020a170906a29500b007af0f0d2249sm129159ejz.52.2022.12.09.08.56.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 09 Dec 2022 08:57:03 -0800 (PST)
Message-ID: <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
Date: Fri, 9 Dec 2022 17:56:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
To: Oliver Upton <oliver.upton@linux.dev>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y5EK5dDBhutOQTf6@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5EK5dDBhutOQTf6@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Usama Arif <usama.arif@bytedance.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Marek Szyprowski <m.szyprowski@samsung.com>, Marc Zyngier <maz@kernel.org>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.linux.dev, Peter Collingbourne <pcc@google.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
 Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 12/7/22 22:51, Oliver Upton wrote:
>>
>> I haven't pushed to kvm/next yet to give you time to check, so the
>> merge is currently in kvm/queue only.
> Have a look at this series, which gets things building and actually
> passing again:
> 
> https://lore.kernel.org/kvm/20221207214809.489070-1-oliver.upton@linux.dev/

Thank you!  Squashed 1-2 and applied 3-4.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
