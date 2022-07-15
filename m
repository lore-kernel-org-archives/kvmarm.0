Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C10C43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 13:59:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A71A64BC91;
	Fri, 15 Jul 2022 09:59:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8dZX9wW04wvJ; Fri, 15 Jul 2022 09:59:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B2754BEAC;
	Fri, 15 Jul 2022 09:59:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0964BC91
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1hxZoZV9QVFG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 09:59:10 -0400 (EDT)
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com
 [209.85.167.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 739BE4BEAD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:10 -0400 (EDT)
Received: by mail-oi1-f172.google.com with SMTP id j3so6141346oif.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FedCUjPaYWeA+erxDCoGCFWQ2IqT52osu7P0qCTsADw=;
 b=SfQLh5uuHMjqqGyxSvxqidpbRlKx2pbwugGUmYScb6znMBdlPl2TKCBAp4vdj16oT7
 wdac5LHirOZciCIyUnKx2JrrOLEzhewDvj+q2kGR5iu8pMh9s3ru88w2C6EsGNmtTHAj
 gV7PPytMXS5+9ZkeGzhbxb2WLZuw13rdJj85CPBa5Xq1dKXG+vvXoq57dWCnIpCuGrAN
 JMTz6EL+56pkYNzfnzlVs+Gh26RtJpMA9BiMei3ELFO43jzq0uoQScorY1jUnZcKnM7E
 51uyUv5MDDsybzgJGw3jQjQF9niyKnv3fG3qmmXgkjzjF3J1nObJQW0ESxaddGHdjvhB
 GJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FedCUjPaYWeA+erxDCoGCFWQ2IqT52osu7P0qCTsADw=;
 b=FkqaV69I2RMGt/jH0Tc5axdp1sshVzQyt6L+vTUvWBK3IBGNWYZKlwK8zlwQeaRwen
 n6I5Uh2i5RS6AlSqk5UzurGxYzU+4T9a2BxOXeq7UIrkcAqfET6uRmO010Y2+r1Icwb/
 Z+kItjWJ6zDHV8KaKcgiaP2sTUvjAaz7sWZH3pfZ3n1f9kGApU6kjNDIUF4KWkSSzY+c
 0xXZOYocNIBi1TgTHqXfm5VPXnxghEaQU6JxzyEOisZK7V9SpVKo0lhh2DjjmGOXgaoD
 tkLWBEglgRphoOSTvWO5Q45ZbNzmtQA558CRnPNs72KzGrTjUCITLsvjxnD1snm+Pag/
 Ox0Q==
X-Gm-Message-State: AJIora/vK5uSCa+whbEpXMSRoHipGlzK1KvV1uxBWRLcRERctMXqii8X
 7njsv/3+R4SJGPnSMHMsan2AcQyETZzwsxLtycWjmw==
X-Google-Smtp-Source: AGRyM1sYJ9tUCJtAOpcRqsqhX74xUJZqwlSchSlNVe5+PXo4VKC+9LCHOatk8tOc3ga/R2H/Z3Mg9Q/uYeEhouETn98=
X-Received: by 2002:a05:6808:1596:b0:337:8c17:b17f with SMTP id
 t22-20020a056808159600b003378c17b17fmr7434645oiw.294.1657893549609; Fri, 15
 Jul 2022 06:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-3-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-3-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Jul 2022 14:58:33 +0100
Message-ID: <CA+EHjTxpYgEYX4MRAYAVyptPZa6jUV2b_c_E4kLEMRcj6jsLUQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/18] arm64: stacktrace: Factor out
 on_accessible_stack_common()
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

On Fri, Jul 15, 2022 at 7:10 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Move common on_accessible_stack checks to stacktrace/common.h. This is
> used in the implementation of the nVHE hypervisor unwinder later in
> this series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


>  arch/arm64/include/asm/stacktrace.h        |  8 ++------
>  arch/arm64/include/asm/stacktrace/common.h | 18 ++++++++++++++++++
>  2 files changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index 79f455b37c84..a4f8b84fb459 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -56,7 +56,6 @@ static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
>                         struct stack_info *info) { return false; }
>  #endif
>
> -
>  /*
>   * We can only safely access per-cpu stacks from current in a non-preemptible
>   * context.
> @@ -65,8 +64,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
>                                        unsigned long sp, unsigned long size,
>                                        struct stack_info *info)
>  {
> -       if (info)
> -               info->type = STACK_TYPE_UNKNOWN;
> +       if (on_accessible_stack_common(tsk, sp, size, info))
> +               return true;
>
>         if (on_task_stack(tsk, sp, size, info))
>                 return true;
> @@ -74,12 +73,9 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
>                 return false;
>         if (on_irq_stack(sp, size, info))
>                 return true;
> -       if (on_overflow_stack(sp, size, info))
> -               return true;
>         if (on_sdei_stack(sp, size, info))
>                 return true;
>
>         return false;
>  }
> -
>  #endif /* __ASM_STACKTRACE_H */
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index 64ae4f6b06fe..f58b786460d3 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -62,6 +62,9 @@ struct unwind_state {
>         struct task_struct *task;
>  };
>
> +static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
> +                                    struct stack_info *info);
> +
>  static inline bool on_stack(unsigned long sp, unsigned long size,
>                             unsigned long low, unsigned long high,
>                             enum stack_type type, struct stack_info *info)
> @@ -80,6 +83,21 @@ static inline bool on_stack(unsigned long sp, unsigned long size,
>         return true;
>  }
>
> +static inline bool on_accessible_stack_common(const struct task_struct *tsk,
> +                                             unsigned long sp,
> +                                             unsigned long size,
> +                                             struct stack_info *info)
> +{
> +       if (info)
> +               info->type = STACK_TYPE_UNKNOWN;
> +
> +       /*
> +        * Both the kernel and nvhe hypervisor make use of
> +        * an overflow_stack
> +        */
> +       return on_overflow_stack(sp, size, info);
> +}
> +
>  static inline void unwind_init_common(struct unwind_state *state,
>                                       struct task_struct *task)
>  {
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
