Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A923BD305
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 09:25:28 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-99357737980so271150366b.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 02:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690536326; x=1691141126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MyDeksRVqGtJNd0fe/itajI8E9fXoiZCjVyZ7emrXms=;
        b=yZlBBa+QgG6A3izqrAvYrZmjNARnJqe9UVJDDaWeo1ngnmOt9VRY93kWsBg3OxlgJ6
         BNgAnv6T/0ObsR7NeaCjk+WNJnmyD7Q59yeCq15kUZEqjsFvHdvXA60zH7S6F25/qIjt
         fm8Sg5o5MpunPrL/BqoXYGZy7msDjit8jc0wg2EmQ6Q8Th8F7S82AjrHRl+/FMq8bTJh
         sEoAOBkEqP29Krhf8xqYypp/joUWh9VUOF8DEcZIisv2V3iWTfC6qxmMhKHNjRW9HI9T
         TolK5KmZ7NzIlhfQCguxbwjQDJpXunGMqxws18N6XaE4FtdLuzrmk4BalRM99UvIXMiI
         LjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690536326; x=1691141126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyDeksRVqGtJNd0fe/itajI8E9fXoiZCjVyZ7emrXms=;
        b=OeWq0hCGIhveWlZZb1WAbCMWCzRBLGurrF2Kpc4Z1T4RGhtKsNEfWqyOcdlY1wovOS
         7xGs1YCVa2tzCnWK+zaGVfAy5LIdjRjBu4oY5Tz18SevdK9MCln9p6rD6nXK1XjGFIiY
         /f8xCUdC54uhWqrusMB8633Qdg9gM7q4HZGTKcNhamx09WSrUnwl0rZw4fnNR82r5qrT
         qqDQPfGolyBax3285LyPcb/gIcpcuawr0Hegi4/AGZgsbwgzu0ZJqvolb2aDHzZGbeZm
         bMJ9DTg/XfEcEDNdRtuE9iX1IlzUqtFoAU1uyO+k28WTigMi87ttKgc65z/5v0i3zxiM
         O1iw==
X-Gm-Message-State: ABy/qLY7keBWal1nCABh3o84pzDwngnO6NkV6Zsv+MxpVMgt+HYQWEjy
	pQ74SvDK5Pvh/4llhcDq877xOQ==
X-Google-Smtp-Source: APBJJlG4DNtaaix3llwTkCcLiQNG9ALlnJv6ynH+2HDeVn6HzB3Xx8i5ieUEd323eDEBkV9C48RmSw==
X-Received: by 2002:a17:906:8454:b0:994:1fee:3065 with SMTP id e20-20020a170906845400b009941fee3065mr1975862ejy.15.1690536326590;
        Fri, 28 Jul 2023 02:25:26 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id n12-20020a170906688c00b00992c92af6f4sm1857653ejr.144.2023.07.28.02.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 02:25:26 -0700 (PDT)
Date: Fri, 28 Jul 2023 09:25:22 +0000
From: Quentin Perret <qperret@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Maciej Szmigiero <mail@maciej.szmigiero.name>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC PATCH v11 06/29] KVM: Introduce KVM_SET_USER_MEMORY_REGION2
Message-ID: <ZMOJgnyzzUNIx+Tn@google.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718234512.1690985-7-seanjc@google.com>

On Tuesday 18 Jul 2023 at 16:44:49 (-0700), Sean Christopherson wrote:
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -95,6 +95,16 @@ struct kvm_userspace_memory_region {
>  	__u64 userspace_addr; /* start of the userspace allocated memory */
>  };
>  
> +/* for KVM_SET_USER_MEMORY_REGION2 */
> +struct kvm_userspace_memory_region2 {
> +	__u32 slot;
> +	__u32 flags;
> +	__u64 guest_phys_addr;
> +	__u64 memory_size;
> +	__u64 userspace_addr;
> +	__u64 pad[16];

Should we replace that pad[16] with:

	__u64 size;

where 'size' is the size of the structure as seen by userspace? This is
used in other UAPIs (see struct sched_attr for example) and is a bit
more robust for future extensions (e.g. an 'old' kernel can correctly
reject a newer version of the struct with additional fields it doesn't
know about if that makes sense, etc).
