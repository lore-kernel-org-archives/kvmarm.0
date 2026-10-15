Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFC144237C
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792098011; cv=none; b=TXOsF/5fKEjQtJPbQVsdkfxZPZcs6s8cIqAtI9+FV/Qh6Qg2CmqAr9z2frs+MdGEF/8iXlvROO4Ecdcy61l/4ws0pPnw1R3Dsno1HehX5sM2QHJv6BSdatSlwevyL22Tqn3p69c10p+mqsW2X7BZHQbJle+33WP0UJDayIY0vgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792098011; c=relaxed/simple;
	bh=Xa7nD3n6mjT7i/Y5Cbo7vd4OEnKnMlJ9CUNAfbld3rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPzhsRESl8XWFV4aiwVNRgKN1B7xMkMj/G6d8mh3rreVerpuO4pIEQ2CibT256XenybfwN5waVlrMUtt1kN5DKooUmmr25SSlcunLmzDbDVc0tvvNpGMh+Uh/d83he/BV0NjmKpEKTlugABTP+G8oAuyYnCs7nZPGyGzyDCi050=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EiBzXokW; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EiBzXokW"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a018493d57so20145e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792098007; x=1792702807; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lfjo2UUCfy9LtemPhtrDOegai3WrH7Ts3lTNM18z7J8=;
        b=EiBzXokWYpamkIp7yWmgPPPOhgP6cnneA2n25bV6N0abqRQZhqU7GrNX164klV5B3l
         uqdHa+P5VJ2ChsrIganWK4V26vqdi4nvyDuLxZNp7/P46G/Fss+Da5J04RGn1tnSe1a7
         L2axYAO5HoGyufs2G70tlm+EWYztgsCSd3Bh365N4FlnSYAamWgdj3IiOcfkuLm0MOmm
         e+CTWILZb8HtdSNFRMBYT8jmO1Er5ShHi2eWqoqVTJomZRYEpg2S/Iad+NLINLY8UdSq
         OGvp1sZ/bLF/MnWub1enPshW1SnaB5LFctfO9BO+/G0AlOY230Ddao6uQ5s3gZr294ks
         BHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792098007; x=1792702807;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Lfjo2UUCfy9LtemPhtrDOegai3WrH7Ts3lTNM18z7J8=;
        b=fAdd2qfTEezu5utUEHPS4FC2H7wjtDp1khBKDbgByTFFICGafjmf8Tj3/1gO7YJdME
         izEJKy8JPdfgr3NX4vw3+gn/o/mBsSv5bSHotDmL2KPpj/H6w6Of2MEkKuAjf+cjXiJx
         +esOMLb26jLnENJip5KoXJ36VOm80hRoSwMq/fZwUHfl8FM9NiqggTglivy4b4vzE+ms
         s9KPM49loTc8CVB1HcogZvQYOFGA5wLvRYdyxFUByGCkO5khemtwrdgaIm0i6+Bn28WQ
         xjhiHsJ1Od0Gy6OBw+GgRWFaGuoc9fYALGBxlL9YbfadctV21n8xXyVOw0Ru9VqgnjIB
         kFlg==
X-Gm-Message-State: AFq9FYKKcyk5Ty1gjKuMWDBcBL3oEuHa5vAQ+K6EL4Lh54QuCVbg2QW7
	LsDpP2TAllRwHarQWTqP0prynA4Wih69idRiU1sTPcuQ5aJDW5OHBt8l8QLTtyMQLEwo4QtDAXH
	GwpNrXw==
X-Gm-Gg: AYBFou27ryh1XHIJNr/uhiWcG8NG7EFndF0S1B/jZawH11jiUwExlMYH2AIK8nbREKX
	S9ides6eml1/AasqZ+ADx5blpDbOlIdWdYoj4lSW5tFtda4BRoBRQjjxTk4GGqeVS6TdXd+jfv+
	6SfPLYCbVds1v93regEd26epEYAjEk0oI374/jm8vufGHB3v/i3DZvbYblHRsJPBxlILER6Vcn0
	ucjbv4saDdz9y7A1AWHX0eepOn75XD6acp5Sjy4hYq/chcZQmtBa2tPKyrdys0mnKJ2uO2DK/uH
	vYbyhbDVUVSY1bFMZxO7B4xiPo9hScYVPFA97p4Xi4L6fcP5t+i7bxpPn+LS+VdKbegYacF7j4n
	6RnWB09RcQhIVYC1pTEqG9diJzCb/bD/l+FAGzvZuWINeeyUIRycO0ZTPdQlGAeBv122N3h/lMV
	EAK0fVQDhk6M3okta5SW1wtOpn9HeswrJqzuIkmPRjyNRtmekwAn5pt+ENhTXAsKuRV01WRfZui
	SO0x55bq3I9y6uVUlpfXIDYhl7JT/bE3MhwrAr0
X-Received: by 2002:a05:600d:8646:20b0:4a1:96a5:3672 with SMTP id 5b1f17b1804b1-4a1c8abd6b0mr72025e9.7.1792098006120;
        Thu, 15 Oct 2026 14:00:06 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd68585csm61787935e9.4.2026.10.15.14.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:00:05 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:00:01 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 13/25] iommu/arm-smmu-v3-kvm: Add MMIO emulation
Message-ID: <atE-0eX2chHOLWJJ@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-14-smostafa@google.com>
 <sashiko-outbox-173397@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173397@kernel.org>

On Thu, Oct 15, 2026 at 08:30:38PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] iommu: mmio emulation bitwise logic corrupted on big-endian hosts
> --
> 
> commit 5a437530a55c608782e029a478141ad9b342c024
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Add MMIO emulation
> 
> This commit adds a data abort handler for the SMMUs to handle MMIO emulation.
> Currently, most registers act as a passthrough, and upcoming patches will
> add CMDQ/STE emulation with logic for specific register access.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> [ ... ]
> > @@ -128,6 +132,170 @@ static int smmu_init(void)
> > +static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> > +			     struct user_pt_regs *regs,
> > +			     u64 esr, u32 off)
> > +{
> [ ... ]
> > +	bool is_xzr = (rd == 31);
> > +	u64 val = is_xzr ? 0 : regs->regs[rd];
> 
> [Severity: High]
> Does extracting the register value directly from the CPU context here bypass
> endianness conversion on big-endian hosts?

mmm, I haven't considered that before.
However, BE support was removed on arm64 [1]
https://lore.kernel.org/all/20260918145217.1669-1-will@kernel.org/

So, I'd say keep it as is.

> 
> When the host (EL1) uses writel_relaxed() on a big-endian machine, it
> byte-swaps the native value to little-endian representation before issuing
> the store. The MMIO trap then retrieves this raw, byte-swapped value
> directly into val.
> 
> > +
> > +	switch (off) {
> > +	case ARM_SMMU_IDR0:
> [ ... ]
> > +	case ARM_SMMU_CR0:
> > +		if (len != sizeof(u32))
> > +			break;
> > +
> > +		if (is_write) {
> > +			/* Enforce ATS checks. */
> > +			if (smmu->features & ARM_SMMU_FEAT_ATS)
> > +				val |= CR0_ATSCHK;
> 
> [Severity: High]
> Can this bitwise operation corrupt the configuration on big-endian hosts?
> 
> Because val contains a byte-swapped value, applying a native bitmask like
> CR0_ATSCHK modifies bits at the wrong offset.
> 

Same as above.

> > +			mask = read_write;
> > +		} else {
> > +			mask = read_write & ~CR0_ATSCHK;
> > +		}
> > +		break;
> [ ... ]
> > +	if (is_write) {
> > +		if (len == sizeof(u64))
> > +			writeq_relaxed(val & mask, smmu->base + off);
> > +		else
> > +			writel_relaxed(val & mask, smmu->base + off);
> 
> [Severity: High]
> Will this double-swap the corrupted value?
> 
> Since val was already byte-swapped by the host's write, writing it back
> using EL2's writel_relaxed() applies a second byte-swap, propagating the
> incorrect state to the SMMU hardware.
> 
> Read paths face a similar issue where the readl_relaxed() output is passed
> directly to the guest without being swapped back into the format expected by
> the guest's own le32_to_cpu() calls.
> 

Same as above.

Thanks,
Mostafa

> > +
> > +		hyp_spin_unlock(&smmu->hw_lock);
> > +		return true;
> > +	}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=13
