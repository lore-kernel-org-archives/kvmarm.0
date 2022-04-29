Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21459C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 896824B241;
	Fri, 29 Apr 2022 12:26:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EZck5FQsxy7Z; Fri, 29 Apr 2022 12:26:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 870B44A014;
	Fri, 29 Apr 2022 12:26:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B68F49E39
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 12:26:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r77-cZbYt3Ki for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 12:25:59 -0400 (EDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC1C54966F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 12:25:58 -0400 (EDT)
Received: by mail-wm1-f42.google.com with SMTP id
 c190-20020a1c35c7000000b0038e37907b5bso7364019wma.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 09:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=U7GwZfxNxCr20dXvniV2zLTxrd1PMEcbQZAO6v8SYLo=;
 b=D7hRSRGysLF6b/+lZGfGwGJW36LZtjnuaVsdT5g70KMJgcqMMC+FEhfKVUsaq/1da7
 IIbDQ1woP6gkqB9YFFVt2Z1ekn7gRvOn9m2dz899A2gF6FBaNoF1biSy4iaquXh+4IUI
 xntEIqq+rBOCXSEXbyXmRDWy5DyPF+oOtEp/tojXXdC7ZGUPgtjmAO4F67MHFK+pFHeC
 HyHxG3Xm7Kn0NTU2juRmrQhnIzj4auuTvurfUW7+ntOkSEzMWmLm6nRn/linRhkY58ae
 ouvIrvB+0vzZ6/h+haYPYB9L3MeD9Z6QO4u+RuQmqgtb/2egseSjMnCQAh+JCe3q1Iez
 W0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=U7GwZfxNxCr20dXvniV2zLTxrd1PMEcbQZAO6v8SYLo=;
 b=HZKfCjyxND1uY9gAsAnN6qXH2mZ8Wmpjvuu+2ALdIcsnRLKW/baUypjD7ayIuQtHQu
 6yKMFFHgBLCJCKZ+mqcn7xFw5S8CIjwDDCo5LlYb7LY3lkpBdXvaHbn6RT5uCV4nnvKI
 AblzNhaLwYhrrhgeN7jjKr1Ay/2IDq8LC+lk0bKiAhwvay7n+1yrIlh83UcYgxOeh+lq
 3+ZfCOTx6GsUXGJ9LdjJ8giqEvHLsyJp4QGdMmrdaWwAY3vwgxDROcCovT7BFQAi7+BK
 qF0Itwl3IMvF2FR0ujWXuZxPZdGhqwSPCB8UkC9p1RPuTSSDz2hIOaCO/hoUpTEFde/v
 H75g==
X-Gm-Message-State: AOAM530M5qzewScwFDmieKsRjSuoHYwkh+PBsV1NFOEQoucKAeSvYxYk
 8224cp305PyKd/LUUAVPG77BhSAZrAQeJJHRNsz7wA==
X-Google-Smtp-Source: ABdhPJxhLzTgLf/Ks/AB0pes6BWh4ozeKIdS874CsMwC+xluHukgX/fubue2dWWqxRl4fMNT+Iw0yiN5ImWbON3APeU=
X-Received: by 2002:a05:600c:4f93:b0:393:f08d:a048 with SMTP id
 n19-20020a05600c4f9300b00393f08da048mr4023212wmq.158.1651249557596; Fri, 29
 Apr 2022 09:25:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220427184716.1949239-1-kaleshsingh@google.com>
 <20220427184716.1949239-2-kaleshsingh@google.com>
 <YmveXly9117jbWKr@sirena.org.uk>
In-Reply-To: <YmveXly9117jbWKr@sirena.org.uk>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Fri, 29 Apr 2022 09:25:46 -0700
Message-ID: <CAC_TJvfm0ndtQSPt-gqYmzA-Q51MY6Eu1Gk3MxvCm+VqgtvCOQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Compile stacktrace.nvhe.o
To: Mark Brown <broonie@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
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

On Fri, Apr 29, 2022 at 5:47 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Apr 27, 2022 at 11:46:56AM -0700, Kalesh Singh wrote:
>
> > Recompile stack unwinding code for use with the nVHE hypervisor. This is
> > a preparatory patch that will allow reusing most of the kernel unwinding
> > logic in the nVHE hypervisor.
>
> This is substantially more than just the build change that the changelog
> would seem to indicate...  it would I think be clearer to split this up
> further with the code changes separated out and explained a bit more.
> It's not just recompling the code for nVHE, there's also refactoring to
> split out changes that don't apply in nVHE hypervisor like all the task
> related code which is needed but not mentioned in the changlog at all.
> Possibly a patch or two for the code motion then a separate patch for
> the ifdefs and build changes?

Hi Mark,

Thank you for reviewing. I agree - will split this into more
incremental patches in the next version.

Thanks,
Kalesh

>
> I *think* the code is all fine but I'd need to go through it a few more
> times to be sure I didn't miss anything.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
