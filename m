Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DC2CA51
	for <kvmarm@lists.linux.dev>; Fri,  3 Nov 2023 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lbtn6dLc"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-67089696545so10627286d6.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Nov 2023 02:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699004575; x=1699609375; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KR3uUy+lpOtuK74sFvr5LpDDKafluOWW+OG46f9Hrzo=;
        b=Lbtn6dLc+Iax9eO1lJlRkYhqg2gUOB4eMtwS8CFJts/VoCX6V3cu5Q+H+G+VBp0kKK
         5/B4ywsWPi1YUYYn7r4xRIHBGS4Q9ZOU+jZ3ViB1bgzjrlHU0iBpBUoKzTwIEcBlXMgj
         AIHcV3PPLNanD5iUk1Gh8++uCohz4ihVlBewve7QETL+a3I8FOMiCt+liaDErn9BFTmi
         ZOCF0FAcoeZwSPcFuWyjaZ8z4VmLxn201aZaV7vF1xaF9gYOiRY/pnLGzO5cU2up7A09
         91PKXx2kGCkXczJ2txZYTXk9MEYQjcAUUj/D/JZDEiTeYGatDKq0pY7izQZHzplertyT
         INXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699004575; x=1699609375;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KR3uUy+lpOtuK74sFvr5LpDDKafluOWW+OG46f9Hrzo=;
        b=kVAXz3LOEPmQWhWFeVHxeZ1yzssSsRHBnBBN4F2QjZeTs0UvMi0fj32txCZrMMgHQ1
         jx2kOtyRN49ESqM9Djj65tNQB+Z8kc1EUd2rAJJru8LCd1HO+4QcJnH8ZZw5vsJyyBLu
         paY12Kyl/xmlgZ6bWTwcxhXfV4qb7GoQhDmRtssVtFL+hVuToJnMop+XcW93DmOHuqrH
         bauSMH6iJmrOiwoWveZ4zEEv9xYsRdP6YQKqKye0Gh0EOIFi6mlDzwHdYvb16Xx8f+G0
         MBHq9JHADJ/QImfG/OiH2/bJTI2ymOTZzYKoNc7PSawq9/v+ZJD5bWZislx5fGUVKQ7Q
         1CnA==
X-Gm-Message-State: AOJu0Yx11BKgc3srWX0iognWQWKHstXfLuXTbKI5UFFPBIA0vby+6LQq
	Xgs1/uSQrbkpm3tYIe60jk0omwknP8IFfRSiIUG9Xw==
X-Google-Smtp-Source: AGHT+IHMtnnuJ+fshc7oeOwDt21mO974uTwKm6avpjixqQMFQPk6nu4AOneq997yl+dXgdaxeuVP+cu76MznLmTOvmQ=
X-Received: by 2002:a05:6214:401c:b0:66d:34a8:3ed0 with SMTP id
 kd28-20020a056214401c00b0066d34a83ed0mr22048546qvb.26.1699004574544; Fri, 03
 Nov 2023 02:42:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-17-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 3 Nov 2023 09:42:17 +0000
Message-ID: <CA+EHjTxEvJpfA7urRj6EbbuwTGWAw6ZYu6NmX9sLT5Cdp5p3eA@mail.gmail.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

...

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e2252c748fd6..e82c69d5e755 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst

...

> +4.141 KVM_CREATE_GUEST_MEMFD
> +----------------------------
> +
> +:Capability: KVM_CAP_GUEST_MEMFD
> +:Architectures: none
> +:Type: vm ioctl
> +:Parameters: struct struct kvm_create_guest_memfd(in)

One struct too many.

Cheers,
/fuad
