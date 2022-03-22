Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0DDC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1984149F24;
	Wed, 23 Mar 2022 05:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q+UAhMMWeEBH; Wed, 23 Mar 2022 05:57:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F3C4A4BE;
	Wed, 23 Mar 2022 05:57:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7017C49F1B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 17:35:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wdEzwjgG+XkD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 17:35:54 -0400 (EDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C85943479
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 17:35:54 -0400 (EDT)
Received: by mail-lf1-f41.google.com with SMTP id w27so31998657lfa.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sViZwtjH37C2XjD/KE9d074ZFGD0e8UmC54d60/mnYU=;
 b=ebY6Y8EZFsj2YWkZmzXxWKTa838I7KidQLIn4kAYg9sttbpf/NkPi3l2U1jJYTLAlB
 o3VVXMXG4KYYAZi67D6xT1lRKw/dRKgKj7EyVhkBRSgVP90yv2a8viotUNqczCnN0zhm
 hQlzeIjr5Hk8szwaGLH5ipnDoziJkZS/arKaatD1nrUwVQJCGLvVIAQi2vFLuKthMXC0
 x8VwcqbnAgE3oPNYkDWpb81BeTSuzLiBJcBS9l8ZNelR296YLxRYBUnrfzbaRwZ1U0MR
 BhGR57yCQQxMat/5AOOwVTtCLN9XAX0GqI2xqiQTmbWkEZtOc8/lNJWG4929NrQ1B4Gn
 tTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sViZwtjH37C2XjD/KE9d074ZFGD0e8UmC54d60/mnYU=;
 b=bwX1qjrOXntEVABsyVkQ0huLHQJD4ZsOloA55/XIc7X9vxmpVuiy/Mk16yo+MrKMK3
 3TXvVcTV//ODSiUSvLM3fYCWvIt8tPPvMRE+gf3ZREtKXKuRXy6Y2OGDlVpmzECmQQSi
 Ly0Oai6oMBPmT7I2xWmchx8a/4BQmXmqEf/5K1ZdFwlRcKb4MCPUHv+uj+MfHMYcsx0q
 eSnlC7HU7Y16v0RJlLCHG2wKtbfd9673cDUNZap04PjV/23FGhP+dyPsHt0D5+zhrtDs
 V6zBOQyw4+81/uY76QX/iGmlPNGk8gltVdEas30sSCNcgBRT4rISpvA86WS/DAXfN2CG
 V6Ww==
X-Gm-Message-State: AOAM533/U94ckl1TqrtzKM8Q8r0WFN4MOD574jzhq7+MLUs4fTFrIlRb
 BodMK/2LvO7r0Xf4AaX61lozU0vO43hiWyNduyp5yA==
X-Google-Smtp-Source: ABdhPJwc0JSNlPahbAdqv7iJH7vq7Pz7uIXFYdwFmk0odM80FGtfrbr+pmJyyGlCdcWSaGWKIPpevvVfQwGTW0XRuvY=
X-Received: by 2002:a19:f206:0:b0:448:5b9d:811c with SMTP id
 q6-20020a19f206000000b004485b9d811cmr19184431lfh.102.1647984952540; Tue, 22
 Mar 2022 14:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-6-dmatlack@google.com>
 <YjBTtz6wo/zQEHCv@xz-m1.local>
In-Reply-To: <YjBTtz6wo/zQEHCv@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 14:35:25 -0700
Message-ID: <CALzav=c0ccztDULiVMwR4K20iYc0WH53ApeOCorhjKwaMNL5Sg@mail.gmail.com>
Subject: Re: [PATCH v2 05/26] KVM: x86/mmu: Rename shadow MMU functions that
 deal with shadow pages
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Wed, 23 Mar 2022 05:57:13 -0400
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
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
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

On Tue, Mar 15, 2022 at 1:52 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:07AM +0000, David Matlack wrote:
> > Rename 3 functions:
> >
> >   kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
> >   kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
> >   kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()
> >
> > This change makes it clear that these functions deal with shadow pages
> > rather than struct pages. Prefer "shadow_page" over the shorter "sp"
> > since these are core routines.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Acked-by: Peter Xu <peterx@redhat.com>

What's the reason to use Acked-by for this patch but Reviewed-by for others?


>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
