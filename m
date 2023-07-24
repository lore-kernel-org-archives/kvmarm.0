Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678C06AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:50:01 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-440c368b4e2so1341369137.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690203000; x=1690807800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IjFfzH4KKXcy4BrOOlOaHGkutEcA3/LbzWnk6l6C+u4=;
        b=0y30xbfi4RK6pRo0nSut9yPkJzpZaAOf/l4dw4O1QZ5s7Zh7tHMLayNxkepLE9RCXj
         qNTRiT/VBAUVw9cG0Gs7j49uVmWpoXN9Eogs09tgaks+GR3OCR3HJGPSNW/qYvKvDInt
         c+oSDqEQSMH1GiPbsth0Tox4EyzwX6ue7HOVfB1fSrBq9S7otYtUvEjfWmFE6aDX841Z
         KwkldI/bNghf94pIAfqie/yi8UV9HGJ6xdnRLME9paznBfuAfx60on4n4SQsi3SUlQCm
         5hUzOX046APC4/n9M/0Tquz2dq9VT2LEqaMFjCn8HbafngK1Kf3VuEUnZjXCbTmQqlNY
         /Kxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690203000; x=1690807800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IjFfzH4KKXcy4BrOOlOaHGkutEcA3/LbzWnk6l6C+u4=;
        b=ZK+LsUfa2esN9NCyj7JtGi1je0PkXAnhkQc82piQq3QwUQoEEGQCef3zny2ikJF1OP
         Z7VL3oV2jhPNOvTLmkymgZylph+oulrS5GAVXjd2OMIR84lh574YfVFRJSPlBUx1D+CT
         Uli6qcYeo4ApAjGzKi0sMJn+YFpmSIi5Xy3a3qWo/KzNsyKTZ3Druk3XO0tDq1ssAr69
         cJtxafBmfUaOBXJMTvjhMDmJHKjEqGCIpVwJPZOm4E554j0VzgVWWC5OGoggKX025ZBb
         u0K606p1D3EUN86D8Rz7BwIzsX0A/faPjY7Vkq4FgWNDS25iWPvqLMnNrKMC9qMgUnKZ
         uicg==
X-Gm-Message-State: ABy/qLYOCiBDKuNtU7jpsVr66M/o+hvp67/cSMNRi7a9628Cx14mZFuC
	5Tm7i/RVE/1Fhua2YrTq1D1++iwGkcm3wS/PHxBIZs3Y8rRsQC5hlnHEXg==
X-Google-Smtp-Source: APBJJlGsAmLeC63oS4OCmcba2CRf1XY4dlDJCL3r3to9RtZbeB6RomyPXAHqVCRhPUoB7XSJGAcBEGt9/7FGNTOu0jY=
X-Received: by 2002:a05:6102:407:b0:443:5f6e:c1b5 with SMTP id
 d7-20020a056102040700b004435f6ec1b5mr2072724vsq.18.1690202999857; Mon, 24 Jul
 2023 05:49:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com> <20230724123829.2929609-2-tabba@google.com>
In-Reply-To: <20230724123829.2929609-2-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 24 Jul 2023 13:49:23 +0100
Message-ID: <CA+EHjTxT0bqKa60M+AjxVp-2FZOsPYyK2LKH3c20bXdgUtR-OA@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] KVM: arm64: Factor out code for checking E2H into
 a macro
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies for this one. I changed the subject of this patch without
deleting it from my patches folder before sending, hence the
duplication.

/fuad

On Mon, Jul 24, 2023 at 1:38=E2=80=AFPM Fuad Tabba <tabba@google.com> wrote=
:
>
> The code for checking whether the kernel is in (h)VHE mode is
> repeated, and will be needed again in future patches. Factor it
> out in a macro.
>
> No functional change intended.
> No change in emitted assembly code intended.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/el2_setup.h | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/=
el2_setup.h
> index 8e5ffb58f83e..16d3bafa715d 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -31,6 +31,13 @@
>  .Lskip_hcrx_\@:
>  .endm
>
> +/* Check if running in host at EL2 mode, i.e., (h)VHE. Jump to fail if n=
ot. */
> +.macro __check_hvhe fail, tmp
> +       mrs     \tmp, hcr_el2
> +       and     \tmp, \tmp, #HCR_E2H
> +       cbz     \tmp, \fail
> +.endm
> +
>  /*
>   * Allow Non-secure EL1 and EL0 to access physical timer and counter.
>   * This is not necessary for VHE, since the host kernel runs in EL2,
> @@ -43,9 +50,7 @@
>   */
>  .macro __init_el2_timers
>         mov     x0, #3                          // Enable EL1 physical ti=
mers
> -       mrs     x1, hcr_el2
> -       and     x1, x1, #HCR_E2H
> -       cbz     x1, .LnVHE_\@
> +       __check_hvhe .LnVHE_\@, x1
>         lsl     x0, x0, #10
>  .LnVHE_\@:
>         msr     cnthctl_el2, x0
> @@ -139,9 +144,7 @@
>
>  /* Coprocessor traps */
>  .macro __init_el2_cptr
> -       mrs     x1, hcr_el2
> -       and     x1, x1, #HCR_E2H
> -       cbz     x1, .LnVHE_\@
> +       __check_hvhe .LnVHE_\@, x1
>         mov     x0, #(CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN)
>         b       .Lset_cptr_\@
>  .LnVHE_\@:
> @@ -269,9 +272,7 @@
>
>  .Linit_sve_\@: /* SVE register access */
>         mrs     x0, cptr_el2                    // Disable SVE traps
> -       mrs     x1, hcr_el2
> -       and     x1, x1, #HCR_E2H
> -       cbz     x1, .Lcptr_nvhe_\@
> +       __check_hvhe .Lcptr_nvhe_\@, x1
>
>         // VHE case
>         orr     x0, x0, #(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
> --
> 2.41.0.487.g6d72f3e995-goog
>
