Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804635;
	b=DmPbS4vBdEOdeaJ2NzN5rBywVwOZKJxlGrVr6YrC+G8J+JFfSvwqBltvZNmuApkFxBR7
	 NJe1wmzlTdFJ2looIdtPFAQVRI9RMq4uqz4CPbtgsM6nSVATCPGQBcG+gHAO4IpQIKV91
	 j9DRbDV3fHMHn27KO0QZCFrC/h7cmj7ixoDFU+cpCooou6X13Wq8wHzyCwVJIAFuWn8rN
	 VmHAU3K588pBG/iB7xvyid6S/bgJnGucIb3DJjaA9cTqrv4ZaX+tED4rXNgmUW0vtcPTV
	 mGNlKoGhxdNAjxm6i48V/lQp+ZQ9LndPpnHWt8JSM9zGHdpYeImXzYRS042wkeVlesg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804635;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=D3RFMx/5mZgCj1sjqXMeEDTjXmhS8Qlkfoo1pL/LuME=;
	b=bUOSY9YlX/IrORahtGG+ahw1ZwG6g8pnSZ+bxj4+3TMj07zqoe5Bg3GG5RgNzVYHig+a
	 czOsWfFRoXF7Br9pfrvPSgp6YBjH1QMeyyasItptxTWGN81sM6h/6Cp/PzUGVGPXtSZWT
	 9PkAmh+RtJmSKsbAnmMSNkOOzcKwY2LRN28+J7Crm2PDQ5bab2yDuMMV3fek2ZA8cmf17
	 onl3ekEDgVDd2TXqBU0dXUakeeRYmrw3ghAMKl4Xq27PCUB0Y5BwxSODxixFtdAs2RRkg
	 s91oCi9XSgQSvTR5B5EXPhR4gb5bSlguOafvZvxeuweYXjsq5LKGQI5kvhsvAg19ysA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="vim/6tm3";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E084606A328
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 15:03:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E084606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vim/6tm3
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 046E51576;
	Wed,  4 Nov 2026 07:03:51 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAEE13F632;
	Wed,  4 Nov 2026 07:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793804634; bh=5ckB1l8xBYIth30jPzNDkUdK+ZATGGMmES9msLUO6Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vim/6tm3QVAPkQu3TR++tMGdFeDqwHHTn+AqYe5KY6IgwVh25h4Q9qEWLBGYIUrJ8
	 qYjfw5NVM3Qxg6h4R/MqbAxiAak+ze2M9Ye64aHiMSC9PQJxyXeX4KWAksKFOjytcL
	 lpmeDnH6VR1c48ov2Zixj3x3z7T8CSuLI+aw/+Qk=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 18/28] KVM: arm64: nv: Emulate CMOs via writable-clean translations as NOPs
Date: Wed,  4 Nov 2026 15:03:46 +0000
Message-ID: <autJUntFMhCoqZeH@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-19-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-19-oupton@kernel.org>
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
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026 at 01:56:00PM -0700, Oliver Upton wrote:
> Virtualizing FEAT_HAFDBS for an L1 hypervisor has a pretty large
> architectural deficiency by way of cache maintenance instructions.
> CMOs (e.g. DC IVAC) require write permission but do not set the dirty
> state on the descriptor.
> 
> There's no way to shadow a writable-clean translation in such a way that
> these CMOs pass the permission check and subsequent writes generate a
> permission fault. Worse yet, data aborts taken on CMOs do not have
> sufficient syndrome information to perform instruction emulation and
> trapping all CMOs is unpalatable.
> 
> So what do we do? Absolutely nothing. Treat CMOs to writable-clean
> translations as NOPs in anticipation of KVM only exposing FEAT_HAFDBS
> when the VM is fully coherent (FEAT_S2FWB, CTR_EL0.{DIC,IDC}={1,1}, no
> noncoherent DMA).
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c    |  4 ++++
>  arch/arm64/kvm/nested.c | 20 ++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7b29be33a1ea..a21b674a1981 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2548,6 +2548,10 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		}
>  
>  		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
> +		if (ret == -EAGAIN) {
> +			ret = 1;
> +			goto out_unlock;
> +		}
>  		if (ret) {
>  			esr = nested_trans.esr;
>  			kvm_inject_s2_fault(vcpu, esr);
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7dda95d37925..46fcc75f4c20 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1150,6 +1150,26 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
>  	} else {
>  		bool write_fault = kvm_is_write_fault(vcpu);
>  
> +		/*
> +		 * Plug your nose for a moment.
> +		 *
> +		 * Writable-clean translations are shadowed using a read-only
> +		 * mapping so KVM can set the dirty state on the L1 descriptor
> +		 * before installing a writable mapping.
> +		 *
> +		 * Certain cache maintenance instructions require a write
> +		 * permission check but leave the translation in a writable-clean
> +		 * state, meaning KVM is on the hook to emulate CMOs that use a
> +		 * writable-clean translation.
> +		 *
> +		 * "Emulate" the CMO as a NOP, as KVM only exposes FEAT_HAFDBS
> +		 * when FEAT_S2FWB is present and the I-cache is coherent.
> +		 */
> +		if (kvm_vcpu_dabt_is_cm(vcpu) && trans->writable && !trans->dirty) {
> +			kvm_incr_pc(vcpu);
> +			return -EAGAIN;
> +		}
> +
>  		forward_fault = ((write_fault && !trans->writable) ||
>  				 (!write_fault && !trans->readable));
>  	}

Maybe it's just to messy or plain wrong, but could we make the descriptor 
WC, then run the said DC instruction, then make it RO again?

I mean, maybe I got it wrong, but if we can't enable HAFDBS for the 
nested guest, as updating a shadow PTE from WC->WD would require us to 
take a fault to update the PTE inside the guest hypervisor, we could have 
the PTE as WC without risking it to be promoted to WD by hardware.

I am probably missing something.

Thanks!
Leo
