Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36BEC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 04:42:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00C8943479;
	Tue, 22 Mar 2022 00:42:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1M59alQlKNE6; Tue, 22 Mar 2022 00:41:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA83C49ED8;
	Tue, 22 Mar 2022 00:41:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 455A949ED6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 00:41:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vo3orccUz0eO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 00:41:56 -0400 (EDT)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2895B43479
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 00:41:56 -0400 (EDT)
Received: by mail-pj1-f45.google.com with SMTP id
 mm17-20020a17090b359100b001c6da62a559so1385685pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 21:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=I30fMtOFrftRRp+ZK8GvM5pRdzD/fkbHxTk7j1WjRNU=;
 b=U6GwH72H5Gth87PY0906tE1wnf+Z+7E4ybKfeq6vtJry2Bs4Ml3VrJdPDd4aGlhpIe
 0wQbFHzDGdg5UIo+9SkGPfwd8fqzDsNgSuRtGbhHa+l5g49SGtFxrqI6Mfn+FTNPhCDF
 JhrD1h2yojsa9gwk1D2N0r/r67BJIc6pymK4haewk8lHLOjD4CykZ+DunoelIQhkDeuT
 eKxgoqRTSfF4Kse8e20k7BEq8XHvNbZQXBzogtYOGqBQpqlJGn0J5V/wVd70kb8YCh5v
 4l9dHMHSbX5qyH0wCY/4QUOYt1U1Tw6atyohBgT4r5dbpUdlsfReDzrGVLTJvaTQ5w8/
 4s2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=I30fMtOFrftRRp+ZK8GvM5pRdzD/fkbHxTk7j1WjRNU=;
 b=ZZZVuigr1Fioi5Y/vemNV+Gubkk69WFfBjQ3tBpWSxRMauVoqxZQlCBIOqSLDinNxr
 UBeiztu5QQtcRLBAHXGr0kzCMClv689PrBPdsQGwGmJCC6T3kOs33xRvWy8cOAG2OvYp
 xgdXuiUr+QAelKKgWB4YDU/Fwiz4lbB3XNuMqld5KWa5k5HBeh02qAw9PXgMXbsmd30F
 ykflbFzr4KDbdvDze8DjQOO4OWS7qL3AXELXwfTvgKx5IJw977QQ4QmgqL8VHNC4CNdt
 IAPwOfZNUMIBGjS6sbi6SguOqggwcGC1NmCFnRz25aXofc4OK8mzRKMtcHMnyNL6Pt+d
 XZwQ==
X-Gm-Message-State: AOAM532YgjusC47/IYOvP8uwa7HoSgnJsqbEmSog3HU+l0DM3KAQmghI
 NUIwE1GPlnd5OaXczLbj6oV+oHk+8aOd4JJphDFSYg==
X-Google-Smtp-Source: ABdhPJyGjOgv68/pB4ZQ6ie/RkmNrofIEy9Np05CrErKIjvd8UHlcfRLPU14yC2Z5KMc1SrLQK+oaTiM1zXYrATE5Ec=
X-Received: by 2002:a17:90b:1a8a:b0:1c5:f707:93a6 with SMTP id
 ng10-20020a17090b1a8a00b001c5f70793a6mr2804463pjb.110.1647924115093; Mon, 21
 Mar 2022 21:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220318193831.482349-1-oupton@google.com>
 <20220318193831.482349-3-oupton@google.com>
In-Reply-To: <20220318193831.482349-3-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 21 Mar 2022 21:41:39 -0700
Message-ID: <CAAeT=FwR-=U_0WvKqV4UTCmo8x1=atBVtTQeirwiF3XCo+S=1g@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from
 AArch32
To: Oliver Upton <oupton@google.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On 3/18/22 12:38 PM, Oliver Upton wrote:
> The SMCCC does not allow the SMC64 calling convention to be used from
> AArch32. While KVM checks to see if the calling convention is allowed in
> PSCI_1_0_FN_PSCI_FEATURES, it does not actually prevent calls to
> unadvertised PSCI v1.0+ functions.
>
> Check to see if the requested function is allowed from the guest's
> execution state. Deny the call if it is not.
>
> Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

BTW, considering the new kvm_psci_check_allowed_function()implementation
in the patch-1, it might be better to call kvm_psci_check_allowed_function()
from kvm_psci_call() instead?  Then, we could avoid the similar issue
next time we support a newer PSCI version.

Thanks,
Reiji


> ---
>   arch/arm64/kvm/psci.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index cd3ee947485f..0d771468b708 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -318,6 +318,10 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
>       if (minor > 1)
>               return -EINVAL;
>
> +     val = kvm_psci_check_allowed_function(vcpu, psci_fn);
> +     if (val)
> +             goto out;
> +
>       switch(psci_fn) {
>       case PSCI_0_2_FN_PSCI_VERSION:
>               val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
> @@ -378,6 +382,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
>               return kvm_psci_0_2_call(vcpu);
>       }
>
> +out:
>       smccc_set_retval(vcpu, val, 0, 0, 0);
>       return ret;
>   }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
