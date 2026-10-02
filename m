Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2377934E75D
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 09:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790933684; cv=pass; b=AxMSTiSW5DJ3t90GyrjMnNchIBTrMVhQs5/Y9EBOFgEeVlFgt59nhMSVj2wLSyjYBxyu8T4s+KVDkCr+sJMBkVKntFoeh/h+1kF2uqtSUT64pTsbVpGRKz+zshd9ZGfSHv0slkLPeBAYFzMcD4J2+M4Imwubzt72JuzWyu0HDEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790933684; c=relaxed/simple;
	bh=x9JTFIhcYIzkewGT1y4B5m/45uK/p/cDf2r6ve5Iqn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cVJQcFvcTPmGlkoN12YlNYpQ/h9lfwuiLXx3avxg6jUUEfQ9FX6Ii+VgqqWRQKCZt8IQ5xJfsoIgP8EP9Bdv7Y0LrPPse+LtbGOliSw3lbcWy7onRPpAF4sv3SLw66OBKuFee8mfCKZ+Ki2bBshs5hIp0YrZ8L16gxxssJHLkr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vTev8OZU; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vTev8OZU"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba40832934so4321e87.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 02:34:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790933681; cv=none;
        d=google.com; s=arc-20260327;
        b=jkPPvIL8Hfl5HwX8OUqyWYjTskPo2CuHT97POpCZHbF35ZnpKPqvRX0dZG8AO5EcEl
         oq6f/WFYdNm3zmTLaPIcaYlwcai2Zohl5W+QJF2JCQiYv26gTtc5cmDAiCy5lk3LAY8N
         /T8MGJfOV0U1FntKXIn26NUOqECLhzV1Xpr8eMdxmYwQTNicR8RkCnUKT/iOJmv05RrD
         /IpJaKvgiJdjKv6hLTc2DE/0rHQtsZciUNESv0OLC8sMn34hpkpSscciHR3kuGNx1oCj
         05sGHHLCK3/s9cs1XwtZ1S5C3XGGG1ITWAv3ni4Pb904YWBnZIML5bWfjYe4PwMD4JiC
         LJ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SuyjNGNTaeTrwozTD0DPhcs6tJEVH09iyMIGVlGNB8o=;
        fh=rgDNzCsL7XIeD99JeApenYXuFnnCtluOVlcBzNCcxJY=;
        b=faED2ZItiwTRqHuR/xAUPCX4T16GP0e5zAPD2LDu+bGkTKDAlKD29bNAXcF3B4pDu8
         IXnx/VVGn2xwTZZ1Riqwis5BKq/pg1kWcktAM1wDeLA2u/iqisqmRHaFsOhixLDAOO07
         ii8tTfW5AtKGR+KieUjiuGW7cCawXhtWV81ZQ5XCF5A3Jct2Wv/kX/D5fIvjKZY+crYo
         CwqOsFFcmcflXaoHDdkcXjV9f9dTOvXxQ1eRyC6kJVrWgWNks0kBM2yjBzFbuhzLt+fQ
         zu1w7vGyf/POl7F1MbYUrzlnYdBI0ohRsHDLn4SL1eztyvanJqk2aLzVkfUGmhK8ZCmj
         4pvQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790933681; x=1791538481; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SuyjNGNTaeTrwozTD0DPhcs6tJEVH09iyMIGVlGNB8o=;
        b=vTev8OZU5cQuDu9KCAqs96cpLIZh41+WsHZo4IBzVjG1Xt0XLmTBUrr/1fx63f6E3O
         LQ7vesjRbdraYH6q5Q7DtglfDhwx3024TSwqy519EOE86EwV6ulQge+jMsQI+asRg/fp
         WXnFeaNL98QsDbnfgW1dDknzhYfsZOIkFpFnNhcFYH+qvLv6gtWVqFL2aaBkdAYP8rYQ
         vt5+Bs3X/4KzaA+95SZGIWcOKAwQm3dUHnUUbrQGu+lsRvPkdilWKrD7Mr/Hhgz/EzHQ
         KiDlsrg76reXFfysfr3u8GCunkOsCYh8YXBmNw0qEg+gtohQe98Bn9DpehvRIuqTvoBg
         q9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790933681; x=1791538481;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SuyjNGNTaeTrwozTD0DPhcs6tJEVH09iyMIGVlGNB8o=;
        b=a6/v0rMN24DnCSnV2WIawJi8DIxC2cFda2NXuDKKU/EABDmw67r05ln5mGs+2JTKUS
         Clvm42phfFu0TzwZr6wTpWV/guP/d9ePn7fazVQcwQm+AMBsrrZTtz95ZGk0BcF8kU6T
         yn2K8oiybzMYKXC8Dw0GeDBUoltyyjHmRn/fgRwWU4UFAHaRCRZqzaBpxRot4uHv4O+v
         j00ZvhTI3ZIUh4j+K+OHPzX+hQtNYNUQEia/wa2l4XbsQv6qMkYWg3d13qMGhi9/jmp7
         tyTnn1QTthPvpUVfcT8PBbS5QnrmKPGQBEgnbCWVL3LUHLNHYYZ/uN2PxGyJw4QQmEkS
         aFjA==
X-Forwarded-Encrypted: i=1; AKwUvBxFng3lv0JQinlz2M9UyWpg9766zBkd38yRmuF8tt2Es+C27o3Gu//ZbrlDfkvPVpOvWhImLTE=@lists.linux.dev
X-Gm-Message-State: AFq9FYJC2kgeX236kH/kSMhctwcGya31ZzG6qCIycZd7GSZyoNPr3Mle
	XonXrjccxG/VJEZROZkDqh1GaqrPu8TLqPfInv1PbOAiUjQuC69vF1i8Q8pnJF+rZOb7TI5qzzt
	zS6Czzi3pZVfGAccRCPTnWOpMEnzvB6kZ+tBgxcF7
X-Gm-Gg: AYBFou28ndQLpAw2Ny3INKmACLahYS7kXswUT6LjCqOOUO9Za/nRXCKjPsN5ec0LTbj
	LW7Sb1CbwY87EnD+vfU7nQtXMwLIl53P5gKiaN0B7d0jHCHSIoCsiZk/uvEVoXDJTFAOtQvsF3V
	xdtTCcEfoMXk32ZYXnXqgJTGLPAupJYM0FsqIJDPB8/yWHP3h4vv2XO5gpXYIHK9YDmUzmwequW
	EbaaGZA20R2O/cm4XpUus4crYbFSXjdaDfMRSoB8cJ7mBQh1iVXs/mtEHYjtFGlzT+55dgkEtvE
	MZaUkB8OiGDoS0GkETcSW9+IRdFM+Aw/Y82+pSAEAlrEytlkrwOXICe1LDRbpXo6pLLCunF4RXH
	z9jRV/mPLehmVyQ==
X-Received: by 2002:a05:6512:6d1:b0:5b8:f20b:350c with SMTP id
 2adb3069b0e04-5bb7c948658mr120571e87.3.1790933680638; Fri, 02 Oct 2026
 02:34:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001210703.1597150-1-suzuki.poulose@arm.com> <20261001210703.1597150-19-suzuki.poulose@arm.com>
In-Reply-To: <20261001210703.1597150-19-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 Oct 2026 10:34:03 +0100
X-Gm-Features: AclHuK90hdLcclI22eF8PMzgsUup2Pu-fPsPyAyT7zN-k3WxhBppCUIye56E7qo
Message-ID: <CA+EHjTyyKxW2TT9XpjSDkdjWEuGyWmA_isDpOnoyri8ikxZN4A@mail.gmail.com>
Subject: Re: [PATCH v21 18/23] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Thu, 01 Oct 2026 22:06:58 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
> +static inline bool kvm_vm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
[...]
> +       r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
> +       if (WARN_ON_ONCE(r < 0))
> +               return false;

The fix [1] is in -rc5, so a rebase conflicts here. Please make sure
to carry it into this copy, i.e., a plain "if (r < 0)".

With that:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260914093838.1082637-1-fuad.tabba@linux.dev/
