Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0939EF25
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122254; cv=none; b=Iw8gQQ2k3sgGG+OD5KMqekQU5+dEgn80Ce7E+WS1SXsyvMRb38U4yCN3pQLA0rromxtAHyvvYElJXvlC/H62hqEYknzVYeoS96TX0hkk+SelEHjxQnwaOQOId3pCET5/8rQDNxt/luNZ0sSz9RSca1xs7uDI1WK/pFgpsonByHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122254; c=relaxed/simple;
	bh=9AmUUo2XdPo4q6I1Y8IaPfKjNUjh7EIPRdpg3kwxS3s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Yei+6x6Cd4SE2crt3XLwowzIB8X3fJXC6SWAN6azWlP7ToJs1kCwJ0Q4QITjBmnLSHH7w84g1v1+bkXbmLDHLwVbCj1tx6UsKIPLyvz30QsyRDVVHy9slUxZoaOjciQt0FP5ZDSHPEumi2wg/FAtivvM0tpbCHC8U4n7Zk0aL/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opEJFw0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opEJFw0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52651F000E9;
	Fri,  7 Aug 2026 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122252;
	bh=LzICne6zOonoa8OVZhxs3/AUv2v2lZMHN21SYtn7eDE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=opEJFw0JTon4WDPB0vpRyD4FUC6H6fDDMTzbo4WEpNVs1nZVph00l6o/eCEgrBZA+
	 DGEC/2yKk0epUe/ziFaGGRjNk9ybuOEs9lC8WlFUBuoLeyqMGCwuv6yKJOalNbwYpP
	 pR/Rx7k975GRzw7s9l4VE7whnYL1X++jyqMPvwnRv3ogJd7XT44ypaiThOXG1yQTiI
	 GGoNVhd1JLElZhSVjVQ86aICR7zK2j71WXAWBM8l8CCLZsyWkHtFeryC9+eLR61Pj/
	 ZLBur3BLWbILaGPSCAcVFO06w3QK9FjGMa7eaH6T2ahnAj++LfMqiTrtK9WLumOdbS
	 Mj6lUQ1WVj70A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/13] KVM: arm64: Trap & emulate the ITS MAPC
 command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807164322.2970811-11-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-11-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:04:12 +0000
Message-Id: <20260807170412.A52651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] Double-fetch of host-shared memory allows bypassing EL2 physic=
al page ownership verification.
- [Critical] `process_its_mapd` lacks alignment validation for `itt_addr`, =
allowing the physical ITS to access host-controlled memory.
- [Critical] `check_table_update` lacks alignment validation for the L2 tab=
le base address, leading to a desynchronization between donated pages and h=
ardware ITS accesses.
- [High] `process_its_mapc` fails to validate the `RDBase` (Target Address)=
 field in the MAPC command, allowing the host to corrupt memory.
- [High] Rollback logic in `check_table_update` is unreachable, causing lea=
ked page donations on ITS command submission failure.
- [High] `process_its_mapc` unconditionally checks the Collection table, br=
eaking ITS command processing if the hardware implements internal collectio=
ns.
- [High] Updates to the shadow L1 table in `check_table_update` are not flu=
shed to the Point of Coherency.
--

--- Patch [9]: [PATCH v2 09/13] KVM: arm64: Trap & emulate the ITS MAPC com=
mand ---
commit 6bcf78893239baf62c5e67a46e844a52707cefb5
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Trap & emulate the ITS MAPC command

This patch parses the MAPC command to verify if any updates to the shadow
collection table are needed. It adds the process_its_mapc handler and wires
it into the main process_cmd switch statement.

> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/n=
vhe/its_emulate.c
> index 071a08d3602d7..5629e2a070df5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> @@ -332,6 +332,13 @@ static int process_its_mapd(struct its_priv_state *i=
ts, struct its_cmd_block *cm
>  	return track_pfn(its, device_id, itt_pfn, num_pages, remove);
>  }
> =20
> +static int process_its_mapc(struct its_priv_state *its, struct its_cmd_b=
lock *cmd, bool rollback)
> +{
> +	u32 icid =3D cmd->raw_cmd[2] & GENMASK(15, 0);
> +

[Severity: High]
Does this handler need to extract and validate the Target Address from
cmd->raw_cmd[2]?

If the physical ITS uses Physical Target Addresses (GITS_TYPER.PTA =3D=3D 1=
), the
RDBase field in the MAPC command specifies the physical address of the targ=
et
Redistributor.=20

Since this field appears to be ignored here, could a malicious host provide=
 an
arbitrary hypervisor or guest physical address? When the ITS hardware
processes an interrupt for this collection, it might perform a write to the
unvalidated physical address, bypassing SMMU stage-2 protections and
corrupting isolated memory.

> +	return check_table_update(its, icid, GITS_BASER_TYPE_COLLECTION, rollba=
ck);
> +}

[Severity: High]
Does this code break ITS command processing if the hardware implements
internal collections?

According to the GICv3 architecture, if the ITS supports internal hardware
collections (GITS_TYPER.HCC > 0), the GITS_BASER register for the Collection
table is optional. If not implemented, get_table_from_snapshot() in
check_table_update() would legitimately return NULL, which causes an
-EINVAL return.

This error would propagate to cwriter_write(), which immediately returns
without advancing its->cmd_offset. The MAPC command would be permanently
rejected and the host ITS queue could stall.

[Severity: Critical]
Is there a double-fetch risk when reading from the host-shared snapshot tab=
le
in check_table_update() called here?

Looking at check_table_update(), EL2 reads the host-controlled L1 table ent=
ry
via a bare pointer dereference:

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
    new_entry =3D snapshot_table[new_entry_index];
    prev_entry =3D original_table[new_entry_index];
    ...
}

Since READ_ONCE() is not used, could the compiler satisfy multiple uses of
new_entry by reloading it from host memory? If the compiler emits multiple
load instructions, a host could race to overwrite the entry after it has be=
en
verified and the PFN donated, but before it is written to the hypervisor's
original_table.=20

This could allow the host to install an unverified PFN into the hardware IT=
S,
potentially leading to arbitrary memory corruption by the ITS.

[Severity: High]
Can the rollback logic in check_table_update() actually be reached?

When an ITS command fails to submit to hardware, KVM attempts to revert the
state by calling process_cmd() with rollback=3Dtrue, which calls into
check_table_update().=20

However, during the initial forward pass, original_table[new_entry_index]
was already updated to match the VALID bit of new_entry.

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
    if (!((new_entry ^ prev_entry) & GITS_BASER_VALID))
        return 0;

    if (rollback)
        new_entry =3D new_entry ^ GITS_BASER_VALID;
    ...
}

During rollback, wouldn't the early return condition evaluate to true
since the VALID bits now match? The function would return 0 immediately,
and the intended rollback logic is never reached, permanently leaving the
Level 2 table page donated to the hypervisor.

[Severity: Critical]
Does check_table_update() lack alignment validation for the L2 table base
address?

When the hypervisor donates the host's L2 table memory, it derives the PFN
using hyp_phys_to_pfn(new_entry & PHYS_MASK), but does not appear to valida=
te
its alignment against the table page size (table->psz):

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
    if (new_entry & GITS_BASER_VALID)
        ret =3D __pkvm_host_donate_hyp(hyp_phys_to_pfn(new_entry & PHYS_MAS=
K),
                                     table->psz >> PAGE_SHIFT);
    ...
}

If the host provides an unaligned address, KVM would donate pages starting
exactly at the unaligned PFN. However, the physical ITS hardware masks the
address to its strictly aligned boundary.=20

Could the ITS hardware then access pages preceding the KVM-donated range?
Since these preceding pages would still be owned by host EL1, this could al=
low
the host to directly read or modify active L2 table entries and bypass pKVM
isolation.

[Severity: High]
Do the updates to the shadow L1 table in check_table_update() need to be
flushed to the Point of Coherency?

When the new L1 entry is written to the shadow table:

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
    original_table[new_entry_index] =3D new_entry;
    return 0;
}

This update does not seem to be flushed. If the physical ITS is not cache
coherent with the CPUs (indicated by its->needs_flush), the hardware ITS
might fetch the stale L1 entry directly from RAM.=20

Does this require a gic_flush_dcache_to_poc() on the modified shadow table
entry to ensure the hardware ITS sees the updated pointer to the L2 table?

> +
>  static int process_cmd(struct its_priv_state *its, struct its_cmd_block =
*cmd,
>  		       bool rollback)
>  {
> @@ -342,6 +349,10 @@ static int process_cmd(struct its_priv_state *its, s=
truct its_cmd_block *cmd,
>  	case GITS_CMD_MAPD:
>  		ret =3D process_its_mapd(its, cmd, rollback);
>  		break;

[Severity: Critical]
Does process_its_mapd() validate the architectural alignment of itt_addr?

Looking at the implementation of process_its_mapd() called here:

arch/arm64/kvm/hyp/nvhe/its_emulate.c:process_its_mapd() {
    ...
    phys_addr_t itt_addr =3D cmd->raw_cmd[2] & GENMASK(51, 8);
    ...
    itt_pfn =3D hyp_phys_to_pfn(itt_addr);
    num_pages =3D get_num_itt_pages(its, size);
    ...
}

itt_addr is converted to a PFN by shifting right by PAGE_SHIFT. The GIC
architecture only requires itt_addr to be 256-byte aligned.

If a host provides a sub-page aligned itt_addr near a page boundary, KVM
calculates num_pages and tracks those pages starting from the truncated PFN.
However, the physical ITS will access size bytes starting at the unaligned
itt_addr, potentially spilling into the next page.=20

If this next page is not pinned and remains owned by host EL1, could the ho=
st
donate it to a guest, allowing either to read or modify active ITEs and byp=
ass
memory isolation?

> +
> +	case GITS_CMD_MAPC:
> +		ret =3D process_its_mapc(its, cmd, rollback);
> +		break;
>  	default:
>  		/* Passthrough everything for now */
>  		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D9
