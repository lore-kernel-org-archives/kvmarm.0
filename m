Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F10944F
	for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 00:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758499404; cv=none; b=I4v+f5SXa1rOQvTtC19dcH4k0YqEqx7OfFfYopDE5uuAmfYQeUeT4LB8VBHrV3EXlt11TT7WFwqtPzelEE0u2w0KeEMBAQb3aCIFGsFBsN6XWpXAbBs5JFaREI6LK7pxxKhzXUPv4TTn5KY9Y1w5Hiiyvdv0/NCXeDvX1Rzr3So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758499404; c=relaxed/simple;
	bh=5S1RAPbr3qVsBqfhEwUmh/5GNlslYTzXJY2zUUc9kcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NcfzwEA3BD4zK7R3eXvKjtfdtihtGqMBFzQ9e9oT/i2NfyoPjyRPmbu3SOpIbypaPbqW4YlFi21IgcM5BdVvILmaae9tFugGLRber0aGX0UOVECLiYIsADl/Jij6ZLvXX2QF2gxm8nGxGx+YRIe4LlpyjOB2cWJo8kzJk/1gBgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsdmvbXW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsdmvbXW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758499401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDXuqYgBTFSeTj9HmL3kCs/tVEJAWswdP19jlLEVGcM=;
	b=LsdmvbXWofc6PRa7bwSzMMOOyB/NYk2S1hiedUqC2QcEOfK8P4tcutlO5AkyNtxCr2WhtW
	sHu2LERZXDpQMpQWYy7PBNe1RlXA+1vEhUZlF5WwKvXRSSxCYwd9kExk8e5FSECmkJ1UmZ
	+noeM2MXkrVIK3wiaE5pfFzN9D9JKuA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-6SzFXR_YM2W4jB70oFkS7w-1; Sun, 21 Sep 2025 20:03:19 -0400
X-MC-Unique: 6SzFXR_YM2W4jB70oFkS7w-1
X-Mimecast-MFC-AGG-ID: 6SzFXR_YM2W4jB70oFkS7w_1758499399
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-26985173d8eso60426425ad.1
        for <kvmarm@lists.linux.dev>; Sun, 21 Sep 2025 17:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758499399; x=1759104199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PDXuqYgBTFSeTj9HmL3kCs/tVEJAWswdP19jlLEVGcM=;
        b=X8LA7E01Jw8ktR36VCVbWv6jquyTjrwGtCD02lkhvkX69W7fQqMJyn92MjFjmSrPOd
         PSTvdNW70/ruB2isqEGMwVpZUnPPowEyebPfTA9UkbBBX6DsAqC6LaZUu9QrZ8a+YPbR
         xL1RjpPa4qT080T+4XNMW47J1PGPx8n+iGmPnjYGmOhDpUL9fioHcPgOsh5ltqfyP/hc
         q15OquebSDgLb/0pl8C0Hm9p/gL2e1+JlPUHJJxPrCDKdhv3fV1dTtESSuTff8o3qQM6
         +X/+s2t5R+TsAjZ+uJN3gWTbxKAg8+KJECJs47PzhZR1b+9sK+uDQzIkLJeETPdkox8G
         Z+YA==
X-Forwarded-Encrypted: i=1; AJvYcCVocjCc51Vmh0STk2vEQDA5lgpW3F39UzFg+KFMPz5CE0miBdfFurPKH2w0S0x48+EOpimCLKg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA312RgY86j5X/iXGDjXzDG5l7qLg1T0YI3oyA3j+XSuVyO4a0
	eDSflBAhGEN9o1j8nDcBw2TnN2SKLsrJX0xUNJleLu9MdP6u8S3H5yTt7bgeKpu36K6Pm4K4pRR
	rC4872hQozHGSyO25mdSPDxdnNYt8PiV277GD2i4IQFWhYg56+z/+TLvNig==
X-Gm-Gg: ASbGncsEsG4oebg/My+Tu7zz3Wz/DxMqjvkcxjltf6ejmb2lrF5lpXnyBx5L4HVXbqq
	DXthxn9mWCuFdPZZ3cEcnwC8gf/Co/tZYIXSCnP61YolrqiMz8akbH0xGxh3N9QzBTVfLu3U8FA
	TlNmpV5zzSIGwbk+1hs2q5uZZbnEg34+/wlUmZQWxqlGuIHcajrg6gLuPHp1MZCdOZAAXrNyEL/
	DTaz0SPXqoukXjMLNZtxKp8qIAPf7lS33JATrHQMYtC81OvG2kQVS3/yohGRs4cc0OIxn2R2a9h
	XzwCBurlcdeyZ0/Y3/Qc8Ze/rfRxOviimBSdr1bQkycrPcP28JCVE7JQVA8TEIakstVo/V1eaMs
	+ziOP
X-Received: by 2002:a17:903:2f83:b0:265:bb0:cbc with SMTP id d9443c01a7336-269ba559260mr154624225ad.47.1758499398734;
        Sun, 21 Sep 2025 17:03:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0MfGExlYWTmOjV1WzK5kji6eVj+QSqlsV+EO7ogGlqCirbQxRS/TDHG9aRgu0NS0ideP2VQ==
X-Received: by 2002:a17:903:2f83:b0:265:bb0:cbc with SMTP id d9443c01a7336-269ba559260mr154623995ad.47.1758499398419;
        Sun, 21 Sep 2025 17:03:18 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269803601e3sm114894975ad.144.2025.09.21.17.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Sep 2025 17:03:17 -0700 (PDT)
Message-ID: <a836c085-9bd2-4160-9bf8-81c186f7535c@redhat.com>
Date: Mon, 22 Sep 2025 10:03:07 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 31/43] arm_pmu: Provide a mechanism for disabling the
 physical IRQ
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-32-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-32-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i5JNDJ_ccYw5FBU5FS2dnKIXfrViveMs_NNnFo0UMwE_1758499399
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/21/25 12:55 AM, Steven Price wrote:
> Arm CCA assigns the physical PMU device to the guest running in realm
> world, however the IRQs are routed via the host. To enter a realm guest
> while a PMU IRQ is pending it is necessary to block the physical IRQ to
> prevent an immediate exit. Provide a mechanism in the PMU driver for KVM
> to control the physical IRQ.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v3: Add a dummy function for the !CONFIG_ARM_PMU case.
> ---
>   drivers/perf/arm_pmu.c       | 15 +++++++++++++++
>   include/linux/perf/arm_pmu.h |  5 +++++
>   2 files changed, 20 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

