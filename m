Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36796C19F2B
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 15:56:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D674C900;
	Wed, 27 Jul 2022 11:56:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wPnrXSd+QkyI; Wed, 27 Jul 2022 11:56:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F3484C8F5;
	Wed, 27 Jul 2022 11:56:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5D4E4C8D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 11:56:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pLduBmB8Dlly for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 11:56:50 -0400 (EDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F3924C7F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 11:56:50 -0400 (EDT)
Received: by mail-wr1-f54.google.com with SMTP id j7so3162241wrh.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 08:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=R+iHvXmGgVaJk0aTh2lYJmpaG/4QQy4FTMp2abmiQFI=;
 b=ou6drcieFoAL/2jVRHRvVPeGXUiZrIcxmlxj02X4BKD5PU9TSwkz5pldwQqFmKeq28
 eSpeM8YdOdCwYCYQjPbCBCiULep9PWCMgm2bEKsLlP0o7m4kRO1BT5H3HWDmuBLBbrah
 UP1y2wk3TbO9ap4H0rQtVvsxiyvc87i5GehoQAkgmH+l9YSRdFLM2BaaI9PmitoBT+x4
 9ihGde66eQDgfwbdvT7Jgiv86rHIPRC7VXlvzS3w4ZD6nCUgj+OkmDNirdiX8a0+11tq
 PrL2RL7QVhmD/hi/cVS09E78jmRv/Zl/dQ12esYwyhLqT7+0jnanJx2d2cZTKB5ClqMT
 W1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=R+iHvXmGgVaJk0aTh2lYJmpaG/4QQy4FTMp2abmiQFI=;
 b=UbYbtEzbmqj3xtDd5tC4pZa/GKO3seNxG0ZHc+PWXgCQKNZ3fUO2fIq33QcIe2Mmdz
 eUx61j8Br5BYS9QGVGJGqDBRUu7e2/nOkzEIX3On/mJITqsHcfrOoKhWSmBrVv1zU6Ay
 sZ09EFwelL0F1rnp+WxrxLPLzKCyS0CBz6Z3MVObV1dB4tmRygBIeNZA+9OK+cNeSOuz
 C/MMG4iI++RF65gpFwxiKmUja7o5h8M3Yu09KIcaX2mMrzLbuOizLTPfv4oPAaIdh9p5
 NgkcDfhe/A/LJBMPUMYA5zP103bu+VilcXq0MExGdTfamieufbzBOxmfghihGaIlnshC
 t4kQ==
X-Gm-Message-State: AJIora9Dj5x3tWvn0w4HhDNEo7Xjr2aV1gyVy4bsjtq5Z7TFB2VAHL1R
 bEvOFU1GKXMZuJiH3l0sUOSnTMI38H8UL+1XA/PJkA==
X-Google-Smtp-Source: AGRyM1stHHn7Piw8GeQ+7b5ehtj7eu1dtqVUc5aek0kwLB+Q7n1iOV/shAexJBJLvMhuZfljNNCjn5b56S32LIlqvvM=
X-Received: by 2002:a05:6000:508:b0:21d:4105:caf9 with SMTP id
 a8-20020a056000050800b0021d4105caf9mr15132968wrf.699.1658937408834; Wed, 27
 Jul 2022 08:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 27 Jul 2022 08:56:37 -0700
Message-ID: <CAC_TJvc6TPin-B-pQ7g-doMUUH5Eywo5GF5crGBmWoD=G2yBxA@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: arm64: nVHE stack unwinder rework
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 "Cc: Android Kernel" <kernel-team@android.com>, Marco Elver <elver@google.com>,
 Mark Brown <broonie@kernel.org>, andreyknvl@gmail.com,
 Masami Hiramatsu <mhiramat@kernel.org>
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

On Wed, Jul 27, 2022 at 7:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi all,
>
> As Kalesh's series[1] already went through quite a few rounds and that
> it has proved to be an extremely useful debugging help, I'd like to
> queue it for 5.20.
>
> However, there is a couple of nits that I'd like to address:
>
> - the code is extremely hard to follow, due to the include maze and
>   the various levels of inline functions that have forward
>   declarations...
>
> - there is a subtle bug in the way the kernel on_accessible_stack()
>   helper has been rewritten
>
> - the config symbol for the protected unwinder is oddly placed

Hi Marc,

Thanks for doing this rework.

For the series:
Reviewed-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: Kalesh Singh <kaleshsingh@google.com>

Thanks,
Kalesh

>
> Instead of going for another round and missing the merge window, I
> propose to stash the following patches on top, which IMHO result in
> something much more readable.
>
> This series directly applies on top of Kalesh's.
>
> [1] https://lore.kernel.org/r/20220726073750.3219117-1-kaleshsingh@google.com
>
> Marc Zyngier (5):
>   KVM: arm64: Move PROTECTED_NVHE_STACKTRACE around
>   KVM: arm64: Move nVHE stacktrace unwinding into its own compilation
>     unit
>   KVM: arm64: Make unwind()/on_accessible_stack() per-unwinder functions
>   KVM: arm64: Move nVHE-only helpers into kvm/stacktrace.c
>   arm64: Update 'unwinder howto'
>
> Oliver Upton (1):
>   KVM: arm64: Don't open code ARRAY_SIZE()
>
>  arch/arm64/include/asm/stacktrace.h        |  74 -------
>  arch/arm64/include/asm/stacktrace/common.h |  69 ++-----
>  arch/arm64/include/asm/stacktrace/nvhe.h   | 125 +-----------
>  arch/arm64/kernel/stacktrace.c             |  90 +++++++++
>  arch/arm64/kvm/Kconfig                     |  24 ++-
>  arch/arm64/kvm/Makefile                    |   2 +-
>  arch/arm64/kvm/handle_exit.c               |  98 ---------
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c       |  55 +++++-
>  arch/arm64/kvm/stacktrace.c                | 218 +++++++++++++++++++++
>  9 files changed, 394 insertions(+), 361 deletions(-)
>  create mode 100644 arch/arm64/kvm/stacktrace.c
>
> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
