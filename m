Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72AD101D7
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 13:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1JC8HtH7"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5b02ed0f886so61967917b3.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 06:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698846106; x=1699450906; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nFf6aEaGwk5ej5JezQy0IgMN87WPAcTCXufwbiE3fug=;
        b=1JC8HtH7blzgtlXiz0gAALeFlMpdjIq11K23Xc1QGXvxRbe7LW8gsIvi/ksYq0aX4t
         iNTmPt1Xs4TSMCb4zl0A/m+vEiwIvS/QG2vlNiPM08/liuJlYE4cnl56lkN1k+YDBKHZ
         ndNh0pb1Ebx5GAiH0uEfNHrlrZSKLMN5yDLnUlijkpK5/5d9MzqPCvvSbSjpY7HoEoCs
         Y/aCpb/Qxc6XRGbosup7f/CI5CmBnM3OpO0q571863w3JkLUeftqLYhYajWgHK1uGqGY
         ylxkL88yCprcPYHvmJ2PAgntEwBzUc7qD4AA8RIG5+s+uJWHAI0Hfx7TK6aaI/l8A73F
         O0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698846106; x=1699450906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFf6aEaGwk5ej5JezQy0IgMN87WPAcTCXufwbiE3fug=;
        b=Rp+xRkojwOPEKuH2ZvVJHp7Y/Dec+02pxgMM/sdP7HprblcIiC75naOA1e0thnfaTN
         vIhNfbaMT1Jpnh0kqnEhlu3AdYvbcu6fVvj54XJjpjTtQrlaYfXYucwGX6GQDt1BP2ME
         dyaUzMwTaFYypzOPUTiKQ8vmTcLsnb3Q14w7kFQIcHKP0EKAdZvkH4o1oZjhFwcqUeMj
         hlCKoPUDkLFyKS6umzFr0qpKiTwzf3tfx4QCJWxzScIcNnFfzvARf0qX7pv1IewX2/2v
         06sxcyKLxlq7nXZM5EsREW3KvVWt9H28rHX25y1pyQxLynF0ySTKb47D8G0x0w5plNOe
         vbVA==
X-Gm-Message-State: AOJu0YyYwDNMs/3c0JX2ylfqqK8bKMmrlSdRecspEuX7+M9PJpAk56Bd
	u6qy7EY3/xOH/khrp1vM1nx9RjsrTEc=
X-Google-Smtp-Source: AGHT+IEsRM1yQnQClQeVqyoNLxT9cYgRny7PWezkHcY0wXTm/cdeLyJgnrb+5OZENHYJQKvQlFBt8yx8E+I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e689:0:b0:5a7:bfcf:2cb8 with SMTP id
 p131-20020a0de689000000b005a7bfcf2cb8mr314827ywe.1.1698846106686; Wed, 01 Nov
 2023 06:41:46 -0700 (PDT)
Date: Wed, 1 Nov 2023 06:41:45 -0700
In-Reply-To: <92ba7ddd-2bc8-4a8d-bd67-d6614b21914f@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-18-seanjc@google.com>
 <7c0844d8-6f97-4904-a140-abeabeb552c1@intel.com> <ZUEML6oJXDCFJ9fg@google.com>
 <92ba7ddd-2bc8-4a8d-bd67-d6614b21914f@intel.com>
Message-ID: <ZUJVfCkIYYFp5VwG@google.com>
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

On Wed, Nov 01, 2023, Xiaoyao Li wrote:
> On 10/31/2023 10:16 PM, Sean Christopherson wrote:
> > On Tue, Oct 31, 2023, Xiaoyao Li wrote:
> > > On 10/28/2023 2:21 AM, Sean Christopherson wrote:
> > > > Extended guest_memfd to allow backing guest memory with transparent
> > > > hugepages. Require userspace to opt-in via a flag even though there's no
> > > > known/anticipated use case for forcing small pages as THP is optional,
> > > > i.e. to avoid ending up in a situation where userspace is unaware that
> > > > KVM can't provide hugepages.
> > > 
> > > Personally, it seems not so "transparent" if requiring userspace to opt-in.
> > > 
> > > People need to 1) check if the kernel built with TRANSPARENT_HUGEPAGE
> > > support, or check is the sysfs of transparent hugepage exists; 2)get the
> > > maximum support hugepage size 3) ensure the size satisfies the alignment;
> > > before opt-in it.
> > > 
> > > Even simpler, userspace can blindly try to create guest memfd with
> > > transparent hugapage flag. If getting error, fallback to create without the
> > > transparent hugepage flag.
> > > 
> > > However, it doesn't look transparent to me.
> > 
> > The "transparent" part is referring to the underlying kernel mechanism, it's not
> > saying anything about the API.  The "transparent" part of THP is that the kernel
> > doesn't guarantee hugepages, i.e. whether or not hugepages are actually used is
> > (mostly) transparent to userspace.
> > 
> > Paolo also isn't the biggest fan[*], but there are also downsides to always
> > allowing hugepages, e.g. silent failure due to lack of THP or unaligned size,
> > and there's precedent in the form of MADV_HUGEPAGE.
> > 
> > [*] https://lore.kernel.org/all/84a908ae-04c7-51c7-c9a8-119e1933a189@redhat.com
> 
> But it's different than MADV_HUGEPAGE, in a way. Per my understanding, the
> failure of MADV_HUGEPAGE is not fatal, user space can ignore it and
> continue.
>
> However, the failure of KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is fatal, which leads
> to failure of guest memfd creation.

Failing KVM_CREATE_GUEST_MEMFD isn't truly fatal, it just requires different
action from userspace, i.e. instead of ignoring the error, userspace could redo
KVM_CREATE_GUEST_MEMFD with KVM_GUEST_MEMFD_ALLOW_HUGEPAGE=0.

We could make the behavior more like MADV_HUGEPAGE, e.g. theoretically we could
extend fadvise() with FADV_HUGEPAGE, or add a guest_memfd knob/ioctl() to let
userspace provide advice/hints after creating a guest_memfd.  But I suspect that
guest_memfd would be the only user of FADV_HUGEPAGE, and IMO a post-creation hint
is actually less desirable.

KVM_GUEST_MEMFD_ALLOW_HUGEPAGE will fail only if userspace didn't provide a
compatible size or the kernel doesn't support THP.  An incompatible size is likely
a userspace bug, and for most setups that want to utilize guest_memfd, lack of THP
support is likely a configuration bug.  I.e. many/most uses *want* failures due to
KVM_GUEST_MEMFD_ALLOW_HUGEPAGE to be fatal.

> For current implementation, I think maybe KVM_GUEST_MEMFD_DESIRE_HUGEPAGE
> fits better than KVM_GUEST_MEMFD_ALLOW_HUGEPAGE? or maybe *PREFER*?

Why?  Verbs like "prefer" and "desire" aren't a good fit IMO because they suggest
the flag is a hint, and hints are usually best effort only, i.e. are ignored if
there is a fundamental incompatibility.

"Allow" isn't perfect, e.g. I would much prefer a straight KVM_GUEST_MEMFD_USE_HUGEPAGES
or KVM_GUEST_MEMFD_HUGEPAGES flag, but I wanted the name to convey that KVM doesn't
(yet) guarantee hugepages.  I.e. KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is stronger than
a hint, but weaker than a requirement.  And if/when KVM supports a dedicated memory
pool of some kind, then we can add KVM_GUEST_MEMFD_REQUIRE_HUGEPAGE.
