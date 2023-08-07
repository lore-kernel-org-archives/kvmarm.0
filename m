Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3069B156D3
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 23:17:51 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-58473c4f629so58823497b3.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 16:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691450271; x=1692055071;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O6ADKvrj6NKuTG8K0De5TN5TBG7YUj/XYIH2D8dp568=;
        b=rHwQlDZDzym7DX7JPTeHFjVedtFRUtAMiKX2VU1EjC3DDPS+GKehZ420ny5GaoR1ql
         DJZSgsfTVJl3vHuTgVdsaoMbYWxHvGzjOU0b7lDeewUWBnmHCx4rEyCV+u7mMO4LYlh5
         X/eCH8/74nhTzgvQgUg3W7ew8mnRsIapj5OejxlfXYe7B7oIEIOpl62BZW0oI322fnfO
         0Voq/X8G0TvKlJzbTSRNfra4zE+z5UETF5mjVUp3srNKrf5MdQ1+J9GDHb9R/7Klrk79
         sQ7ciz1qdHaVGW7a/1FblT/tag2WVBkp7Xupx92Rz9XtAvp0t79KGYAXs3GugjDd4DWz
         Be4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691450271; x=1692055071;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O6ADKvrj6NKuTG8K0De5TN5TBG7YUj/XYIH2D8dp568=;
        b=C+famTqRNt4uo5b6PtM+EzKq9jbKLk+H0ysA6LbnQqQ8AlGNjWjDGvwvqJRpY+84w1
         2TFjdN8OU+NLX7vMivxZ8vuLnI7UWeFqYGIOVDPURTgdScA1nKlOjzT+Gv6KCJSW1ECW
         UXoOEVAUvDai1OV5wVSBlaFG5Ye/vDDk9C5yFTx7zTGxwAMkH8nsLF7xXDHWQTXayff2
         6rKAG1PExkxtupxVAwvamBbFwFeQZDsrVzKW/TuTRCU7DHPqtmUPmzkFYLyA1RoEpAjw
         losvVLe5GHQb9DUMftslfAp7eVoi4DxbXWBn23Np2pnuZc3UI40PT5J6M9kYu8B2j0ES
         Mgww==
X-Gm-Message-State: AOJu0YwMose5PR34rUA4rDWnddj85XG4D39Qa+9M8ehmI3+R3X+S0BG1
	nw3z+n+ihXki5yIip/1TNPpeXHwZ0nTXSfPOsA==
X-Google-Smtp-Source: AGHT+IGSgl+5gSINX//lCEXF+ifa5KuvDte/Vqkh35HGceplFQQ8fBj/FZjwVUabZs4KoYQYU07HEfGWMf/BZUZt+g==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a25:ce50:0:b0:d4f:d7a5:ba3b with SMTP
 id x77-20020a25ce50000000b00d4fd7a5ba3bmr34924ybe.8.1691450270921; Mon, 07
 Aug 2023 16:17:50 -0700 (PDT)
Date: Mon, 07 Aug 2023 23:17:49 +0000
In-Reply-To: <20230718234512.1690985-28-seanjc@google.com> (message from Sean
 Christopherson on Tue, 18 Jul 2023 16:45:10 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <diqzr0oe30iq.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v11 27/29] KVM: selftests: Expand set_memory_region_test
 to validate guest_memfd()
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, willy@infradead.org, akpm@linux-foundation.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, kvm@vger.kernel.org, 
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
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> From: Chao Peng <chao.p.peng@linux.intel.com>
>
> Expand set_memory_region_test to exercise various positive and negative
> testcases for private memory.
>
>  - Non-guest_memfd() file descriptor for private memory
>  - guest_memfd() from different VM
>  - Overlapping bindings
>  - Unaligned bindings
>
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> [sean: trim the testcases to remove duplicate coverage]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 10 ++
>  .../selftests/kvm/set_memory_region_test.c    | 99 +++++++++++++++++++
>  2 files changed, 109 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 334df27a6f43..39b38c75b99c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -789,6 +789,16 @@ static inline struct kvm_vm *vm_create_barebones(void)
>  	return ____vm_create(VM_SHAPE_DEFAULT);
>  }
>  

> <snip>

> +
> +static void test_add_private_memory_region(void)
> +{
> +	struct kvm_vm *vm, *vm2;
> +	int memfd, i;
> +
> +	pr_info("Testing ADD of KVM_MEM_PRIVATE memory regions\n");
> +
> +	vm = vm_create_barebones_protected_vm();
> +
> +	test_invalid_guest_memfd(vm, vm->kvm_fd, 0, "KVM fd should fail");
> +	test_invalid_guest_memfd(vm, vm->fd, 0, "VM's fd should fail");
> +
> +	memfd = kvm_memfd_alloc(MEM_REGION_SIZE, false);
> +	test_invalid_guest_memfd(vm, vm->fd, 0, "Regular memfd() should fail");

This should be

test_invalid_guest_memfd(vm, memfd, 0, "Regular memfd() should fail");

> +	close(memfd);
> +
> +	vm2 = vm_create_barebones_protected_vm();
> +	memfd = vm_create_guest_memfd(vm2, MEM_REGION_SIZE, 0);
> +	test_invalid_guest_memfd(vm, memfd, 0, "Other VM's guest_memfd() should fail");
> +
> +	vm_set_user_memory_region2(vm2, MEM_REGION_SLOT, KVM_MEM_PRIVATE,
> +				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
> +	close(memfd);
> +	kvm_vm_free(vm2);
> +
> +	memfd = vm_create_guest_memfd(vm, MEM_REGION_SIZE, 0);
> +	for (i = 1; i < PAGE_SIZE; i++)
> +		test_invalid_guest_memfd(vm, memfd, i, "Unaligned offset should fail");
> +
> +	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_PRIVATE,
> +				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
> +	close(memfd);
> +
> +	kvm_vm_free(vm);
> +}
> +

> <snip>
