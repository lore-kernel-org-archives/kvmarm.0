Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E658352C29
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 06:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774420689; cv=none; b=HkxH+gtEPekSG5h2OSsqDh+wbhEJW1K61kDdfDfWxSY4EpulwZtrRjzs2OC68q8c86i0V28lXKoBmv3nui1O5fMuhJh4YV1KBKsatZsv/w4Il7TSuKrgul/1yuAWkaAKPs9m8Y3J4bnd7RyK8aTMo0k3u6h7+Qf9FvDnMRf5+oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774420689; c=relaxed/simple;
	bh=yZtfD8ZbhUWOVtqgdCaXlBQFYIVZsgKdxdefJ6np6Dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5zJdXAi6ZaIwcLON9AXEW+NVW9N5hlHe/DMyiIcEF0H+CQ+iXMLRMslKVeb4LUZjLy4r8VQXzsFpiD4nNyDWfUbGJBUMfhVtRC/wAKOQf5crJglhPp+R7IgBbChjCemM+KA3VfvJtYSOlYi8JKRehozYfibjxLMm6gZx+o64zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A4Ma5kI+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A4Ma5kI+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774420687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pf2aP5j0cWMrde9xV40F9uxk8K2GUvZ19JNXNz1B5Hc=;
	b=A4Ma5kI+gUClzeqlpsBX4FPv0i3UO0xYGl6lF2osBMwAwntWpiO61kmHAbvtT/3IhkHFuA
	6X9e+LKSxziH7SIPLU7rxqf66vK2/xb69uG12Kt/LJIMOnDfzzHO5niYwlh5Y0s6El7c3B
	qKv1r58fBTpun3OaW3HWkEBZdvlIuZw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-fRyifdxwN5e2IOPgCCz5KA-1; Wed, 25 Mar 2026 02:38:05 -0400
X-MC-Unique: fRyifdxwN5e2IOPgCCz5KA-1
X-Mimecast-MFC-AGG-ID: fRyifdxwN5e2IOPgCCz5KA_1774420685
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82c71a8969eso255770b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 23:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774420685; x=1775025485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pf2aP5j0cWMrde9xV40F9uxk8K2GUvZ19JNXNz1B5Hc=;
        b=APcurtmNY4AaPHEgYyNQ+EKNT56pqk9yU4mCNP1jc54eRkvzDYOCUUxv6cv+SNZLiO
         eL60ZD2zzcllbPcfcuHHCuxXPjuGeXf7N0/U35XhI4/mCSpDPS9tg+frgurfuZ8m0z9J
         im/mmv06nb+pSb+8Voq+Y7YmFszfoZEfLIcY1+ZJRFj9XbUC9xMwsBmCOjTCU4nPhZ6Q
         sX6/BwQYfKNxumPqt20ZGqRBqtSfQ0n/EeTBVl/XHBKhX+sGIFIi1ZxNB/BnZV74jUcp
         GmyzCdJASRpW0PSsnytdM19VyLDqNqh8bHhs3psZ9RK4oPPn9D7KrnuNVyZPsi8Gqjhi
         QbKA==
X-Forwarded-Encrypted: i=1; AJvYcCV5qnQ0oeEDNsYWtDjcii7dGdKLuDutleuh75xxpqEB+nfNMa38q4nUDhoBv+qKZ6hbNaFLwfE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSB2hgpFwbx6ZFjOet8MlRR7DPhX+BoV8AbDpHDinFfP+zI6L8
	QOVjZzzV64xqHM0R7iRZ5BRP+rJCr3a4v2O1iYBg57IpUDUr/qqMU68TVdUN3i+3HZbdQ1Duoqw
	3GP2s19PTArer+YUE99JSWL40JLOjrM/kmZYWbMh270tThVjPO/DCNKSDsg==
X-Gm-Gg: ATEYQzz+OgYLBLudo2REhWcSk18BCZY+W7IhCFtRCoh8MNT89hM9bCct1EZFoUbEi9D
	HKntsLJaoBDlGMSKQW6CLRE9fn8Ed2abrZVvvigSZVfLcKMDSNIv4htTajp+EVjFYjG7QdISFdv
	ZBOdG5QKbuImpt87pF7TG6ZhTsCiKl8fvbcS9EzkOo7MYp2mhs8kLta6ITOOKdHMUjzRJPpclkV
	XXyYSCTAyBEYFocrGNqAQ40WOVZ4Hn6f0p3qtybMFixPl6+HVPhs5ErQM2lx2NfZ2iUCQJ3/Yur
	KfWzfnNawBR/KL7HGK4njlvt8aNFJxTCN3bEPwjVTANyGlMoQf3iExSdVukYEXM85RbxAhh6s5i
	LzOBTBeVHh+TZHinXj7nCgpbQy5s05QH2ZYFq1NBCnF0YVhZHEe3epulmTPqsCJW5
X-Received: by 2002:a05:6a00:1f0d:b0:829:8041:83f with SMTP id d2e1a72fcca58-82c6ded62f5mr2295340b3a.7.1774420684571;
        Tue, 24 Mar 2026 23:38:04 -0700 (PDT)
X-Received: by 2002:a05:6a00:1f0d:b0:829:8041:83f with SMTP id d2e1a72fcca58-82c6ded62f5mr2295316b3a.7.1774420684086;
        Tue, 24 Mar 2026 23:38:04 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbf0c2sm17111626b3a.15.2026.03.24.23.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 23:38:03 -0700 (PDT)
Message-ID: <0b7121e7-3c74-4303-a200-01d2b7c535ce@redhat.com>
Date: Wed, 25 Mar 2026 16:37:52 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Steven Price <steven.price@arm.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <abyAbPIkDn2bGZwd@p14s> <37bc1222-6fc7-48f0-94d3-6eaac420aa55@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <37bc1222-6fc7-48f0-94d3-6eaac420aa55@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: euN2Sv8k_PK9fyAx38BWR1Vn6Q33YoTDPfZl9M7aWpk_1774420685
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

On 3/21/26 2:45 AM, Steven Price wrote:
> On 19/03/2026 23:02, Mathieu Poirier wrote:

[...]

>>>
>>> The TF-RMM has not yet merged the RMMv2.0 support, so you will need to
>>> use the following branch:
>>>
>>> https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc
>>
>> This RMM version is expecting a RMM EL3 interface version of at least 2.0.  Do
>> you have a TF-A to use with it?
> 
> You should be able to use the 'master' branch of the TF-A repository.
> For now you need to set RMM_V1_COMPAT=0 to enable 2.0 support.
> 

In upstream TF-A repository [1], I don't see the config option 'RMM_V1_COMPAT'.
would it be something else?

[1] git@github.com:ARM-software/arm-trusted-firmware.git    (branch: master)

I use the following command to build TF-A image. The RMM-EL3 compatible issue is
still seen.

     TFA_PATH=$PWD
     EDK2_IMAGE=${TFA_PATH}/../edk2/Build/ArmVirtQemuKernel-AARCH64/RELEASE_GCC5/FV/QEMU_EFI.fd
     RMM_IMAGE=${TFA_PATH}/../tf-rmm/build-qemu/Debug/rmm.img
     
     make CROSS_COMPILE=aarch64-none-elf-                               \
          PLAT=qemu ENABLE_RME=1 RMM_V1_COMPAT=0 DEBUG=1 LOG_LEVEL=40   \
          QEMU_USE_GIC_DRIVER=QEMU_GICV3                                \
          BL33=${EDK2_IMAGE} RMM=${RMM_IMAGE}                           \
          -j 8 all fip

Booting messages
================
INFO:    BL31: Initializing runtime services
INFO:    RMM setup done.
INFO:    BL31: Initializing RMM
INFO:    RMM init start.
ERROR:   RMM init failed: -2
WARNING: BL31: RMM initialization failed

Thanks,
Gavin



