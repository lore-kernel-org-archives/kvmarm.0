Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1298AA1
	for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 18:47:41 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id h193so14079276pgc.10
        for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 10:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AkKPIWHeRn4hniFMrnTGIvHiqEhhgn36keNoZHXH3oI=;
        b=hDLtK/CfhXpByl5cdJHj5fS6CRLCYmzHAAmcDFoAq0ZWMqmrPakIcZ7dyCKeczjCoU
         ijVNKn8k2kccZk6ZkpitihnY2qlj8f7j/fPfk2POgyWKHBUnkCSOh3kueO1ZX0g2IL30
         IAZEpHmHEfgTXiDQzQNlTqmTr/xibzlUqGu9uaxhaxHk8xDxgoeBTrvt0pL0N7vlKXdU
         3uAjS/AJ/zsByV84zOyxr3NkKiC6ze5xAjSZ2QbeaVlSdAW3PAoa6n0F287ykgDHtDS7
         AHuAbh6r6PuJ+clQieWCi5h1ryW4s/uVIwz//7XkCgod/d5XMjb1T6loNU4sDlNJDlsd
         wNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AkKPIWHeRn4hniFMrnTGIvHiqEhhgn36keNoZHXH3oI=;
        b=B1HIbUAXol/T/Ww46umm/o9ufNLpH9dT/SvhGffbaRZf+ZvHji7FvHkuHMRn4RRze4
         bhjtQ7dse9c2k2zh7dFZA21mO9syxDeNZJvYFh3Ny2N6Rs0MvjEpL1yAPvGnSyxm0ekE
         hQWoo2oXXZz0Sy4lPE13KNzGgA2XddrkLJf63uut5oiKMcrIn6Shqvb1+1A0W5+rEG3b
         SW5ySn2zTI8MD3yl1rcTTffmkKj5eaDJkyCsKrrhod+G1Sz7E6EMZddJblZcTQB2s9HK
         eW3dlprz52ZetQwrAJSaWL5RGzQZZD+bRxOlg4MG98EDHkJOnZYkl2+vXhQAsAJZ0qHT
         LGUg==
X-Gm-Message-State: ANoB5pkTmQt497F4EWRHJD+Yim+wWJS8V44FmDNnxUSV+i88v257I8EA
	vZ4UyK+S1+2aWkzff+LtWrBlwQ==
X-Google-Smtp-Source: AA0mqf5ewUFxFuYZmhYALZjNpcyEotKOZbibubDZGdomI5FE4JI3gXz3HN+ZL/JWRORbOZ+Q96LHew==
X-Received: by 2002:a62:bd19:0:b0:56e:a001:8cb0 with SMTP id a25-20020a62bd19000000b0056ea0018cb0mr19447236pff.60.1668538061122;
        Tue, 15 Nov 2022 10:47:41 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id o38-20020a634e66000000b004639c772878sm8147241pgl.48.2022.11.15.10.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 10:47:40 -0800 (PST)
Date: Tue, 15 Nov 2022 10:47:37 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y3PeyV4KIjoBBYNV@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <Y2whaWo3SIOOMKOE@google.com>
 <Y2w98zPmtefJlNfa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2w98zPmtefJlNfa@google.com>
Message-ID: <20221115184737.nOLSlMdNQXi3-a4rFaHQa_zuwuHujOPUti-6RwFikrk@z>

On Wed, Nov 09, 2022 at 11:55:31PM +0000, Oliver Upton wrote:
> On Wed, Nov 09, 2022 at 09:53:45PM +0000, Sean Christopherson wrote:
> > On Mon, Nov 07, 2022, Oliver Upton wrote:
> > > Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> > > release the RCU read lock when traversing the page tables. Defer the
> > > freeing of table memory to an RCU callback. Indirect the calls into RCU
> > > and provide stubs for hypervisor code, as RCU is not available in such a
> > > context.
> > > 
> > > The RCU protection doesn't amount to much at the moment, as readers are
> > > already protected by the read-write lock (all walkers that free table
> > > memory take the write lock). Nonetheless, a subsequent change will
> > > futher relax the locking requirements around the stage-2 MMU, thereby
> > > depending on RCU.
> > 
> > Two somewhat off-topic questions (because I'm curious):
> 
> Worth asking!
> 
> >  1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
> >     faults (handle_access_fault()) and/or write-protection faults without acquiring
> >     mmu_lock?
> 
> I don't have any plans personally.
> 
> OTOH, adding support for read-side access faults is trivial, I just
> didn't give it much thought as most large-scale implementations have
> FEAT_HAFDBS (hardware access flag management).

WDYT of permission relaxation (write-protection faults) on the fast
path?

The benefits won't be as good as in x86 due to the required TLBI, but
may be worth it due to not dealing with the mmu lock and avoiding some
of the context save/restore.  Note that unlike x86, in ARM the TLB entry
related to a protection fault needs to be flushed.

> 
> >  2. If the answer to (1) is "yes!", what's the plan to protect the lockless walks
> >     for the RCU-less hypervisor code?
> 
> If/when we are worried about fault serialization in the lowvisor I was
> thinking something along the lines of disabling interrupts and using
> IPIs as barriers before freeing removed table memory, crudely giving the
> same protection as RCU.
> 
> --
> Thanks,
> Oliver
