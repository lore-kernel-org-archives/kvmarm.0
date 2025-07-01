Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E711F0E4B
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 06:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751352104; cv=none; b=JsSOQHQ4OMhgBBUXcVZWAIM5f7yFQSHHFX4rUYfWeyPnatlUe3D8dJj6YBaX0BEnZwAnbrAT6+8XijRHaQf2bJ6o3PwKC6euP3WkbkoS3bPX4ijmdkXVvqjJ8y0msF1ivtX2BcPXLXTHV/eyO/ntX//jObBcpP6BWotw+IARV4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751352104; c=relaxed/simple;
	bh=kGpgLRB+mp02Cl1q11HP6F3dDAhpnnUXWI58xYxcPZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VvjLFdrQuZuXz57q0jniZTQNYIrELibUiHCGlEfGE14GWxpeSJgDYGJULoCn8vHRB4iOz/VXwoRx2XbA1GWZRsDUszcafgp5GBx3WDqx6hjVQDPb/G2/RiuvwvgKIXKcFc0lSXfKPYr1ebOJSTifWtF6+09cuY9C/v++s4bkg6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hxOoqMLc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hxOoqMLc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751352102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQYfrw2czgfVr+YerX7siCfmJocpn7Zqz18UhcgAHpo=;
	b=hxOoqMLcIVT1HQARS0yN6JLq1PINIlxGxo8olS8g7ndhsiMbe7CuboDjpU8ivRHZSP+a66
	3CnCH2l0FdvsZUt33BwI35th4KEBvKAennJQFuSeCnlKj4wZAlD+H6BiGjULNqJqiBe6UB
	hH4wKyxWfvuB5sb9IqN8wApCfLUG634=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-TB6wxVDoPqGfSfSKQaBYCw-1; Tue, 01 Jul 2025 02:41:41 -0400
X-MC-Unique: TB6wxVDoPqGfSfSKQaBYCw-1
X-Mimecast-MFC-AGG-ID: TB6wxVDoPqGfSfSKQaBYCw_1751352100
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-235089528a0so50990135ad.1
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 23:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751352100; x=1751956900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQYfrw2czgfVr+YerX7siCfmJocpn7Zqz18UhcgAHpo=;
        b=dhho3kAmHyrJhYRFmDNNsajnWHGwRBvyPUZ9huwhHREcA8md6i9W6UCOwbrGbUgE3P
         JhzQy0r8+TuGow5odbQdPnMnKAi+rn2U32pVYBSSrq5MEEFodcstY2cLoZgmCVB1rO+r
         vh5KrV+N5Xlm7MlMqOqRu3/IqPxVWaZ9j61ryhHGop1/70jjwxFM70CNA4IWlcD7EnTe
         R26pC/cqZB5ky2trKdRHoP6zUHs9utxuamf4vBmfFTKqmbsyx1j/3uUUreDjcpsuUT6l
         ko6mL4AS+efssEkNSOSULX7zHWRESSP98jGWT9pEwngXxChPliwsbCL5pSsMR3XQqSrh
         Qwqg==
X-Forwarded-Encrypted: i=1; AJvYcCWqoxFUMFqGLAKPi7yv17FmwkpA5vWsO/igLHfp3TPy7x6pSGbhmiO4u08FjI2VpWLEt2HT6v0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAb+mJbAwZO+ZmsOuU13CykDWPhuEs+yyGJorkfs9mKB7OnTiD
	yFIfZtCufW/rqouiOzRxfM8+Ic3B6lmvPeGz8Q+4cu55eFAwmfmZVEnf4BeXukRpxGueFhnB1U2
	ipH4T1ZqsPqSwd3Xw3XE1TJkTsZAC7xmY2tUib7ljF342Fz4JsOUzHh3Big==
X-Gm-Gg: ASbGncuO15R1XsStwrHeypW4m+HfpmJYWSOp0ucyfFmRj6ahS2zwbcKTghBeD1EQj+u
	L4F9juWb6yWoGOG+jmZbmQCTAyqJcbBW9A2rBpwhYuiL730HY19q+gZvOK/WO3430WFQwZejs2K
	+YhyMZY3nQENEjFt64QeLL+f7fcdtpTD5+KLZeKzLK2ZK7Ay7aqHHyewHDvlio2hmxbZ03YYpF9
	0BqEYu6Mn8NBuqhd6/vfDGt5hTAwZ7E4pewGhju6f/dMEiPLfDD7HJ4dNfy5OD/D5vHpm2Kbk8E
	mnfpYDusIwcdQ3Oha/4ErbTotxM3xv7F8xmMwZlZOUACWYvhQKKAhs4x5GxQ5Q==
X-Received: by 2002:a17:903:19c6:b0:237:e3bc:7691 with SMTP id d9443c01a7336-23b354ccb5fmr48817335ad.13.1751352100094;
        Mon, 30 Jun 2025 23:41:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzRrkg75jFwfmHGPour3us0gMVNM40EjoGoGZlYrZyd2YrJY+nKplS2aGywWS1wb1p46z/mQ==
X-Received: by 2002:a17:903:19c6:b0:237:e3bc:7691 with SMTP id d9443c01a7336-23b354ccb5fmr48816855ad.13.1751352099716;
        Mon, 30 Jun 2025 23:41:39 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2e1b3esm96630595ad.35.2025.06.30.23.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 23:41:39 -0700 (PDT)
Message-ID: <5930a931-b809-497d-8eb2-076570738ef7@redhat.com>
Date: Tue, 1 Jul 2025 16:41:30 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/43] arm64: RME: Support for the VGIC in realms
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
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-14-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-14-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dLu-njbfMEhO1FZkAWZxxeJhX_DxTg_kfu3coiuVxmA_1751352100
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> The RMM provides emulation of a VGIC to the realm guest but delegates
> much of the handling to the host. Implement support in KVM for
> saving/restoring state to/from the REC structure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v8:
>   * Propagate gicv3_hcr to from the RMM.
> Changes from v5:
>   * Handle RMM providing fewer GIC LRs than the hardware supports.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  1 +
>   arch/arm64/kvm/arm.c             | 16 +++++++++--
>   arch/arm64/kvm/rme.c             |  5 ++++
>   arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
>   arch/arm64/kvm/vgic/vgic-v3.c    |  6 +++-
>   arch/arm64/kvm/vgic/vgic.c       | 49 ++++++++++++++++++++++++++++++--
>   6 files changed, 72 insertions(+), 7 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

