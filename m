Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B1A1DFC2
	for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N38xQyv5"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1cc3ad55c75so20002495ad.0
        for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 07:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698761777; x=1699366577; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+SCWDVcx1K76tZHWI6JguONJ6NnGeKLP7+QbYfrb3Rs=;
        b=N38xQyv5qajq3YZ/7r8R3wcsNEiZT/01QPJ/4n8pTbPD7z36ePaadXmXAXXPMYwq5h
         ORYZ1XkNgTijwTeoTim13X5DVgzO6Krhetv4dhgTRY7P7q/2Am6OAYvAdSH+HyUXe6sh
         lrtmV+IONJHq+zcLRsp5GHol1/XedE/ggG+2xivTKX2wfyweWmTm/iHUQmBA82zp7UTZ
         o8VkVKN5F13/ZyKeo0VF0SAcm39fv/GDjySGc1myf14rZNo6ry3YYX/qXSB3dysBQFZf
         ZVCEWwJhfDJIQkBJHrPLDKFjmm2TQe3SqxHTg+Ul9xZD03e5dtAbbac0wo8/r0gzp9sH
         zCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761777; x=1699366577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+SCWDVcx1K76tZHWI6JguONJ6NnGeKLP7+QbYfrb3Rs=;
        b=PndDb7+adRNNBXOZJBc0gfVVyI9hfTeDgK+sVjfT7ngCkwxv7ePMvjpRHzenx4iH2D
         wcdmVVdInSXO4HONLQ06ddzp1zqFQf7nvhzXnkmfC/yQo1EfIPg54wE7UdK36i2wENFR
         35Nmd/bIoCx7vdB1DvnF3ZigPTlgvOYv7lYURBiHgDiLejJ0miXi0jyZAeyuQI7Dj6uq
         hBUpWqksSZ63tcbrIBxPqC4ns/rUBqHI9/KghTU47Ykzum20CAxDiDbj5o6kEEBZj26w
         fNzOJZ/3AWUip1ZkghBhMfgKsi7p4QuwZkoNkVY/2HhUdGpEbyWk13eO5Y0ubJQqs/0b
         Z3rw==
X-Gm-Message-State: AOJu0YwchX3Gi6V37X9/y5+Jw39XoSIC8EHnX6Iri6+FhDimZpfA4TAv
	KftrdBkHrH90kP6QyUnBPg+gtioDmQ4=
X-Google-Smtp-Source: AGHT+IG8tFKfIuO6cbI6ukftnUzYB8muWE8fOHZgWpajrHJaT+RkL+zDaTOo8ZNIlEatfvapWXD9jFRr58g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2616:b0:1cc:2549:c281 with SMTP id
 jd22-20020a170903261600b001cc2549c281mr206233plb.13.1698761777291; Tue, 31
 Oct 2023 07:16:17 -0700 (PDT)
Date: Tue, 31 Oct 2023 07:16:15 -0700
In-Reply-To: <7c0844d8-6f97-4904-a140-abeabeb552c1@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-18-seanjc@google.com>
 <7c0844d8-6f97-4904-a140-abeabeb552c1@intel.com>
Message-ID: <ZUEML6oJXDCFJ9fg@google.com>
Subject: Re: [PATCH v13 17/35] KVM: Add transparent hugepage support for
 dedicated guest memory
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
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
	linux-kernel@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Xiaoyao Li wrote:
> On 10/28/2023 2:21 AM, Sean Christopherson wrote:
> > Extended guest_memfd to allow backing guest memory with transparent
> > hugepages. Require userspace to opt-in via a flag even though there's no
> > known/anticipated use case for forcing small pages as THP is optional,
> > i.e. to avoid ending up in a situation where userspace is unaware that
> > KVM can't provide hugepages.
> 
> Personally, it seems not so "transparent" if requiring userspace to opt-in.
> 
> People need to 1) check if the kernel built with TRANSPARENT_HUGEPAGE
> support, or check is the sysfs of transparent hugepage exists; 2)get the
> maximum support hugepage size 3) ensure the size satisfies the alignment;
> before opt-in it.
> 
> Even simpler, userspace can blindly try to create guest memfd with
> transparent hugapage flag. If getting error, fallback to create without the
> transparent hugepage flag.
> 
> However, it doesn't look transparent to me.

The "transparent" part is referring to the underlying kernel mechanism, it's not
saying anything about the API.  The "transparent" part of THP is that the kernel
doesn't guarantee hugepages, i.e. whether or not hugepages are actually used is
(mostly) transparent to userspace.

Paolo also isn't the biggest fan[*], but there are also downsides to always
allowing hugepages, e.g. silent failure due to lack of THP or unaligned size,
and there's precedent in the form of MADV_HUGEPAGE.

[*] https://lore.kernel.org/all/84a908ae-04c7-51c7-c9a8-119e1933a189@redhat.com
