Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD42812880A
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708957146; cv=none; b=BRnzaTpsPn0fvOzkiexRgA3pka8gYhLA9Tw84IfW5EyB1i6vN0v4KEihoFmv9apdUnyDkNTT5CdmZHQI7AdpSNsca2LDY1seF2W5xrNLVXPdgD1zT5RUjpXXuK2Nkl6RCr5jshhuJ9ByeEMZ/phq8sTWuOPM2CDEVYu6Nm8Dkpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708957146; c=relaxed/simple;
	bh=G4XBBEq03XlPZBzlU4Ah4X9LDm3fiTWJHJycT/zZUeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZ4FzBLOhJlTCRklaZgGRm5WeBXNNgM6RL7yj4Qx4vU8Lsy1a4pV/E5AwOSjTiecK5PnwFMnbnnNQPDMzt5kFp9ObkKnFV1dbyFN+j1PWHFuJcQ3yxJiTgPVfCOnzQfQwIOUnuWHyVTfzFJ340W1WbJkb1jthIh76dzoQJs6tj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dVHue20P; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dVHue20P"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-412a3903586so8602965e9.3
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 06:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708957143; x=1709561943; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zU9gWhI8YTP8O4Ezh9O8H/Onb4RDBW/HUckw6weGVNA=;
        b=dVHue20PotCfBpCm3ERYNB4Bi4rhlYe4ZojnrizdSVtxGeJImqrcmVgNWmfJl3leSo
         8ZvZBwt8qOjB0IaZShIjmN/m2qUlypMXlXsCCJ4Mk4LEZbtTlSFcH+E+iYI51T1J70g1
         4IWIxGmGDSwp0du0A1Xo67eJMVWt0X0P8Hvl7/TwXUj2/ChFgT1UWWU51EzDGFhrzbN5
         MZ2QfMF4BKEbm1d3pEYW63yxGsfs3PGa807P7gXaHblvjyiUi/3g1xKyTZBMFiacaFj6
         aJ5P/46VFZNjZnwpuwJPANK+z7xCWNNiXKl1L43UZ7IOcG9dGJ7o60voIwnB5efgoolP
         LSfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708957143; x=1709561943;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zU9gWhI8YTP8O4Ezh9O8H/Onb4RDBW/HUckw6weGVNA=;
        b=DW5j9DbbS0pLQz/41knA3bCyaCL1sei4+KL00zxN65P08iYKTm1sV4Dx5ji4z70Qub
         ajWtmkDNcUNxJiw6ftod6x1QKFnVxV0G2B73bgkLfT4XXfheXsE80TNtXL1/yAJfDo3/
         0xymwjJ4efV1ah8cs61IiReIcUMyoUKwGhpRjESqh6CIR6JU+rrTvw1+jdGpC8JDSf6j
         RKhr+TCIYYCUBor5fj4pYKeOYXd4gEcmhzZ/0u3u1U5AAXcyt+vW+Pr//SbHbhKuBrQC
         eUvpnKzsYsG+f82BYHBwDDckVoKzvTgndtWVnCO1coerq0zPQA/TscdajxG7qonSR6Om
         u3sQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9vbWMgW25JxIN+ejlW+HhT705a7DJJAzAk7QOIwUE5ssQBGUrh2gbx3diyzP23wKLntIHy63gsFjelbSRnED03oNrR6VC
X-Gm-Message-State: AOJu0YwlpgP9u+FdMs0GojzvbecbRiUZH/5zaqbPgcEfuYUGm1v8h8PR
	dkCt2Pr6FN20qJrbK9YDvxAZcu2JUT083mNkZKSFHdHL/nCmcTS3y2EiCYeQ6IM=
X-Google-Smtp-Source: AGHT+IHzzvgW8Msmz96TO0YqlIxP9hO9Z+i87SeD3gDrTADwH6etGKaustJAeoEB7ymtgh99PSfMOA==
X-Received: by 2002:adf:ef87:0:b0:33d:942f:6784 with SMTP id d7-20020adfef87000000b0033d942f6784mr4978622wro.57.1708957143064;
        Mon, 26 Feb 2024 06:19:03 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id q8-20020a7bce88000000b004101543e843sm12070934wmj.10.2024.02.26.06.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 06:19:02 -0800 (PST)
Date: Mon, 26 Feb 2024 14:18:39 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, Daniel Mentz <danielmentz@google.com>
Subject: Re: [RFC PATCH 27/45] KVM: arm64: smmu-v3: Setup domains and page
 table configuration
Message-ID: <20240226141839.GD1579460@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-28-jean-philippe@linaro.org>
 <CAFgf54pysSxKHcJVP6=dWPxmS3qi=eEMNQMF7SPiaiaeA-Kc_g@mail.gmail.com>
 <20240123195053.GC40099@myrica>
 <CAFgf54r3nNez_Rp0xOYWcTKvO9tcx313Q5-_dotT341qQOHm1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFgf54r3nNez_Rp0xOYWcTKvO9tcx313Q5-_dotT341qQOHm1w@mail.gmail.com>

On Fri, Feb 16, 2024 at 12:11:48PM +0000, Mostafa Saleh wrote:
> On Tue, Jan 23, 2024 at 7:50 PM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> >
> > On Mon, Jan 15, 2024 at 02:34:12PM +0000, Mostafa Saleh wrote:
> > > > +static void smmu_tlb_inv_range(struct kvm_iommu_tlb_cookie *data,
> > > > +                              unsigned long iova, size_t size, size_t granule,
> > > > +                              bool leaf)
> > > > +{
> > > > +       struct hyp_arm_smmu_v3_device *smmu = to_smmu(data->iommu);
> > > > +       unsigned long end = iova + size;
> > > > +       struct arm_smmu_cmdq_ent cmd = {
> > > > +               .opcode = CMDQ_OP_TLBI_S2_IPA,
> > > > +               .tlbi.vmid = data->domain_id,
> > > > +               .tlbi.leaf = leaf,
> > > > +       };
> > > > +
> > > > +       /*
> > > > +        * There are no mappings at high addresses since we don't use TTB1, so
> > > > +        * no overflow possible.
> > > > +        */
> > > > +       BUG_ON(end < iova);
> > > > +
> > > > +       while (iova < end) {
> > > > +               cmd.tlbi.addr = iova;
> > > > +               WARN_ON(smmu_send_cmd(smmu, &cmd));
> > >
> > > This would issue a sync command between each range, which is not needed,
> > > maybe we can build the command first and then issue the sync, similar
> > > to what the upstream driver does, what do you think?
> >
> > Yes, moving the sync out of the loop would be better. To keep things
> > simple I'd just replace this with smmu_add_cmd() and add a smmu_sync_cmd()
> > at the end, but maybe some implementations won't consume the TLBI itself
> > fast enough, and we need to build a command list in software. Do you think
> > smmu_add_cmd() is sufficient here?
> 
> Replacing this with smmu_add_cmd makes sense.
> We only poll the queue at SYNC, which is the last command, so it
> doesn't matter the pace
> of the TLBI consumption I believe?

Yes only smmu_sync_cmd() waits for consumption (unless the queue is full
when we attempt to add a cmd). And submitting the TLBIs early could allow
the hardware to do some processing while we prepare the next commands, but
I don't know if it actually works that way.

> 
> One advantage of building the command list first, is that we also
> avoid MMIO access for the queue which can be slow.

Yes, I'm curious about the overhead of MMIO on some of these platforms.
Maybe we should do some software batching if you're able to measure a
performance impact from reading and writing CMDQ indices, but I suspect
the map/unmap context switches completely overshadow it at the moment.

Thanks,
Jean
