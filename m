Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B2CC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 12 May 2022 20:37:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 465E44B08B;
	Thu, 12 May 2022 16:37:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PMRVTfOy1xwm; Thu, 12 May 2022 16:36:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 586F94B0B6;
	Thu, 12 May 2022 16:36:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E3D34B08B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 16:36:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lhZxNaEnhrPs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2022 16:36:57 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8163349F46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 16:36:57 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id d22so6014373plr.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 13:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=8iEGBmtJoxRg/w5RBuhSp0K5Od/nybtVVk1rH49oGiM=;
 b=ixitpKQ3SEMJx6+vyRqfYZFPsTDVscIcPWYVwAot2TlYWB/whS7xd2WA0N3kFVhdWv
 xykgHSXbXR13UoiVi6kmSmkzX2tfIsv7vsZph7eFSvV1S0D9T3FHIUWA8LMD0Do236on
 FTisXIdk9sh4KeO0hAlhE0GBNUnBqeKLa0sWqmXuxnr73Xr9DqUdwX/qiP840xQT6KmX
 vUwaNHv4yq0UjkHIbCtTCBZttGQQrebwZJ05pQro3hanExvUMkgnoB8A3xPfeZTScIFd
 ifuuI96/H0MEDTv8C00E3fyfMSJ/KwBkl5YM9aUbb9nKKbBlKdnD3y7zJcQs9AzZnuVI
 uC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8iEGBmtJoxRg/w5RBuhSp0K5Od/nybtVVk1rH49oGiM=;
 b=tpeltzplGJN+O//WYa2kVl0SXY7GxaCR7iId/jj69Tm1mNxZXbSeQ1vDE6xsGEK/tv
 jj24chbs2HZRLT8j5wTsXrleEiEds+j7YPHzHr8v4iQCizJCYMtLE4c1eUnAi4PwbqJS
 p8JgSIvmWpzFTfnOzQtGRITH6c5t+Vv7m3EDivKtPIrXZmBe2Cm1JdixpMIyhg322UfO
 gy//n3VOJiCV1MF5rOeRP+IdEz2F3ZGe23iHv01tCWWoJYE0z0BywH/TMHfpp5+m1i+W
 kE8IFrvvg8/PJGFEi5o+xzDO3cEpkPdOIFowOv1UIvHFifMBzpDGMRqyb8n0OI0JL1Sl
 Rr5w==
X-Gm-Message-State: AOAM530W/frlcK7BhYuYGXTr4AwtFvRbeH7NvtCCEWYiLLtU4DZEpykL
 pd1PCeZ+EZpSHDpduH/s8o8evFEjAED4XEN/cDGKzA==
X-Google-Smtp-Source: ABdhPJwuhYymsZ0StsyNYTXEvlNbykWVyGE1D/eBaulkendPrYdPMp+9LrsPeBKypjw3sXfyHpF2VAkA0+PEtw1SNjc=
X-Received: by 2002:a17:90b:1d83:b0:1dc:4362:61bd with SMTP id
 pf3-20020a17090b1d8300b001dc436261bdmr12577913pjb.126.1652387816246; Thu, 12
 May 2022 13:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <CAJD7tkbfT-FRs3LE2GPddqrQSWw_eC1R6k3z04x=z9Zvt5yLpg@mail.gmail.com>
In-Reply-To: <CAJD7tkbfT-FRs3LE2GPddqrQSWw_eC1R6k3z04x=z9Zvt5yLpg@mail.gmail.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Thu, 12 May 2022 13:36:44 -0700
Message-ID: <CALvZod4w88YDCpageGPDZfCcFwi2C4YfSsavd-Svixovvx5n_A@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cgroups <cgroups@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
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

On Mon, May 9, 2022 at 9:38 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>
[...]
> > >
> > > What do you plan to do for IOMMU page tables? After all, they serve
> > > the exact same purpose, and I'd expect these to be handled the same
> > > way (i.e. why is this KVM specific?).
> >
> > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > account other types of secondary page tables to this stat. It is just
> > that we are currently interested in the KVM MMU usage.
> >
>
>
> Any thoughts on this? Do you think MEMCG_SECONDARY_PAGETABLE would be
> more appropriate here?

I think NR_SECONDARY_PAGTABLE is good. Later it can include pagetables
from other subsystems. The only nit (which you can ignore) I have is
the very long memcg stat and vmstat names. Other than that the patch
looks good to me.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
