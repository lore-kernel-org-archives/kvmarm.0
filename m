Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260D37475
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 22:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670884362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHhE1QP3jUCpk1cxLuQ6KAYvI1S2lfEsXBvTRJ9YN5A=;
	b=UetGr0hQVlIH9v/ykp0zGN6+9zvzvtvVdcXe7oQn+OqrdWQIpX2zqz8g8/FQM+VlDuxHzw
	wM86+ABgxGCcKQk60xiLKJYsZw8RlRAHS/8HBKCXW+TY1+RrNMjycrKoSoIqko4QGTuAgI
	pMtYkGduynuGJkVdEcMYHj+ErjMF8rY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-321-KlpSdWFhOsaj4hBj7LJojA-1; Mon, 12 Dec 2022 17:32:38 -0500
X-MC-Unique: KlpSdWFhOsaj4hBj7LJojA-1
Received: by mail-wm1-f72.google.com with SMTP id bg25-20020a05600c3c9900b003cf3ed7e27bso3966077wmb.4
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 14:32:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BHhE1QP3jUCpk1cxLuQ6KAYvI1S2lfEsXBvTRJ9YN5A=;
        b=zr4fX44bCeNzmM7A/Bo2wWwer9TOgIM9O0zGcp1whJEariHmDfH5WfAAxs3oYRj150
         sFoSYAGjeq4jTV2mnRawJhNzJ538St5z1ZW9pEm/J9QKEfxXiSmg5HrWzclMK37HLg2A
         Khrn4+ZsIKUVk+eDlPSfbqIYdU7/uFJJBwNgHiJFIONmqGWzccpbd5Lw7gaeNjH2I8jP
         xlhPMD2mviAtqPGKMzk+lXwhcoeeSM/WOIKnmtSv9BoL9J+CX1VdntzOJhrv8Sl4jd+r
         mx79FumZm3TSIIPXwrA7w6LCYKtMQocWT9zGBGPfASX4iaZ1IY04GLKT4cPK7UyzfD4Q
         d8cQ==
X-Gm-Message-State: ANoB5pkOpEroCJPelsprrs3MTc9BC00j3L2tTHymputs5X/k2WSiATOl
	sJDnqW/lxHIrKDt6JYvGQ4d7vVvQDYJpZBh+14D77MS9zvJQPMvylXcFpVthZLISjuJNJvlPMje
	SPCrF2c/xj3KDPYBj
X-Received: by 2002:a05:600c:3d8f:b0:3c6:e62e:2e74 with SMTP id bi15-20020a05600c3d8f00b003c6e62e2e74mr13978210wmb.15.1670884357779;
        Mon, 12 Dec 2022 14:32:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5rK2wuh16AKn0g4El+6pmLN9CiGHMIzRy1p4C+zNER/+4S5U+s8UBV98mPUqtRVzVGakI9Nw==
X-Received: by 2002:a05:600c:3d8f:b0:3c6:e62e:2e74 with SMTP id bi15-20020a05600c3d8f00b003c6e62e2e74mr13978185wmb.15.1670884357516;
        Mon, 12 Dec 2022 14:32:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id o5-20020a05600c510500b003cfa3a12660sm186503wms.1.2022.12.12.14.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:32:36 -0800 (PST)
Message-ID: <0e159e42-ebca-c0d5-f2ae-29fa2344e720@redhat.com>
Date: Mon, 12 Dec 2022 23:32:34 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 06/37] KVM: MMU: Move struct kvm_mmu_page to common
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
 <20221208193857.4090582-7-dmatlack@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221208193857.4090582-7-dmatlack@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221212223234.sJelNeLmlRERDlGyi53NSzL9zYe7ipMGVRX250uNoFg@z>

On 12/8/22 20:38, David Matlack wrote:
> This commit increases the size of struct kvm_mmu_page by 64 bytes on
> x86_64 (184 bytes -> 248 bytes). The size of this struct can be reduced
> in future commits by moving TDP MMU root fields into a separate struct
> and by dynamically allocating fields only used by the Shadow MMU.

I think it's already possible to use a union like

	union {
		struct kvm_mmu_page_arch arch;
		struct {
			struct work_struct work;
			void *data;
		};
	};

Paolo

