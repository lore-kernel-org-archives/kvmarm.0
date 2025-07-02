Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EAA249EB
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 00:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751416928; cv=none; b=UH2EEwHhMqJCUr4+44+0+spGTvGtTioN/vwZRGyXSvYmcjygeRgtgemmXZBBdbqmxfYrNAyPVd2Q1luLLk89nR8fvHLe82lXOinogHEsJkTgbdOGQx4HAIUNjUKeELq8Xdre9Z1Vavuh8iUMmsoupHqqMStiLKo/+gCTkPCwhm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751416928; c=relaxed/simple;
	bh=gQML4Nlb+6BLGU4vZy0wmRSFYntLR4PR2oVZTdDZp88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FQUmUIpSS/0fRiJy6ZxQOGKh5oWmbxHaxYZOvcw+6M72Djpo0ThyXXQ6mz6xk6mE77hHNNBPWP8uXAdDaFwmq1zWZg8gtrnkycdOva43HO2SP0URm3QF2U/42UqqjYkekqBgJPeLG70CHXX43js+32aQtGwQ491WMby/M1XHGZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IxNWgQwG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IxNWgQwG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751416925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IS6DmHZ/EPn9vNNwu1p5P0DKnu56R5jJnANztZV8U2U=;
	b=IxNWgQwGV/to1llh0ut/3B8s8sLXQfzfm3bgK09Ia5wGHDrDezeyUSUgLFWL1R4RhGS3In
	J+9oFqUeAxk9pmN2mfxGyfiautkda9c3HSeFYZDKfssN7QeRTQiyRCRbSSWdLZj8NH4QXb
	0ot6lDtsHa/9DYt3IVBCKgeue4UttXo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-ONi9BqGmNXGP5lqpyOB93w-1; Tue, 01 Jul 2025 20:42:02 -0400
X-MC-Unique: ONi9BqGmNXGP5lqpyOB93w-1
X-Mimecast-MFC-AGG-ID: ONi9BqGmNXGP5lqpyOB93w_1751416922
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2363bb41664so46837825ad.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Jul 2025 17:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751416922; x=1752021722;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IS6DmHZ/EPn9vNNwu1p5P0DKnu56R5jJnANztZV8U2U=;
        b=KxRrIAk8Z7lKVana3LoJgMkUiEZHf1i9Bfd/EzzHGQNH4t6NutNIa8oNhfxxDfKOE9
         KBylDLCxSSbjiOZeYzoQqW63otFsJ9Mizl14vdGxfJyIjp0f7xXjKguUoNlIogC3VyTO
         AHR9MSJh1DDi20Kk5nxX54EqvUf+nVxypiAf5AkUSPNa1lfO/Fm77SegqfBHWePNrfjC
         txnJ4i3hTK+VsA5InzU6IzjYRc62uuOU6Mr2gYxgeYSes7ZaXqXb/uwcXNpyM/bAcj2P
         66oA6k43dvtP3RX9Q3i8an0IEMTvQyZX/ZsNidBbN3ki7qxk2/ljHVONqOpaTzCSHd3s
         Wexg==
X-Forwarded-Encrypted: i=1; AJvYcCXLGYQnTDvrmvk8xJxlLOhrxGx48plhnZE279y+pn/qSkCh4sb1W9gujuuY7LD5rexWbaRqBlE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJAf01bV3eyPcesVX2vREPFluAXierLIBP9LF1toZKFZjXFE5T
	YIovfYGTzGhLx48PvkWLRMaophcdPwE+t48IUYv+EyhyTk2hPbeLe84ur/dautIMj518N8XTDuX
	IoJMha+pOMmflUQtxevmNq89OejwN6EsdKxSk4xDIiCLjL38qbzLJ7Zdcpg==
X-Gm-Gg: ASbGncvljShcm78XN9zkidlKRclKed/I/PTYuKdmEtNcIb79FG2gM8YMm3QPdp/T+l5
	LsKVVx1/L3fM8Rqk7Wl6nNH8WfU5yqfWNIgc5R0ezQUMpyV6wWLd2vOpjfO94DxMAjbGELpmBDc
	LO2ZlXroSH+7NlSzVLvEiSPQKy66v+80/kvSgv0xHK9xg83cjVyhn+vTHO3t0YZLJ5zXnu0zi8T
	vX9Mha0bQQB1oMO5VMviFoxZn6QTyvaG4JZZ+7sir0sExc+lrNl9j2Ta4QRVlljZr4j3GE6t+Vt
	xoE3HqpigBtMGuv7VZdL8DX4m8s0FL3XoNkyl4+gy4tucpmF/LgFA4cz2ABLCA==
X-Received: by 2002:a17:902:e809:b0:21f:5063:d3ca with SMTP id d9443c01a7336-23c6e81e812mr10087945ad.16.1751416921636;
        Tue, 01 Jul 2025 17:42:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLaYwVOFkrc3uXeDo3lLBdt2ODjpAZgoQY+FVxCUbATRGn8q8nteuTtaLiNL9kfSpsCG8Ldw==
X-Received: by 2002:a17:902:e809:b0:21f:5063:d3ca with SMTP id d9443c01a7336-23c6e81e812mr10087595ad.16.1751416921150;
        Tue, 01 Jul 2025 17:42:01 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31c2252sm11480507a12.49.2025.07.01.17.41.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 17:42:00 -0700 (PDT)
Message-ID: <d092bb97-d552-49f2-ab93-bb2bd7809c3f@redhat.com>
Date: Wed, 2 Jul 2025 10:41:50 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 16/43] arm64: RME: Handle realm enter/exit
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
 <20250611104844.245235-17-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-17-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -CuIQdd7-vmKmAhBHmKWLoixDx-W2R8bApEkK6f3gHo_1751416922
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> Entering a realm is done using a SMC call to the RMM. On exit the
> exit-codes need to be handled slightly differently to the normal KVM
> path so define our own functions for realm enter/exit and hook them
> in if the guest is a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v8:
>   * Introduce kvm_rec_pre_enter() called before entering an atomic
>     section to handle operations that might require memory allocation
>     (specifically completing a RIPAS change introduced in a later patch).
>   * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
>     HPFAR_EL2_NS as a valid flag.
>   * Fix exit reason when racing with PSCI shutdown to return
>     KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
> Changes since v7:
>   * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>     been read (although that can never happen in the current code). Tidy
>     up the condition to handle any future refactoring.
> Changes since v6:
>   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>     vcpu to the error.
>   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>     this exit type.
>   * Split code handling a RIPAS change triggered by the guest to the
>     following patch.
> Changes since v5:
>   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>     change on next entry rather than immediately on the exit. This allows
>     the VMM to 'reject' a RIPAS change by refusing to continue
>     scheduling.
> Changes since v4:
>   * Rename handle_rme_exit() to handle_rec_exit()
>   * Move the loop to copy registers into the REC enter structure from the
>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>     where the handler exits to user space and user space wants to modify
>     the GPRS.
>   * Some code rearrangement in rec_exit_ripas_change().
> Changes since v2:
>   * realm_set_ipa_state() now provides an output parameter for the
>     top_iap that was changed. Use this to signal the VMM with the correct
>     range that has been transitioned.
>   * Adapt to previous patch changes.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   4 +
>   arch/arm64/kvm/Makefile          |   2 +-
>   arch/arm64/kvm/arm.c             |  22 +++-
>   arch/arm64/kvm/rme-exit.c        | 178 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/rme.c             |  38 +++++++
>   5 files changed, 239 insertions(+), 5 deletions(-)
>   create mode 100644 arch/arm64/kvm/rme-exit.c
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

