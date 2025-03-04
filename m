Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E582980A8
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741109891; cv=none; b=Nu9HXjFMTZ1xMcozjx2FsULIyNNzGguM0YImcgx2jQFGaozATntUXq68li2qsQc9j/ODNg71Igf/xwpHWd0xrfpV0FX7DjoWK6bwrGZEMAVS4WWzCB+JiAsrM0nMgg00GW3sMBSB4anBf5Nicsn3dacGWdmscrpkJE8bFumuD54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741109891; c=relaxed/simple;
	bh=YBkjs7x4M5DA1yV1fs8+DwMnIWeKn75JE8veC9jpzm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2ivoSVNiLkwT+gwn7mW9TVTx0TUCNdNYcJFoP0jCfkoAI50v7zcTIFpu+Lnj148n/bYUbuV3gnnwxFwKx57prRHqAjqZYKR/IZhCvEMJtZwQ3g5SII34L5pXiGCkXyuuAwLwFD+Ed3EW21E0hnm6RWHVonJNOQrE0SDCRbHjxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iyp8wdAa; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iyp8wdAa"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4393ee912e1so62645e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 09:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741109885; x=1741714685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hL600D2Vd4+7j33RPgiVpKbsOkzk21To6aEbWxtha+U=;
        b=iyp8wdAatVBl5KTr6pY9aTJqtlXEg6KoII8n7OW7JstPo70VQD8NRqbsjVxlOo0G2z
         klJHzBWUtINnBJ4syMd9+Q8B+1ptQLa4ZkC00u1RXZQw+/B7b/VwHgHiQqLBeZG353FY
         iJNaIoR5vu+oca+PvdpJEyDEif2Ig8wMZKSl5hVe8R/tFndc4FmOrUv31L/KlFJPtEJo
         dLel8bETnTP+z+A4gP3bGWSVkSJqJS8ZCf4UJ0atAR1PaiJfwlVHEi+YTiz/Q9vFO0fZ
         uBr9qVaTj3HtE3oeQP81/tp5odokWQ1biSVacF/7MchZF4WRwjG3kf2ptQK9yUN16sA8
         XzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741109885; x=1741714685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hL600D2Vd4+7j33RPgiVpKbsOkzk21To6aEbWxtha+U=;
        b=EnWsmiDIFM8SHbtoglSXIvGyHYupcD88ylSHv0ogi8itPy8XJQKt7DZTZ0SdGYY2rb
         fmQ5NIAjTsM8oTbNQjXydj4x5He03a3MbH4eBb4AQHrPRpoGMPj3XpD01FVzMue2DFEJ
         9+RlWcUUl2NsnsQLQgke3JRhUxiPJjA6o9GbXUtBGFCKZ/fVNIPpVc4X5f6OkFVAV8w1
         Ml70uRuKU9o0o/t8qrgcRLluiR/z1mS/9W/NlWQEYPrkPbU0399AKR2ByKbZyV/aLOe7
         xiLBkkSKkiE9nnpVnC3td4pKX/A9Hbt9oL7WIbXu7En6MMyIBPQ2H0XAyOeW3eSjepas
         y9QA==
X-Forwarded-Encrypted: i=1; AJvYcCXa2m3l7LIuRpmeuBwfgUTfgvFXjD30VLbDHaRPpK8UrHkObY8bj1rQI38F2Z1mT0/eRq9CyaM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVF7Jvaow018Yk9hGV9dccQmRb4+LqiveDdjZQt0cjSKtDTPRR
	XXjQH2A6z0atPHRIBYaChGgD2FsbKzK4BtD4u6i+eZikQ5vaJtjmtuQUfwgO4w==
X-Gm-Gg: ASbGncvEk0qm5xDFL4wR/lHH7ZDsd5rBVJbRxlvUI+MUusoCeMtNUKK4t1Y2WUs0p29
	pG+LjiF6LsDPAqzioXu3H5rLnsk5JX3FOMRkl7U3JYRuvNGBmNuIMN2oXHoS7ERxRsJJA8gS7Dd
	AlyktSxjKxoCnjkyQm3ahieIwFJDBEf4ICBwynW0WJ1EKVSXJ8o97Qz004sDidSrVwHVBWzTDk4
	pXr2T7ffd+warycekro0BzXP4Zjjiv+OzPTUDvKdwQ7cMgSihOqvXs4gM+Tvm9NmsbwV2wbVIP0
	T86QK7wL0NWmZFzs/xQEKq1+UScpRnINmHydgPzZlwEhj7Ztns4d89fgQuTaQELI14TxKF7BwxG
	J+JdvZXBzep4E
X-Google-Smtp-Source: AGHT+IEpl5KnI/AmOBYa3wPD1FFPvleHPCRAbMj/fSXQ1+Q66fw7eWALywPcXdmGSME1S33/iyh4Iw==
X-Received: by 2002:a05:600c:329b:b0:439:9434:1b6c with SMTP id 5b1f17b1804b1-43bd15f3ffamr165995e9.3.1741109885428;
        Tue, 04 Mar 2025 09:38:05 -0800 (PST)
Received: from google.com (100.235.22.34.bc.googleusercontent.com. [34.22.235.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e485d906sm18464176f8f.90.2025.03.04.09.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 09:38:04 -0800 (PST)
Date: Tue, 4 Mar 2025 17:38:02 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Map the hypervisor FF-A buffers on
 ffa init
Message-ID: <Z8c6enoolJe7Zeqk@google.com>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-4-sebastianene@google.com>
 <20250303234259.GA30749@willie-the-truck>
 <Z8ZPBZF7J-qKdb_i@google.com>
 <20250304015633.GA30882@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304015633.GA30882@willie-the-truck>

On Tue, Mar 04, 2025 at 01:56:35AM +0000, Will Deacon wrote:
> On Tue, Mar 04, 2025 at 12:53:25AM +0000, Sebastian Ene wrote:
> > On Mon, Mar 03, 2025 at 11:43:03PM +0000, Will Deacon wrote:
> > > On Thu, Feb 27, 2025 at 06:17:48PM +0000, Sebastian Ene wrote:
> > > > Map the hypervisor's buffers irrespective to the host and return
> > > > a linux error code from the FF-A error code on failure. Remove
> > > > the unmap ff-a buffers calls from the hypervisor as it will
> > > > never be called.
> > > > Prevent the host from using FF-A directly with Trustzone
> > > > if the hypervisor could not map its own buffers.
> > > > 
> > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 46 +++++++++++++----------------------
> > > >  1 file changed, 17 insertions(+), 29 deletions(-)
> > > 
> > > [...]
> > > 
> > > > @@ -861,6 +842,7 @@ int hyp_ffa_init(void *pages)
> > > >  {
> > > >  	struct arm_smccc_res res;
> > > >  	void *tx, *rx;
> > > > +	int ret;
> > > >  
> > > >  	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
> > > >  		return 0;
> > > > @@ -911,5 +893,11 @@ int hyp_ffa_init(void *pages)
> > > >  		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
> > > >  	};
> > > >  
> > > > +	/* Map our hypervisor buffers into the SPMD */
> > > > +	ret = ffa_map_hyp_buffers();
> > > > +	if (ret)
> > > > +		return ret;
> > > 
> > > Doesn't calling RXTX_MAP here undo the fix from c9c012625e12 ("KVM:
> > > arm64: Trap FFA_VERSION host call in pKVM") where we want to allow for
> > > the host to negotiate the version lazily?
> > 
> > We still have the same behaviour where we don't allow memory
> > sharing to happen until the version is negotiated but this
> > separates the hypervisor buffer mapping part from the host.
> 
> Sadly, the spec doesn't restrict this to the memory sharing calls:
> 
>   | [...] negotiation of the version must happen before an invocation of
>   | any other FF-A ABI
> 

We do that, as the hypervisor negotiates its own version in
hyp_ffa_init. I think the host shouldn't be allowed to overwrite the
hyp_ffa_version obtained from _init, this feels wrong as you
can have a driver that forcefully downgrades the hypervisor to an old
version.

We need to do three things, Sudeep & Will please correct me if I am
wrong, but this is how I see it:

- the hypervisor should act as a separate entity (it has a different ID and
in the current implementation we don't do a distinction between host/hyp) and
it should be able to lock its own version from init.
- keep a separate version negotiated for the host
- trap FFA_ID_GET from the host and return ID=1 because
  currently we forward the call to the TZ and it returns the same ID
  as the (hypervisor == 0).

> We're also probing the minimum rxtx size in hyp_ffa_post_init() so doing
> this here is doubly wrong.
> 

Those operations should happen before the current ffa_map_hyp_buffers()
call, I agree.

Thanks,
Sebastian

> So I think we should probably just drop this patch.
> 
> Will
