Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8AE34E75A;
	Tue, 14 Jul 2026 10:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023958; cv=none; b=LBcCgCzKGj/v98OxgGjthfxAQCP1ui7kufIsBRYoVlKdxQjGA0tGsYipIAX5nv6PVydgqUxQQbwv1zpJhHbMXa3y/X1Y2xAAtDwJEAbhtIC5kZEKklH65X6/oXeF3gNfPNdg+S4MSMyRWbrZmi71wvy8oYPsr2MIN36N0wT/n6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023958; c=relaxed/simple;
	bh=uRFIUKB91+acCovv2cm5n8SkD2VKDIAFyiULog8T7+o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TMxH50wz9QOiqYQP5PjJPCO+r1kzJYEs5sgCvmMK1r7X5V9LGugPVG3i4s6rVrvO3uGgRJOGo1bqhZmom6WjlN80CtmBxbdNxSY9yeZo+Dq2/xwrx1r9i9Ri88UWCcGnHq8jwKcck/sLTt0py0GAMW/QDVRnc3Md33fFiB0T6pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYDKsps/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYDKsps/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905141F000E9;
	Tue, 14 Jul 2026 10:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784023956;
	bh=36rCKn92kmOANZrIMoXIwDoqPlfuHRRY0/IwYHlVuQE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DYDKsps/7nSp/JlDdez+fH+1Fczp7eYDD8BqaXibgnA2s4IRvjtLL+wmVNiOspKqF
	 sg4skwFCtL+ntRuLja178Z85VsXPzPAh1nDbavRWzQg/QEZ1305xjJjuCFJDhDJtrx
	 c9CoknEsmXmhzdPXh4qc/Kvyk5WoNhkjRkycRKc1Ier4Braa9O1mRacd841R6N0MdL
	 3yTKjBwKmBUpKE/NMsjzNpCRoG0G00rgXNycHnw+KzZWuUp5DrfpsQJUJqZBqNUd6d
	 MQgVyUWsJtt23HgwnAwcvlp92Fv60922jnnplV6ETFkafL48jq6n2gePOuPMCsg72p
	 I+dWRN1PLrK3g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/28] KVM: arm64: Relax CPTR_EL2 handling when
 FEAT_NV2p1 is present
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260714091641.1970822-10-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-10-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:12:36 +0000
Message-Id: <20260714101236.905141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Nested trap configuration for CPTR_EL2 is evaluated using a stale =
memory backing store under FEAT_NV2P1, breaking nested virtualization isola=
tion.
--

--- Patch [9]: [PATCH v2 09/28] KVM: arm64: Relax CPTR_EL2 handling when FE=
AT_NV2p1 is present ---
commit c67129a02beeb5d291611085a5d2f889ac9d97e8
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Relax CPTR_EL2 handling when FEAT_NV2p1 is present

This patch relaxes the handling of CPTR_EL2 accesses via CPACR_EL1 when
FEAT_NV2P1 is present, stopping the trap of CPACR_EL1. It modifies the
read path to use the hardware SYS_CPACR_EL1 register instead of the
memory backing store for CPTR_EL2.

[ ... ]

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6b47d936efb32..1dfc1f88bec82 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -326,7 +326,10 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, e=
num vcpu_sysreg reg)
>  			val |=3D __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
>  			return val;
>  		case CPTR_EL2:
> -			return __vcpu_sys_reg(vcpu, reg);
> +			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +				return read_sysreg_el1(SYS_CPACR);
> +			else
> +				return __vcpu_sys_reg(vcpu, reg);

[Severity: High]
Since this changes CPTR_EL2 to be read directly from the hardware register
SYS_CPACR under FEAT_NV2P1 (as the memory backing store can be stale without
trapping), will direct readers of the backing store now read stale values?

For example, in arch/arm64/kvm/emulate-nested.c:get_behaviour():

    val =3D __vcpu_sys_reg(vcpu, tb->index);

And in arch/arm64/kvm/emulate-nested.c:check_cptr_tta():

    u64 val =3D __vcpu_sys_reg(vcpu, CPTR_EL2);

Because the L1 guest writes to CPACR_EL1 natively without trapping, the
backing store is not synchronously updated. If an L2 guest traps to host
KVM, wouldn't these functions evaluate trap configurations using the stale
memory backing store, potentially bypassing the L1 hypervisor's trap
configurations?

>  		default:
>  			WARN_ON_ONCE(1);
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D9
