Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F640C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:58:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0FFA4C8FF;
	Thu, 21 Jul 2022 05:58:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2kAo5Lsr-XPB; Thu, 21 Jul 2022 05:58:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B5D24C901;
	Thu, 21 Jul 2022 05:58:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5694C4C90E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BOqfrU5ey927 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:58:21 -0400 (EDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com
 [209.85.210.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 398354C8FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:21 -0400 (EDT)
Received: by mail-ot1-f42.google.com with SMTP id
 z12-20020a056830128c00b0061c8168d3faso754497otp.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=w1cw8n2s++yGrcoRACgo1RACYLLvGocB0lSZfMf+v5k=;
 b=GAiOHo1VRSqtmwOO5seALkjK17Xl0J2NPoHCbEV3V07AP4Q2diSeRtvxSgavPHZl2O
 8NkgO9GuJGz5vkg6RGY5AX0645gxSAAi0+fNRbfT4mSLeoi0cOBpH/pHgmmtcUCsLIwk
 5EFuw/QBuJxkhjgWqt08kwIN/JVUy/1J1zRTpEaOWGHnkZpmjeMafnxpAGL6hdwz0EkV
 6lsSAmvB0GJYnA/+1nqw8/SUbEZNTOtnhzSW4jP3lFvH/ZfvGFDFxlKXzdN2trkCQlH2
 CXdK/0a/22SEDyIMh/oa5dmVfs6B0HrwGLiXw5Z/Ro4cSU1Wwirr+HjCB9lamCBoOZHk
 udqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=w1cw8n2s++yGrcoRACgo1RACYLLvGocB0lSZfMf+v5k=;
 b=bWZle23L8t4LLMZmjuNllwIbQabuiRoy87AOA2tAYmyEcPU6VA/VCkndM51hZO8yzz
 ak9mG6qX30CZgKz7wYti/BAQaYM4o9M8HCfDhTxByzSmvcerHBkELv8oLunxRI8bQHW+
 KiXNTCAEKQSpfAQX3QNG14/7DyKWPBWqcnm0F1RAws+OtF3+M+BkMczhwmGnD+5u5nZn
 O6XrfNnrbViuHVBB+j+Sl0anXO55LAwgHQR+cg5uB/BlG3jrGxyrIkpTRjzraCLWXmaZ
 Gg/+kC1iBkTQRgrmK07AzEwURTRl+2QSCDgq5j6XA4YgTn1rH0jKoosUANNNkSZAV8MM
 1hzw==
X-Gm-Message-State: AJIora/ChZ5FsctNPr8X4yRSA4Q6G+72N2I2y+WM/sbdsGTrcSH3kbZV
 wNmWPzY84Q9XKHI5k3g1wZJVY5g+me202o828Eis8Q==
X-Google-Smtp-Source: AGRyM1v2hPhTASw+wF+XVDBlk1CI1nNorxhP4r6p0nuR1mYXYF4mAP3CWBqFwNTgIpR5+p7wQj950bEmAKkn/BHUbRU=
X-Received: by 2002:a9d:5f1a:0:b0:61c:50a1:df3 with SMTP id
 f26-20020a9d5f1a000000b0061c50a10df3mr16441497oti.102.1658397500469; Thu, 21
 Jul 2022 02:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-9-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-9-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:57:44 +0100
Message-ID: <CA+EHjTxtwjf3dMhrBFa0iTMPayV0V0dM-z_Gk_hSQn_hr4zYow@mail.gmail.com>
Subject: Re: [PATCH v5 08/17] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, madvenka@linux.microsoft.com, kernel-team@android.com,
 elver@google.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 andreyknvl@gmail.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Hi Kalesh,

On Thu, Jul 21, 2022 at 6:57 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> This can be used to disable stacktrace for the protected KVM
> nVHE hypervisor, in order to save on the associated memory usage.
>
> This option is disabled by default, since protected KVM is not widely
> used on platforms other than Android currently.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Just wanted to point out that I have specifically tested this as well,
enabling PROTECTED_NVHE_STACKTRACE but not NVHE_EL2_DEBUG. Works as
expected.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> Changes in v5:
>   - Make PROTECTED_NVHE_STACKTRACE depend on NVHE_EL2_DEBUG, per Marc
>
>  arch/arm64/kvm/Kconfig | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 8a5fbbf084df..09c995869916 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -46,6 +46,21 @@ menuconfig KVM
>
>           If unsure, say N.
>
> +config PROTECTED_NVHE_STACKTRACE
> +       bool "Protected KVM hypervisor stacktraces"
> +       depends on NVHE_EL2_DEBUG
> +       default n
> +       help
> +         Say Y here to enable pKVM hypervisor stacktraces on hyp_panic()
> +
> +         If you are not using protected nVHE (pKVM), say N.
> +
> +         If using protected nVHE mode, but cannot afford the associated
> +         memory cost (less than 0.75 page per CPU) of pKVM stacktraces,
> +         say N.
> +
> +         If unsure, say N.
> +
>  config NVHE_EL2_DEBUG
>         bool "Debug mode for non-VHE EL2 object"
>         depends on KVM
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
