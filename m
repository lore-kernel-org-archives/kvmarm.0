Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47D43176E0
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 17:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774979042; cv=none; b=uszCUDUkv2twrdL55KxJz6y9ZiH8SdStuhNJgGTYPmF697vCD+DFI7GbKsCuDM8JD3ECueURaLYGp4rn7jhHMvFuKtzr+hUHSI5gF2SyKQXqfmAfgWvYyYNlukiHQ7WDP6kIybMhGTvebSlrdgREoc4bR3Zxqkx4VhNAN15hAHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774979042; c=relaxed/simple;
	bh=O/84EN5YYoPM1+5xtE3R1wBAPsRMRFS9tH2mD4pprKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARVu+Ae3S9H5LL1PHNUkHd438qubfW8SyY4bNGaY9cPWXrPR11S4kUoeCroai38xe3BOXpB9Qf5k4G1HLZ5jN5ug/s4h0uRWv69w+4gFapyyfaGGs/m5lGg/4I2MmBK9w++4rrWN/SrCNQpK1xt5r2A3P5e2EVaTJP0KUs1QLXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yOn4/ti3; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yOn4/ti3"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35d94f4ee36so2072857a91.3
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 10:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1774979039; x=1775583839; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DfoeEFvtZcN/vD2OkIhN1RR2rBv2unDxcoeXhDGEM9o=;
        b=yOn4/ti3qvUCN3wYV1Sn7czsDrsQ4Z8upCnZBo5og2gAc2iRmu2Kfc+/rEImovaD02
         eFnaWoRco/4KIqUMe+6AUkZseiEt/QzV/5Y/xDnw/tCgfjYRj0exqvK9ZzkHzAp769sj
         4YgniACFrPQFFEMrfoh21HtTOKRFuN/HZjVbYkH+0Gr1tz9KTHZAmyf2up4a1akBR0D0
         8x3cQ6lszHn/301GZyszGHWCtr+JzPNC6DxZUmP63cCuvuH5BEmvn6vLmBVW5VSqU4Yi
         Lclg437pnIcSwVmAqGuVF7SjfHgGPMUn6ycZ2IwgfdSwQNQwQ79XDWYAm+Te2XtOERBv
         Y/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774979039; x=1775583839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfoeEFvtZcN/vD2OkIhN1RR2rBv2unDxcoeXhDGEM9o=;
        b=kEGK78IC75ytIg5Ul1BbAXKiFR/BFznyAee7tMefUuXdQq6mpqaNZvrSxjFfx9dz30
         Jbsl34HG4SsO8NZHazXXijGbF8LgA5gYL0fCCF2097L7ONY7CSylB6JubyE0KuCZVuf9
         T0PTtXKyDvEFS2X8ZlpYa8Rx7nTrYBJOcck+Dcy4i6F5pK+KavLDq1WAL4aK7BvP8Jcs
         s4MPJ266p9lE9hwsdurxXs6GddFcFTz6+1fJCP8eUBQWHLgPAF9FlXVqHInXjIWB6cZ7
         s98znKjXBf1/cmja6r1rPzHj8wfQogTcLiBMq+P75umS0ydeCk36ft0RJME6TOnyCCSk
         EDfA==
X-Forwarded-Encrypted: i=1; AJvYcCXt19rkqNZBbl+ZB0p0cV+XBZZg823KjxikGiemaGosbPGyPSD3icDxejmtkLGe+KzUxWD+Vos=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyjshhfy39CYKfT52NJJoorH3baGtYATrbRBZXZy/D4exHIKbgP
	ZASJI9zp96l14Ojb2b1+1HgRIe+Z/fdNgNydzsOfSzvoevBEQxFCalofQIZPgdz3/XY=
X-Gm-Gg: ATEYQzxMAHBLo1CoUeHUOKTndpCD66GRG5l+kFImrQdi7qp/y1H8M+KXoE6KE1vwZL0
	VnIon3DbP4zF4qtMPaczcuw1HauGfiTMI+YecAYdRBn7OcsWX0U+Z5WeNA6QlO6HWkPt1nHaB97
	4LUaG4zJZOhKbcwNVihli8YHfen2FeUyTwyRBGmlWNxmF3rPIee48jxOWkLwCFY6Coyl1cx22LQ
	BtA3teRO+z/ahPXl+uFF1CIsNXrMmp9YPRru6EotsvnwJRMN7OFMNxjyaI2i6P4p2sqGItGhEng
	09Ram7viEH6HYe45EvNWS9bg8YBwsr1MwZlX86cYLg4yF62BqD8ryZroAotf+Fj7TCqQejiHzip
	hC70akXzV7oPrC3UAL2Q29S67MYpK5h+nuCgd01TS1ZnWAUySHSIKAo9KLS0iemnDzwrj9or+hl
	EMsDHgm2sFYtLV4cIt9CxrZlVqJA==
X-Received: by 2002:a17:90b:3f8b:b0:35d:a2d3:5c2f with SMTP id 98e67ed59e1d1-35dc701f81amr175346a91.24.1774979039033;
        Tue, 31 Mar 2026 10:43:59 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:3147:ec27:349:39db])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe9377b7sm3173953a91.10.2026.03.31.10.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:43:58 -0700 (PDT)
Date: Tue, 31 Mar 2026 11:43:55 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v13 10/48] arm64: RMI: Ensure that the RMM has GPT
 entries for memory
Message-ID: <acwH2_2b7bdOSsOd@p14s>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-11-steven.price@arm.com>
 <acrj-cKphy4hJsEG@p14s>
 <152f5070-fda6-4381-bc40-4a70908c27c1@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152f5070-fda6-4381-bc40-4a70908c27c1@arm.com>

On Tue, Mar 31, 2026 at 12:05:47PM +0100, Suzuki K Poulose wrote:
> Hi Mathieu,
> 
> On 30/03/2026 21:58, Mathieu Poirier wrote:
> > Hi,
> > 
> > On Wed, Mar 18, 2026 at 03:53:34PM +0000, Steven Price wrote:
> > > The RMM may not be tracking all the memory of the system at boot. Create
> > > the necessary tracking state and GPTs within the RMM so that all boot
> > > memory can be delegated to the RMM as needed during runtime.
> > > 
> > > Note: support is currently missing for SROs which means that if the RMM
> > > needs memory donating this will fail (and render CCA unusable in Linux).
> > > 
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > ---
> > > New patch for v13
> > > ---
> > >   arch/arm64/kvm/rmi.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 89 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> > > index 9590dff9a2c1..80aedc85e94a 100644
> > > --- a/arch/arm64/kvm/rmi.c
> > > +++ b/arch/arm64/kvm/rmi.c
> > > @@ -4,6 +4,7 @@
> > >    */
> > >   #include <linux/kvm_host.h>
> > > +#include <linux/memblock.h>
> > >   #include <asm/kvm_pgtable.h>
> > >   #include <asm/rmi_cmds.h>
> > > @@ -56,6 +57,18 @@ static int rmi_check_version(void)
> > >   	return 0;
> > >   }
> > > +/*
> > > + * These are the 'default' sizes when passing 0 as the tracking_region_size.
> > > + * TODO: Support other granule sizes
> > > + */
> > > +#ifdef CONFIG_PAGE_SIZE_4KB
> > > +#define RMM_GRANULE_TRACKING_SIZE	SZ_1G
> > > +#elif defined(CONFIG_PAGE_SIZE_16KB)
> > > +#define RMM_GRANULE_TRACKING_SIZE	SZ_32M
> > > +#elif defined(CONFIG_PAGE_SIZE_64KB)
> > > +#define RMM_GRANULE_TRACKING_SIZE	SZ_512M
> > > +#endif
> > > +
> > >   static int rmi_configure(void)
> > >   {
> > >   	struct rmm_config *config __free(free_page) = NULL;
> > > @@ -95,6 +108,80 @@ static int rmi_configure(void)
> > >   	return 0;
> > >   }
> > > +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> > > +{
> > > +	start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
> > 
> > This will produce an error on systems where the start of system memory is not
> > aligned to RMM_GRANULE_TRACKING_SIZE.  For instance, on QEMU-SBSA the system
> > memory starts at 0x100_4300_0000.  With the above and RMM_GRANULE_TRACKING_SIZE
> > set to SZ_1G, @start becomes 0x100_4000_0000, which falls outside the memory map
> > known to the TF-A.  I fixed it with these modifications:
> 
> Thanks for raising this. This would need to be addressed in the RMM
> spec, I have raised it with the team and will be addressed soon.
> 
> > 
> > LINUX:
> > 
> > diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> > index 10ff1c3bddaf..21bfbbe2f047 100644
> > --- a/arch/arm64/kvm/rmi.c
> > +++ b/arch/arm64/kvm/rmi.c
> > @@ -424,7 +424,9 @@ static int rmi_configure(void)
> >   static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> >   {
> > -       start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
> > +       phys_addr_t offset;
> > +
> > +       offset = start - ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
> >          end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
> >          while (start < end) {
> > @@ -439,7 +441,13 @@ static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> >                                  start);
> >                          return -ENODEV;
> >                  }
> > -               start += RMM_GRANULE_TRACKING_SIZE;
> > +
> > +               if (offset) {
> > +                       start += (RMM_GRANULE_TRACKING_SIZE - offset);
> > +                       offset = 0;
> > +               } else {
> > +                       start += RMM_GRANULE_TRACKING_SIZE;
> > +               }
> >          }
> >          return 0;
> > 
> > RMM:
> > 
> > diff --git a/runtime/rmi/granule.c b/runtime/rmi/granule.c
> > index cef521fc0869..60358d9ee81e 100644
> > --- a/runtime/rmi/granule.c
> > +++ b/runtime/rmi/granule.c
> > @@ -209,9 +209,11 @@ void smc_granule_tracking_get(unsigned long addr,
> >                  return;
> >          }
> > +#if 0
> >          if (!ALIGNED(addr, RMM_INTERNAL_TRACKING_REGION_SIZE)) {
> >                  return;
> >          }
> > +#endif
> >          g = find_granule(addr);
> >          if (g != NULL) {
> > 
> > This is likely not the right fix but hopefully provides some guidance.  Send me
> > your patches when you have an idea and I'll test them.
> 
> We will send you the update once it is fixed in the RMM spec. The rough idea
> is to remove the ALIGNMENT restrictions and return a Range that
> the host can iterate over to find "regions" with the same type of
> memory.
>

Ok, thanks for looking into this.
 
> 
> Cheers
> Suzuki
> 
> 
> > 
> > Thanks,
> > Mathieu
> > 
> > 
> > > +	end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
> > > +
> > > +	while (start < end) {
> > > +		unsigned long ret, category, state;
> > > +
> > > +		ret = rmi_granule_tracking_get(start, &category, &state);
> > > +		if (ret != RMI_SUCCESS ||
> > > +		    state != RMI_TRACKING_FINE ||
> > > +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
> > > +			/* TODO: Set granule tracking in this case */
> > > +			kvm_err("Granule tracking for region isn't fine/conventional: %llx",
> > > +				start);
> > > +			return -ENODEV;
> > > +		}
> > > +		start += RMM_GRANULE_TRACKING_SIZE;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static unsigned long rmi_l0gpt_size(void)
> > > +{
> > > +	return 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> > > +				      rmm_feat_reg1));
> > > +}
> > > +
> > > +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
> > > +{
> > > +	unsigned long l0gpt_sz = rmi_l0gpt_size();
> > > +
> > > +	start = ALIGN_DOWN(start, l0gpt_sz);
> > > +	end = ALIGN(end, l0gpt_sz);
> > > +
> > > +	while (start < end) {
> > > +		int ret = rmi_gpt_l1_create(start);
> > > +
> > > +		if (ret && ret != RMI_ERROR_GPT) {
> > > +			/*
> > > +			 * FIXME: Handle SRO so that memory can be donated for
> > > +			 * the tables.
> > > +			 */
> > > +			kvm_err("GPT Level1 table missing for %llx\n", start);
> > > +			return -ENOMEM;
> > > +		}
> > > +		start += l0gpt_sz;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int rmi_init_metadata(void)
> > > +{
> > > +	phys_addr_t start, end;
> > > +	const struct memblock_region *r;
> > > +
> > > +	for_each_mem_region(r) {
> > > +		int ret;
> > > +
> > > +		start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
> > > +		end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
> > > +		ret = rmi_verify_memory_tracking(start, end);
> > > +		if (ret)
> > > +			return ret;
> > > +		ret = rmi_create_gpts(start, end);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >   static int rmm_check_features(void)
> > >   {
> > >   	if (kvm_lpa2_is_enabled() && !rmi_has_feature(RMI_FEATURE_REGISTER_0_LPA2)) {
> > > @@ -120,6 +207,8 @@ void kvm_init_rmi(void)
> > >   		return;
> > >   	if (rmi_configure())
> > >   		return;
> > > +	if (rmi_init_metadata())
> > > +		return;
> > >   	/* Future patch will enable static branch kvm_rmi_is_available */
> > >   }
> > > -- 
> > > 2.43.0
> > > 
> > > 
> 
