Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C292014A087
	for <kvmarm@lists.linux.dev>; Thu, 25 Apr 2024 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714057793; cv=none; b=RuOv9DyJ2WdzaB0Z0I+YTRZCwhL83q/ca9hrL1npsC1bLTObcr1bE3tbsNNS34OaBZhqyttjNuXmGIuNYR3/dT+5VvPFvGyhvtl5wlLiaCl5ZQImFRF7rFsTvifHpkGQPzsiwvXAMu7je+/3Okd7vgX7mYXBNlzOUn5Xz7vYV68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714057793; c=relaxed/simple;
	bh=14ynkVWPzNhCtgD+Z9x14gnpSJO5GRO1ma5/65Lnzr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y2dlu+z0bomQl+HC6kyTdYvtlJXDf3EU7uQSCGnZnHWK8ZZGp2KrurVTmDWBtEzBlvmgiCGXJfhKHe/hdnyWC9olewO3KPHsKUcc1qmXys4b9O64dC3U7ssC/ykgP7Wfz0aumovo+/oiJavFsIRZsy9owh6IaulIMY+fJnCyyqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hwmyWVh+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hwmyWVh+"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61892d91207so19448937b3.3
        for <kvmarm@lists.linux.dev>; Thu, 25 Apr 2024 08:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714057791; x=1714662591; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m1qzGW4ycfJBkwOtQag42BpB9F1dgLw6AsC1TpSQ/BE=;
        b=hwmyWVh+ZyU6XDorW2GpCpoVnemr/+F2aNDNZe+YLzHmCltf8bJTntNNJGB44FI1/6
         Fb0+RsS2h7F/xtS/AUaE0yxik/m0HIbJ0LBDyHOCxxzoIkS7V0FTYkuoQNxJ8tkZscoK
         4EPybqXtjEgKtkFKeDxE9b9J3BgVu2vYNemgeDHFcgmwq2cEMZO8QQPLI7WsIJ1b2y/a
         gzyFzQQCrVCpQMhbLvG4DSGmHtX2pIDq/7TKqne7pfDAGjBP5l7KArqA77NlQtoKDtph
         ItfLEPsPAHh2XQ5yrKXmppAPwuIagy+lpMWMvFNzGesQARIplgnhBXAr/hdz4NKP1G9h
         Cc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714057791; x=1714662591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m1qzGW4ycfJBkwOtQag42BpB9F1dgLw6AsC1TpSQ/BE=;
        b=NnO8NQplW5Pc7B/MR4mh1jtCVArdwuPLDQImaUBGNSY9Gdu9qOtgSMuVG3375kzFeD
         VxWJ3Rki9CZS8mjgyY/P5Gv1lXqfxMqCH5HBr1x3fpBno/bQruYp3U4W57+HXWJmYUhB
         BU2w1In25k6HxPhT3YTy4mRj6AVVYavB+beQeHzPEpkH1NL89L+bE3bS1QL4oTTpMkFl
         EyKNePLRrv2Sb3O0pch8m6hMosMoeMk550LgfCwSTwdks8xY6RHt6WB0oXUrb2EeVbQv
         37+Mn7vWZmP6jV2jcOjqCuKdv69tW/k24uIPw5prkQkshdNn2QlfwMfCDI6kH9pG1mt1
         1HfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkv7m3PlUhHTa9iYA/fLPo2c+beMlnBAWi7bbrrVYbSsc9WeIzemgAtSbxBTLK7XpD17V/883XrDBzYyEt83BiYos3anID
X-Gm-Message-State: AOJu0YwFrSbi0LhNf6zEv1r3mUUwNo9g2r9m/VISMDB09bkA3Fwd0iWB
	PYKCfihmolgiAhz9TcbBek87VA3g1hfkxDEphnjPQq6gtfS1SKHFAU9nJk3vVap70qlFsfvP0nv
	nYA==
X-Google-Smtp-Source: AGHT+IESJpACVh541xxXAQ9OLoBU3w6/mlBcJ1Y0e41i9MN7u+mraz/pMXzsHrFUz1aVf7/+mBldg/ztHFs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:698a:0:b0:de4:c2d4:e14f with SMTP id
 e132-20020a25698a000000b00de4c2d4e14fmr1617703ybc.11.1714057790783; Thu, 25
 Apr 2024 08:09:50 -0700 (PDT)
Date: Thu, 25 Apr 2024 08:09:49 -0700
In-Reply-To: <3848a9ad-07aa-48da-a2b7-264c4a990b5b@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-26-seanjc@google.com>
 <69ae0694-8ca3-402c-b864-99b500b24f5d@moroto.mountain> <3848a9ad-07aa-48da-a2b7-264c4a990b5b@linuxfoundation.org>
Message-ID: <ZipyPYR8Nv_usoU4@google.com>
Subject: Re: [PATCH v13 25/35] KVM: selftests: Convert lib's mem regions to KVM_SET_USER_MEMORY_REGION2
From: Sean Christopherson <seanjc@google.com>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Benjamin Copeland <ben.copeland@linaro.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Shuah Khan wrote:
> On 4/25/24 08:12, Dan Carpenter wrote:
> > On Fri, Oct 27, 2023 at 11:22:07AM -0700, Sean Christopherson wrote:
> > > Use KVM_SET_USER_MEMORY_REGION2 throughout KVM's selftests library so that
> > > support for guest private memory can be added without needing an entirely
> > > separate set of helpers.
> > > 
> > > Note, this obviously makes selftests backwards-incompatible with older KVM
> >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > versions from this point forward.
> >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Is there a way we could disable the tests on older kernels instead of
> > making them fail?  Check uname or something?  There is probably a
> > standard way to do this...  It's these tests which fail.
> 
> They shouldn't fail - the tests should be skipped on older kernels.

Ah, that makes sense.  Except for a few outliers that aren't all that interesting,
all KVM selftests create memslots, so I'm tempted to just make it a hard requirement
to spare us headache, e.g.

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b2262b5fad9e..4b2038b1f11f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2306,6 +2306,9 @@ void __attribute((constructor)) kvm_selftest_init(void)
        /* Tell stdout not to buffer its content. */
        setbuf(stdout, NULL);
 
+       __TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),
+                      "KVM selftests from v6.8+ require KVM_SET_USER_MEMORY_REGION2");
+
        kvm_selftest_arch_init();
 }

--

but it's also easy enough to be more precise and skip only those that actually
create memslots.

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b2262b5fad9e..b21152adf448 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -944,6 +944,9 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
                .guest_memfd_offset = guest_memfd_offset,
        };
 
+       __TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),
+                      "KVM selftests from v6.8+ require KVM_SET_USER_MEMORY_REGION2");
+
        return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION2, &region);
 }
 
@@ -970,6 +973,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
        size_t mem_size = npages * vm->page_size;
        size_t alignment;
 
+       __TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),
+                      "KVM selftests from v6.8+ require KVM_SET_USER_MEMORY_REGION2");
+
        TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) == npages,
                "Number of guest pages is not compatible with the host. "
                "Try npages=%d", vm_adjust_num_guest_pages(vm->mode, npages));
--
