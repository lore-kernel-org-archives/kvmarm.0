Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9F921D3E5
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 16:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740588481; cv=none; b=dsLF5BWpdCM+6yEjYgSSCIXrC1m0BviXEn1Cc2N9BapfYcZUMCRUoM8vVUypdtYIQNRLXNe198z6gemGshSz0VKGsQUW5kWMNYZQ59Z3PZembnWSTPtXW1X7kIkRbgt/FnW9xqGP+pPmhnuXb74kU911piIVmpUYxGaLgfWhb7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740588481; c=relaxed/simple;
	bh=FKuDjPky48EawNRhGHbvfKvn12YiQAezKUHuc/fM6JI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZwDxZsS9Z++mH/1Jd29/OS0sw9H9n7gwXXVSHtEQ1zJKkACOODQC+N69MI5dbZML9AbvEy1NhlWy6NcTa7VxGWeHP/XOgNRTioTEem7NuWYSc6DqS8w1P4O9Rrc3hBuVgj7eikbpqYWviolCriFGS0NUdxP03qX2HDijB0fto54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wc5sH/lB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wc5sH/lB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740588479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XEVhtESHjA99969kja7lZkPq3yyhhnaBTAi7GUz4sRE=;
	b=Wc5sH/lBMWBO2Go1bceYqwpVrTLKm2zUeEy37nptZizLxpJaNeDDm+RCEUq/lgyyEABFnq
	7ua8bqZvhsSrKUKQpyXMrp8DnZ4zac0gYy9Mdtw4RRv8sM7GjNLiaTxTLJszReWaRhjgFJ
	HIKz0H2n1EAMmkTrVcW4t2bFFnRWwFY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-cz9S6hYuNxKqVOc_mTv9mw-1; Wed, 26 Feb 2025 11:47:57 -0500
X-MC-Unique: cz9S6hYuNxKqVOc_mTv9mw-1
X-Mimecast-MFC-AGG-ID: cz9S6hYuNxKqVOc_mTv9mw_1740588476
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38f2f78aee1so40511f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 08:47:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740588476; x=1741193276;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XEVhtESHjA99969kja7lZkPq3yyhhnaBTAi7GUz4sRE=;
        b=DZXtYOr/TcqYuyKwFVAozBHwvZMowlqpedz/M9WhtgPPeTj4IaX+DJYjktJxwDoLzf
         mzV93jShpV+ZuW5EvnlpxOJsxVypbsB+wxCCXeG5SlT9Mdk3QQN3jJjydoIIzU1MvWXl
         iu4CUHwJGjTkXd31obucQZs3XEV5nX5E6Cnos5e3F3egutn2+PdrMsIXcdybQkB41ERX
         Wu6HrqNkBq2POR/16maNP93mXWM5Kp55ZK1FDZmsCWus5Zb3yNoO2+L6vvBHA9swnhqV
         xk+oLBZCMr0ZUmbMc32sdh/0UkmKyBc6pyBxEhI8YJ9Wnc9WZHqrP/BLVJHhTlSPsVtj
         xSVg==
X-Forwarded-Encrypted: i=1; AJvYcCWHF5Vhyiz2nbKKd/J8gwN7Ol1UfmbMJANgnhGOIC4fFC7OX5LY+BCftt5R2wGy7t+9qhmurzQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8Xk8HnH2WsKAK+9cS9bsOv840d2JcSsy9wAf4V4AOQQFnJZkr
	Q96fNyJRosUxPTXGokSvQziL+BNnWa0o9nADyApUULdgPEWBtK2qN5cyPoPXAohZ26hQ/2MRee/
	xin54pf0v02YMQl6BFSzyfI9gyaCH+TqBW7LSeaaoCYvHazx4qhaYBFO4QBC5CQ==
X-Gm-Gg: ASbGnctTZ8MgpqC8dplX3IqxJzlwyNgK+K0Lv8PIet9nBbEalIDiV1toq5uXGWKhztG
	ZUeWujYxmx2Uvd6NuwfJAuJXYZKetuVSZrx75ZEabkehIMn0Nlkho6x4B2LY1A7dZ0MQCFFnbjb
	8otDkq88K1CA9D1yc7+pPLva/dbK6SNqIphPKwwBypIZPttLTfXkvXL0XcstoNg01gu8QBheGi4
	HDO7inUz0m7Lz3xZMs8BP83HjAzl9UqxkC2lHEaTLRkNbHCJWlxEj7CWFPPLlkV/sZQ+/W/y5Ny
	Ugps8ZEiu4ArTag5UFywJRHLXJ8yP63+8pbnVyu6ElfFZO20/sw5C53/BbWlDQmf
X-Received: by 2002:a05:6000:188f:b0:38d:b028:d906 with SMTP id ffacd0b85a97d-390e169981emr60081f8f.21.1740588476058;
        Wed, 26 Feb 2025 08:47:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF83oPTzqUwKLHnTkQQgBtRJWLQEt88A6Baykbj08FpuJXByuQdt6jO1meJ6Wj8oNqtztQbXA==
X-Received: by 2002:a05:6000:188f:b0:38d:b028:d906 with SMTP id ffacd0b85a97d-390e169981emr60059f8f.21.1740588475654;
        Wed, 26 Feb 2025 08:47:55 -0800 (PST)
Received: from rh (p200300f6af284000f9ca1328aeaacdd4.dip0.t-ipconnect.de. [2003:f6:af28:4000:f9ca:1328:aeaa:cdd4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390cd866b09sm6275665f8f.19.2025.02.26.08.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 08:47:55 -0800 (PST)
Date: Wed, 26 Feb 2025 17:47:53 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
    Cornelia Huck <cohuck@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] KVM: arm64: writable MIDR/REVIDR
In-Reply-To: <Z7zxSdW5b6rqe2bt@linux.dev>
Message-ID: <b2b015de-569b-2cdd-8ec3-8c8690ff950b@redhat.com>
References: <20250218163443.32836-1-sebott@redhat.com> <Z7zxSdW5b6rqe2bt@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DW88ujmPJ05czd-6GUnNTs1VwjyprFlsvF8ZwagAVRA_1740588476
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Oliver,

On Mon, 24 Feb 2025, Oliver Upton wrote:
> On Tue, Feb 18, 2025 at 05:34:39PM +0100, Sebastian Ott wrote:
>> Based on prior discussion [1] this series allows VMMs to change
>> MIDR/REVIDR to enable migration between machines that differ in
>> these registers. Since these are used for errata handling the
>> errata management series [2] is a prerequisite for this one.
>>
>> changes for V3:
>> * handle VPIDR_EL2 as part of vcpu ctxt - thanks Oliver!
>
> Thanks for respinning. While your changes are looking good, as I got
> ready to apply this series I wound up peeling the onion a bit further
> and have a few more concerns:
>
> - Current KVM allows guests to read SMIDR_EL1 despite the fact that we
>   do not support SME (this is part of TID1 traps)
>
> - The "invariant" values that KVM presents to userspace originate from
>   the boot CPU, not the CPU that resets the ID registers for a VM
>
> - A VMM that wants to present big-little can do so on current KVM by
>   affining vCPUs, but cannot with this series
>
> All of this is to say, I think your series is going to collide with
> the pre-existing pile of crap we have. I'm going to pick up these
> changes and rework them so we can send a fix for #1 to stable trees and
> (hopefully) avoid breaking the old "invariant" behavior.
>
> I'll post what I have as soon as I test it, hopefully we can get this
> shaped up for 6.15.

Sry, for the additional work I've caused. I gave what you have in next a
spin and it looks good so far.
Thank you very much!

Sebastian

