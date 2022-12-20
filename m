Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405A37E
	for <kvmarm@lists.linux.dev>; Tue, 20 Dec 2022 02:59:34 +0000 (UTC)
Date: Tue, 20 Dec 2022 00:06:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1671494814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=foi+cM9gEI1JlVJgipQwf5m4Su0pKjKEMr5jntc/8X4=;
	b=FEA5Zx40ThQP3Y+aileQBqtWae2jAdWjSK9yyTnmOMbwatS5Kprq0K0HMUDAPCinU4n1qd
	dMWsHrxEbTE/SD3HHfKK9dsdzUwrPFsaEj/4Fnc4/Zj+TXLgmqu0wcwLDEkwYmYnx64cIO
	3cvJSQ3d0B/XcfXFOPWRY7eBF6GsT08=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v1 10/12] KVM: arm64: Rework logic to en/decode
 VTCR_EL2.{SL0, SL2} fields
Message-ID: <Y6D8mYpSY0K8EGO4@google.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <20221206135930.3277585-11-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206135930.3277585-11-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221220000649.OXI_VLlpnj5AaWMvE7C8tWijiSZ6rJpsvF_JkwZVL78@z>

Hi Ryan,

On Tue, Dec 06, 2022 at 01:59:28PM +0000, Ryan Roberts wrote:
> In order to support 5 level translation, FEAT_LPA2 introduces the 1-bit
> SL2 field within VTCR_EL2 to extend the existing 2-bit SL0 field. The
> SL2[0]:SL0[1:0] encodings have no simple algorithmic relationship to the
> start levels they represent (that I can find, at least), so replace the
> existing macros with functions that do lookups to encode and decode the
> values. These new functions no longer make hardcoded assumptions about
> the maximum level and instead rely on KVM_PGTABLE_FIRST_LEVEL and
> KVM_PGTABLE_LAST_LEVEL.
> 
> This is preparatory work for enabling 52-bit IPA for 4KB and 16KB pages
> with FEAT_LPA2.
> 
> No functional change intended.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

Why do we need to support 5-level paging at stage-2?

A configuration of start_level = 0, T0SZ = 12 with 4K paging would
result in 16 concatenated tables at level 0, avoiding the level -1
lookup altogether.

--
Thanks,
Oliver
