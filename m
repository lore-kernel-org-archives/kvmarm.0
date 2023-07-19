Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FA117F6
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689786745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zkcPX3Osb4OA2D5IidduaA2zXjGkNlWKrQ0mhSge49c=;
	b=KFEleRgGCXbf7CZS6xve3EvIiO65fo76jN5d0lQbnmromQAnEFZhLImaiy7zYhh/Ppub66
	2hrPiqBPD/RWcYYhQW9zhLUv+N5U2lDEhwE3l4uTByHqs56FiqlFxBNRW599vSAJCbz3Ha
	96aRLAkh1iS2vf4H//5+jOpZ5ixH9j8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-g5ZOntVBOe-frS2Zwfzl7g-1; Wed, 19 Jul 2023 13:12:24 -0400
X-MC-Unique: g5ZOntVBOe-frS2Zwfzl7g-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-978a991c3f5so420148866b.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 10:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689786743; x=1692378743;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zkcPX3Osb4OA2D5IidduaA2zXjGkNlWKrQ0mhSge49c=;
        b=HehY+fQUGltZ2GTHdJqx/XXHM7R/+KMMl61N722nGArxHQ1ranZ9RYW5C7goNzNEoT
         LKddhU75pb8ER01Fctp09aU6Ezwi0pTJWhkeRQRAwqRIFK8MWwG8iG6k6/YLG0vyI6oz
         j10gwCy8tWV1IS3uSvq8w9sJovL9q8P9Mskkre/es1ZGRqS43TENZrCHArMRFKFKTtq0
         1nNwj7YUMIy1EP5RjxteyfFfjygVyJm6Iy6kN3TCmjWMq0YZGH2aW7KEy/kWJvLM15Zx
         dtrHOkx8dW4mPTPKFSymi18d13Q0m1k+rLH2IPaI6nRAOOnxZ5VxaFtEYZFNR9pn/fK0
         Kr/A==
X-Gm-Message-State: ABy/qLaw3s8l2p6BlpshC9XyJNy+ehM1YGxvhJw4TS701OKFKnd0mOgo
	7yb3m4Fu4yxoykxxwsKuAepR9aabNJgWmLjmGbQqxTIBnqhzVlEXYpAPFF5xEAi8NPBFv6L6VXh
	DGRyDFD3QcCcd4gQl
X-Received: by 2002:a17:906:d84:b0:994:54ff:10f6 with SMTP id m4-20020a1709060d8400b0099454ff10f6mr2451579eji.30.1689786743715;
        Wed, 19 Jul 2023 10:12:23 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGz54zGhPvYMbmpFt53PQK6LgNX37cQEB9yNTieid5ItMiwID6yFOylHPqQjVFsqfqQ8BKwkQ==
X-Received: by 2002:a17:906:d84:b0:994:54ff:10f6 with SMTP id m4-20020a1709060d8400b0099454ff10f6mr2451551eji.30.1689786743496;
        Wed, 19 Jul 2023 10:12:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id h24-20020a1709063c1800b00989828a42e8sm2589100ejg.154.2023.07.19.10.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 10:12:21 -0700 (PDT)
Message-ID: <095133d1-ad3a-8b5d-d000-10b0b377c7b3@redhat.com>
Date: Wed, 19 Jul 2023 19:12:18 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 02/29] KVM: Tweak kvm_hva_range and hva_handler_t
 to allow reusing for gfn ranges
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>,
 Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>,
 Maciej Szmigiero <mail@maciej.szmigiero.name>,
 Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>,
 Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>,
 Wang <wei.w.wang@intel.com>, Liam Merwick <liam.merwick@oracle.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230718234512.1690985-3-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/23 01:44, Sean Christopherson wrote:
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 34 +++++++++++++++++++---------------
>   1 file changed, 19 insertions(+), 15 deletions(-)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

