Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38446C847
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038460; cv=none; b=LW3JWIZismLKb/aO/wVgIs/cLpkkZs+ZmSDLVsW+NgqdbDX2IRedZ3NBt6ZNGYngullhFPWZGEs1d+1CyYHVkaDECj+GM7jwWyT9dBkrGw3KOvjYSBB2MEAoplGNoqOBC7gMlAu+cRQAwtC2iXLYefSrNa+ivLkJcUHNUT6miN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038460; c=relaxed/simple;
	bh=70Xrz5Ek18W9RLHK+PGrZl6neyZSU/LQLxpuqNmBXms=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=rCMeXP5/RUv1RboZPtDLYhQoHoNrbVYkMYNYtfRTtw7Du9Pmvp3P3lT3Gihp8wSXV4FfsYSIPDeFFNVHf78YhT2N/J7O5Ek5jLeR2qihgwIYBXTpSea/87bNfcIUvj/JPmQToUCo7XLOiarQp91Ls+D4be9l+XGn+bAlbhq0too=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qvtHzH49; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qvtHzH49"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc1c73645a1so5460055a12.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 04:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789038458; x=1789643258; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=70Xrz5Ek18W9RLHK+PGrZl6neyZSU/LQLxpuqNmBXms=;
        b=qvtHzH49IpgVHGwxU6NgmtAYuseev/bySb6Apa3CaoWPwNHz2JsxHAY3rgKbRg5vcc
         QeukSy/7mS32UfAcTqPxVN0pA5/0w39PKNvl5Gt76XGYklOZPmqQ2vZXZ7IwWVTcFOw8
         giHIvjVLu3fEnop0UY5wVh6mYwPQkgNzS6p9s6kafgJD1MidTO6HIiNsNo5cECC8Urjm
         OVAiHYE56281SkwnKAH3tEtSQ+n5eWXgADEqxR6xefMMRFF0i47A51zipELsiHnV1F/7
         zwdq2c/wpojvTisKIdAcxhgJD6mLQ6pKspT+k+MsHz9QZnHob7czhv6U/qLMjLUhz67M
         i3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789038458; x=1789643258;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=70Xrz5Ek18W9RLHK+PGrZl6neyZSU/LQLxpuqNmBXms=;
        b=VjZE939AobBZ2bs7KHIgjJO/Ivho7K3xt6xnA+XRAw4ZQuD1a8lZYj53KsnXBC38ni
         /NJ4OUiu0J2vfcP8tpv/7ghpQhDG0Jt+tCib0w/NXXSvwTnwSokeN9Q8l3yxENlephZu
         4I1EHekZeVeUfGK1/F+Ho3bshpH8oIHMrW/g/Q4icT5SToyKW8v+CrYh8Od8ZnNZCASL
         Cbk/lzVjYDn51Ndflbw6je+4ZPQK1EwIL2KXHkbJqNQeaDigM/MfZYnUSO6SlpJMVuiu
         LH25ZhNQSZ1SFCeSzPP9ClOYhBorpKpQzhmLFqk5uXCRQ5/lVPJ4YfU3y8HqhoM1b7kz
         h1fg==
X-Forwarded-Encrypted: i=1; AKwUvBwR8IHp/xTb9py9novOQkMZe2X8KmwJkYi4lPTfQkdIJxNyEKgCB+QngnI89bzhwTUKzVcAyFM=@lists.linux.dev
X-Gm-Message-State: AFuF++kqN9dpojk3N+6RXALgJc8NSdEhH8vsK6YiL1s9YUsa6FrGect/
	AFvFiLgKAatE6ZmwwS2/s+3yGNEhJ6PmR+aGOx9YcSnYCJ80/9d6N9hM
X-Gm-Gg: AYBFou160l4l6S3Ld6LsleTYDwAO3z9Cb1I+kqmJ2VT8KZ6ZcHi3xR/iprIXAlLgzJU
	3CePqOK+Pd9NHw5OwyxvoYY0X2XBas/PKKh+AnvNerQAcjJWcdJKcy78pyjki/RSn1udkjhS84B
	xqoAc3RuO4CT6eUzdm6bqMkh9oEU3tSaoPet6jQ6vRgYSzhxUCRBdKw4ZzbHje86cy0510LkDvI
	RfS6PoPLc4jK6FwLK2votuyZ88IwkzoIN8BriSJiSzzi0fUy5ZOn79AOh+bG7tMFQhCW1eK8+qD
	dCFP9UhP+qZT6UlK1Y+2Ixj3pMCzuxFOEYYcPEM5j6dc4X6ulwls+DtMHM5wapZ54XCgn0hwKuU
	e1PBwsfUS9xXFTRDbvy+9pTPTvxJcvin7eD8RAiGdI7S9JsIA8UqYdR6YFKxX09FZ2cvZJsTTOm
	ni69Zw3ZiZxlkgrlS4f5HOOWRn+Ou+WMi3+dy/wbAMxjIQIGCe/XudLWvBHesyQKusobQ5YS+Ly
	O+1K2yYcGw8wAs1B5uvbT/v7bSDo3YICqy4/+azP9v+clO9Wh/lZPo=
X-Received: by 2002:a17:90b:1b06:b0:398:9be9:ab8e with SMTP id 98e67ed59e1d1-39b2622ba26mr58218547a91.19.1789038457819;
        Thu, 10 Sep 2026 04:07:37 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a62be87sm43023781eec.6.2026.09.10.04.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 04:07:36 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 10/20] KVM: selftests: Add a wrapper API to allocate multiple page table pages
In-Reply-To: <20260902164123.2546762-11-seanjc@google.com>
Date: Thu, 10 Sep 2026 16:34:41 +0530
Message-ID: <8q591i5y.ritesh.list@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Sean Christopherson <seanjc@google.com> writes:

> Add vm_alloc_page_table_pages() and use it throughout arch code to replace
> open coded equivalents.
>
> No functional change intended.
>

Straight forward change. LGTM.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

