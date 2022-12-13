Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7A15B0
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 01:42:14 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id f9so9451079pgf.7
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 17:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=opT7QlxBkoYVHWKjfFWe+3FrtkzNsO2VihRNj3rgWn4=;
        b=SK1WTnhEcJ7vOVSL2xzzXtEkHtH43rxXSGW7Dtujo2q/jDMxxwle2K41T6LEOAbu31
         njuyn58rLHAdSISg9P623gyKYXFOPbX7pgjYFQq0nCNnpQM5nUBslElHcKrZV00WUweD
         2Ab6o7XW4eUWoa8IW7OXTpjK3c5JsXSeCBMBKd1ZVWft5A67PRSXDH8qkRexDCQaB9Yn
         RRx3hIYf+BW8rjptQ0hTe+UyiZNfb7Ry3StWfXGfsaNsXjMTMnyjPwgtlBcOWZ5bOvDK
         NYZEtjUykiKNojc+IPEX89P4N1KrKqPpyt3Z0lKnKRo6M5fuKnMpjzJMGm1TZAMuI+Yh
         G8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opT7QlxBkoYVHWKjfFWe+3FrtkzNsO2VihRNj3rgWn4=;
        b=tnDZUFjDZooGcyEgSZqdYPyey7aaLBGRws/E/V6Amf44Zy9Fw5PbgU0MTbnYHHo8rl
         MADjjIZEoBQLmiLG+HvCjtDCzfvt9k2DXdMeNFJrmlLeLmvpbIPrMilWgohiKo99KKvQ
         /xU3QYedtEEDf6mVkpoOOuo53x2tBHaH0XIb6Fu6OyFWoizgH8b+gWjpSOVFiTiG6lrt
         pUNRejQiNfSilfF2r+fjsj/uxZFndwQ6QqkT4l3MTpfO9lpUzX4jIW00zlH7uK68CVah
         dnutj8UoOGavngj39q/ZB3T02hA9eHNac9QOKclYwFQCRpNkCITn6I6fTZYwxY2J4hIf
         xSkw==
X-Gm-Message-State: ANoB5pl+rDC2VWiX1YrUEQwSw0Vrir8rylJAB37KDcnXMj83QzI79HMk
	2WBCbvkyMICW5lP0YGMOtIizxA==
X-Google-Smtp-Source: AA0mqf4Ax5/VKVlxMD5DSzFDunN/IfJNpj08Gszf3tnTB/tljXojhITyTp9EJLu9yUUGsdwIrNP7Ng==
X-Received: by 2002:a62:160a:0:b0:576:22d7:fd9e with SMTP id 10-20020a62160a000000b0057622d7fd9emr72299pfw.0.1670895734011;
        Mon, 12 Dec 2022 17:42:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i134-20020a62878c000000b005761c4754e7sm6630376pfe.144.2022.12.12.17.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 17:42:13 -0800 (PST)
Date: Tue, 13 Dec 2022 01:42:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Yang, Weijiang" <weijiang.yang@intel.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Amit, Nadav" <namit@vmware.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
	Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>,
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>,
	Krish Sadhukhan <krish.sadhukhan@oracle.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5fYcosbituc0kc4@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
 <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
Message-ID: <20221213014210.AbpEfo5TwZQbuPmYv1d0f0ndLvIv-ZNiVbBVm9wZdeU@z>

On Mon, Dec 12, 2022, Paolo Bonzini wrote:
> On 12/12/22 18:39, Sean Christopherson wrote:
> > My preference would be to leave .smm in x86's page role
> 
> What about defining a byte of arch_role and a macro to build it?

I think David already carved out a big chunk for arch role bits, my objection
was purely to making as_id a generic 8-bit role.

> > Unless I'm missing something, e.g. a need to map GPAs differently for
> > SMM vs. non-SMM, SMM could have been implemented with a simple flag
> > in a memslot to mark the memslot as SMM-only.
> 
> Unfortunately not, because there can be another region (for example video
> RAM at 0A0000h) underneath SMRAM.

Ugh, it's even a very explicitly documented "feature".

  When compatible SMM space is enabled, SMM-mode CBO accesses to this range route
  to physical system DRAM at 00_000A_0h – 00_000B_FFFFh.
  
  Non-SMM mode CBO accesses to this range are considered to be to the Video Buffer
  Area as described above. PCI Express* and DMI originated cycles to SMM space are not
  supported and are considered to be to the Video Buffer Area.

I also forgot KVM supports SMBASE relocation :-(

> In fact, KVM_MEM_X86_SMRAM was the first idea.  It was uglier than multiple
> address spaces (https://lore.kernel.org/lkml/1431084034-8425-1-git-send-email-pbonzini@redhat.com).
> In retrospect there were probably ways to mix the best of the two designs,
> but it wasn't generic enough.
>
> > And separate address spaces become truly nasty if the CPU can access multiple
> > protected regions, e.g. if the CPU can access type X and type Y at the same time,
> > then there would need to be memslots for "regular", X, Y, and X+Y.
> 
> Without a usecase that's hard to say.  It's just as possible that there
> would be a natural hierarchy of levels.

Ah, true.
