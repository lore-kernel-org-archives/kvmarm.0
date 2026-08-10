Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E463803D2
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786401170; cv=none; b=DOlODhyOuMmYlrxoHth+tkum/qmfkgQBIKdXoXL9xVhNDqGss2jvJCiz9h6TLmvpa9Y1aokFRsVmhjqL95lZxruEJ8Z7b276rCIs0agMozzQ3qELET2kEOrjTxyDLMOvbRANrw3GIrt1nryXfjbO84zvtzUtfKfWXAGLihT2JnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786401170; c=relaxed/simple;
	bh=Ut4xeXPIHkP/ZTuqOULeqn9lHhqonacl55jKH6OZGjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRE7GsPnpBTFdrPSKFR2OB/0TOBS/xDi5rwd+cNueiuV4hdXdffxj/Vupx3f2jGJoGCJ+quZ2mAbRl4e5ACPcKGzQnYMkKM0nR6HyFRQvVj8lr1teA3yM0zcfycJ1h1bSyegEl5a7iChPBOxu3sFDlKftqm7eDYcrP+jPmaD+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MpJuVCa7; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MpJuVCa7"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4980dc26022so24446815e9.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 15:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786401167; x=1787005967; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KujuDXjufsH4fQ0xRNZyj2JY4LmTzir+J1KJ4jS+lJA=;
        b=MpJuVCa7p29uYRwiKyvzAQ/uOGLavgaf2dY0lS0w7pFkX0Dh0IAUWCEunVK7sY9VOl
         5nbVnjs+mdbaq7A/tLRblHIslcnloOkK4z7Tn2nX1LGZ9i/15MGIffM1m4bD7244n8Oa
         25yg2WQEazQoEIqDPHLZt/eh2S2eBtjL5KRyPmlKvo+VeLPh1wCpagOSybl990ZvttVY
         HsYqsRnYWstIiF5WFJi+lWHQoysB5QpCL48CgmSOhx2IHEpvZ5hJ1QOyqgu33mod3qpJ
         OBhmtVEdxSphbk/U/rGIqfNGZyJ0hvJcWhkKoazy5sRfARUEvJ8e33Jgvzp4ZzZcOQl0
         dp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786401167; x=1787005967;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KujuDXjufsH4fQ0xRNZyj2JY4LmTzir+J1KJ4jS+lJA=;
        b=l/zkun2WJPTZc+hGG201We9TFLXgSOqc7I7hpwr4a/F8Oe6hsaAp4nFZYrRV2fkW7T
         McO0EWZ+odaMEgFQbvFrlj9Ye8YJjyn5DJwVXoOxpJBAPVj/Pmmlk6tGpD5iiHf5v5rh
         SITyGRoz543k0nJHYyZCl5+qk/Za7q/VXEJroe6Mn5Sdb9Gw9ZyLB3qg9UTOlIklsJUT
         G5oD3+AoIsjtZ1Z9ImnbEaOBYKq9FgZ1WVPBnUObBADPK5Bigbv0v5nQCDNLN6Vk79e6
         +pizwohGd9r2lo8QONJFTrqvfgep34qYcTRWkFvtbp3vMI1d6GJNTLPRQ96m+FM9qLkv
         CbaA==
X-Forwarded-Encrypted: i=1; AHgh+RoEU5qNvxGW9uyCtqA1LRZ9n3/2bAaa0h92Tx/rZ3ylw5sUUZ5iKlW2/rkuKq6pQV23lOZazew=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxwKSAMbugopTKgdQmj7CgKJUZ5RR9BjDL42khaUMJWHeoC8vR
	41mbWf9Eaftg9jqT45A33xmHYtLfzQy+zmm7vB+6fXIFdxcTjAAO6qbA
X-Gm-Gg: AR+sD131095UxI9tNh5f5pUH+/CELSiKhyoPCmuauR/k1xYn06ZHXwEoJvnPyMTHe3x
	VmSIqtxPf8S+mZvu+nnhEb8U3PXj9Bn1iyBihu6gsoNuShKZi5tPLDCa7sHt4/0gsqB77wF+gQu
	LB6/FZmazggPT8lzyExVuw7G8uz9EO/h/3eGSKd5tocmJx6MbqygXEyadGoYyDX+E0KIAA+p6rV
	+2QmTKx1vX7DVeTBzoKAUGe87Hm05Pb2yU86varIhyeKWK4z3tc6oFHYdd+U281pR7tESSjbErF
	vInOqEVB8g75KCOIkSasJNBINfGE7Er1Dkwxi5UKo3zzO7CPsyBIP2VzSecjRWsJmlVrF/OASIB
	mJehu86X5Np+9FQ8qL8+SJHagwADAq9UyeRFgP8a7uYs2vaw3ywLBoik5609gFzuZks5+Wro2Z+
	iMiRPRasDWDv/DYS0u+yq0wI9UArNfCq2T0JBxdDyFA5CTnTtpVidae/002fbPtRFhsYMCvsyfM
	+vVo444Ryl9Sg+6jNQlUDRr7Vgq3qkli6TfKSxff+i8wGTCEpybg2LWlTYyp+D1JhJxQ3ihc/fI
	VMCbULcEg2Qud9J2XiDocwU3T8WmHAc8JAIwso5Pu/J7aTt3xspt8rMRzx8Qxg94+8sEIi0=
X-Received: by 2002:a05:600c:8b17:b0:499:726c:50e with SMTP id 5b1f17b1804b1-499727b1011mr49652125e9.14.1786401166552;
        Mon, 10 Aug 2026 15:32:46 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a1e8-7401-316d-6c00-7a9a-8fac.310.pool.telefonica.de. [2a02:3100:a1e8:7401:316d:6c00:7a9a:8fac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995d85254asm153382245e9.1.2026.08.10.15.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 15:32:45 -0700 (PDT)
Date: Tue, 11 Aug 2026 00:32:44 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: nv: Allocate the shadow S2 MMUs
 individually
Message-ID: <anpRMrGG_54yO6CL@gmail.com>
References: <20260803224405.41468-1-kmehltretter@gmail.com>
 <86mrv2arf2.wl-maz@kernel.org>
 <anYNTW2e3HalTqTk@gmail.com>
 <878q6fplpd.wl-maz@kernel.org>
 <anizGXThM-haqQXU@gmail.com>
 <86v79i9zl7.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v79i9zl7.wl-maz@kernel.org>

On Mon, Aug 10, 2026 at 08:58:12AM +0100, Marc Zyngier wrote:
> > The increment expression of the for loop still runs after an error.
> 
> Yup. Should be fixed with

> +		for (i = 0; !ret && i < S2_MMU_PER_VCPU; i++) {
>  			ret = init_nested_s2_mmu(kvm, &tmp[i]);
> +			if (ret)
> +				break;
> +		}

Yes, that fixes the cleanup issue. I have no other concerns with the patch.

Thanks,
Karl
