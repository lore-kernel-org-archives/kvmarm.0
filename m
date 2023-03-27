Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7192223DA
	for <kvmarm@lists.linux.dev>; Mon, 27 Mar 2023 13:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679925563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ib1Sbmeg5wn9T9cMjoPs94Ttz/AXNygGsYMj5t3rfL0=;
	b=CRhej7xCjHzbreEHlh1YDwp5eQLDRmE7fdh74HFbALhk4ZkP/rtJ3efquQLJWLuvkYve9/
	77vca4tckAX+PCw4mWoUTbiWeHiqNLRUcLfwwL/RA2rKLYuVdhvyMDvLwohznX992w8ZFL
	OBAWXfraRRNx0yhNrOHyfyJZIP/heFU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-vBUlaMPaOJe-9DFcw0UyGA-1; Mon, 27 Mar 2023 09:59:22 -0400
X-MC-Unique: vBUlaMPaOJe-9DFcw0UyGA-1
Received: by mail-ed1-f69.google.com with SMTP id es16-20020a056402381000b004fa3e04c882so12768598edb.10
        for <kvmarm@lists.linux.dev>; Mon, 27 Mar 2023 06:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679925561;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ib1Sbmeg5wn9T9cMjoPs94Ttz/AXNygGsYMj5t3rfL0=;
        b=ZgIIPe/oenJigq3wAX9zt/E6vROAoMFU8JR5lSrKOf68+lwB5zgPAQctaJunbYH+no
         eHDcNUqNIqSnwQcXzkutOfq925nXAT1eVuZoEJYja0rKsDqDwE3MCSAb/uzmS41CW+1b
         bdwl1FKDHW50Iot0O3SJF+KxPsenI6EdU4qw8eO26/YMtwwwq68SCFYHg9RqG/IiiSjl
         Yy4sF4rfNNnhqfPQ2p31sYTz64Q5LX+a8kFVjIVFg8zOLbpou+3LpPhOJ0ZppmVLRMeA
         Yo3JD5kBoNxuXIB1mDOmg+ARCEVsbTQFQYqylJwvPVUHEKAx3fSQvWDawTys3UqVJiQG
         QJMQ==
X-Gm-Message-State: AAQBX9c2AgEcMyjYKuBLxLnIwHw/kGE7Uo5OZChUHl1Zzh6/m6KwRtqY
	JugT4bcvZWA7n1m0gnN91CiQ7FPk4kW2vKBHhO5xT8CmQbhnf8e6a2WZwC+iOqfWX/AjHWJ07Fj
	Mi+X7iT8ajQppxKk9
X-Received: by 2002:a50:fe94:0:b0:4f9:9e56:84bf with SMTP id d20-20020a50fe94000000b004f99e5684bfmr11332083edt.10.1679925561232;
        Mon, 27 Mar 2023 06:59:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350bnOgenmvlJK/KfZzoCNV2Y22c0JxxStJEq6tgQdOSRmSq0EomzPpCWswApUOVHdn7LueBBXg==
X-Received: by 2002:a50:fe94:0:b0:4f9:9e56:84bf with SMTP id d20-20020a50fe94000000b004f99e5684bfmr11332072edt.10.1679925560982;
        Mon, 27 Mar 2023 06:59:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 15-20020a508e4f000000b004fa99a22c3bsm14659319edx.61.2023.03.27.06.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 06:59:20 -0700 (PDT)
Message-ID: <49385a34-6ad7-255d-68d9-6b41a76f01df@redhat.com>
Date: Mon, 27 Mar 2023 15:59:19 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #2
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: reijiw@google.com, dmatlack@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
References: <ZBPZ4D9MIsaCNDh6@thinky-boi> <ZB3o/jsQIwS+4g4E@linux.dev>
 <86v8imwhi1.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <86v8imwhi1.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/23 13:39, Marc Zyngier wrote:
>> Paolo,
>>
>> Pinging this PR in case you missed it, the issues around host page table walks
>> are particularly urgent as the race on host page table teardown has been
>> reproduced on some setups.
> If we don't hear from Paolo shortly, I suggest we route this via the
> arm64 tree.

It missed the pull request I sent on March 17th by a few hours.  I have 
queued it now and will send it to Linus later today.

Paolo

