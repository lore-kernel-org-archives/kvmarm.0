Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490FFC2BBE2
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 14:08:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B91D0206DF
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 14:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AJJM92St"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B91D0206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9180B4AF42;
	Fri,  6 Dec 2019 09:08:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 79sN8h+OcZ+n; Fri,  6 Dec 2019 09:08:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B60D4AF00;
	Fri,  6 Dec 2019 09:08:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2654AF00
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 09:08:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hFbifAZKxhOm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 09:08:17 -0500 (EST)
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com
 [209.85.210.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71B1A4AE8D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 09:08:17 -0500 (EST)
Received: by mail-ot1-f68.google.com with SMTP id 59so5837768otp.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Dec 2019 06:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Z4sjm9mq9FY1JBwtvKmdYT9ZZ3hKV67Tyf1BR1lTeOw=;
 b=AJJM92Stp3S2lj/sjdyQGY67jSbm4ayYNuhm+4rMSqhS+SxxZ0jVZBd+msHmLexoOt
 aCb+ZxRMrv7QDsxMWKNRjwQUvO38T7acJV9hrbLlqVCPnQJ1OWej+5QVtfYFWGfJRWEJ
 6LVkRgNX76UARx7ldyaLVcKW8Fndqx6MI46tBRF1v1IC7AW9v4TBVgJp/ppWUB9H/Soc
 eqFugjPqzJuyI0uPwlRbWIQZDbuJDYf0mPoAKH/ij+wthkjaYHWL/PvyLPoHvc9wln0A
 7Rg76dLYORAX2AeWENSIp+Qntw7/U4voMoQhPyean5OjozqURNsvUwmU2ic3F8eW+uvF
 qB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Z4sjm9mq9FY1JBwtvKmdYT9ZZ3hKV67Tyf1BR1lTeOw=;
 b=DDx/o1/BC0XVheS8www4zD/IgglC+k0BD9saeK48pubKPTKsUSvSyzhG5MOoA/3Cv0
 ziHoNVF5Pi/DaV3nJkxcWhblBlh72i88DQEpkxK7sTQaqIDMFQ4aXWBYZuhuWb2vVHaM
 KTh9l3909uqzDqd3pNIa2LEWznMMK0fFpQ9r1qLsGoiDNZFsEz7z/rZv4txFNW9a/MIB
 vNl0FFMQGG3wAbljfTcUfvUEGlHVb5Ui42wFXj2d7ZRs0mCQHpm6L6PvhKNMOiNW7Llq
 eJBB2kvsGjaygmPHLyfv9M7pOy79r4CpL9T3HR9TlDq2HZjZARY3WEZq6/Glknze1IXI
 t2rw==
X-Gm-Message-State: APjAAAXQWZvM5cTpFBTpl5DaoPWYoCHaJ9kVtop22A8vswWGG6UCSyqh
 w+LOT00pW1gDz+ySs9T3e0chisOKYrm/XpDNnxGJ2A==
X-Google-Smtp-Source: APXvYqzrntCeRcECAGynjuKrNAr6W6c2Hv0/aLo/VBA8L6c6DdqsRKy6xQLvd3B8HvJ18ed7kqpkT04yFIhqFwu9zqY=
X-Received: by 2002:a05:6830:13d3:: with SMTP id
 e19mr11191067otq.135.1575641296875; 
 Fri, 06 Dec 2019 06:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-4-maz@kernel.org>
In-Reply-To: <20191201122018.25808-4-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 6 Dec 2019 14:08:06 +0000
Message-ID: <CAFEAcA_YGBXY4X5KYE_xny1bYtP1fKefT+VubmNYbe8TxdwBOw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
To: Marc Zyngier <maz@kernel.org>
Cc: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

On Sun, 1 Dec 2019 at 12:20, Marc Zyngier <maz@kernel.org> wrote:
>
> HCR_EL2.TID3 requires that AArch32 reads of MVFR[012] are trapped to
> EL2, and HCR_EL2.TID0 does the same for reads of FPSID.
> In order to handle this, introduce a new TCG helper function that
> checks for these control bits before executing the VMRC instruction.
>
> Tested with a hacked-up version of KVM/arm64 that sets the control
> bits for 32bit guests.
>
> Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper-a64.h        |  2 ++
>  target/arm/translate-vfp.inc.c | 18 +++++++++++++++---
>  target/arm/vfp_helper.c        | 29 +++++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+), 3 deletions(-)
>
> diff --git a/target/arm/helper-a64.h b/target/arm/helper-a64.h
> index a915c1247f..0af44dc814 100644
> --- a/target/arm/helper-a64.h
> +++ b/target/arm/helper-a64.h
> @@ -102,3 +102,5 @@ DEF_HELPER_FLAGS_3(autda, TCG_CALL_NO_WG, i64, env, i64, i64)
>  DEF_HELPER_FLAGS_3(autdb, TCG_CALL_NO_WG, i64, env, i64, i64)
>  DEF_HELPER_FLAGS_2(xpaci, TCG_CALL_NO_RWG_SE, i64, env, i64)
>  DEF_HELPER_FLAGS_2(xpacd, TCG_CALL_NO_RWG_SE, i64, env, i64)
> +
> +DEF_HELPER_3(check_hcr_el2_trap, void, env, i32, i32)

This has to be in helper.h, not helper-a64.h, otherwise
the arm-softmmu target won't build. helper-a64.h is for
helper functions which only exist in the aarch64 binary.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
