Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2138BC0502A
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 06:01:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D0A4B8F8;
	Tue, 30 Aug 2022 02:01:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id md-zs4YgARzC; Tue, 30 Aug 2022 02:01:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8DD4BABF;
	Tue, 30 Aug 2022 02:01:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 661D54B8F9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 02:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eF3Yu136ScIy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 02:01:20 -0400 (EDT)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com
 [209.85.221.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 159DD4B8F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 02:01:20 -0400 (EDT)
Received: by mail-vk1-f173.google.com with SMTP id o12so500176vkn.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 23:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=II0ZRvpyCmZsr92YqXuZZ/vXhZG9dSd/cKIK3SFpfT8=;
 b=nwIphf3SN8SPDI9lF45xXNGKxzXuBy7/MpijMVPbJJEnFUjmXUk/NJBLl4HtecAxI7
 HB0Q1UcHnMwPQ0GJq25AOgkwYNaKF+m2suVblmUrWysR6BgQ88RHvf16YDxn0l5zVKIR
 O37N9tSePzxVSeiUVPUEySP8/SH46wYQVSXhUWzoVYdsccS1bA3i79LJg/GUqtSatfgS
 kcv8IdzpjaqBrJxmb22srS5pcyHjqyVOJf9jbW+zc5EoYi27RP4Q6D9tOMnAW4e2hW3P
 m0jJ+anCP7RLsrVNhcjf4p+gfNXeGz9FYEMPCTbg1DaO20KI5SYQD5n5vFae95EyjI1p
 SH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=II0ZRvpyCmZsr92YqXuZZ/vXhZG9dSd/cKIK3SFpfT8=;
 b=qyBCVBNEDS0LMiYZaNSuICRx8QJd91R4p2t9sBsmmZwRgqe+DEpDOoRQYX/CgesQNW
 gRR24W+Iu5j+NceusjhgJk7n17iAdV7p9LUfK1sgCwx9W0aoPo5Q9ZY+pyM/pGOXv/J5
 4KVvrbfxt5L6QTvqoqTHGP0UeANaBpKoxVuz9JeQ8vkcuApC9nMzzok9D3Zd77vXGrn3
 F+8gecN8G4rRMY5gs9fHWrL6My2NWbyBYDjvBNMlbe9ulPW1G9UMIaifRSHGYokkTqDv
 +dU64rLyv5Wlol63fVW8HLXv0FNpl1irimURtKLnoYCRmBMCMYrRjqfx1Q6i7YwVrkJf
 Ol4Q==
X-Gm-Message-State: ACgBeo3PNk11MCuSRPw0XRcVFBwClvUbxU5eNvcFRqX3+rCJg1IJICHc
 zabZe0o0/zHW6GL+RWfK3FwRwtNfxXriA7NMchrFQg==
X-Google-Smtp-Source: AA6agR6/43t9mn8vyQUyis7KwGHYx16rxCk7VtEspKIvDh0GiZ5lOGt5Ps7J26fqhMvj2fNUfNLWdXs7y/LmQokPsdM=
X-Received: by 2002:a1f:a30e:0:b0:380:81d3:2562 with SMTP id
 m14-20020a1fa30e000000b0038081d32562mr4148222vke.7.1661839279500; Mon, 29 Aug
 2022 23:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-4-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-4-oliver.upton@linux.dev>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 29 Aug 2022 23:01:03 -0700
Message-ID: <CAAeT=FyNDjNvqeDWMVRtGiFrPo7D9p8Z4PAVAJPkpSRbRRcP5w@mail.gmail.com>
Subject: Re: [PATCH 3/6] KVM: arm64: Spin off helper for calling visibility
 hook
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

On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.h | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index a8c4cc32eb9a..e78b51059622 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -136,22 +136,25 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
>         __vcpu_sys_reg(vcpu, r->reg) = r->val;
>  }
>
> -static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
> -                                const struct sys_reg_desc *r)
> +static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
> +                                            const struct sys_reg_desc *r)
>  {
>         if (likely(!r->visibility))
> -               return false;
> +               return 0;
>
> -       return r->visibility(vcpu, r) & REG_HIDDEN;
> +       return r->visibility(vcpu, r);
> +}
> +
> +static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
> +                                const struct sys_reg_desc *r)
> +{
> +       return sysreg_visibility(vcpu, r) & REG_HIDDEN;
>  }
>
>  static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
>                                          const struct sys_reg_desc *r)
>  {
> -       if (likely(!r->visibility))
> -               return false;
> -
> -       return r->visibility(vcpu, r) & REG_RAZ;
> +       return sysreg_visibility(vcpu, r) & REG_RAZ;
>  }
>
>  static inline int cmp_sys_reg(const struct sys_reg_desc *i1,

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
