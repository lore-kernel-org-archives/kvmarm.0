Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A89B1EE7B7
	for <kvmarm@lists.linux.dev>; Sat, 15 Aug 2026 03:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786764154; cv=none; b=OZXIvi6A5QPL+szO1jl0HPnvXYUJPp8rfJjTwR0+mYauWk77WkpTMI7AqaMXEIMUf36Kzo0YBf78h2wfPEyC60twAFX0YOkdh9hYSJd2cllJlt7wn6acMYxv9/vNwTGjOn5w7RgNskVjWLFmKXjD/vBr/SubhyLsOkrmOwwXqyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786764154; c=relaxed/simple;
	bh=gxd8EQtDJL+7J8yBONl7zGvyZm5F7eTxJ5MSfYlRQ9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvmcvsbdsOftqgCYuQoWoGtkAKOcWvq+kW/gLxJpyEZlPhVxbSI3546aT9p83wF1Nf4MPWK0usP+N/xXttwS8+qBnoHDPxX9d6RG+W1j6tQiDcHUJaRJXoBCxbvvHPIQ8s7LfI1BtCWo/9smWNSgTGI52kjgO3nsC7eSO87liDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ab8vwrew; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ab8vwrew"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-471eeac43bfso1480342f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 20:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786764151; x=1787368951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ye0y0tRevzSPz6VhXI7jbdhAlgjaMxZeRJ9jaKbqMD8=;
        b=ab8vwrewOhTYjqv3wB6Q8TSFZJyrt8+vVGg3rjFaOF6JWIMwDmO6kxKN79zSYGnteO
         wAnC9wfPNHVvC5SxxiEIByln96Usf/437znWEXShz7J/jE0sb+ziqTvu+YxxLWmz5OMB
         gpKn7EuDF6nBwLtqYwfZdNXRiWoaeZgmt0ghHty/vZkRylHypcUSMkfUioySMF2hUeVS
         +AQhgSGOnpCEUTDUXHRLb27JZ9g6SRajB0OXh5ghbmniDthkR/ypwrzjCep+uC5pZ5ux
         swOvpRitbSBALyTMrtYgeS5CjoHPUhQGrWHfBWOfR9AASfnPNH/NXiU69HLuRosJmo2+
         mTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786764151; x=1787368951;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ye0y0tRevzSPz6VhXI7jbdhAlgjaMxZeRJ9jaKbqMD8=;
        b=dbItLQkigl0v5j2w81v+96uzMcj8eATMvqsn/J5aVr3KEp9f/kxI32KQjzfStwxdJb
         VekTwice2MPRz/b689PiQaSUz/3Pes2yfye5RkTdRhMku2m5XVmnQPv7mdcQ9GCMo7Nx
         vQW83u0d5XDMEdaE3ExGa3TIvITMPsqGZTTe7rgJPXheMKek3fxg7DtxGoc0CRzT3GJL
         ISEs0TGD1VE/QD7bEE7T8Lx5Plf1Y3wTtX53TaQfEim9Hh7cVYGBMFV6/u64y0q7t1+P
         SQ2eZbGWc0bSB4yvbY61HWFktvNTz+IB9QYLkwRTz+gGgHDtI1QFaxXjP6v10vN0zR31
         +BXg==
X-Gm-Message-State: AOJu0Yz2nhrQjCBYyEAW/sbiLHxJiYrJlSTcHayfth3z5HUGabWT/RlH
	2elrPrWPff7TJK+TOaQEDw1rBuciIN+7uXajIPAUxp6QDA0nT9bNfPOI
X-Gm-Gg: AR+sD11tJu3GrfdIm4A4qE9135OJocf2KvHf2Hv0D4r0JuJ03kPMoVG5wz7vpD4uu2Y
	VagU62hxHg71mNVfMbWSxy9sy3l+mSuuET3G5MJHVKIglfTpF8gS+y0dvivtM8ld6VVDRh0xpld
	D3PRHZybZxPXGvqILPYUNPLMD1uB8qZgFMP70NoWt0FjjcfHfBlW6mYXeuaVXgT/YGzfcJGyEpb
	EbN1pIyE8ehJLnhTXJJB6zMKSzqxqHTX98hemkNYIEpMn4F238uW33C9p0KsAJE5POKy4v5bl4A
	BJpKLfKBxqPtHdYQ+WlZx/AId5OtSEaLaHgnKajR0Ffsgs69WbsNkc4oxaC0gbsSzmnTc6ck1Sl
	uSVco3Oe5N7h8hiI98YXQwFhdlKb28yrCXjyQ4qsFNY0YsSe2Nw70m7ZiFVSgaqhqqGbTQFvn0V
	wHbvzT+LEclBkIdEIg+8Ot9Q9uRGNxfIXqnsWycxmHThCc+Nxt+YjV40gmmz6FHjRDQYlm+rExF
	+t6X3rpdN1VcZ+tbjbKBFsxlDIYjyZDkwBo5Wwok5Lg8kcYRUs7qc3AxiboTkeX0YC0iz/RYRD5
	Ns5fQPsBda92AQ1TXNe5REi2U+dMb7POUsaLQCSu48ozq/rVBL98tBtPRutmw0j2Ig==
X-Received: by 2002:a05:6000:dc6:b0:47f:7964:9887 with SMTP id ffacd0b85a97d-481607aafc9mr10977350f8f.25.1786764151253;
        Fri, 14 Aug 2026 20:22:31 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-aecb-d601-fc34-eb31-14a1-3704.310.pool.telefonica.de. [2a02:3100:aecb:d601:fc34:eb31:14a1:3704])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2c07d2sm13323196f8f.30.2026.08.14.20.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 20:22:29 -0700 (PDT)
Date: Sat, 15 Aug 2026 05:22:27 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, ljs@kernel.org, 
	Shen Yongchao <grayhat@foxmail.com>, Wei-Lin Chang <weilin.chang@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: nv: Fix life cycle of the nested_mmus
 array
Message-ID: <an_ZDzaiPxhrp9zs@gmail.com>
References: <20260814103230.858578-1-maz@kernel.org>
 <20260814103230.858578-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814103230.858578-2-maz@kernel.org>

On Fri, Aug 14, 2026 at 11:32:29AM +0100, Marc Zyngier wrote:
> +int kvm_init_nested(struct kvm *kvm)
>  {
> -	kvm->arch.nested_mmus = NULL;
> +	kvm->arch.nested_mmus = kvmalloc_array(KVM_MAX_VCPUS * S2_MMU_PER_VCPU,
> +					       sizeof(struct s2_mmu *),
> +					       GFP_KERNEL_ACCOUNT);

better: sizeof(struct kvm_s2_mmu *) or sizeof(*kvm->arch.nested_mmus) 

> +			return ret;
> +		}
> +		
> +		guard(write_lock)(&kvm->mmu_lock);

tabs in the empty line.

Thanks,
Karl
