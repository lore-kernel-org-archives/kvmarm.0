Received: from out-141.mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BAFAD5D
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 19:06:12 +0000 (UTC)
Date: Fri, 3 Feb 2023 18:49:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675450192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wN4paWkwXIa3CFgztXV8SjaEAKuP+2RoDhhtXu4cIuU=;
	b=jO6B/3uutUTT+e3ZPGeCi9N2WzRphHCd8Zvt0BZnk3yz3hqj0/QgdlY4HYzBqDa7nYVYR4
	y3EIPzceLl6k9iZPGNf8CLHnL6iIYKEUTXzCerI9p/kEgRr/r62o7EW1USVsS6OZnqey0/
	4+MyUYmWm61ViF9E8I8/vrzR7q8kJ1Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: shahuang@redhat.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <linux-arm-kernel@lists.infradead.org>,
	"open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>,
	"moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <kvmarm@lists.cs.columbia.edu>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Remove redundant setbuf()
Message-ID: <Y91XSZaRyqJjsg8o@google.com>
References: <20230203061038.277655-1-shahuang@redhat.com>
 <Y91VV+WWrakREsN6@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y91VV+WWrakREsN6@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 03, 2023 at 06:41:27PM +0000, Sean Christopherson wrote:
> On Fri, Feb 03, 2023, shahuang@redhat.com wrote:
> > From: Shaoqin Huang <shahuang@redhat.com>
> > 
> > Since setbuf(stdout, NULL) has been called in kvm_util.c with
> > __attribute((constructor)). Selftests no need to setup it in their own
> > code.
> > 
> > Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks!

> Oliver/Marc, want to grab this one?  I doubt there will be conflicts, but IIRC
> there are a handful of in-flight changes for aarch64/page_fault_test.c.

That is indeed the plan.

Applying patches for arm64 has taken a bit longer because I don't
yet have push access to kvmarm so I need Marc to pull from me. The net
effect is emailed thankyous are delayed by a few days, but that wont be
an issue going forward.

-- 
Thanks,
Oliver
