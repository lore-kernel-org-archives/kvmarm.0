Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D529D47277C
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251015; cv=none; b=WJLctQhZeQH5URCW7Af5anue0LtfKWW2kqlaurwv6YxXTHkelGphvm6GEO9BaGBH6q7YmCjSU0OJzAy29W0X02bEgC+WzTteEzKREi85kiGTSSNagmn2IGzpfWq4ielluq4+a0gedSho0SZd7yC5+Wr7fkCTPMB8uVVGQVvPa2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251015; c=relaxed/simple;
	bh=4eDTQFLAllYxwctxoYUjbgJ4B7eM0Ax1wh6lcTfsfgY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U3J6P9UIIbgSAzEYZj6/pmwWfnd28X6V5QecwXKPfj7W24McU3CIbWAGYRX9v1u6PG0yNAIoIsnMjzx2ewv5l7KE9h9UrslMF2VkA+Sg+bKmvtlDxqv6jQTD76qV4IDt6KbgQcWT4bgzr7XCjhl10WO9/HztTVjiQcN42pN/ekg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yjei86Cc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yjei86Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC681F000E9;
	Tue,  1 Sep 2026 08:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788251013;
	bh=w3cykyALRJo7i3RyU1j/wxukO4UDLOz4kciObDB1wK4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yjei86CczdhwptTCpnHljUbEIqhIeWh0kV2SoCGwu71Hu8H5egw2l2m7TCVa/0/sL
	 Wo+U8ImZ3q4ngKDGZYNU6nsslcP6yrY/Q2pyKvdm2/C7h1gNls8SjNRaNo2S8xwUWt
	 0xLcwDCqKpQpSlFHk6rdJH9YU3CuG8wMPhd2W/TBCeYtLUbsytn5UQ4bbWMSKzSusb
	 90ntjF9D6kQgzVsu7fLNvTCu2PSyf1M0s2Ra0eeMxnM5dNAR2h7KTseYLrcMJTpDwE
	 ECf2kgH8H1mnTuquRp12NiOM/Cc4RcUx8bPv1QeCcngIdLrLGv+AIMRs/s06Eg5zKH
	 O5amDg4SdfIyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/18] KVM: arm64: Filter out non-kernel addresses in
 kern_hyp_va
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260901080941.997769-12-vdonnefort@google.com>
References: <20260901080941.997769-1-vdonnefort@google.com>
 <20260901080941.997769-12-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 08:23:32 +0000
Message-Id: <20260901082333.3CC681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] The patch modifies `__kern_hyp_va()` to return non-TTBR1 point=
ers unmodified, allowing a malicious host to trick the hypervisor into dere=
ferencing EL2 private memory instead of host memory, completely bypassing p=
KVM isolation.
--

commit 1e2548767418379244f938decad822feafe32b7b
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Filter out non-kernel addresses in kern_hyp_va

This patch updates __kern_hyp_va() to filter out non-kernel addresses based
on PAGE_OFFSET. When protected mode is enabled, it returns the input address
unmodified if it is not a TTBR1 address, aiming to handle addresses from the
hypervisor private range.

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> index 6eae7e7e2a684..d89864c4b961b 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -126,6 +126,9 @@ static __always_inline unsigned long __kern_hyp_va(un=
signed long v)
>   * replace the instructions with `nop`s.
>   */
>  #ifndef __KVM_VHE_HYPERVISOR__
> +	if (is_protected_kvm_enabled() && !is_ttbr1_addr(v))
> +		return v;
> +

[Severity: Critical]
Does this bypass the mandatory translation for non-TTBR1 addresses, breaking
the guarantee that kern_hyp_va() always restricts the output to the EL2 lin=
ear
map?

Since the pKVM threat model treats the host kernel as an adversary against
hypervisor integrity and guest confidentiality, returning the address
unmodified could allow a malicious host to trick the hypervisor into
dereferencing EL2 private memory instead of host memory.

For instance, if a malicious host passes an EL2 private virtual address
(which is below PAGE_OFFSET) to a hypercall, is_ttbr1_addr() would evaluate
to false. The address would be returned unmodified, leading to potential
reads or writes in EL2 private memory.

Could this lead to exploitation in paths such as:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_tlb_flush_vmid_ipa() {
    ...
    __kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
    ...
}

In this case, EL2 could read out of bounds from its own private memory.

Similarly, during a hypercall like __KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_save_apr() {
    ...
    __vgic_v5_save_apr(kern_hyp_va(cpu_if));
    ...
}

Could this result in __vgic_v5_save_apr() writing hypervisor registers into
EL2 private memory, allowing privilege escalation from EL1 to EL2?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901080941.9977=
69-1-vdonnefort@google.com?part=3D11
