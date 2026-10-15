Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DCD4AA1D4
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099369; cv=none; b=clWmuGl4iDyG+0IwNDjB106Oe36q7wIpr9OfFzr14KFKnDRJsNNoYiyq+UHpGqiBpcdXa19gVy68oFHJ1cGFnXHz4FhRqEQwVAfErcgTZCkZnXiT5+xT2JthpsDF8dMHU0iJAdKqRtre5Ii26Xoq+D/4Uv9KtXZKZQEFLZX3olw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099369; c=relaxed/simple;
	bh=WKgqCS5uf1Zf2wdUkSQ54ODR3oz4ad6ZYiHdiDGTKzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ed4XGckhe4LslDS2DfOtLcEMrcts8y0Jl7Us1GnvOM+i//lKHAoNb3HICwgOG/AK6NkLtl5/AkO8ykaSRiEH7GIbcI7jE1DnLcSglOu4YpEBBqb+iNpc4m5P5Z47xoQLjQahA3DR1i3zPkqj3Z5KuPNP0FQyvUm6YK1oOwYSAZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BiyJwQqI; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BiyJwQqI"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a018493d57so21665e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792099357; x=1792704157; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MgaUGrs6x+9VlRGH/aLbti3i9VNYpicjo0s14cx7ey0=;
        b=BiyJwQqIeYyd3LXR5WU3upf8vdDQHBo5VoGbqvHm/fVRH0io1mOG+FE5gTWJLK2poZ
         5ZeqT5QyuXGQQto0rTHK4XLAl8s1NZhfKTCehtXz5lCZUFMnfeAdubfoKZh/GOfmul7O
         wVAzA7dLTT42ntLZTJNaFOccZ1A3pncz82U3NCYsAYaixZjsdyowfb8ipiN2qiwMrSUn
         hJ0VHERNPAI3zbDBr6MLd62IHDD+eflU27ZMLmMfdJh14x3V+evV2QR9KFf5JSulycmx
         hTLjeXvYi8OaNDrdoUvvS8ddOlYt7MrLH0k192fOW+Fl+9qhecWuCqQTuNs4Yy3HSLin
         Hpiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099357; x=1792704157;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MgaUGrs6x+9VlRGH/aLbti3i9VNYpicjo0s14cx7ey0=;
        b=CyDrdT1z/Gj++nVE+3dUzvKzwiUOzfn42P7qJO6+vD2fXhRXPl912wchKDoflDAyFC
         vJSjewKJoueqo5NS69LBtjeMDJ53moGrACgkYUWZ8OONbR5usgaXGHTglTBQdBvTKtq+
         1DdtYIVPzTxaEY8ryaBs0K4p4GyiZDicRmQnJ5p4+fhRxNv+lsNKiqJb1+ltAJEiNUkv
         5zce4f+zd8qmlVD2ZqCBWRD74RECrv6T6xySUCiA8esk0F/tVB1/k/4pkrPhchn02bet
         N/8ue3w+O5bdhjTOn/HFyFvB0VQX9RUv3QD6Z1xMHCI+T/c45lThCeQ4Yb/WWGr149zr
         hngA==
X-Gm-Message-State: AFq9FYIV/2UEYIRa+sfz2s1i8uI0ryVR31TZwHkANJAltGFVNv0WZWvF
	thcQdEp0p41Rktv1AdyI0qUjsIysm0uxMmcv3FYRIWzz++PwkgnTagscWrXZXdi3fQ==
X-Gm-Gg: AYBFou09BqxDa6d7B58GgyiJCyno9wvwYZgZwqqG4HZWd4QXITkNonfj9eW1P+18A9R
	yHptS5CFCNvtWJkzuTqThhdjCuLZp5+0ctiB1KDA6gRB+BTCOYq/fWQ+i0O0DKHYeHjNHHdZslc
	Xug1t6kChcGQ1EfZ64BtNOhouM/vDd8kgZxN8HEokNs3fl8X1VqeXDd5Hj/1dc1QmhIa+DJV8DG
	4bbTFX/HiXHE+qILXYeSY2grZPi+u6Bn1nupUd9Ck3ahKSQBC4VjXcBJ+kPw7kr+mtR+NlmzroZ
	bDNZs06vrEB438jMfHqwwjDka3XZSQIl5IESTos4gJ+P3ure5yCz+mJN0sJ3aX/wmcneNFjT/J+
	bQcLKwPMT/TC3V7DKiWpQEGV3fElBBsojEWqt+Pd7W1d0czkPx/RBeg/r8M9pti6LtBhYXTgG/j
	mHuwaQsW0bep2cbAn4FY4dmZBbduEuZfEn6wlQVY/qUfba6tZ1yd8H8Ae2u/fmWunEW1GduTHwK
	MqN3pn3h7Kaber8vfZjrVtxEy09BQ9fMPOzYXdV
X-Received: by 2002:a05:600c:4307:b0:4a1:6f41:90f9 with SMTP id 5b1f17b1804b1-4a1c8adfdf2mr85515e9.14.1792099356901;
        Thu, 15 Oct 2026 14:22:36 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4d4dddsm536769f8f.22.2026.10.15.14.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:22:36 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:22:32 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 18/25] iommu/arm-smmu-v3-kvm: Shadow STEs
Message-ID: <atFEGMXzoj1WAOHh@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-19-smostafa@google.com>
 <sashiko-outbox-173395@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173395@kernel.org>

On Thu, Oct 15, 2026 at 08:30:26PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] hyp-arm64: fatal WARN_ON(skip) on normal pkvm_iommu_alloc_pages() -ENOMEM failure
> - [High] iommu/arm-smmu-v3: torn STE write sets Valid bit before configuration
> --
> 
> commit bc7189831be67d30110e4ed04545c980d138dc99
> Author: Mostafa Saleh <smostafa@google.com>
> 
>     iommu/arm-smmu-v3-kvm: Shadow STEs
>     
>     Shadow the STE when the host sends CFGI_STE: copy the host entry as is
>     into the hypervisor-owned stream table, which is the one the hardware
>     uses. For 2-level tables the host L2 table is shared and pinned while
>     the entry is read, and the hypervisor L2 table is allocated from the
>     IOMMU pool the first time its L1 slot is used.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > index 0fa98915e00d4..132f3a9ba3084 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> [ ... ]
> > @@ -290,6 +293,91 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
> [ ... ]
> > +static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool leaf)
> > +{
> [ ... ]
> > +		/* No hypervisor entry, first time the L2 is populated. */
> > +		if (!l1tab[l1_idx].l2ptr) {
> > +			struct arm_smmu_strtab_l2 *l2table;
> > +
> > +			l2table = pkvm_iommu_alloc_pages(get_order(sizeof(*l2table)));
> > +			if (!l2table)
> > +				return -ENOMEM;
> 
> [Severity: High]
> If this allocation fails, smmu_reshadow_ste() returns -ENOMEM, which causes
> smmu_filter_command() to return true. In smmu_emulate_cmdq_insert(), this
> triggers a preexisting WARN_ON(skip):
> 
> static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
> {
>         ...
>         skip = smmu_filter_command(smmu, cmd);
>         if (WARN_ON(skip))
>                 continue;
>         ...
> }
> 
> Since WARN_ON() expands to a fatal BRK at EL2, does this allow a normal
> out-of-memory condition to panic the hypervisor?
> 

Allocation shouldn't fail as the carveout should cover the worst case.

> > +			/* Ensure L2 is observed before writing the ptr. */
> > +			dma_wmb();
> > +			arm_smmu_write_strtab_l1_desc(&l1tab[l1_idx], hyp_virt_to_phys(l2table));
> > +		}
> > +		l2ptr = hyp_phys_to_virt(le64_to_cpu(l1tab[l1_idx].l2ptr) &
> > +				STRTAB_L1_DESC_L2PTR_MASK);
> > +		hyp_ste_ptr = &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
> > +	}
> > +
> > +	for (i = 0; i < STRTAB_STE_DWORDS; ++i)
> > +		WRITE_ONCE(hyp_ste_ptr->data[i], host_ste_ptr->data[i]);
> 
> [Severity: High]
> Does this copy sequence write the Valid bit (bit 0 of DWord 0) before the
> rest of the stream table entry is fully populated?
> 
> Because the loop starts at i = 0, hyp_ste_ptr->data[0] is written first.
> If the hardware concurrently fetches this entry, could it read a Valid STE
> while DWords 1 through 7 still contain uninitialized data?
> 

This only copies the host STE (which follows the spec) for bisectability
that is fixed next by using the ste writer.

Thanks,
Mostafa

> > +	return 0;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=18
