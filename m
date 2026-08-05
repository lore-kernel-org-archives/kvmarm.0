Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F222B40F8E9
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 09:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785923703; cv=none; b=jySvBuJBnUnXM9TR5Hkowz8JQ65R3uU35MsZeFzxyZVLm71Ts6m4a8njBW6KL0xa5I9PgczoZMiiY4MNdB02eV5zySzQn5Lx1abhTT5tl1VFVfC0R7R5zjS2r8byCkLDsE5DmoX2MJgGdLWVvhkfVW/yDeHLWN9+NhqBdioRxqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785923703; c=relaxed/simple;
	bh=swHTxzQpwQzE9WR21iECUsew8everD1NanNEvuFX8Qw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PO2KrO2kKLTNDtV+kUaZVI2Ie/MsYY/qL0ZQwQMKGdoa8Kbu1vpnuHyIloCftcLdNdoevHFan2tWQ0QJEhiugk+MeQ1khiBznd/3+/bfk8hej8yN94AA3J5Lxym8ceihBsLQMm14/ahxviimfcGe+yLlqOqCv0EoUg29d6tUb7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWr8bwuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWr8bwuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1461F000E9;
	Wed,  5 Aug 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785923701;
	bh=rEPdE2uWWOuJbKqeRYisyPznE4rqrc8hAb6MGuU0vYI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YWr8bwuzcGPARjg/uHaqkJT+mzm/wGdgZKMx3Z2mVtRG0mPujoRGU0zJpWJ2f86YC
	 JSyAWFsIQkAD1J6di1icJ4G/W0IZND78+ePwThrVYKM0pHxn2oSCW+SCkTmwRZtuph
	 rrwWPX7tSI23lzWj6Yn8p3zeJlKZIf2WZUc17RNmDJUBuzSxRS3vSDUgHoxFZ4N128
	 kwFW6kKt6n7ArvacUWZsjSTvGigZyUJRb3I+oJuq7MYoCr/IKEfc4X0Zhv1Lt1bg2O
	 +l6ZeGTm5rPJJ+bGsQWxbOylukx+1nmuqYw8XRwHjOfxWB849bLPkboPH21gspwT2Y
	 7VujSs5+Ug2OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: vgic-its: Don't write past the end of
 the collection table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260805093828.3626610-4-fuad.tabba@linux.dev>
References: <20260805093828.3626610-1-fuad.tabba@linux.dev>
 <20260805093828.3626610-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 09:55:00 +0000
Message-Id: <20260805095501.8E1461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] vgic_its_save_collection_table() saves collections with IDs that=
 exceed the current GITS_BASER size, generating an invalid migration state =
that fails on restore.
--

--- Patch [3]: [PATCH 3/3] KVM: arm64: vgic-its: Don't write past the end o=
f the collection table ---
commit d0eca2d07d6d3c4d13e7fff1329f9d14363bb0f5
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: vgic-its: Don't write past the end of the collection table

This commit limits the number of collection table entries saved during
migration to avoid writing past the end of the guest memory table. It
aborts the save operation with -EINVAL if the guest has mapped more
collections than fit in the current table.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index ed281fbf008b9..c709fc5e17cda 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2540,6 +2540,9 @@ static int vgic_its_save_collection_table(struct vg=
ic_its *its)
>  	max_size =3D GITS_BASER_NR_PAGES(baser) * SZ_64K;
> =20
>  	list_for_each_entry(collection, &its->collection_list, coll_list) {
> +		if (filled =3D=3D max_size)
> +			return -EINVAL;
> +
>  		ret =3D vgic_its_save_cte(its, collection, gpa);

[Severity: Medium]
This is a pre-existing issue, but does this code save collections with IDs
that exceed the current GITS_BASER size?

If a guest maps a collection with a large ID, and then shrinks the table si=
ze
in GITS_BASER while keeping VALID=3D1, the collection list isn't freed. Sin=
ce
the total number of mapped collections might still be small enough to pass =
the
filled =3D=3D max_size check, it appears the collection with the large ID w=
ill
be successfully saved here.

On the destination side, when vgic_its_restore_cte() reads this entry, it
calls vgic_its_check_id() which checks the ID against the shrunken boundari=
es,
returning -EINVAL and failing the migration.

Should this path also validate the collection ID against the current table
size, similar to how vgic_its_save_device_tables() uses vgic_its_check_id()?

>  		if (ret)
>  			return ret;
>  		gpa +=3D cte_esz;
>  		filled +=3D cte_esz;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805093828.3626=
610-1-fuad.tabba@linux.dev?part=3D3
