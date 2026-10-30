Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793337133;
	b=jXTuV3Un09cqGi2TUACD9E3mssZvoj1K1lGNw6g9fx6VHusnSmUvHjr/8Jj1alxMq1xb
	 PaoUBg2b4QxmN4Yf5c8uPIbSmatEvVBoIG1LzVLE19Ib/L4Ps/SujQoApL8wuKD2m2lM4
	 S4Khulub+mNxOQs4tbzapKfZzz9/aJXir6bD9oe/Q1mP75tuO6m2y2Zbfy4a6ALfYSElk
	 HRpmAEPU5nIci4u4hJ2rWpgHRUjd/vY9M5rK1jFk4B4wbM099o1oDQl1Boq/IedBSWRPQ
	 wQGSTIxRQHySRHv+qivdPpWirP3Geh9E+ec0JadlnwDImBbN7DHNNpKp2yS9ktNhpAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793337133;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:From:In-Reply-To:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Language:
	 Content-Type:Content-Transfer-Encoding;
	bh=yZJnTzcgAEufapruv+sU1p9fK/mqyPTcRB7MRChBfE8=;
	b=0rJc25Lizr1LIx+M6lZMK7hHasFhOX/v3sOcXW10GFLdBrVBYlldvDmN1LvGoOpWSS6c
	 elh4n7NhDjW3zUmcvqV0DT3XdSkAACFfHklFgORHScJT3NtNY5A5jIvORMJBKFs2Kd9vM
	 YnePpgPMarcTkHJBjguuBUn3Pc3M5YCj+SI+ZDPWo3QiL2GSadHZgA6uqWtvnQ8DnkNN7
	 wIO2tN5hNWLU3457Szrw5taJx/Fofv26O1hZae1drXgYT13HNCzTZzcYPmBcVQPvgxVpr
	 i0zm51qnBvbKwNg6aSpbGMQQPeFf/mUA2RtNItBq55yHyNNk4XCoZOr67N99ya9C5Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EYENxIrv;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91BD606A31A
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 05:12:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E91BD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EYENxIrv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793337132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yZJnTzcgAEufapruv+sU1p9fK/mqyPTcRB7MRChBfE8=;
	b=EYENxIrvUI4S6hyv9as/EZzS/jKxKeFUii2m8veYRZLBAdKf3lnuldZtE/l7QU0t9MW8or
	1JYQgKs/bOcRtI9vMCQJRjiA31zFkHgHQd+u23guqhxaSEbElTs28zuuoywLOHSOm3hiAG
	Mu2OwQKcCsft6Q9om0ChJUYaXHNXhew=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-ZcHz5pZcNzqBdnf1LrFrLw-1; Fri, 30 Oct 2026 01:12:09 -0400
X-MC-Unique: ZcHz5pZcNzqBdnf1LrFrLw-1
X-Mimecast-MFC-AGG-ID: ZcHz5pZcNzqBdnf1LrFrLw_1793337129
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3adf71ee6a5so482592a91.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 22:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793337129; x=1793941929;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yZJnTzcgAEufapruv+sU1p9fK/mqyPTcRB7MRChBfE8=;
        b=z4V8Xr9WraL2G4HbRb9tNI1fSbpQCpeumJug9c1T03Sic1ZIHml6dTlrX11/nh91xd
         d/7YtMmXHthaQ06W6eWdlaT3rgrFSyZrFR+IOJiRHlIU8BVEFNs7JJyigr/Q3GSFRfza
         qIDMalx+ZLEcil6SSE6WNTNAtxKqhBEo+lgMtCC1UsRZGFICHWJEaJCndFvKiy81j6jV
         EHXyYPcfNc92qIgAFAMZ24lWNmkOeYDxEBdedRM9oLlAPH7CMZMvspP+PiB0WFPvxYjG
         Rt+UBAp1JxeNKhPiHog0hdI0of1G/SI1K6FzLe1vd+5QojEcgszS7cU3PJGgd8fhTvod
         fNLA==
X-Forwarded-Encrypted: i=1; AKwUvBwL6NaSjqdOpjC1PO1iGUcwWJrs4C62/ipshZGdcL0W12s1MC+vtDwXRNqBd8AW5bpJFbbJr0w=@lists.linux.dev
X-Gm-Message-State: AFq9FYIKT/5yf0mD5NKluHb5waFlH/EgcItdBI2S5aCTc0pUbu+VOkYy
	CULu0HaqWB0beyXP5ZyTbVAoVO/42fVDbU6VQonq+ft68VTx/VQw1AY5bw51HVigPxOTDop63vj
	ZkF6LwjS6gZULOR4wTglcy8R67ZsrJBzIH/5ZfYFypwi6Tae3OT6vHc3MYA==
X-Gm-Gg: AYBFou307+6f3e0eHF/NnLttPfaupj69fMbr2tMW5lsSN+GXLWcWJkOy4OMLv/34vUR
	uFXY6SRamDWKX1BRLDtUjRREkqFWZJZ4qnTNQ6B364nDBjRiIf0JebzpCs7ph9wL9+qdKgo3W7X
	GkFbNA5lF7DQYyFfz6QPi86tcfpEPYA5syJrVtVHKCuSc6mWUxA5asGnGyxjNLkjt5HvGhs+ydd
	vSom30WN0EKaTN7l9D2yNEuzZEzbebKuIw0SV9+EM8g9MGZbWCrqPtBsAxBfcp6l0s67ojsHPoy
	lK26Mk+6NTYXfOnaoRsqCxp5V/xRmS+zZ4pLEs8lPVWy8yzFls53l9lVYZrN/47WGlzH9WjvXEz
	DJoKcP50Q5WWyrPgKZ64zqhF6KklFuvHAf/GddlM4/4JvJVa6AsrdltlkmENpt5G34tKoqJ3N1C
	KL9Mq1Bv+q0Qk4ntw=
X-Received: by 2002:a17:90b:2f87:b0:3a8:9b79:e6ea with SMTP id 98e67ed59e1d1-3ae897f6d60mr921878a91.59.1793337128731;
        Thu, 29 Oct 2026 22:12:08 -0700 (PDT)
X-Received: by 2002:a17:90b:2f87:b0:3a8:9b79:e6ea with SMTP id 98e67ed59e1d1-3ae897f6d60mr921866a91.59.1793337128336;
        Thu, 29 Oct 2026 22:12:08 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae84542a13sm2349712a91.5.2026.10.29.22.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 22:12:07 -0700 (PDT)
Message-ID: <d9eed4b5-e9e4-4699-ab5d-197141a995d3@redhat.com>
Date: Fri, 30 Oct 2026 15:12:01 +1000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: arm64: Remove stale remark on canonical IPA
 alignment
To: Wei-Lin Chang <weilin.chang@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Leonardo Bras <leo.bras@arm.com>
References: <20261029175238.3214788-1-weilin.chang@arm.com>
 <20261029175238.3214788-3-weilin.chang@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261029175238.3214788-3-weilin.chang@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3m5aSLccIyvxii8usbTRwPeaL8aVBu9nCXPvdsRMgO8_1793337129
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/26 3:52 AM, Wei-Lin Chang wrote:
> Commit 3b8ce2b5132ae ("KVM: arm64: Use a variable for the canonical IPA
> in kvm_s2_fault_map()") created a variable to store the canonical IPA,
> instead of calculating it when needed. It moved the aligning just before
> mark_page_dirty_in_slot() to an earlier place but did not update the
> comment.
> 
> Remove the stale part of the comment.
> 
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

