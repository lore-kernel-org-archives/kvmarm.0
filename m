Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51FE7475
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 23:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670888602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jEA/kHTqeoXaUaGcLLLnYDpNScpRzske2CPEB3QlR58=;
	b=OJWd8riMYOf3gpz8fE3e/NTDqI2oiArAxhdCaK3uB1u840ldYj1ANtvpV+l0jBPiHZRvzR
	Cpo2/kdPnL2fRV9dQvF/q4gYdiowmsNFc78yxHNwI63PwQ/i16hdmqmJVr84xZYEglDzHC
	p+5kuA8RuLmHBvAX1p0Ifye4Y7iPerw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-hANsTjKTPFeA-Nn7jrleJw-1; Mon, 12 Dec 2022 18:43:21 -0500
X-MC-Unique: hANsTjKTPFeA-Nn7jrleJw-1
Received: by mail-wm1-f69.google.com with SMTP id 125-20020a1c0283000000b003d1d8d7f266so4003184wmc.7
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 15:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jEA/kHTqeoXaUaGcLLLnYDpNScpRzske2CPEB3QlR58=;
        b=2jqkP/f5GGpS2EsKD7iM6mpxfnFbRDKliVOmeZwgFtQBMmMyDZVTwrXAD6JunEE32J
         NQbYi/UQ32EloFM1kCohMTh5khRBOgkcIVdNva7tARjMZBt0TcG2wLgioJmbpQbKmGJu
         luwxBuzbgSELWbkwStdQu7w3yMkXTMXK23L/qY7WJ2Vppq6PLoVG7s39ClNLm3whPWFU
         7i5B18iv3XaKdssB+s01JRTNygs1TWpxUlbj7tHJ6MLOEaQVTNQSEZ87C2Q0XQCKDYD1
         juhLZunJ4qZ3bL1vXM9bxdPGB2dL2QJn7M2MvG5BMDJtznZxZ5AD4E7DkWAf0EF5FhMd
         9g7Q==
X-Gm-Message-State: ANoB5pkhT9ssujz6xth3sbGswPCvUc6EQ2J5eXfAVrQNhhsEdXNt663z
	rNGeDTIC1cvQTUG1Vb3WFfOsb8fkTBCAcEm+JWfM2vMQ746V8iKUGmZaaND+ipRHoJ+LSzdczzo
	Z83bJvPQ2drw65huv
X-Received: by 2002:a05:6000:1a41:b0:232:be5d:4896 with SMTP id t1-20020a0560001a4100b00232be5d4896mr11068891wry.10.1670888600340;
        Mon, 12 Dec 2022 15:43:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6FE6NAMqQtmSlBoZgWlaFymznZFcQYb9/qLkdQoBRkq0uuA5oTNuN3c0LKnzZL0EytBO3qiw==
X-Received: by 2002:a05:6000:1a41:b0:232:be5d:4896 with SMTP id t1-20020a0560001a4100b00232be5d4896mr11068853wry.10.1670888600068;
        Mon, 12 Dec 2022 15:43:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j18-20020a5d5652000000b002427bfd17b6sm12017830wrw.63.2022.12.12.15.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:43:19 -0800 (PST)
Message-ID: <f1026204-1895-1a7e-5bf8-3527223f3778@redhat.com>
Date: Tue, 13 Dec 2022 00:43:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, David Matlack
 <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit
 <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
 Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>,
 Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org
References: <20221208193857.4090582-1-dmatlack@google.com>
 <Y5OHVzBSHPmAq2FO@google.com>
 <eb93beee-9d43-1c1e-250c-28ab7e9ebed9@redhat.com>
 <Y5e4qxjHWoMt8YGs@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5e4qxjHWoMt8YGs@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221212234317.RbKUZLAdT2hwdEflxY148Y3GgovDNH0obr2PPdpr0f0@z>

On 12/13/22 00:26, Sean Christopherson wrote:
>>> I would strongly be in favor of discarding the shadow paging residue if
>>> x86 folks are willing to part ways with it 😄
>> Yes, absolutely.  Something like to_shadow_page->to_mmu_data, sp->md,
>> spt->hpt, spte->spte, sptep->hptep.
> "host" will be confusing if when the primary MMU is involved though, e.g. I always
> think of the primary MMU's page tables as the "host page tables".
> 
> What if we keep the "S" for SPT(E) and repurpose it to mean Secondary PTE?

Makes sense, so just to_shadow_page->to_secmmu_page?

Paolo

