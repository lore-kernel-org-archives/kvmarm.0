Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6E046D2C1
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 12:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789041929; cv=none; b=Pm9yDNbqqq94v2nttXYqlq9cwgcV+fBE/bBZAnfg+iJGw5M+zBbu0Kg/zhRkgj6H12uRPzdo+baoopBTAdXG8CHGAmGL+UmRePTOMXu9AysqHtPztD7C5PbNHgEWA6aZwYn2YJbTCXBan3Z7vtpJmNwQLU4hRvPo+fNOrkz1tyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789041929; c=relaxed/simple;
	bh=DthyWf2+A2G2Y75caLR9paCIYHUzGrDRbammkA/3Uc4=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=ESOxAQwMGEpMqRsA/8rknNn30AH3FEPRQZ2qOpbTIRyQkgMBC+Fj0e0uRO0g4RlPjbxq3wY3+4g2CDJuVpH1xAaZ6lCx7BmSa5pH17EUYlWZaxbB0eWNrc9uYonYwhX3RilSe4dD+qJVZOR0iguB0M8s34668hHjR4oGLePIRZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dqlW96hB; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqlW96hB"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4ae61629fso591829a12.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 05:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789041927; x=1789646727; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=j5p0fnZhfsutRgdRJoA23rs+n3VC6+9xK2KvWtfvI90=;
        b=dqlW96hBwIpSrzeKtgkLK9MYVY2KEQi2m4sTXdqNOqpYHLxZU/RcvcbPlVeadnSYgS
         F385cH2XEo+bi5FRW1do3J+hMgRwz0aldbtS7KrAzND+CReBJ1OyetarDrT1hVmFSpGa
         /9Ew130EUAYTDa+YSz1lm15FxKC0QjvkPTfTL/i4UpByJQuMoWpnKGiLm6duUQsEPCS4
         xMBHuiHl0bwS5IpClrp3GIWNNhXPeMubL2vLWqTPVPVUb+WPrRcK0dC5y9vq8YMstlw8
         UWI7N33NP9XTpfN/GYw72zRkOkK5rpvhNXH9RNFn1jjbNs0KBx23kzZ2Ru04YW/zW6Ft
         23bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789041927; x=1789646727;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5p0fnZhfsutRgdRJoA23rs+n3VC6+9xK2KvWtfvI90=;
        b=DNVKywTJEfeOFapyYOUt1en8KGCSd3L690LglLza/fA5WYksELXsCj8zjjiOWoXddC
         AqjjUMDCO3erDFZzeKrUkYz7IlQ+R2OPls6T9zm4u37kjREpLlZcYyCtyoM31WaOiJox
         UquOtDNLlVKNf8oL3GWBVIc4pBNyRRRPL5en9sV3H4C/5JPxjlha9btFQ6ZVbuNw/vHo
         cmShKOZ8nkLp/1jY+yQyb1FCF4Me25QUZQ0BzAZeB6qVcTj4Hy0nBTLmWq3X+nUxwX/H
         N8hUFRK7UtgYs0O1hf3XosCNgXYKyUrxesjHXx8I4tUm+F9/QEf5FJ74yaaxk+n28Xs8
         6tQQ==
X-Forwarded-Encrypted: i=1; AKwUvBwyCMbY9FzA5+NddqRLxq70uodHpvUYDYiXLKSopmboe/6j4Vm5TjMTjlQBcDSJyMntBMnCzZA=@lists.linux.dev
X-Gm-Message-State: AFuF++nK0whOitCNypP5BgpX7fXrtuB86koXkd021610mkUVgWfruQPl
	Ac7cqN7Fcda3Opsl19SqqALbh6Ka6oZlsfEmysyuO6dAosZnP2yJF2oO
X-Gm-Gg: AYBFou0ckXbGQQ7YkDSFu6P4ZDN53Nl8Uhn2Dz3wlfR0Qz4DfHlAVexTiJ/DcP+gF70
	INtfF/9ZZwQwbaGRlN5pIU+lviIRhr45bViiB1KkxrtpVJjdGvDda9lChBMkW8Ogi0EsC/453wI
	DODKx0ZQCY7WO6cjvvUVyjf8jrio3xFlna+UflkJ+SSG2vWqKTHOF4ufAiqUS8N2y6kXYsuyNpW
	x+iRQe8/Qb96CQEew2j1MGvq4mYRLF3rv8WwV/3jX344JHSPjvKbQ88UCsul2m/yiUBkeUtPFde
	vLMt/cw5PQ1karv3P1RKQY1i5LoFTNlvSoB8S5KxHc4f5wFijiuCDD+OcDVMAI+O2kqSMuyWigV
	HBgxhFFP7TD30CY/S56iEEUQUw8uXLUi0s9QKNPeyefBomqIVvoTF4bHbOdc+PgGKSVScXZOCB8
	D+9wBgxwG5VZU3SOfPscfHTJZmTt+NK/n3Ie+ru+rwcEmXpfLdfyZCbUJOECvxs2dEKhD8GyJC0
	KS9HbF11u8S6bhlVfs0fPoKkkG+aqEktTaIDLsrFsXQ+3FYvOze1zU=
X-Received: by 2002:a17:90a:ec8b:b0:399:1b64:e0d7 with SMTP id 98e67ed59e1d1-39d70bb1bd0mr11567376a91.19.1789041926812;
        Thu, 10 Sep 2026 05:05:26 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm59190560eec.21.2026.09.10.05.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 05:05:25 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 20/20] KVM: selftests: Add arch hook to force page tables to be naturally aligned
In-Reply-To: <20260902164123.2546762-21-seanjc@google.com>
Date: Thu, 10 Sep 2026 17:27:18 +0530
Message-ID: <zexpz5cx.ritesh.list@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-21-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Sean Christopherson <seanjc@google.com> writes:

> Add an arch hook to communicate to the core physical page allocator that
> page table allocations need to be naturally aligned.  The hook will be used
> for upcoming PowerPC support, which has MMU tables that are larger than the
> guest base page size and need to be naturally aligned.
>

Thanks Sean, for these patches. I have addressed your review comments on
v3 of PPC KVM selftests support and ported those on top of this series.
I am still in the process of running the entire series on a real HW
(and some todos/minor changes to be done).

Will soon post v4 of PPC KVM selftests on top of this change series.

> Bury the hook in the physical page allocator to avoid having to plumb a
> rarely used param into the main APIs.
>
> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

As for this change. LGTM. Feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

