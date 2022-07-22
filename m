Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BD3C43334
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 17:25:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A75FF4D1D4;
	Fri, 22 Jul 2022 13:25:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sXnphQSc50iO; Fri, 22 Jul 2022 13:25:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 908084D1D8;
	Fri, 22 Jul 2022 13:25:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E12564D1C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 13:25:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eDkqaTmN+mzR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2022 13:25:25 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE2D24D1C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 13:25:25 -0400 (EDT)
Received: by mail-wr1-f52.google.com with SMTP id u5so7421859wrm.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 10:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qo8WtVG4n0zTyMgzLgHF96/1qxYxV8ri3HK7ykqwnO8=;
 b=IK7V1IOiUtkzMNlZe+LF+whif65Ho4BnHQgQT5ZqfEnJBdOdhx+lcnsEqWnONdEIj5
 37zG5sDarPhLTl8WkWOedv9TArm8RDXVASNCbomlxOJZVtSYWcSdjX/2pK+YEaabocSO
 vHG5ODih6QIppMO3JhyTpBsN+rCbddhFRKimz/zgyqwR1EnLH1QxtEIvX5/kYonlKosk
 2BxCBvjDosLoJIIRjCMzRvruT384mua/wXVI+I2tkETcS4K8ZUtaZ57+L+go0dpvv1Pp
 L0WZjgtsSjEI/qBKh8D7LLxMRKJLuLObV4Ml3SUEGNA59aYtWV92hmkMEOFDlWPgM0w5
 34Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qo8WtVG4n0zTyMgzLgHF96/1qxYxV8ri3HK7ykqwnO8=;
 b=LqtjnV4boi2wOrfbJtGRi6unDq8AjQ0QqCxaSJz9FVDL4vsx36CKujIUPbOI1ZpNS3
 XQqM6/blNmIAIJooT14piR8Bb/JnwfWNTp5j8IsC+l4Q16oEvpXwn3zzWx5EX4MUyMLT
 pY2mLwqi9ua94eh3GzIPDqa4aUCHw5zR/xifj0hsZaT/Sx3ItLZ+e8YYvxQW1J1AX9c2
 GOeJSq1+NWxc2wL8Lyr4gbiFppxUty/Dzg0fQrxYncoWHcNtvUM2+UePdbH0Oy6BbnSA
 QzqYK/glApRfIIaIbrLJIVDPtox2w7UT1HY0mEfrPx4PptOi7u5Fc0LTEex/bAeywMJL
 GB5g==
X-Gm-Message-State: AJIora/DbKmk4jII5WaoKVRc5dLl89Cd0or3SuiR0uulMhP1lTfrnrBb
 syqLYWnj0KJ1xAfzsfbAKjtnxyn9CfyV7b/kweX/PA==
X-Google-Smtp-Source: AGRyM1tMBRELkdIUB+WahUZ3HbBB7VpSn07XisByEgMH3WLYDxJwtXXySPT1I4TW5C1OKkrxltUynrrqfqmbgcKRLcA=
X-Received: by 2002:a5d:6c65:0:b0:21d:b7c0:9930 with SMTP id
 r5-20020a5d6c65000000b0021db7c09930mr626692wrz.500.1658510724540; Fri, 22 Jul
 2022 10:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-17-kaleshsingh@google.com>
 <YtqHDTpnn376Qb7u@google.com>
In-Reply-To: <YtqHDTpnn376Qb7u@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Fri, 22 Jul 2022 10:25:13 -0700
Message-ID: <CAC_TJvdAa0PnTSiNa4W0QusQYJ7bEGeWD2+i4EsuZL94LjB15Q@mail.gmail.com>
Subject: Re: [PATCH v5 16/17] KVM: arm64: Introduce pkvm_dump_backtrace()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marco Elver <elver@google.com>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 android-mm@google.com, Marc Zyngier <maz@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Andrew Jones <drjones@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, andreyknvl@gmail.com,
 LKML <linux-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>
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

On Fri, Jul 22, 2022 at 4:16 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Kalesh,
>
> On Wed, Jul 20, 2022 at 10:57:27PM -0700, Kalesh Singh wrote:
>
> [...]
>
> > +/*
> > + * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
> > + *
> > + * @hyp_offset: hypervisor offset, used for address translation.
> > + *
> > + * Dumping of the pKVM HYP backtrace is done by reading the
> > + * stack addresses from the shared stacktrace buffer, since the
> > + * host cannot direclty access hyperviosr memory in protected
> > + * mode.
> > + */
> > +static void pkvm_dump_backtrace(unsigned long hyp_offset)
> > +{
> > +     unsigned long *stacktrace_entry
> > +             = (unsigned long *)this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
> > +     unsigned long va_mask, pc;
> > +
> > +     va_mask = GENMASK_ULL(vabits_actual - 1, 0);
> > +
> > +     kvm_err("Protected nVHE HYP call trace:\n");
>
> This and the footer printks should be put in respective helpers to share
> between pKVM and non-pKVM backtrace implementations. I imagine users
> will invariably bake some pattern matching to scrape traces, and it
> should be consistent between both flavors.

Hi Oliver,

Ok will split these out into helpers.

>
> > +     /* The stack trace is terminated by a null entry */
> > +     for (; *stacktrace_entry; stacktrace_entry++) {
>
> At the point we're dumping the backtrace we know that EL2 has already
> soiled itself, so we shouldn't explicitly depend on it providing NULL
> terminators. I believe this loop should have an explicit range && NULL
> check.

Good point, I'll add the additional checks in the next version,

Thanks,
Kalesh
>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
