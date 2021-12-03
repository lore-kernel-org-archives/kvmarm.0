Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A907C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Dec 2021 08:29:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0DCD40642;
	Fri,  3 Dec 2021 03:29:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LYgDF+IrDZHe; Fri,  3 Dec 2021 03:29:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D7B94B0CC;
	Fri,  3 Dec 2021 03:29:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AF954B0C0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 03:29:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UBC19vGbG0yU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Dec 2021 03:29:36 -0500 (EST)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 549B34B0BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 03:29:36 -0500 (EST)
Received: by mail-oi1-f169.google.com with SMTP id bf8so4452868oib.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Dec 2021 00:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=B6rbGDDnuKK1TJDEU0UHOS4JAtrhB5a4QxNTOY21YgE=;
 b=WUpT/oF4Eg5AmS3IU5iQZjg23Y99fZacMadfs5VVvqJngMtDWQqTgg5rH+U7YSRDga
 wej0P+a/+kOD81DFrhJ6NPLiVWQYu5dn4NheTVT0lopog5U/7k145aPNWAmFORM+F/At
 iwVwV17Y8z7cSAVBdAVWk+aBt4eWqquhpaCGFuuwoqQHQmvyiKGq8H4ucHHhhQnh0/OV
 SKIOrXhwXwL588QeSyDcns/FEiWVwKWCaMgkETfWyOjpvMYCB1w/kmjMqBaVc/xzAdbm
 dEq/GERfZDZj5jt4m8OTG7UCFPxUg4OkATLLg9U5QY3dqADAIQFwQuZGIyH+fTF/dR4m
 ZLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=B6rbGDDnuKK1TJDEU0UHOS4JAtrhB5a4QxNTOY21YgE=;
 b=1JRjWxsKwkahm7bRjfjJuMzinCR3qsYge+zjn8m4WrJ0vIyEYdxi5Kw+BVObxXGkiR
 ybDCUV9NKqhLnmnc+EfwqvHZgZpRU0tBe53O1NILxaETZaMUSStp0sncmhfsMyNFgfBh
 ldfDnJoh5Zbzqw/mFloQjHVSF7uPTDYoFBExQ7VptBUwVBISFiKG+8BsDB1GqeZHSIeK
 46Y/3OkaU4A2qrwS7NrHoqF285GLczDkhiitDh4OF37ojzyw8meF55cYEE32GSIWnqqY
 +MQXt40gg4n1wTRnuSmA7qs3G5dfx2KBtSZ9pW66pKhkVB+VQzAPMHpvDbuTSScsUuxL
 I10g==
X-Gm-Message-State: AOAM531jM3xGTnKgOLYYt9IlHKw70MCEYGa4NxPXOzADjNwMvXpDC+Yz
 okk0VolzryGkiEr8z968OuES4yh4aKyduZcLtyetyg==
X-Google-Smtp-Source: ABdhPJzFQyOYquuoESX4XOQLDO7KeqzUIFmH80rPEarCX1yhOlqPMUedzqTRB2d5Rbjpr1f1ORT7LJf9ZaqJRbE1oek=
X-Received: by 2002:a05:6808:485:: with SMTP id
 z5mr8796051oid.96.1638520175576; 
 Fri, 03 Dec 2021 00:29:35 -0800 (PST)
MIME-Version: 1.0
References: <20211202171048.26924-1-will@kernel.org>
 <20211202171048.26924-3-will@kernel.org>
In-Reply-To: <20211202171048.26924-3-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 3 Dec 2021 08:28:58 +0000
Message-ID: <CA+EHjTxDxufPykv3cWT5nEW3GkPeu5x6JV3fRAsyojHrhVrv=Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Generate hyp_constants.h for the host
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Will,

On Thu, Dec 2, 2021 at 5:11 PM Will Deacon <will@kernel.org> wrote:
>
> In order to avoid exposing hypervisor (EL2) data structures directly to
> the host, generate hyp_constants.h to provide constants such as structure
> sizes to the host without dragging in the definitions themselves.

That's some fine kbuild wizardry right there! :)

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/.gitignore          |  2 ++
>  arch/arm64/kvm/Makefile            | 16 ++++++++++++++++
>  arch/arm64/kvm/hyp/hyp-constants.c | 10 ++++++++++
>  3 files changed, 28 insertions(+)
>  create mode 100644 arch/arm64/kvm/.gitignore
>  create mode 100644 arch/arm64/kvm/hyp/hyp-constants.c
>
> diff --git a/arch/arm64/kvm/.gitignore b/arch/arm64/kvm/.gitignore
> new file mode 100644
> index 000000000000..6182aefb8302
> --- /dev/null
> +++ b/arch/arm64/kvm/.gitignore
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +hyp_constants.h
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 989bb5dad2c8..0b561752f8d8 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -25,3 +25,19 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>          vgic/vgic-its.o vgic/vgic-debug.o
>
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
> +
> +always-y := hyp_constants.h hyp-constants.s
> +
> +define rule_gen_hyp_constants
> +       $(call filechk,offsets,__HYP_CONSTANTS_H__)
> +endef
> +
> +CFLAGS_hyp-constants.o = -I $(srctree)/$(src)/hyp/include
> +$(obj)/hyp-constants.s: $(src)/hyp/hyp-constants.c FORCE
> +       $(call if_changed_dep,cc_s_c)
> +
> +$(obj)/hyp_constants.h: $(obj)/hyp-constants.s FORCE
> +       $(call if_changed_rule,gen_hyp_constants)
> +
> +obj-kvm := $(addprefix $(obj)/, $(kvm-y))
> +$(obj-kvm): $(obj)/hyp_constants.h
> diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
> new file mode 100644
> index 000000000000..b3742a6691e8
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/hyp-constants.c
> @@ -0,0 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/kbuild.h>
> +#include <nvhe/memory.h>
> +
> +int main(void)
> +{
> +       DEFINE(STRUCT_HYP_PAGE_SIZE,    sizeof(struct hyp_page));
> +       return 0;
> +}
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
