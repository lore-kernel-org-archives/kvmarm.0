Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B05C388E51
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 11:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783940878; cv=none; b=Zefyfi7rAGBLnYRzCe1+Gcpk4opUIXXbZTRwg347mXzbIJJYElXFBTN6lDt2/6H6I8lN/UnKBE7eisoneJKzGHdujajAFD/Mmn87PkvU57JmFyCUJuAjVaGsVFXVlKXhXj6lJUlnXL0TlR3pplxNc1ZnWaO6lBiz+xbiOjEaWY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783940878; c=relaxed/simple;
	bh=Eds3EgvFkpLMHtynlmWxSgjSfgcwXmnfbdoaPHhBueo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZsBSvm3/2OBokjFx0MBkD2Ryb2Yk7H1QFod9xSW1UVFboCQO5tZwB8pSObC9xKYSbypto8Tw77IK1nvBwZdi6yQTRXbag/C5m885r9sZRfZH8X68EfwCpstIpCKODYRc/VfLxC5ZJiRDuovV3SvRhwN9CtljOM+OtFDDFA9hIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kjQN3VFo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kjQN3VFo"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso86545e9.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 04:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783940874; x=1784545674; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YZ0k43QjY4fFBTZv9XwnB5eVI6fl2iA5pqXp0CRkiRA=;
        b=kjQN3VFouwZEARB9hUIajlTsgmWEiHve6Yuwo+NxHmbWURYOusdy/YfnvJ0X2iy2U/
         0fHW+Ike6w0BbWsAFwEKX7rFs0EzVRJb0AQXtJdsOfIf+jKev9X7BASb3rK+ZH+QnECv
         C4do24yUKpnNhLNjbpKiDmbwCGR2U2PXTXumWVahvbc6Qe4CDyZrgtJRxbdIz8xqWioA
         hpdk7Ux/Oro22XwJZDZKlRG6HEw/ZkEu/uyYKn3XM2Hby/zc4GwGM6O35WUWuugE7AW7
         0IMkbubCDeuc0j702sLq6VNrPAuhVJffnQTlElOqFb7k/lRT3APpZ6DVJWVE0mLHif8L
         1KLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783940874; x=1784545674;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YZ0k43QjY4fFBTZv9XwnB5eVI6fl2iA5pqXp0CRkiRA=;
        b=Ns++nV/DdXFdAnfPx5X1U/dE0erGxs0iAd+5GX+f5ac55+qI9T0qDAWnv+6bbZYWAu
         9llVxeCK6EelblpbG5rDx19eTQKkHL7/80jxfHS0o/KL47gFGIeN+w6NW7isZAVCSA6V
         FxBivBwkgb8yULR1RGvVXF+rXzlZG4p34MmgAVqOPgRKyc+2SX90JsjOAavuEei3ApMk
         //OV0wUv7uecLTaqlXDoPEEmoTZz3u5imNpqTbg0tj083YLAaczdBCc50LlqzcUOmL4i
         AAWLGQCbQzXEYWg0FKTutF8SHLer6l1QItyE58wz4iiJtMUnSwvlcC817Aetl+ch3naN
         2HBg==
X-Forwarded-Encrypted: i=1; AHgh+RrruLUmq1+oNXbeRlBF0iO2JGT+J8pePTw03BmaMAbM6nJjaIKLl14AYnqdk9/iLSRE+Q9eg4o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0t5GuAWwHlk7L86+WejQlkDMSd2iOFrdEhr+hAV5iO2n05dQn
	yDoL/IJDk8bni1LGRp7WKOrQrTHylzye7rwzpvpPymT8XYqmLl+Snn+MdyOOX8Ds9Q==
X-Gm-Gg: AfdE7clwtkNId74FQx0XzoEV0EPP2MbjYrG24XsB2qJayPvUK2ugc44z1wXAKq4CJru
	2xkwsHwxlzFkG1SBC4y3yq1B9Ku3qAThfv02LPLGmp4x8YfE82VIZrq9QUuABYXXkVzipKDqc/W
	p7K/6X+OgetCTgonXzaWWsZeZ2kD1BFUdePaWI9oifUuZ9L1Rn/+L5BDqYKXaTARWGOffIiGw0c
	EpWwBH5sLc6PP3b6kToGNE7SscDlq8YEDTX1+3y40a3f8v8zN3yqB7IN4LzPHJgP29LAl3o0WL9
	19T8/iM09aOgnEYrVgSiMkwVTQyPTZeksiskSU/ch3Y4zCV6wql/5rAr+Dv1ePAAIhkWocvCmkP
	g5GM89uv26NtGyK8k44bgvC7y5x8pm4ynefVUozVmsFapTlm1AsOzZK3vUTz5OGTmEEXvWxyZXq
	HOwYSCvo4C1d4Ty8JnuiX+G9mWNIVUaLD7RWas5x4Q1cFK8g1y
X-Received: by 2002:a05:600c:a088:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-4945e32136bmr235535e9.2.1783940873591;
        Mon, 13 Jul 2026 04:07:53 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f214d2sm82275582f8f.33.2026.07.13.04.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:07:52 -0700 (PDT)
Date: Mon, 13 Jul 2026 11:07:48 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 16/25] iommu/arm-smmu-v3-kvm: Add CMDQ functions
Message-ID: <alTHBD1YBiTbdbIG@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-17-smostafa@google.com>
 <alEXQ2X_0XQylvw-@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alEXQ2X_0XQylvw-@google.com>

On Fri, Jul 10, 2026 at 05:01:07PM +0100, Vincent Donnefort wrote:
> On Fri, May 01, 2026 at 11:19:18AM +0000, Mostafa Saleh wrote:
> > Add functions to access the command queue, there are 2 main usage:
> > - Hypervisor's own commands, as TLB invalidation, would use functions
> >   as smmu_send_cmd(), which creates and sends a command.
> > - Add host commands to the shadow command queue, after being filtered,
> >   these will be added with smmu_add_cmd_raw.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 ++-
> >  .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 107 ++++++++++++++++++
> >  2 files changed, 115 insertions(+), 6 deletions(-)
> > 
[...]

> 
> I only looked at that smmu_wait() as this is the hyp_clock_ns() caller.
> 
> >  
> > +/*
> > + * Wait until @cond is true.
> > + * Return 0 on success, or -ETIMEDOUT
> 
> nit: Would be nice to explain use_wfe. 

I will add it.
> 
> > + */
> > +#define smmu_wait(use_wfe, _cond)					\
> 
> nit:, (__use_wfe, __cond), or (use_fw, cond)

Will do.

> 
> > +({									\
> > +	int __ret = 0;							\
> > +	u64 delay = hyp_clock_ns() + ARM_SMMU_POLL_TIMEOUT_US * 1000;	\
> 
> Does it help to lower the risk for the 128-bits fallback if we keep the
> resolution to _us?

I will remove the tracing clock support as mentioned and I will handle
the overflow in smmu_wait()

> 
> Also, ARM_SMMU_POLL_TIMEOUT_US seems to be 1s. Blocking that long at EL2 is
> really terrible. Any chance to lower that? 
> 

That should never really happen, I am re-using the kernel max, but I can
change this for the hypervisor.

> > +									\
> > +	while (!(_cond)) {						\
> > +		if (use_wfe) {						\
> > +			wfe();						\
> > +			if ((_cond))					\
> 
> nit: I believe there's no need for the double () here is there?
> 

Will do.

Thanks,
Mostafa

