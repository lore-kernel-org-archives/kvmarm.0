Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E92FC43334
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 19:55:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A11BA4B40A;
	Fri, 10 Jun 2022 15:55:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5YCt8YEcmyA8; Fri, 10 Jun 2022 15:55:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA8054B34A;
	Fri, 10 Jun 2022 15:55:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5FEE4B2E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 15:55:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7673dyN6Eod for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 15:55:43 -0400 (EDT)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86CD24B2BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 15:55:43 -0400 (EDT)
Received: by mail-pg1-f177.google.com with SMTP id 184so83429pga.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 12:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QBy6NjH2ouB9J4AcBo7wTpbSKkOShDZoTHSArfldiUw=;
 b=sklHbZakJDBBoAiTpjSD5q4HxK1etfA1WIC7E1GGXxranlMwDMPGy/uz2sJhGgVhFh
 PsuwAc1Kvt+JrVxUxoIbUT41GO80lUj3bVmOMXx/EiCDoPrvSZTi5VA6KlhM0oySyOuR
 +tYZA59GVkAhi7mk0TAsOWGswz98wriVH5TPC/c2Qf2YokWtgLtStUvjfTvamYaneEGH
 bzvkFbDMtZuEKw/jnULBvxk8zwbsM2bB87HtefiubybLbL+H3NdXdw9PHE9MFa1uwCCh
 tyZDjrUVtcAARyszAW1G5DhaCKiwkKolBeX5R2/hKBE7ytxWxLfuo/5GEb1KHAlQavBv
 Z93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QBy6NjH2ouB9J4AcBo7wTpbSKkOShDZoTHSArfldiUw=;
 b=4XdifbYWZhYYx3/VzuePHIwSFZhS5gt/ASGTp7YZsW7T+yEaxo1C7pyR6bmMIu00Y3
 HWlfdqXpfRezicqwac9crFhw7cr0fVKtagEhh7cavsVoNKIegaTJmUlf9dhbJoHrACm9
 zuc3PDY4MG2GFT+AjJwln9Di0pooqpOqm39JDl9rl7Rc5ZjtCyIhpKyqfwEK10/cXY+V
 +CCnawcaFWUYHSuSrBx4PIrxmz4G9hlVw+ETgggDE1lN6Tl5lXn6dvg+79OLEXuX3oX9
 sBH2F6atUopdEPj3Dwe4KHk/E3HqUd59nSA2fypnId5tcn7WXAsuXw5/rGkpiSq5T8pd
 Q6Yg==
X-Gm-Message-State: AOAM532ujWQdBuM8LWmuZzGBcGbDUaqaTFwZ9O6FOd995GdnK82hSfrg
 2r/+EcPJSnkqPsMDg0u9EA5XVVmTBq46OpULcSnZ6g==
X-Google-Smtp-Source: ABdhPJzEcSokF/zla93DIjSWei/mG/WMD+1gosW/4iq24fWu9VXSfgg5vd1o6/WI+TarUi1z/A31bQpqsNJXGPSmzwc=
X-Received: by 2002:a05:6a00:a12:b0:51b:92d7:ec55 with SMTP id
 p18-20020a056a000a1200b0051b92d7ec55mr55432987pfh.85.1654890942318; Fri, 10
 Jun 2022 12:55:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
In-Reply-To: <20220606222058.86688-2-yosryahmed@google.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Fri, 10 Jun 2022 12:55:31 -0700
Message-ID: <CALvZod4XtEfdSjq=Jq51tvwXkpv-TKr32G6aeyjzcwxvdPv9SQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cgroups <cgroups@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>, LKML <linux-kernel@vger.kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 6, 2022 at 3:21 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> KVM mmu. This provides more insights on the kernel memory used
> by a workload.
>
> This stat will be used by subsequent patches to count KVM mmu
> memory usage.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
