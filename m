Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D8E230D1E
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758034225; cv=none; b=nDyKX2Nwgx3y7iZMHah0fRvoe9SFdulY8CsQZSVNh4p2N95Aoan4zjKfx5qsIDUQ4hdaWKJv+dJsw+M0tpQ9WLYok4sbD7nJUWuABaA73+PDpnAavZLduqKdr4K5Z39HKITSCOt+fgoQ2h2450SjMYf4+ACPMAWF7FQXnOtsYQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758034225; c=relaxed/simple;
	bh=fbvwpPM3R5lMCHUi2ENLE4gQsD0b4XmRKkbrAcTMxxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j87mVWTrgGFnTxlNWW4Wv71z7e2ZPyPVxcK8uTAhdzTQLjvBrUt75d4IDHow4zMV3VQcmUiDCB+ykciG3DRanEEimt0vtHtdTlGPbxKxOp1QH5xZIbSuylGTH+qSJo7mUYoXkVP0HmLPeVNv9uu8dENU3ssyPZ3MpfVhcnNx8gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NGT0jjqV; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NGT0jjqV"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45f2f894632so58545e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758034222; x=1758639022; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZTpmHXQDrDNu2omvxpv38G1z1jQL9k5zYwI+nHzzx2A=;
        b=NGT0jjqV7m7dAYSotOSJ8ReRS7sD0HjmwYqju9TxUl9lPivoIwmblSQP9C8dGz+ZI2
         02LbrKA8zl1WDzyqXkvHEaI/AY7atE+zKdf87AGDy92XHYyj/aunPRI5dt9uO4ypLDcL
         DBUVvtN7BGEoDiVqALFPrSXd3aG6brL8l6b8swIIahGtxBIaaJuK0xpYhCaYKTGMWrTB
         9/xZi4O0Uc6q0q8dl9W8wa15VaqhMhrEdz2NJ2Q4QH9je4WL5y61RS6ObVbjIYOK2vcx
         RG2KxMonnFoODKag3LY2tYD6Nqa79kEhPCnvMoq6IUzSR3O5OYZEphkv/Qx3Jg+l5KPY
         f47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758034222; x=1758639022;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTpmHXQDrDNu2omvxpv38G1z1jQL9k5zYwI+nHzzx2A=;
        b=RKcRJ7ClGvmn4sDSxTSvT6dTrsNjjslZT/35Xm1W4phIbOvvdp9kyIcjkiAGfGC3ZI
         jAk7u1xHv7mxYeUoO2Y3wtV47A+8S1qbAbapngpjf9Mg/xg9fdh2Xfc6s0WDLZbpaQBJ
         fM61v0EE0CZqBgMKsdxP+oeKJX6LyB3+BT5zwwOhPRU59IOBzavWU4qHJ4DYzrYmOZFE
         72C2H4E9sO5437LHRk1nAZWcAJxq+AoMsKjnGmI+6I6snj6L1ydCbXk8qeV9zPTDpE2+
         REyUX3aEd5/OvU+5GHF7rGl8a16NGBvql2Tmyi7hRFVlA6wiBUubIlCoZoaoP4z/I4IL
         mZNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOsac0azpf2dpqZ0+oM9H9wjurYQDHMWAyrzk+R8IGhKpy/cFTcl9oHal9Kd107G3Z9BLtuC0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBZK1D+pAhOWa+EzvD2CnOAHvJnalBWGGB/8jsivGPeYfvvCTD
	9Wk4huvCVR679hqGAzgm88R8Sxd0W+C/k06MS9X8NN0ZRcDCSuUd21xZIQmyOzhLmQ==
X-Gm-Gg: ASbGncvnWyj5shyCCy/OCfBNed1dwe+iy4XYEPc/A5K0DMTnKbQ7BoINsJnpEn65oE7
	pG38Yj4hSUwwFvGkoyTPZySMW1sATh2wcuyVBdtVjPitG3WN0M9idl4ya4SyvGDT3nFYkuO0ZaI
	sP12+eVIwp0wDMNU1cZMl+PQ+DojovtsIXz84fXF2zbkSqrExwYv7G4FihUaF7rrjWuw1P5Del4
	NpxEhJTSFn6i2gqtkL6xH21UqAU9SuAhKr01HQNdhsWYSouwwjL+Vjt4KF8e+6aEJzbV6dAs2GP
	HqvfYdqwFEGAB52c6C8Si+iamHFTrsdUoTdLZPs8lo0kw1DVZ0AQut7G4VAM7pZ06XbS2f3DtCM
	Ol5tpENOfyyFkrELDN87GJCFfEAb3a2bAZdmtrmc5NolDYARvihdJzTviLP3CjVfg0dpPBQ==
X-Google-Smtp-Source: AGHT+IHD9Kzax0Ca9B0Mi5gbzv7latmKARYeb9YTewjapsp5wcmK8hKO8yrvBqqgUSVFMKJVQNhyag==
X-Received: by 2002:a05:600c:4689:b0:43d:409c:6142 with SMTP id 5b1f17b1804b1-45f320079e2mr1999085e9.0.1758034222192;
        Tue, 16 Sep 2025 07:50:22 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f2a65e1b5sm123753115e9.4.2025.09.16.07.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:50:21 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:50:18 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 22/28] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <aMl5Ku6ZbzTOuGh-@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-23-smostafa@google.com>
 <aMQroI4NDu74PDGT@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMQroI4NDu74PDGT@willie-the-truck>

On Fri, Sep 12, 2025 at 03:18:08PM +0100, Will Deacon wrote:
> On Tue, Aug 19, 2025 at 09:51:50PM +0000, Mostafa Saleh wrote:
> > Don’t allow access to the command queue from the host:
> > - ARM_SMMU_CMDQ_BASE: Only allowed to be written when CMDQ is disabled, we
> >   use it to keep track of the host command queue base.
> >   Reads return the saved value.
> > - ARM_SMMU_CMDQ_PROD: Writes trigger command queue emulation which sanitises
> >   and filters the whole range. Reads returns the host copy.
> > - ARM_SMMU_CMDQ_CONS: Writes move the sw copy of the cons, but the host can’t
> >   skip commands once submitted. Reads return the emulated value and the error
> >   bits in the actual cons.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 108 +++++++++++++++++-
> >  1 file changed, 105 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > index 554229e466f3..10c6461bbf12 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > @@ -325,6 +325,88 @@ static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
> >  	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
> >  }
> >  
> > +static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *command)
> > +{
> > +	u64 type = FIELD_GET(CMDQ_0_OP, command[0]);
> > +
> > +	switch (type) {
> > +	case CMDQ_OP_CFGI_STE:
> > +		/* TBD: SHADOW_STE*/
> > +		break;
> > +	case CMDQ_OP_CFGI_ALL:
> > +	{
> > +		/*
> > +		 * Linux doesn't use range STE invalidation, and only use this
> > +		 * for CFGI_ALL, which is done on reset and not on an new STE
> > +		 * being used.
> > +		 * Although, this is not architectural we rely on the current Linux
> > +		 * implementation.
> > +		 */
> > +		WARN_ON((FIELD_GET(CMDQ_CFGI_1_RANGE, command[1]) != 31));
> > +		break;
> > +	}
> > +	case CMDQ_OP_TLBI_NH_ASID:
> > +	case CMDQ_OP_TLBI_NH_VA:
> > +	case 0x13: /* CMD_TLBI_NH_VAA: Not used by Linux */
> > +	{
> > +		/* Only allow VMID = 0*/
> > +		if (FIELD_GET(CMDQ_TLBI_0_VMID, command[0]) == 0)
> > +			break;
> > +		break;
> > +	}
> > +	case 0x10: /* CMD_TLBI_NH_ALL: Not used by Linux */
> > +	case CMDQ_OP_TLBI_EL2_ALL:
> > +	case CMDQ_OP_TLBI_EL2_VA:
> > +	case CMDQ_OP_TLBI_EL2_ASID:
> > +	case CMDQ_OP_TLBI_S12_VMALL:
> > +	case 0x23: /* CMD_TLBI_EL2_VAA: Not used by Linux */
> > +		/* Malicous host */
> > +		return WARN_ON(true);
> > +	case CMDQ_OP_CMD_SYNC:
> > +		if (FIELD_GET(CMDQ_SYNC_0_CS, command[0]) == CMDQ_SYNC_0_CS_IRQ) {
> > +			/* Allow it, but let the host timeout, as this should never happen. */
> > +			command[0] &= ~CMDQ_SYNC_0_CS;
> > +			command[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
> > +			command[1] &= ~CMDQ_SYNC_1_MSIADDR_MASK;
> > +		}
> > +		break;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +static void smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	u64 *host_cmdq = hyp_phys_to_virt(smmu->cmdq_host.q_base & Q_BASE_ADDR_MASK);
> > +	int idx;
> > +	u64 cmd[CMDQ_ENT_DWORDS];
> > +	bool skip;
> > +
> > +	if (!is_cmdq_enabled(smmu))
> > +		return;
> > +
> > +	while (!queue_empty(&smmu->cmdq_host.llq)) {
> > +		/* Wait for the command queue to have some space. */
> > +		WARN_ON(smmu_wait_event(smmu, !smmu_cmdq_full(&smmu->cmdq)));
> > +
> > +		idx = Q_IDX(&smmu->cmdq_host.llq, smmu->cmdq_host.llq.cons);
> > +		/* Avoid TOCTOU */
> > +		memcpy(cmd, &host_cmdq[idx * CMDQ_ENT_DWORDS], CMDQ_ENT_DWORDS << 3);
> > +		skip = smmu_filter_command(smmu, cmd);
> > +		if (!skip)
> > +			smmu_add_cmd_raw(smmu, cmd);
> > +		queue_inc_cons(&smmu->cmdq_host.llq);
> > +	}
> 
> Hmmm. There's something I'd not considered before here.
> 
> Ideally, the data structures that are shadowed by the hypervisor would
> be mapped as normal-WB cacheable in both the host and the hypervisor so
> we don't have to worry about coherency and we get the performance
> benefits from the caches. Indeed, I think that's how you've mapped
> 'host_cmdq' above _however_ I sadly don't think we can do that if the
> actual SMMU hardware isn't coherent.
> 
> We don't have a way to say things like "The STEs and CMDQ are coherent
> but the CDs and Stage-1 page-tables aren't" so that means we have to
> treat the shadowed structures populated by the host in the same way as
> the host-owned structures that are consumed directly by the hardware.
> Consequently, we should either be using non-cacheable mappings at EL2
> for these structures or doing CMOs around the accesses.

Thanks for catching that, I missed it, I think we can keep the host shared
as cacheable, and use CMOs when accessing it, I will have a closer look.

Thanks,
Mostafa


> 
> Will
