Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CB3C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 07:17:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 243F54B1E9;
	Mon, 16 May 2022 03:17:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Oj-Tm4CarBc; Mon, 16 May 2022 03:17:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEF8F4B08F;
	Mon, 16 May 2022 03:17:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7F64965C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 02:55:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V0bBaDhqT6Cw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 02:55:07 -0400 (EDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com
 [209.85.219.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91EA24141A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 02:55:07 -0400 (EDT)
Received: by mail-yb1-f170.google.com with SMTP id j2so25466938ybu.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 23:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1dK2edFTU6ZA396mt6VL7asKfbqNWslhLCJG//w22WE=;
 b=WVYfP4NvxnHADNi+hRg6j3xIW9SSgkwiYdcc4w4LkOcObEbK4djJuGbyRgSNXfqRUc
 /OpAOGbxuX0XJVU+FZAjYzt6GgK2Z+C0SZukTADGxR5J3mtX3I5HAItHwW8nzVi6yVay
 HO+mhZ0KkyMX4E6/xxDVv1j6XmvTBkZT8N2qrsYsG7VZd30ddAmcKTEEj1X/ekScfmpI
 E1Ep5yaon/rUT9cGuvuGaHRt+iBlFR1trUiR46MoJ4KR+qtTNUlRRJ4IwqRPhW114le9
 DMvywKUWPGHv1WSyDW+cMm+0w2JQO+XgUC1uuhm5N/9Lmnaumrt3JJMYnTvjeMSP7ciz
 o5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1dK2edFTU6ZA396mt6VL7asKfbqNWslhLCJG//w22WE=;
 b=UaANZkrzpBc7IJAg4nwHLWwoaPHiHu4VwLeVVym1fDhkrXrC57IvcqG4mqtvEwNWTW
 vr6ggS4fCwO24Ek8ivg3Ih7+bk6zy5DQBq+h+opfsvKQbr4bRhCyeWTYWGWORJtsaVwa
 qC95RFIqAWitC//B1f+hjYf7u5W+IaAgxYNVOF0tIDDJiL5MhVWB8yP+jcVfl4in63Ms
 mGf6/5GIFzuScoMxnr7ztDkugFl14OSOaem95qcyNDP/97dHHHxBbnl+FH+Txs9YG5tb
 2IWFd5bpdabkwa4EBjEjipmZlerX3l2xt/2r82RSagy51USbIkHKP4bwE+AliZeBhsaB
 yYNw==
X-Gm-Message-State: AOAM530Pzdj6hn4isnxesJhan+YkxNFnP8IzQRZ6R0oBJsARt6+88wSE
 rCRokDw3nQx0g84XWDxrWOh9lNxke49o0ZN1DKE=
X-Google-Smtp-Source: ABdhPJzocFzE5rLFilLG6+T+z0h5XBshtuxJ3zJwJJbakycdvZGhiUOe/2JYCMFm7TDfi4FBy+rA24Yx8TOKnCEWpQ0=
X-Received: by 2002:a25:cf42:0:b0:64d:8800:ade3 with SMTP id
 f63-20020a25cf42000000b0064d8800ade3mr5478053ybg.376.1652684107021; Sun, 15
 May 2022 23:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
 <20220513202819.829591-4-dmatlack@google.com>
In-Reply-To: <20220513202819.829591-4-dmatlack@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Mon, 16 May 2022 14:54:55 +0800
Message-ID: <CAJhGHyAU_5Esn6i-eeBNKOh4XenOc9_1aiF8N0+CeMF5yyhxew@mail.gmail.com>
Subject: Re: [PATCH v5 03/21] KVM: x86/mmu: Derive shadow MMU page role from
 parent
To: David Matlack <dmatlack@google.com>
X-Mailman-Approved-At: Mon, 16 May 2022 03:17:36 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sat, May 14, 2022 at 4:28 AM David Matlack <dmatlack@google.com> wrote:

> -static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
> +static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>                             u8 level, bool direct)
>  {
> +       union kvm_mmu_page_role role;
>         struct kvm_mmu_page *sp;
>
> -       sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
> +       role = vcpu->arch.mmu->root_role;
> +       role.level = level;
> +       role.direct = direct;
> +       role.access = ACC_ALL;
> +
> +       if (role.has_4_byte_gpte)
> +               role.quadrant = quadrant;
> +
> +       if (level <= vcpu->arch.mmu->cpu_role.base.level)
> +               role.passthrough = 0;
> +



+       role.level = level;
+
+       if (role.has_4_byte_gpte)
+               role.quadrant = quadrant;

Only these lines are needed because of mmu->pae_root, others are
the same as vcpu->arch.mmu->root_role.

The argument @direct is vcpu->arch.mmu->root_role.direct.
vcpu->arch.mmu->root_role.access is always set to be ACC_ALL.

vcpu->arch.mmu->root_role.passthrough is 0 when mmu->pae_root is used.
Or if vcpu->arch.mmu->root_role.passthrough is 1, @level must be 5
and vcpu->arch.mmu->cpu_role.base.level must be 4, the code here
is useless.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
