Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3256238E8CE
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122145; cv=none; b=BNfORgROeIpA6N/wrrhdpMaxqYUwNiwC4E4sEzDiFLAReAUOoe41sG9TeSp6+grhHX6CJQQp9bqsSfW6q8IV+9AiYzZq5OQIvYBtiNoNN/XoPjyQM4ZEdL3pfhGW64Vc5JCVlVhusJtSyrOUSJ9V6wVOgwkDmjZ1Hq5644ZShN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122145; c=relaxed/simple;
	bh=kC3fn+dr4tO3S65R+/zvQ6StDmJPOOiB0pIubNYagpQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GcykO+IW31lYTaFufNKRp1jSI+DkbZ/9BwkuSB/WWwhclY9BhtYCxvde4sf+lMRqcfZ1Wcr3/nmRVi1WS+y+OtKNqyPnjQNHDPUVfI16GD7UKhfox0OTPCWZ+6Jd0y8D6ekCnc7WYEtQ/kAHShkFZVDO9wDHOpo8CWn69Wpx5Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WINybgmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WINybgmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C3B1F000E9;
	Fri,  7 Aug 2026 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122143;
	bh=Is4mg99b2YaSH25rSzoDXD+QqCQR30eFV2ZKYoPPPjw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WINybgmUSD3VR+f5W1YThLXiX7n/YmN+pxJgqMnzH6YpWrarnJtmUFDkBlcJYrSlw
	 XYgrZy3E1g6iPm96Plzi4oMCJA34dx3ZSd90A67GlPHNqs/XvXbMbTOkXernQboRxl
	 zA3nqctdomn2j1zY3YGQiOvdQpTvAZicTlGbdyJq/cJe6MlOJ0aHJ4De6NVSSlhJ2B
	 WmHmQbyNUrGFunAW/B84rJlDEiDtqk72BbZkVBPz8WOelCa3eLa0i5KsEnBLWnSzNe
	 qsdzdy3SXTe9KEMP2dEoQYUny7njQKFkzw60aSMuzrbTQx3Qhf1XPUpZQwFzPC0dW8
	 RMDAgvzDuwA2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/13] KVM: arm64: Restrict host access to the
 private ITS tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807164322.2970811-9-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-9-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:02:22 +0000
Message-Id: <20260807170223.85C3B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 15 potential issue=
(s) to consider:
- [Critical] Host can bypass ITS table protection via mismatched virtual-to=
-physical address mapping.
- [Critical] TOCTOU vulnerability in `check_table_update` during rollback a=
llows a malicious host to intentionally crash the hypervisor.
- [Critical] Wrong architectural valid bit is used for L1 ITS table entries=
, breaking L2 table donation.
- [Critical] EL2 ITS emulation handlers process host commands without acqui=
ring `its->its_lock`, creating a critical data race.
- [Critical] Software rollback of EL2 ITS tracking state on command timeout=
 leaves hardware desynchronized, allowing memory corruption.
- [Critical] Missing alignment validation for Level 2 table physical addres=
ses allows hardware masking exploits.
- [Critical] `get_num_itt_pages` ignores intra-page offsets, allowing unali=
gned ITTs to overflow into unverified memory.
- [High] Missing rollback on partial command processing failure leaks donat=
ed pages and desynchronizes EL2 metadata.
- [High] Undefined Behavior via unsafe bitshift on host-controlled `table->=
order`.
- [High] `check_table_update` incorrectly returns early during rollback, pe=
rmanently leaking Level 2 table pages.
- [High] Error path for `kvm_iodev_add` failure completely bypasses shadow =
resource teardown.
- [High] Potential resource leak due to unaligned `cmdq_len` calculating to=
 0 pages during teardown.
- [High] ITS indirect table entries are accessed natively instead of little=
-endian, breaking behavior on big-endian kernels.
- [High] Bitwise calculation donates 0 pages if the ITS table page size is =
smaller than the KVM page size, breaking isolation.
- [Medium] `track_pfn_remove` fails to clear the device tracking entry if t=
he PFN remains pinned by another device, causing a resource leak.
--

--- Patch [7]: [PATCH v2 07/13] KVM: arm64: Restrict host access to the pri=
vate ITS tables ---
commit 427f53daa5c5d6b87ee6ee19cf96de15042a131a
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Restrict host access to the private ITS tables

Make the last level of the tables(DeviceTable, Collection and vPE)
inaccessible to the host by donating them to the hypervisor. This prevents
a compromised host from patching an entry with an address that it wants to
write to and then using an ITS command to write over the memory content
from that address.

> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/n=
vhe/its_emulate.c
> index e943ab972aa5e..1ce2f9d8fcf9c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> @@ -237,6 +237,20 @@ static int pkvm_setup_its_shadow_cmdq(struct its_hos=
t_state *host_state)
>  	return ret;
>  }
> =20
> +static void pkvm_teardown_its_shadow_cmdq(struct its_host_state *host_st=
ate)
> +{
> +	u64 i, start_pfn, num_pages =3D host_state->cmdq_len >> PAGE_SHIFT;

[Severity: High]
Does this code leak hypervisor memory if the command queue is unaligned?

If the host-provided host_state->cmdq_len is less than PAGE_SIZE (e.g., a
4KB command queue on a KVM host with 64KB pages), host_state->cmdq_len >>
PAGE_SHIFT evaluates to 0.

The subsequent loop to unshare and the call to __pkvm_hyp_donate_host
execute 0 times, leaking the shadow command queue pages in the hypervisor.

> +
> +	start_pfn =3D hyp_virt_to_pfn(host_state->cmd_host_copy);
> +	hyp_unpin_shared_mem(host_state->cmd_host_copy,
> +			     host_state->cmd_host_copy + host_state->cmdq_len);
> +
> +	for (i =3D 0; i < num_pages; i++)
> +		WARN_ON(__pkvm_host_unshare_hyp(start_pfn + i));
> +
> +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(host_state->cmd_original=
), num_pages));
> +}
> +

[ ... ]

> +static int pkvm_host_unmap_last_level(void *shadow, size_t num_pages, u3=
2 psz)
> +{
> +	phys_addr_t table_addr;
> +	u64 *table =3D shadow;
> +	int i, end;
> +	int ret;
> +
> +	end =3D (num_pages << PAGE_SHIFT) / sizeof(*table);
> +	for (i =3D 0; i < end; i++) {
> +		if (!(table[i] & GITS_BASER_VALID))
> +			continue;

[Severity: Critical]
Does this code use the wrong architectural valid bit for L1 ITS table
entries?

The condition checks if (!(table[i] & GITS_BASER_VALID)) to verify L1
table entries. However, GITS_BASER_VALID is bit 62, which is architecturally
reserved as zero for memory-resident L1 table entries. The actual Valid bit
is architecturally bit 63.

This evaluates to true, the loop continues, and no L2 tables are ever
unmapped or donated.

This issue is also present in check_table_update():

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
	if (!((new_entry ^ prev_entry) & GITS_BASER_VALID))
		return 0;
    ...
}

> +
> +		table_addr =3D table[i] & PHYS_MASK;
> +		ret =3D __pkvm_host_donate_hyp(hyp_phys_to_pfn(table_addr), psz >> PAG=
E_SHIFT);
> +		if (ret)
> +			goto err_donate;
> +	}
> +
> +	return 0;

[ ... ]

> +static int pkvm_setup_its_shadow_baser(struct its_host_state *host_state)
> +{
> +	u64 baser_val, num_pages;
> +	void *original_table, *snapshot_table;
> +	int ret;
> +	int i;
> +
> +	for (i =3D 0; i < GITS_BASER_NR_REGS; i++) {
> +		baser_val =3D host_state->tables[i].val;
> +		if (!(baser_val & GITS_BASER_VALID))
> +			continue;
> +
> +		original_table =3D kern_hyp_va(host_state->tables[i].base);
> +		num_pages =3D (1 << host_state->tables[i].order);

[Severity: High]
Does this code trigger undefined behavior through an unsafe bitshift?

If the host supplies a table->order value of 31 or greater, (1 << order)
overflows into the sign bit because the literal 1 is a signed 32-bit intege=
r.

This overflow leads to improper memory sizing.

This issue is also present in check_table_update():

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
	lvl1_table_sz =3D (1 << table->order) << PAGE_SHIFT;
    ...
}

[Severity: Critical]
Can the host bypass ITS table protection via mismatched virtual-to-physical
address mapping?

The host supplies host_state->tables[i] where .base is a dummy virtual
address it owns, but .val contains the physical address of hypervisor memor=
y.
pkvm_setup_its_shadow_baser() donates the dummy page at .base:

> +		ret =3D __pkvm_host_donate_hyp(hyp_virt_to_pfn(original_table), num_pa=
ges);

Then baser_write() sets the hardware GITS_BASER directly to the physical
address in .val without verifying they correspond:

arch/arm64/kvm/hyp/nvhe/its_emulate.c:baser_write() {
    ...
	baser =3D its->host_state->tables[baser_idx].val;
    ...
	value |=3D (baser & GENMASK_ULL(47, 12)) | (baser & GENMASK_ULL(9, 0));
	writeq_relaxed(value, its->base + offset);
    ...
}

This allows the host to point the hardware ITS at arbitrary EL2 memory,
bypassing KVM's memory isolation.

> +		if (ret)
> +			goto err_donate;

[ ... ]

> @@ -294,6 +449,10 @@ int pkvm_its_emulate_setup(phys_addr_t dev_addr, str=
uct its_host_state *host_sta
>  	if (ret)
>  		goto err_with_host_state;
> =20
> +	ret =3D pkvm_setup_its_shadow_baser(host_state);
> +	if (ret)
> +		goto err_with_shadow_cmdq;
> +
>  	hyp_spin_lock_init(&priv_state->its_lock);
> =20
>  	priv_state->host_state =3D host_state;
> @@ -312,6 +471,8 @@ int pkvm_its_emulate_setup(phys_addr_t dev_addr, stru=
ct its_host_state *host_sta
>  	hyp_spin_unlock(&its_setup_lock);
> =20
>  	return 0;
> +err_with_shadow_cmdq:
> +	pkvm_teardown_its_shadow_cmdq(host_state);
>  err_with_host_state:
>  	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(host_state), 1));
>  err_with_priv:

[Severity: High]
Does this code skip critical hypervisor-side resource cleanup when
kvm_iodev_add fails?

If kvm_iodev_add fails during initialization, the code executes goto
err_with_priv; which is located after the teardown labels err_with_shadow_c=
mdq
and err_with_host_state.

This skips the cleanup of the shadow structures and permanently leaks shadow
ITS command queues and donated memory.


[Severity: High]
Does process_its_mapd() leak donated pages and desynchronize EL2 metadata
when partial command processing fails?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:process_its_mapd() {
    ...
	ret =3D check_table_update(its, device_id, GITS_BASER_TYPE_DEVICE, rollbac=
k);
	if (ret)
		return ret;

	return track_pfn(its, device_id, itt_pfn, num_pages, remove);
}

If check_table_update() succeeds in donating an L2 page but the subsequent
track_pfn() fails, process_its_mapd() returns an error directly.

This error is propagated to cwriter_write(), which blindly returns without
invoking rollback:

arch/arm64/kvm/hyp/nvhe/its_emulate.c:cwriter_write() {
    ...
		if (process_cmd(its, &cmd, /* rollback */ false))
			return;
    ...
}

This leaves EL2 metadata desynchronized from the actual hardware execution
and permanently leaks L2 table pages in EL2 memory.


[Severity: Medium]
Does track_pfn_remove() leak resources by failing to clear the device track=
ing
entry if the PFN remains pinned?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:track_pfn_remove() {
    ...
		ret =3D __pkvm_host_unshare_hyp(pfn);
		if (ret =3D=3D -EBUSY) {
			hyp_unpin_shared_mem(virt, virt + PAGE_SIZE);
			ret =3D __pkvm_host_unshare_hyp(pfn);
			if (ret =3D=3D -EBUSY)
				return 0;

			WARN_ON(ret);
		}

		memset(&entries[i], 0, sizeof(struct dte_entry));
    ...
}

If an ITT page is shared between multiple devices and __pkvm_host_unshare_h=
yp()
returns -EBUSY, the function executes an early return 0;, skipping the
memset() step. This leaves a zombie entry in the fixed-size
its->tracked_entries array.


[Severity: High]
Does check_table_update() incorrectly return early during rollback, permane=
ntly
leaking Level 2 table pages?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
	new_entry =3D snapshot_table[new_entry_index];
	prev_entry =3D original_table[new_entry_index];
	if (!((new_entry ^ prev_entry) & GITS_BASER_VALID))
		return 0;
    ...
}

When a command fails and check_table_update() is called with rollback=3Dtru=
e,
it evaluates ((new_entry ^ prev_entry) & GITS_BASER_VALID). Since the forwa=
rd
pass already updated original_table to match snapshot_table, both entries a=
re
identical and their XOR is 0.

The function erroneously returns 0 early, skipping the rollback donation lo=
gic
entirely.


[Severity: Critical]
Does check_table_update() contain a time-of-check to time-of-use vulnerabil=
ity
during rollback that allows a malicious host to crash the hypervisor?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
	new_entry =3D snapshot_table[new_entry_index];
    ...
	if (rollback)
		new_entry =3D new_entry ^ GITS_BASER_VALID;

	if (new_entry & GITS_BASER_VALID)
		ret =3D __pkvm_host_donate_hyp(hyp_phys_to_pfn(new_entry & PHYS_MASK),
					     table->psz >> PAGE_SHIFT);
    ...
}

During rollback, KVM re-reads new_entry from the host-shared snapshot_table.
If the host concurrently mutated it to have the valid bit cleared, the XOR
check proceeds. The rollback logic then flips new_entry to be valid and KVM
attempts to call __pkvm_host_donate_hyp() on the physical address embedded =
in
this host-controlled new_entry.

If the address is invalid, the donation fails, and the returned error is bl=
indly
wrapped in a fatal WARN_ON in cwriter_write(), crashing EL2:

arch/arm64/kvm/hyp/nvhe/its_emulate.c:cwriter_write() {
    ...
		if (submit_single_cmd(its, retry)) {
			WARN_ON(process_cmd(its, &cmd, /* rollback */ true));
			return;
		}
    ...
}


[Severity: Critical]
Does cwriter_write() process host commands without acquiring its->its_lock,
creating a critical data race?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:cwriter_write() {
	struct its_priv_state *its =3D region->priv;
	struct its_cmd_block cmd, raw;
	u64 new_offset;
	bool retry;
	int i;

	new_offset =3D value & GITS_CWRITER_OFFSET;
    ...
}

The cwriter_write() MMIO handler modifies its->cmd_offset and shared intern=
al
tracking structures like its->tracked_entries without acquiring its->its_lo=
ck.
A malicious host can issue concurrent writes to GITS_CWRITER from multiple
physical CPUs, causing the unlocked code running at EL2 to corrupt its own
metadata.


[Severity: Critical]
Does cwriter_write() leave hardware desynchronized on command timeout,
allowing memory corruption?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:cwriter_write() {
    ...
		if (submit_single_cmd(its, retry)) {
			WARN_ON(process_cmd(its, &cmd, /* rollback */ true));
			return;
		}
    ...
}

If the hardware stalls, submit_single_cmd() times out. EL2 then rolls back
its software metadata, returning the ITT page to the host. However, the
physical hardware queue has already advanced.

When the hardware un-stalls and processes the command, it will use the phys=
ical
page as an ITT, blindly overwriting whatever data the host subsequently pla=
ced
there.


[Severity: Critical]
Does check_table_update() miss alignment validation for Level 2 table physi=
cal
addresses, allowing hardware masking exploits?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
	if (new_entry & GITS_BASER_VALID)
		ret =3D __pkvm_host_donate_hyp(hyp_phys_to_pfn(new_entry & PHYS_MASK),
					     table->psz >> PAGE_SHIFT);
    ...
}

KVM donates the range starting at the physical address provided in new_entr=
y,
without verifying the address is appropriately aligned to table->psz. The
hardware ITS expects addresses aligned to table->psz (e.g., 64KB) and will
implicitly mask lower bits.

If the host provides a 4KB-aligned address inside a 64KB region, KVM donates
the 64KB range starting there, but the hardware accesses the true 64KB-alig=
ned
base below it, writing into hypervisor memory that was never checked or don=
ated.


[Severity: Critical]
Does get_num_itt_pages() ignore intra-page offsets, allowing unaligned ITTs
to overflow into unverified memory?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:get_num_itt_pages() {
    ...
	sz =3D max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
	return PAGE_ALIGN(sz) >> PAGE_SHIFT;
}

get_num_itt_pages() calculates the required pages using PAGE_ALIGN(sz) >>
PAGE_SHIFT, completely disregarding the starting alignment of itt_addr, whi=
ch
only has a 256-byte alignment requirement.

If an ITT fits within a single page logically but crosses a page boundary
physically (e.g., size 512 bytes starting near the end of a page), the math
returns 1 page. KVM pins only the first page, allowing the hardware ITS to
write into the unpinned next page, potentially corrupting hypervisor state.


[Severity: High]
Does check_table_update() access ITS indirect table entries natively instead
of little-endian, breaking behavior on big-endian kernels?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
	new_entry =3D snapshot_table[new_entry_index];
    ...
}

The host Linux driver architecturally writes GIC structures in little-endian
format (cpu_to_le64). The KVM hypervisor accesses these memory-resident
entries via a native 64-bit load.

On a big-endian system, the resulting bytes are swapped, causing validation
checks and physical address extractions to return completely incorrect valu=
es.


[Severity: High]
Does check_table_update() donate 0 pages if the ITS table page size is smal=
ler
than the KVM page size, breaking isolation?

arch/arm64/kvm/hyp/nvhe/its_emulate.c:check_table_update() {
    ...
	if (new_entry & GITS_BASER_VALID)
		ret =3D __pkvm_host_donate_hyp(hyp_phys_to_pfn(new_entry & PHYS_MASK),
					     table->psz >> PAGE_SHIFT);
    ...
}

KVM determines the amount of memory to donate for L2 tables using
table->psz >> PAGE_SHIFT. If the hardware is configured to use a smaller
page size than the hypervisor (e.g., psz=3D4096, KVM PAGE_SIZE=3D65536), th=
is
evaluates to 0.

__pkvm_host_donate_hyp() receives 0 pages and the host retains full write
access to the table memory, bypassing isolation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D7
