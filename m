Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4557B
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 21:07:34 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id k7so4997191pll.6
        for <kvmarm@lists.linux.dev>; Tue, 01 Nov 2022 14:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFX3TjIuKKqYykGd6uzPpB/gicyMyYF9f2ih7JzKNRQ=;
        b=nBxrbawSkasV5OIFis4uRsM+ydVhwdbUYy7S1Z3udwJaID7FVoII4y3e2Y6NcN+RFh
         lZp3bFFxhaissiuG6SA1KtcxUPcOTyxEnfs3GW5mwTdPgGenTxv71EwIcLPnJ5aI0kQL
         dTkinmMWMPJlBd1h4MrEs6dFRGDXU5ZWycVzIeEZRmebSIxux39oV0pjFOaqEEMwW3PI
         mdWnXqnGBZe7Y4JMXHIAhJSV70YC2ZZS7M8HJAu/hH0IOh/jqS9KEtS1DxLpUlDaT2HB
         iwxcgPifN/nh2CZXcMCvRbDSp/gibhS85slcsL0bNnD/E/hPfgU1EdRvi82v6+YKObPV
         7Xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFX3TjIuKKqYykGd6uzPpB/gicyMyYF9f2ih7JzKNRQ=;
        b=1S61fB1We8RpG+y/iVfE4zzmtwF3gi9WaWxQzyizChPMuZKQ3wWPNnFCDD3zUtdL8f
         yhHjAsmeOk3Gluxhy0vT5dzkPiCbBo2nXTOEwjwwlqIWaW2m9e5DeADNdMaDXXbCF+PN
         qUChp3MCSGJkhnGetXsZ8ia8FCv/q4JTx8RY/MjrK4Cu82OqadMtaV/FBDYNO+K3E1xp
         /JLRN2y/x35Yde/yPPIqb+fQziI0gbSOjczurOjj+ncu5FT9IMGJFF9wlKd1csjWVoVR
         LcrTLw94T7GeklRVUcVnFusG1JZSMubdpyDzRF/w3h/3X+BL/nxjGq3WkSOhJRNgRdnD
         0usw==
X-Gm-Message-State: ACrzQf2n0wFTd5CMg0yTe+3BitD3MyjHX11JmIWODTOx63izL9R7fv9O
	KXGMOs7UcVube5RcC3hOyLktWg==
X-Google-Smtp-Source: AMsMyM7wcyEL7piFmVnE/Id8mKnk5QFETXWa137oLbYLhxqiM7qCfR6bO73L99JU47mjSsviqexCHw==
X-Received: by 2002:a17:90a:9bc7:b0:213:9d21:b0b0 with SMTP id b7-20020a17090a9bc700b002139d21b0b0mr22261185pjw.26.1667336854224;
        Tue, 01 Nov 2022 14:07:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q3-20020a635c03000000b00460d89df1f1sm6321288pgb.57.2022.11.01.14.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 14:07:33 -0700 (PDT)
Date: Tue, 1 Nov 2022 21:07:30 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 09/15] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <Y2GKkvMWTHfuPf4Y@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-10-oliver.upton@linux.dev>
 <Y2GBVML5MWXZE9Na@google.com>
 <Y2GFliAVxui9VyK2@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2GFliAVxui9VyK2@google.com>
Message-ID: <20221101210730.E_ffQe9xEhqEqkM-DXwFttDylBDzB6Lb_679FFfMsGM@z>

On Tue, Nov 01, 2022, Oliver Upton wrote:
> On Tue, Nov 01, 2022 at 08:28:04PM +0000, Sean Christopherson wrote:
> > On Thu, Oct 27, 2022, Oliver Upton wrote:
> > > There is no real urgency to free a stage-2 subtree that was pruned.
> > > Nonetheless, KVM does the tear down in the stage-2 fault path while
> > > holding the MMU lock.
> > > 
> 
> [ copy ]
> 
> > This is _very_ misleading.  The above paints RCU as an optimization of sorts to
> > avoid doing work while holding mmu_lock.  Freeing page tables in an RCU callback
> > is _required_ for correctness when allowing parallel page faults to remove page
> > tables, as holding mmu_lock for read in that case doesn't ensure no other CPU is
> > accessing and/or holds a reference to the to-be-freed page table.
> 
> Agree, but it is still important to reason about what is changing here
> too. Moving work out of the vCPU fault path _is_ valuable, though
> ancillary to the correctness requirements.

Sure, but that's at best a footnote.  Similar to protecting freeing, RCU isn't
the only option for moving work out of the vCPU fault path.  In fact, it's probably
one of the worst options because RCU callbacks run with soft IRQs disabled, i.e.
doing _too_ much in a RCU callback is a real problem.  If RCU weren't being used
to protect readers, deferring freeing via a workqueue, kthread, etc... would work
just as well, if not better.
