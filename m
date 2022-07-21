Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BADBC43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:58:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3C564C8FD;
	Thu, 21 Jul 2022 05:58:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A38DlOKM8cKj; Thu, 21 Jul 2022 05:58:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 635734C901;
	Thu, 21 Jul 2022 05:58:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 554A34C8FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k+9qVSHh3bCv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:58:13 -0400 (EDT)
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com
 [209.85.160.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D7AC4C8F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:13 -0400 (EDT)
Received: by mail-oa1-f43.google.com with SMTP id
 586e51a60fabf-10bd4812c29so1655136fac.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sB5+VFg26y53vqC/8MRmL6RVPSMPo+AiiM8Gm3tkc5I=;
 b=DpM33J/meqDpm/cC0Fst4MfLsktLCbHt60MbQA7Ft0z/s315GwSGwjCSkhbqSMdmmY
 CeUnaja1sQhfgPKcSU/Lk9M6cPdAsmvAv5tnXbpO085Oqw6Qe1mDTFJxYDzuzkJFczYJ
 TA40gFokhgf7/+q0gbQ4RYD5ac/0wTBaXypFKkJRhOULDcM3IBEHi1zF01rrBQCtOUyC
 7IpgpmZkUDiPGvXFYFUN80kMKMT1Fxsx+KH6WO/niHoWVAMqhu1mzuQ4pXP2kmxjdp/F
 hXfdqEsqPIHbeNuxzy5v79CGC8h44k8BGCQx36AFeagdG3v7aM945fsCFNA9uavNztfE
 IQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sB5+VFg26y53vqC/8MRmL6RVPSMPo+AiiM8Gm3tkc5I=;
 b=BZCw5mE0XiOMbLOM/CpY/4tJv1j1tJlSNl3ffLx97EA/Rnv1mBHvMIlyazPZ3Y0JEb
 nEw7shixlSjTqR9D8ZDMhOPHTfXquFBHDm6nLm1FBVD2TiBY3Pd4THhxPOmn8Eezm4nZ
 3Sd2SPu0kcq1skO6wXiWtXcQKezQOKXQWUi8aobk9NfkO2idYHzW2lbDVukkvVOKDuCh
 ulu6RuYh3LfE5/xO0pTbd0/8esltrr28ao9rV4AESNyxxKRH1rWr4mLgP0K67WyuH6YT
 BChYE2DqF8gresM63Rv1+TCtUWUPUEcfr6ibJawxQ4lR2T28VADPccmCL+GGAT11E+Xe
 nIPg==
X-Gm-Message-State: AJIora/mqHxnMAfQZrow+ZNCtYwTB9E9Ys2xjRskGVvuPUJkO/xVhJho
 Xnla0NCyhPVTGNCYLvnHdPMn+oAXGRMvhTQAdK+bTQ==
X-Google-Smtp-Source: AGRyM1v17gff8o19t6yFCbZorc8LVOpXY1I3uCydpXbcgQefIXMnlFa8G4NkPgmWCDlzsSNE/lKD4q6x7q+LckMFFkU=
X-Received: by 2002:a05:6870:2303:b0:10c:2ed1:6326 with SMTP id
 w3-20020a056870230300b0010c2ed16326mr4422385oao.146.1658397492622; Thu, 21
 Jul 2022 02:58:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-7-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-7-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:57:36 +0100
Message-ID: <CA+EHjTxqNOU9cjA1Gnur9wp4W4nt9ZXC+y6N9HCEzf4BmPc60w@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] arm64: stacktrace: Add description of
 stacktrace/common.h
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
> Add brief description on how to use stacktrace/common.h to implement
> a stack unwinder.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>
> Changes in v5:
>   - Add short description of each required function, per Fuad and Marc
>   - Add Reviewed-by tag from Fuad

Actually it's missing :)

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
>  arch/arm64/include/asm/stacktrace/common.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index 7807752aaab1..be7920ba70b0 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -2,6 +2,21 @@
>  /*
>   * Common arm64 stack unwinder code.
>   *
> + * To implement a new arm64 stack unwinder:
> + *     1) Include this header
> + *
> + *     2) Provide implementations for the following functions:
> + *          on_overflow_stack():   Returns true if SP is on the overflow
> + *                                 stack.
> + *          on_accessible_stack(): Returns true is SP is on any accessible
> + *                                 stack.
> + *          unwind_next():         Performs validation checks on the frame
> + *                                 pointer, and transitions unwind_state
> + *                                 to the next frame.
> + *
> + *         See: arch/arm64/include/asm/stacktrace.h for reference
> + *              implementations.
> + *
>   * Copyright (C) 2012 ARM Ltd.
>   */
>  #ifndef __ASM_STACKTRACE_COMMON_H
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
