Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7AAC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jun 2022 16:07:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CC7B4B2BC;
	Mon, 27 Jun 2022 12:07:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 16vmEODqd7ah; Mon, 27 Jun 2022 12:07:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542384B29E;
	Mon, 27 Jun 2022 12:07:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 902BF4B285
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:07:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e61UHWAr-1Ql for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2022 12:07:37 -0400 (EDT)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7114849ECA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:07:37 -0400 (EDT)
Received: by mail-pl1-f172.google.com with SMTP id o18so8603233plg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 09:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=l0pibN8bjG0PnvfGdr94sagjrAjKQlwTKx4ke7hg5TE=;
 b=KXpJaULYCMOBvM0KZ+Y0QmYKcs5GsOT3UDoT12OxOmZTuofXiRwwGm/WgJTM1heXoI
 t1dv3k342OQnZ9iooXjd608cniWLl0qlDw2/EFrZO3JITiMUniSnoS9vRpsVYcQj8vN/
 I7nko6H+yxfXlWmj6BpVmIQCvWqpF55RTmiG3dExwV8krl6JWA8dxuz7o3cuKUtlCKLL
 AUH1GrHaKcLi0AxNkq1Q0RlPIztx9SDq4ccjZXK7Aa2jkpBZXbRVUSJ+/fIBfJxIB9bo
 wqHrvEDbll+Qw87/iH2rzRcMOLCQ34VpKyfcZXoB0fUgM3GYU80A2xB80LHN6E80KQa1
 5riQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=l0pibN8bjG0PnvfGdr94sagjrAjKQlwTKx4ke7hg5TE=;
 b=1fGwCmLerVUTAsWPuohmiOfoqzxJkzB2N3eYIcvEo30XbY7pk/7e86hVMy1UIu7yL2
 Z1UiPhIHtez9zTdR22IbhWFW8Evgy6oQzlskbE5fFnYNyTk6V+/MuVjPYqqX4ItcDApX
 ILY8fYb4FupO0OVcAif/LjLTc8n6xNr23NZXPsfqg3GbYvLDE2ROQRZsV7sy61IR0fs3
 KpS/ziZCV2a0XUKI0meRUg4B7SlyY6gwCsPHI7sbelv2ppwbJyYybHE/P+qkIAaaxQfY
 RW/M/vBk35hk5R2mC8wj7K9Lg7zWK1Io557ELQU4RJfmR3Y1WtHf14jZHSHh4xK/9YGy
 AzUA==
X-Gm-Message-State: AJIora+L1QikG5UDtOLMSo8EpKW7b+qIVSEFP1UB/OOe/XO9aNXKNWOd
 vtkiWmRXcl9Cq3AVMLuxUrxSxQ==
X-Google-Smtp-Source: AGRyM1uyfo5AfaNgmfF7G/qEE7dWnvzScXgctBWfKk3cum7fj6D7nx+TeglAS/qAbSPCsy6MAsmoPA==
X-Received: by 2002:a17:902:9f97:b0:16a:9b9:fb63 with SMTP id
 g23-20020a1709029f9700b0016a09b9fb63mr15547216plq.7.1656346056250; 
 Mon, 27 Jun 2022 09:07:36 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 g17-20020aa78191000000b005254bd90f22sm7528584pfi.150.2022.06.27.09.07.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Jun 2022 09:07:35 -0700 (PDT)
Date: Mon, 27 Jun 2022 16:07:32 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <YrnVxM/5KjVhkOnn@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-2-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> KVM mmu. This provides more insights on the kernel memory used
> by a workload.

Please provide more justification for NR_SECONDARY_PAGETABLE in the changelog.
Specially, answer the questions that were asked in the previous version:

  1. Why not piggyback NR_PAGETABLE?
  2. Why a "generic" NR_SECONDARY_PAGETABLE instead of NR_VIRT_PAGETABLE?

It doesn't have to be super long, but provide enough info so that reviewers and
future readers don't need to go spelunking to understand the motivation for the
new counter type.

And it's probably worth an explicit Link to Marc's question that prompted the long
discussion in the previous version, that way if someone does want the gory details
they have a link readily available.

Link: https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
