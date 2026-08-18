Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EA13438AD;
	Tue, 18 Aug 2026 22:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787093274; cv=none; b=sLB186su8DlBjg7oj6WDvbiiikJeEtslVeShAKk26yo1I6ViZJ1TY0PwqEDQHrQ+dLC4hF0S1ljEJYBYKK8bs/z3hhdyJIWC+Lwyb7jMXhLDm5+ClZ8gpeLd8VpFGT58+OA5pLfVhjBmS7icLTAiiHw5kFRMYRSkD4aBOGq4Jcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787093274; c=relaxed/simple;
	bh=guJ1pV19rraBxwYerL9Vdm+bI7Kt1PmwggEB5Q17GHY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NXj8mgS/5u+xOjoos4cuj1wGw6HqH8J6R0G6UNFIrvEtyCKY2RJQmYyC2akZkZnHa0H+bCDfJoT6QqRKYrgXzLXid8MeQFTUj0Jc9Gz9ysH8ZClfR4u/ru9dGn+j3CYJry2uMEJBci9JKi/qDPFqz6XQP4CtGWsTp9VCDzvsqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRzTWxa8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRzTWxa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB341F000E9;
	Tue, 18 Aug 2026 22:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787093272;
	bh=eq2OBtSbwU5XSdocYtHikTFoDFIWDe9KhtUazDDOtMg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FRzTWxa8TWht9pvZ2rN5VZ4+DpXLoiPE/Q6vkh+zULjAXkfbuvBLy4Ie4akMueOVl
	 fq3/D0INut/duEFYQ1IA2o6I0v4TuifDiMAuczOMgo6XcMlFdgfme9yNidOrE1TZgf
	 MYuqnwM0EnnE2qROgqPHV9eqzNuTVE6ifbN7kWhJv/dD0Y/eHfACf0clEuAy81WXMO
	 aW7Sh6GRUh+G44HWTtQNo6Uh3dws2UFt6miRnHQBCvL1W343+Ub3m8Z+iIaFqf07un
	 f0az4IKE0qtsw6MlGXKQ1AiPxreO5w7pPBzTP9LtwVg7WfPlkOFDVQdgv0N3r7v2LN
	 9t4jBA+vT/n0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-its: Fix O(C*I) loop in
 vgic_its_free_collection_list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jing Zhang" <jingzhangos@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260818223422.367803-1-jingzhangos@google.com>
References: <20260818223422.367803-1-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 22:47:52 +0000
Message-Id: <20260818224752.9FB341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Unconditional dereference of `ite->collection` during ITS tabl=
e save leads to host kernel panic.
- [High] Unmitigated O(Total ITEs) loops during ITS command processing lead=
 to guest-triggered soft lockups and RCU stalls.
--

--- Patch [1]: [PATCH] KVM: arm64: vgic-its: Fix O(C*I) loop in vgic_its_fr=
ee_collection_list ---
commit 57034db6ba413048ab15ade32e11d1ba6a290388
Author: Jing Zhang <jingzhangos@google.com>

KVM: arm64: vgic-its: Fix O(C*I) loop in vgic_its_free_collection_list

When destroying the vgic-its collection list,
vgic_its_free_collection_list() iterates over every collection and for
each, calls vgic_its_free_collection(). This function walks every
Interrupt Translation Entry (ITE) across all devices via
for_each_lpi_its() to nullify the collection pointer.

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 4477f870c7b36..5e907a34226e3 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1122,9 +1122,21 @@ static void vgic_its_free_device_list(struct kvm *=
kvm, struct vgic_its *its)
>  static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic_i=
ts *its)
>  {
>  	struct its_collection *cur, *temp;
> +	struct its_device *device;
> +	struct its_ite *ite;
> =20
> -	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list)
> -		vgic_its_free_collection(its, cur->collection_id);
> +	/*
> +	 * Bulk-clear the collection pointers for all ITEs.
> +	 * This transforms the teardown complexity from O(Collections * ITEs)
> +	 * to O(Collections + ITEs), avoiding guest-triggered host RCU stalls.
> +	 */

[Severity: High]
This isn't a bug introduced by this patch, but does this fix cover the same=
 RCU
stall vulnerability in the ITS command ring processing?

A guest can queue up to 32,768 MAPC commands to remap an existing collectio=
n,
which vgic_its_process_commands() processes sequentially under cmd_lock
without yielding. For each command, update_affinity_collection() loops over
all ITEs:

arch/arm64/kvm/vgic/vgic-its.c:update_affinity_collection() {
	for_each_lpi_its(device, ite, its) {
		if (ite->collection !=3D coll)
			continue;

		update_affinity_ite(kvm, ite);
	}
}

With a large number of ITEs, can this unmitigated loop still cause soft loc=
kups
and RCU stalls on the host?

> +	for_each_lpi_its(device, ite, its)
> +		ite->collection =3D NULL;

[Severity: Critical]
This is a pre-existing issue, but can setting ite->collection to NULL here
cause a kernel panic during state saving?

If a guest clears GITS_BASER1 (triggering this teardown) or unmaps a collec=
tion
via MAPC with valid=3D0, the ITEs are left in the device list with a NULL
collection pointer.

Later, if host userspace triggers VM state saving, vgic_its_save_ite() blin=
dly
dereferences ite->collection:

arch/arm64/kvm/vgic/vgic-its.c:vgic_its_save_ite() {
	val =3D ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
		ite->collection->collection_id;
}

Does vgic_its_save_ite() need to verify ite->collection is non-NULL before
attempting to access its collection_id?

> +
> +	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list) {
> +		list_del(&cur->coll_list);
> +		kfree(cur);
> +	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818223422.3678=
03-1-jingzhangos@google.com?part=3D1
