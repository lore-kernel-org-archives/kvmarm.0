Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154581537D6
	for <kvmarm@lists.linux.dev>; Wed, 21 Aug 2024 02:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724208358; cv=none; b=PGIye59qf8TjwI1O2cjOVH7d7kmn2jet7z+/SP7xONqZAiym4KMCXWpxKpq6QKEQX8ZSXbwLlBJYm2UGeg0hTGNGh8Ni5s7dAhTvJDLBuT6oRq5kUZ5jUOV8eBUT8ktO2CrZyJcbSQyFIKLPIyh4GyE+ncdcsMjEy8cr6wahWjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724208358; c=relaxed/simple;
	bh=1tpxTosyO9oxG72wvXeOM17GOQXVSYOsZcA5bZgcwWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sApfa3KH6bOQDz3lmIR3ndi7O23bL85wJ4kwo936c/tV4KyH/keia1PGgiGJ1FiPlGFj261sYk1tN18VHBTw0z6nkpGzwXXxJE7Fq89dJ4PIaOm6xvljpkJjQb7KMzGYso9a9ItukrVqy+VDHEeABB5RNp1JKB5wlYrWduUbd9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GlkFEL2W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GlkFEL2W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724208356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnCB9XL+js96QTUnqcwBPZip9eUqUJSLO61FBStGX2g=;
	b=GlkFEL2Wv+7nXjt6hHiAWuh3jVnkbyiNUMJFSeknVO4dK+KeFZa1TTX1/+8J4PZRn8uszU
	Jjp9Jo+8xkuT97Hyn8an298G7dwVXToooSPCaxLTKKD9WtKU5dbBUSdTARUOyHcPJ6wxEL
	MLv5gYIrkZ+Ym5NAXuSNW9UxYvjKKlo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-ThXO_lP3MMeMP-cMgyi2Ew-1; Tue, 20 Aug 2024 22:45:53 -0400
X-MC-Unique: ThXO_lP3MMeMP-cMgyi2Ew-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-202088f100aso42340535ad.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Aug 2024 19:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724208353; x=1724813153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QnCB9XL+js96QTUnqcwBPZip9eUqUJSLO61FBStGX2g=;
        b=mW0agX76arbJwDY+fynnMt2acQpnRH5W8HhbesUurqY83/TU/EMd73ZKo7pXAH7vJm
         sAwDqNO/zyyiZh4pDwqN6RvhmnnE2SZKLE9qtY9BLvHbgBJ5awv1UsvNxA4o/BC3nM7B
         deuX9Py3LkEQkE4CGo+5WPWplVtY0U5vlRuLyRe9oI1s47fpbg3x7Xlqe2/In0dN9flh
         yXQkzagVTAVlKEkjpNgEuxxECVXAdyJG60k51yUTPBwSNFPybUZEikDZuXCYQ/qIQvJw
         i+LD7yNJ+aZPgt3TmMq/5xteOqPxlNDJGyFUNgR37BpIOgn5lQqXeKhImAToxpGRxSll
         FsFg==
X-Forwarded-Encrypted: i=1; AJvYcCX6u9sGoFLthIuef4N+CZkK0fQCUMOxmcn15i2gOwx+WYEhpXI8yvTeRjgkqlT8KGmO+TkoDic=@lists.linux.dev
X-Gm-Message-State: AOJu0YzohPfeDta2Isg8MaDM2KbuGsa/Z9Y+h0+bIQuEVyGlMetpWbrM
	+4jMaYOj82fSEyllUBd062S2/AG1GCuoaGwweedVzLwwjR/sY1Bwk4f2bUkQvmltJhmOG96sgiQ
	RSswEMiw/k1XDCGLHmYvBlmVTTRgj0o6qCtGT2ve1gFZOvv6JpD2X5g==
X-Received: by 2002:a17:903:247:b0:1fb:8cab:ccc9 with SMTP id d9443c01a7336-203681e3d0fmr12418355ad.45.1724208352846;
        Tue, 20 Aug 2024 19:45:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLvx8xlkUZjlEq0KcUSI9PEcJu6+23cYjpsS4sKgWdxqVJexOjK6LBAMbnz8YDagYUZLFm8A==
X-Received: by 2002:a17:903:247:b0:1fb:8cab:ccc9 with SMTP id d9443c01a7336-203681e3d0fmr12417995ad.45.1724208352388;
        Tue, 20 Aug 2024 19:45:52 -0700 (PDT)
Received: from [10.72.116.48] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f037903csm84174065ad.125.2024.08.20.19.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 19:45:51 -0700 (PDT)
Message-ID: <f423a404-82bd-43e2-a2a7-c0ea038cbbda@redhat.com>
Date: Wed, 21 Aug 2024 10:45:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] Allow userspace to change ID_AA64PFR1_EL1
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
Cc: Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Catalin Marinas
 <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20240723072004.1470688-1-shahuang@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240723072004.1470688-1-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc, Oliver,

Kindly ping for this series. Welcome your feedbacks. I wonder if this 
implementation satisfy your expectation?

Thanks,
Shaoqin

On 7/23/24 15:19, Shaoqin Huang wrote:
> Hi guys,
> 
> This is another try to allow userspace to change ID_AA64PFR1_EL1, and we want to
> give userspace the ability to control the visible feature set for a VM, which
> could be used by userspace in such a way to transparently migrate VMs.
> 
> The patch series have four part:
> 
> The first patch disable those fields which KVM doesn't know how to handle, so
> KVM will only expose value 0 of those fields to the guest.
> 
> The second patch check the FEAT_SSBS in guest IDREG instead of the cpu
> capability.
> 
> The third patch allow userspace to change ID_AA64PFR1_EL1, it only advertise the
> fields known to KVM and leave others unadvertise.
> 
> The fourth patch adds the kselftest to test if userspace can change the
> ID_AA64PFR1_EL1.
> 
> Besides, I also noticed there is another patch [1] which try to make the
> ID_AA64PFR1_EL1 writable. This patch [1] is try to enable GCS on baremental, and
> add GCS support for the guest. What I understand is if we have GCS support on
> baremental, it will be clear to how to handle them in KVM. And same for other
> fields like NMI, THE, DF2, MTEX.. At that time, they can be writable.
> 
> [1] [PATCH v9 13/39] KVM: arm64: Manage GCS registers for guests
>      https://lore.kernel.org/all/20240625-arm64-gcs-v9-13-0f634469b8f0@kernel.org/
> 
> Changelog:
> ----------
> v4 -> v5:
>    * Only advertise fields which KVM know how to handle to userspace, leave
>      others unadvertised.
>    * Add a new patch to check FEAT_SSBS in IDREG instead of cpu capability.
>    * Tweak the kselftest writable fields.
>    * Improve the commit message.
> 
> v3 -> v4:
>    * Add a new patch to disable some feature which KVM doesn't know how to
>      handle in the register accessor.
>    * Handle all the fields in the register.
>    * Fixes a small cnt issue in kselftest.
> 
> v2 -> v3:
>    * Give more description about why only part of the fields can be writable.
>    * Updated the writable mask by referring the latest ARM spec.
> 
> v1 -> v2:
>    * Tackling the full register instead of single field.
>    * Changing the patch title and commit message.
> 
> RFCv1 -> v1:
>    * Fix the compilation error.
>    * Delete the machine specific information and make the description more
>      generable.
> 
> RFCv1: https://lore.kernel.org/all/20240612023553.127813-1-shahuang@redhat.com/
> v1: https://lore.kernel.org/all/20240617075131.1006173-1-shahuang@redhat.com/
> v2: https://lore.kernel.org/all/20240618063808.1040085-1-shahuang@redhat.com/
> v3: https://lore.kernel.org/all/20240628060454.1936886-2-shahuang@redhat.com/
> v4: https://lore.kernel.org/all/20240718035017.434996-1-shahuang@redhat.com/
> 
> Shaoqin Huang (4):
>    KVM: arm64: Disable fields that KVM doesn't know how to handle in
>      ID_AA64PFR1_EL1
>    KVM: arm64: Use kvm_has_feat() to check if FEAT_SSBS is advertised to
>      the guest
>    KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
>    KVM: selftests: aarch64: Add writable test for ID_AA64PFR1_EL1
> 
>   arch/arm64/kvm/hypercalls.c                   | 12 +++++-----
>   arch/arm64/kvm/sys_regs.c                     | 22 ++++++++++++++++++-
>   .../selftests/kvm/aarch64/set_id_regs.c       | 14 +++++++++---
>   3 files changed, 38 insertions(+), 10 deletions(-)
> 

-- 
Shaoqin

