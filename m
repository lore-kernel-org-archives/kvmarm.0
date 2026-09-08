Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC9350EC11
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 10:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863144; cv=none; b=ERNnIcssI/v1ruyhIIbD4pFSyz7TJ0rw51dFWTfe5x95mLXkPFZkA3SVYGmD7mujAH0/zYa4TsFVUoWM70kLbljrc34A4dmYycnqzLnQpEUO1KJ9HZ80CltjjJo5ll8Uss0YhrV2fuGPpmhuBbUsaBsYbKD55cVIl3tj250k4XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863144; c=relaxed/simple;
	bh=1im1X+nWA/RVB8cU/fE0BjR/RtuRJVu+V8Tz3ORGegU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBVE2t4AG4zUAsQmKfZ403ZULzcFYn5fruWQIsVcyShTyfwh01n/y4G0Euv0YfiPEvw+JJbwQbI3csHAwRnd7osDHdR4vkaXlm1CRJnJrAnKGBt9+O+hXWqse9bLuwTPXpmcL/FIem7qVEy46HpgfQOV7eILTFNPzuNw+jta0sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WpqPY9JV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WpqPY9JV"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-484392e3d33so3161270f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 03:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788863141; x=1789467941; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sJghjsjeZZE/MAZEqL/GCrOia9QwjdEjzWzYPWrDgxY=;
        b=WpqPY9JVNw4ZtMW+Zdc6O2me/X0cXJb7pU2/OXJl8ICVqXQYOlW6fsPUMVPdoAGmTL
         zrdzpIx++AwNuis4pFoAypSVqGUaZQKAzXsUZ5w6XuW5QL1yosB0PQ4zA60ZwkBmJ41h
         O2LY+CIxXhGNeiFqQKOf55TFGShsTaY++Ch8FZf7q13FM2t4tfZUOJdFEvTL+2mByIBG
         fCnFBhVyajPuwMKSYhZ1nkoGdMADG//MebU3gK+1tuS2a/lEqFnjAyBwTVUVzjOzXv4D
         QFxIe/rZUBGCDpXcJfoD737zviZ56ZoM/8xjmMtb7s4o/XyP2v+bu9fJzfNunODmyE+Z
         WR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788863141; x=1789467941;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sJghjsjeZZE/MAZEqL/GCrOia9QwjdEjzWzYPWrDgxY=;
        b=f02vVOP/5Q3aVeRhikqlwmAnd+XEtKSJ0uTwcr6h9RAdeliikJ5yP5Y+m/kYImRRe6
         LmIqLOqSRSe7cgE+XR+gR8TjC8N1WrE0JY3Cuu6WhgJA8PS5j6JvHijp51ZgxiyYu+aZ
         RpygeHqjHRFTR+Z29ObdK0yzCzhvytkd1OrIIKX8zWyO2rCpnKE8mrf8f/lZFvcYiUbC
         ydKl3g9pZ6CiSGvMwNleBGERTWqUm46MVNWtrydafuZYsH+fCKTFkb7ztcFJ4etR7BE3
         K1bDdnV22PxBSbN9eDeVINxENZdKF/RNjgfUwTuKUBQZ2UppskqSZcrtpQ+xIml+04IF
         58rg==
X-Forwarded-Encrypted: i=1; AKwUvByrn3dzhiBYYbJ6VJOEPU9vJlCs2+D2x/gmXXdpvSXhVLn0Wg/Xkp4ekqZJ9HNP/obZycBcXMQ=@lists.linux.dev
X-Gm-Message-State: AFuF++mLcHX8/AFv1s8/hoV1+X+RqG3FJ01DmbmmJaVv58zvo7AYv9m8
	vIB3h/WZWMHFUGjmIEyHLAMMvx/cyoNhOR/7dyIlWJ74l86QDHmuUcETzs1IQhNonnr+0d9QUaE
	WX8zYMCxc
X-Gm-Gg: AYBFou12fupMaJBro0UFsFB72sHo0K07OGUDS4yzyOD73KSTMuu/hCoJlllZULy66/R
	nWxLJzqO/LvDpUuNM4lqjO0HaQUDh4SJk9pykZaswzQonADP87NUeCOlmCvNDHSGHMFKQdwH76n
	SX8HHo3v/8VoYdbZt+kh9aqHhehON8vbpL+LaxpDuCyUirjY1sOtdkgCxTD0pftGNY22LgSSmrt
	ZwOKJmcFCbXAB3PxSWOmN+E/rvSVC33QpDu3wmiuaydiP9aaQiZSE1N+5aOe8PR5Xz66o4DjCo7
	RTykhSstFxwlOV1VOQ/Do315uFwBmyWdvPYh5XuPx4y06esqIjK0XdODOSgpVKPtMA2DNAXQ/Vf
	dD0buRfeFiT+UsI7ygKjaha9S31kA3owLOSvggn4dcJBthkg7yAtSDbm9ZpNFAGqqB1Wxe/bomt
	dvDO0Sm5ts3LnoOtKb7ayqlRK6WQyyWKEmyXUcBft3IJXra/mgOvx/I0VpMkp94HjeRDKxE9H++
	nieyqvpRpl8/LlZ4aruO1IkruhJ0ofx
X-Received: by 2002:a05:600c:a0b:b0:49c:cee2:1697 with SMTP id 5b1f17b1804b1-49cf8262133mr282239435e9.16.1788863140078;
        Tue, 08 Sep 2026 03:25:40 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee60bae6sm555597215e9.9.2026.09.08.03.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:25:39 -0700 (PDT)
Date: Tue, 8 Sep 2026 11:25:36 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 11/20] KVM: arm64: Add a range to pKVM ownership selftest
Message-ID: <ap_ioANYZN2_aogf@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-12-vdonnefort@google.com>
 <ravrecwvcy2okwdi3h5buzneyfilfjgx76c374r7l7jtx62lqc@rom2sxozz5is>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ravrecwvcy2okwdi3h5buzneyfilfjgx76c374r7l7jtx62lqc@rom2sxozz5is>

On Mon, Sep 07, 2026 at 03:58:13PM +0100, Wei-Lin Chang wrote:
> On Mon, Aug 03, 2026 at 11:08:55AM +0100, Vincent Donnefort wrote:
> 
> [...]
> 
> >  void __init pkvm_ownership_selftest(void)
> >  {
> >  	unsigned long pgtable_order = 5;
> >  	unsigned long pgtable = 0;
> > -	unsigned long page = 0;
> > -	long ret = -ENOMEM;
> >  
> >  	/* Memory for the VM page-table */
> >  	pgtable = __get_free_pages(GFP_KERNEL, pgtable_order);
> >  	if (!pgtable)
> > -		goto out;
> > +		return;
> 
> nit: previously this allocation failure will print a message, but not
> after the change. Is this the intention?
> 
> Thanks,
> Wei-Lin Chang

Nah, that's a good point, it should print something.

-- 
Vincent

> 
> >  
> > -	/* Page whose ownership will be tested */
> > -	page = __get_free_page(GFP_KERNEL);
> > -	if (!page)
> > -		goto out;
> > -
> > -	ret = kvm_call_hyp_nvhe(__pkvm_ownership_selftest, virt_to_pfn((void *)page),
> > -				virt_to_pfn((void *)pgtable), 1 << pgtable_order);
> > -out:
> > -	if (ret)
> > -		kvm_err("Failed to run %s (%ld)\n", __func__, ret);
> > +	__pkvm_ownership_selftest(0, pgtable, pgtable_order);
> > +	__pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);
> >  
> >  	free_pages(pgtable, pgtable_order);
> > -	free_page(page);
> >  }
> >  #endif
> >  
> > -- 
> > 2.55.0.508.g3f0d502094-goog
> > 
