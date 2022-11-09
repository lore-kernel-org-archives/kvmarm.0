Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FA7107B9
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 21:53:50 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id y13so17937265pfp.7
        for <kvmarm@lists.linux.dev>; Wed, 09 Nov 2022 13:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OjtTll63kEDv75PwR7o0lnOxIMI339azC+QX7bn1Io8=;
        b=ZO89qv+qCkNp/HiQ4Q6ZJHGSsutpkVQ0xhTCiLfOk0GkhfFmwFuMtZN/Ed/uuBdDsm
         b4X5XeR59abjiW7lNZ1Z9sR8LJFUsx+a9B2SHUeRRp6/cYrXLpoetVMHXFuCgwZAQnqE
         pZ/BWXqM7bIWHIcqAXTSDbjGG1ERbeFNTk0Y4PtVgfNcm9PuSJ9sfiFrUcEyBLE9HlM8
         QkMLkRFVrLYk5OZ84sNAclJOw5/83UK4EKX6nFYv+wTNUyqxRuFtrezzGGJav2rHU/CN
         Zf6bz4ZbCHT13Hi9brY3D91Fmcisb7qCwzTNns0F2mJxXzQkAu6FEZ58AeO8lHDoc3Oi
         RJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjtTll63kEDv75PwR7o0lnOxIMI339azC+QX7bn1Io8=;
        b=01oy6zdqApuFGPxvoI1WOhgdWGdApa6JkU+cSV1DUC/KXmu2FnGn7aSaiqZ3eY8UDe
         /Zx9IPVrt0Wo/Xedd2hBYIqwt1HDO+Pbn1b3lbKVWDmXpkrVdXFehSsDm4iUanw0300h
         sJGGCX9mlpVkdlHvlsSF+/TRQaktmNt2JNrHdCUy+0ZjElK1x7AngHh73ItEarzpwy42
         IWp0I0vFPxnu0vVGyni0B7ZrdBe5P99MphyWQHIEsv8RVovtMxSnqwDp/I3M1NB1FG7t
         M1ZH5mjSWgg1/3C9kaWvdNqPesoVFvxh1gJTdPrR9dreay209JFrIvRtffEYMsNS7H6i
         /lAQ==
X-Gm-Message-State: ACrzQf1piRH46wHKiQY00kwTj7tqgs33yH4BSCQu9xIllaSca7YqGbZv
	Bx1xtO40m/PmUZj/ja4aQ0fBWw==
X-Google-Smtp-Source: AMsMyM405OCKBpJo33fzWng4KuCQaVeCIAwiX562TxX4BcFcitQF+k78e7DEu09G23/oE/uOT0+mjQ==
X-Received: by 2002:aa7:859a:0:b0:56b:d76d:8c76 with SMTP id w26-20020aa7859a000000b0056bd76d8c76mr61634658pfn.77.1668030829526;
        Wed, 09 Nov 2022 13:53:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902da8c00b00186b04776b0sm9672086plx.118.2022.11.09.13.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 13:53:49 -0800 (PST)
Date: Wed, 9 Nov 2022 21:53:45 +0000
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
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y2whaWo3SIOOMKOE@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107215644.1895162-9-oliver.upton@linux.dev>
Message-ID: <20221109215345.Ed-rS_LJdikT4QJIAh6Pm_MIQ2XDmiOS-WLejjGxVqI@z>

On Mon, Nov 07, 2022, Oliver Upton wrote:
> Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> release the RCU read lock when traversing the page tables. Defer the
> freeing of table memory to an RCU callback. Indirect the calls into RCU
> and provide stubs for hypervisor code, as RCU is not available in such a
> context.
> 
> The RCU protection doesn't amount to much at the moment, as readers are
> already protected by the read-write lock (all walkers that free table
> memory take the write lock). Nonetheless, a subsequent change will
> futher relax the locking requirements around the stage-2 MMU, thereby
> depending on RCU.

Two somewhat off-topic questions (because I'm curious):

 1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
    faults (handle_access_fault()) and/or write-protection faults without acquiring
    mmu_lock?

 2. If the answer to (1) is "yes!", what's the plan to protect the lockless walks
    for the RCU-less hypervisor code?
