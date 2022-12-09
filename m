Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30AFA35
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 08:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670573337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yu5+kKIER0XXOyMNzTciuKZhNByC/ICD1fCqGsVZ3Vc=;
	b=QnpueKvaSpqab2fDBhbcqtdzRFGoPSMtaNcaylMylnZtCUvMcvWgBu+ASUXeTFSXA6RBxs
	q5IoeKWradWShajuRtEfqyopkc6VvOGATsggPLgZuSSuQLmRQZzILZapy+L/+OebObEESg
	sS0dbLgi8UMTTk5mhOQiDSl5ug3gw0w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-532-5AoIcDCQOkmGuSbkbDLMnA-1; Fri, 09 Dec 2022 03:08:49 -0500
X-MC-Unique: 5AoIcDCQOkmGuSbkbDLMnA-1
Received: by mail-ej1-f70.google.com with SMTP id sh37-20020a1709076ea500b007c09b177cd1so2610809ejc.12
        for <kvmarm@lists.linux.dev>; Fri, 09 Dec 2022 00:08:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yu5+kKIER0XXOyMNzTciuKZhNByC/ICD1fCqGsVZ3Vc=;
        b=HjjDHhV8wsdfpsR6/2YrYq31Q4JNvZioLk1rQCRvUppRd4tRNuy5bwgXGNMFMYpxNF
         Twvyb9G8oiyiZZVPwR6nF0WChgNOk9+CzbSNbHB7Jjj/aqzMIsNXWcK8ylEv9gPztR2n
         qGpsT9+ylsWoKwfZ2YvRUSINisVVjKHmCsMigs0UES+axPPgLGq54/HJvr9vtK3dLqiT
         GoWBtFj1K0eaMNynf8pxSUgR4seopgRnI4uqggLg01zSIakO3VVGouNBXC8fedcxbBwG
         dQSvnjCHSDMxIoLmkh/2SOxwhtAt2YNujHd9skhoaKdVgCjN2e0dVKJ3NO2ImSDt9O7a
         Na0A==
X-Gm-Message-State: ANoB5pnBky4s/xRa9yKkzeCqXDbXr5nSfkq3vHQdFNsqYjHvvYFnvVpj
	j9YiZ/oCMyGGDIvBb+Y+wYJxZLjY4EpaIxfVuXIpQws0CTjeTqDdn+GT8lKkGK2fCr4CggjeGIw
	I0GW7y+DJ7fYQCoSN
X-Received: by 2002:a05:6402:44a:b0:46c:d2f2:123d with SMTP id p10-20020a056402044a00b0046cd2f2123dmr4697632edw.40.1670573328118;
        Fri, 09 Dec 2022 00:08:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5r7667C6OXmgEC5Z+6sRu7C2NkDmbkDiR1zIVIJ5e+pJLXpgHVV1OhFN2QxbJEA13QwmklDQ==
X-Received: by 2002:a05:6402:44a:b0:46c:d2f2:123d with SMTP id p10-20020a056402044a00b0046cd2f2123dmr4697599edw.40.1670573327883;
        Fri, 09 Dec 2022 00:08:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id s10-20020a05640217ca00b0045c47b2a800sm327301edy.67.2022.12.09.00.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:08:47 -0800 (PST)
Message-ID: <40f99ae8-e5c1-efba-ab1d-b8927938d34a@redhat.com>
Date: Fri, 9 Dec 2022 09:08:45 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck
 <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>,
 Gavin Shan <gshan@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 James Morse <james.morse@arm.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Peter Collingbourne <pcc@google.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
 Quentin Perret <qperret@google.com>, Reiji Watanabe <reijiw@google.com>,
 Ricardo Koller <ricarkol@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Steven Price <steven.price@arm.com>, Usama Arif <usama.arif@bytedance.com>,
 Vincent Donnefort <vdonnefort@google.com>, Will Deacon <will@kernel.org>,
 Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221209080845.kIaGT7cNBafmaA9j5bEh-v2XvYDGjtzLDg32fqwySL8@z>

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

