Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3307631F9B9
	for <kvmarm@lists.linux.dev>; Sat, 19 Sep 2026 05:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789795118; cv=none; b=XplRyeqNtJZWQF0v2/jEmPrd4rQpgI5i7brYXjzuqhlm2+yeAvppyEqgnwBdxeCHtsUan7ad4DUqFN9zEyBbX7bb3fjuE2qYY9Hbe1F1wNpxXs0j3cYH5MnhSwZ0un8GcmGbvfwJkfSJ9KoXWmbks6f2YvBH5z5+hpzCCrdPyD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789795118; c=relaxed/simple;
	bh=1tUtuUrEXlXgTzbEoxh1BpuPhgQ2b2BnNT3+Ec05ZYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pqVDIQRNPKyYDoFsc244tr3Q/GNmzXvG8kSHsaiazeInUpLzZ7CVgexzYCEBIJJe/4vN/V4jrGjV6Pf7QI05LZ33J6fqd/KU+Njv9wS3t0yr3YRKF8FmUrz3djh4q4IKM/SZhSxSHbq2CdReNJpaD/d8PohSZkXFl1O2fLXfmPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CndpAX/e; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CndpAX/e"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so10073625e9.3
        for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 22:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789795115; x=1790399915; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sBBnfsQ+/vg6cjSZvG+Kg56eu8vn625PDpD6taCDHRs=;
        b=CndpAX/eAMJsoxuSarFGpMpBQyuSXD8BE5E0JTj85l/NqkdH3e3IMWvT6M5ALAOF4F
         dsm5YjJiz6h7McgyxhosiNI6BXkhHg93/ZteUj4AQ/6G/GWGvvI/kFATGy9g16+AtxtJ
         TNj5eZ3AfMuGnRIsCKisgUPRo2EZ5CskKjtQB9NfmqDcOGhL8r5sbNYZcu7N9pXkm5Zh
         TKo6g2f5j1RyZWmedUZAeAV/5r3lc/+DYgT4cGAxhIvq3HC7ocpI0tOFJZm4JAvSltIt
         yn9cVhEnx+QEau8JteLXvIU8Z47FytMC4N8gjvYLlu2U03jtOQDbGiUp+eDvqOXRTxF7
         +dvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789795115; x=1790399915;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sBBnfsQ+/vg6cjSZvG+Kg56eu8vn625PDpD6taCDHRs=;
        b=ueDYoMBrbnm3YGRNtzRQZ2hAPCD98BubnxYHOJ3r9hgzRZ8VpgZfd/ZYBk0dZYqlMH
         3jM+5vKayasuXsYCCJeBkg8DGP9be9cauWml97gXOKRzxR9oiQk4LWdE9vLvVQSBowTI
         ngrsF+641yu2YptW87LdglFv3yfXSHIG1/P0P+8kLHxMP08qddf8MAeopVnYTt0donaF
         pM4Z38Eg7HlpwiqU9hkdqTQiyzHkO2/BB3xiOGbX9YBBJTZAutLj3/+8I8chIUx4yr1U
         kT3CvOjo9YNS5q4w29A6sESo5sxiIUMDdp6/lgEM1JspDPPG+QP5SKT5oDbqeuTohWGt
         qGGg==
X-Forwarded-Encrypted: i=1; AKwUvBwC8hmFdPYihZIvK48C83w30I7CMEKM6UasbUyV2lsc9woXWslPqGIhQOxnrkhwtMCd0UDhQ20=@lists.linux.dev
X-Gm-Message-State: AFuF++lJc9w/BKplnz1VyTBlvDa2V5xZdPL/gdc00t4wTP4ezT0apvPM
	MXCbR3GoSwQMzwWCXeqHOHGQgW96aKoXsyk8QHR9ixD6DYyJOTnOdw5t
X-Gm-Gg: AYBFou1IxCk9H5EOtuf4D+YYfjK56G1+wfgCB81y8DR2QfKa3H/chz7iKOls8du2GlU
	lMOtGa484+I1/IIR6/fJodxn0oUHvrczxIR0p2B+Th7bFhAWWV+lsyuw8kiTWGkdkL56fzNOVWJ
	pcK1A7dBySnS3R5GNhIya931XG2WJ4RogaNZxzvE6gHtX/r8GQl/bRr2q73vVAcEinpQYFBV2H7
	2keLPOstW+nPzEm/iiDxojh7mY26SP2cdisTT7INhFoMZ+xERwO//gks9JUOwvE3aao0uSig5qK
	D9KvFN4WbMiwny1pHtbr4F3eJp2NkOJbgT5PRi8pOhzEyxI4AIlxa8NjaBjYCzvhrfpvbeT5LcQ
	Xz5nxodOUpl4S8IXsPN9D0rD7kaYa00/RUb3/RcC9222kP3dtjquPCJIP1d4ILHd1VKR6/g+JSX
	39skGzKqCSK3nqFZOziRCWYCUWOwgkDOEiZSyM4bLP7Kd7AcV4yNR7n2S8d0AYjjMBfOo5vHXMD
	yeSJzsG+WtpMwqSYyV5cQiVu1HluetZaPqedmLorXcjUrofhMdw4vW/rUQUs6VRdGtIDsoH2Kxz
	X03bwWK3KkWJxMb64wToJWuRlBXrjV1sa9agL4dp7PqPEHh82zrdMMzd2rI2TssV6g3SyiHT1MM
	nYNHO/nBFGqkNrq8=
X-Received: by 2002:a05:600c:3f0b:b0:49b:d45:703e with SMTP id 5b1f17b1804b1-49fc56aa68amr61228495e9.8.1789795115151;
        Fri, 18 Sep 2026 22:18:35 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a017-2b01-05fe-203b-7cd2-a640.310.pool.telefonica.de. [2a02:3100:a017:2b01:5fe:203b:7cd2:a640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcda2140bsm30392735e9.1.2026.09.18.22.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 22:18:33 -0700 (PDT)
Date: Sat, 19 Sep 2026 07:18:32 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix AArch32 DBGBXVR<n> handling
Message-ID: <aq4awYi4eQwgcZ-E@gmail.com>
References: <20260810005616.13227-1-kmehltretter@gmail.com>
 <86qzk69x2j.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86qzk69x2j.wl-maz@kernel.org>

On Mon, Aug 10, 2026 at 09:52:36AM +0100, Marc Zyngier wrote:
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 5d5c579d4579..2862df188155 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -889,6 +889,7 @@ static u64 *demux_wb_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> >  	struct kvm_guest_debug_arch *dbg = &vcpu->arch.vcpu_debug_state;
> >  
> >  	switch (rd->Op2) {
> > +	case 0b001:
> >  	case 0b100:
> >  		return &dbg->dbg_bvr[rd->CRm];
> >  	case 0b101:
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> 

Friendly ping on this patch. It already has a Reviewed-by.

Thanks,
Karl
