Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA90D3FC7
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 18:17:16 +0000 (UTC)
Date: Sat, 11 Feb 2023 18:17:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676139434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N/Pf/v0NdU3twhv11oRMVuPWRZtmDGxVoirpuiLBTZ8=;
	b=Dch6PBorZoikpEn6EhKqUV76zHIfzbrZpfj4oEbDafVGoF9818U1pDyhk3QL3RVxXZmNOt
	BYunCGOM287GPH8ZdVbTEdFPtNY69aonM1bchy7O1c0UNnQvaohuQGQ0FyQ/p6TQ64qXaJ
	vNlyzKHB2Z2MJaKGXPboNTFLdAn+4Xs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 12/18] KVM: arm64: nv: Handle PSCI call via smc from the
 guest
Message-ID: <Y+fbpcGa9FOntVmJ@linux.dev>
References: <20230209175820.1939006-1-maz@kernel.org>
 <20230209175820.1939006-13-maz@kernel.org>
 <Y+do7RAm5PC8LFw2@linux.dev>
 <87pmaglcgw.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmaglcgw.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 11, 2023 at 10:31:59AM +0000, Marc Zyngier wrote:
> On Sat, 11 Feb 2023 10:07:41 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > This also has the subtle effect of allowing smc instructions from a
> > non-nested guest to hit our hypercall surface too.
> 
> I think we'll have to eventually allow that (see the TRNG spec which
> we blatantly deviate from by requiring an HVC), but we don't have to
> cross that bridge just yet.

Perhaps I'll continue to bury my head in the sand and act like you
didn't say that :)

I seem to recall that the SMCCC suggests either the SMC or HVC
instruction could be used if both EL2 and EL3 are implemented. So we've
messed that up too.

My only worry is if we open up the use of SMCs and userspace does
something silly in ACPI/DT and unconditionally picks SMCs over HVCs. The
VM won't get far on pre-NV hardware w/o EL3...

We could always just hide the presence of EL3 for non-NV guests :)

-- 
Thanks,
Oliver
