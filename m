Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C58413FF4
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 19:10:39 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59e79a36097so45863917b3.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 12:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695323438; x=1695928238; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=msCRqftjzvMka6Rl5V/NvDEz768neF2Qswneru1ptF4=;
        b=NUfMfvv4dEV9OZRSc97L9KGRj69GtZZSEHeHW+1Fu9k0owcC/Sh5BACD3uSI6Y3aLD
         BaWOcMU7BXYxStnfs9U1aamkxyxz9xNuRUOft/8YHHa836/S3SU3Q5zurkq9zIpTeWkj
         0MKNdxzXvMxRZWldSnqrA3MgN6qC++EHrGjmitDWcUc1U8y+YGpmc4e0scLsDhNDKQk2
         u7HQPRyesB5Joa0Hi1jjr7xi6yZFwHKJJhxCMRNmM6HXGsUEz5SdY8GQKLugqxX7a3Kj
         1iRF7zUYuRtyOTOMxiFnTAMkyfB/Ewp7wUXzES9lFtVZ7/+1dAfPKYsC7sBpmhKgWOtN
         Bl2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695323438; x=1695928238;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=msCRqftjzvMka6Rl5V/NvDEz768neF2Qswneru1ptF4=;
        b=FI9XYKJ7wokMv/G9aOoMRD2yJH4Xd0514CAAL1OxVb4DBEPo3H8a3hcwLaAR96tnzi
         0BNxBM6UygyKREzgZjquuWkXBCP9ZXsXZISZg+ZslWwmeNucIZEyKizqfU/Uk620W+y3
         GRN1336obQ79tTr8QtjafiYni0mVoVz3LCri6mqkookJTe0uohN/Wncx4WJ8gZeKTwPV
         87+1+EpGjzN5TcRd7IagXBRTyUYLRvby+gwshP6OcVfXGTkc7Bfd5RY+HhU07wn7oD9w
         ImC8eO1a+Z5CHYIDJ2J16ilXkOyW/oJ93miAXR/pxzLtO5Q7t2NMdRSa9AwV5tunlRvB
         GuRw==
X-Gm-Message-State: AOJu0YywnfDblr4fSVrVATBpgCxeopCLxaY/Lf+ucmPpyI5SZVn3945V
	ss4FhU1D/RxzjcFi5vjnFtcKXLJWOJk=
X-Google-Smtp-Source: AGHT+IHW881nAqFnjABVXUT4908B5v4pAo/onJespz4HnG5MCVd8NLEq9DsMcDxqDXD3hJb4Zo/K0u0JOVE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:70a:b0:58c:e8da:4d1a with SMTP id
 bs10-20020a05690c070a00b0058ce8da4d1amr8361ywb.2.1695323438500; Thu, 21 Sep
 2023 12:10:38 -0700 (PDT)
Date: Thu, 21 Sep 2023 12:10:36 -0700
In-Reply-To: <20230914015531.1419405-15-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-15-seanjc@google.com>
Message-ID: <ZQyVLEKXbpJ9Wvud@google.com>
Subject: Re: [RFC PATCH v12 14/33] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 13, 2023, Sean Christopherson wrote:
>  virt/kvm/guest_mem.c       | 593 +++++++++++++++++++++++++++++++++++++

Getting to the really important stuff...

Anyone object to naming the new file guest_memfd.c instead of guest_mem.c?  Just
the file, i.e. still keep the gmem namespace.

Using guest_memfd.c would make it much more obvious that the file holds more than
generic "guest memory" APIs, and would provide a stronger conceptual connection
with memfd.c.
