Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF317E
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 20:22:19 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id m6so14538192pfb.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Nov 2022 13:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xVkJZtEBpIeuzqQn3nnjuzEWSUM1mVqhj+nnH0c1tQc=;
        b=M4X/osJ6VqZpKNtuP99fp4hNhqecoTugRL5QfWaIhyUxA9c53vT2gzUsKKGIv4cq+D
         N4IonfyyypScYrsv8ODBCuTAKMU/o3MuedyC4XY7mQxji9pS70V0SKgDvwYFSfWhghQ5
         DSHIteFpQ5DT8H/yuhvbuDJ+aT14g2LOoyFC7UtDqZDOCQSYZGT07KnHz1DlHeril/bj
         KZ6lYlB1F8nR11PVom9zZllOxYKCdv33fJC9+NNvtrvNHgsPRLMmiaeyoIMyvL0/2rzw
         cm6ucLucJ1hX/EB3aXe+tUxGs+j1hQ/M65oNHUJ7CRlwtvLEnlMzSzEVZREE3HFHamlW
         wBrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVkJZtEBpIeuzqQn3nnjuzEWSUM1mVqhj+nnH0c1tQc=;
        b=h9xYBsH/qDrVDsWZ030b5lmUeiqyU0HdEjI5x3OuGxghndwtJUgTKcnHw6N+bWVXZ/
         mrk7IVSBaKifWk8NRhAWRTRIiWgTTCCt1veSh5Ku5X7K5lvHerfnl4eXyDWAL5QU1Tof
         vhBN10fLBkZPjASLdCE9X8XV62RRjn8lFlQstaGm+tbYrd8qaXyIgt6Mlvtee1doPRxi
         9Oj1npdwLi+ZjpFfebEGuyuhuejArT7MvtaT2z+hyGJ2cxi8h7BsuyeT2rmAEPPF/GN5
         aZoHfb7Jlmh53YvzXYbWceUllDPNRiQzB9mzslhAocT5PMjPxJX6xMD+yQvXKM8QDxFA
         acRg==
X-Gm-Message-State: ACrzQf0XO56vR3mWLYm6Kg7p4K4rnfuKqEITNPeC2rwvO69m/7YYdwXi
	6HlaIptpglGy1c+aOl1gRvt8vg==
X-Google-Smtp-Source: AMsMyM7fD/Ym5AIcfwQwPvEeDSThfT/5hUO484wIK3KagW5eWCNhPeqPpcfATaT8FOx4g4d/EWqTBw==
X-Received: by 2002:a05:6a00:2481:b0:56b:dc84:7ad1 with SMTP id c1-20020a056a00248100b0056bdc847ad1mr21687157pfv.43.1667334139000;
        Tue, 01 Nov 2022 13:22:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x5-20020a170902ec8500b00187022627d8sm6816709plg.62.2022.11.01.13.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 13:22:18 -0700 (PDT)
Date: Tue, 1 Nov 2022 20:22:15 +0000
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
Subject: Re: [PATCH v3 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y2F/96RnvGPompIC@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-9-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-9-oliver.upton@linux.dev>
Message-ID: <20221101202215.P7GcqTfm7tnAXno1ukGnUBwPL8nc_rqPhg6WzvkQXjU@z>

On Thu, Oct 27, 2022, Oliver Upton wrote:
> The use of RCU is necessary to safely change the stage-2 page tables in
> parallel.

RCU isn't strictly necessary, it's simply _a_ way to ensure readers have gone
away prior to freeing memory.  E.g. another method (used on x86 at least), is to
disable IRQs when walking page tables without holding mmu_lock, and then requiring
paths that free page tables to effectively do an IPI shootdown of all CPUs that
are reading page tables.

And "safely change" is misleading.  RCU doesn't allow safely _changing_ page
tables; if RCU did, then patch 10 wouldn't need to implement atomic updates.
Protecting page table walks with RCU is purely about ensuring readers have gone
away prior to freeing the backing memory, an entirely different mechanism is needed
to allow parallel updates, e.g. the CMPXCHG + KVM_INVALID_PTE_LOCKED approach to
ensure only one walker "owns" the detached page table.
