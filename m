Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8A6ECAAD5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 05:45:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F2E54B9CC;
	Tue, 30 Aug 2022 01:45:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zlm06eGH1qwZ; Tue, 30 Aug 2022 01:45:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4952D4B9CD;
	Tue, 30 Aug 2022 01:45:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9024B9CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 01:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ySvt-w9Hft6y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 01:45:25 -0400 (EDT)
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com
 [209.85.221.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A90D94B9C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 01:45:25 -0400 (EDT)
Received: by mail-vk1-f179.google.com with SMTP id i67so4758417vkb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 22:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=VMIb6GYUzCfc3+/Xc4FMCchhP72IJrj9lhvFB6QXdWk=;
 b=f2Pjgks1IgKLfp0+ju5p5beAZLmt3On2jj5QhBlcOIrKKZeODOrrEKhz/CdsZzzdBY
 6UbA7bFIew2N9rxzUYi0wAMWmfAmlnUUFbdEN1yxsBxzYR4YpoPtrK+CV73kMsLk/BVG
 HrXedqkwlnhE6yGBZYU7GHtJKL7lTerjh15KqFlY6sbXZTNrVc5tr9flLEJaFhPQxMbm
 mPzhDTW7PjP/KcxdJHsaqL233Dm+suiNJoJnM2NkHJjW5txU9I5jzX3RhBqFewIDBkoG
 1zcoWVVpBn24ORPDctxwJ/hM9V41HHaWGlbigp4IBz74s/WIHab4Ues9WLlZXvQHYtkP
 RfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=VMIb6GYUzCfc3+/Xc4FMCchhP72IJrj9lhvFB6QXdWk=;
 b=AbVeJizV3GQwbpwAm8Xq4viHl46NifuXW079UvyVZSICNANSFKZ/H9BNsQGwwHZ90P
 +km3NqRKUi3Tm1ehm2K3rEJ+huy1r5JftsJl6aLueytiCGsob7RWzwrMVL9WhxWyUeYw
 YmI0ArqrN3xkLO/Ylli5X8ZEBJdjz8vuFAPHUzjjkR+uLWjZ1GMijqi4WlSaDIni8aVl
 2NibNQAt9/ZK5sBsKyvsHLLNJV4QQ6rPPq7cTXirl/cPxWdZpv2WxBLvDGPWRWkqdVjP
 cv73lFdl/hpfLA9McrzDF516KB9VRBr1CJquXKFwtdScVlnaOUPTYKNu1ijiMS9l8Htc
 LetQ==
X-Gm-Message-State: ACgBeo2PL0qG+6o8KIKzkxETF4JbhKofKv5QhD54lW/69TjZ97eRLbfS
 woTqzRYjfgzS93f5aeskAA7f9/3iR3qasOQX2+UOLw==
X-Google-Smtp-Source: AA6agR6NGjZWRN7kcpaJwBnPGNtCazicEBMDo6qxVbvkwJ3SiTOD5XMcJOtSs8He+R18T3QSry+edV6obBbxGLOCq84=
X-Received: by 2002:a1f:bd0e:0:b0:394:9da0:2449 with SMTP id
 n14-20020a1fbd0e000000b003949da02449mr126935vkf.4.1661838325018; Mon, 29 Aug
 2022 22:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-3-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-3-oliver.upton@linux.dev>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 29 Aug 2022 22:45:09 -0700
Message-ID: <CAAeT=FwxN=UtVGO+85iZNRkGEoZ7GQ_WB4FAhHBRnCKoPNXHVg@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: arm64: Remove internal accessor helpers for id
 regs
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Oliver,

On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> The internal accessors are only ever called once. Dump out their
> contents in the caller.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 46 ++++++++++-----------------------------
>  1 file changed, 12 insertions(+), 34 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e18efb9211f0..26210f3a0b27 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1153,25 +1153,17 @@ static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
>
>  /* cpufeature ID register access trap handlers */
>
> -static bool __access_id_reg(struct kvm_vcpu *vcpu,
> -                           struct sys_reg_params *p,
> -                           const struct sys_reg_desc *r,
> -                           bool raz)
> -{
> -       if (p->is_write)
> -               return write_to_read_only(vcpu, p, r);
> -
> -       p->regval = read_id_reg(vcpu, r, raz);
> -       return true;
> -}
> -
>  static bool access_id_reg(struct kvm_vcpu *vcpu,
>                           struct sys_reg_params *p,
>                           const struct sys_reg_desc *r)
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, r);
>
> -       return __access_id_reg(vcpu, p, r, raz);
> +       if (p->is_write)
> +               return write_to_read_only(vcpu, p, r);
> +
> +       p->regval = read_id_reg(vcpu, r, raz);
> +       return true;
>  }
>
>  /* Visibility overrides for SVE-specific control registers */
> @@ -1226,31 +1218,13 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>   * are stored, and for set_id_reg() we don't allow the effective value
>   * to be changed.
>   */
> -static int __get_id_reg(const struct kvm_vcpu *vcpu,
> -                       const struct sys_reg_desc *rd, u64 *val,
> -                       bool raz)
> -{
> -       *val = read_id_reg(vcpu, rd, raz);
> -       return 0;
> -}
> -
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> -                       const struct sys_reg_desc *rd, u64 val,
> -                       bool raz)
> -{
> -       /* This is what we mean by invariant: you can't change it. */
> -       if (val != read_id_reg(vcpu, rd, raz))
> -               return -EINVAL;
> -
> -       return 0;
> -}
> -
>  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>                       u64 *val)
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, rd);
>
> -       return __get_id_reg(vcpu, rd, val, raz);
> +       *val = read_id_reg(vcpu, rd, raz);
> +       return 0;
>  }
>
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> @@ -1258,7 +1232,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, rd);
>
> -       return __set_id_reg(vcpu, rd, val, raz);
> +       /* This is what we mean by invariant: you can't change it. */
> +       if (val != read_id_reg(vcpu, rd, raz))
> +               return -EINVAL;
> +
> +       return 0;
>  }

I see no reason for read_id_reg() to take raz as an argument.
Perhaps having read_id_reg() call sysreg_visible_as_raz() instead
might make those functions even simpler?

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
