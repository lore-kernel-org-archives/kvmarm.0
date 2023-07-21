Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB94D1D2F6
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 11:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689940782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Y7rbnaDJbn/YejSF4mQVA8Z4grlfMZHjKPnDFxLZ8A=;
	b=NLYxJ/tI375ddfrYE69u4PU4Z9h7i6tOguCLsIe+/EncQBl2Aqsf93Gj2dpLFHHmIJWLvd
	wEHK9+sHYSWQpfB86rX4TB+P5e6nKB+99bnGoy9jC96Rwt1F2pOlKeFgF426rwViuud1tV
	rJFa43qXP2DG3tN66TNOfIOxNbBopgE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-E2R99b1dNDK8YcWIl_-TMA-1; Fri, 21 Jul 2023 07:59:41 -0400
X-MC-Unique: E2R99b1dNDK8YcWIl_-TMA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a34e35f57so118178566b.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 04:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689940780; x=1690545580;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Y7rbnaDJbn/YejSF4mQVA8Z4grlfMZHjKPnDFxLZ8A=;
        b=KZwvKsKf5ZhfaR6uyrXy0YJT8Jam8EpKcAdB4D7L45qZKN7gXkI4jcVn2rjAgX8c34
         hYknTmyAhCD5f7Qn3Tcvb1LXeccIAHTvwb3xCDNQh5/lhjledPmPbn2eWDIITA4aO4Ke
         IMc0NfSvF8ECZiTln0sqCt4owS3lOXbxZBEmaDWNkPHAOmqoMhnSVw1xwl4NSUjsf6ly
         SWgOQjiqUfmrspAcEBxmzUZsadLjMxb8gN4oVOgGe6JdZM1lEO/XywY6pbyqqHKWf7zd
         hOhclSV1+fd0TQ9L66k5CxxcXQ+attC9TLDb+Eqtit7P6Yu0YuEX8fS+4lfZVkbocxGK
         P2Tg==
X-Gm-Message-State: ABy/qLbFJhI7Sr7mMVy8LotEmf3jMa90bPXukKcPik9RavB3ChMoJjp5
	quZ/98cGHgWZkZz+QcPWGAXfa/UT43RNtImEnFo0cnbgt5N5TIsucRp4YazzGEW4c2tZ+EFUh4q
	WtogKzojwWBDtaBni
X-Received: by 2002:a17:906:2da:b0:994:54af:e282 with SMTP id 26-20020a17090602da00b0099454afe282mr1360614ejk.10.1689940779997;
        Fri, 21 Jul 2023 04:59:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEk/l1rT7vVGyK6B+M0/vN6OF6CipTv2G0AE0UWGqg9sgFPNWcoUSGmc+Sw2v1G9OPem3PIcQ==
X-Received: by 2002:a17:906:2da:b0:994:54af:e282 with SMTP id 26-20020a17090602da00b0099454afe282mr1360600ejk.10.1689940779630;
        Fri, 21 Jul 2023 04:59:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id um15-20020a170906cf8f00b00992b3ea1ee3sm2078970ejb.159.2023.07.21.04.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 04:59:38 -0700 (PDT)
Message-ID: <6118063e-5c91-acc4-129f-3bacc19f25ce@redhat.com>
Date: Fri, 21 Jul 2023 13:59:36 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 09/29] KVM: x86: Disallow hugepages when memory
 attributes are mixed
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
 <20230718234512.1690985-10-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230718234512.1690985-10-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/23 01:44, Sean Christopherson wrote:
> +static bool range_has_attrs(struct kvm *kvm, gfn_t start, gfn_t end,
> +			    unsigned long attrs)
> +{
> +	XA_STATE(xas, &kvm->mem_attr_array, start);
> +	unsigned long index;
> +	bool has_attrs;
> +	void *entry;
> +
> +	rcu_read_lock();
> +
> +	if (!attrs) {
> +		has_attrs = !xas_find(&xas, end);
> +		goto out;
> +	}
> +
> +	has_attrs = true;
> +	for (index = start; index < end; index++) {
> +		do {
> +			entry = xas_next(&xas);
> +		} while (xas_retry(&xas, entry));
> +
> +		if (xas.xa_index != index || xa_to_value(entry) != attrs) {
> +			has_attrs = false;
> +			break;
> +		}
> +	}
> +
> +out:
> +	rcu_read_unlock();
> +	return has_attrs;
> +}
> +

Can you move this function to virt/kvm/kvm_main.c?

Thanks,

Paolo

