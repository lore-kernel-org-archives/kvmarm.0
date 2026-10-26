Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793038343;
	b=e5DHJt4j+ahlBFsVFwZC3AFNSuPPM5unqr7xl4Tb1LemlgFBWJvaY+vZRYbTmz4wlfm5
	 RmqswnaKUNO8DecyEUrUQwifyLGynTEB00cP8YgXPrBIs0axXL/EyoO408ntCkO6WMi3m
	 pcBiDwJzoq5zwddJrXZJFn7jNIkl496RNmj6jXYH2f0AAB9LZsKr6ju9EczMaIsuEvH5E
	 9Q0YNbT8Ndhk6tsaeTo4FMZiJVAwlMHswVvhmSYLphYixko0nydRLsLny80A0QCY0RifK
	 J20vG0iRrXARYOBIl82aPxj2z0ahjGCR2aNSQY6Q3IqBMBhuokpplhTDwCpWTaCl8Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038343;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=sS8eK21wcStxD43pokzl5l+eKhxWDBCgOyN2a4eiOW0=;
	b=ZR6m6kuRuQh8rJkECqIzVRpiQi+WEtRpw+zhuE6F6a2+q5tdg9Z45G1W6ezicahCd5h6
	 rKROEL26nlIUEourJ1t05sePFNDUfqcu/KZZvRE3vE7j1Wn48vrvAT27iQF/+s3idefQE
	 V+uqQy9dLW3yB46DfDRSBRr/7aL4Bj4algMwlsmG+6Gqat2AGMqLgpq2Sh+sU4bdKBA5D
	 GIqCvRp9Vt7Hzu9ucWRe/XxMQf6WIOjjzUoa5E3gtJJpdYAEC1H/EDHQIs+4AJEDGYR8F
	 +ngEcoTLQ58PJTi/LKLNMeXU8v2AA2qQ6IsKlNCKhn9OcId2KePCezMmWpyd/c7mwSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HaGbgBhG;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE417606A31D
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 18:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE417606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HaGbgBhG
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D935819F6;
	Mon, 26 Oct 2026 11:12:17 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5730A3F7B4;
	Mon, 26 Oct 2026 11:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793038341; bh=wWJzTR3+Htr+1KB+CeXE1r7KMO3Eq6qQO8tranbjgEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaGbgBhGvHNrCSoZMQZwE2Rf+O7xkvPrz8EmYBL5er1/HwqECfBXYRDWtWQR5/akt
	 H29jkInDU8TVzJ/EY6x/NrfrEC5SJpx/2ZTHZlIRabLVwtJe6gjhw1nE4dvJijMwCw
	 1BY5t2eXAWy1WXZLn4ljoJUkMWmP5t/p13GzHy9Y=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 06/15] KVM: arm64: Add support for FEAT_HDBSS
Date: Mon, 26 Oct 2026 18:12:15 +0000
Message-ID: <at-X_hFbsBU_Dsgr@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929103655.85107-7-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-7-zhengtian10@huawei.com>
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
Content-Transfer-Encoding: 8bit

On Tue, Sep 29, 2026 at 06:36:46PM +0800, Tian Zheng wrote:
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 32102c3912fa..12fa37328dd2 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2158,6 +2158,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
>  	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>  }
> 
> +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, scope);
> +}
> +

IIUC you run this on every cpu in the system, to make sure it's matching 
the feature. Is there any chance the kernel is in EL2 only on some of the 
cpus here?

If not, maybe we can run it on system_supports_hdbss() instead, which would 
be easier for the user to understand it only runs in EL2, on top of not 
needing the above.

Other than that, seems ok to me.

Thanks!
Leo
