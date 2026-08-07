Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8983B39A067
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121848; cv=none; b=IHAEqY3ZLFW1yxGT3qtLQ4jjVXdcQfu5K67TIJeHfhdYKmclJRl3osjJK6xP4k4ZuH7Fz+6uHEiXh54g4kNggWtfCLYjwP6b9hgM3ZYZYbh+XawfHMInnp8pgFS08evgzsQ67AwbWqGpMXHx2LCBGfz3mJ+m/Zw4EpSVC+w3d8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121848; c=relaxed/simple;
	bh=4mOXp8OrzjX5+ujKoBUNlncTHuh685T9OrokqnpToos=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Vr6DlwJCH+DTEwkqnI4bTy7wBJoJZx/3vzUUO/lvUK5GQiOIE0MyLCOH4mjvGAonn+kunbUkEcxmGS55NmnbA0W6ksWkzQfVQtSTsNw5EXi0DKUf8fJo4gVrMRUrnVKTe1ZNTTibiQdPzBgOieBfStYQZkEjg2KKFuD2THMKaOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ArM5WyxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArM5WyxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952CD1F000E9;
	Fri,  7 Aug 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786121844;
	bh=gS3jDLsKgTQKdCe4sW6qMxfCOtSQSAORd3yRblbbzVU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ArM5WyxSnmp4bfzQhfO0iX2uEBu6puRehuUT58VOkmIl357Ngybm/s4hYqmYDYofB
	 wvYaIVsgbUhg0j+5BbKooU043Vu6ZnxzWFujcfD6SKQdSfZDGnHuKxlmvK8TIhOkV5
	 IGsl9dIQUe/r175hyMujRXL6jvRjAJMyvaLi64/ogM+PKtX+xeTrSItZVj9V2kszYb
	 VXy2IuBzhx9CvjVkLrnBn6HM77AFZUEWaE7RqCzT5MAKNqopA4gQlpFhO2iQUbcE7J
	 pFjS8eVteo9is3HE5+D2Hv7GzRGlIzRchUFk9ulnYnrS2/PMkGTHL2tY3coEIlYyJw
	 AQ9nhJG8D0prw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/13] KVM: arm64: Trap & emulate the ITS MAPD
 command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260807164322.2970811-10-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-10-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:57:24 +0000
Message-Id: <20260807165724.952CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [Critical] The rollback logic in check_table_update is dead code and allo=
ws host-driven hypervisor memory compromise.
- [Critical] get_num_itt_pages calculates ITT boundaries incorrectly, resul=
ting in underpinning of unaligned ITT tail pages.
- [Critical] check_table_update does not enforce physical address alignment=
 for Level 2 tables, allowing hardware ITS memory corruption.
- [High] track_pfn_remove skips clearing the tracking entry on early return=
, permanently leaking dte_entry slots.
- [High] Partial failure in process_its_mapd aborts command execution witho=
ut rolling back EL2 metadata donations.
- [High] track_pfn_add leaks hyp_page refcounts when mapping duplicate comm=
ands, permanently stranding host memory.
- [High] Architecturally legal MAPD unmap commands fail with -EINVAL, perma=
nently stalling the emulated ITS command queue.
- [Medium] Re-mapping an existing device to a new ITT leaks the old ITT pag=
es.
--

--- Patch [8]: [PATCH v2 08/13] KVM: arm64: Trap & emulate the ITS MAPD com=
mand ---
commit d27a7f8a2aeffcb0dd24c8e126274036ef6c275e
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Trap & emulate the ITS MAPD command

Parse the MAPD command and extract the ITT address to sanitize it. When
the command has the valid bit set, share and pin the memory that holds
the ITT table with the hypervisor to prevent it from being given to
someone else (eg. a VM). Use the pinning as a mechanism to get a grip
to the page and to prevent other users of the pKVM API from sharing or
donating the page for something else.

> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/n=
vhe/its_emulate.c
> index 1ce2f9d8fcf9c..071a08d3602d7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
[ ... ]
> @@ -110,11 +118,236 @@ static int submit_single_cmd(struct its_priv_state=
 *its, bool retry)
>  	return 0;
>  }
> =20
> +static int get_num_itt_pages(struct its_priv_state *its, u8 num_bits)
> +{
> +	u64 gits_typer, nr_ites;
> +	size_t sz;
> +
> +	gits_typer =3D readq_relaxed(its->base + GITS_TYPER);
> +	if (num_bits > FIELD_GET(GITS_TYPER_IDBITS, gits_typer))
> +		return -EINVAL;
> +
> +	nr_ites =3D BIT_ULL(num_bits + 1);
> +	sz =3D nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, gits_typer) + 1);
> +	sz =3D max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
> +
> +	return PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +}

[Severity: Critical]
Does this calculation miss the intra-page offset of the itt_addr? If a host
provides an ITS-aligned but not page-aligned address, sz alone doesn't
account for the page boundary crossing. This could result in under-pinning
the tail page and allowing it to be mapped to a guest while the hardware ITS
writes to it.

[ ... ]
> +static int check_table_update(struct its_priv_state *its, u32 device_id,=
 u64 type, bool rollback)
> +{
> +	struct its_baser *table =3D get_table_from_snapshot(its->host_state, ty=
pe);
> +	size_t lvl2_entry_sz, lvl1_table_sz, num_lvl2_entries, num_lvl1_entries;
> +	u64 *snapshot_table, *original_table;
> +	u64 prev_entry, new_entry;
> +	u32 new_entry_index;
> +	int ret;
> +
[ ... ]
> +	snapshot_table =3D kern_hyp_va(table->base_snapshot);
> +	original_table =3D kern_hyp_va(table->base);
> +
> +	/*
> +	 * Look at the host table copy and if the entry hasn't changed the valid
> +	 * bit compared to the original table used by the hardwre, don't update=
 anything.
> +	 */
> +	new_entry =3D snapshot_table[new_entry_index];
> +	prev_entry =3D original_table[new_entry_index];
> +	if (!((new_entry ^ prev_entry) & GITS_BASER_VALID))
> +		return 0;

[Severity: Critical]
If a command fails and triggers a rollback, will this early return bypass
the rollback logic? Because the forward pass already updated original_table,
new_entry and prev_entry will match here. This leaves a window for the host
to manipulate snapshot_table and maliciously donate arbitrary hypervisor
pages.

> +
> +	/*
> +	 * The host can play nasty tricks with read-modify-write after a
> +	 * rollback is triggered but we still hold on to the original tables
> +	 * which are hyp managed and we don't give back any other page to the
> +	 * host.
> +	 */
> +	if (rollback)
> +		new_entry =3D new_entry ^ GITS_BASER_VALID;
> +
> +	if (new_entry & GITS_BASER_VALID)
> +		ret =3D __pkvm_host_donate_hyp(hyp_phys_to_pfn(new_entry & PHYS_MASK),
> +					     table->psz >> PAGE_SHIFT);

[Severity: Critical]
Does this pass the physical address to the hypervisor without enforcing the
architectural page size alignment (GITS_BASER.Page_Size)? If the host
provides an unaligned physical address, the hypervisor will donate based on
the unaligned PFN, but the hardware ITS masks the lower bits, potentially
accessing memory outside the donated range.

> +	else
> +		ret =3D __pkvm_hyp_donate_host(hyp_phys_to_pfn(prev_entry & PHYS_MASK),
> +					     table->psz >> PAGE_SHIFT);
> +	if (ret)
> +		return ret;
> +
> +	original_table[new_entry_index] =3D new_entry;
> +	return 0;
> +}
> +
> +static int track_pfn_add(struct its_priv_state *its, u32 device_id, u64 =
pfn)
> +{
> +	void *virt =3D hyp_phys_to_virt(hyp_pfn_to_phys(pfn));
> +	struct dte_entry *entries =3D &its->tracked_entries[0];
> +	bool pfn_shared =3D false;
> +	int ret;
> +	int i;
> +
> +	for (i =3D 0; i < its->num_tracked_entries; i++) {
> +		if (entries[i].itt_pfn =3D=3D pfn) {
> +			if (entries[i].device_id !=3D device_id) {
> +				pfn_shared =3D true;
> +				break;
> +			} else {
> +				return hyp_pin_shared_mem(virt, virt + PAGE_SIZE);
> +			}

[Severity: High]
If the host issues multiple MAPD commands with Valid=3D1 for the same
device_id and ITT, can this leak hyp_page refcounts? It increments the pin
count for a duplicate mapping without adding a new tracking entry. When
unmapped, track_pfn_remove unpins only once and clears the tracking entry,
which would permanently strand the extra pins.

> +		}
> +	}
[ ... ]
> +static int track_pfn_remove(struct its_priv_state *its, u32 device_id, u=
64 pfn)
> +{
> +	void *virt =3D hyp_phys_to_virt(hyp_pfn_to_phys(pfn));
> +	struct dte_entry *entries =3D &its->tracked_entries[0];
> +	int ret;
> +	int i;
> +
> +	for (i =3D 0; i < its->num_tracked_entries; i++) {
> +		if (entries[i].itt_pfn !=3D pfn || entries[i].device_id !=3D device_id)
> +			continue;
> +
> +		/* To decrement the refcount, first try to unshare it */
> +		ret =3D __pkvm_host_unshare_hyp(pfn);
> +		if (ret =3D=3D -EBUSY) {
> +			hyp_unpin_shared_mem(virt, virt + PAGE_SIZE);
> +			ret =3D __pkvm_host_unshare_hyp(pfn);
> +			if (ret =3D=3D -EBUSY)
> +				return 0;

[Severity: High]
Does this early return skip clearing the tracking entry? If an ITT page is
shared by multiple devices and the second unshare returns -EBUSY, bypassing
the memset below will permanently leak the dte_entry slot for this device,
eventually leading to -ENOSPC.

> +
> +			WARN_ON(ret);
> +		}
> +
> +		memset(&entries[i], 0, sizeof(struct dte_entry));
> +		its->empty_entry =3D i;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
[ ... ]
> +static int process_its_mapd(struct its_priv_state *its, struct its_cmd_b=
lock *cmd, bool rollback)
> +{
> +	phys_addr_t itt_addr =3D cmd->raw_cmd[2] & GENMASK(51, 8);
> +	bool remove =3D !(cmd->raw_cmd[2] & BIT(63));
> +	u8 size =3D cmd->raw_cmd[1] & GENMASK(4, 0);
> +	u32 device_id =3D cmd->raw_cmd[0] >> 32;
> +	int num_pages, ret;
> +	u64 itt_pfn;
> +
> +	if (rollback)
> +		remove =3D !remove;
> +
> +	itt_pfn =3D hyp_phys_to_pfn(itt_addr);
> +	num_pages =3D get_num_itt_pages(its, size);

[Severity: High]
The GICv3 specification dictates that when a MAPD command has Valid=3D0 (an
unmap), the ITT_addr and Size fields are IGNORED. If a driver provides zeros
for these ignored fields during an unmap, will extracting them here cause
track_pfn_remove to fail with -EINVAL, permanently stalling the emulated ITS
command queue?

> +	if (num_pages < 0)
> +		return num_pages;
> +
> +	ret =3D check_table_update(its, device_id, GITS_BASER_TYPE_DEVICE, roll=
back);
> +	if (ret)
> +		return ret;
> +
> +	return track_pfn(its, device_id, itt_pfn, num_pages, remove);
> +}

[Severity: High]
If track_pfn() fails here (for example, if the tracking array is full), the
error is returned directly. Will this leave the mutations and donations
performed by check_table_update() permanently applied without rolling them
back or executing the command in hardware?

[Severity: Medium]
When a MAPD command is issued with Valid=3D1 for a device_id that is already
mapped, but with a new ITT_addr, does this leak the old ITT pages? The new
PFNs are tracked, but there doesn't appear to be logic to look up and remove
the pre-existing mapping for this device_id.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D8
