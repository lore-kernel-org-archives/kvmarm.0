Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A281DDF8
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 21:55:16 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bb962ada0dso31339225ad.2
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 14:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690840516; x=1691445316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mxm0zlWAhsdwPNs5iJKIB42nBu2Sipk2tDe8KMVu/ek=;
        b=ytmpshOAB12qGqTyFlWk5nuibqbjszjzG8HlzRak1nXLBRIW7mqhUOB3pdnUEqnw9p
         ULxnWPLZRD2mRlVyB/5q0bX5aw1YvfLLdUMnRf4zI7SyNr0EH4R4tqZ2ZiseNI/YvKYQ
         OZ7Y8CSXug8EnjUACyUdgtTfIF4qmkOQgAhYTbRl3Yf5EpZjTT6Y30q2mELLLrGNzfAI
         TWHiUWWZhxH6y1Ge+v/UQbVXBXj23ItOQKCwVAD9/GNOUpV5F9QWb/vBOmkWUJSZ5ia8
         2yt2+GgEWjOZeaHfuSn3YEhuGE3VZrD7PEIEAsa/FVk3PFxtUHAMyfY0BGbbF9GkdiQc
         vKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690840516; x=1691445316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mxm0zlWAhsdwPNs5iJKIB42nBu2Sipk2tDe8KMVu/ek=;
        b=DwLiDf+KALYlVhCtbSC0OMGaCTTiI+HG2RqGG6GHlNxlRgI63JL502otu4yAHkeo+a
         Xk40AJdt4RF0+LbuQ9oeFzLQF1hel0Apkx1H36+G7d/t7XF8QbUknrVzGOYHsykmOrmm
         UFP5z17y1GIBwSpZIVe1gJxqZR6KZWrYW69u9LEQ0mjy7yAn8lL0xv1PTAUtgFHkuq6+
         MwqRSLMtIwd331AlHRxJNhwnJMl1J/1sT8pHL94/Vt/IVdOxHC6WA5iQj6lzhnnu8LZ5
         c8Whp9E2CZ0pIEnS9IvkePPhhl5X6dB4wKX4HeTK6sSLfp2tWsV4Br1N1fIBNj4a3An+
         np6A==
X-Gm-Message-State: ABy/qLbqp36ow4+b0ai2uW9JWQd8v9do19bNctgs5ZpQJ9CQgytgkF9c
	RHkwBlA3N3uTtU+SgJGrq0hAzMtM7/c=
X-Google-Smtp-Source: APBJJlHx/oZJ65GqvDqk2V7Za+tbO1+mKQOFTUapwiCiODu7Ma2pbwshPhgFtt7G52AjT0XsLIyUCa+03cU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2309:b0:1b3:bfa6:d064 with SMTP id
 d9-20020a170903230900b001b3bfa6d064mr49693plh.1.1690840515767; Mon, 31 Jul
 2023 14:55:15 -0700 (PDT)
Date: Mon, 31 Jul 2023 14:55:14 -0700
In-Reply-To: <20230722022251.3446223-5-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-5-rananta@google.com>
Message-ID: <ZMgtwp/YCZciRvdr@google.com>
Subject: Re: [PATCH v7 04/12] KVM: Allow range-based TLB invalidation from
 common code
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Jul 22, 2023, Raghavendra Rao Ananta wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..eb88d25f9896 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -278,16 +278,15 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
>  	return kvm_x86_ops.flush_remote_tlbs_range;
>  }
>  
> -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> -				 gfn_t nr_pages)
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)

Please keep "nr_pages", I have a very strong preference for that over just "pages"
as the "nr_" makes it super obvious that it's a single number, as opposed to an
array of pages or something.

And it doesn't truly matter, but IMO the gfn_t type is more appropriate since
the gfn and the number of pages need to have the same type.
