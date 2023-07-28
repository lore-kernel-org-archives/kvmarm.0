Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3530F14A98
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690560812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Dyh7+qatvQDKM5qDRHq8YkO5TCQeLww3uN1vYmzEUU=;
	b=EzFo3gQj5XQ/9hIaortrhTD4LYBvIArNQeuoEUMjFSmK9OVj9+r5R7l037EK/2lLnNq90Z
	iCl5HGQAazJ5SxihMyCGgtE/1fNg8e8aP6nCISlzVK2BY7YZYcv/jQY5OtVem140TIuwGZ
	xjSysc4LiYaO9KBdfIkJceHnTkWpOxw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-TAORUiDjP2mJkZk5eGClJA-1; Fri, 28 Jul 2023 12:13:30 -0400
X-MC-Unique: TAORUiDjP2mJkZk5eGClJA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-978a991c3f5so138008366b.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 09:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690560809; x=1691165609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Dyh7+qatvQDKM5qDRHq8YkO5TCQeLww3uN1vYmzEUU=;
        b=irRkzOow/U3VFhycRyw8wIvIx7XHWfg1HBew4dHrzX7Gkwsq59F4X8qcqEuy+6EHyy
         lrllvXyRVspWIpHEzW+QV4/SGXZEiswyWUComD6jV3LFKGesbN2QMm6WpbAoQGm6IeZ0
         ujD5HhsrVlTpI+q+XoxogKzxHyLBTf61MabpFCqH/vmlukMtxPglzQR5P/ix2M+x5/yE
         nd6aAUdfMOvEY4onbVykPRXMUyDXeljDhR3R+/xipjf8+/yGJfvXcUp2uJ0p2Nqvpms7
         IBeMy8CmT3FSJQI8kQc6f/R5lmBvi8jDkQb9zUt8bnigjluoDwne645INO0oaixyRrEF
         86dw==
X-Gm-Message-State: ABy/qLa9mfzms/wDCecaKNkfyNODISuE+N8LOR0vKXEoLBCqUIKTKP2V
	kium0sx3Bo4N7qjR1qktarNiYKvBRBDorY2r4D8hc/DdDlf0iZySqs1Hcfh1gTnStDaQ623rvIU
	GnbfUiBhcIgZiwRQj
X-Received: by 2002:a17:906:5354:b0:99b:efd3:3dcc with SMTP id j20-20020a170906535400b0099befd33dccmr1357368ejo.62.1690560809632;
        Fri, 28 Jul 2023 09:13:29 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHd2sX/AyGtIAscRR2p4pTksaGOsuCTBRQ37WpaEGChaEB1fcJtjozFJjrwhV4jFSHGD+pttg==
X-Received: by 2002:a17:906:5354:b0:99b:efd3:3dcc with SMTP id j20-20020a170906535400b0099befd33dccmr1357325ejo.62.1690560809219;
        Fri, 28 Jul 2023 09:13:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id gy26-20020a170906f25a00b00993470682e5sm2197928ejb.32.2023.07.28.09.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 09:13:28 -0700 (PDT)
Message-ID: <6da710cf-2bc0-bb6e-26f1-fba14ca767db@redhat.com>
Date: Fri, 28 Jul 2023 18:13:26 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 10/29] mm: Add AS_UNMOVABLE to mark mapping as
 completely unmovable
To: Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
 David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>,
 Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
 Liam Merwick <liam.merwick@oracle.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-11-seanjc@google.com>
 <20230725102403.xywjqlhyqkrzjok6@box.shutemov.name>
 <ZL/Fa4W2Ne9EVxoh@casper.infradead.org>
 <692b09f7-70d9-1119-7fe2-3e7396ec259d@suse.cz>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <692b09f7-70d9-1119-7fe2-3e7396ec259d@suse.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/23 18:02, Vlastimil Babka wrote:
>> There's even a comment to that effect later on in the function:
> Hmm, well spotted. But it wouldn't be so great if we now had to lock every
> inspected page (and not just dirty pages), just to check the AS_ bit.
> 
> But I wonder if this is leftover from previous versions. Are the guest pages
> even PageLRU currently? (and should they be, given how they can't be swapped
> out or anything?) If not, isolate_migratepages_block will skip them anyway.

No, they're not (migration or even swap-out is not excluded for the 
future, but for now it's left for future work.

Paolo

