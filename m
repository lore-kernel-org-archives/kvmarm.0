Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0057475
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 22:50:02 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-3e45d25de97so168298587b3.6
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 14:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=emGR11sDGj23bwB4iDGKY/Jt07F7a624TvyLlINCb/4=;
        b=iIA/1zCE2/PdX7UwUpsCHVx2/4soMLJq+umSYNq1TIMKZ3vYOufggcHfzl2zpb3L95
         3KzRsMM6KMDNwv2INU26jqyRM70qj97aTjffNJqHOpklQjdDCkuFG/H5HyjOFryrkHsC
         WuUbOIXYNWL4NRA6iZCQSLbRHyxsEBOt+Yw5NkOMax5mZSsMG+NRAdlVCNMmHaLUJBr6
         RC6kxVfoGDnQ5XX0CU2kxeJuCxvyy75M74Im9VLDAzaDFpiYYonazefbFsiv+O87XQTC
         OANFKz6exzf3vgq07bR18r0zHtd6tggWQPlgrfF8L6R2GCpm+TNCBwJ2GvYSdlpZvSIY
         NaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=emGR11sDGj23bwB4iDGKY/Jt07F7a624TvyLlINCb/4=;
        b=LqAqDBBXXpC1cm/VQTS/kPkc3THQDiEeH00OfU1PjrizNBXra9Sw+rCSK4qlFL/iWE
         jXP+oWk40bNkHpwUW5jip1a0MIat5hhoPjDb6cOTp1aQabAOiiX2/88RUwLi7cV+exya
         hg+tXd0i6Re4+iiOHyjrHVHnJS4gLdw1K/feqWO/wUse5Y6yvOlE98ORB8AYlY1Plvik
         dai3IhBEvQsqEUTgaj3DBQosoBuIAsCjUE4iYKypFGTNf5SLqauSB3i9TKdW1OspZfVs
         jCp+MnBy1kmBLVKzq1coZvMgagnj1D6KQznd859oFyVHpZmUOiw7KwUevGo5BYIWUUvX
         yYwQ==
X-Gm-Message-State: ANoB5pn8LzjHAap8ngEpYRr634TdIgeO+i3pwCdBAUSgKtAK+XifNDMu
	kB0rdeR6VNLNvugLh6Ub6N4qvetF4RfjhizkgjgnNA==
X-Google-Smtp-Source: AA0mqf7BLbzUXAWE3wffbmFiHSNF9Kd+b9tfc4w51Pba8kylanBVygPwVEaOBfOQoKTOkaa76ZxA34hsT2ZYbKl8ZbE=
X-Received: by 2002:a0d:df0a:0:b0:35f:9c14:144a with SMTP id
 i10-20020a0ddf0a000000b0035f9c14144amr26607842ywe.209.1670885401042; Mon, 12
 Dec 2022 14:50:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-7-dmatlack@google.com>
 <0e159e42-ebca-c0d5-f2ae-29fa2344e720@redhat.com>
In-Reply-To: <0e159e42-ebca-c0d5-f2ae-29fa2344e720@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Dec 2022 14:49:35 -0800
Message-ID: <CALzav=efGBpf7joCwRjkF2B2VOmauuktSzRdoyWTRwVkQr1Tbw@mail.gmail.com>
Subject: Re: [RFC PATCH 06/37] KVM: MMU: Move struct kvm_mmu_page to common code
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221212224935.iMLQPCkhVSaHboCMZZ0RLPGO-3ilwjjQX6LRQety3mo@z>

On Mon, Dec 12, 2022 at 2:32 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/8/22 20:38, David Matlack wrote:
> > This commit increases the size of struct kvm_mmu_page by 64 bytes on
> > x86_64 (184 bytes -> 248 bytes). The size of this struct can be reduced
> > in future commits by moving TDP MMU root fields into a separate struct
> > and by dynamically allocating fields only used by the Shadow MMU.
>
> I think it's already possible to use a union like
>
>         union {
>                 struct kvm_mmu_page_arch arch;
>                 struct {
>                         struct work_struct work;
>                         void *data;
>                 };
>         };

That would potentially corrupt
kvm_mmu_page_arch.nx_huge_page_disallowed and
possible_nx_huge_page_link, both of which still need to be used by the
TDP MMU on x86.
