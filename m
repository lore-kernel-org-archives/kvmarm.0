Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BF47E
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 20:28:09 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id l6so14330654pjj.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Nov 2022 13:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Q15eoBQW+ndVdEuHxmdR78/VIpdRnCY/gFW79Q5++Y=;
        b=JeRquhbkLaWQ4VXS0ZlfxU7Y8+xIVGl1+LdsPQ0hWDUsemLo7dmNUjfVG3XeWtQ+q6
         anOYfFqBxLnv8zuKUeuNSfJC6yWnnwaRxxvd3gf+tr+sN4tRYQJ9BFAcNmM51Nmm1y4/
         Ve0qZkEVA5+q3F865yXWV2l795oQInHr6YQ8EVAoPWaVtZSXmHDvtUvYOs+L9jwDIpH4
         d9gFRlhhChEJbDnUVO+mCaISyg5Rc3dqgckgKei9ZJmBfo2vdA09RgkQPWFNRdICRIjW
         QZ+tYvfviZe8jTh+Aetu+CrTUVBHson3qov5eGJuvniXk3JfoUiJeCHNjzBEM33zQVat
         HCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Q15eoBQW+ndVdEuHxmdR78/VIpdRnCY/gFW79Q5++Y=;
        b=k7ZPS4AWN1ypvCy2nwkeV72fxmRQ7uC2xUC9UGKKvxixVrlf/8cq3rGTtjg4VjLMLU
         r85/iVAEOQjB76oZldtiOsjtRdnL2XjsaJrbzPzi3SYxhTPRmq5pY8rCSCvglM+PtHn2
         MtCHlWi7EX+yx8zcdH2onY377PYMHqPTpKR9sVJKOBniS8S9r/2Dn5fcaHR/bulS8316
         DAiaUIQSWrFDB8JQ658X0X8Dpdp0ZiCVhWbs4+WEHl3OFOgQ4p0EvXYfwwWKGFF4Kzx6
         voJDfJIbqzqrLhrhjnsK1utoB3bUK2rnnJPCscPdBZfm8ZKucwo7EOxW8nTOvdsdad7h
         JsXA==
X-Gm-Message-State: ACrzQf1NQIFoXTdNnrqaURfj8bk9imcBwIvhNw7vKUPbRC5i7vBX3kAC
	RSx0yVWWIkvx650fSviSXiSwBA==
X-Google-Smtp-Source: AMsMyM7rdaSOxuZbjzEc/VEG8h7kZQ83nH1qpB3jBULH8y8Ns8Rm2Ic8D29LJAQbjO7QhKZuDJvUsQ==
X-Received: by 2002:a17:90a:54:b0:212:eb01:1ce with SMTP id 20-20020a17090a005400b00212eb0101cemr39243143pjb.236.1667334488515;
        Tue, 01 Nov 2022 13:28:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090a1f0500b0020dd9382124sm6315783pja.57.2022.11.01.13.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 13:28:07 -0700 (PDT)
Date: Tue, 1 Nov 2022 20:28:04 +0000
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
Message-ID: <Y2GBVML5MWXZE9Na@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-10-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-10-oliver.upton@linux.dev>
Message-ID: <20221101202804.Dt3cgBL-IPC11r2Z7MO2r3BcSnGyKTj8IL_Zm7zamgE@z>

On Thu, Oct 27, 2022, Oliver Upton wrote:
> There is no real urgency to free a stage-2 subtree that was pruned.
> Nonetheless, KVM does the tear down in the stage-2 fault path while
> holding the MMU lock.
> 
> Free removed stage-2 subtrees after an RCU grace period. To guarantee
> all stage-2 table pages are freed before killing a VM, add an
> rcu_barrier() to the flush path.

This is _very_ misleading.  The above paints RCU as an optimization of sorts to
avoid doing work while holding mmu_lock.  Freeing page tables in an RCU callback
is _required_ for correctness when allowing parallel page faults to remove page
tables, as holding mmu_lock for read in that case doesn't ensure no other CPU is
accessing and/or holds a reference to the to-be-freed page table.

IMO, this patch should to be squashed with the previous patch, "Protect stage-2
traversal with RCU".  One doesn't make any sense without the other.
