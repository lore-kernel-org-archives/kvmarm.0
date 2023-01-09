Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37428163
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 18:56:13 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id t15so9471744ybq.4
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 10:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=npK1pVWS9Y7zSvO0nWYdwcAA7TbeGlnyEckY5HPb/Qg=;
        b=EHKm0/F2buMoOsKhjWg0lWsOuJldy/zfoO9SoYjwOUBjEtYFI7vDu+I5lwSpjMbW6Z
         3ObtFaGnVjmdcg2O2Aret0FZO2bn7yqTJbEhANZLCO7TmNFgRBE+1H+8TwiSfzm06+sv
         NoXn+BRIUqVauOHPZ13p93njC8trw+pKMvKGKG+JOay5G96uMzNCvp6yocnoligPU/KG
         nsT5KAmMgHERAldXeigMGDd8xVH2mvsfpS/FV/+f0V+6HxueWNzcx2CaGaqz8pAq/Qe/
         1IhIl/jFSe8NXCzMDt2iiVq0nAJOXzbL0gSR4VpeaFp+Z0f01ufRbR7OxltlcKWyJfdN
         GLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=npK1pVWS9Y7zSvO0nWYdwcAA7TbeGlnyEckY5HPb/Qg=;
        b=3QJF6uN7kxwIZPkadWtsTvUxWcwpl29tj2+W+2h8WWso9pnh6jNJbLgX7DCcTr5EPJ
         YVf9hJ+VIW37yru5uxUEZcyH4udUQrI9/gGivleKnISzVMDo96A9YhbgKSmzaHmUnjSS
         yNk+8lTt/+D+UsJIrKJ89en6CNQpukeAe3LnH0IQA9FRhRGls6sthNB37Qqipx/9XzXs
         H5JA2e1GYLVNR97mS7T97MLm2DLtB/rFlVFzfFixW2HBE06cVT+8MDGq3nPbL1BwaD+p
         sIwIBQBlyKWZXwaJ0MkI3qIPmobRRGr5EJLfplyE5RddxyKFUgiVG9um4INEbBCE4LVO
         9DYw==
X-Gm-Message-State: AFqh2kp5WdWC9jjSnHUUmPPBJ7t3wj/ZO0742FMHIr0dTiMXbFDcBrRy
	XEOdWx0fLhA6k4h/4tSqfCcFL+KGxtTfm3CbO3NXnw==
X-Google-Smtp-Source: AMrXdXuGuwlSiliqUzNPwuP95duqjm2wzwipEY34JM0d62JWS00zM7bbMqGhGQDGetcNhy7upYl68Cx0Wdx6BZEJfKU=
X-Received: by 2002:a5b:1c8:0:b0:6fe:46c9:7479 with SMTP id
 f8-20020a5b01c8000000b006fe46c97479mr7514517ybp.191.1673290571936; Mon, 09
 Jan 2023 10:56:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-11-dmatlack@google.com>
 <ce1ea196-d854-18bd-0e60-91985ed5aaea@redhat.com>
In-Reply-To: <ce1ea196-d854-18bd-0e60-91985ed5aaea@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 Jan 2023 10:55:45 -0800
Message-ID: <CALzav=fVbvKQMhSBD0AdrRTH+jDyRG0Hf5M-H7vCtRCR1Lk9sw@mail.gmail.com>
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common code
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

On Mon, Dec 12, 2022 at 2:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/8/22 20:38, David Matlack wrote:
> > +
> > +     /* Derived from mmu and global state.  */
> > +     const bool is_tdp;
>
> I think this could stay in the architecture-independent part.

I agree but until there's a use case for accessing it in common code
I'm inclined to leave it in x86's kvm_page_fault_arch.
