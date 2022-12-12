Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF627474
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 22:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670884032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zeSZwvHmFeU5UUDXCwOByZegtobcOblZc96Ym35chsE=;
	b=O1eS1kWjOUo7T2E/0LW79S2Ha/5C4vPnl8Gov5IbNhzcCVeW08OHr4GhkffMd3jY5fRMtS
	7WgOghRsXLO/s6nIS9ltW2H8t29O7ZObzOehzWe+O6v6w7wZxETzFczMW1uNv/3Ab1/i2Y
	4levTXatxdU22BFencp4nrRiy1dHnFQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-68-rBnRA9mGOlGEtiiQMhC_6w-1; Mon, 12 Dec 2022 17:27:11 -0500
X-MC-Unique: rBnRA9mGOlGEtiiQMhC_6w-1
Received: by mail-wm1-f72.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso3952480wms.8
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 14:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeSZwvHmFeU5UUDXCwOByZegtobcOblZc96Ym35chsE=;
        b=oIgrCAsZ3EsolZWXn0VDEJn/xnhyDrd2/bpPzG7yFelqU6+XPOr6oD+kFp707oL03s
         1OHpQXqLy3bePoUViQnasJxbYl9IcGO0maF+B7WH3VO2AmN1Cw047NrZueLhC4ECjZYH
         znAbjrVYL8aEdSH38PK2ceGcakMFVOw4dB5xhcYV/7bJpku5EvKUcv9lG0u+akUrgTiv
         BeDZL4y/SyERMQSrlt9ni1MITtDSYueVyJzMPz6hLsZil0DLEU9ioWWsXiTjK0hxqBdg
         huItTQEfGNqeMBNpxLFS/QH1vmcu8TRBw5vJgTKBdq1ga49lRLIvs7JTcZoEfwXcA07O
         AaPg==
X-Gm-Message-State: ANoB5pnaExW3vPQIsZqELnCCKWQp9DBBfmrlECVURNJ85tWPXTN6j+oM
	IiqDbBVJMnt2Vc5nD29XTvlceVgABcsU3wC57sMu+/Rx4DmgJA9EvXXxRUKWj9B685AVPdYnloT
	tPLprG2J5K2wMjSWQ
X-Received: by 2002:a05:600c:35cb:b0:3cf:360e:f37d with SMTP id r11-20020a05600c35cb00b003cf360ef37dmr14411542wmq.22.1670884030397;
        Mon, 12 Dec 2022 14:27:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5dJ0ARaW77iY6LzN30Dnbz5ebYPZeA9S1gDChcfg6ar2i9lvJt/8ICiG48/nDxEpBydsoLBw==
X-Received: by 2002:a05:600c:35cb:b0:3cf:360e:f37d with SMTP id r11-20020a05600c35cb00b003cf360ef37dmr14411523wmq.22.1670884030137;
        Mon, 12 Dec 2022 14:27:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l8-20020a05600c4f0800b003cf54b77bfesm11143797wmq.28.2022.12.12.14.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:27:09 -0800 (PST)
Message-ID: <ce1ea196-d854-18bd-0e60-91985ed5aaea@redhat.com>
Date: Mon, 12 Dec 2022 23:27:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common
 code
To: David Matlack <dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Sean Christopherson <seanjc@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit
 <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@Oracle.com>, Suren Baghdasaryan <surenb@google.com>,
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
 <20221208193857.4090582-11-dmatlack@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221208193857.4090582-11-dmatlack@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221212222706.QwMDzjKIBHFd7ftYV-QQKgSsoLxNWX_eN-Cli1pMAoo@z>

On 12/8/22 20:38, David Matlack wrote:
> +
> +	/* Derived from mmu and global state.  */
> +	const bool is_tdp;

I think this could stay in the architecture-independent part.

Paolo

