Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C123DD847
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779084322; cv=none; b=NrbDc7QxJiksA0JjNSu5cmxq/4u9mBv5/UgL7bvPyk1E7pwKLkYRZ4WYUfOxaEHME8q+qHY6mUKj063fycVPGNSodtoLLeji2Yoyj4/YAaubAXVkbYucdQGQQ7rTJpUxFN27XRcFuBwb8KOZoW35VaEOvGFSkAGSGilBnphjL70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779084322; c=relaxed/simple;
	bh=pKC1G6pUlZ+zn+dB9l5JMTbv6ZGTT3NyvmHGZEdViQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjEjcs1REKbJYWjSK2fcBwMM+/SfTqYM4QL7jwdUZTys50wsTBxRJaRn+e4+vyCNBvETycQ+ZU5ECsclL4/qeeN5YamLQNbV3z4gdS4sSl0fGV9NBjRvqw5JVeAv+bzZoH5FQKMq5deXiIDV/8XsZNw3MrORAc0Fxyb1VFPMcLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=U6RcwSU7; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="U6RcwSU7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779084315; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=PwP076I/SbrBnwh9hhmLpYzId0geiVgIKLZ2AElPwTQ=;
	b=U6RcwSU7G7hRSt7F2+Ku9VlkHQzwFO9CgfVTgjKmrMWmPqaWoJMfzIIEK4WmRLGhQRYTBfvNdlMAbTXPL0Ob2HfY4n+EN80qtZB+ONyMRjNdFFWV3dzmO9zSuPSYsj4DOVxVRxpI58nzzkPBn1IIJ1dyqF2AF0zCGMWMyZZ+cOk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X33TsTD_1779084313;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X33TsTD_1779084313 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 14:05:14 +0800
Date: Mon, 18 May 2026 14:05:13 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-its: reject restored DTE with
 out-of-range num_eventid_bits
Message-ID: <w6zdprlry2y37wtkirv4zhiy5awau3stbkjohmvfwkswgoaafe@ul53z6xwyuhw>
References: <20260517174955.273004-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517174955.273004-1-michael.bommarito@gmail.com>

On Sun, May 17, 2026 at 01:49:55PM +0800, Michael Bommarito wrote:
> Userspace can trigger a host-side denial of service via
> KVM_DEV_ARM_ITS_RESTORE_TABLES. A Device Table Entry whose Size
> field encodes num_eventid_bits > VITS_TYPER_IDBITS reaches
> scan_its_table() with a sign-extended ~18 EiB length, where the
> loop holds the per-ITS mutex and never calls cond_resched(),
> pinning a host CPU for a time linear in registered guest memslot
> size. The accessor is any process that can open /dev/kvm and
> create a VM. The same out-of-range value also disables a
> subsequent live bounds check on EventID, as described below.
>
> The MAPD command handler already rejects this case in the live
> path:
>
>   if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
>           return E_ITS_MAPD_ITTSIZE_OOR;
>
> vgic_its_restore_dte() reconstructs num_eventid_bits from the DTE
> Size field but does not apply the same cap, so userspace can
> install device state that the live MAPD path is documented to
> reject. The restored value is stored in dev->num_eventid_bits and
> is then used by vgic_its_restore_itt():
>
>   size_t max_size = BIT_ULL(dev->num_eventid_bits) * ite_esz;
>   ret = scan_its_table(its, base, max_size, ite_esz, ...);
>
> scan_its_table() takes the size as int and assigns it to
> unsigned long in the callee:
>
>   static int scan_its_table(struct vgic_its *its, gpa_t base,
>                             int size, u32 esz, ...)
>   {
>           unsigned long len = size;
>
> For num_eventid_bits = 28 the size_t value 0x80000000 truncates to
> INT_MIN as int and sign-extends to ~18 EiB as unsigned long. The
> scan loop then walks the registered guest memslot one ite_esz at
> a time with the per-ITS mutex held and no cond_resched(). In a
> QEMU TCG arm64 guest at EL2 on v7.1-rc1, with an empty ITT, the
> ioctl returned -EFAULT after about 14 seconds with a 256 MiB
> memslot and about 56 seconds with a 1 GiB memslot (linear in
> memslot size). The per-iteration cost on native arm64 KVM
> hardware will differ; the loop shape, and so the linear scaling,
> will not.
>
> The same out-of-range num_eventid_bits also disables the live
> vgic_its_check_event_id() bounds check, because event_id is u32
> and BIT_ULL(32) is unreachable in that comparison, leaving
> subsequent MAPI/MAPTI handling without an effective EventID cap.
>
> Mirror the MAPD cap in vgic_its_restore_dte() before allocating
> the device, so out-of-range restored DTEs are rejected with
> -EINVAL up front rather than triggering the int-truncated scan or
> installing a device whose num_eventid_bits silently disables the
> live bounds check. Sizes within [1, VITS_TYPER_IDBITS] are
> unaffected.
>
> Fixes: 57a9a117154c ("KVM: arm64: vgic-its: Device table save/restore")
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 2ea9f1c7ebcd0..a5dcf9a6a2854 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2307,6 +2307,15 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>  	/* dte entry is valid */
>  	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
>
> +	/*
> +	 * The MAPD command rejects this case; mirror the cap here so a
> +	 * restored DTE cannot install an out-of-range num_eventid_bits
> +	 * that vgic_its_restore_itt() would then convert into a
> +	 * sign-extended scan_its_table() length.
> +	 */
> +	if (num_eventid_bits > VITS_TYPER_IDBITS)
> +		return -EINVAL;

Hi,

IIUC, the same issue is still there when VITS_TYPER_IDBITS
change to >=28, I know it's limited to 16 in GITS_TYPER's
definition. I mean the issue is still there w/o really be
fixed.

Change the scan_its_table() and other related code path to
avoid such date conversion issue is more reasonable
fixing to me, please also wait others' input yet.

> +
>  	if (!vgic_its_check_id(its, baser, id, NULL))
>  		return -EINVAL;
>
> --
> 2.53.0
>
