Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F9DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 09:46:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF03749DF6;
	Tue, 10 May 2022 05:46:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6QLKT0xJuh7H; Tue, 10 May 2022 05:46:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4FFE49F3E;
	Tue, 10 May 2022 05:46:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D12449ED2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:46:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p85llp+hlfOL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 05:46:07 -0400 (EDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEBF449DF6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:46:07 -0400 (EDT)
Received: by mail-oi1-f176.google.com with SMTP id v66so17945864oib.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=o39NrF3LSVHYlVpwQr3bgKqf/zDQFHhHc4PtC81jizY=;
 b=SfCXjLw/VznGk6AzMLnh7lqE+0bjdTxIsbqedkWfVZqnAVpZe04Rtg0cAPR5Lm0vOw
 a1kDK6R6UBoc+F5Yl3KfbXmwnV6Cs4sXZNlaUnx1/SMPTpAyZQkLkF/c9D8aBrv01Iah
 tvG1ziIqkAHUJiTdG/zyHnWJUmkIImU8U2SPnPtDhy2YyWpsswc1M9nnhnmZ18vN+sZE
 jt7q/yvmNghXEQD0vNgIaZ2okgFiFQ1cF/kdeFLmaU8QY94W+1SMIvm9Jlxq+fbwdn2v
 P2tJNjrzzSCEvw3d1vtCJUmt5N51xAAbG3jSDRoljFkTgx8V7lFNvSPxaRxk90AGZSLH
 ZhNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=o39NrF3LSVHYlVpwQr3bgKqf/zDQFHhHc4PtC81jizY=;
 b=oL7eB5Tq3E9dUE50MrP83HeY+HOARaXR7aierpbG4iuDAGh/ZzlRHFWU6LOa+9P02k
 eVtIuzulhoLNgrmltnXd97+QIXxLPaa6xlhkWzLfjAT1afAjIbhviIqrzASdC1oNZxjY
 7IxWXYQEujqre/YPg4k4xT8mWFefrqKLxbOQ+piZxV9WtfYxUoAQi50GaFVNdQNyxkg6
 C33HgBMQ87hztzXO5ZXENCjWvOjtY7iFUr0GOk53H3AZnudPhGpfOIYQYUSudaMFKDES
 fO2JB0rI+FUJmcf3MJlrUBgClPIYsk3gdOru1UzZEbVDXoe7vjTeJI7YtopwkMBdjdvi
 5Fng==
X-Gm-Message-State: AOAM5311O686/tFlUpqYjUBmG8nbkimktPGSdpv00Ob7QlO2BNfKU+mV
 +lvYgT+8AZQOJDewZrzsQYAwRJO2QVuwaDqvPfRMdw==
X-Google-Smtp-Source: ABdhPJwLwLi6HfB/M1LmfOIjn+TH5lqS8GI3HaBOG4okjrcTmcuCVhyHfe6tbTsbpvj2w6SW3d8BLPBFZfrHl3Rc9Qo=
X-Received: by 2002:aca:180b:0:b0:2f7:23ae:8cd1 with SMTP id
 h11-20020aca180b000000b002f723ae8cd1mr13435377oih.146.1652175966977; Tue, 10
 May 2022 02:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220509162559.2387784-1-oupton@google.com>
 <20220509162559.2387784-3-oupton@google.com>
In-Reply-To: <20220509162559.2387784-3-oupton@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 May 2022 10:45:30 +0100
Message-ID: <CA+EHjTztV9ZN4sQyS8BGxuROw4NY873LXve8LPjo417Ao6y4aQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Oliver,


On Mon, May 9, 2022 at 5:26 PM Oliver Upton <oupton@google.com> wrote:
>
> FEAT_SVE is already masked by the fixed configuration for
> ID_AA64PFR0_EL1; don't try and mask it at runtime.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 33f5181af330..3f5d7bd171c5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -90,9 +90,6 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
>         u64 set_mask = 0;
>         u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
>
> -       if (!vcpu_has_sve(vcpu))
> -               allow_mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> -
>         set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
>                 PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
>
> --
> 2.36.0.512.ge40c2bad7a-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
