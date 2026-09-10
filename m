Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4590E47A876
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789040795; cv=none; b=FWsHigLeFF+Jt95WkvGkUQWUvf1+2L/5+PbT7+KnFXCjVemXKRa/BHekDiLRniFEB9vf3+/lsy5R9VjGQGPDAcLn4bCnushP73HuzYS/5Q9UCSYj/thSqlr618q5S6/twIAxmCSKH+Ztv+UrsanHzZCbJlNll+bFen2T4NcXAhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789040795; c=relaxed/simple;
	bh=+9G8GC05NdLHXF8cStdhp+Ruyt/HZZEYr3s5pM8Whfc=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=OAfmts5KQMZhiXJzOVidouSpPCELc8nEdUi8FN3xxhUUucn4CqzauFsd4sJibkeXLVRO+Z27VU1eEcy5eFyxtTNfOohyg8AOvuW3u+zQnprvELWs7uuwL1oFBC5zPTUwF5mGFadKumFpzed0sKkB5U2RarueA4zeFCGfXmtsJJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VB2JOTzg; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VB2JOTzg"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7eb61bbeb25so6775944a34.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 04:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789040785; x=1789645585; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4oV1R7Sem2YZktphiH9OH9k3wSSCyVuVuzldh1QWGuY=;
        b=VB2JOTzgYXxIR/p/+IebzVoFeUsQCI9fAesBKQ/falBZ1OSELHL/i3p1x9NFS3FVJw
         WIyMFz+bu0MbOU+6ZoAibX7B8fQMNzE72DGTbAB1Ju8Cr0n6ExI+kYtvk1NQHVaEwNNb
         78SVmIvc4H87r4LpFktip+Vylv0Pt9n7+/hAD1+5H5porFND/KPf6y/Vgg0kA0WWcTgf
         5Ib5Pyhmk7rrHcE65seAUkL1v/cG8qkFEj2UyE2weCfS9DPhL1CyShaufHy6XpWFx2ch
         T9F2NlaqTmD6FFlDbhwDbOX3fMtXiRnGXgxGKPAN6yIOHK4r2zkzQbd1TDhJicbztBnW
         Oa9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789040785; x=1789645585;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4oV1R7Sem2YZktphiH9OH9k3wSSCyVuVuzldh1QWGuY=;
        b=qmWRVVM2+bLqkN2VwRWjIIDeDzURZ+H3Jnvl+Zb+jRaTvCdIia4iozzZkqnK192YNU
         Idt6frDM1qfVIHG2gdIdXT+buKjE2COXW9IzhOYxDZUoOxBiBUem7KmHJBtlK2A7oUAg
         VreCFclMnskqWbcLxt1kxfGspj8HcwDJMYEAd7VVNhN/v86fO69JL9zConLVoJFwLMPY
         0Bg6q5SZXLvbff/SAcVhuyHp49VsaaD9PLFaEhyDffh0gupZ4MSNnKVkDtq3JLg4/+XT
         cZ3ckPHXAn3EJ/0KYTsYPWfsLorT2Otoi6RmA0kadv7jyFzSjtELuaShqFXbgFHqWUYF
         3ECg==
X-Forwarded-Encrypted: i=1; AKwUvByVssFZ3ys1eGRzHYr3idTUjVHFtdmJwbwxp9Cc7jjMvrGxPE2P3JxfCTT2FPK18YGmwQFinzE=@lists.linux.dev
X-Gm-Message-State: AFuF++n575U22UVrGmwiNof+wdWoEZLYcFnTLNZclWB/iCvfunk9317N
	QHvczEkn5OGvNxGJ0Ud+Le5MbyUEELSno0EiDIFsxm/Fwu5uslrn4wCu
X-Gm-Gg: AYBFou2fpsnbWNHYbZWS1OLNRjb1iBOKSwyh1pRPl0s53WztznaIqjn2DbJ0ZXB3TmO
	NAc51f4L9lsr+qjQ5X+lx7nSN2rZ2NSLWHBBF05GjsLBbiVCD6J12vAZoi/BtB9ikCUMyNHlCPo
	rWG4bYih+haMxtY9yibSy2B51HddKApdsnV63LS7mERkRneXuC/k/BcksFZ28LFFAmxu+ltTXrf
	cZXiaRqZk44NfTQautAiQyph1FPxmrtMtvgVL8JhjJ1bI6Pjcf+eTvJk7xCUAWfHazFhL8OLdg6
	bm4Fy421KPvhKrm8whUpRbZ3VkVJwP4rKJZJNUMugn9dYl4bgrMC4U98Oo1RqAtiIeK1VpPAigJ
	FDEFzHzmgfGOavZKdsWu7ayzS+AEsk3kr/fHwIJdgU9e1tjZSa1z8PRBaiVcIaDT8cL6eys7emS
	nTOUiH2yqbjoJAdSUnrvIpNoDswUtMOGvsrjVP1kgdqCCEArbbC24+QXvsqcnone5k4p6ZfxTPT
	X5kwOdT9M+z2ihhtRoVveICSYCOQHMYAYQF413G/2wXSxkh5/Kn9jo=
X-Received: by 2002:a05:6820:180d:b0:6b7:8415:d78f with SMTP id 006d021491bc7-6b78415d8bbmr19129181eaf.58.1789040785360;
        Thu, 10 Sep 2026 04:46:25 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143240d86c3sm46857652c88.0.2026.09.10.04.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 04:46:24 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 17/20] KVM: selftests: Take the memory region type, not memslot, in page allocators
In-Reply-To: <20260902164123.2546762-18-seanjc@google.com>
Date: Thu, 10 Sep 2026 17:10:56 +0530
Message-ID: <33vh1ghj.ritesh.list@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-18-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Sean Christopherson <seanjc@google.com> writes:

> Take the memory region type instead of the memslot in all page allocator
> APIs, except for the innermost quad-underscores function.  This will allow
> automatically selecting the minimum GPA based on the allocation type, which
> can't be done using the memslot due to all regions sharing a single memslot
> by default.  PowerPC support will also leverage the type to ensure that
> page table allocations are naturally aligned.
>

yup, PowerPC can leverage this.

> No functional change intended.
>

Sure, even though the callers are changed to pass type instead of slot,
the inner page allocator is moved to pass vm->memslots[type] to
____vm_phy_pages_alloc(). So no functional change.

LGTM.
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

