Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0938BC4167B
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 08:08:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E844B9FF;
	Fri,  9 Dec 2022 03:08:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tgf6TuDv+3xZ; Fri,  9 Dec 2022 03:08:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32E184B936;
	Fri,  9 Dec 2022 03:08:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 051734B91B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 03:08:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tNl4UBUmy4DX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 03:08:50 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D910E40177
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 03:08:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670573330;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Yu5+kKIER0XXOyMNzTciuKZhNByC/ICD1fCqGsVZ3Vc=;
 b=OjOMjFpIb2Q/P7B9Rg1oSpJn+Br3ouC51dkKNRLsZ6umcnjhktLudxRtHukz5n8zIE/dth
 jZbYXIoY/GH1Dik92TVUudVJEMb45uOHsMQToMHOn3c+9xGLEsQk6FQIAX0J4GlvPXTXBy
 LARyq01346V1T934siae1SoFEjTob+Y=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-bOiWbfWsMvWrux9zHBeSqA-1; Fri, 09 Dec 2022 03:08:49 -0500
X-MC-Unique: bOiWbfWsMvWrux9zHBeSqA-1
Received: by mail-ej1-f72.google.com with SMTP id
 xj11-20020a170906db0b00b0077b6ecb23fcso2629409ejb.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Dec 2022 00:08:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Yu5+kKIER0XXOyMNzTciuKZhNByC/ICD1fCqGsVZ3Vc=;
 b=rC14OUE5lqyHDoOJkoUtHGisrjbLvnn727c3nRiHKZrOjieo7TNTcRZPAwgYsMGeQ6
 ARVF/F4ql/lAFUAk9HVOG+pGx2Tc8IZS5X/JblKekLepVMmPaOEKkblo2FR0gODO9jXa
 3YNDIeNKl19DgwvU7BJRMZNoB1D0NkPyOoAqtotihY4xM06YWT7186sUj5JUy4EhOOEp
 Hbz7oa5daNsBDbKKCW+sf9nrlsIVkyYnn0zViCMO8Zm0jg3UdppLhwvo6gN971oxib05
 EwFA9t5Fm+uw0iSjd5j/F8iLNMQlZJdAJxqKi/ai6bofEZ/YVC35fU5QmgjHLqW7/NFr
 nsMg==
X-Gm-Message-State: ANoB5pmOSE1WpLLJFtRdnTKdQm+G94UoVtohOhpAxFWfcjZL+KcPCzTQ
 8oJQCAkOKUGVOhvOJJ9yNvTvgrjO4h9GQC2+uY7MAW9mahaS500IQo2kttxR/tIdD0i4RNBOky4
 kWmrEowAngCxsN9iYpPNNH9+N
X-Received: by 2002:a05:6402:44a:b0:46c:d2f2:123d with SMTP id
 p10-20020a056402044a00b0046cd2f2123dmr4697647edw.40.1670573328155; 
 Fri, 09 Dec 2022 00:08:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5r7667C6OXmgEC5Z+6sRu7C2NkDmbkDiR1zIVIJ5e+pJLXpgHVV1OhFN2QxbJEA13QwmklDQ==
X-Received: by 2002:a05:6402:44a:b0:46c:d2f2:123d with SMTP id
 p10-20020a056402044a00b0046cd2f2123dmr4697599edw.40.1670573327883; 
 Fri, 09 Dec 2022 00:08:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928?
 ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
 by smtp.googlemail.com with ESMTPSA id
 s10-20020a05640217ca00b0045c47b2a800sm327301edy.67.2022.12.09.00.08.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 09 Dec 2022 00:08:47 -0800 (PST)
Message-ID: <40f99ae8-e5c1-efba-ab1d-b8927938d34a@redhat.com>
Date: Fri, 9 Dec 2022 09:08:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
To: Marc Zyngier <maz@kernel.org>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y4+FmDM7E5WYP3zV@google.com> <Y4+H5Vwy/aLvjqbw@sirena.org.uk>
 <28e7f298-972b-2cb8-df80-951076724c73@redhat.com>
 <877cz3u00b.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <877cz3u00b.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Usama Arif <usama.arif@bytedance.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Marek Szyprowski <m.szyprowski@samsung.com>,
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

On 12/7/22 08:49, Marc Zyngier wrote:
> On Tue, 06 Dec 2022 21:43:43 +0000,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 12/6/22 19:20, Mark Brown wrote:
>>>> I almost suggested doing that on multiple occasions this cycle, but ultimately
>>>> decided not to because it would effectively mean splitting series that touch KVM
>>>> and selftests into different trees, which would create a different kind of
>>>> dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
>>>> touch selftests go into a dedicated tree?
>>>
>>> Some other subsystems do have a separate branch for kselftests.  One
>>> fairly common occurrence is that the selftests branch ends up failing to
>>> build independently because someone adds new ABI together with a
>>> selftest but the patches adding the ABI don't end up on the same branch
>>> as the tests which try to use them.  That is of course resolvable but
>>> it's a common friction point.
>>
>> Yeah, the right solution is simply to merge selftests changes
>> separately from the rest and use topic branches.
> 
> Don't know if this is what you have in mind, but I think that we
> should use topic branches for *everything*. The only things for which
> I don't use a separate branch are the odd drive-by patches, of the
> spelling fix persuasion.

Yeah, I just wish we had better tools to manage them...

Paolo

> That's what we do for arm64 and the IRQ subsystem. It is a bit more
> involved at queuing time, but makes dropping series from -next
> extremely easy, without affecting the history. And crucially, it gives
> everyone a hint to base their stuff on a stable commit, not a random
> "tip of kvm/queue as of three days ago".
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
