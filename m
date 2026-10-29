Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793265799;
	b=Kkyqfi8e4SFY3bXSLl3Lpr1Kht0fmz7Yequ0RD12k4Wa7fSoInV2DbQUZlSB6YX1HFWz
	 MtO9LGdq4WlQnckbubu7tdemtSqRB/Nd1x5cinTar9gbQABTRSZAm+6pzZRNIjCYFrzu1
	 veOLW/6ppY1t2oEmR50evgHDwStdTX4vLO3r1+NTsKRc8Tbn3C2wSeb8y4clWgz7vEuwq
	 kOEu5hokndjQpbu10mh+chU7fonbqlaeNfx856QM+TLB+5CqV1GtBygKpDrKLg5OmU7Qt
	 04RI7u2znr93xvbsura7cbSqEiPOyXedRKo9BtP5iWK2Zz/tIPqplVmQmO1vBLdZFiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793265799;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=068RARPUhpeNt5cdqdcKQHksPIpTlxwfCKWl/O6RHkI=;
	b=szCxsrTU3gLshW+eihJPdbTpiLWiF7IrbRw38qxZP3T9jojXRVvEmmcjpIczuRSoEFDZ
	 IH7LnaITE+l1GHjPhM6OMgcYjLdKNCQYGCI/vo88a8eSFzyFi/vHbHjP1Z8xT8pJ1kRrG
	 395iFgBLI2DjLhwbtnndYQb87PHpfHRI9TpDWLZPyj1IWWbOYN6JrjofZcjThIu4u4vqw
	 NLd/hf7LpEUuI1lGs0KZCsUs/RFj8dZB/O5O41Jd32e5aZ4vOrHqBXoXwrT35Ic7jrzS5
	 TW7Ajdh7Wz8yTAQybzlGuQPZGqGpBWHTEKzbmvTntWpAoHMGGBi155AUkMtYMj/rLwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hl1arTt9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842BD606A337;
	Thu, 29 Oct 2026 09:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hl1arTt9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD8C1F01828;
	Thu, 29 Oct 2026 09:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793265799;
	bh=068RARPUhpeNt5cdqdcKQHksPIpTlxwfCKWl/O6RHkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hl1arTt9CLQDGptJengrqjKeO/CbPgOOLiN0GgPZ7OP4SrH7yv69hn2BZ34ibZZwj
	 riXpYoM6I7ebc+BptLTZeaRG7HPvOiI7ypiF7RnGaJYpob/awILhwuT+sImxbOe6UF
	 qYoRY4rkNJZwdYscvantXBkx955C6gZRNdUMyFT4mL8drqL/cIU3tKGSL8bSi79ePp
	 5OY1HcF0rrk+nenDrPIkt8RJtvjagARti6Yb2PcMcCcuPPgzhiMgJ0L+SppbT/MfEd
	 vdI2ObMITkJLxiG+cvBt6R549iZoEjWaqKaoKDmmVF1xhbTJhAZHJTEt7estahfIiB
	 JrzzBODm+DPYA==
Date: Thu, 29 Oct 2026 02:23:17 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: xuheng@cs.columbia.edu, maz@kernel.org, qperret@google.com,
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Add an ISB after mapping a hyp fixmap slot
Message-ID: <auMQhSmxIm5JMftF@kernel.org>
References: <20261028-fixmap-isb-v1-1-6c9f0f9cb810@cs.columbia.edu>
 <20261029085414.2279900-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029085414.2279900-1-fuad.tabba@linux.dev>

On Thu, Oct 29, 2026 at 08:54:14AM +0000, Fuad Tabba wrote:
> Hi Xuheng,
> 
> On Wed, 28 Oct 2026 23:02:10 +0000, Xuheng Li <xuheng@cs.columbia.edu> wrote:
> [...]
> > A litmus test of the same shape (map the slot, DSB ISHST, load through
> > it) faulted on a Cortex-A72 in 2 out of 100M runs.  Arm's herd7 model
> > with -variant vmsa also allows the fault, and forbids it once the ISB
> > is added.
> 
> nit: it would help to have the litmus test itself in the commit message,
> or as a commit note, so the herd7 claim can be checked. Here's the one I
> ran (herd7 7.58, -variant vmsa): "Sometimes" as below, "Never" with an
> ISB after the DSB, and "Never" without the ISB under -variant vmsa,ETS2.

Maybe I've been conditioned at this point but doing DSB; ISB to consume a
translation after setting it up seems pretty straightforward. Especially
since we don't care about ETS in the kernel at this point.

IOW, I'm not sure what additional detail the litmus test buys us.

Anyway:

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> 	AArch64 fixmap-noisb
> 	{
> 	 [PTE(x)]=(oa:PA(x), valid:0);
> 	 0:X1=PTE(x); 0:X2=(oa:PA(x)); 0:X3=x;
> 	}
> 	 P0           ;
> 	 STR X2,[X1]  ;
> 	 DSB ISHST    ;
> 	 LDR W4,[X3]  ;
> 	exists (fault(P0,x))
> 
> FWIW, the result matches the ARM ARM (B2.3: without FEAT_ETS2, a DSB ST
> doesn't order an earlier store before a later translation table walk),
> and emit_pte_barriers() in arch/arm64/include/asm/pgtable.h has the same
> dsb(ishst) plus isb() after making a kernel pte valid, for the same
> reason.
> 
> [...]
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Tested in protected mode on QEMU, booting a protected and a
> non-protected guest, and on an Apple M4 (nested virtualization),
> booting a protected guest. No regressions.
> 
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Cheers,
> /fuad
