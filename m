Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9B6C43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 13:59:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C96A4BEBE;
	Fri, 15 Jul 2022 09:59:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3By8hbTBd8VN; Fri, 15 Jul 2022 09:59:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C4D4BEC0;
	Fri, 15 Jul 2022 09:59:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF27B4BE90
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sHtBJLrI3h46 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 09:59:43 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF1984BD62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:43 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 a14-20020a0568300b8e00b0061c4e3eb52aso3548560otv.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=fRcx9c8UdpURDQJn1/FwxxpqDetYYI9ywH8GAGTFS+U=;
 b=gtFC5Oqg8xhzmhUgw0Irrwnhki0tPLqR9BejFwaaiBIjCPhOyRnjtS0e/MhDRfvZEp
 pWel7RCg+ldSNukr8AXo5gUxGdJGqejdOeYCBnTemXJsM828rHl1BfwxibWOg0SgIM4D
 KzDI4U/R6UvCdvJv8YmLFWyV/HrlFGdyyY7fQd0SOPwxGRo6qbvVI13JDTwNIoQZJkZr
 HUDMJEx7i7BccgEhBdezfzh9+7tdqzh8Mq8osrTCIPKgvnS41lJ5iDKNdySTfLjTEerZ
 ic+pFPpwJ9narc2AT3FePEMX3fX7rV4px3LxHsqAQuJ5gmH+Khb0JG3UtMsx7bHEtq9b
 P8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=fRcx9c8UdpURDQJn1/FwxxpqDetYYI9ywH8GAGTFS+U=;
 b=3DNtFBkBfcMYgvIUxNFPTEL9qjXVeWxTNmGOIX1Ogr6e0cewMr//NzXrN6tE4dzzKW
 2kRgmF5AIltI8tAJ2wGI3TeiEZDGqWdFG/7FPIlgyEChUPiMAOkAKfkq0dWmUVTcELzO
 X+msR8DFbaQNUeB+C7z8kWe8DgiwMYOl3GB5f++aFWRt4rMHh6MsOtE1KaHWA6JK/6UD
 0l6g5SV8pzcMnwzXbZGVclYtJH5S64Ccrg5DJEVlwPNnwsAKUbzF+P161AhsQw7Ja0tY
 MNmQSLHALXqosyKkgHpqLUWfStSi03aix/nF6M+QSb5ohpXNcPFd15MM8VkgOt8MyFAT
 rKKQ==
X-Gm-Message-State: AJIora/uAiXkIRbpGdb+QyG6doAU4uC4qAU2NwS21j5ufQCjaHC2TcWZ
 PZp13QR1UYDcHAiDEu/oc6tNSZZmuYZ4ZMYsNsnWug==
X-Google-Smtp-Source: AGRyM1vHO/STc1Sj/3EukFJjIixl6baJ3J0IcXnUJe8IzBWtptFSN2Sx5Bh1wsfvM0lhDyfQSxknYauFRHkVPPk85tk=
X-Received: by 2002:a9d:873:0:b0:61c:3f57:39e2 with SMTP id
 106-20020a9d0873000000b0061c3f5739e2mr5396066oty.299.1657893582980; Fri, 15
 Jul 2022 06:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-7-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-7-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Jul 2022 14:59:07 +0100
Message-ID: <CA+EHjTx-yqnkikhsvBdJMPOOyZK+yTeFpZxmQ=u57oezy4KQFg@mail.gmail.com>
Subject: Re: [PATCH v4 06/18] arm64: stacktrace: Add description of
 stacktrace/common.h
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 android-mm@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 madvenka@linux.microsoft.com, andreyknvl@gmail.com, kernel-team@android.com,
 drjones@redhat.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 russell.king@oracle.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

On Fri, Jul 15, 2022 at 7:11 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Add brief description on how to use stacktrace/common.h to implement
> a stack unwinder.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  arch/arm64/include/asm/stacktrace/common.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index f86efe71479d..b362086f4c70 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -2,6 +2,14 @@
>  /*
>   * Common arm64 stack unwinder code.
>   *
> + * To implement a new arm64 stack unwinder:
> + *     1) Include this header
> + *
> + *     2) Provide implementations for the following functions:
> + *            - on_overflow_stack()
> + *            - on_accessible_stack()
> + *            - unwind_next()
> + *
>   * Copyright (C) 2012 ARM Ltd.
>   */
>  #ifndef __ASM_STACKTRACE_COMMON_H
> --

Ideally it would be nice to have a description of what these functions
are expected to do, but that said,

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
