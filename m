Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57C619BC5
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689952053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2LT31EnQdwzSm3B5EwQJfjJehEaFosn84rDtB5FWxnI=;
	b=NeF2q5Dk8i5rFoVQkLEDStgFiYvgJ82I4vyKQGQcI8bWDj8UIr6piO4e1oAPj8RbVpeQ8j
	uEXRDEVpF2vchUqR2OXhD1+1gv2NNwhJVM/KOui09wDGAimv4lupVwcZpczunwmrKcGeFd
	Vo2h2c34AnjoG1MHu5+MZB49zbmzbZo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-D-yniTIzPXmxhlMKrM15Rw-1; Fri, 21 Jul 2023 11:07:32 -0400
X-MC-Unique: D-yniTIzPXmxhlMKrM15Rw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-51e3713ce6eso3804127a12.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 08:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689952051; x=1690556851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2LT31EnQdwzSm3B5EwQJfjJehEaFosn84rDtB5FWxnI=;
        b=d1T3sR1y/eM/UbeOHZ7rXGv53yNJlE2sHKzba7EimjHxMdwblr2WjqDimbDaWzu8fp
         ixoT/KCBr93WYNHxEYIAkpgTFJ/1yLNSspni43XeMX4Z5q2UHi7qQ/v3CdHM5SohMrP8
         xXjhPPImhQO6EPWahBYRr/thrE04AINIct/n+x9CFv+kHPOTaqj3iZ9U5dmuO0C4vKRm
         r/AptG2IAJfaNq7C+u1ElO1be4QejsPuhwJ3E928UPbW+mSmG9Qw1nzOZu7+fmVOHu6N
         g7A0AbpwAMz1mNWPnhTDqs5m42FcxzCx3GNClQ0pSqV25pMSDDSYSlTSMsStryC7P9yK
         JHEQ==
X-Gm-Message-State: ABy/qLYKWPivtSL1op+a4AUrsXExptHXoChXhJDSO5GVzJECvVpZlK80
	yNsOIOdFpS8w+HimJUo2sCG9MZCH13dF8yVX4BZxXLlVjIEYHxXZfkfqQKrv2XWaymM1CtF4sLE
	8PbJHWMZcF58YDqzB
X-Received: by 2002:a05:6402:3596:b0:521:ae30:787d with SMTP id y22-20020a056402359600b00521ae30787dmr8297806edc.21.1689952051258;
        Fri, 21 Jul 2023 08:07:31 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEmyaXBPPcDeACqrampuhZk7coBp7sKkHctpw4dd03JKW9PMu58s3JgUnfUUPbC+bjZ7T2rgQ==
X-Received: by 2002:a05:6402:3596:b0:521:ae30:787d with SMTP id y22-20020a056402359600b00521ae30787dmr8297753edc.21.1689952050947;
        Fri, 21 Jul 2023 08:07:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id w10-20020aa7d28a000000b00521f4ee396fsm127596edq.12.2023.07.21.08.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 08:07:30 -0700 (PDT)
Message-ID: <84a908ae-04c7-51c7-c9a8-119e1933a189@redhat.com>
Date: Fri, 21 Jul 2023 17:07:27 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 13/29] KVM: Add transparent hugepage support for
 dedicated guest memory
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
 <20230718234512.1690985-14-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230718234512.1690985-14-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/23 01:44, Sean Christopherson wrote:
>   
> @@ -413,6 +454,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>   	u64 flags = args->flags;
>   	u64 valid_flags = 0;
>   
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		valid_flags |= KVM_GUEST_MEMFD_ALLOW_HUGEPAGE;
> +

I think it should be always allowed.  The outcome would just be "never 
have a hugepage" if thp is not enabled in the kernel.

Paolo

