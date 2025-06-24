Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B1A27C144
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 09:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750756822; cv=none; b=VpoxG/P/biOcoIKdcwAOV1UZF7+lSfwALhfyX3KqOn2R71EYUsDM2yLE+yYVxBc4/OGyQvD/OdxDYcLlqlSAo+I7nrUqhu7QPGUnxt9RSM6XB6VHkwmh/28NE2bQcQahwOt2pkpLZRNoDm9qjWl38hRe2rHRx3kNCg0xloADt4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750756822; c=relaxed/simple;
	bh=r7b9+YdEXsnWpLlEGtT7fhWq6i3byVNh3eeoZJlx1pg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gzfY/kMy/NV5ksusWbXwI2RyqimrSeOczPBVxV80V9aYS81pz0n9bxMDkCr9ti8ohk6mDvebU4QXNFzZCbDvw2LoY1C9Fqq4FAaaOwQHQDN3IEMF3A9G2C/BUT2+cAorJevEDV6XTk1V2LgyNR0Qy+fUVbNNG97Xl4XhkNJ7k60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jfgs5MOT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jfgs5MOT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750756819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0jdlbyzwhOvR0TOSckRhTiUQnf05D9iDWTr7qMjHW2U=;
	b=Jfgs5MOTZ2qLZ2xJ4wW7x5+GCo19oHWhAR5vZvjScxmk9lcApJBIxk1LId0ReMl56LqJJE
	Y7S6YUszAn5NT/1v8d0AJ02zb81GldxuvbeQSa2TnjSFZc55ux6+nj5mFM1FlHVmsIE8m4
	qtKEbEL644/VIVzS1SPHCCcdusc4AJ8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-2LSE0GrmOzKfCHVAc3kNLw-1; Tue, 24 Jun 2025 05:20:14 -0400
X-MC-Unique: 2LSE0GrmOzKfCHVAc3kNLw-1
X-Mimecast-MFC-AGG-ID: 2LSE0GrmOzKfCHVAc3kNLw_1750756814
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a6df0c67a6so1683996f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 02:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750756813; x=1751361613;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0jdlbyzwhOvR0TOSckRhTiUQnf05D9iDWTr7qMjHW2U=;
        b=UtnGt7YSnBhKCi5vfot/kLJ5KaKViAIofUv+jBGiGESM/3wrubuPYRhxOZw8QqHCpi
         puWo6TxZ+uGi4HpyYznCzUG/Dw52LTQECiM2YtcBsEUUbJ+ZoW3VjO/7P0V407ftGVQJ
         cv+d/VO5QD3ZWevECOwJiB20RsqPXbuyY77mI0OHWmYY4Ljds3MbQiijeOoCkJwcaPKC
         WpQ6UcOaerNpQXnHipu3m1eQG76T5sTpytKbymS9PUEOFNgId05YWxQ2ERVIpXfR8HoF
         EO1xHHmHJPawfZrXBqzEZTbSh4dZ1H49EFvixFJcnzREiXvISo6X2DXPYivmpyzNVJFE
         GjIw==
X-Forwarded-Encrypted: i=1; AJvYcCUOY9WlVSGn+vNpPo7pnky+HB7tEsMR+YO0FVEM/7fo+id0IKzZbTLylXqz+pG4vIvzHnnuXQQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzADLy6jyOPiPS/Jf7rY5USNAQ3dd0l/w3x4ud5CrtfQqdPFxSv
	us+h0rehXDyh7FyCPsroIE0SsZouV/cd/d4AlhCkLyocDGFm7om4xCdVIvruRdsGxubCdRaGmfS
	Fx4UCKTJJj0YCfsJzqoNZ33A3QBu3GLPyr0UjbrUqk9sUDcKbxvJerYdMZQ==
X-Gm-Gg: ASbGnculSiaMifdTbJAGx080qfDHDxo2rJ17Px03zFtoerBL3dlFZtTsfcVeThvTWNT
	exAxpg9Df26Yg2qvZt27H2LZaaBrugCR6JzCSE5i6zEP9B6NMCz1KZaDsGOhvvB/jbMJkMHWR1c
	W0xYjj7EJEUNmicZfZFZLrS3ObddT5xl1zTBAb+A+Os8OzqG+OMMvL1CGca0IzBcaeiXYukMFWG
	SMuBOZteZ6KrGqYxaii/wVEtBem0c7glX25lpvNjyHUNAvoIc/awrbz8oHa+vLAYPKVpR9RdR1P
	7zr49ghNjOP7BubZ4BYAfHnG+DgGuiTygEwGSW4c3vQa3Awkso/CgOwjxmmkdq8v
X-Received: by 2002:a5d:5846:0:b0:3a4:e6e6:a026 with SMTP id ffacd0b85a97d-3a6d131708fmr13847261f8f.28.1750756813596;
        Tue, 24 Jun 2025 02:20:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG90ssd/Q7UJyYLoQ/soeF+R1DyWoiSsSC9z7zTe1BY8pnooxTi/4aCxQxIMA8YQroBd4jqAA==
X-Received: by 2002:a5d:5846:0:b0:3a4:e6e6:a026 with SMTP id ffacd0b85a97d-3a6d131708fmr13847222f8f.28.1750756813145;
        Tue, 24 Jun 2025 02:20:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e810b140sm1417562f8f.80.2025.06.24.02.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 02:20:12 -0700 (PDT)
Message-ID: <55346a73-d20e-494a-a287-6874216457c8@redhat.com>
Date: Tue, 24 Jun 2025 11:20:10 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KVM: arm64: vgic-its: Return -ENXIO to invalid
 KVM_DEV_ARM_VGIC_GRP_CTRL attrs
To: David Woodhouse <dwmw2@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Jing Zhang <jingzhangos@google.com>,
 Kunkun Jiang <jiangkunkun@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Keisuke Nishimura <keisuke.nishimura@inria.fr>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <bbbddd56135399baf699bc46ffb6e7f08d9f8c9f.camel@infradead.org>
 <5e22442e-ddf8-4f5d-b7e4-5e2c9bf783b0@redhat.com>
 <0f86df0c2866114898da1e9f4274e23b3d1c38b4.camel@infradead.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <0f86df0c2866114898da1e9f4274e23b3d1c38b4.camel@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rN1iJYAXvhIe507KWLlcoP3vfusJYeGBdJXwV-jqo-Y_1750756814
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi David,

On 6/24/25 11:01 AM, David Woodhouse wrote:
> On Tue, 2025-06-24 at 09:25 +0200, Eric Auger wrote:
>> Hi David,
>>
>> On 6/23/25 3:22 PM, David Woodhouse wrote:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> A preliminary version of a hack to invoke unmap_all_vpes() from an ioctl
>>> didn't work very well. We eventually determined this was because we were
>>> invoking it on the wrong file descriptor, but not getting an error.
>>>
>>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>>
>> In the corresponding doc (virt/kvm/devices/arm-vgic-its.rst)
>> it is said about possible returned values:
>>      -ENXIO  ITS not properly configured as required prior to setting
>>              this attribute
>> which does not exactly match your situation. Shouldn't we also update
>> the doc or change the returned value?
> 
> Hi Eric, thanks for looking at this.
> 
> I think this is OK because the -ENXIO return is covered by the high-
> level description of KVM_[GS]ET_DEVICE_ATTR in virt/kvm/api.rst:
> 
> Errors:
> 
>   =====   =============================================================
>   ENXIO   The group or attribute is unknown/unsupported for this device
>           or hardware support is missing.
> 

Ah OK I missed that. Anyway that's not a big deal I think.

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric


