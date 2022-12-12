Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC8B7475
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 22:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670885690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A5SuLNwdZHpl5E44bqXulIn8ful04ZsB1bGOr0Kxg/E=;
	b=ZZSzFOEFew823Nrnj0h34B7b+6yujYoPWV0i/Zp+esAIG2xHOwnE90guGA5dqUf1WkOtF4
	y2yizLI89Hj9PQFdtmljEuG+LPgutqHLQqwhJj0DPjZvh6pJNFqc4CAyzzD8BPeXlzi7zn
	ydAjGmAJoSTxcpifJK+nzEmNaNzUaGY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-ZXDyGDe5MOq54DY-d3TCSQ-1; Mon, 12 Dec 2022 17:54:48 -0500
X-MC-Unique: ZXDyGDe5MOq54DY-d3TCSQ-1
Received: by mail-wm1-f72.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso3976856wms.8
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 14:54:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A5SuLNwdZHpl5E44bqXulIn8ful04ZsB1bGOr0Kxg/E=;
        b=pUssVpMy9SSQGhQjbUj83fELGVU7yUYKSBXuXItEA0K8drlBNcuirZMnYuHmN/3lZH
         LrvTXU26LFDN3r6WbiXxA8z5Pg61LWdtzxaedJpH92VNW2mvpRi37lDq9nlzZvroAhHI
         WpYjQb+QHgTgTsm/XKMPbTj5eXIxuHfPavQx0z8Io5p5L5lfycvrREEhsUTtsaPyvee8
         mw/z93Ag+00sBmt4fgCcaiBOXAc2osZGg6o7vNJ1dVu6OmOIfCj3qMyvm+wrR2hfLhmq
         SSv9nQWe4WtLlkRzTzGt2fwJfpcWX+/EsjJztqg/zOfFGCDTNtvholPYjVKCAw4ps9FH
         KRCQ==
X-Gm-Message-State: ANoB5pnPGJd1bfKWSu+Olp15OJmxmSX8Cfaz2rraGInqMzcdI29cqBbV
	5+c8ZOc7UOsoRC3Uj/rwwFN38m6tm9S2o9zrLBg0CSWk/zdPjzzOuAqeIRv7tw5bOkO6nkBicU4
	Q3fYZs7Lsm7J5rHEm
X-Received: by 2002:a05:600c:4891:b0:3d1:fbf9:3bd4 with SMTP id j17-20020a05600c489100b003d1fbf93bd4mr13513723wmp.10.1670885687620;
        Mon, 12 Dec 2022 14:54:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7KvFoJFh/xdI6Uil+R/sBcLTOuYWBFn5UTZm2GDLG0lMDUVKnPmisnw/N8nz6QJ1gfZ6zvaw==
X-Received: by 2002:a05:600c:4891:b0:3d1:fbf9:3bd4 with SMTP id j17-20020a05600c489100b003d1fbf93bd4mr13513681wmp.10.1670885687379;
        Mon, 12 Dec 2022 14:54:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h7-20020a05600c314700b003cfd4a50d5asm12200704wmo.34.2022.12.12.14.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:54:46 -0800 (PST)
Message-ID: <eb93beee-9d43-1c1e-250c-28ab7e9ebed9@redhat.com>
Date: Mon, 12 Dec 2022 23:54:44 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Oliver Upton <oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Sean Christopherson <seanjc@google.com>,
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
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
In-Reply-To: <Y5OHVzBSHPmAq2FO@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221212225444.0zRz63AGcNYJfyD6DEoRnJS9LfeOr0YrgJc_zhdUlmk@z>

On 12/9/22 20:07, Oliver Upton wrote:
>>   - Naming. This series does not change the names of any existing code.
>>     So all the KVM/x86 Shadow MMU-style terminology like
>>     "shadow_page"/"sp"/"spte" persists. Should we keep that style in
>>     common code or move toward something less shadow-paging-specific?
>>     e.g. "page_table"/"pt"/"pte".
>
> I would strongly be in favor of discarding the shadow paging residue if
> x86 folks are willing to part ways with it 😄

Yes, absolutely.  Something like to_shadow_page->to_mmu_data, sp->md, 
spt->hpt, spte->spte, sptep->hptep.

Paolo

