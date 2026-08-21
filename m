Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F4C24B28
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 06:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787295464; cv=none; b=e7zsvfhTaKhzWzW0MURmDhk159mzdMKFViQesdgF7+6TEnF0DDQDkPApQeDyBY+U1QabrPBzJ+gc+BzoN5Z8mSa3Pu6BlKZGlpKaRKid/lpP2Y67CnqpXf43SR/UPW6kpjjcr2YdOL5v/m5xDIw4dqGyS+7XNpSPOkoqgMB6obw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787295464; c=relaxed/simple;
	bh=5TCa2RxAc5/lS6VjpL0qdg+u5LznS1afeBIeKamLULs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LMwNYGoh+CnmMoc1muucfaDsZpz9mBMRw4VBq7gLzG/4l7Hwzipdk34YCym9dJGK5ag/ykbBt1ecqNv+R/lTdS1Bi7eO5P65Koy/OYkmxW65qiNe2UdqgJFniWdTB+TyOj5qcl5q9cacSG5fGwZLUHlS9vcNmjxPTi5ZKvB+eXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dirAs6U6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dirAs6U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3563C1F000E9;
	Fri, 21 Aug 2026 06:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787295463;
	bh=XNqPC/6O7Fpi55hHwWW/GDg0oTaXf7E/oMs+/u5cD5E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dirAs6U6EU4QKbeuawVvEwOxwGHNYSkKiuPfTbJAj8JzyBjOVo5f5OmTz534iuXRX
	 nEYpU6phJI4Z+HHnehT28qczC9LbO0eD05IKVRpc04cHhCopVLrwl2qVPGOlEt6LUR
	 NtobkI6HyTFk5t5Q9MeRJD7ON6T+6Hnm174PrjKZo6BPL+4cGIzrLJJuW5FWPnezuA
	 8RAXphArE1crrcAtn3AOfHkE68aOPm2F4lIbDH8X1dTaGKWAkH1EeP1mQerwqY36CL
	 NvEwI3pDD64nEbLAiauE0Pj0KYyJe0hpQa0ZrZFYFgXrdkjgZdRqPFfDCWW+TaQf/x
	 nkfih/eZA0ePA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic-its: Free the caches when
 GITS_BASER changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260821064445.615838-2-fuad.tabba@linux.dev>
References: <20260821064445.615838-1-fuad.tabba@linux.dev>
 <20260821064445.615838-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 06:57:42 +0000
Message-Id: <20260821065743.3563C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing race condition in ITS MMIO handler allows MSI injecti=
on while ITS is disabled due to a stale translation cache entry.
--

--- Patch [1]: [PATCH v2 1/4] KVM: arm64: vgic-its: Free the caches when GI=
TS_BASER changes ---
commit 98c89973da07ed23e9bd8348bfd2cf61333c4e66
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: vgic-its: Free the caches when GITS_BASER changes

A guest that disables the ITS and changes GITS_BASER<n> with VALID still set
keeps the mapped devices and collections. This patch frees the list and
drops the translation cache whenever the stored value changes.

Link: https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 9e782a4fea7e5..ab89b0138efd0 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c

[ ... ]

> @@ -1702,6 +1705,8 @@ static void vgic_mmio_write_its_baser(struct kvm *k=
vm,
>  			vgic_its_free_collection_list(kvm, its);
>  			break;
>  		}
> +		/* A concurrent injection may have cached a translation. */
> +		vgic_its_invalidate_cache(its);

[Severity: High]
This is a pre-existing issue, but the commit message explicitly notes that
an injection can still cache an entry after the ITS is disabled.

Is it possible for a subsequent MSI to trigger an unexpected LPI injection?

If Thread 1 (e.g. irqfd) calls vgic_its_inject_msi(), takes its_lock, and
enters vgic_its_resolve_lpi() in arch/arm64/kvm/vgic/vgic-its.c, it reads
its->enabled as true.

If Thread 2 (guest vCPU) concurrently disables the ITS via
vgic_mmio_write_its_ctlr(), it acquires cmd_lock (but not its_lock), sets
its->enabled to false, and clears the cache.

Thread 1 could then resume, finish resolving the LPI, and call
vgic_its_cache_translation() to insert the entry into the cache, ignoring t=
he
fact that its->enabled is now false.

A subsequent MSI would then hit vgic_its_inject_cached_translation(), which
does a fast-path lookup without checking its->enabled, successfully injecti=
ng
the MSI.

Could this violate the GICv3 specification by delivering LPIs while the ITS
is explicitly disabled, potentially crashing a guest OS during kexec?

>  		mutex_unlock(&its->its_lock);
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821064445.6158=
38-1-fuad.tabba@linux.dev?part=3D1
