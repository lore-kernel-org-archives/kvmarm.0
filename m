Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33E64A012F
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 13:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355856; cv=none; b=KfPAtN7fbtNzsLr7gIJN9eWTveKfaD1IFD5C3/k0RBKne17rMK5y9mW4ONjjoMPZp1nuDetV0sG835RmVYA6LjuQ5THyIV0j5nBKh7aduoUFNsWnAArwec0RwoTR26ODR4EH+n29oS3K8eEJGnApXcS8Ckdsgr3aHMAToPgM1lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355856; c=relaxed/simple;
	bh=NxKnop67K40F9mz2/w4xW51Ap2vB7W+wpl1PHcBVYv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4053uBMo9eMLZzxmmyK0eT4+MhXRZuBMRem6Et855Ff2Xr+8PDpH7G7wvTNJrxeWBEJHpkoJzNLrLkVFIvL5nXvYdShjgub7f72cjEPVAGdaL/Fj7C1Ozjc5pvg+CLAxC89owCFmpbpZlRhuVjLo20jyoxIHK0ybHbIkFV4yWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MQ6d8/1q; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MQ6d8/1q"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a5e329c0f2so1372539a12.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 06:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788355853; x=1788960653; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YsG1U7ahDUDRdpBFdpvVDRbtk4czDxTB0Kyn7B74q6I=;
        b=MQ6d8/1qETA8S4r6u2wGMX7Hl5BZKqIK4VW5b87iWQqrq8ird7WM/2bKr5GOeb0WWn
         9awL1w9bcKMAi4j5/tF3MOuixS9YT847tX6zXR4Zkr/qYybyGmNQ8LPFUZvgpbYjzwzs
         /TvVH8/4UXcs8kW5t9gWz3LFSsMsrA7JZ8y7b3baL54s3eJo6Et7/qYruqkU87wYvXqC
         rlfq9TySZk7+LfwaR+spqo5DqSy4h9CloqpqmOU72CdB7n0OnoO+rPgVgZi55nRvwbqf
         JD7YR/k7XCEeVDlxsYTZTdn7o8mKD5FR3SLtl0RPBmKAzdYH2ZaOm8QCd/31UMqsuIfZ
         DjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788355853; x=1788960653;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YsG1U7ahDUDRdpBFdpvVDRbtk4czDxTB0Kyn7B74q6I=;
        b=ilJ1slpBlapU1gYebW7mSaW7DC/I+w7DUUw+uRe+LyaLzPwjXC4Yz8/MD6pv8N+guQ
         cbiZw5ddg/gWmT1dq1/xUYgNrj6U8QWFAJPDBYHMi9f+C2gWrXCzxg0+7bCpxJwFhoAk
         kgDo/YXjvVjEwxctflZeFAVq+InQg3N23XMvn2SC64tO491qHn3Mv4pr2IjoF6gcL73A
         byA+stuSlgKkNyKHlNqMdN1+yzN0EQW/iihqXXM0ZOcoTsrDT59hWGkCvgx4Q1UzHHA7
         ttGplkyMrIl7fRan0zbyRQNMoPDOKpVLy9PqAWCeyVYk4EDJu+hGOuAdAqBvj7rOr83E
         lZJg==
X-Forwarded-Encrypted: i=1; AKwUvBwdPDeHkE0kpnI89rBZTAmlQwE2lMyL5commZh7pT/6hVvkQwh3b8EitfCaVQfWjdA+s6O59b0=@lists.linux.dev
X-Gm-Message-State: AFuF++nb3PG20SkX2KM8cfsZ4RpRGnMBICTJmOpRZ4qdutfmar9m0cOh
	eX56OVzo5+E3q/clde2BVTptE5j/Z7cRSvlSqPQsujxCasVTQJh0PHV58o24RRPVFg==
X-Gm-Gg: AYBFou16pHAOwQLHhKW+0m7/sBJF9JuX5rj2zkgqhmSU3tQ5IThsVvJGpIhIoM966sg
	OHK3/Q+BvV0JL66/HoWtuKsrnmgJA7hLflcFv7eUooOAvfOr5aPtC4dEkVga4pXtb4HWSLDvsDx
	kJngl4DgbpWRVqD98Sz2OesneQf3AWVAleWD65Ym9ZnDs9xYEj0m6hfWlua3fe42MxtfmB9rA/M
	JnsK4nYLFH7UM/n5v1tbFd40CyZ2nPWfTtl0q4pPFsNbaha4TBN4G2oCiEBrhLeas8429MigH7O
	u6rSOZ/v7J9OQqeyytVc+5NVNldhMuNDOGEAGqykJK03gXVXLy0Z9XhIBEcu3Y8bjvbgl4eUyv1
	MKDiHQynBszORC2Hsf2xD2g032/usUm4AtSDnfO84nsusgOXXQiUAFIGYQLOW4MIHVZkQdkTcWs
	+KoASRft8CMbIyxYCgXI6PX0Ew+8oUluz+66jFFWQMX52TUxmulI+ooAqjH4IpQIPagGVyTIU8y
	dBc1B8Bv21nH7BTg9oZbXmwYynNvKg+09UsdXqy+X1N
X-Received: by 2002:a05:6402:2486:b0:6a6:757d:632a with SMTP id 4fb4d7f45d1cf-6a6828a183fmr3550857a12.17.1788355852434;
        Wed, 02 Sep 2026 06:30:52 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f932bf5sm1108584a12.14.2026.09.02.06.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 06:30:51 -0700 (PDT)
Date: Wed, 2 Sep 2026 14:30:48 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 03/17] KVM: arm64: Reject the PVTIME vCPU attribute for
 protected VMs
Message-ID: <apglCDec15q8D8u-@google.com>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-4-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163421.272420-4-fuad.tabba@linux.dev>

On Mon, Aug 31, 2026 at 05:34:07PM +0100, Fuad Tabba wrote:
> pKVM currently does not support steal time for protected guests:
> KVM_CAP_STEAL_TIME reports 0 for them. The host still accepts the
> KVM_ARM_VCPU_PVTIME_CTRL attribute, whose IPA would point
> kvm_update_stolen_time() at the guest's private memory on every vCPU
> load. Return -EPERM for the attribute group instead.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/guest.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index b01d6622b8720..23f725e2cf745 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -916,6 +916,10 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  		ret = kvm_arm_timer_set_attr(vcpu, attr);
>  		break;
>  	case KVM_ARM_VCPU_PVTIME_CTRL:
> +		/* Steal time is not offered to protected guests. */
> +		if (kvm_vm_is_protected(vcpu->kvm))
> +			return -EPERM;
> +

nit: We have vcpu_is_protected()

Also, would that make more sense to put that check in kvm_arm_pvtime_supported()? 

>  		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
>  		break;
>  	default:
> @@ -939,6 +943,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>  		ret = kvm_arm_timer_get_attr(vcpu, attr);
>  		break;
>  	case KVM_ARM_VCPU_PVTIME_CTRL:
> +		if (kvm_vm_is_protected(vcpu->kvm))
> +			return -EPERM;
> +
>  		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
>  		break;
>  	default:
> @@ -962,6 +969,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  		ret = kvm_arm_timer_has_attr(vcpu, attr);
>  		break;
>  	case KVM_ARM_VCPU_PVTIME_CTRL:
> +		if (kvm_vm_is_protected(vcpu->kvm))
> +			return -EPERM;
> +
>  		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
>  		break;
>  	default:
> -- 
> 2.39.5
> 

-- 
Vincent
