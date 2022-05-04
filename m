Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4062C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 16:02:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16FF24B11E;
	Wed,  4 May 2022 12:02:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BSm881bLDzbJ; Wed,  4 May 2022 12:02:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B744A7FD;
	Wed,  4 May 2022 12:02:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA85C41173
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 12:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5zaUxmPrHdxO for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 12:02:41 -0400 (EDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C7DE411C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 12:02:41 -0400 (EDT)
Received: by mail-wm1-f54.google.com with SMTP id
 l62-20020a1c2541000000b0038e4570af2fso1105316wml.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 May 2022 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kO7qnx1Xqmu4DTD9ZcMD0gBbZfcRWt3UHYqgmw5RRmo=;
 b=Uoq+oA6kCO+OfEGFjCjYfU6owqHFW/6uuJJ0H7lJFwoo877iwo4q1BKeCwlxbMlnFD
 HrPqOqakLwgWUHpect+AHNXyT9CjssbCwV0BkKOsOz06UViZ80rZdayeXGvjhzIr2Vlt
 AP6bsFESQPVV82h6Mb4v4iYaWkr3weVKmV62+yLiGi1I2EzaK95tF7W6jbD/XaxgkYlK
 0/Gr3VnwDTjNeFheBC5hKvnDmiLK9SIOu6bH2fISS7YUP0asoWXXkRUN3pAXV6ySq3Vv
 5n6HxKCryKATu1TtPgq6gw62JUxp5dYF5M4Qeqt2gXCibnb4oqDmi72w6bOll+4EXAcr
 7ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kO7qnx1Xqmu4DTD9ZcMD0gBbZfcRWt3UHYqgmw5RRmo=;
 b=ECitbct2OYGSKVz2c3Yp71o0PGK3ozOXL5mSzbcAnXixy5rrKyKelhv78WcOmXpYkm
 AqBJl4xBQg9GanREFC51iyBxExSzbh7HciuggXqwdyvoSLfsbLB0KNyB8bT/E24eHaCj
 1Kf6Ux0+G9jV6jWSILGUG2OYZWKUSN6G/fGMoxRYQXg6gzem6bB6iUL5pMOB9vcPcVh1
 Sihv8cKiNhuehsygJR7e/wYNfFIPw/9GOuaWoTFZuKkDc5X5QYXEJDiA01c8AIBav1Ny
 N8I0W+8qLhRh46dZwQsK9+U6Wm9rm5YXYvmDd76OTIYLhK2UBdTjfpNde1tfOMssbopp
 8RUQ==
X-Gm-Message-State: AOAM532AslFDrh3WnmM1X1uijsSkSBxqsWczD6g0MdEIkj/niTD9mkRb
 TmXG1odVYo8vVP25BVjNuqHPfm299CteaE+PCD6JjA==
X-Google-Smtp-Source: ABdhPJxRKbW0nGe4qEM+/yFmAHEZ2p2lUWe6rRExJqJLSFhXadzsjcNe1S07pRkToh4blRMr1KAvy65FxTxywp/v26M=
X-Received: by 2002:a1c:e916:0:b0:38e:ac96:f477 with SMTP id
 q22-20020a1ce916000000b0038eac96f477mr115168wmc.160.1651680160228; Wed, 04
 May 2022 09:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220502191222.4192768-1-kaleshsingh@google.com>
 <20220502191222.4192768-3-kaleshsingh@google.com>
 <YnKK2IxdbVvcsOC2@sirena.org.uk>
In-Reply-To: <YnKK2IxdbVvcsOC2@sirena.org.uk>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 4 May 2022 09:02:27 -0700
Message-ID: <CAC_TJvcqRd+t8y75Z6+CAoDtADAH0yEFWo1CHhGz7wYxubM7-w@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Compile stacktrace.nvhe.o
To: Mark Brown <broonie@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Marc Zyngier <maz@kernel.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Suren Baghdasaryan <surenb@google.com>, Peter Collingbourne <pcc@google.com>,
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

On Wed, May 4, 2022 at 7:17 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, May 02, 2022 at 12:12:02PM -0700, Kalesh Singh wrote:
>
> > Recompile stack unwinding code for use with the nVHE hypervisor. This is
> > a preparatory patch that will allow reusing most of the kernel unwinding
> > logic in the nVHE hypervisor.
>
> >  enum stack_type {
> > -     STACK_TYPE_UNKNOWN,
> > +#ifndef __KVM_NVHE_HYPERVISOR__
> >       STACK_TYPE_TASK,
> >       STACK_TYPE_IRQ,
> >       STACK_TYPE_OVERFLOW,
> >       STACK_TYPE_SDEI_NORMAL,
> >       STACK_TYPE_SDEI_CRITICAL,
> > +#endif /* !__KVM_NVHE_HYPERVISOR__ */
> > +     STACK_TYPE_UNKNOWN,
> >       __NR_STACK_TYPES
> >  };
>
> I don't immediately see a problem with it but I'm curious as to why
> STACK_TYPE_UNKNOWN got moved to the end of the list here?  It does mean
> that zeroed memory will default to STACK_TYPE_TASK but we're not
> actually relying on that.  Otherwise

Hi Mark. Thanks for the reviews.

STACK_TYPE_UNKNOWN was moved to the end purely to group the common
enum values. Not a functionality change as we don't reply on an
uninitialized stack_type

Thanks,
Kalesh

>
> Reviwed-by: Mark Brown <broonie@kernel.org>
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
