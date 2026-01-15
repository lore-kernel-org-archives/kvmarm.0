Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621D0221FDE
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 02:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768444431; cv=none; b=uO8HQ5/NhRpedJKUY/ydXSkpgCUMHZvvl7RFjoiaQtzWxGTpMt0zDdI7WsIshPdZBoUVA3LNcoei1i6K0JaNqJvrRQE6BVMBJUXsIIN/82MtRc9CtkMvPU9eqPSshwMI0nW4q75lWVyvyFd43HW/Sk3MAkTevJcYSx4vfJnW9P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768444431; c=relaxed/simple;
	bh=ANgYclRL+9P1OafP0fdimfW5PvWasuxnpbORJ+WCl8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bEprnkt5BHh7lkhWqwnPpPafdLs3jSjZMAXuoqtUkTK7HxOhfcz9BLWJ25/TE0VVlTOV/uZ0Zz5qzs9Eg8e6lvYtgSDZlIjDl8Oq+eoc+vDdmIzs5ZZJu9x2Z9C/uhCRA4QMc7zvPzkRkoQGzAcMSQAuSKqZIQpWRIb2B62N9Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdN3x0LD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdN3x0LD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768444429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=blWj7goxRVPsavzwT8Xk5BJGCREI4FlPjxR03xc0PiQ=;
	b=BdN3x0LDHx0ejbNiio4M93ACZYV7JOWkKWVMJ7jV4yTHVAb/Qhxrl8begcEWtt4TSMfWWP
	c8hqzDxK4LrIKrzgAPLEWZHPgNpuRVsF+on4ojjVv9auHd2Bq86MZOn2U5SjKvNLqA3R+p
	xl1a9k4lgMQRt6i7eWPBMnqu8YsTlIw=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-ROKnln-XO_CW72EhtjzQtA-1; Wed, 14 Jan 2026 21:33:48 -0500
X-MC-Unique: ROKnln-XO_CW72EhtjzQtA-1
X-Mimecast-MFC-AGG-ID: ROKnln-XO_CW72EhtjzQtA_1768444427
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a58c1c74a3so3561625ad.2
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 18:33:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768444427; x=1769049227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=blWj7goxRVPsavzwT8Xk5BJGCREI4FlPjxR03xc0PiQ=;
        b=gMUpPpT2IUnHeP3uoeLGuac0GSxjv1WsSh+FYQ4aoFR1HDCyQtm+J2VnTtRUDrMJue
         zK/n+l5loyvkneQqHHzP24WtA3uZTOrHttrbFsBhaT3nHM7vsUB/OhsTh0ekajcfXUN+
         iGeJgYAWvp1yR12c3TGi78ROSTCtedx12i6AKxStmS88fxP1Mn2Gnx4E+PypEdz+t9Vw
         YFEOucC5bJ6wk1rkJh1eVjrZdlsBcbvKOnoX8TCTni1pPTD5ycu2lJGKN1Bpf3mqT/Bt
         tY1+Pe/EHIcnSqrAPXeXtbtgqHoxp2Rp5YwsJvnzhqOE03vFgZtijlSg39GbpVdiIQfW
         Iusw==
X-Forwarded-Encrypted: i=1; AJvYcCWoTL+wMh6NeMROFLtM/gaaeve7ZC3rZkFMf0YkOOgxFVdLN0h3XauxgUOlbeMNx681cRLfR/Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ3i+d19jFT4M9XE5at6R2BAcxf+sC2X7p5Xii9ns3vZxixpzV
	J8U7GYUxYq2CK5oWEVc9T+3eCrj/lJRXOL3BKwMSoPL5lFDSzhIIaPGd2noI7oaV7AwNTkTDW3G
	ywVgBD8JBKPPLMU5UacGiGsa2Jt1SawaL6V+AmhZwJ2H7D9PL7P8ohBWw8g==
X-Gm-Gg: AY/fxX49bxWa5eCid7r5GbFdyflIpyNPHmiAmcpk6jwV16HNsN0sXRlQZ2qhMEvfvZ7
	QjIWw403mgPmi7zhib9ZuW6GO3HPoK9j9zTOUXTbBG9sKuMyxa3mLtTM74U8TBhoU1+0GzkFGon
	WrmjQ7CCSr/Kfpxc9dQQat66fTYANahQTtiRhRs/IdQ6RC23ZE4KE/XDNWBBrO9uwh3kH5Uws11
	8SjHPyZgqhPNAY8lTd8VRsFnA5ufad1i6JjVxPtTwM68hT0pUtJJYHh5wvXGX3t8lhjWWQSwy30
	q2jjFrdFWUOak5Rx/Y92CTwZMV8MghUecxtlStFgJDR9MZx9hqylz1jdUGMU0kv0Ys9KtsTpuBj
	9SsYbW6+0mbw=
X-Received: by 2002:a17:902:ef09:b0:2a0:e223:f6e6 with SMTP id d9443c01a7336-2a599e3f37emr47430645ad.46.1768444427025;
        Wed, 14 Jan 2026 18:33:47 -0800 (PST)
X-Received: by 2002:a17:902:ef09:b0:2a0:e223:f6e6 with SMTP id d9443c01a7336-2a599e3f37emr47430395ad.46.1768444426637;
        Wed, 14 Jan 2026 18:33:46 -0800 (PST)
Received: from [10.72.112.168] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2fe3sm240569515ad.59.2026.01.14.18.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 18:33:46 -0800 (PST)
Message-ID: <d0b95ff6-6b69-4ee3-a494-a3dd278d1021@redhat.com>
Date: Thu, 15 Jan 2026 10:33:33 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/47] KVM: arm64: Preserve host MPAM configuration
 when changing traps
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-5-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-5-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6-iaxOFks5iUp8vsJgSfePUOmqamuO9_JgK8V3kB968_1768444427
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:58 AM, Ben Horgan wrote:
> When kvm enables or disables MPAM traps to EL2 it clears all other bits in
> MPAM2_EL2.  Notably, it clears the partition ids (PARTIDs) and performance
> monitoring groups (PMGs). Avoid changing these bits in anticipation of
> adding support for MPAM in the kernel. Otherwise, on a VHE system with the
> host running at EL2 where MPAM2_EL2 and MPAM1_EL1 access the same register,
> any attempt to use MPAM to monitor or partition resources for kernel space
> would be foiled by running a KVM guest. Additionally, MPAM2_EL2.EnMPAMSM is
> always set to 0 which causes MPAMSM_EL1 to always trap. Keep EnMPAMSM set
> to 1 when not in a guest so that the kernel can use MPAMSM_EL1.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

