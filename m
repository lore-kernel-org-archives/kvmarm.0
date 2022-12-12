Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1D2C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 22:32:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAB204B959;
	Mon, 12 Dec 2022 17:32:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YfLDUizNLOkm; Mon, 12 Dec 2022 17:32:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8316B4B917;
	Mon, 12 Dec 2022 17:32:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D457D4B90B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:32:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BQdMf+50YN3n for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 17:32:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94D354B861
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:32:42 -0500 (EST)
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
 us-mta-481-hjuzlG8QPf64T3TKv5eQNw-1; Mon, 12 Dec 2022 17:32:38 -0500
X-MC-Unique: hjuzlG8QPf64T3TKv5eQNw-1
Received: by mail-wm1-f72.google.com with SMTP id
 o5-20020a05600c510500b003cfca1a327fso3957601wms.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:32:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=BHhE1QP3jUCpk1cxLuQ6KAYvI1S2lfEsXBvTRJ9YN5A=;
 b=OmaXNCNZrvgU/RVFR+rFg9VQb/2erqrxdaGhWqZq3YHwSUqDZ/bPXl22uycr1nz1iX
 Ah3DY4YXbLGVoW7yNbXy/kslxz3AE9T2Nh2nI04xyuyMHSeeKpXGOQJa6ffsqXZC59YU
 h632LaPhU3bfUmiVM2za0gwiW69bBciJSGtBCmB/Ur/m70W/DwOpWx0qip68NxAVjbSe
 ZkURFghZAQH1IAu0e2ipQtg6nKk2UeVmpUWfmKdLN4O7XUJG9iNOy8swsxuiVPSsUJDV
 cD3cl04WMN7c79A7XNKGXH6mhMQYRYvafhiZkGbgk4QTb7JxJIBCXneVsHuA19UBOoG2
 fSSQ==
X-Gm-Message-State: ANoB5plvB8Gxc7rHpXf3cq2dxxRzTe76iZOzDVK2w0dbY+Zo1Ovt6NbY
 7eg4hyo/AVMOg3xQy8njWCAMuGYIn4Sznqwz7MxZI4CYqbV0V2roHiB6eYiqtP0tRmFfJdH2sAJ
 IXLKpmKhezGwZ/UlAGpemEIFN
X-Received: by 2002:a05:600c:3d8f:b0:3c6:e62e:2e74 with SMTP id
 bi15-20020a05600c3d8f00b003c6e62e2e74mr13978225wmb.15.1670884357780; 
 Mon, 12 Dec 2022 14:32:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5rK2wuh16AKn0g4El+6pmLN9CiGHMIzRy1p4C+zNER/+4S5U+s8UBV98mPUqtRVzVGakI9Nw==
X-Received: by 2002:a05:600c:3d8f:b0:3c6:e62e:2e74 with SMTP id
 bi15-20020a05600c3d8f00b003c6e62e2e74mr13978185wmb.15.1670884357516; 
 Mon, 12 Dec 2022 14:32:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 o5-20020a05600c510500b003cfa3a12660sm186503wms.1.2022.12.12.14.32.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 14:32:36 -0800 (PST)
Message-ID: <0e159e42-ebca-c0d5-f2ae-29fa2344e720@redhat.com>
Date: Mon, 12 Dec 2022 23:32:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 06/37] KVM: MMU: Move struct kvm_mmu_page to common
 code
To: David Matlack <dmatlack@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-7-dmatlack@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221208193857.4090582-7-dmatlack@google.com>
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
