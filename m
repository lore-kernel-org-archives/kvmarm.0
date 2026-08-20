Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862D64503F2
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 13:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787232321; cv=none; b=b9Gz6ehmPu56tf6ZH0uqMNUFmQmhYHvOOmy4S4NbI6j1Z5UNqk/6qTxuc1+L+ArBnvPl8RIVeRLFUJffzjMEs1YUN8qAF+I2ah/2OjovHR6yZ4toDR6uqItq/EvLmr2z15JbbBRSyk6oXS8uIXp3iObP1G4ffyHb2vZjy2iG904=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787232321; c=relaxed/simple;
	bh=3+wXYz3Xivy0AKKEKwgo5jBHvbMzCq6hPJk0sZNdm+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4FayB6mchwoI/0Kj1VyS+7JJZsZXx3b9Pe4B5ZkAEVTEvrGYPi+7MLs5R26mx+uBbCexLlRie4/xjTfuGgCe4FV6jXxs9JXTat2czbR1V/wlP3bBp9HV/2P7M5jT3V/vfGO83trqjDmQuH0CtcaCD9d9Vtv7ipq3W0UEQyWQMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XdRLF2Ol; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XdRLF2Ol"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-499b1409a75so48945e9.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 06:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787232318; x=1787837118; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3cD1lm9J5LOoc1VctowqA+QcEiYzpDZbKA3NAtqMB+c=;
        b=XdRLF2OlTxeZJsaHCtxOYJPc06S4DnAeLZNNd5Z35+54dQznyjPf+rz9eTVUVkCr8T
         UJjdK5tzx+6Ub6uRgqZsfV8tcJ5TomhFcUpvsqqMvxv2h+xJuLXMS27V9JCzGBLrNwhP
         TpG/6tAffeUpuL61rK6g1kSaE5I/jnqKILcnkZkWu9ApI/MqRxzCe84EyGwA+gsx45KN
         8ZHzULF/8OFZVjfUS4Iu9A1peDEBJuAqlCKbeVl63AIEGpFNtzckZnocAOMc56biRmOh
         Zw+UOD9R2cKiGAICHVSRMpNdSfdlO6ESt2G3C3eNlAB6b3IVmqbeUPNm9aJkysY6dhAS
         N+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787232318; x=1787837118;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3cD1lm9J5LOoc1VctowqA+QcEiYzpDZbKA3NAtqMB+c=;
        b=TK+7IC+OEPgA7veBK0HO61ake7mC4/nhG+CZc7QdEgW0Q7LhKOkpf2qnEXzBDvOCJ2
         QbnA2YcB5wN4E4fxldaMAJx7sdSN0iSElmQ+DKMGakT+buHDuRytFBFcp005hgClgcdb
         HILxtOLJuqP2H7hwE4v8zX6fN5+RXZUhbbSX3XCknGHVVJ8ZTuDSq5S5LcnoBbphsZ7l
         vP+q6YF5YHpSUfEarvZ036lTFQZpkm1Ym/Hqh9QANiRi8YS55VKfnwjEhPSVfF/HU96p
         etYVKbAGB6ImVqJVfxj7wPar/kKUnDS90Rfv0qNeuugBzzC2LtiPxRZr4ebrNO/1Lh3m
         zWkQ==
X-Forwarded-Encrypted: i=1; AHgh+RqL9pHE/fQaz8w/Mhapi9Tdlof56EDZpaDM0AB6ylQtplny6anfuORdil8pWb2cvkD6R6qFqV4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx17FKM0hYkhbF1CkSksg77ecZXcT5HcX9Wg0q16RIi1mJs7rP0
	5FLZEr8uDJ4Y4EQchk6mcukMMbfrEqiFtJDrN1YckQZp5Rec/s+cuEBIXLQFFFsGww==
X-Gm-Gg: AR+sD11WpbXcy53dTiSszDyocbZLBdPRw0kXpVZw2N75R3CSMRTpMwr7pm3dLP7Hq5R
	7fyLqLEvBR0TjdFtulF+vf7PmBGInKjTInNyoLCamEyUYHoZKp8SbKg23hO85A1cJfsgXHBaTD6
	NKtUrdWhW1CTo6CR6yfkGl1llqbAvb5wQ13uRqi6cv3FqCnQpUbVTCtIxCrSww0d2CnEJr5q4lf
	1VdvRJiSz5xXlhHUkZWrqpfbX9NNpQnMZrYKIx31UfQnklmbRlOrAUWlDklYNBkMvmUpH/EEUyc
	EIKSyVThhmI0ibSqF0LcTdvTq1FAE47OIgHZt2BvsJyhO3Of+FPdwJ7Cpt5Q4XaBrJgNaECQsdX
	OrdtLDcFKW5IZqvfMlVQMrDl1i/CenvKWfCgwj43o5NF0LX3c/4vRSOIexbdPCxL+XiMx65rOV5
	zn8LWe9e/JQ5DUaofjiC8A2+psIQQXXLpEh0nd/2J9afrcBwdp3QHN03s23N5lNquNKF9LOLD4c
	K05CAPGQb1TvOVmZbabCLmrp/+YX9RY
X-Received: by 2002:a05:600c:5ca:b0:48a:623c:8859 with SMTP id 5b1f17b1804b1-499b1ee3dacmr656705e9.7.1787232317330;
        Thu, 20 Aug 2026 06:25:17 -0700 (PDT)
Received: from google.com (63.235.189.35.bc.googleusercontent.com. [35.189.235.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aca21c63sm160099225e9.0.2026.08.20.06.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 06:25:16 -0700 (PDT)
Date: Thu, 20 Aug 2026 13:25:12 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Kim Mankyum <mankyum.kim@samsung.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Andrew Walbran <qwandor@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Allow smaller FF-A RX/TX buffers
Message-ID: <aocAODVhayfmy26M@google.com>
References: <20260820-master-v1-1-ea602b6d3860@samsung.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820-master-v1-1-ea602b6d3860@samsung.com>

On Thu, Aug 20, 2026 at 02:42:31PM +0900, Kim Mankyum wrote:

Hello Kim,

> pKVM currently requires the host to map PAGE_SIZE worth of RX/TX
> buffers, as do_ffa_rxtx_map() requires the FF-A page count to match
> the capacity of the hypervisor RX/TX buffers.
> 
> This is unnecessarily restrictive when the kernel page size is larger
> than the minimum RX/TX buffer size advertised by the SPMC. For
> example, with a 16K kernel and an SPMC advertising a minimum RX/TX
> buffer size of 4K, a host request with a page count of one is rejected
> by pKVM.
> 

That is because we should trap and report the minimum number of pages
from pKVM and not from SPMC. The host doesn't end up mapping directly in
the SPMC.

Something like this should do the trick:

```
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 48cf502ce1e7..95156d409f79 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -1355,7 +1355,7 @@ static bool do_ffa_features(struct arm_smccc_1_2_regs *res,
                            struct kvm_cpu_context *ctxt)
 {
        DECLARE_REG(u32, id, ctxt, 1);
-       u64 prop = 0;
+       u64 prop = 0, buff_sz;
        int ret = 0;
 
        if (!ffa_call_supported(id)) {
@@ -1364,6 +1364,18 @@ static bool do_ffa_features(struct arm_smccc_1_2_regs *res,
        }
 
        switch (id) {
+       case FFA_RXTX_MAP:
+       case FFA_FN64_RXTX_MAP:
+               buff_sz = KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
+               if (buff_sz == SZ_4K)
+                       prop = FFA_FEAT_RXTX_MIN_SZ_4K;
+               else if (buff_sz == SZ_64K)
+                       prop = FFA_FEAT_RXTX_MIN_SZ_64K;
+               else if (buff_sz == SZ_16K)
+                       prop = FFA_FEAT_RXTX_MIN_SZ_16K;
+               else
+                       ret = FFA_RET_NOT_SUPPORTED;
+               goto out_handled;
        case FFA_MEM_SHARE:
        case FFA_FN64_MEM_SHARE:
        case FFA_MEM_LEND:
```

> hyp_ffa_post_init() already allows an SPMC whose minimum RX/TX buffer
> size is smaller than PAGE_SIZE, and the page count supplied by the host
> is forwarded unchanged when mapping the hypervisor buffers into the
> SPMC.
> 
> Allow RX/TX buffers smaller than the capacity of the hypervisor buffers
> while continuing to reject requests which exceed it.
> 

I don't think you should change that, it will probably brake things because the hyp knows that
it is using KVM_FFA_MBOX_NR_PAGES but you only mapped npages in SPMC. 

I have some android patch where I am also trying to remove the limitation that the hypervisor has
only one page per mailbox buffer (set in stone that KVM_FFA_MBOX_NR_PAGES is 1) :
https://android-review.googlesource.com/c/kernel/common/+/4238522

This should probably put you in a better position for a patch ?


> Fixes: 9d0c6a9af9e3 ("KVM: arm64: Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host")
> Signed-off-by: Kim Mankyum <mankyum.kim@samsung.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index a327c2bbb6b6..594d1112b5f9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -239,7 +239,8 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
>  	int ret = 0;
>  	void *rx_virt, *tx_virt;
>  
> -	if (npages != (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) / FFA_PAGE_SIZE) {
> +	if (!npages ||
> +	    npages > (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) / FFA_PAGE_SIZE) {
>  		ret = FFA_RET_INVALID_PARAMETERS;
>  		goto out;
>  	}
> 
> ---
> base-commit: cb8a75eec0877810b50aa1c5a833f929525cd2ee
> change-id: 20260820-master-572418a358ab
> 
> Best regards,
> --  
> Kim Mankyum <mankyum.kim@samsung.com>
>

Thanks,
Sebastian 
