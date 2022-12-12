Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4DBC00145
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 23:11:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F2B64B960;
	Mon, 12 Dec 2022 18:11:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DaxwEJu8TNRy; Mon, 12 Dec 2022 18:11:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CDC94B955;
	Mon, 12 Dec 2022 18:11:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AA634B951
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:11:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DpK9i9eRLhYF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 18:11:46 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44DBC4B950
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:11:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670886706;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ro+zcDO7opJfp7WFDTaK4QIlqGiqpBQjwVa0Lz8JmGo=;
 b=RQwZ6PiffjWvTSuusrLT+932iuhHkixj+8k7HSshe7k1GGKt5NKYjsY4PQfQzRwU8rx25m
 CNk1Jd/Ib0zS8fH1DUusqfUXbvah9qUeRfMyI+31WSnOUSN7tmE6Dmw81XxLdnonO4xdn4
 CWYA8o5GD8bYrqt8xUTaRWJXz2dcJ0Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-266-j2sfFrjyMwecwIcE5esoYQ-1; Mon, 12 Dec 2022 18:11:45 -0500
X-MC-Unique: j2sfFrjyMwecwIcE5esoYQ-1
Received: by mail-wm1-f71.google.com with SMTP id
 t24-20020a1c7718000000b003d1fd0b866fso2336104wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 15:11:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Ro+zcDO7opJfp7WFDTaK4QIlqGiqpBQjwVa0Lz8JmGo=;
 b=gMGkR/zOONk1fwmR21wMtl+PsK5sD0QmiKszqQcAfo33aaBvZsGZmZEpTXa857Ss5I
 yMo6hQmv6x5/sJBguzWZy5qKmsss2jDJNC98n6gGvb6wQaJ/Nl+Hc3axuX1nDar25TD3
 VsBiIKOHv9molyS5DDvLwCBvUj0He8AzeSVShTIIqSIz0N1hxG7HXP0OzGaJxP5Fmp9M
 MMTbCUk3ZRbMie5znIs/btz8wAdqWFclxPJeJ1LuabtB8nuHj3eo0OOJqU7mLJccKq7M
 Sa9f1mchZzVkg/XUQJvy5RZ+eK7rpRnlmGFEvjIVo2WlqKtsgAdfU+3ChMOum86/Jqf/
 X/9w==
X-Gm-Message-State: ANoB5pkLep/QvqOTKTbHtRP2p4rIBPOEQ6kAa9qhzR/K4I0eXxSwm4n6
 lEuwQ5vIexCn4AC7Qi2UVvCa5BtMqD0fReWbwCM29mlNxkzUmK9XzFRMY0tS17D96GJsdKUhfqB
 VG9xf4d7Q1DjMWBR7RLpRunAN
X-Received: by 2002:a05:600c:3d19:b0:3c6:edc0:5170 with SMTP id
 bh25-20020a05600c3d1900b003c6edc05170mr14313818wmb.25.1670886702689; 
 Mon, 12 Dec 2022 15:11:42 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5lDfiYN0rE6YVEbmBF7N8YZEpLr9T7uo4Q3R+sKGlV+dcjnOy985UIqQQiqS+aPBilidYnPg==
X-Received: by 2002:a05:600c:3d19:b0:3c6:edc0:5170 with SMTP id
 bh25-20020a05600c3d1900b003c6edc05170mr14313790wmb.25.1670886702453; 
 Mon, 12 Dec 2022 15:11:42 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 i14-20020a05600c354e00b003c6f3f6675bsm11712338wmq.26.2022.12.12.15.11.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 15:11:41 -0800 (PST)
Message-ID: <48f4df00-8ef6-042f-c9ae-4023c4f70058@redhat.com>
Date: Tue, 13 Dec 2022 00:11:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: David Matlack <dmatlack@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-3-dmatlack@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 02/37] KVM: MMU: Move struct kvm_mmu_page_role into
 common code
In-Reply-To: <20221208193857.4090582-3-dmatlack@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 Ben Gardon <bgardon@google.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Yu Zhao <yuzhao@google.com>,
 xu xin <cgel.zte@gmail.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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

On 12/8/22 20:38, David Matlack wrote:
> +/*
> + * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
> + * also includes TDP pages) to determine whether or not a page can be used in
> + * the given MMU context.
> + */
> +union kvm_mmu_page_role {
> +	u32 word;
> +	struct {
> +		struct {
> +			/* The address space ID mapped by the page. */
> +			u16 as_id:8;
> +
> +			/* The level of the page in the page table hierarchy. */
> +			u16 level:4;
> +
> +			/* Whether the page is invalid, i.e. pending destruction. */
> +			u16 invalid:1;
> +		};
> +
> +		/* Architecture-specific properties. */
> +		struct kvm_mmu_page_role_arch arch;
> +	};
> +};
> +

Have you considered adding a tdp_mmu:1 field to the arch-independent 
part?  I think that as long as _that_ field is the same, there's no need 
to have any overlap between TDP MMU and shadow MMU roles.

I'm not even sure if the x86 TDP MMU needs _any_ other role bit.  It 
needs of course the above three, and it also needs "direct" but it is 
used exactly to mean "is this a TDP MMU page".  So we could have

union {
	struct {
		u32 tdp_mmu:1;
		u32 invalid:1;
		u32 :6;
		u32 level:8;
		u32 arch:8;
		u32 :8;
	} tdp;
	/* the first field must be "u32 tdp_mmu:1;" */
	struct kvm_mmu_page_role_arch shadow;
};

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
