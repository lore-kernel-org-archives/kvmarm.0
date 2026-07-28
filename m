Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283C241D629;
	Tue, 28 Jul 2026 12:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241420; cv=none; b=BQBZvN047AwkdpXx3jnhKBnF3hN/KScCE3O2L7ScAwnWli5JPHAMhXA3JhN4OUeBwZvJb4EIDjjMyF9AB/+7Gz9nFbqLCzTXRn8k1uTCENceIVawZQ9u6XFYvc1/jRPyUv4lfLfFT30VaQ3VU9xc1Mg4nszl0+nJNOcy/oCZrq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241420; c=relaxed/simple;
	bh=auhNHHAVWp8WwTCSZTla+ToFyKsBTcSb9bsJYLBT5KM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TTnoITSPK3nzGZYzD0Y3m612QfFlz5cbBdyz8JuafPREEpJgM9yZ+Fbsa9c/oTrELjmmMgGMb2eIH8yqeWkxqzfDgGKbR3ZMt9+09OINliOLEZqs3MeUSp3IfdmZT1MQoz7j2jWOVLB6Y8zJoeZw+XKaCboWoyuhtzCGlWjT0bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYrBET68; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYrBET68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC141F000E9;
	Tue, 28 Jul 2026 12:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241418;
	bh=QAAJPdcw0e3nzwdUBkuX9JtPpDN91e/vsvtwjUONayA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RYrBET68FJnhkdBme98oTo9r7wLRGIVrYQqFiwfQBLaBty4POzndTEqQwdbnB1i01
	 fLhaz3FaUJsQ5FCcLGg+djOh0DusdpA9fwabfW0G4aLbod4sjrd2rJuzC8/eAZPFsc
	 3GCmRCht9kHQ4UH85edRUzXV4ibboE/kzWxoIu1tWgYiUBWpHBWzol95pMK2T4PR+l
	 zm6+Xa+ufJ1BV0GReuuVF50DIvyon7JOKCNL6mrqe7KU7a57h3DsOhH3evKIRFpIHp
	 CR7NHKAo8zSHaR0dkHHLfhPZi9XAzrIN1swYuXp4Ul1BEDfogW5XznWvio4oeLiHlP
	 83/3tBH64OHxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/11] KVM: guest_memfd: Add support for preservation
 via LUO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260728121138.1103610-9-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-9-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 12:23:38 +0000
Message-Id: <20260728122338.7FC141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] `kvm_gmem_luo_finish` incorrectly performs cleanup on successful r=
etrieval, resulting in use-after-free and double-frees of the serialization=
 state and premature freeing of page cache folios.
- [High] Missing `kho_is_enabled()` check before invoking KHO serialization=
 APIs, risking a NULL pointer dereference.
--

--- Patch [8]: [PATCH v4 08/11] KVM: guest_memfd: Add support for preservat=
ion via LUO ---
commit 8d81cd3b20bca211fdf1860f352a2bbcf1096ec9
Author: Tarun Sahu <tarunsahu@google.com>

KVM: guest_memfd: Add support for preservation via LUO

This commit registers a Live Update Orchestrator file handler for
guest_memfd files to preserve guest memory across kexec reboots. It freezes
the guest_memfd inode during preservation, walks the page cache to serialize
metadata, and reconstructs the file and its folios on retrieval.

> diff --git a/virt/kvm/guest_memfd_luo.c b/virt/kvm/guest_memfd_luo.c
> new file mode 100644
> index 0000000000000..c0aa9354e0a78
> --- /dev/null
> +++ b/virt/kvm/guest_memfd_luo.c
> @@ -0,0 +1,515 @@
[ ... ]
> +static int kvm_gmem_luo_preserve(struct liveupdate_file_op_args *args)
> +{
> +	struct guest_memfd_luo_folio_ser *folios_ser =3D NULL;
> +	u64 count =3D 0, gmem_flags, abi_flags =3D 0;
> +	struct guest_memfd_luo_ser *ser;
[ ... ]
> +	end_index =3D size >> PAGE_SHIFT;
> +
> +	ser =3D kho_alloc_preserve(sizeof(*ser));

[Severity: High]
Does this path need to verify if the KHO subsystem is actually enabled?

If the kernel is booted with KHO disabled, calling kho_alloc_preserve() and
other KHO APIs unconditionally can cause a NULL pointer dereference.=20

Could we check kho_is_enabled() either here or in kvm_gmem_luo_init() before
registering the handler?

[ ... ]
> +static void kvm_gmem_luo_finish(struct liveupdate_file_op_args *args)
> +{
> +	struct guest_memfd_luo_ser *ser;
> +	struct guest_memfd_luo_folio_ser *folios_ser;
> +
> +	/* Nothing to be done here, if retrieve_status was successful or errore=
d,
> +	 * Cleanup is taken care of in retrieval call.
> +	 */
> +	if (args->retrieve_status)
> +		return;
> +
> +	if (!args->serialized_data)
> +		return;
> +
> +	ser =3D phys_to_virt(args->serialized_data);

[Severity: High]
Is the check on args->retrieve_status inverted here?

When kvm_gmem_luo_retrieve() succeeds, it returns 0 and frees the ser point=
er:

kvm_gmem_luo_retrieve()
    args->file =3D file;
    kho_restore_free(ser);
    return 0;

Because retrieve_status is 0 on success, this finish function will fall
through the if statement instead of returning early. It will then access
the freed ser pointer and mistakenly discard all the successfully restored
folios.

Would checking if (!args->retrieve_status) avoid this use-after-free
regression?

> +
> +	if (ser->nr_folios) {
> +		folios_ser =3D kho_restore_vmalloc(&ser->folios);
> +		if (folios_ser) {
> +			kvm_gmem_luo_discard_folios(folios_ser, ser->nr_folios, 0);
> +			vfree(folios_ser);
> +		}
> +	}
> +
> +	kho_restore_free(ser);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.1103=
610-1-tarunsahu@google.com?part=3D8
