Received: from out-9.mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8376DA34
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 18:46:44 +0000 (UTC)
Date: Tue, 4 Apr 2023 18:46:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680634002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6CCFZGbCbuQhOOVHvrtx2gWbSjOe3K33umxalnr28II=;
	b=iF+v2Q68XT8lGFaQ4gn2l9SacXhFLr07nAJDyI5xvBIPSL79kEpsGE78SUdsCLk2SYEpOH
	gNbkgNenyyOrqioed/7OY2lIcm+le6m6u0QuxKJDhvHEj9Xw6GN6Ra+PNeP5zXqchAsBTF
	60qSwNES7H8nO1iMtQr+iEogRX+FYxU=
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
Subject: Re: [PATCH v2 3/7] KVM: arm64: Implement
 __kvm_tlb_flush_range_vmid_ipa()
Message-ID: <ZCxwjYf+EjuB64iH@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-4-rananta@google.com>
 <ZCTe5koj8fOgbrYO@linux.dev>
 <CAJHc60x-ZHN=ZQemZp0wkj5jp-Ys8024YDQmWhmKn3NgZ0HHCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60x-ZHN=ZQemZp0wkj5jp-Ys8024YDQmWhmKn3NgZ0HHCQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 03, 2023 at 02:08:29PM -0700, Raghavendra Rao Ananta wrote:
> On Wed, Mar 29, 2023 at 5:59 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Mon, Feb 06, 2023 at 05:23:36PM +0000, Raghavendra Rao Ananta wrote:
> > > Define  __kvm_tlb_flush_range_vmid_ipa() (for VHE and nVHE)
> >
> > bikeshed: Personally, I find that range implies it takes an address as an
> > argument already. Maybe just call it __kvm_tlb_flush_vmid_range()
> >
> Hmm, since TLBI instructions takes-in a variety of ranges, VA or IPA,
> I just thought of extending the '_ipa' to make things clear. Moreover
> it aligns with the existing __kvm_tlb_flush_vmid_ipa(). WDYT?

Like I said, just a bikeshed and it seemed trivial to eliminate a token
in the function name. FWIW, you're dealing in terms of the IPA space by
definition, as a VMID identifies an IPA address space. Range-based
invalidations by VA would instead take an ASID as the address space
identifier.

-- 
Thanks,
Oliver
