Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3F4472543
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039689; cv=none; b=si7XlNJIaHRVEvdTI6K398hU6XzGEX1xDRamAqTMmjYTHNc+xPC0/l7PSrKq/Pq6DfD08SZauhCeNrF1C3ScYdlHI0bbpuVtQ/MahL0+yHsChZNuqhEGyrpzajN0QsEj+zqRzd56xqqTqMeKHQc9d2Ff34j4suy3rzURRpVs3YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039689; c=relaxed/simple;
	bh=Rdvn6SlWN1pYD61UCQmrt7vWGIUZg8DLzgLld4sc614=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=hueGXPlR/2VvtSXSByCW+wr5Q/NMxVU+WFvLf00VDb46W47rUFhXIeJY3Jxc3PgVRAdEKwg4YmYMMeI4CCGg9SSRpYPSdx5amyWwiBkMhY/11TvohxI9ps/sjEkqvM6FUkXIIY8H+f34Rhh3GdHzyjHEq5ZvNa5v2JnB0kuQamg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g3fx208q; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g3fx208q"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7f48c750afcso6272064a34.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 04:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789039687; x=1789644487; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Rdvn6SlWN1pYD61UCQmrt7vWGIUZg8DLzgLld4sc614=;
        b=g3fx208qu0u1kyqQsSIXq7ASD4vHT7Z3WvZVACvloM7AggOw3mvxdHsONGEeypjUBQ
         PO9KqX82F3svqqc3Qa+1xLASx2n9kRa3WZfXp1c+H7Og6nqKLKW8lwrVLF0Hc6p9rWXy
         mjGJF9Qe9S6sn3WQirmfTYkU8TjoTU2gfAn481+5vWlH8TX+bGsbKirc9YpuunNqJOIq
         eY+Z8nTxf+h2Knk+zw4+t1js/NKjPDF3ekDmTc56BS0z0Oqwn4AibabeQ6BKtoD6ym3L
         CdrkMYEpC1Dsore808WvqIdEm2rN13Ky3C+DKKa8grMyYIq953mTf0sRw5B1sxXbxmIm
         s2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789039687; x=1789644487;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rdvn6SlWN1pYD61UCQmrt7vWGIUZg8DLzgLld4sc614=;
        b=qg4+HAtFafqAPNIMcJWgDe6aFF0DefKi1HA7Vc6HyJmfUus7Om3HrLjCaIk96tgsRm
         dVn0mpfbK17q+hVtpQREuS/vqD8lUItZsgfPIoBfU3wOo66nOHXt2HGZNL0FUtdelNuU
         wO1+DeF4lyJraA6YRDpYIGg4yJaVMsUMiNwZvnyncM0UDCdZQQEk2/gtaL3sM7CZF4Yq
         hm1LU/GBMsIccTReECT6JBghb8bY6Kz1jBgZzXILkvbuml+IY7YE7MLesMerqJgEFJln
         abXsLG7fAWjbmJf8Jcv6UGi5kSXbAySkTNtzDHGG8l0/fa16A/cDHaUuxPc7zqsi5HyF
         cFEQ==
X-Forwarded-Encrypted: i=1; AKwUvBxUXcAbuWeu8UO3qoX9GtbmWopMvC7RNzFMDN0LB3qzqUrw2QHTHo76TyazzHPj1vmhTDg0ams=@lists.linux.dev
X-Gm-Message-State: AFuF++nCpfU4Al7M+wugZcUBLJtvcL0BYW0KNuECAguT5hLW9o7rSaFP
	wFrkOD2gHJzmnIyWylTzHRGKI5qCuHLOCETXPMrPwE+vpl7cDfF2/9oQ
X-Gm-Gg: AYBFou0XqKjB9L+BHJQMgywGXIA9R8qQ//ul5cN1MvE4dvUN7fkOfQDoxMbgJiHwxOt
	cuIVQCpd/2N0xGGk5NX/Bv8MUUVvVafAXUiV/udvnJxrP5YpH8ZVfFQcAD+6P29YI9eAFcDtUdX
	5qnzy6UChqSSlnHjEe8XJguEpX+GU0Vu9nCdOpolX1ykuPwR+0qhnGjmCdeIg+u5mnD3Rl2TvUG
	MdctnkRMFV3yGz6z5vyXBSG1BCV/5HBOqm8w1UDNY1Rm4A41u7r2ieAmo5KkB1w0Oe6ye7M5Uc5
	pGfD3Si45slNVacpO6d/wB2ZDwnflwPMICrEJ0asNUehEaswJHsUeb+UbRFQ0M6dKdaUM0hKzOG
	fKq8ZSpexlxpSbEIaBW9j2cJWkuLwoPVNgObp+/MtBrPqfJX3Qjemr2E2gLZinLi8sEGKgbi96G
	45GRGnoDr8taan2bwa8lqA20zR7EZnqTCJQYjdx4k2ZXrmYWcOohGJK91AVl2gxrHUoMp8MQdxt
	X5rz1/vE3JkliKGX690X41CekfOBn63huTIikTdInX9w7KitECNx0zaLgrzQJZokg==
X-Received: by 2002:a05:6808:f09:b0:4b2:8ee8:8a38 with SMTP id 5614622812f47-4b95db6da80mr27637088b6e.0.1789039686755;
        Thu, 10 Sep 2026 04:28:06 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14332405e92sm49398440c88.8.2026.09.10.04.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 04:28:05 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 18/20] KVM: selftests: Use TEST_ASSERT(), not assert(), in vm_get_mem_region()
In-Reply-To: <20260902164123.2546762-19-seanjc@google.com>
Date: Thu, 10 Sep 2026 16:57:29 +0530
Message-ID: <4ifx1h3y.ritesh.list@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-19-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Sean Christopherson <seanjc@google.com> writes:

> Use a proper selftests TEST_ASSERT() in vm_get_mem_region() so that bad
> input is guaranteed to fail the test, and with the standard error message
> format.
>

LGTM. Feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
