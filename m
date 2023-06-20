Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127351FA2
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 06:33:11 +0000 (UTC)
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-76257c11363so256480285a.3
        for <kvmarm@lists.linux.dev>; Mon, 19 Jun 2023 23:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687242791; x=1689834791;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5+evG04UMHwwjirukN0kb+RSrnzU5xpsvDPn540ciQ=;
        b=RYErAH+mi2zc86r5KWWfsFA8LP9PiwTUwejliV9x5CX3ukRT4UyxAdu8oUINH7+o71
         BABXTb+Al0ui9J0tqzVpEDRuSZr7tolLidH0mp1NHU5h6r01OFWQA5apd8IF14gcAjCV
         ZRWOtKnC/zvWenVhjSYiKmkcKYt4CTOYw+0eRsHFKMmo9NQRqlAgaYQ2+wCBJ5fPad2y
         deRzUvOljVXlVzy6NidHkJvcZ2hSlA4NU0ZEdVHUogrHjN1a2N62u1KbIFT0+ns5rGr1
         FqDT8PFagV1HC5m3wV6nfyjNesWAJV5ePIm4nguSY52ho/FLBHehJd28qB1ZFHtWJmFE
         tW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687242791; x=1689834791;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W5+evG04UMHwwjirukN0kb+RSrnzU5xpsvDPn540ciQ=;
        b=iKkPXprfJpFpiMO7+SVZz6aFVDFKDEqlyD4OW/H8YvzbtKp5zyrpkLapfgEvtFmhje
         0nJOddgIjTN9Ou9xd6eYVFoyDYysAJhoJ5h6b0pvJxzZJdRxRkQ3YaJSgtQ9eba06mw8
         OhyI4i+2VBJFnzXYnSXrFGIY73P5E8+FBAuzaxl16gIoooqkmmGrMyEYHQkxVI3FdLVP
         28kJDK68q3dK8DE2EB4Jkn4Ou8t6gtI8wX0e6okQr4A9IZqdqXH+HzfQglYYL9+DPv7b
         SNKkkPltS5zkyBf1LNrpmO5fa0wlhJktPcPS4IeStejO1/icXgzf13TBRdOlxK9+9ZRq
         bxog==
X-Gm-Message-State: AC+VfDxtkUOPTei4TVGyQ7mB0ECYjgQdmKlBvjkkxLZWSYd+qhdICbfW
	zQk/URe0o6T6lG3Zd0xXmMI=
X-Google-Smtp-Source: ACHHUZ5n5K5aPC9bYUBHTpIjgZaXZzWq6qemowxSHihC3bO7xjOaMj7H/aLUT30sH+RFyR4rpOLqsQ==
X-Received: by 2002:a05:620a:3c90:b0:763:a610:bb64 with SMTP id tp16-20020a05620a3c9000b00763a610bb64mr2766292qkn.25.1687242790830;
        Mon, 19 Jun 2023 23:33:10 -0700 (PDT)
Received: from localhost (193-116-195-252.tpgi.com.au. [193.116.195.252])
        by smtp.gmail.com with ESMTPSA id i14-20020aa78d8e000000b0064f708ca12asm622133pfr.70.2023.06.19.23.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 23:33:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 Jun 2023 16:32:47 +1000
Message-Id: <CTH9N6UYDUM2.1974CRL32YFQC@wheely>
Cc: "Alistair Popple" <apopple@nvidia.com>, "Anup Patel"
 <anup@brainfault.org>, "Ben Gardon" <bgardon@google.com>, "Borislav Petkov"
 <bp@alien8.de>, "Catalin Marinas" <catalin.marinas@arm.com>, "Chao Peng"
 <chao.p.peng@linux.intel.com>, "Christophe Leroy"
 <christophe.leroy@csgroup.eu>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Fabiano Rosas" <farosas@linux.ibm.com>, "Gaosheng Cui"
 <cuigaosheng1@huawei.com>, "Gavin Shan" <gshan@redhat.com>, "H. Peter
 Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>, "James Morse"
 <james.morse@arm.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Jonathan Corbet" <corbet@lwn.net>, "Marc
 Zyngier" <maz@kernel.org>, "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Michael Ellerman" <mpe@ellerman.id.au>, "Michael Larabel"
 <michael@michaellarabel.com>, "Mike Rapoport" <rppt@kernel.org>, "Oliver
 Upton" <oliver.upton@linux.dev>, "Paul Mackerras" <paulus@ozlabs.org>,
 "Peter Xu" <peterx@redhat.com>, "Sean Christopherson" <seanjc@google.com>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Suzuki K Poulose"
 <suzuki.poulose@arm.com>, "Thomas Gleixner" <tglx@linutronix.de>, "Thomas
 Huth" <thuth@redhat.com>, "Will Deacon" <will@kernel.org>, "Zenghui Yu"
 <yuzenghui@huawei.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-trace-kernel@vger.kernel.org>,
 <x86@kernel.org>, <linux-mm@google.com>
Subject: Re: [PATCH mm-unstable v2 06/10] kvm/powerpc: make radix page
 tables RCU safe
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Yu Zhao" <yuzhao@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Paolo Bonzini" <pbonzini@redhat.com>
X-Mailer: aerc 0.14.0
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-7-yuzhao@google.com>
In-Reply-To: <20230526234435.662652-7-yuzhao@google.com>

On Sat May 27, 2023 at 9:44 AM AEST, Yu Zhao wrote:
> KVM page tables are currently not RCU safe against remapping, i.e.,
> kvmppc_unmap_free_pmd_entry_table() et al. The previous

Minor nit but the "page table" is not RCU-safe against something. It
is RCU-freed, and therefore some algorithm that accesses it can have
the existence guarantee provided by RCU (usually there still needs
to be more to it).

> mmu_notifier_ops members rely on kvm->mmu_lock to synchronize with
> that operation.
>
> However, the new mmu_notifier_ops member test_clear_young() provides
> a fast path that does not take kvm->mmu_lock. To implement
> kvm_arch_test_clear_young() for that path, orphan page tables need to
> be freed by RCU.

Short version: clear the referenced bit using RCU instead of MMU lock
to protect against page table freeing, and there is no problem with
clearing the bit in a table that has been freed.

Seems reasonable.

>
> Unmapping, specifically kvm_unmap_radix(), does not free page tables,
> hence not a concern.

Not sure if you really need to make the distinction about why the page
table is freed, we might free them via unmapping. The point is just
anything that frees them while there can be concurrent access, right?

>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/bo=
ok3s_64_mmu_radix.c
> index 461307b89c3a..3b65b3b11041 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -1469,13 +1469,15 @@ int kvmppc_radix_init(void)
>  {
>  	unsigned long size =3D sizeof(void *) << RADIX_PTE_INDEX_SIZE;
> =20
> -	kvm_pte_cache =3D kmem_cache_create("kvm-pte", size, size, 0, pte_ctor)=
;
> +	kvm_pte_cache =3D kmem_cache_create("kvm-pte", size, size,
> +					  SLAB_TYPESAFE_BY_RCU, pte_ctor);
>  	if (!kvm_pte_cache)
>  		return -ENOMEM;
> =20
>  	size =3D sizeof(void *) << RADIX_PMD_INDEX_SIZE;
> =20
> -	kvm_pmd_cache =3D kmem_cache_create("kvm-pmd", size, size, 0, pmd_ctor)=
;
> +	kvm_pmd_cache =3D kmem_cache_create("kvm-pmd", size, size,
> +					  SLAB_TYPESAFE_BY_RCU, pmd_ctor);
>  	if (!kvm_pmd_cache) {
>  		kmem_cache_destroy(kvm_pte_cache);
>  		return -ENOMEM;

KVM PPC HV radix PUD level page tables use the arch/powerpc allocators
(for some reason), which are not RCU freed. I think you need them too?
I wouldn't mind if the kvm pud table slab was moved in here instead of
shared.

Thanks,
Nick
