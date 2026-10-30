Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793337109;
	b=pCZiBHCliKxIT9yxRFULx/OQhn2clvg0XoKBDdkY/klTylOANZa2iyVA+dR4aHGtkr7w
	 L5SGo71T1ujb5+ac4jC8eYIeXjzOBZxqzJvEaEEiZ7hARbFqL/QXEeOE6J90nm5EaXQVg
	 acUxaM90TuWpsabiGJonm1Bj03r7F7UHUReMueQmcBsMFqdskwk9w0U08NJk3coTyvX1w
	 3IgMO0o+rnE9GRETinNuFBF4db8I0nNnnjCmqVQ8Vu+Q+sAPIDJ5riAJfmObsWwHxuQ0H
	 WYfk3I4KZRsW3BO7HgoUwtNE3IwGj+08Tjk/1nQ6e4JmnP46PZRe3NXiBilBGPdbQzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793337109;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:From:In-Reply-To:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Language:
	 Content-Type:Content-Transfer-Encoding;
	bh=FQn8AMTtavP6P181h0fXU4D+4WY7Po1HblFZ/HaZCWU=;
	b=cYWXm/E0XRtzk2tc3TS3OaJ69Z9pS8bKz0GTQk69Rq2PNIiPKF2Fmda8ZA57nZI3AxT3
	 z5hNluVyEPB82K2lF0y7yMghIoxPeFCJQK5KnkRt0vcTMy99MQRN8P8UbB5BBdSYgPJts
	 rGZ40QBqc9zkt2OImCtdS89YsUy46fiIVGpXHrRm69ukvtrYTNhPMOqyLjk4uFPXqlV5o
	 gK2ZBkebioUkpTdGfHvHJ9N0YICInp4BJwDLfzO/WuXju6MZIpXOYW6t5g+JqiIl9kkx9
	 y3b83trFAFI6GZY4V6sOKiVXaTlDfohv59150Day+QUOjD8sHZOlyu8/962HeFvFIjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XW8WCvWg;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66897606A31C
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 05:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66897606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XW8WCvWg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793337107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FQn8AMTtavP6P181h0fXU4D+4WY7Po1HblFZ/HaZCWU=;
	b=XW8WCvWgJGCrtcAiWgfwcMqLGT72FVAcK/GzlDsd6fHEmEbd6l6zZFb3uH/wrtcJ0HheHO
	vnqnD92aikMqBn4DJIU/Ip7/zTrT/bDhA206ONZV8gdRH649FRiiA83ES31JDaHRyozVSr
	BVXxzf3sGvPaaGd4aBDRPZwRsyZbgKo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-2MP_Cr3pOVeRBRrx8IjlOA-1; Fri, 30 Oct 2026 01:11:45 -0400
X-MC-Unique: 2MP_Cr3pOVeRBRrx8IjlOA-1
X-Mimecast-MFC-AGG-ID: 2MP_Cr3pOVeRBRrx8IjlOA_1793337105
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so540477a91.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 22:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793337105; x=1793941905;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FQn8AMTtavP6P181h0fXU4D+4WY7Po1HblFZ/HaZCWU=;
        b=hNQOWjm30DICKBb98hOecKgNppKQjY6jj/tM0vkdFi7YvIseYVzJCLk3xHxO/O7Vm8
         bHidfd7l+wKEw0usqnLIWC4L1Y/59ixJYRMRsHpTTfcoXcKB5vaxYgXpN/MCG6WEy0uK
         0GnjZEjysUYrlJaOmZ/n/d+Pt0Dj55hCU5l+tmyfLl3N6fOGHNYbi+kWvjSAL/+sZoQU
         TtT4pdsuiLv25+ykGejG+6mAvnoD7u5Y5hjzZAPHx6K6rqbPugpT8ltZfUL8JNgHJEzQ
         LcXwBg3h5bixRk4wgHjnqOrXMshvDPuCfbQoOAQJfUuUkOXu0WumC8yp2FYYPcvIhhHD
         Nt8Q==
X-Forwarded-Encrypted: i=1; AKwUvBx6RG6L2PncsAcxSXTOpW1sdgAaOL9d7lvtPdOE51xFzAPQ8e6BdWjYc4IOjeqMPvr3y0c6BZ4=@lists.linux.dev
X-Gm-Message-State: AFq9FYLzb3COakB0+c3/2xxRP8+bWk0O/wYfexKTcCV9olCXgdZVMkt9
	J613pkeNE3Y9c29Fqdp0Y2IgF9TacGXBzv64pgoXDvFuWycxsp6XFuJ4lb4JUCMNcAXoZTibiPR
	TPO0+ja8lcY4SOJWn3IwyftKKrGjVDqj7sLcS4/jJHwYsrU4a3fY8+mlrog==
X-Gm-Gg: AYBFou1XgNvKoCrbWKwbY+sspNtdtxzhRqml93si8XnOpCJj4Nbwa1FT52TwtSkpgDG
	lbtoszjkHCVU0ikCsaW9GUc29zS4PUjBLePxzsGKjcLxDo1vGCTw/tmzar2mbi1Aua8o3fCqudd
	WntGylpaHIrnQ5YXMOZbTlCfiEJ4Tws7prrC4bAxeWdk7xKEGWEdAGfN98LAbeVzdHyVIOHU1YL
	OnbpxfA2Z1Pum7YZ8xy+o0bHbZnfHCyixlfHM9WDfnnlnX7nP9bV1nn34ks+2m5nL13lZelkgnh
	hacNdvT79BD4RqU5pHCtOhF4gsxgcBxkgmZQWpbTxf+lWZEmPaAKBcg2JxpfCy4ubQTdp8nA662
	X0G32jxG1rIOubRpCdJEEwKdPHQ6rfKA3ExLGb5SpYQeaWEFbct29K8KZCY/ZVJv0qvdQF3b3ng
	bQWIA/Vw5cFho6TBw=
X-Received: by 2002:a17:90b:55c5:b0:3a4:ad5c:d48a with SMTP id 98e67ed59e1d1-3ae8987e75dmr994565a91.67.1793337104515;
        Thu, 29 Oct 2026 22:11:44 -0700 (PDT)
X-Received: by 2002:a17:90b:55c5:b0:3a4:ad5c:d48a with SMTP id 98e67ed59e1d1-3ae8987e75dmr994554a91.67.1793337104101;
        Thu, 29 Oct 2026 22:11:44 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9b1506sm6728517a91.15.2026.10.29.22.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 22:11:43 -0700 (PDT)
Message-ID: <6c683dbf-45e7-4a19-968e-5acab3290090@redhat.com>
Date: Fri, 30 Oct 2026 15:11:35 +1000
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
Subject: Re: [PATCH v2 1/2] KVM: arm64: Fix dirty logging detection in
 ring-only mode
To: Wei-Lin Chang <weilin.chang@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Leonardo Bras <leo.bras@arm.com>, stable@vger.kernel.org
References: <20261029175238.3214788-1-weilin.chang@arm.com>
 <20261029175238.3214788-2-weilin.chang@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261029175238.3214788-2-weilin.chang@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 13VfFgc2UYO9cPLmPKfqmhSn7gwvWo7_t9a12Y8idE4_1793337105
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/26 3:52 AM, Wei-Lin Chang wrote:
> When checking whether a memslot has dirty logging enabled, the
> KVM_MEM_LOG_DIRTY_PAGES flag is the source of truth. Previously in
> memslot_is_logging() we were testing the dirty bitmap only and did not
> consider dirty ring.
> 
> With the ring and no bitmap, a logged memslot can still get block
> mappings, so guest writes to most of a block are never logged and a
> migration can copy stale memory.
> 
> Fix this by using kvm_slot_dirty_track_enabled() instead which checks
> KVM_MEM_LOG_DIRTY_PAGES, within memslot_is_logging().
> 
> Fixes: 9cb1096f8590 ("KVM: arm64: Enable ring-based dirty memory tracking")
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> Cc: stable@vger.kernel.org
> ---
>   arch/arm64/kvm/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

