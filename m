Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC15C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jun 2022 11:24:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7B9B4B37F;
	Tue, 28 Jun 2022 07:24:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DjxyUcv+PrkN; Tue, 28 Jun 2022 07:24:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74B634B3D9;
	Tue, 28 Jun 2022 07:24:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A9E54B12C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:29:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JzOmehqXqWl6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2022 12:29:50 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17E3B40597
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:29:50 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id
 g39-20020a05600c4ca700b003a03ac7d540so5169913wmp.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 09:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kCgDBgQt6lsYAKDyUa0fPFsfL97zuKyIxwCybKNVm6o=;
 b=IuiG/blkJ7gXjOQhLgtlkFYoJRK5r8pgakqSWN1/zlxqf40s05Q2KxgVLRnXAzs+fg
 ulTgDq4Xa1IQ2RvaytKxJcvgFOnViaFiqQeqoT8bFMwQmOfmx5WYvBOMGbjbujaxBKq2
 ZxRw26go6NuTS6kLvJS34xZfj51gNbDxnvzESq7KPA+97DIORIk3qqV6wvZaFYlRyp37
 iYjN5F2Fx3qCzsMwgAJwoELntygw5WoMYjcgqI9vY49AS4kLGOtkbsV2NX3QusZYb24t
 UMBgY7EFeybOiOqeaEkIwXo3wZRzJbzLQJE66d9iQWRd6teu2XSLOdmiKZKg0XoS0prd
 qUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kCgDBgQt6lsYAKDyUa0fPFsfL97zuKyIxwCybKNVm6o=;
 b=qqllsZHGQ7z+mZnkrMg9mzIZpSufyw0T48UMqF3k/CSCCzdzTEizkrTyRdTFuF/EAF
 24vKK/k0FKF4LBbb1ChpdnSugyidMRcVfhCyLHteksNG+dzebGjLKDlbY0sRinEkaVYT
 uO7sS6xDAvejkxnMQGk3gO+qVoR7HVn10whBqfkGjUTlbO3Tl4neF4sGfE8wLvvNLjbw
 MxJHwnF6Kclf6Rv3o4uxCL4LdPGFHvAzDbawNGionzIeeiHe9T9IncbACa1KQFHMpVz/
 HiSxYLtbKvDZRX8XCvTp8XET5avSPb/LiU5AmHdLlCKGnxGxB52GF26BRNw+SS4QVaGs
 s7mQ==
X-Gm-Message-State: AJIora8NcjEcxD3zAgg1uHV1gwEncgHg4uCkRaVJHuG8DDXQL0mosp3l
 7sajh73BPidd9VVUAYDa6QthFxapDLoYFsTDeCubYQ==
X-Google-Smtp-Source: AGRyM1vrDRm9Dztps4OpWjfEHDZNDaLLcMTy/XMsmuqPQoMJ/tNBlVur8bjCqgfF0MDzD0AVg6RDeZvfzsVoc13BMio=
X-Received: by 2002:a05:600c:34cc:b0:39c:832c:bd92 with SMTP id
 d12-20020a05600c34cc00b0039c832cbd92mr16254989wmq.24.1656347388958; Mon, 27
 Jun 2022 09:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-4-yosryahmed@google.com>
 <YrnZVgq1E/u1nYm0@google.com>
In-Reply-To: <YrnZVgq1E/u1nYm0@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 27 Jun 2022 09:29:12 -0700
Message-ID: <CAJD7tkbkgruPRrfyaHGQcOgmNFCWRASaZB-a8igBScpasfC64g@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 28 Jun 2022 07:24:17 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 Cgroups <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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

On Mon, Jun 27, 2022 at 9:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> > Count the pages used by KVM mmu on x86 for in secondary pagetable stats.
>
> "for in" is funky.  And it's worth providing a brief explanation of what the
> secondary pagetable stats actually are.  "secondary" is confusingly close to
> "second level pagetables", e.g. might be misconstrued as KVM counters for the
> number of stage-2 / two-dimension paging page (TDP) tables.
>
> Code looks good, though it needs a rebased on kvm/queue.

Will rebase and modify the commit message accordingly, thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
