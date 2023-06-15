Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71654BA3A
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 14:56:05 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bce24604eeaso1928536276.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 07:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686840964; x=1689432964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8mCu3q2W53oKSoawXLYJ93orssYlrpvFJDcpWykXpws=;
        b=mUgvNvZY/tOdw3tuKIAsLd1mD1eoX6q/vF4f+UMtwXX/LnleIYYhB+2kJmlH3xFNQl
         xGosABWC5pM8S+9c7Go3WbBUGwk1nPMP6fpNkpPnPXU6E8EFFBwS0EjHDBLZLRMRR+jG
         Xu+6g3oCQUR1Tznlx75COV7MLaKxsxel0Mxv7gDsgjrFETQ+5DNTpPZiFrDmNgYglFf9
         iIjmYP4Qcx1Vs8l0Rx792q8Xk7qFeNyKsP2AS4ht1upRkwu9bdBuI8CDP8FabIojrKfY
         AjI7aeJdrglwJdFi3GYDaW61B3xtRtL95X59EpqsSIegViNBv7/Tc4GwYAGju2+kE01D
         BNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686840964; x=1689432964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8mCu3q2W53oKSoawXLYJ93orssYlrpvFJDcpWykXpws=;
        b=Pu1JRww5TaDHfl4UFxIcJrb2SSaUn02akbJD1Xm0ylLWyIHeKWfxJ8+t0yet/PbkJ5
         jy3/rMEVoUeyvNFgMPlbXa5kLXYQchmwHLLuvKX53JBrGftt3IVTtbvFjBqApy2rFOLO
         W0vxeSLx9b8LmA8hkTpHXSMv4yXTtv7NQxxVZuiWuI3KGzb9zKfS99w4ra2FQjgpAUEj
         nXZ/0Jjf617MQA1NFale7KHQv8BnxZF3sb3+okmIFKKTWe9JYvKJwChmrVOog7RNnQTe
         98V8unY10+86VpFwLGO1yb8a8Qbeah5PpON+yyd+0Yfxa160yMOQCWwZ00JA8BNAgNq8
         mSLA==
X-Gm-Message-State: AC+VfDyXEaupjirihvFpXBrFFMNEP+qj2PbB+yMkEj+IthEsW3u560mH
	QajywZ5BqNi8l8rPyF0CqMCIzK8u0Rw=
X-Google-Smtp-Source: ACHHUZ7ZYqdPI7E3BxkS+GlJff/2XmsdQrbZQToAtHCD3oKMWWqg9gW2lpZzYNNQvHEbuBhXAI4EIguFdRI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8209:0:b0:bd1:ae45:5447 with SMTP id
 q9-20020a258209000000b00bd1ae455447mr706408ybk.0.1686840964224; Thu, 15 Jun
 2023 07:56:04 -0700 (PDT)
Date: Thu, 15 Jun 2023 07:56:02 -0700
In-Reply-To: <DS0PR11MB6373969DA5CCDD6EBBC9CB7ADC5BA@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <DS0PR11MB6373969DA5CCDD6EBBC9CB7ADC5BA@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZIsmgnEneMBZ48hf@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: Anish Moorthy <amoorthy@google.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maz@kernel.org" <maz@kernel.org>, 
	"robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "bgardon@google.com" <bgardon@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "ricarkol@google.com" <ricarkol@google.com>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"nadav.amit@gmail.com" <nadav.amit@gmail.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 15, 2023, Wei W Wang wrote:
> On Thursday, June 15, 2023 5:21 AM, Sean Christopherson wrote:
> > Ah, crud.  The above highlights something I missed in v3.  The memslot NOWAIT
> > flag isn't tied to FOLL_NOWAIT, it's really truly a "fast-only" flag.  And even
> > more confusingly, KVM does set FOLL_NOWAIT, but for the async #PF case,
> > which will get even more confusing if/when KVM uses FOLL_NOWAIT internally.
> > 
> > Drat.  I really like the NOWAIT name, but unfortunately it doesn't do what as the
> > name says.
> > 
> > I still don't love "fast-only" as that bleeds kernel internals to userspace.
> > Anyone have ideas?  Maybe something about not installing new mappings?
> 
> Yes, "NOWAIT" sounds a bit confusing here. If this is a patch applied to userfaultfd
> to solve the "wait" issue on queuing/handling faults, then it would make sense.
> But this is a KVM specific solution, which is not directly related to userfaultfd, and
> it's not related to FOLL_NOWAIT. There seems nothing to wait in the KVM context
> here.
> 
> Why not just name the cap as what it does (i.e. something to indicate the cap of
> having the fault exited to userspace to handle), e.g. KVM_CAP_EXIT_ON_FAULT
> or KVM_CAP_USERSPACE_FAULT.

Because that's even further away from the truth when accounting for the fact that
the flag controls behavior when handling are *guest* faults.  The memslot flag
doesn't cause KVM to exit on every guest fault.  And USERSPACE_FAULT is far too
vague; KVM constantly faults in userspace mappings, the flag needs to communicate
that KVM *won't* do that for guest accesses.

Something like KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS?  Ridiculously verbose, but
I think it captures the KVM behavior, and "guest access" instead of "guest fault"
gives KVM some wiggle room, e.g. the name won't become stale if we figure out a
way to apply the behavior to KVM emulation of guest accesses in the future.
