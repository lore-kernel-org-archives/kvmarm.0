Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B7E376
	for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 04:22:05 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id w22so2883502vsf.13
        for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 20:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DmQBbpAu6B0uYYhxH30aHdK9UMmXNgVHX14jvNOggZk=;
        b=tJA35Ofvs7OhFLQM4OAO9pyzBvthd1pHbKdaGQcRJ3YavWvQaShc7aTkBnKhHNN/qf
         71V0DM19hvtEjOHUzjLR2745KsM8dlyMKcd01CcQ+FwFzC7/bE1MPLr0cth7zPVN5t84
         xXJakn3yMkVRExor1tx6+hTzGcDc9X7aMCvaIxvranghfxdnSmz++u5JcY376v30Pvve
         cbEsgeTf3k8MLOzEzpPng3PoJj+Ma95D9fTXhjgzq7h+2JupaecZZY1EoqYZmXBd2Gl2
         pokR2z1r2mqfRnRHTWASeUWMVLlt4NHNRc3gZ0KfBJzISW6RhMZlmTLJmVp6kSJ54cKK
         2BCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DmQBbpAu6B0uYYhxH30aHdK9UMmXNgVHX14jvNOggZk=;
        b=CKG/BRkDngtDXeHEMBVKcjTYkPk69bcDQ/xLGW4rfDxurgt46InEwQYjwZq/rtffs/
         8c6oaaGHp5tfBn02ejoWJNHbwo0HHJ2QOGo2wEOHDJtFpqoS2ewcKq5+xS248ywvt8CF
         wRc48YOriVlgs8U8tqwg8ogQkfLqfI/HYk38Iee2bs4tpxAF7CdI4TDNU0N7JwtN55tU
         kLtjRGf8YUPReNmFBWFHc4CUlhOj+ToD6bPTrCjMXPPr9sUHqOIQxnxVtUAqTa0+Y8wn
         5eHW4osr7yZ6xBYnLgjSW0BCcbbBt818XrCFNXryQRAzeRti+aIT4Qu/T2qkAERtZvAG
         joRg==
X-Gm-Message-State: AO0yUKVne6s2rL0B+4kksoV6f+FwcAwlhz8zLEy5vbua9UlTFIerePaU
	vU0xNFyQbT4ZjHZ2xg8UVZjVSkmHg9+hFM5ULkxR0Q==
X-Google-Smtp-Source: AK7set8pOdWfIt69LFD7Klja37MX4Y0B4AgeZGxYGFzE3TmHzaA3GYFi17QwE/R0IT0jJksQbazWrQ2EJ3TyMlpGcMk=
X-Received: by 2002:a67:cf47:0:b0:411:c1a0:c787 with SMTP id
 f7-20020a67cf47000000b00411c1a0c787mr1602974vsm.26.1676607724287; Thu, 16 Feb
 2023 20:22:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-4-yuzhao@google.com>
In-Reply-To: <20230217041230.2417228-4-yuzhao@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 16 Feb 2023 21:21:28 -0700
Message-ID: <CAOUHufYSx-edDVCZSauOzwOJG6Av0++0TFT4ko8qWq7vLi_mjw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 3/5] kvm/arm64: add kvm_arch_test_clear_young()
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
>
> This patch adds kvm_arch_test_clear_young() for the vast majority of
> VMs that are not pKVM and run on hardware that sets the accessed bit
> in KVM page tables.
>
> It relies on two techniques, RCU and cmpxchg, to safely test and clear
> the accessed bit without taking the MMU lock. The former protects KVM
> page tables from being freed while the latter clears the accessed bit
> atomically against both the hardware and other software page table
> walkers.
>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  7 +++
>  arch/arm64/include/asm/kvm_pgtable.h    |  8 +++
>  arch/arm64/include/asm/stage2_pgtable.h | 43 ++++++++++++++
>  arch/arm64/kvm/arm.c                    |  1 +
>  arch/arm64/kvm/hyp/pgtable.c            | 51 ++--------------
>  arch/arm64/kvm/mmu.c                    | 77 ++++++++++++++++++++++++-
>  6 files changed, 141 insertions(+), 46 deletions(-)

Adding Marc and Will.

Can you please add other interested parties that I've missed?

Thanks.
