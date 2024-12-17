Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5451DAC93
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425052; cv=none; b=gPu28KhqquDuz/sq4lWhc5uuAuNjOUniMQ0TmGNpK2Lx0vbtdXUu0/9kT75OZ+x96xCZJDdyuFNpC+EdsGE7c9w9Et8Cbu8NOXspIHLyY5AAXhQNkHcSJ7HYnVdE8SxLgR/AvBcLDP9PYJS9W86RXLEETEMjUYuODtymEMwAQ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425052; c=relaxed/simple;
	bh=CzNcFF88uddDnzy+LRXi6AvU0SQB03wFYGhto7aKcH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KkBGMVhn9SbEY5MqXO0zthFqEARUTim4YVOFUPv0OtvxLWAVa4/yIpPF+LCcWSkwG9/CCh47KO5XPf0IgybjX7wAncOt/tL3WCS/am2RFk+Ip/P81xsQSmzrPZh0QCUvr8domgAEwQVhw0a67gS6Su15s4GzW6hCzCqvww7VjR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xDxkcFxA; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xDxkcFxA"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361d5730caso26955e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425049; x=1735029849; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9aOMhauyNEGMb+lCk/+Fik0KUFbDUblO2f0wjbG5sGk=;
        b=xDxkcFxAbioMSwnDY6fSxRiY9OGc5tDGMf0KWKR6mQwfbGdnMr1femWp9zcIUwFsET
         2SFviIpGRpFUZLuiz3/E+gJDWHMy3i2xyhVhLFVWimy1LPxxXzhV597+b03CvLcMPIMX
         oZDLVFVZrDceEC4tD0V/yijXe8CSbcs4p8nicEVrrd+iZDKeJfmsR4o/zgIr9GgraM+p
         a04NnUrzppCKDdqpCAlvHeXHxtuujRaceKrgAgddcQOZzJI56qvsx7fZGdw2uQ8Xan9Q
         D8u3gRGmJSYTN4E2Tmb3rmJ2B//di55b9LiIVUJvpTpsymZ/86L/2l+Tu++aSyU8+W6J
         yTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425049; x=1735029849;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9aOMhauyNEGMb+lCk/+Fik0KUFbDUblO2f0wjbG5sGk=;
        b=a+6PsLOLMSUghC2Md/qgmRJGmgFzfCq+PQoL48mIZ3muvsvF+BgYrX0jJrnrWed58i
         tHzYYORVC72HXY10vMszHibj7iPzYDDf9H2uwAazhEj57hBN19Tmw4hweh7s0LUUhWiQ
         vxFdQeQtAJkgpNeNT2fhWXTzsVFuYbyPmRArS8Uxa6ZKag7WuI/tqiJMsoI5nXMXZjdY
         33FDbCA8Obh5EFjre7BLF9orSrd2283hjqa9FR+bE2k64BAMgqGY9/nuWAN/PHLd8gzA
         yu6nrzJFRpxByH6hWZvhYTRLAIUjdg4kcirq+ef/klAYh85ryBjx1MAyymTU9Gk5PzDB
         x5QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfF4CUALFjsa7gs10tVxBNXyRKhBwSizi+FPrjrh1TeyFf7shodO+vnx4AIUtmjzqz2URPsuY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7H5xc2IreOxNAZgKrbcjmiF7FNsOYloUHadagMIyNfrSx1+QA
	E0n6HsZNl5OirXInkTepfnDAxHICAyTYkO4rEbBfXfap58cRX+JcvtZuU6kzksXGKiau9FOF5hZ
	/H16K84vWXYQ98j8k2GLfkNuVG+G99/hom4wo
X-Gm-Gg: ASbGncs5cHb22Vql1/tTDE9ZXNOl3Q9yE7xfoYmuQA/3ubZdh0bndbWhZAa+sb69yt/
	rhWDjSzih0heHx5gEFIeqS+ofXaHbdmSKeuyJCVshspYuma+EAbh9Kq2JFy64ZcbzUw4=
X-Google-Smtp-Source: AGHT+IF4JRtgEWyFkNnA7Okyum1zxkryf5hfSceNzF5pRsh6nPxBddG8vtt5SAlgqybP5Y0TnQhiQk19Bz3LqCTEjLo=
X-Received: by 2002:a05:600c:4d21:b0:436:1aa8:d05d with SMTP id
 5b1f17b1804b1-43648c98e30mr922405e9.0.1734425049163; Tue, 17 Dec 2024
 00:44:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-3-qperret@google.com>
In-Reply-To: <20241216175803.2716565-3-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:43:32 +0000
Message-ID: <CA+EHjTxmt4QdmiqCCJh9kf9aGL36hVXRXCr+EgdT1TDk_arJ=w@mail.gmail.com>
Subject: Re: [PATCH v3 02/18] KVM: arm64: Move enum pkvm_page_state to memory.h
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
>
> In order to prepare the way for storing page-tracking information in
> pKVM's vmemmap, move the enum pkvm_page_state definition to
> nvhe/memory.h.
>
> No functional changes intended.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 34 +------------------
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      | 33 ++++++++++++++++++
>  2 files changed, 34 insertions(+), 33 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 8c30362af2b9..25038ac705d8 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -11,42 +11,10 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
>  #include <asm/virt.h>
> +#include <nvhe/memory.h>
>  #include <nvhe/pkvm.h>
>  #include <nvhe/spinlock.h>
>
> -/*
> - * SW bits 0-1 are reserved to track the memory ownership state of each page:
> - *   00: The page is owned exclusively by the page-table owner.
> - *   01: The page is owned by the page-table owner, but is shared
> - *       with another entity.
> - *   10: The page is shared with, but not owned by the page-table owner.
> - *   11: Reserved for future use (lending).
> - */
> -enum pkvm_page_state {
> -       PKVM_PAGE_OWNED                 = 0ULL,
> -       PKVM_PAGE_SHARED_OWNED          = BIT(0),
> -       PKVM_PAGE_SHARED_BORROWED       = BIT(1),
> -       __PKVM_PAGE_RESERVED            = BIT(0) | BIT(1),
> -
> -       /* Meta-states which aren't encoded directly in the PTE's SW bits */
> -       PKVM_NOPAGE                     = BIT(2),
> -};
> -#define PKVM_PAGE_META_STATES_MASK     (~(BIT(0) | BIT(1)))
> -
> -#define PKVM_PAGE_STATE_PROT_MASK      (KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
> -static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> -                                                enum pkvm_page_state state)
> -{
> -       prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> -       prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> -       return prot;
> -}
> -
> -static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
> -{
> -       return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
> -}
> -
>  struct host_mmu {
>         struct kvm_arch arch;
>         struct kvm_pgtable pgt;
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index ab205c4d6774..c84b24234ac7 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -7,6 +7,39 @@
>
>  #include <linux/types.h>
>
> +/*
> + * SW bits 0-1 are reserved to track the memory ownership state of each page:
> + *   00: The page is owned exclusively by the page-table owner.
> + *   01: The page is owned by the page-table owner, but is shared
> + *       with another entity.
> + *   10: The page is shared with, but not owned by the page-table owner.
> + *   11: Reserved for future use (lending).
> + */
> +enum pkvm_page_state {
> +       PKVM_PAGE_OWNED                 = 0ULL,
> +       PKVM_PAGE_SHARED_OWNED          = BIT(0),
> +       PKVM_PAGE_SHARED_BORROWED       = BIT(1),
> +       __PKVM_PAGE_RESERVED            = BIT(0) | BIT(1),
> +
> +       /* Meta-states which aren't encoded directly in the PTE's SW bits */
> +       PKVM_NOPAGE                     = BIT(2),
> +};
> +#define PKVM_PAGE_META_STATES_MASK     (~(BIT(0) | BIT(1)))
> +
> +#define PKVM_PAGE_STATE_PROT_MASK      (KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
> +static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> +                                                enum pkvm_page_state state)
> +{
> +       prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> +       prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> +       return prot;
> +}
> +
> +static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
> +{
> +       return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
> +}
> +
>  struct hyp_page {
>         unsigned short refcount;
>         unsigned short order;
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
