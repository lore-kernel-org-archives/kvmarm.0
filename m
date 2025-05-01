Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B3D2AF10
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 03:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068482; cv=none; b=ujGAxzpQCVrAiePqYP886l0JBlwuD2vUFwFkxvmKI3LCsSay3CAAonZwd6X+DKdF0Ywd0xusNbyfhqJP9996/BaqhUecdsvLFo0Kzal7ZCLXVaH0qjXvYliegRGFKgjvi0u30rDqu22QbZeyIpNKURTJAvPsVFdkCJZKaqBof7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068482; c=relaxed/simple;
	bh=/ptZbSFI9sOT2FDVpzMMrJrZJtXi7a7ktLAYSxgGEAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XLZCRFBELAhPwQhK8FHXQwSXTfAAH12KDXkjwKSsmBu0EV8TYD9fIBekbgZ9dvOp8dwatXkvzidhU9uDnM6egHP0f5bpNAim2JIHrao+o5eAYpPK7u/74jZxwpeT6KTtFdzEJ+Ni6XgWM3RI92Q9qvIY8Ca+A9ey6qJ/Ll8cZ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBlTkvzd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBlTkvzd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=66PeGHTOpdnar+Qa0JWdL51yAJjG/0kQaEukyiMWp3k=;
	b=eBlTkvzd4fSvfJwoJjEQEP9T2PzYlrwC+OBQhRsKRVYoX9zbWOZJgzCaqNTuf4uSv/ZI8r
	yNOeX56lcYmqjAVZFPECdnjWvfkF9DJl368+j8S7ZkUhzrOKJ45m5ZPyE8pQ06MbkvlB6k
	qNoUJqjQ9Mxufvv2SwVji/+R9WeksoY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-rnu24w6UPe6zKVAQbfKV9w-1; Wed, 30 Apr 2025 23:01:16 -0400
X-MC-Unique: rnu24w6UPe6zKVAQbfKV9w-1
X-Mimecast-MFC-AGG-ID: rnu24w6UPe6zKVAQbfKV9w_1746068475
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b0b2de67d6aso561602a12.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 20:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068475; x=1746673275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=66PeGHTOpdnar+Qa0JWdL51yAJjG/0kQaEukyiMWp3k=;
        b=CHBMV1K01vgGBkXNJxm6A0Omx5JPojLxh38tlulfVPCQoNkx1NQ+U1M9KvJYVWXs3C
         P5TW6UgYZNlWLvh/r7MI04wgPYpRqeK7lV7rpzqmsAf5syScIAUCx3m/IEPh1VpDvM4a
         1ky1adIr9M87wKZ2k+nuzqOoE4F7BqMtpXXXQmZxeQK4DtUIClF4xlNY7YvDQwJ8un94
         YSwZ0/hovxv7MJ4vp38ROg+jIoz5NmJK45SlG2fiZSusxfpRMc1T32M88CY1mpnf7rp9
         lXPSRhP1rWbAgxgoJlpseZzffFxWvYMZKht9YrTziNh2SOAX2jd4SwZu//F7lZ+ayXER
         xNDw==
X-Forwarded-Encrypted: i=1; AJvYcCWs+QVMHUizPwLQeGRnF+A+M/JYDarkuD9wRcHMakgulSwe3YJKjzBsVEMLtJ1IbfDc+TI/Lhs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxB+LMaXCXjqIYt9wVj3IJPTeeeCbOQy93PcJn5Auw/ly3MF+Sm
	Lo1CVXgnrA2+dfpodnhNaUB+WHZc1JUeUu14azO6EIZXSI4QxvFh2n5mOUOm+PKGuNeTmWg3Ido
	vBQW0xqo9vQjSZ/KMsnD1mhW0vM2CrpAfTi78HSyAXlE/jMRclqDBeQ==
X-Gm-Gg: ASbGncvKLbAUUc3WGCKxYQflHcq1wLM5+0oM8DUfzEKbqfYBugfbyPchVGhMDCnCGBA
	6cWCYjp+sAq5aTfwq1/83q4AA3Ikv1IH1Rav3/Wh/U3xLykXFGAzyefXwxSZVziGm5Qqzxf37Zq
	U00AsW8uffKJWEXsHqMt/dJkPAMRQ/W+tNP5d/0GfsGw/kR5Am4tcphADfdcaGhq6A0GRdP8Iqv
	918urCGgK1XnDw8MNi1QJKckCwTyEjKfLAyQo8/MtnKXaG27MC2+9i3cGB2qePkKaTrpIO7HWFv
	qNcwzWrz4B4q
X-Received: by 2002:a17:903:3c4c:b0:224:256e:5e3f with SMTP id d9443c01a7336-22e040c6e79mr22293035ad.25.1746068475347;
        Wed, 30 Apr 2025 20:01:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZAaGsqWilNG9nKIQwO6WjMhMxoDtCPFtqO+KYQXEgWxu5s0tu5Q6Ot3OxM8Xca9EYb2dyqQ==
X-Received: by 2002:a17:903:3c4c:b0:224:256e:5e3f with SMTP id d9443c01a7336-22e040c6e79mr22292615ad.25.1746068475064;
        Wed, 30 Apr 2025 20:01:15 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0a243e82sm766515ad.2.2025.04.30.20.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:01:14 -0700 (PDT)
Message-ID: <fd1936c7-cc82-4dd9-9bc0-2b25a3bbbb91@redhat.com>
Date: Thu, 1 May 2025 13:01:06 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 33/43] arm64: RME: Hide KVM_CAP_READONLY_MEM for realm
 guests
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-34-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-34-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mM9PSInwLq_liB_QM4gKW63dDIxTWoE6qtJUW0zmi6I_1746068475
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> For protected memory read only isn't supported by the RMM. While it may
> be possible to support read only for unprotected memory, this isn't
> supported at the present time.
> 
> Note that this does mean that ROM (or flash) data cannot be emulated
> correctly by the VMM as the stage 2 mappings are either always
> read/write or are trapped as MMIO (so don't support operations where the
> syndrome information doesn't allow emulation, e.g. load/store pair).
> 
> This restriction can be lifted in the future by allowing the stage 2
> mappings to be made read only.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Updated commit message to spell out the impact on ROM/flash
>     emulation.
> ---
>   arch/arm64/kvm/arm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

