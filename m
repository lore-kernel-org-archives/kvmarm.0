Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA4428F2
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 15:18:57 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id d22-20020a63d716000000b00502e3fb8ff3so2725897pgg.10
        for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 08:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678720737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J9Xq5escaSYWRdwEHLAH6oMvH+8AblM7LMhxhLK/+R0=;
        b=ECU2onOte2LWgRcZ6hdpQJUQ545e8QYM/XcY7GVAWLhiWCLmjylBB4Lrbg9gPXs1Ly
         nyymNz8VgQwaIYdloRIqQFkY18RufYl0mPrAqfYFQTkZ1/lhJmPjcOUXTNTwEn56gupM
         AP/aLRyohdEkarN7z8U0kKmAMbtXatRxWA3ZViONpAZqXBqOJHXxHqQFK+l048IthItP
         ClzEB5dty74kqOXSVv7HoBUAnVozh8IkxDnN/1sOZSiAEgeg7hRiwB2MsepNbU/GdTxp
         FQwlKOIbv6RHdQXdmiC934rGjmvInxzxTVlwbQyDRnc0kxiIceRbwpY+0ZKXrD0WblOt
         nMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678720737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J9Xq5escaSYWRdwEHLAH6oMvH+8AblM7LMhxhLK/+R0=;
        b=ojegz06WeSx6JzXs+FZdLu8qd3fddwY05eYk383Kkt9+p0s7979ZBKoacnM/R3qpJY
         bwTmG7WoIzpY+a9JE4TQnRoWyX3aWniJCkBeXiH12y+tza4TpYtJ0uQwybKXd14vscC/
         V/3XehOX3VMKfETSiNtJDmnuFLLKnsUuRrvhW/lx6PxXrdWjluj/demZJq7ANSL7wxCL
         DpTApG8+xo1Cjj4F8DDD5bFtk4NRq+eeA9R58KEAMUrJ8FY96Xa/VUA3+zGE2MtkBkY0
         7Nzn3zUFV1Q0yJQaHzIDOlLfpJT//kso6NzI0s+bELnLZftlY3/RXmMEx/OU1Lv7JQan
         wt8A==
X-Gm-Message-State: AO0yUKVzeR1sKSVTcF5lP05m9wwnyfRvqSdWpl0KEM+zHtKVA+waBPiE
	qH1gzDcBjIab2QufJ0U3QHlehUEKKHg=
X-Google-Smtp-Source: AK7set9BlNoLJIo5wX3TzGHjv6KddFr8nWGutCu67vJ9adzJb5qHZFLAwIMAXzJ2iWxeuSokv6/ju1J+ybs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1b50:0:b0:593:e110:9582 with SMTP id
 b77-20020a621b50000000b00593e1109582mr3599041pfb.2.1678720736984; Mon, 13 Mar
 2023 08:18:56 -0700 (PDT)
Date: Mon, 13 Mar 2023 08:18:55 -0700
In-Reply-To: <878rg25hbq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com> <20230307034555.39733-8-ricarkol@google.com>
 <878rg25hbq.wl-maz@kernel.org>
Message-ID: <ZA8+31vQA6vcQuK2@google.com>
Subject: Re: [PATCH v6 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, alexandru.elisei@arm.com, suzuki.poulose@arm.com, 
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com, 
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Sun, Mar 12, 2023, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:50 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > No functional change intended.
> 
> I wish people stopped adding this pointless sentence to commit
> messages. All changes have a functional change one way or another,
> unless you are only changing a comment.

The implied context is that there is no change in runtime functionality, which
does hold true for many changes.  I personally find the annotation helpful, both
for code review and when doing git archaeology.  If a changelog states that the
author doesn't/didn't intend a functional change, then _any_ change in (runtime)
functionality becomes a red flag, and for me, prompts a closer look regardless of
whether or not I have other concerns with the patch/commit.
