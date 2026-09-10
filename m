Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E2C3D4135
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038216; cv=none; b=dscBsg9s6PS659Xrh5KHYAUHffdB5w5gT7FPXTUt5Eo5D/qAlaryZD2VVrb+n+vg4jNlQsDpv9oZlQWND3sn/ToF+92WZ0MIbstuOfPlqHnbnpMEvgKYPERHmzvpQ+Yv135XS5jqVxUZGinwNZ7jCJ74voiomEWzDqWVqqdb13M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038216; c=relaxed/simple;
	bh=3gHoeS5DETEBmd8V63FOswxYH+BlwM2UupwRK7ysm3U=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=kiprHKfumu8OXNA0oyd5qms76eNGSgGaIsiHgfFxSc8ziFfZCDYrSd7NYw30jb6UaOPPpgF0s0vkOdn3eadSieUZdu01AoAyCy9Tg8rqHMsTEc3rP7MU15YL9C7VhW6GgRg6OiF172lXVY63v2aHw6d9nKFzRi/97ptbx7VxJ0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sT2mTDEg; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sT2mTDEg"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccda24a3so935035a91.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 04:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789038214; x=1789643014; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Hx87S2Y2VYrsz+ltlElpgYkkRP/rEKOc33NOUB4sPbE=;
        b=sT2mTDEgrSuiB4qxDzCB62UnAdekQe80I977cHvfcOyRISVIfI1pauuH1GT6RyqWpF
         7fA2ZenRXoGMg8Tlqu9nFGoemPKyrXm1Ps7+6kd+sy+GkIq/yCUEOcVoKQ4Y6xPOtxmt
         kgxBHJrFsOBFD0TKq1v+vB3GrKcQ2NXEjkBl6sEu3hO229OC6zV8sXKd5lylB9w4/xBu
         cFp22q9bweztg0zYsz0ZSswHqi3MMFDDhnUPPN3W8WwDLMlqoPOsU7mABhYkUUjOThQW
         TJzXVos07nZeqsZkeGVjyZemNZ6kyeX9j4MRwKmPDt5RExCedfbYguUodOW+Uj5uljVa
         LfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789038214; x=1789643014;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hx87S2Y2VYrsz+ltlElpgYkkRP/rEKOc33NOUB4sPbE=;
        b=rFlEvHRgQbA+2aCAZ9FTnaCE1InOdXM8alBfZlmW5Xt66KqWQ2Umxux3rI9Rz5moUd
         n4jI/J16qhk4eWEGk3rdPg+h341/uYWKcWKAr2w5DEl2pATUC6aFG+Ok40DlVzcFe0BF
         zFemxgQqxfD7RcfxJ9I5SzPJixVQ71tqI2EzFJwpvNHqfUbo52kttfv1UkjYCyV9UHqU
         jc1jM9aUUdf1YNREqdRH1zlBvlPsP6+x8ZYbxqMEjnaMAM6jrLxxlOZY5Xg5Hbx50B2m
         xvx8V8rOq6MpnmiQilw8EwSAgbhV/idjkzNhANqMuUZDupujPBz5eumvU7iuCnGHQ23r
         m3ww==
X-Forwarded-Encrypted: i=1; AKwUvBxO4zzs9BJer9fhQVcjNtit3svPJR8ZUJPV+FZcDxssSA4M0TC9TIZjmTVqc52HkzWhi4APnk4=@lists.linux.dev
X-Gm-Message-State: AFuF++nHrqas9PHFPLx5nDxOMka7sNZXOqwOvN4tiL7LVeUxKL0kuVD8
	P6ub32TX1gBi9HRBwmSoHuX6l8TDBKStuPfvuNloWfiTt/PRl+1OLnLO
X-Gm-Gg: AYBFou0b2qkWyiiH/I4BSzespdYypABrWgkh9BhtryuLUfYzTxeX1qzW6WHoTXLNXXW
	1or/nLmjMgSovXgzN1CE0c5xzNvnpGIVge54x1MlByKxiUzhNa3B8oIV9YtdJKwuD2NNxnlE9+u
	ntiDrQAEr33YElZhFFJOPgT8SY6WoS5gwsl5AHh0DIBsFR1wOjlkZKhCEZdojVNXCvgQrG8ZeCp
	l83iyO7+czQt3amc810PSYN8bvLkvknZqCStzNitrMoIMZkiC1dh2VXoiepLjPBrUVoN5sh9eGJ
	qXy+8tM/IXxSZFDSggXbbJ2K3zWyVU/2ubLLTPFBfzDKoV1eOL/DSdAcGXV2zH4FjC/F9/1mUDM
	mQFfc9dri7pl8RUuOCg4fTF27nhCobNk2YSUK3txYpyWLYFN0oJBUtbjE8az7LiiSbjjgDyKTRw
	2zX/8nWcig2HeT1x887nSKHKTyO6sQbZM56x80+5mtA6uBgvQdTn44kn2C7z0++CzQ1Xxs2qIS5
	1CWKTd6imjNEHOvGoxk4Ka+olT5clFIl5XPDFO5imo7wSpa8yWdAxQ=
X-Received: by 2002:a17:90b:3e46:b0:393:194d:5366 with SMTP id 98e67ed59e1d1-39d70a5931bmr11901184a91.10.1789038213696;
        Thu, 10 Sep 2026 04:03:33 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534152sm50133517eec.10.2026.09.10.04.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 04:03:33 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 08/20] KVM: selftests: Use the innermost page allocator API in the memslot perf test
In-Reply-To: <20260902164123.2546762-9-seanjc@google.com>
Date: Thu, 10 Sep 2026 16:30:42 +0530
Message-ID: <a4pp1icl.ritesh.list@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-9-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Sean Christopherson <seanjc@google.com> writes:

> Use the quad-underscores physical page allocator API in the memslot perf
> test in anticipation of converting the outer versions to take the memory
> region type instead of the raw memslot.  Stating the obvious, the memslot
> perf test creates and allocates from multiple memslots, and so can't use
> MEM_REGION_TEST_DATA to communicate which region/slot to allocate from.
>
> No functional change intended.
>

yup. Indeed the later APIs will drop the memslot argument from the
main/outer page allocator APIs, so we need to use the
____vm_phy_pages_alloc() variant here. The change looks good to me.

Please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
