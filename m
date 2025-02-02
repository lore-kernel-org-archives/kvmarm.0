Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B6B17993
	for <kvmarm@lists.linux.dev>; Sun,  2 Feb 2025 02:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738462566; cv=none; b=XVLLrAOUL5JmWuvDUA3uENFs3aRQh9fCrDx8WcHEKuGLZ4AzEJm3TbbwNtjw4RjjDv0/JnqvTzXDq6Jh8CGpQ2T7jZyaTVR+/qOsLcb0aKhx2I8roD/XeMFjvO3GVkpXEUfd2U1gIfrzIex258yo6FFCy/I8U+Fuchipl3m1tjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738462566; c=relaxed/simple;
	bh=YpG5rQ2KFsWWjOCvMTMldtm0ojXwxSh6Ny+S3WE3jww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJv0nyoCdgk0/tc+4YKFBAL040wE20LS1grqXHvoKQ8YSQgXqYzoa72pESNFJkVcyksDsiTMTrzQBbx6p5SMB2jew7sVj90Qsfxc4YRhP2ASuXsHLCge3O2r58MtDBYbTMQ9nt2qaEScKTCAvoPSYfcZQ5i915d5dK/zoNrXuw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J7jkgibK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J7jkgibK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738462564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oaPgjrYHflaoqP5DxCw0DAPnLuPRTINmmGCdI1hjL0g=;
	b=J7jkgibKawX1xD+GuiBudXeBtDpWjCCtvEpIfkDvin5Kkc768jxux+T8gtOKFJMtnf57Nk
	Agrp8oawjqQTzjZy+3Mr5yvizK3XQVL6QstDBy7m8JEsmzdI+TgfvNpp3VPifDLhG3KYOm
	fF+2PJ8Hm5tYVAy4OENuMjDueLjsKV4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-COfeVo5-PNi2YJRKwsIMDA-1; Sat, 01 Feb 2025 21:16:01 -0500
X-MC-Unique: COfeVo5-PNi2YJRKwsIMDA-1
X-Mimecast-MFC-AGG-ID: COfeVo5-PNi2YJRKwsIMDA
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2ef6ef86607so8142755a91.0
        for <kvmarm@lists.linux.dev>; Sat, 01 Feb 2025 18:16:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738462560; x=1739067360;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oaPgjrYHflaoqP5DxCw0DAPnLuPRTINmmGCdI1hjL0g=;
        b=qUHA+kWGAvI1J0n+SXwchwppMae2yrzANoM7AfwqYuGnog/ITTXqfdVXER+/ZWPUcR
         6QD6SrVfmqUh2giMNwbh5hq1nkbsGA7yfL2/oBXKL+jRF7aVfIiQjuXD4iikD3KKIi4I
         KQFi9xaJ87RH4NfoDLijpmJ6j9XDYswOE86B0D55ivZPxK3GM/JoepPaBPo6ZqpADAVm
         UIDXUcDhzHsvKc8p0E5lcZHD0N2dn0FR31D/PEQZoW+yOm3DKaurHTa85NJm4zbl0F6T
         f4rPCuityZtwojHqyl0q0AAGQ7SUM/lXHQtJ3PRXW5s0mqSHzJ2RZS0pk8Ht4rn+kUO1
         XGIA==
X-Forwarded-Encrypted: i=1; AJvYcCUGt7AD4Mn7VY123Ne9iSkjMPYWSZtH72H2GhD8lS4Y8bdQf3RHHjA6Lpkb5hSSZ7ARmQ5V//A=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ5PUM43E6zpQWBQyZxygR5ADoBOocUhZnWr7setWXhoY83usP
	zW0g+sSr5jA6Ebj2wO5u799wY+9Wgm4y7MQf4G722WS+o9Cj2UgL1m4jkHRoSGxCBUdHl0dWj5U
	gZ4qxO9MeRUHsCA88BX95rWqja5K7iH2loR+Eh3wDlF+qFptm8cCM3w==
X-Gm-Gg: ASbGnctfO3vkVjycUn0DWPfm1egHW2k4RiYZYwa+k9IMetfvAxMLzWPAxTlhooH/baV
	u4P96FBELago6Jk9c79gs+7cOrmgzrMliEPbUPf5nFcInCavGuYDSuYtp8HkF2+ALEu5TWPVmiF
	3AKXkdptbz25JVRuVNHNVgqr+DvZSuuh1259zjY8ajewVxepp9OAqvMj/NTzW1AEErYbS3BS4tl
	FtrvpMVCTa8hFEBgvJt11XEXhRY+q47SuxIdcBJ8OY/a0WEEm7kvMb1pECNCIeChrbuGDK5IX+P
	7sUTQQ==
X-Received: by 2002:aa7:8c43:0:b0:72f:f86d:c543 with SMTP id d2e1a72fcca58-72ff86dc5cfmr9769151b3a.9.1738462559688;
        Sat, 01 Feb 2025 18:15:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwN4JpbwAKVJUbVg+/34hGwQp5HKYXpKcr/Eo2PO+gIzPd+r9+tV930pBIODwVO11f1VYIuw==
X-Received: by 2002:aa7:8c43:0:b0:72f:f86d:c543 with SMTP id d2e1a72fcca58-72ff86dc5cfmr9769126b3a.9.1738462559318;
        Sat, 01 Feb 2025 18:15:59 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe69ba47esm5834225b3a.96.2025.02.01.18.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 18:15:58 -0800 (PST)
Message-ID: <ae13e762-bd0d-4525-8919-f6b1bcfc8fee@redhat.com>
Date: Sun, 2 Feb 2025 12:15:51 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 25/43] arm64: Don't expose stolen time for realm guests
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-26-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-26-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ibSxwp4EV2yqpe0SQV3WFvD31JlSEEHVII2m7CKpLYI_1738462560
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> It doesn't make much sense as a realm guest wouldn't want to trust the
> host. It will also need some extra work to ensure that KVM will only
> attempt to write into a shared memory region. So for now just disable
> it.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index eff1a4ec892b..134acb4ee26f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -432,7 +432,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = system_supports_mte();
>   		break;
>   	case KVM_CAP_STEAL_TIME:
> -		r = kvm_arm_pvtime_supported();
> +		if (kvm_is_realm(kvm))
> +			r = 0;
> +		else
> +			r = kvm_arm_pvtime_supported();
>   		break;

kvm_vm_ioctl_check_extension() can be called on the file descriptor of "/dev/kvm".
'kvm' is NULL and kvm_is_realm() returns false, which is the missed corner case.

>   	case KVM_CAP_ARM_EL1_32BIT:
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);

Thanks,
Gavin

