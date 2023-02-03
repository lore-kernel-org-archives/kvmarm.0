Received: from out-106.mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A1BA31
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 21:16:25 +0000 (UTC)
Date: Fri, 3 Feb 2023 21:08:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675458492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zF794bsssBgYs01gtLHUkS28EIicNc0l0YnvFt/94YI=;
	b=gF+Ot9L7bvkYWgstVlN3IGR5gepXbOhnLUW+ryxf0GGE8OvgoAe8gh4332GPCHIBnUEDfl
	OstQTXxU52klLCCbGsxtBPABUoe9zoYwljDknwyOPX3XqLcs69d34u9p3+onFADs6Ko7Qx
	oTbdNErPix3LGrijaxdz/cn1jgoVGFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Morse <james.morse@arm.com>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Borislav Petkov <bp@alien8.de>,
	H Peter Anvin <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Len Brown <lenb@kernel.org>, Rafael Wysocki <rafael@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Salil Mehta <salil.mehta@huawei.com>,
	Russell King <linux@armlinux.org.uk>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [RFC PATCH 29/32] KVM: arm64: Pass hypercalls to userspace
Message-ID: <Y913sIqWxmf4O5oG@google.com>
References: <20230203135043.409192-1-james.morse@arm.com>
 <20230203135043.409192-30-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203135043.409192-30-james.morse@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi James,

On Fri, Feb 03, 2023 at 01:50:40PM +0000, James Morse wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> When capability KVM_CAP_ARM_HVC_TO_USER is available, userspace can
> request to handle all hypercalls that aren't handled by KVM.

I would very much prefer we not go down this route. This capability
effectively constructs an ABI out of what KVM presently does not
implement. What would happen if KVM decides to implement a new set
of hypercalls later down the road that were previously forwarded to
userspace?

Instead of a catch-all I think we should take the approach of having
userspace explicitly request which hypercalls should be forwarded to
userspace. I proposed something similar [1], but never got around to
respinning it (oops).

Let me dust those patches off and align with Marc's suggestions.

[1]: https://lore.kernel.org/kvmarm/20221110015327.3389351-1-oliver.upton@linux.dev/

--
Thanks,
Oliver
