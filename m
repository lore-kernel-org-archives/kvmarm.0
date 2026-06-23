Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8697A3ACA74
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 20:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782248214; cv=none; b=D61hKCkiB9k/ydi886vIyI4vIVe6vABZ8jN4bYP58t0Kr9oH8VTj3lBRURTO4O7hVa9ITJbKw4htv+Cb9PJc6MydsA9IuVefsmDFT9gAmLlvEh/mD9tmqjV1+S5t0CT9bJwh89cRpkJOPYiUekx6z2KhDlFO7fAyEU5niY3qjRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782248214; c=relaxed/simple;
	bh=5UAywcSGpdjwQl+NDBiBD9HhRry+w2P/W6igQKlMrek=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MDj6CmwDgqYdr59IkC8WgWLEuJgEHhLgndDXpq2+bo5JIGMRFB/anF0nqnFnwrM0vnvw4RG4DitfNWL88kXIMi2ve2exLIjDS0VeJyAOh8U+cZjbe7JuZRcN004WnaDx1OJ4UwSo+lFzAmCBROwSRVrhnySHCtChPWpZvAOoaZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TzIUK2Ek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TzIUK2Ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4C71F000E9;
	Tue, 23 Jun 2026 20:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782248213;
	bh=uikVT6sEiFocOerFLtdCz3piaxEkQ3ehiz+zAHMF9ds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TzIUK2Eku+pKFD/8SMDOYwClBaHmY0hGb1H/wCIqzT1W/raaslSRhYtZmCphjTaPs
	 XMpir7+Mry/5ifFJkliLf6FhrdBVFkUWIXsDj2k6zvPM8a08faaf1/YowmBvio8SOb
	 Cx7aoejB4XN+inPOxC6dhdMIP8PwZK+BFj+/qtqdyXLIqxVSJSX4JDr3/ngNENMeE+
	 5gxfbAn1T+iO50cwVwQJBYBChI0tgCJ1WgFknqj+C6yCInYwIKlIue3lRA2yIgfJbg
	 C/DYhmtBYJP84rpxt9i4xqY3fmNAi3WpL3xknfQs6gLnmDRFqneFPYHM9qSfBOhbHK
	 qxg0BdUBMmHmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/22] KVM: arm64: Set Access flag on table descriptors
 at stage-1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260623184201.1518871-18-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-18-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 20:56:52 +0000
Message-Id: <20260623205652.DC4C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM incorrectly applies stage-1 Access Flag updates to table descr=
iptors when hardware AF updates are globally disabled, causing spurious per=
mission faults and bypassing nested stage-2 dirty tracking.
--

commit 3e7cbff07bcf9d864e2cd9a33c92f040a6496081
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: Set Access flag on table descriptors at stage-1

This commit implements access flag updates on table descriptors as required
by FEAT_HAFT. Note that unlike leaf descriptors, access flags on table
descriptors never generate a fault.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -416,6 +416,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struc=
t s1_walk_info *wi,
>  	wi->hd &=3D (wi->regime =3D=3D TR_EL2 ?
>  		  FIELD_GET(TCR_EL2_HD, tcr) :
>  		  FIELD_GET(TCR_HD, tcr));
> +	wi->haft  =3D kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT) &&
> +		    FIELD_GET(TCR2_EL1_HAFT, effective_tcr2(vcpu, wi->regime));

[Severity: High]
Should wi->haft initialization be gated by wi->ha?

Per the ARM ARM, TCR2_ELx.HAFT is IGNORED if TCR_ELx.HA is 0. Because
wi->haft is evaluated independently of wi->ha here, the guest could configu=
re
TCR_ELx.HA =3D 0 but TCR2_ELx.HAFT =3D 1.

[ ... ]

> @@ -465,7 +467,7 @@ static bool should_set_access_flag(struct s1_walk_inf=
o *wi, struct s1_walk_step
>  	if (access->type =3D=3D WALK_ACCESS_NONARCH)
>  		return false;
> =20
> -	return wi->ha;
> +	return kvm_pte_table(ws->desc, ws->level) ? wi->haft : wi->ha;
>  }

If the guest configures TCR_ELx.HA =3D 0 and TCR2_ELx.HAFT =3D 1, this will
return true for table descriptors even when hardware AF updates are disable=
d,
leading to spurious descriptor writes.

This can cause KVM to trigger stage-2 permission faults if the stage-2
mapping is read-only.

Furthermore, if the stage-2 mapping relies on hardware dirty state manageme=
nt
(DBM), KVM's nested stage-2 walk in walk_s1() treats the access as a read
because wi->ha is false:

arch/arm64/kvm/at.c:walk_s1() {
	...
	struct kvm_walk_access s2_access =3D {
		.type	=3D WALK_ACCESS_S1PTW,
		.ia	=3D ws.desc_ipa,
		/*
		 * R_JCXVS, stage-2 dirty state can be updated
		 * for an S1PTW even if the stage-1 descriptor
		 * isn't updated.
		 */
		.write	=3D wi->ha,
	};
	...
}

This will silently bypass the nested hypervisor's stage-2 dirty tracking
while still modifying the guest memory in host memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D17
