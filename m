Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397856FA1
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 17:22:02 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id u72so3230137ybi.7
        for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 09:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+NF7WOwKXStbVcCBmnQTR8aAYHjwReQdf6MvWz/ieQE=;
        b=G/sP0Ge2BbmLK5C1fYqIhHmfO9YiRHy87eRqbWpmlZctgb1Mjd3hQa4bOwD180MWX6
         N9m5BZ5ghS2tzwTNr12nV3VeSN0+z9yP0c4kJa8fVHf0liLZpx9LSNTEL28uc4R/m8Xd
         DTt9dY/swPExNObKMFXnORILtXrqvfvPIy7kzOUkT25jJo53AbsZlXcJaaoY0pxtCLXS
         qgm7XaZfzBEKVqNPbBdF0AhzVYtmjGNYtzFnqQUr3odJs29myMNgBOQe8LMz9PeTVJLp
         7+pVgI1I+vSb3zqVmxeKhnMsVmNFvn/PsYcbOlBZDilIwwcmDqrHgsUVs8ak5XGd8/tq
         3RgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+NF7WOwKXStbVcCBmnQTR8aAYHjwReQdf6MvWz/ieQE=;
        b=15icLpEsxFQ39YZ7cZ6I4GfqY2Lk25imL1AivZGGPYyeUxk9/gEBKJPxszmLsBANCU
         lN1m79dm0h9mB4BgPvE1lVRUV7VsrOBGDDIwF2UIqI3eCiXIVtSh4gqGUBM47rvE2c3D
         Tmh043Low0MU/UcPWt+H9WK2PxU/NlxsHnoNs1n/qLv9qoJqVoXsy0OhSEhyoLkuH8er
         CenmwKKCfp/dokY05SW6BUaWsb/L75oEDUySTS54TXXrvd6RnDwux6BpVPtGJtyc557R
         hE7THpOTApLOEBCDatq26bW+ZixT5iDJH1hVtOShxaHKnrK4BMD9fYJTMI0OIuCjLpGd
         aa/g==
X-Gm-Message-State: AFqh2koGTbVKA9c3L/4ZcPvoALEnAJ8I23moEVupeCynhg2tOVd7ln6J
	q0M7Peo+l/JJui7x3p3DGh+wzqdf/+ebbX2RhZ0e4w==
X-Google-Smtp-Source: AMrXdXu3jKBxFWKV9U7HEoc8nZkdzpu/vB3yVyIUHmWHNLUO+5YjJYHaG1m9/rmSDsx5131N51uq+J+p+rywDrfAr5Q=
X-Received: by 2002:a25:1984:0:b0:7fe:e7f5:e228 with SMTP id
 126-20020a251984000000b007fee7f5e228mr1798951ybz.582.1674667320995; Wed, 25
 Jan 2023 09:22:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com> <Y9B8A+/FSPCrAANT@google.com>
 <Y9B9FZReDVwdNNrS@google.com>
In-Reply-To: <Y9B9FZReDVwdNNrS@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 25 Jan 2023 09:21:34 -0800
Message-ID: <CALzav=fAVF5VDj76Pd9m+G+-A+UdvCS1tTVGCyvnvtgq4eFOSg@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: Add a common API for range-based TLB invalidation
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023 at 4:51 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> On Wed, Jan 25, 2023 at 12:46:59AM +0000, Sean Christopherson wrote:
> > On Thu, Jan 19, 2023, David Matlack wrote:
> >
> > Did a quick read through, didn't see anything I disagree with.
>
> LGTM for the tiny amount of arm64 changes, though I imagine David will
> do a v2 to completely get rid of the affected Kconfig.

Thanks both for taking a look.

> > Is there any urgency to getting this merged?  If not, due to the dependencies
> > with x86 stuff queued for 6.3, and because of the cross-architecture changes, it
> > might be easiest to plan on landing this in 6.4.  That would allow Paolo to create
> > an immutable topic branch fairly early on.
>
> +1, that buys us some time to go through the rounds on the arm64 side
> such that we could possibly stack the TLBIRANGE work on top.

The main benefit of merging in 6.3 would be to make Raghavendra's life
simpler/easier so he can build the next version of his arm64 TLBI
series on top. But I guess he can still do that with a topic branch.

I'll go ahead and send a v2 on top of the changes from Hou you queued
for 6.3, Sean, and we can plan on landing that in 6.4 (barring any
further feedback or conflicts).
