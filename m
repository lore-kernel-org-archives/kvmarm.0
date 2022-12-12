Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538D3C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 22:27:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B69194B953;
	Mon, 12 Dec 2022 17:27:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NJv0VGMloJV9; Mon, 12 Dec 2022 17:27:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60C464B86E;
	Mon, 12 Dec 2022 17:27:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C123E4B86E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:27:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mo9PC-6U2Tth for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 17:27:13 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FDCB4B865
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:27:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670884033;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zeSZwvHmFeU5UUDXCwOByZegtobcOblZc96Ym35chsE=;
 b=eibkr8klbSQncXZQFstboW32gdZU30uF/uZNuLtSCBH+qDEk1p072CAsnB4a3YkaUUN9s9
 zIk57Eph/Rcb+BxTxBPd0WcRP986anbY+D3LY3EKJPoLTo4JExUblgfjhqjtzB4gYGekxc
 ZV8bqpbprW4cjWgc61DbG8mSThkutxc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-562-Ye4I6zQIO7WRvkTKN45xcg-1; Mon, 12 Dec 2022 17:27:11 -0500
X-MC-Unique: Ye4I6zQIO7WRvkTKN45xcg-1
Received: by mail-wm1-f69.google.com with SMTP id
 9-20020a1c0209000000b003d1c0a147f6so4716647wmc.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=zeSZwvHmFeU5UUDXCwOByZegtobcOblZc96Ym35chsE=;
 b=dCb3TgkiVWDrH/ILe4+U5Ji5u5VK9n75Zeln18W7YW79qgrHsTwg+z4t2bY/ZcVTyv
 gRmGtDtK0XKIx8+MnqRRbEzfZJfn7xZMDoG9lQ3wGv+QoJaCH/qSVJte0QOIUK8wHAVL
 e7vniW6hCcW/46HOOSNhPqw+eBBxYcnha43WLE48gSFlfP47c5ySzP0gF7PlLHq/gDt7
 ZJo2OUrtP9ZRDg9M/o+Q5HJNTYYouIBhHMSfo9Y3Itu0VowmHTQI7RX/dtdPxgolGovO
 ApUgZc4jszo0nQKHEed1UTKQOwmnXAfS97vWYCm3vh5W9tfkte85Cu2tOUFoY3L5IbN8
 a2QA==
X-Gm-Message-State: ANoB5pn+zmX4Ytp9zDif5nkOheAJfcmtV919t4256xM/SRX+BDZXmSjW
 70qVly5ucM0yQr0J6mm/xl6Kgno2nBDqDe7jqerYkn+SSsLVU17X4YfIuL0aGFo6e1yFYIzd6ig
 fQSOabJsE2OVFPE4f7iJ0nkur
X-Received: by 2002:a05:600c:35cb:b0:3cf:360e:f37d with SMTP id
 r11-20020a05600c35cb00b003cf360ef37dmr14411562wmq.22.1670884030409; 
 Mon, 12 Dec 2022 14:27:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5dJ0ARaW77iY6LzN30Dnbz5ebYPZeA9S1gDChcfg6ar2i9lvJt/8ICiG48/nDxEpBydsoLBw==
X-Received: by 2002:a05:600c:35cb:b0:3cf:360e:f37d with SMTP id
 r11-20020a05600c35cb00b003cf360ef37dmr14411523wmq.22.1670884030137; 
 Mon, 12 Dec 2022 14:27:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 l8-20020a05600c4f0800b003cf54b77bfesm11143797wmq.28.2022.12.12.14.27.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 14:27:09 -0800 (PST)
Message-ID: <ce1ea196-d854-18bd-0e60-91985ed5aaea@redhat.com>
Date: Mon, 12 Dec 2022 23:27:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common
 code
To: David Matlack <dmatlack@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-11-dmatlack@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221208193857.4090582-11-dmatlack@google.com>
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
> +
> +	/* Derived from mmu and global state.  */
> +	const bool is_tdp;

I think this could stay in the architecture-independent part.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
