Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDC7174DA
	for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 23:01:29 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d745094c496so1166719276.1
        for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 16:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692399688; x=1693004488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=usNReEG1yhZ2OoI1bkcsHZxi8vJT2uNEbLMV9P1BADc=;
        b=gS9arkhq2BQM5wyG90faWG4pywmMu5sfjHEWd04bKy84agcqatheT6YSVqsnMAhJXs
         7Ey6R/IsFpbuJAgflRTfCsGQSeE7z8aCnsHRbxEkKBK/PAH7FMZgZEavx3BeBXM+3P+2
         Plq9VhZaRy5PbOx8EDNA03ytcClkYRB9Plt+OD+UltS53ZO5IOuVPHa/Yt8AOkDtjpGf
         J0ReekJEPtY7ifZaoOCUWVj24ZOCPfNYabKI/jnVy+VGWVTelTn6BvdxHdiQrBc+k/kc
         BoETN+5H+qyvqSzJ4nWEMxKRREF2ybV9p6gaBfB8lx1V/iAPfjWa3WjZDIbTKQp0bm0Z
         IJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692399688; x=1693004488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=usNReEG1yhZ2OoI1bkcsHZxi8vJT2uNEbLMV9P1BADc=;
        b=LUx9k0lx+Z2Wc/n/fM9hkGmbawwAqKxpfahg6oNJKqopQ8ZjsOaPgplMCi2/nGRP5R
         p68mI1aViSnjTxh83L/m9vSgREWN+Pzvc9L7jxDwNFslB3+FiPbHyx87f6nyJTMQ7kgn
         qj8Ol2Uc15swp0Gpf6JnGlPU7nBBrEE2nnH5zEs1JZW3d8KgbyjL1qqQbmi1ElYzj2WO
         x+4PYYF/ZgTQoRoJ/bU97Zi+SB3zMJNiIZBAlmu0Yg4IYmNF6d1WFpAfpYlTgmxf0boF
         TZj4tSS1tCIWx45jh23IUclDCduI5RmqA1wsYoR+gN1PGtaRqVXscUf5VfNYMwAwRf3m
         f20w==
X-Gm-Message-State: AOJu0YyAxIn3SiDKTTkHl3qBoZCbUMw/PFiMpBe/SjjdlT9dAmP1yRKm
	+sv9DuneFVnoW47zDmJ7+Y9xa9gghpc=
X-Google-Smtp-Source: AGHT+IHoaUgHi5iMS/0Xt5cvUarFzMCVBDWHJfa8lAvVIAai8wyXyMLBOgyLMJxxiXlZfzlnoz9PoDeIZVI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:a8a:b0:d74:347:1e3 with SMTP id
 cd10-20020a0569020a8a00b00d74034701e3mr5755ybb.9.1692399688376; Fri, 18 Aug
 2023 16:01:28 -0700 (PDT)
Date: Fri, 18 Aug 2023 16:01:26 -0700
In-Reply-To: <diqzleem306p.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-29-seanjc@google.com> <diqzleem306p.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <ZN/4RjDsBLf0FB98@google.com>
Subject: Re: [RFC PATCH v11 28/29] KVM: selftests: Add basic selftest for guest_memfd()
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	willy@infradead.org, akpm@linux-foundation.org, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.p.peng@linux.intel.com, tabba@google.com, jarkko@kernel.org, 
	yu.c.zhang@linux.intel.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	vbabka@suse.cz, david@redhat.com, qperret@google.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 07, 2023, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Add a selftest to verify the basic functionality of guest_memfd():
> >
> > <snip>
> 
> Here's one more test:

First off, thank you!  I greatly appreciate all the selftests work you (and
others!) have been doing.

For v2, can you please post a standalone patch?  My workflow barfs on unrelated,
inlined patches.  I'm guessing I can get b4 to play nice, but it's easier to just
yell at people :-)

> >From 72dc6836f01bdd613d64d4c6a4f2af8f2b777ba2 Mon Sep 17 00:00:00 2001
> From: Ackerley Tng <ackerleytng@google.com>
> Date: Tue, 1 Aug 2023 18:02:50 +0000
> Subject: [PATCH] KVM: selftests: Add tests - invalid inputs for
>  KVM_CREATE_GUEST_MEMFD
> 
> Test that invalid inputs for KVM_CREATE_GUEST_MEMFD, such as
> non-page-aligned page size and invalid flags, are rejected by the
> KVM_CREATE_GUEST_MEMFD with EINVAL
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  tools/testing/selftests/kvm/guest_memfd_test.c  | 17 +++++++++++++++++
>  .../selftests/kvm/include/kvm_util_base.h       | 11 +++++++++--
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index eb93c608a7e0..ad20f11b2d2c 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -90,6 +90,21 @@ static void test_fallocate(int fd, size_t page_size, size_t total_size)
>  	TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
>  }
>  
> +static void test_create_guest_memfd_invalid(struct kvm_vm *vm, size_t page_size)
> +{
> +	int fd;
> +
> +	/* Non-page-aligned page_size */

Instead of adding a comment, use the message from TEST_ASSERT() to communicate
that information to the reader *and* to anyone that encounters failures.

> +	fd = __vm_create_guest_memfd(vm, 1, 0);

ioctls() are fast.  Rather than hardcode one value, iterate over a range of
values, e.g.

	for (size = 0; size < page_size; size++) {
		r = __vm_create_guest_memfd(vm, size, 0);
		TEST_ASSERT(r && errno == EINVAL,
			    "Informative error message...);
	}
		
> +	ASSERT_EQ(errno, EINVAL);
> +
> +	/* Invalid flags */
> +	fd = __vm_create_guest_memfd(vm, page_size, 99);
> +	ASSERT_EQ(fd, -1);
> +	ASSERT_EQ(errno, EINVAL);

And then same thing here.  Then you can use the legal flags to determine what is
and isn't valid, instead of using a completely arbitrary magic number.
