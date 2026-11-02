Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793647668;
	b=UvnuhZzL3F2khZkARSwds8D4B2Pwyzr2jmFLLtOLY85Rm2AnR00VC73oVu9C8OFv1dBr
	 YUf9UvAYCodtslfHuNq9I5OnsYnJrTW4VIZD361a6YKfMpTygyCfWRMwGaGqpf814R+ky
	 6ayfcH9kk8wB3RaB3gP7isV9Qg5vTesMzarsXj7+wb0TkEXi6rw+VTMF32KXflNz86jHJ
	 lY49X7a6V7ShAmdGCTxaeMtCjnADi9zLJ6JaDwJTQk4NXIW2E2G1Oni6qmq65yZykgGXW
	 XGzfSf8kbVd87CoOsxwf3C0muho79ykw2AO82YDbSZwltRHLye2XP/75lX4YbfUNOrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793647668;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=pf5mnv312thSQfR85MzimBrWC+L47vaGI/Xim2J2b1Y=;
	b=nda5uCUs4TBiU4Wrp6m5EyScodYajUD7vLLfd1x+AMVNOYibMSYrgKD0l8ES5px5YgM4
	 rebwm5HqBU4j8lbiuTh9DN6hqvRom3kIAGFoEA0zfUwQQRNS9+E9QgmDBpurezqyf/dpp
	 arZcmmSRfur75bTEB3gqoV0v0wPs1bukM+HLGygVt5iCzBDWZ7DLUi1IMlH44egHHkkWw
	 GU+7pZBM6dccgVPiZTIICb5ZPJ8r47KAKNEx5iZlnvONcIQaq/Wpz5g0/5oH9Z/FQqDKP
	 R/5YQwxEKsenGHPX0GvYTGT2Zw3Da4ZgsSO88HAqgCbX9p65KcEBVu6xIIZsKk1jBng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jGRoR1ET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36E9606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jGRoR1ET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3D31F00A16;
	Mon,  2 Nov 2026 19:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793647667;
	bh=pf5mnv312thSQfR85MzimBrWC+L47vaGI/Xim2J2b1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jGRoR1ETQLbTAOhLX+NItAiw0MtdHIAiUqMQ9DEbySqB38+jcDGhWsMBrgksp1mb2
	 3Lyw90eoGhi1jy+5yqlgI4Qm9dxwqs+hTFjB4Usrtz1St9Fh9tOMMBR9PA3/oswKI9
	 jzF4u/Unx0G2AA3iL07wuPpBdkn4M0sbajbWAukB0SfWxMpTBh9sIzwRgEpL+w6QZr
	 aJIMwTEvDEfghXkh9TUTCwm6EiVCNim1SxrXzhYPHiePtMYuHZokimiFHBDsBqXcw+
	 lb5XZZ2OG3tk26ibFnBIcoH06WFr22vLf+qkBM0R77d0Ols4PoI2s9aVnce04kX3hA
	 sGatS3MVQoHJg==
Date: Mon, 2 Nov 2026 19:27:41 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Ard Biesheuvel <ardb+git@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Don't livelock when AT can't resolve a fault
 IPA
Message-ID: <aujkLeo6QaiDMOv2@willie-the-truck>
References: <20261102094748.2638468-2-ardb+git@google.com>
 <auiXMN5td-2QlDkd@willie-the-truck>
 <CA+EHjTxVPyY70Dm+BiwgQQNwx1cJpEKvJBJGZWPCKLx2M8X2FA@mail.gmail.com>
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
In-Reply-To: <CA+EHjTxVPyY70Dm+BiwgQQNwx1cJpEKvJBJGZWPCKLx2M8X2FA@mail.gmail.com>

On Mon, Nov 02, 2026 at 03:57:51PM +0000, Fuad Tabba wrote:
> On Mon, 02 Nov 2026 14:17:10 +0000, Will Deacon <will@kernel.org> wrote:
> > On Mon, Nov 02, 2026 at 02:09:25PM +0000, Marc Zyngier wrote:
> > > On Mon, 02 Nov 2026 13:59:12 +0000,
> > > Will Deacon <will@kernel.org> wrote:
> [...]
> > > > > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> [...]
> > > > >  static inline bool kvm_hyp_handle_memory_fault(struct kvm_vcpu *vcpu,
> > > > >                                                 u64 *exit_code)
> > > > >  {
> > > > > -        if (!__populate_fault_info(vcpu))
> > > > > +        if (!__populate_fault_info(vcpu)) {
> > > >
> > > > Presumably we need a barrier (DSB?) here, to ensure that the TLBI happens
> > > > after the AT instruction?
> 
> I don't think the TLBI requires a barrier before it, because it
> doesn't matter if the AT's walk allocates entries after the TLBI.
> Anything it allocates matches memory, and the stage-2 descriptor the
> AT faulted on has AF clear, so that descriptor can't be cached:

I'm not sure that's relevant. The S1PTW case described by Ard in the
first part of his cover letter could look like this:

1. vCPU takes an S2 permission fault on VA 0x1000
	-> The permission faulting entry is in the TLB
2. Another vCPU unmaps a S1 page-table page used to translate 0x1000 from S2
3. EL2 does an AT S1E1R on 0x1000 as part of handling (1)
	-> Due to the uarch, this always walks the page-tables
4. The S1PTW from (3) faults at S2 because of (2)
	-> The AT fails

If we invalidate the TLB after step (4), then we will see the S1PTW
fault upon retrying the access that originally caused a permission fault
in (1). Without barriers, however, this invalidation could float up
between steps (1) and (2) and wouldn't be effective.

Now, having written it out, I think we would eventually resolve that by
replaying the faulting instruction a second time, but it feels odd to me
that we wouldn't just prevent this race once we know that the AT has
failed.

Will
