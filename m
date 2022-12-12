Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D616A23C5
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 10:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670841382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mQe1vPVAoLefYVtJgOMADA9UsAQ3Kxq8XGAB/nV1Q60=;
	b=KlAay9MJGpxeE6NzBHN8eaGv9IigyHXkeGe5B2F4fmy9KJnp/x83LWn7mTcQEhdeCkao9I
	aiHhPS1JQHswfErvLzQib0xsqbPx5TMvGOQqJX/ffj0TqK5XxqqGwZiciso3zmqWe/2XvM
	HHUaIHqKfCZ0aCBckp4/zooIi3CVxbc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-ybnWBjsiM8CUSwpghYMuaQ-1; Mon, 12 Dec 2022 05:36:21 -0500
X-MC-Unique: ybnWBjsiM8CUSwpghYMuaQ-1
Received: by mail-wm1-f71.google.com with SMTP id h9-20020a1c2109000000b003cfd37aec58so3173148wmh.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 02:36:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQe1vPVAoLefYVtJgOMADA9UsAQ3Kxq8XGAB/nV1Q60=;
        b=WBCbXFB2LWYAQkan2gMVNdAIi+1qVkIMau1NRYreMT0rb7SDTVcUY/HRt2KD/ficu3
         IBV7L4y5BJbS+pxGFfhpHwDlA9afmagHMQrTjjQa+AxV5eNL6AMhLbR4BSHkJ+yYAT3L
         jtDiYTV46I1PwdwhK5QSxXZse0NAG13Y1bp9VEQ2DHlXFs7gmhI9xOl5pO0jnqdqq9X+
         QugFzhYPIDI+t1SV7gYnuGxatiS8u7fRhdrUgi8CVbPWHfKpN7nOPi7s/HemuJ0DRbeK
         CS5WQQ4xJX/sRRYnprt9oH5gu1WwtSd3rTpFLBjP4dmV9ySrGFe6t0ZF4O449XudGxUc
         +aMA==
X-Gm-Message-State: ANoB5pnbnuJVm2LCt2AyM0gUxesqhvznsf6Hp/ECjCGmci0/gx0bt6Tk
	+izNs9wGcQ2Jg99wKNVOD6IKsuX1rLHhQTthPFjbXz439y2yhVUeX7nAqPCAqwZQBFRLGhzFUiI
	uvvXsaM4lXUr7EFhe
X-Received: by 2002:a5d:564a:0:b0:24c:f1ca:b2df with SMTP id j10-20020a5d564a000000b0024cf1cab2dfmr5988131wrw.67.1670841380634;
        Mon, 12 Dec 2022 02:36:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5yfwj5UnZ7QW7iYJjXIjnpYQh7U361r5HLW6PWTGWDdexdLTapuWofhSkU9q9aAnLfd+7YDA==
X-Received: by 2002:a5d:564a:0:b0:24c:f1ca:b2df with SMTP id j10-20020a5d564a000000b0024cf1cab2dfmr5988117wrw.67.1670841380414;
        Mon, 12 Dec 2022 02:36:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bp8-20020a5d5a88000000b00241e8d00b79sm10772956wrb.54.2022.12.12.02.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 02:36:19 -0800 (PST)
Message-ID: <42dbdb4d-13da-cd6b-e2ad-95b0cb0ff04e@redhat.com>
Date: Mon, 12 Dec 2022 11:36:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ricardo Koller <ricarkol@google.com>, Sean Christopherson <seanjc@google.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221212103618.GRCCKMXxWNA6qycrkXJY-bFUb9ObV9dnUsb--PFtaRA@z>

On 12/9/22 02:52, Oliver Upton wrote:
> The combination of the pool-based ucall implementation + page_fault_test
> resulted in some 'fun' bugs. As has always been the case, KVM selftests
> is a house of cards.
> 
> Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
> be squashed into Paolo's merge resolution, if desired.
> 
> Tested on Ampere Altra and a Skylake box, since there was a decent
> amount of munging in architecture-generic code.
> 
> v1 -> v2:
>   - Collect R-b from Sean (thanks!)
>   - Use a common routine for split and contiguous VA spaces, with
>     commentary on why arm64 is different since we all get to look at it
>     now. (Sean)
>   - Don't identity map the ucall MMIO hole
>   - Fix an off-by-one issue in the accounting of virtual memory,
>     discovered in fighting with #2
>   - Fix an infinite loop in ucall_alloc(), discovered fighting with the
>     ucall_init() v. kvm_vm_elf_load() ordering issue

Queued 3+5, thanks.

Paolo

