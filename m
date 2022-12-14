Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9464833E6
	for <kvmarm@lists.linux.dev>; Wed, 14 Dec 2022 09:50:20 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id k79so4055612pfd.7
        for <kvmarm@lists.linux.dev>; Wed, 14 Dec 2022 01:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jbas8k53VpTFWCNrs3oRHT/Z65GCtCU2WQLZf0mUIGE=;
        b=afwPx6LdFoKaH5nf+ag3bcmEMnN8QxYCsgHz0tCKFfNGbcAhKAKWcHJS4u0Xa02rh9
         1zx4dWkTQ16/1Xq2qNjpEn/3zEiV+mVtkVWXwDxrtry3ggQwYtHlzleK+hm+POGHPrEa
         VR30Iiq3fwVosu3uFcFlghm/CQnobNW0jBUmqmTqKDJ18p6Vv3nTnv+YJd9Q5V9R2qRW
         rK3qglYycZi9MnKCpxTmAdk5enZysYESnQUsKy4Dui9/9KOMamkgsKJVkSAwwlSq3qfb
         OyhJNSoWvttRx7SrdvyCvHkwHTBdaB7W4Z0D/jUtQ/E84c2kEM0PIZMnID4mjv788Xgs
         gp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jbas8k53VpTFWCNrs3oRHT/Z65GCtCU2WQLZf0mUIGE=;
        b=XhYdpuGQG6jCVYdQrUUvoRKaFtXsrePKuFTgKdGJaO38Wcbc/mdRoCIyc/D0XHRVZy
         e3lCgN302Xaf5Riaf3RZ1k7wtc0Umv8wJ5AGDaSq0wGbSiO1VVkgCi2R2ES0JVtIf7/J
         WPql7RSBbzDUX92io8bOMgFwuBI6iFh/K69C0ByNMK/M5m36h5sI6L1wM0ojhFp+MceR
         cb0ddyCgtIZx4kr2eBMA/wYRXXSDu4OYtxFHdNNYW9cH4u/Vl9rm2CF7MAf82SisROXa
         pY7LNBuB0OaS1HdM2X3Phzcx/QgoYHD4hMTlh+aeFV0VZ4W2cuG2pRuaa9nwYeozLP2L
         ANyw==
X-Gm-Message-State: ANoB5pmcuAoxBcSeboCZhIexAoM90AdZ2ydo7F9Eb8ahXvmB9eYRVS21
	GtEaZORHvriiU6BNki94/ImYKA24UnEMV7bTIuM=
X-Google-Smtp-Source: AA0mqf7w8TIU6K2l/8MuGzXNAAZ9FRqdURji/6nctthseH2MSfKX1yiUw7Qrbh0D1Res/crh8T4uAxCut4Jl7FykNkI=
X-Received: by 2002:a63:e4a:0:b0:477:6cd0:9a04 with SMTP id
 10-20020a630e4a000000b004776cd09a04mr75781850pgo.433.1671011420030; Wed, 14
 Dec 2022 01:50:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com> <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com> <Y5dnWgJ0ine55/hN@google.com>
In-Reply-To: <Y5dnWgJ0ine55/hN@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Wed, 14 Dec 2022 17:50:07 +0800
Message-ID: <CAJhGHyBbjyKVEv3KcoOcPGQ28753FjR_rc9uNDEF3Dd-gNTRGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Yang, Weijiang" <weijiang.yang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	"Amit, Nadav" <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221214095007.Reg9cZLek1OHzvVFZDPEONNv0moSeL0l1FTlaKDjJK4@z>

On Tue, Dec 13, 2022 at 1:47 AM Sean Christopherson <seanjc@google.com> wrote:

>
> My preference would be to leave .smm in x86's page role.  IMO, defining multiple
> address spaces to support SMM emulation was a mistake that should be contained to
> SMM, i.e. should never be used for any other feature.  And with CONFIG_KVM_SMM,
> even x86 can opt out.
>


I think the name ASID in kvm/x86 should be used for vmcb's ASID,
vmcs's VPID, and PCID. Using the name ASID for other purposes
would only result in unnecessary confusion.

There is a bug for shadow paging when it uses two separate sets
of memslots which are using two sets of rmap and page-tracking.

When SMM world is writing to a non-SMM page which happens to be
a guest pagetable in the non-SMM world, the write operation will
go smoothly without specially handled and the shadow page for the guest
pagetable is neither unshadowed nor marked unsync.  The shadow paging
code is unaware that the shadow page has deviated from the guest
pagetable.

It means when SMM is enabled, shadow paging should be disabled,
which also means it has to use tdp and not to use nested tdp.

Thanks
Lai
