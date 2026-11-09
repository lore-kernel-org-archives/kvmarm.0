Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794221778;
	b=UY94sV8M1N1ho45QIIOixHcmO5D6GRJ5zxByu+cZKa1iqmbjF6Gr2YAR+GSuJBULp6XQ
	 06gh/xr2O0yf1QbOrbWD0hArXQg1gLoV9xY/xcx0tV1R+9cVfkn5Lqw5rv17YjlYmJebJ
	 unc0K7+2ysLugaweIq7bcCe0z95PuB2cmeZWvMbhCHSFIYMg0fzGcaacMx/SIwO1XdnA9
	 NlU/uCX4v4z5oMl4xyVlFCRTd8p/IuRnvs00PzTPHHBBqj+hFFjcAwdQYhNMMKZ+M7FFm
	 d4G3K35sDCyIx/MRiLb76+RAbjf/iC5pphYP8QurmKV9Y9KGYQoX2kkGBuLdBS10DwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794221778;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=9ORalyFXe7qdK/R0lBn9ynib3IYyaexwVRCwyl06+yA=;
	b=1Hjcm2xZZfSM3Afkemtd9ep1ZuJMZA3nJbUEs9sjd8JZcjjVZ/GqsJ1nxzv8nW5jyAF1
	 IZN5/VsFlrIcR/rD/1Pi+t/LBScCI98eSdxX/4wpNMbbyCOLufV0UO2F8vn9F5hY1A65B
	 ZkDZN+xUuo4hdHTrdmghKw5KhGOFEG5apZfzwkOzPD79p+EVSxv2S74PwLviVVtW09pk5
	 WVFNtvpNZA8Qhmn4iF0zXN2KW2MKfhVnWZjTXRTO4jqM/egAwSNT3zN34YjlquRB5z4hQ
	 AhH7n87tozNpuTQEYbz2LBhnnTQ1kiD1ggkbPE+Grb2duZ2hcmn6LS4D4E+ttnQG8dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="QdBcUW/x";
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D41606A332
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 10:56:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49D41606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QdBcUW/x
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4b6266b5bc4so22285e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 02:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794221777; x=1794826577; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9ORalyFXe7qdK/R0lBn9ynib3IYyaexwVRCwyl06+yA=;
        b=QdBcUW/xHQo9de8RJsUQY5xAsRnd9iS5cR+3J1+REeXuSS/axGtTjCly1cmmPpU/L3
         Fe+/S4eC5le4q1rQrq2Hjcq1dIIWRiyYCor6fTsX8RSoXehi1r3PljjVaMY//r38JwbQ
         ZMNJmMgkPGt408IG2lrpB5ILuR7So7sRGyP0x/eSd2NnZP6+6OTYHP7c6eqAAZu8YKzl
         n7y7W0zp9vpKZ4lrRsr9RAiK16uziUb6SSkJ1zqjluTk9oNETUhW+OpHkC3Ig9VcX6Co
         VYoiGujcIQVopUpmK5u215XZOmRVJBcLndvSKJKH9czWM280g0NkhtGJM+zuI0uS1c/v
         TQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794221777; x=1794826577;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ORalyFXe7qdK/R0lBn9ynib3IYyaexwVRCwyl06+yA=;
        b=eaepEC1bRNXcwf7Xxnz7tMGKspD7lfZhXOOtdfiRXIMPm2QTbPlGkGmHuhXy/YlBDW
         muUTCCltW/7AVimYav2yRjJy7GidtR2KESFhWMaacDZqCsrxyusZ3eMt++Kv8egQp8CE
         XSt94OYeqCODAN2pH+iYXqGorTuLd4lyanOqHOQJPA5CAYaCeV1EyYykSVCqwcS74OOW
         fL+dvkOWbu1Irk3MFlQQ6rOEEi9aUWW24VxoGsShG5YBmIZ43ICdmzrzXZS3gft+WqQC
         58H71zYYYAscDMiarWrpg8rKUXou8396agjoGODkVMKJvkXGTj0fF9XAwujfp955Bop8
         2rTQ==
X-Forwarded-Encrypted: i=1; AL+hErECHKgUH7HzDIy6l4pQbb2pVPXHmYLlIzyRf2vQIF/0ZJHLB3EnTAo7NnwiSxFHPnpds8pfEnc=@lists.linux.dev
X-Gm-Message-State: APuU4Z9BULYlF/RTGpfvV7JCU99jz2bx8Rwm16IhAuOtlc1Ma+bJ2sXA
	TYeTqx5mJjn0BwKCvIRZQ0WhE1nQ6ksIBW1Xoxqm0+XqU9jJv7kbm6rp5AIQgB85FA==
X-Gm-Gg: AYBFou0BqduJ8Q0iBPvoy2VEokFhypTpqH355x37l9VFBO1TDVcoQjJj47pGy02avYg
	JH+v2wyyVAWUZnlyrYQvjQwzzhQ0LZwyVe4cxzCWB9o1V0HRxqkSyJeZoTGj99eDCg8/hwpBppZ
	Y6NFNQeiVcsJ9RFGbLT/mUCC3LBQcZiizGqJldoR9wvEcMqduoDP8YyOdg4h1hWWdBqMCOEmISJ
	fUKdCKNqjVrKp6vDYA3/31hLzKC2L6WoLGHonot4O7mUCIHf3cILygXJb7VZby3lbt2y5oJbZGN
	y8NXEa9kGUt2ZrAUZg9mCJjH27TO5rzkJJSoy6qxF6Nmnd1fkqKzpMBQFYp9kXNOyaDnucfN5aY
	fcby1g4QKtk/rNCPiqxAinnY/qIVQJt5ZTwcAP2FMs28RU/pxscatEykgfYsaqtOxMgL+GBrLjX
	xq/akdPtkvx1igHgwuI+9YMJvYvDFACmvyPw13kqIJUfV3/Ycs+p9CTHn+Es4QY8opJG8XTSE/G
	NLT3U1aRGGpTXRYGWv3Iob+tVBwRoYgbPLWoyOCUnBtTEQKZ2RoM1LtEsEhMDvf3hdZGHUevxfY
	hwUjrkG1Sk+OcVntDP/f1necYQyxLl0/4PObFFPA0WkbFoL5AYVv9QwXEWLbkJCoRr9V3g==
X-Received: by 2002:a05:600c:492f:b0:4a1:e384:5e12 with SMTP id 5b1f17b1804b1-4b8b04d4155mr845705e9.7.1794221775967;
        Mon, 09 Nov 2026 02:56:15 -0800 (PST)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7da62edb4sm270902255e9.1.2026.11.09.02.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 02:56:14 -0800 (PST)
Date: Mon, 9 Nov 2026 10:56:10 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 13/25] iommu/arm-smmu-v3-kvm: Add MMIO emulation
Message-ID: <avGmyuYdheMJdLik@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-14-smostafa@google.com>
 <au0LlPl2xwJvtfCu@nvidia.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au0LlPl2xwJvtfCu@nvidia.com>

On Thu, Nov 05, 2026 at 03:04:52PM -0800, Nicolin Chen wrote:
> On Thu, Oct 15, 2026 at 08:08:44PM +0000, Mostafa Saleh wrote:
> > +static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> > +			     struct user_pt_regs *regs,
> > +			     u64 esr, u32 off)
> > +{
> > +	bool is_write = esr & ESR_ELx_WNR;
> > +	unsigned int len = BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
> > +	int rd = (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
> > +	const u64 read_write = -1ULL;
> > +	const u64 no_access = 0;
> > +	u64 mask = no_access;
> > +	const u64 read_only = is_write ? no_access : read_write;
> > +	bool is_xzr = (rd == 31);
> > +	u64 val = is_xzr ? 0 : regs->regs[rd];
> > +
> > +	switch (off) {
> > +	case ARM_SMMU_IDR0:
> > +		if (len != sizeof(u32))
> > +			break;
> 
> Maybe add a small helper to list all 64-bit registers:
> 
> static unsigned int smmu_reg_width(u32 off)
> {
>         switch (off) {
>         case ARM_SMMU_CMDQ_BASE:
>         case ARM_SMMU_STRTAB_BASE:
>         case ARM_SMMU_EVTQ_BASE:
>         case ARM_SMMU_PRIQ_BASE:
>         case ARM_SMMU_EVTQ_IRQ_CFG0:
>         case ARM_SMMU_PRIQ_IRQ_CFG0:
>         case ARM_SMMU_GERROR_IRQ_CFG0:
>                 return sizeof(u64);
>         default:
>                 return sizeof(u32);
>         }
> }
> 
> Then it'd be tighter by testing the width once, prior to switch (off)?

Makes sense, I will try that.

> 
> > +	/* Allowed RO 32 bit registers. */
> > +	case ARM_SMMU_IIDR:
> > +	case ARM_SMMU_IDR5:
> > +	case ARM_SMMU_IDR3:
> > +	case ARM_SMMU_IDR1:
> > +	case ARM_SMMU_IRQ_CTRLACK:
> > +	case ARM_SMMU_GERROR:
> > +		if (len != sizeof(u32))
> > +			break;
> > +		mask = read_only;
> > +		break;
> > +	}
> > +
> > +	if (WARN_ON(!mask))
> > +		goto out_ret;
> 
> Your cover letter mentions "WARNs are fatal in the hypervisor".
> 
> Is this WARN_ON fatal?

Yes. This is reached if the host does something not emulated:
1) A bug (writing to a RO register, writing STRTAB if SMMU is
   enabled...)
2) New arch feature not supported.

In that case, I'd rather panic here and fix the driver instead of
ignoring it which will manifest in a harder to debug symptoms later.

Also, this driver only handles the Linux host kernel (which must
be built-in in this config) so we can assume how the emulated driver
works and what features it use.

Thanks,
Mostafa

> 
> Nicolin
