Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE6D27F00
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 17:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689959863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kQftevPX0XUeLPrBO0NAWxPIrge3Hp6/1+H4UC+Ikhg=;
	b=jOullois1qXlg5Og+Hk4Cxtese+TCHcC8rw2CeBbTUYPjQg7FTnFa6SP0p+5V8JrHXT/da
	mdFJ8HQdnvBlcY9viQASyeBegU5sASkpq5ANhGB4LihO0dE487hh3CGC6sPdmnpAAuSMU7
	inuj12KMvP2UdGF5aE1s2CTQsTtq9hk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-4248CVLqOKW9elXB-xboOw-1; Fri, 21 Jul 2023 13:17:42 -0400
X-MC-Unique: 4248CVLqOKW9elXB-xboOw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-51e10990adfso1349898a12.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 10:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689959861; x=1690564661;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQftevPX0XUeLPrBO0NAWxPIrge3Hp6/1+H4UC+Ikhg=;
        b=gtvzYdb/19Qk2IEkA00uA9tR/aeAB/fzfOpdd/HdJOlu2ORDsycFPHqD9olYydDrXf
         awwM31rEHWdD6idpFIerTukLck/T6U+VTacgBPq/b1Wm8Ew9Lfu5C89Jo9UM5euXQylb
         EZWxPgODvZx6J7LC/C8mlRqQjaAjnMUw88x2pii2X2vZ1TQPESrkc6DfVBH4aaaWJ91G
         QFqcnCPZjnSJmItq5Pz5hR0HuWw9N5VjW95PijPZr88KGZyQoyquiIoxMR6iT2BxtYF1
         ngb6/zVMED70zpfE2n7M28knEt/e3SSk8L6fJxUfLgBtoVl0e56j2GNfPmQiv9xREEyi
         HWxw==
X-Gm-Message-State: ABy/qLYcDa/khdZ4uJIn3EU5Wjbiwfkf4H3BF7UFc0vPGhnw7fVzIMA/
	5cT+oIttJuW5qygG5S1sRXgea1Q7rtJWCmeoABPmm0fLMjkvXJ1sNL7raVx1z/+Lzhp6MWNbMMK
	q3KD9vPjDPrmX9kDg
X-Received: by 2002:aa7:c753:0:b0:51e:1a51:d414 with SMTP id c19-20020aa7c753000000b0051e1a51d414mr1878190eds.32.1689959861041;
        Fri, 21 Jul 2023 10:17:41 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFyyf9U2FFYwtGg7Nfx7TqscSvBa0fBBUyOLoWSpgQImoylEzXmYhbWs/84TcbA6dVob4NtSg==
X-Received: by 2002:aa7:c753:0:b0:51e:1a51:d414 with SMTP id c19-20020aa7c753000000b0051e1a51d414mr1878159eds.32.1689959860744;
        Fri, 21 Jul 2023 10:17:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l9-20020aa7c309000000b0051d87e72159sm2346640edq.13.2023.07.21.10.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 10:17:40 -0700 (PDT)
Message-ID: <8ad7a846-64e9-a3f1-4bf1-731a994d62cb@redhat.com>
Date: Fri, 21 Jul 2023 19:17:37 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
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
 <20230718234512.1690985-13-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
In-Reply-To: <20230718234512.1690985-13-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/23 01:44, Sean Christopherson wrote:
> +	inode = alloc_anon_inode(mnt->mnt_sb);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +
> +	err = security_inode_init_security_anon(inode, &qname, NULL);
> +	if (err)
> +		goto err_inode;
> +

I don't understand the need to have a separate filesystem.  If it is to 
fully setup the inode before it's given a struct file, why not just 
export anon_inode_make_secure_inode instead of 
security_inode_init_security_anon?

Paolo

