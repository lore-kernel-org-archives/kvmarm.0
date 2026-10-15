Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2F549B5B3
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099090; cv=none; b=CM51A0nW3bMl7jY9jsnAUHNaGXxTZHPqE1/7gtIGE4qggYYwxmzrvQNrgpbFbeoZyT6Ip8eDto9QaUwxUnyXQfjY+o8P9B8mXofC9TCEsFn4Kt9ZhYqbi4rkPKixC12pUULtbrEt/kPAel1jg1uL9reHLHp0TReSP0B3SF3l3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099090; c=relaxed/simple;
	bh=LMBAf2/vas6JaCOvZ0cUaeg3YXiUsxQIPPIqfBm9DPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4brv/7aQWXci2UhjMIccEtq2AL0kJH1C4bxaXVMcTGeBRKjA5DzTcqI6sY6xgng0wTJYSfwC3Nuwmh0ArY98iP/vEd4XGu2+pu2AHp6vbkKPLEVOnoTnGSgXu3pzk+DvdJIXD88bhlXcuTkWQg3wfBQg4B7/Gqb+LabuT83lsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W8lFH+dv; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W8lFH+dv"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a018493d57so21475e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792099082; x=1792703882; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mGhCiCxy/Vk9JPlIBjpq29kn1QBSCOPFUhyy8hBKHRE=;
        b=W8lFH+dvNRIqzE8USNLcMwaWXlscPTrpGldpibJuqSVhuUFjy79OP5P0RWac2F2bXR
         yLmcBUHOtGOCIfqjt2cVaNgAx2jbbEOAW2ysF8B4oX5AAuw7O5Dq+RiLymeVkPPGWVl5
         17B/l+O4KYYeeRh7UMHqRzRD0HqLzdNcxlJZG61+BVfDkQH2WPBFwRstZd5sOobm7Z3R
         NK16HjUeIyNS3xzW+na7TKbsDgZdgnnB4FA18OPeJAZLP2NFgTBYf8b+8uVfFHTdP9S1
         DVN4CPFbS1Cr29zX7j4b4K8NM/uw6+qHNXvvnXpXnFQ5a4GT5WRsRsaafuEXkLj/vx5a
         eo6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099082; x=1792703882;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mGhCiCxy/Vk9JPlIBjpq29kn1QBSCOPFUhyy8hBKHRE=;
        b=dQc1jZiO+b23lT0L66r7/aZ2pzXW/wN2pFpshm9rnQa5jyP1y6jf10tsAZLxVyhblx
         IQpiAS5Bv0Dlqq9BRiXUCBlUnLXuAfFNxv9akDBriQeNOIw+ukbAPMawvpB+ZUL3ZTaH
         8QNAhuwBWxomYhdbrAS/J5WMMJkyWP0/QOZx7PU8a8dcCBbuTWdDuO/+moYijCE1wNBn
         74HNfasMyOCW1IY/of4s8no0Zual4CmOYjL9cXTZy71EZXIiW5qwWvxk3g0ZpUcxbdT3
         uKEWWB3axhlxOMEmv5SXnz0+ZoTNiwYfxI9Axxz98rOxexsDB5ZNGcK7LKXlagu3YDY8
         jCGA==
X-Gm-Message-State: AFq9FYKqDkZ7ZTZ1QtxTlnFvqV/NHD1riiUIfdghsdfWqJYY3BCjqIEO
	DFEYXkjLTzWSmfHJ1fT4rCGA/xySl8G/nvmwVofvl8G1MXXfSdbCexS9WNZyb6mgXQ==
X-Gm-Gg: AYBFou0YkKUcRECwSs2YgQb+gfh7s1lPFKbRyzB2ylt8JHaT/GcZE7EzrdKk/OEETH1
	bt/NjL7SLj3tMZM9t0uxd42HYiIeO5MDXGd+QJ/Z85TN7N5p1zGZQEt2TNwmYPhg4AAW6ckF1hr
	vSTt2ZVr+VsRQ9yWLIvitAAWIsQL6zFFBhVqEm7+7YD9bqpDf1hgC+q4ZIzudADKxgFNnmxQkeD
	4tjO5S40EE2PVnCYtr6ZWyYUVyJU6ewgPCRI1FT06aghVhM6ZgyN8MoERGKHb4TF91CVHe1zzVu
	T1Z46yk3fyHhgx/YVGA+WOxbfgJrMFWu+YvQLOsBqjfeS+Iq3jSrgpyoVRt2lLywrChjZUOIbmz
	ZDgKG8/1G5aJCnAv1ob7eDTo0DwP6uY6OdeFU6Wh77wsJuO3AEZehZHRuFpHbGSGDV3vjpudMS4
	F+Rs3EUGBfRovwzUzrKVqESuEOgcsYAIXPr3pYhsQXr26O3HAafox0RMB3oGKBoq9ZpyzXaUgrD
	O1fPQyj43QloiP/wGIuI5mde0v17UMrFnc1bpVG
X-Received: by 2002:a05:600c:a5a8:b0:49c:ff18:79bd with SMTP id 5b1f17b1804b1-4a1c8abfb3amr95775e9.9.1792099082124;
        Thu, 15 Oct 2026 14:18:02 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9b8ebdsm113632015e9.10.2026.10.15.14.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:18:01 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:17:58 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 16/25] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <atFDBjY66Ucu0pd5@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-17-smostafa@google.com>
 <sashiko-outbox-173396@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173396@kernel.org>

On Thu, Oct 15, 2026 at 08:30:32PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Critical] iommu/arm-smmu-v3-kvm: user-triggerable hyp panic via unhandled SMMU commands (e.g., CMDQ_OP_ATC_INV)
> - [Critical] iommu/arm-smmu-v3-kvm: CMD_SYNC filter allows arbitrary memory writes via SIG32
> - [High] iommu: EL2 panic on SMMU hardware timeout or CERROR due to WARN_ON
> - [Medium] arm-smmu-v3-kvm: Dead-branch traps due to WARN_ON() panicking at EL2
> --
> 
> commit 44f2b5e9d53208cadd7d659b59bf05189d20f72d
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
> 
> This commit introduces command queue emulation for the host in the ARM SMMUv3
> pKVM driver. It filters command queue entries, shadows the queue, and prevents
> the host from directly manipulating the hardware command queue to ensure isolation.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > index c9fc21e405e79..dc9b1e659a422 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> [ ... ]
> > +static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *command)
> > +{
> > +	u64 type = FIELD_GET(CMDQ_0_OP, command[0]);
> > +
> > +	switch (type) {
> [ ... ]
> > +	case CMDQ_OP_TLBI_NH_ASID:
> > +	case CMDQ_OP_TLBI_NH_VA:
> > +	case CMDQ_OP_TLBI_NH_ALL:
> > +	case 0x13: /* CMD_TLBI_NH_VAA: Not used by Linux */
> > +	{
> > +		/* Only allow VMID = 0 */
> > +		if (FIELD_GET(CMDQ_TLBI_0_VMID, command[0]) != 0)
> > +			return true;
> 
> [Severity: Critical]
> Could this reject valid nested-translation TLBI commands? A host userspace
> process with IOMMUFD nested translation might legitimately trigger invalidation
> commands (like CMDQ_OP_TLBI_NH_VA) where the host injects a non-zero VMID.
> 
> Because this returns true, the command gets rejected, which later leads to a
> hypervisor panic (see below) triggered directly from userspace.
> 

Wrong, the host kernel only sees a single stage SMMUv3, so it can't issue
non zero VMID or IPA invalidations.

> > +		break;
> > +	}
> > +	case CMDQ_OP_PREFETCH_CFG:
> > +	case CMDQ_OP_CFGI_CD:
> > +	case CMDQ_OP_CFGI_CD_ALL:
> > +	case CMDQ_OP_TLBI_NSNH_ALL:
> > +	case CMDQ_OP_PRI_RESP:
> > +	case CMDQ_OP_RESUME:
> > +		break;
> > +	case CMDQ_OP_CMD_SYNC:
> > +		if (FIELD_GET(CMDQ_SYNC_0_CS, command[0]) == CMDQ_SYNC_0_CS_IRQ) {
> > +			/* Do not allow MSI */
> > +			command[0] &= ~CMDQ_SYNC_0_CS;
> > +			command[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
> > +			command[1] &= ~CMDQ_SYNC_1_MSIADDR_MASK;
> > +		}
> 
> [Severity: Critical]
> Does this allow the host to inject an SMMU hardware instruction that executes
> an arbitrary physical memory write? The filter specifically neutralizes CS=1
> (IRQ), but it appears to ignore CS=3 (SIG32). If a malicious host issues a
> CMD_SYNC with CS=3, the hardware might perform a 32-bit physical memory write
> of the host-provided MSIData to the host-provided MSIAddress, compromising the
> hypervisor or guest memory.

As mentioned in v8:
https://lore.kernel.org/all/20260922133237.5A5381F000FF@smtp.kernel.org/

This is not true, there is no such encoding in the spec.

> 
> > +		break;
> > +	default:
> > +		/* Deny unknown commands */
> > +		return true;
> 
> [Severity: Critical]
> Could valid user-triggerable commands hit this default case? For example,
> CMDQ_OP_ATC_INV appears to be missing from the allowlist. Since it returns
> true, this will also result in a user-triggerable hypervisor panic when the
> caller evaluates the rejection.
> 

ATS is hidden from IDR0, the kernel shouldn't attempt to use it.

> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> [ ... ]
> > +		skip = smmu_filter_command(smmu, cmd);
> > +		if (WARN_ON(skip))
> > +			continue;
> 
> [Severity: Medium]
> Will this execute the continue statement? At EL2 in nVHE/pKVM, WARN_ON() expands
> to a BRK instruction and triggers a fatal hypervisor panic. Because the macro
> doesn't return, the error-handling path is dead code, and rejecting a command
> results in a hard panic.
> 
> This also elevates the severity of the filter rejections mentioned above. If
> userspace can trigger a rejected command (like CMDQ_OP_ATC_INV or a nested
> TLBI with VMID != 0), it becomes a Denial of Service attack against the host
> system.
> 

Again, by design, any unsupported command will panic, that can be
relaxed, but that only happens if the kernel is malicous or buggy so
I'd prefer to catch the place caused the issue to make that easier to
debug.

> > +		smmu_add_cmd_raw(smmu, cmd);
> > +	}
> > +
> > +	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
> > +
> > +	ret = smmu_wait(false, smmu_cmdq_empty(&smmu->cmdq));
> > +	hyp_spin_unlock(&smmu->hw_lock);
> > +	return ret;
> > +}
> [ ... ]
> > +static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> > +			     struct user_pt_regs *regs,
> > +			     u64 esr, u32 off)
> > +{
> [ ... ]
> > +	case ARM_SMMU_CMDQ_PROD:
> > +		if (len != sizeof(u32))
> > +			break;
> > +		if (is_write) {
> > +			smmu->cmdq_host.llq.prod = val;
> > +			WARN_ON(smmu_emulate_cmdq_insert(smmu));
> 
> [Severity: High]
> Can a hardware timeout or CERROR cause a hypervisor panic here?
> smmu_emulate_cmdq_insert() relies on smmu_wait() to check if the hardware
> command queue is empty. If the SMMU hardware halts due to an error or takes
> too long under heavy load, smmu_wait() returns -ETIMEDOUT.
> 
> Because the return value is wrapped in WARN_ON(), this timeout will be
> converted into a fatal EL2 panic instead of propagating the error.
> 

Yes, if the HW hangs, we can't return as the TLB state might leak
donated memory, so in that case we have to panic.

> > +			goto out_ret;
> > +		} else {
> > +			val = smmu->cmdq_host.llq.prod;
> > +			goto out_update_regs;
> > +		}
> > +	case ARM_SMMU_CMDQ_CONS:
> > +		if (len != sizeof(u32))
> > +			break;
> > +		if (is_write) {
> > +			if (WARN_ON(is_cmdq_enabled(smmu)))
> > +				break;
> 
> [Severity: Medium]
> Similar to the dead-branch trap above, the break statement here appears to be
> unreachable code. Because WARN_ON() expands to a fatal BUG() at EL2, writing
> to the CMDQ_CONS register when the queue is enabled will panic the hypervisor
> instead of just ignoring the write.

Yes, that just looks cleaner, similar patterns used in mem_protect.c,
compilers are smart now and will remove it.

Thanks,
Mostafa

> 
> > +
> > +			smmu->cmdq_host.llq.cons = val;
> > +			goto out_ret;
> > +		} else {
> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=16
