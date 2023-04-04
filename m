Received: from out-46.mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7080C942
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 18:51:05 +0000 (UTC)
Date: Tue, 4 Apr 2023 18:50:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680634264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zjskJ/+K4RYnRGaiw8Qyw6yBk5pv87S2MCPATkCEId8=;
	b=RU0QINMpSErQ04BD1mGX/o9p8yR/QvrVf5TAqJ+B0pLUCxlNxu1B7R7LkVkoP7JGYL7LUz
	jEfaLi/d/MEkINFRhOVJnkIsMAYSrvpbp62YYwIAXojJutdmnhHH5FrTjB/EC2SDr4zovx
	evYXQ5F9H+NtK4KK+RTsFefQZk43INQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
	Ricardo Koller <ricarkol@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/7] KVM: arm64: Add FEAT_TLBIRANGE support
Message-ID: <ZCxxklWzAz9K+aOP@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-3-rananta@google.com>
 <ZCTjirkCgBkT65eP@linux.dev>
 <CAJHc60y1BLQC4c0qXCuqF7JfewBC_fG2xuH0Wj0AHJh9x3CK5g@mail.gmail.com>
 <ZCxvXq0dftq/Szra@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZCxvXq0dftq/Szra@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 04, 2023 at 06:41:34PM +0000, Oliver Upton wrote:
> On Mon, Apr 03, 2023 at 10:26:01AM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Mar 29, 2023 at 6:19 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > +     start = round_down(start, stride);                                      \
> > > > +     end = round_up(end, stride);                                            \
> > > > +     pages = (end - start) >> PAGE_SHIFT;                                    \
> > > > +                                                                             \
> > > > +     if ((!system_supports_tlb_range() &&                                    \
> > > > +          (end - start) >= (MAX_TLBI_OPS * stride)) ||                       \
> > >
> > > Doesn't checking for TLBIRANGE above eliminate the need to test against
> > > MAX_TLBI_OPS?
> > >
> > Derived from __flush_tlb_range(), I think the condition is used to
> > just flush everything if the range is too large to iterate and flush
> > when the system doesn't support TLBIRANGE. Probably to prevent
> > soft-lockups?
> 
> Right, but you test above for system_supports_tlb_range(), meaning that
> you'd unconditionally call __kvm_tlb_flush_vmid() below.

Gah, I misread the parenthesis and managed to miss your statement in the
changelog about !TLBIRANGE systems. Apologies.

-- 
Thanks,
Oliver
