Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794225719;
	b=vN4vpEDB5hktLTF0ISILmo+uPlbmj0upKwIjDt1MG93WJsnOA7COUeFYQb019L0yHt2Z
	 HFX6AdYUPMsYbLIt7dshxOwQy64fBd2DXiZLS1bhVOrMvORmOjN1HiGp5XwwVabWKDiTq
	 5WSAieqd66Wsr8gvo7TGCh9cKQjODQVKCa8xuuBGR4cO6E3JFMqQHjE0wsI+mVOvQANlq
	 zIDgrIugsVo1Whm8AZQ+/9UJcVkPwl3l7BscW69F2OiDKYsVOHeRSv+tfJ0A6iLzwP8Ri
	 1VvRLBuTePc4Ggkcg+OiFjMKfzrRZkNvAwsDAv5jOxoLJt/jTsGoHxvb64s+ZnIYanQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794225719;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=szgQb0dY5ZnhzHxi0dDY7s5APqPVFKBR+bd+pkS5brY=;
	b=oKMpbgh7MMYxs92rCRzIzWyjfDfbR5ttOxTDhCHPO7znwNOc7qI1rpKN4kZIl+NxVvEB
	 IcrjdwiVvO3wlzEb7b16PjI7mMo/G15EPPea78aHLnUYk5F0NVTCnnnPy2mm0Lmqaqubh
	 8hAl/Mf6/ELwEUvrFaZOmTrhTJuBOPdkYp32aFoI2new6KHfH7qmHDzCFxiClJvJ2A4tC
	 QDWhirSXs8QBnHnGgeXzKXw9oxgHAnMi4ibjEPd/Fp0iMnsN8CIBIBs3KULkFsvfM60hx
	 tq7yLQZR1Ghr34oO0VKsIrfXZyY7FjCSDC3S22xYg4tp+CbUM1hKm9TTy7mHCvK8YJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BqRRyPiI;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A08606A322
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 12:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62A08606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BqRRyPiI
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a206f0b95bso32225e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 04:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794225718; x=1794830518; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=szgQb0dY5ZnhzHxi0dDY7s5APqPVFKBR+bd+pkS5brY=;
        b=BqRRyPiIWei3DcDNGeeqWshIPB8zgfm2M+/g33eQEK19oD1Pe80oQibQp7rmNnF6yQ
         pygu5tf313rllBWZzOn259sxaIncw85GaviGyGvmMhg6o9Ss8Qr94IOLSvl5mcb/wmTl
         bVjkOsgVhY0vbuyw2loCeZfDXch8vCLF2OHaev9KDndgngj1W7atAoIuYW2GPyQKhaZw
         JBBfjcaLvyojsk+GqUf1X/oPNX5QPFxRSp6mbmoaVHhaLK5Bh73t/9W/uWLLMQJ+39KO
         Erd6i7vhxrHdDJVz/Bax5lkiKin72q6UPrrJ3yZoezfweXgi2zViP0dNfKRXhk4JZEM0
         Z3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794225718; x=1794830518;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=szgQb0dY5ZnhzHxi0dDY7s5APqPVFKBR+bd+pkS5brY=;
        b=lsuYKI3AmgAsggoCxM97P8EujKH9tSNWF1+//eNWfEhme489cuLrSTIWNlL2myAkfh
         KVLYs147reTYYdmd82ggjNdlBPcy4PX4cFa8GXkdFmetQWR+RKTL25Ed+SHu53gfK3Ez
         JtDziLDchu8OeYCbbubnPWFTKJ6MYTA7aRwyDuU621g6ySnHmPP8f7e1cDmFcHGsbc6g
         jHA1uS1HfMTCULNkqn6rLyTnANoRHenzO3RBC/ZVwPWaKTVE4/8lrxr6NC2g7VJzJb46
         pbHEVV04X3t1REdYjzzdMZox097y6ZC/arN2LzLgJNnz3Mcdj4NkGiBrd1eoiFNk33Cn
         xcMQ==
X-Forwarded-Encrypted: i=1; AL+hErER/9m8+mZSfEPeBxh8O2r2uFH1HJupuNTTHG80tceNXkMgGHf9w6+Dzx15zqZiixcfHC4DcN4=@lists.linux.dev
X-Gm-Message-State: APuU4Z9pomSbGVRLetvTVnx0FuraFdXK/RZnoIJZ/3QBaoorPegg/NmW
	QwqERWPNlEgP6K2H3vf05iqC71CNU58jjRWm/RFMzbU9m8TZvRVKy7WjmBsKUj3RDA==
X-Gm-Gg: AYBFou3a2OHNYwxNM+ZsDEsR2eibeguN9Wu2oPetuCnXduaWiM4dRkgzQjPrKkIxakD
	AUI0UGALzs0UyvsE5HryxkCnjqfA1qaP44n1no/c3GUojN0GibTzankxXjLOy4m3XaHLY95sYG0
	d+IpEhCY+eM1lfI+Evm3OSgWiXK/pprP/swGMzrvYWxi0cNPr7PtmmvVGGnl9ZbcfC8SXKStYaB
	X8BQOwe1f0DWbiTLq3frBb0wo2BRQDAM1K3VO5vXFpkG+zExxQURqM2OY/wXO++W8cSMfRLLmjv
	CRwogRhAfx99KhpbAEB0tGzVIS/PzCzE40FRcz6eOftfxRyCRt1aXA8odME5uHJYVqfxUgRHLYp
	y9h2TG0j7BPUqfNOCDa7fXANN9ThbhhXoY1sieJMH+EtBRUmhNw1F5MeeQq8t15HHpiQRVQ9R9c
	8ktXqwo2eMriyvhfmngqce/srqptSMzxBPyIQsQeZnXd265K2h5m9Ji8f7/hMP+3CiQdkPZKIex
	T8gHdJKU1R5FZb/jZ9wbNhQbQ7hldrL9w+AGTmIuCvlo4PRhJeNQFA5fksjvlNKnxR8VvkDU0tA
	IxcSGLo0k55FVbzi5dvqGjZ1mDFG+9zsju4j+SuLIVLRBQlPbjs/Mz3Y4TNgfDCVrEG2mQ==
X-Received: by 2002:a05:600c:c055:b0:4a2:bd1:a80a with SMTP id 5b1f17b1804b1-4b811e398ffmr1476265e9.2.1794225717416;
        Mon, 09 Nov 2026 04:01:57 -0800 (PST)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4967003fefbsm5468334f8f.13.2026.11.09.04.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 04:01:55 -0800 (PST)
Date: Mon, 9 Nov 2026 12:01:48 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 17/25] iommu/arm-smmu-v3-kvm: Shadow stream table
Message-ID: <avG2LCJVZIyhWQSG@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-18-smostafa@google.com>
 <au4uTxliZFv12Bqn@nvidia.com>
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
In-Reply-To: <au4uTxliZFv12Bqn@nvidia.com>

On Fri, Nov 06, 2026 at 11:45:19AM -0800, Nicolin Chen wrote:
> On Thu, Oct 15, 2026 at 08:08:48PM +0000, Mostafa Saleh wrote:
> > @@ -538,6 +655,7 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  
> >  		if (is_write) {
> >  			bool last_cmdq_en = is_cmdq_enabled(smmu);
> > +			bool last_smmu_en = is_smmu_enabled(smmu);
> 
> It'd read better with smmu_was_enabled and smmu_is_enabled.
> 

Sure, will update them.

> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> > index 3903ae358555..31ab7a0335a8 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> > @@ -27,6 +27,12 @@
> >   * @cmdq_host:		Host view of the CMDQ, only q_base, base_dma and llq used
> >   * @cmdq_max_shift:	Max shift for the CMDQ probed from HW
> >   * @cr0:		Last value of CR0
> > + * @host_ste_cfg:	Host stream table config
> > + * @host_ste_base:	Host stream table base
> > + * @strtab_cfg:		Stream table config as seen by HW
> > + * @strtab_dma:		Physical address of the shadow stream table
> > + * @strtab_size:	Size of the shadow stream table
> > + *
> >   * @mmio_addr, @mmio_size and ARM_SMMU_FEAT_COHERENCY are filled by the host
> >   * before de-privilege, the rest by the hypervisor driver.
> >   */
> > @@ -50,6 +56,11 @@ struct hyp_arm_smmu_v3_device {
> >  	struct arm_smmu_queue	cmdq_host;
> >  	u32			cmdq_max_shift;
> >  	u32			cr0;
> > +	dma_addr_t		strtab_dma;
> > +	size_t			strtab_size;
> > +	u64			host_ste_cfg;
> > +	u64			host_ste_base;
> > +	struct arm_smmu_strtab_cfg strtab_cfg;
> 
> The order is different here than the kdocs.
> 
> Also, it might be cleaner to group host/shadow/hw stuff separately:
> 
> struct hyp_arm_smmu_v3_device {
> 	...
> 	struct hyp_arm_smmu_v3_device_host host;
> 	struct hyp_arm_smmu_v3_device_shadow shadow;
> 	struct hyp_arm_smmu_v3_device_hw hw;
> 	// Or
> 	struct {
> 		...
> 	} shadow;
> 	struct {
> 		...
> 	} host;
> 	struct {
> 		...
> 	} hw;
> 	...
> };

That looks better, thanks! I will try it in the next version.

Thanks,
Mostafa

> 
> Nicolin
