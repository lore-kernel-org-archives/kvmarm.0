Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C843E1898ED;
	Mon, 24 Feb 2025 07:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740382821; cv=none; b=S4O4Ka4joVmtl4B5MCQROLhr/BuTnBVHhykfDug+W+OzhT4zrKcUkT6Sv0q33T3LMIjHLaS/ZnCvOeXya4BdLCPa+qkwgYojD3H3SNwHPd1ELGg/rfvrFOS8ThoqVN0xqlIt0EPr1AeLBU+Do4UjNIfk3Zdv3DKWPE7spMcWi/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740382821; c=relaxed/simple;
	bh=4CyLXJ2S1ic9X6I/59uuXieSdeweNmqD9gOdi7QuBSI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IdlmT7cCenWwMQc7uUEjsvsYHVMJ+q0pj+FWVuFX7uzKJSeIZktODatJrru0eFeXehn2EbxEQOaqkyP3rp68UuJN4MqAF9TFCHHDU3X8j3ZU+Exise/8gyHX4Ttb7vN8kryiW2iJ02b/aZJF0WJxefaYtZKEF80PKxquTsK00CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqZcH9au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqZcH9au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE27C4CED6;
	Mon, 24 Feb 2025 07:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740382821;
	bh=4CyLXJ2S1ic9X6I/59uuXieSdeweNmqD9gOdi7QuBSI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZqZcH9auEw6Dli9U1U7g3sQMuWokdauRl5alYlvCJJ042MaEgoyctxTUngyMV0ToL
	 rt3hIcq157CFTnnF5gu+w5OLV0y+NhQOzsAbWbq1FJ93TGPG2QUDV9HESrhqpEnq1i
	 JDTX6DtIWquO4L5ijwZhkmKg+fmy+DhoLt70Uh2LaM9JyN+hlwnfcxvXIeKz1wTd3k
	 qSIJgRtTQTaH3o4nwUdHiERzI3GaL4nF6Q+Zb2IeaKCgNg3z5/xxU+PFxrfXKZTLyp
	 NIoPZp7exYAJVjSpAEGckBykjW/JUBTyULzAkVB6L7qZbjOp8X5rwElt4BhtfnOCbM
	 n33ecCjg3mtqA==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 03/14] KVM: arm64: Mark HCR.EL2.E2H RES0 when
 ID_AA64MMFR1_EL1.VH is zero
In-Reply-To: <20250215173816.3767330-4-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
 <20250215173816.3767330-4-maz@kernel.org>
Date: Mon, 24 Feb 2025 13:09:30 +0530
Message-ID: <yq5aa5abhjv1.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Marc Zyngier <maz@kernel.org> writes:

> Enforce HCR_EL2.E2H being RES0 when VHE is disabled, so that we can
> actually rely on that bit never being flipped behind our back.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 0c9387d2f5070..ed3add7d32f66 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1034,6 +1034,8 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  		res0 |= (HCR_TEA | HCR_TERR);
>  	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
>  		res0 |= HCR_TLOR;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
> +		res0 |= HCR_E2H;
>  	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, IMP))
>  		res1 |= HCR_E2H;
>

Does it make sense to check for E2H0 if MMFR1_EL1.VH == 0 ?
Should the above check be
	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
		res0 |= HCR_E2H;
	else if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, IMP))
 		res1 |= HCR_E2H;



>  	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
> --
> 2.39.2
