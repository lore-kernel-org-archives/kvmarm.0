Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC10C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 22:12:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2EE249F59;
	Tue, 11 Jan 2022 17:12:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LWPVZ5-WMPgD; Tue, 11 Jan 2022 17:12:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C394D4B099;
	Tue, 11 Jan 2022 17:12:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C08E49ED6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 17:12:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6mKMxSRVJ6YB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 17:12:51 -0500 (EST)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com
 [209.85.222.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FB7E49F3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 17:12:51 -0500 (EST)
Received: by mail-ua1-f45.google.com with SMTP id m15so1295563uap.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 14:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Nbz7vvk/g5/wyCkKEDLwDSJe+JJYzX4xi71jSjqd8Ds=;
 b=nxOeeZBxizto3wdZqks3d+GuM/48NtxocfE27Xr6dqtR7ijr6ny0cpE1j8ZUo8irHN
 FUTPJOvHC2oqzVB7ose2KipHP7/ndid7ROLpw5blVzVqPYSxx3vAUr98tVkavFnbQfUK
 pLMhQeEVTGVT6MqluFvDbj+Qx3itH7a6DGeqsIJGdPXTD05RBFF0LElrQEUb+lLCSb7o
 +8H54rhaP8Yy4jJOZyUB9PhmQyFDyOKB1IB9lHvEDFJBWzAUQdb3Sd34x9sXII/2NMP1
 NsOYpCd8uTDlBYaIifrXaGwiehi1nnh4P1rSK3cpSoydYYtHYkZ9iGc4A6Kz2yqLIx5q
 iw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Nbz7vvk/g5/wyCkKEDLwDSJe+JJYzX4xi71jSjqd8Ds=;
 b=NPb/q1nrNYLPF6ltxN6rrHyC0Y5ulsVKz3B+/au7Fsx9sMqZ2UHoNPBy+NRrDDJdzR
 O8KHI1K6Lwu1cNuEXllnhqTunVdanJo/we9Xdo0q6/s6ss17alcmVYNA//UqLnVEIHlJ
 vEyiphSrzeh/R34a3i7SPBJ9gvbCpIIWnr1gm4UhltZqr06+FaQ6/HLDLiJ2t5WtRVcw
 yRStPAt3sL/a29BcdpUReG8gdDutQmw+r8mqMcb6qvW2sItR5i730l73f2+HlGzwLirV
 HJEsSDCnEnXT6HFeQDcwElploUTMos1JnkrjlIrU7qPKBgmaKdE37nGjPXXwhtw4MYlq
 huxw==
X-Gm-Message-State: AOAM533goJs8DrlVsNEmR/Abwx5uj3d6+gbLpgvYsvuT1HFLKFp+XGKt
 Ioks9Qo2wwJehgbWejQa4E37JFs/LroxilWur9H6wQ==
X-Google-Smtp-Source: ABdhPJzN+ft96CWqj5Q5pNpe5OnVUqYzJeoEqIa+2c9dEmh0mAlkqxKfCPmLLnid4IgaThqckNk6o/WOedpsjDOPsGs=
X-Received: by 2002:a05:6102:50a2:: with SMTP id
 bl34mr1703201vsb.16.1641939170862; 
 Tue, 11 Jan 2022 14:12:50 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-2-jingzhangos@google.com>
 <87bl0itvt9.wl-maz@kernel.org>
In-Reply-To: <87bl0itvt9.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 11 Jan 2022 14:12:39 -0800
Message-ID: <CAAdAUtiGYRgdp4qMwhPcYypUa2h_B6qWF8PkUEccHksKKsLoog@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] KVM: arm64: Use read/write spin lock for MMU
 protection
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>
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

On Tue, Jan 11, 2022 at 2:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 10 Jan 2022 21:04:39 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > To reduce the contentions caused by MMU lock, some MMU operations can
> > be performed under read lock.
> > One improvement is to add a fast path for permission relaxation during
> > dirty logging under the read lock.
>
> This commit message really doesn't say what this patch does
> (converting our MMU spinlock to a rwlock, and replacing all instances
> of the lock being acquired with a write lock acquisition). Crucially,
> it only mention the read lock which appears *nowhere* in this patch.
>
Good point. Will use the below message instead for future posts.
"Replace MMU spinlock with rwlock and update all instances of the lock
being acquired with a write lock acquisition.
Future commit will add a fast path for permission relaxation during
dirty logging under a read lock."
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
