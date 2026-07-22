Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468A93E3C74;
	Wed, 22 Jul 2026 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710667; cv=none; b=d7ivAcfwov+4m9QDI6nV2/uHmlvo/60VJg1Oix3e9ZE80Xh3bOlpSqxsq08KAGtjzaQHmwrXWseMtucjlZK/+BsfzVsSSFaFnNTF9t7FyhxAzIMF1UAC/LoMh/oSPfrXCoIFALNQZzQ+uQ/xHxxxNwo8MaTKpvPp30o5DJXMVLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710667; c=relaxed/simple;
	bh=dYrWsqi3jQXfS9NppbvOvoWrjISxFr0fMVK5iLVhDkQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m2kORKrnRK6c3JdJAXYHbXaePu7bfbUOod5uPz3ohv1RH97gZiEU+4g0c7r+1X/yJHI3GxZYL+hvWfUWnNvCrpdZEWPuZaqlLXBtuT95uIk0hwRobWV0kJbnBg5XIXJ9PvjwzRel5qhExmR3ziL6k7baoYqEFgJCFtpxtK4SoFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2k+NrNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2k+NrNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911F01F000E9;
	Wed, 22 Jul 2026 08:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784710665;
	bh=Lr0G7ubvpshMW+y1cFhAs6kS1pzY/Z/rnO465y+rg14=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F2k+NrNlvug/HtGEhBZqiNeCHRExCUuGZ7qN9Ofxr1/c9hmFMsTOm0suXmUgSBC/4
	 8Iq6A9ohku0+epAIu3oYBKo/bwZPjRD56V0fAKM/kdffUmYY5gFnm6uq9hoRcqT4Dm
	 g0pe9m/Ju3gl/wPD3lS0/7K2m2Qpm07ewXqU0toDq8cpm2LY1xWMJl0cyHpboD+zCn
	 EC89InzNbTxoGUybzvbwlXaUiHaZFxha+Q6u1ovEH4T3DLUL7g3LDwPb3GWjkH8B0j
	 xE/1t9YVRDN4+5GzwDY17ylRnC4cniENs/NjbaMGcegBsjIlPODPYq0WBxmUO5zY7x
	 htT7IGCQtjOkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 25/28] KVM: arm64: Engage NV3 TLBI trap elision
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260722074234.3330999-26-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-26-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 08:57:45 +0000
Message-Id: <20260722085745.911F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Stray double semicolon creates an empty statement.
--

--- Patch [25]: [PATCH v3 25/28] KVM: arm64: Engage NV3 TLBI trap elision -=
--
commit dabbb189ece66c0128f9610303e005d9bdd94252
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Engage NV3 TLBI trap elision

This commit enables NV3 TLBI trap elision for guests that are not NV2 aware,
relaxing the TLBI traps when only the guest's S1 translation is affected.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
[ ... ]
> @@ -715,6 +715,19 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vc=
pu)
[ ... ]
> +			if (!kvm_has_nv2(vcpu->kvm)) {
> +				vcpu->arch.hcrx_el2 |=3D (HCRX_EL2_NVnTTLB   |
> +							HCRX_EL2_NVnTTLBIS);
> +
> +				if (kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> +					vcpu->arch.hcrx_el2 |=3D HCRX_EL2_NVnTTLBOS;;

[Severity: Low]
This isn't a bug, but there's a stray double semicolon at the end of this
statement.

> +			}
>  		}
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D25
