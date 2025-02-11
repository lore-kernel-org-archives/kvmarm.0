Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CF26FB9
	for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 12:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739277806; cv=none; b=inCu1fCRjvi7bdGM/YhE5oYtbeZOVqyOq7W27A3gr+bw5UbYZNxHyCKjsvZBy385S/MdzczStF9MGHsO/gBkdqJUSwGzdbgcqcHERr9QvZPjBE3cxBd7GhbKVNiPxmWbBv3WPHYn5B0YlEW/+yNCjt2GyzdWDC7CCKK04dxc+QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739277806; c=relaxed/simple;
	bh=ZaDynmUZpB3fgf+ccdlspZi8D8W0GokI4Rg3ucKPjTw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jy6wrfcA3yWxlK+mFskZHHKGM64yJbNEyCmC+jt1Bu/EYI+HPb1nMaPoXik13VZsHMOpr3oM9drnSfCsqOK8ariQmEIjmhustpEhLRTL+UzjhhUsqyqiyrcfjx+zDq4VljxTO5qAWKNtLfkuo+FpWtwDGvt8A3kLRN2ZoHoh7es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7mq1vEk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7mq1vEk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739277803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fl8OSnLCA195UnsHqHADtSdhh5YuMF6KeCEzc0u9BFU=;
	b=Q7mq1vEktqkfvEQecyoD8nS0KH4UBeuR86G2L8jiGC78yi73eKH1LDYpf2kUupl8B3XrmN
	eoc9hQIKYlZAEYCE3TdPs/xEBDzvUJVT2rAZyzQtrwCI5Sp5AgKNmCbWRZlEvvDAUdBfWA
	hbLl/ikcmiwDx6mgCmV0wflpyZ66Mo4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-PGxdgjfpOry87r9e69zzVg-1; Tue, 11 Feb 2025 07:43:21 -0500
X-MC-Unique: PGxdgjfpOry87r9e69zzVg-1
X-Mimecast-MFC-AGG-ID: PGxdgjfpOry87r9e69zzVg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4388eee7073so30471805e9.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 04:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739277800; x=1739882600;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fl8OSnLCA195UnsHqHADtSdhh5YuMF6KeCEzc0u9BFU=;
        b=oX+BcyXmUNJT0mUAB8okPRgc0kxC+/lCWpUy8ZK8gQFiMKrfc1VG9mtg9fzz4AkQ8u
         RcfL0Pa872GXBCKxC2uVIU08DMRLiNffr7ghHqTyYc7YqgdqSa56EG7FVKjKf08TTpg+
         nuKfaySu0me/026FPZ4WJIiIRs27VRXXQAQZZZWDaCE2VEC6w9vyA5pURL/4L3T6HKn8
         VnKkeoZzr73heQgIzFJzGEoz8XhNY2NQIvOQLraJBQKOfSGubIP+ZGEybSJQ/oo22mvZ
         c0K9LhsfHwwhx8RNbDEcidBGph8UmGgnLBrcy4K7M2+gDdfs6L1brHs3jKlvzVd371va
         +DQA==
X-Forwarded-Encrypted: i=1; AJvYcCXwRCZ/mPpchWvC01/RFuDSgDFtOtQBtmbWjYsD3ldyauPn8cnojf4bTLd7E/+yoyTuGQQ04Yw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTLzPOOgrWtL/KF0I6lckPI3fh/y249OF3T+KxH+E7BLSGTiAn
	JCkwZOdtIx77PxXcr++zrfcPsD4AyouQvg3Rak/P9C58Oqd6xcUfop3VPNkKkxIe0NXW8jYckwu
	pwUIwgs0xbyZDH0q2AUKzqAeYDNdf7AQHOnsF0c4HwbajnELzIqHDow==
X-Gm-Gg: ASbGnctDJ8B4TPK/xh51M3MENjW9pe3LzSBl6jH5vNPL7dfQ855VFKqkRWVOhqVVzNL
	BtTjmJ1WSjWS8mX0Oi6dCLDUiYno5rqa72OIMlHIgHTXdqx3pY4IvC9bShOeHHbioZgebo84TWJ
	oL7QtGcO1/pQm8ULFWJEs0ODJ3ONcLXwLdAUaD6tF0SQNKZel23OB45rS4tu7xcNTsiQf67BvbH
	0VfZRB5ukus0hc1+hoKGfuRgC26ouH1zxPovx9Tx71Pn4LXh3cZlsdCAnc2R27dPhrsZF/go0y6
	J7il34xMtkSZDaZnHIgJjG8MP2MDF30VqHCQWpfqoTOpC0eVp1nwqw==
X-Received: by 2002:a05:600c:2053:b0:434:e65e:457b with SMTP id 5b1f17b1804b1-4394ceaf842mr28612785e9.3.1739277800592;
        Tue, 11 Feb 2025 04:43:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEk//W2BZo5OkvrLHLvMbFfjLDfIdPmBrP4srGuM2VWkzHyhBkqsKX8bhs4FGGa0+OXOscEUA==
X-Received: by 2002:a05:600c:2053:b0:434:e65e:457b with SMTP id 5b1f17b1804b1-4394ceaf842mr28612595e9.3.1739277800283;
        Tue, 11 Feb 2025 04:43:20 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dc5a8a9e4sm13420373f8f.10.2025.02.11.04.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 04:43:19 -0800 (PST)
Date: Tue, 11 Feb 2025 13:43:18 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
    Cornelia Huck <cohuck@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
In-Reply-To: <Z6pBd0XgEvrMoLcS@linux.dev>
Message-ID: <99f6301e-69dd-47e6-2cc6-10f44f6760cd@redhat.com>
References: <20250210154953.27002-1-sebott@redhat.com> <20250210154953.27002-2-sebott@redhat.com> <Z6pBd0XgEvrMoLcS@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8BYe9KD5hjEk8K8enF7bLmdH74cRHSEZhJtd6gfNVOA_1739277801
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Oliver,

On Mon, 10 Feb 2025, Oliver Upton wrote:
> On Mon, Feb 10, 2025 at 04:49:50PM +0100, Sebastian Ott wrote:
>> Enable VMMs to write MIDR_EL1 by treating it as a VM ID register.
>> Since MIDR_EL1 is not handled as a proper arm64_ftr_reg apply only
>> a sanity check against the writable mask to ensure the reserved
>> bits are 0.
>
> How exactly does the VMM's MIDR_EL1 find its way to the guest? VPIDR_EL2
> is still set to the hardware value.

Ouch. Completely missed that part, sry.

>
>> @@ -2021,7 +2037,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>>  		return ret;
>>  	}
>>
>> -	ret = arm64_check_features(vcpu, rd, val);
>> +	if (skip_feature_check(id))
>> +		ret = arm64_check_mask(rd, val);
>> +	else
>> +		ret = arm64_check_features(vcpu, rd, val);
>> +
>
> Can you add a new implementation of ->set_user() for MIDR/REVIDR/AIDR
> instead?

Yes, sure.

>> @@ -2542,6 +2571,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>
>>  	{ SYS_DESC(SYS_DBGVCR32_EL2), undef_access, reset_val, DBGVCR32_EL2, 0 },
>>
>> +	{ ID_DESC(MIDR_EL1), .set_user = set_id_reg, .visibility = id_visibility,
>> +	  .reset = reset_midr_el1, .val = (u32)-1 },
>
> nit: GENMASK() instead of truncation by casting.

All done. I add a test and send out V2.
Thanks a lot!
Sebastian

