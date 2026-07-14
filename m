Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D8936921E;
	Tue, 14 Jul 2026 09:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022373; cv=none; b=KlPA1bChHyJg6BRBydpb7b3NXj6ZvXHgTVucN+JoyCf1S+jaj9mVVsk9njc3FZI9pgz0bYjxkn85we8v/LtsDYnYUC7QSITqBQrZy5aKxF/DrmnJ94qhEKIMmyIVBeuVe5ER1FI507QLeXSX+7JXp9mJQtdYPh9XHnsYKYH9T1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022373; c=relaxed/simple;
	bh=nd3tXWs2bLq8vphZEYWHzpKam+fxUz8CzZZzLOajrWo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UvhsUPOIBVhQVI2GRA8C1VDFYmylLiA11kbjiiO7/6uJeGcCJ9jXYD4X3UQudcTU8mfr3vexAI5GBhWjvNlswnlcg8rvw0vaImGJF1kT2PUGRobqQA/WlFXkcefBosJu/IQ1Mq5Z4kiHia1PoIqzhSH2pdE5p3WOH/FxUp3iwBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFPaaBuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFPaaBuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACD11F00A3E;
	Tue, 14 Jul 2026 09:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784022369;
	bh=gUC8fxJDGNOaiW1RXvIHxFL1gk2RrPcTibctzVPs0tE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eFPaaBuODlmmxos/roycZykNJ5cbQLXNIGMzj4XetPejyHM9DsUagMEk4OYp2jMav
	 V05qwUG2xs26kjIfBX2+wSZH7ix9/zoDIkBNKPuWU3wsZ4B3vEAfP6fXoPpwJlceeh
	 2mkJd8O8H9a/mokZV8wFsCBByXwzhP9tk91/cQXZooZ/ByoOC5xcxMpLhd9KO++yB/
	 aa99Zttn2RpWb7zYuSbSuYHDI9j9pXaROjVQ0tAuyBw4FoHdwLKA0ENUu/1QouIKWa
	 ap4lZFrgd89VoLtDhZVFEvtwv4JVAerceOt0DgrAtgiPKwFD1GQOFfaEbuLYLpsfgf
	 qSlaoJAl4Myvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/28] arm64: Add FEAT_NV2p1 detection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260714091641.1970822-13-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-13-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 09:46:08 +0000
Message-Id: <20260714094609.4ACD11F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing immediate Context Synchronization Event (isb) after writ=
ing to control-plane system registers cnthctl_el2 and cntkctl_el1.
--

--- Patch [12]: [PATCH v2 12/28] arm64: Add FEAT_NV2p1 detection ---
commit e272e43dc6ce85d3337902d78430aad6bf5b83fc
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Relax CNTHCTL_EL2 handling when FEAT_NV2p1 is present

This commit relaxes the handling of CNTHCTL_EL2 when FEAT_NV2p1 is present.
It removes the need for a split approach to access bits and instead relies
on the normal CNTKCTL_EL1 accessor.

> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 4155fe89b58a1..db60facad9f3c 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -876,8 +876,14 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, s=
truct timer_map *map)
>  	assign_clear_set_bit(tvt02, CNTHCTL_EL1NVVCT, clr, set);
>  	assign_clear_set_bit(tpt02, CNTHCTL_EL1NVPCT, clr, set);
> =20
> -	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
> -	sysreg_clear_set(cnthctl_el2, clr, set);
> +	/*
> +	 * This only happens on VHE, so use the CNTHCTL_EL2 accessor, unless
> +	 * we are sure CNTKCTL_EL1 is completely stateful with FEAT_NV2p1.
> +	 */
> +	if (!cpus_have_final_cap(ARM64_HAS_NV2P1))
> +		sysreg_clear_set(cnthctl_el2, clr, set);
> +	else
> +		sysreg_clear_set(cntkctl_el1, clr, set);

[Severity: Medium]
Does this code need an immediate context synchronization event after writing
to these control-plane system registers?

Modifying cntkctl_el1 (and cnthctl_el2) via sysreg_clear_set() expands to a
conditional write_sysreg() without an immediate isb() barrier. The function
returns immediately after, which may allow intervening instructions to exec=
ute
with architecturally undefined pipeline state before a context synchronizat=
ion
event occurs.

This path is reachable during normal VM execution when loading vCPU timer
state. While the cnthctl_el2 write is pre-existing, the cntkctl_el1 write
was newly introduced here, which could introduce a regression.

>  }
> =20
>  void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D12
