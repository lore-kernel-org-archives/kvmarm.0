Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304DC35FF6C
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 01:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558976; cv=none; b=LSESpNN0ecueBU/n+IGkr7H3kxYmFABIBbRkO+AMLUNkEC23wfty8Q2oF9t/ZI6MBu0ZVDmYCicl8HGmQi1wkr99IUPkUMSz6wveXCYK6SrxkvUJyobJcmJgUmXx73zhzj4gR9tj/DEItrjXnmgjRP/u4kGji5xvmZjpPzeXBGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558976; c=relaxed/simple;
	bh=6l5SM3odIjYsratn5+hyANF/3A4SjCbou9O2TWWTn/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VAwAIze/pvyLTXTxnCCvMJEui4DG6MFGm7LDcNqp793USGHHxklAkgic3tLMhhxZchSEK/FRn9rWqUy0oZtk+YP7DVOgfg3djAluwSQH06c3fT1v68TwgQSALSHZ+yn4MgMCzTEQKIwZ34lqLeFm69ZGRJH2wGl3Qs10AyrGRrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gZ+/TSO2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gZ+/TSO2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790558974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gPTRGSRmIEuAgsqdZVsCgUbEv8K5pyxuaYYIDQSv9zo=;
	b=gZ+/TSO2s1s2Pu7kdVIYmVgExqkn0OxgXY3hBfV5xuR8t2A5qCYiuUcH1ZclvKtSptr4fW
	kt3O2GUluFXPUspF/tHHuqp4Vo2h2MMnd3MZee4nyO3YAgUVVGE6zpMRR8lbaCglCRZ53l
	QCt3/7DAqe9yJ5X3t0QZmkjEmNnxBUU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-h3__15D4PIquYQgzAsbSUw-1; Sun, 27 Sep 2026 21:29:33 -0400
X-MC-Unique: h3__15D4PIquYQgzAsbSUw-1
X-Mimecast-MFC-AGG-ID: h3__15D4PIquYQgzAsbSUw_1790558972
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39d865b11b4so3047837a91.3
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 18:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790558972; x=1791163772;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gPTRGSRmIEuAgsqdZVsCgUbEv8K5pyxuaYYIDQSv9zo=;
        b=ghKr5OV2hJHj8yBTfJk+fJxX+gS+PkWOg/LCg+R2H0Jh32BDeaixLXKwhGFSi4i+T4
         M/B9uFzqCgqvVpM+y7fhwPx7RQRHrd/X8WHXILFB7tAqI0oEaIL6sPZUXZSY05Y/IYr5
         bwwdsOj6NhwxccFVThPKYNYLCOCox5oOnr6kpRnfkOo+eupa+1RDuun6nRTIhzAhPIpk
         iFfr+DQOZ+qDGTS8wQbrBnwlwYzgT+zmLkxlj0RrxaFpZSyi/n64QFLxE3rgdB6a1cLm
         /bSzrh5zrpa0QXw3gIbuT97SH/lKu0AKgko+q4LLC/Jf0e0zsM1v+Nj/BKGACn7flBIY
         FlcA==
X-Forwarded-Encrypted: i=1; AKwUvBzgVIe2fjiFWJgmJUIUU7piJo/k92FBpwTT7Aswgz2uhNl0yNQwynE3+ZK8KcTSH6rF99VaDOw=@lists.linux.dev
X-Gm-Message-State: AFq9FYIPNsvutjaLh4pThy3UlfkL/4/j4WL62dFyLw0XjpHYjL7CrzBp
	4pkVRPb0I63dm+ZpIskmA4Fd2ryAbekTVwYBmBnLwzFNKtptQc2eos5k2Ox91Ut3Guv6XSth6ek
	d+YBj0m19SQOalI0k+1MkQPFJVdmXLgy3i1/4bIqswJZLRG/kOmxlD0H6ow==
X-Gm-Gg: AYBFou1jtYmQ0JzZWxxSq+24PsE1zhTEulE4pvaVYrDFKUYTK5uiyEUidDNf4fSLw2U
	hwpkda1x476XkPCd+Mv/vyP/ESMJW38D8Jv2dcamP+LS4U5eYaIk4754Woa9VzotJgs53SLjEX2
	qZe690J7nnIcpCqu2gX1lTBJyXGuN5nqCxfeJ/Vqma6eefys3bvtl60XMn6BHmklK5bWKBFADm+
	NQEtOd+wDyiLOLzQ2riWTDARpg82kl1KA3SWsrO5WIVA1hpkMTjVRxKuZk9KeMZspr2Y02Uy2z8
	yf8KEq0MHQB1qgBkJqaNGLU2aRNu8ggKJnQg7NxrP3D6cc9X6Ct/+KwlIKHNFqU8cX5U6UPAYMa
	Q4iorkezOwkkvWUovWwoYk7PDbmtubykdf7PVPI5Gwg==
X-Received: by 2002:a17:90b:2ec4:b0:3a2:b59f:639b with SMTP id 98e67ed59e1d1-3a2b59f6deamr1580731a91.54.1790558971753;
        Sun, 27 Sep 2026 18:29:31 -0700 (PDT)
X-Received: by 2002:a17:90b:2ec4:b0:3a2:b59f:639b with SMTP id 98e67ed59e1d1-3a2b59f6deamr1580702a91.54.1790558971111;
        Sun, 27 Sep 2026 18:29:31 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df913ddc55sm32916295ad.23.2026.09.27.18.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 18:29:30 -0700 (PDT)
Message-ID: <d1ad37f1-f87b-4812-a202-8b5e949fa1a8@redhat.com>
Date: Mon, 28 Sep 2026 11:29:23 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 19/20] KVM: arm64: CCA: Expose SVE VL register before
 VCPU finalization
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-20-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-20-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4tG9g5jZvl7QTAKXeuOclsn1o54X2tMFTW2hjPYhIKA_1790558972
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Userspace must configure the SVE vector length before the Realm is created
> (as it is part of the parameter for Realm creation), but the Realm VCPUs
> cannot be finalized until after the Realm Descriptor has been created.
> 
> KVM_GET_REG_LIST currently rejects the unfinalized VCPUs, which prevents
> the userspace from discovering and configuring the VLs for  the Realm.
> 
> Allow KVM_GET_REG_LIST for unfinalized RECs and make the SVE register
> enumeration handle the unfinalized case explicitly. i.e., only expose
> KVM_REG_ARM64_SVE_VLS before SVE is finalized.
> 
> One adverse side effect of this change is that a KVM_GET_REG_LIST call that
> only probes for the array size will now succeed even if SVE is not
> finalized, but that seems harmless since the following KVM_GET_REG_LIST
> with the full array will fail.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v17:
>   - Rewrite the commit description to clearly describe the purpose
> ---
>   arch/arm64/kvm/arm.c   | 15 ++++++++++++++-
>   arch/arm64/kvm/guest.c | 10 +++++-----
>   2 files changed, 19 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

