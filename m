Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125C821364
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594113; cv=none; b=rZhg6NHGQZPbN5B6xxjPeIFj2bj8w1MK9PbSHGTA0SRuyuOhuBxrteLuSi3ancD1hlwZSHUOEPtqhxjmf00/tPzKyAlPD0/ls0AC56VLj3GiewH+SiIeuq48eyIao+Lx1IIP1vuw+6bFMkTMcsPtgemN5ly92SovSD7PE/o2Ye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594113; c=relaxed/simple;
	bh=5eGGDSk4BD3UY2fAfn703dVtF9ub3OwUFQVO9EkJFY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S1J/BR8IN4/ljWwhFQ3dNcPA1m4lni1Ub+yVynFqt4GZNf8joyk1xHRU5cCfDe5DNTuS/N2JrYNzCCG3998imVMtbGJUlkFtvYDpZ8kEMgb7YMm5kG7zslHyDh8mnVNtCT5n5WJ/bSJX5F8dNsDt5FxYAjendGzg2M+9K3ECXwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FjwtJyUC; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FjwtJyUC"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcbee93a3e1so728981276.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594111; x=1712198911; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9X/k4Ur7ktRAsFVEZTgADbEiXncvofPy+APEnCk0Uuc=;
        b=FjwtJyUC9fMcrohbzRFycGQESTFy0m1fNJjBeoRvq3s9N3igYU82evUqhopkDMqPdn
         X5prEniFsi2dXEravXnodxW695Oj3mMOH99zPYfXO25DXAgd7iXz3p9+mbwfjOjBvVDw
         pzb+TAYjqQHWyUvcRa8AhW8iu+c5tlxLejLgbZz365EsSngvjFWIru+PjKzrgw1ltwDW
         gkRc/k6iTEF3hpy/ODzs1IDnuu8pieRtjYxwE8eBN02nLQ4MyJCMHimazRsDcZJGiPgJ
         +I9owpdDrOz0mpRy3qN1xJOTwIHVJIsa49aGWJSdLOsZbHI6Ud4BP8rdR2iDfFFLM5IB
         bazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594111; x=1712198911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9X/k4Ur7ktRAsFVEZTgADbEiXncvofPy+APEnCk0Uuc=;
        b=nMNBU+0PY01VttMKqTXCNbVKXrqBOqbRlXArfHkkuv8FaRV76suRW4ZQBJc19F8IxK
         oJ7WF2yYz8ohtMYlgd1dkI3v3V8ga+pVRNjKB3PYv7fiGFsWURMJUuKTOQmKFxI3XT1K
         jGjbEy8Q9Z2piQzssF0MPFIdQCld9AmVd3xj/m7uA5K/3Mu7AGStY1EVn3M2x88Xhrhb
         3+Ryc3zRvhJn2bB+Fy4sWxuGrWY8NgLZHsQACi/U733q34zCsp+bshQN9PFZDLvCjlMJ
         i2cB6g1ONy15TKvDZvn5mghQVbnc5gNx2K8R8Iyss9VpRuLhhQfmc9/yYF4SkgocyVar
         YNyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAuPCX/P0y96J4EexLRG196Q22BzqC1ZZDOSh93amI4H4M8v45vOPPLe3ZyAA+lWWJiXXnPCjwTTEh3DhzhcXWPGc7TA3y
X-Gm-Message-State: AOJu0Yzxj+7L+VTvnDLdynF0bt0v/u2Y0hnaVibBFK50G0RI++BcAvC2
	ciEeqeZ32TJpxO6pXbpqbHxjB2AU7WlfuIgRh0r0D/LD3Kseyx9SZ7AT2aPjf/BxlEEu3SL/4kn
	aI3WKts+jgEJNqEW69hGuFg==
X-Google-Smtp-Source: AGHT+IHCBcXGdwnKOw373UKcOQTGGrOXXtILBB7knODDR6g2De9IJeAdRjNIMJCvIjU14tTQdEZAyXnNc8ki3rX1vA==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:260b:b0:dc8:27e6:cde1 with
 SMTP id dw11-20020a056902260b00b00dc827e6cde1mr124693ybb.5.1711594111169;
 Wed, 27 Mar 2024 19:48:31 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:48:27 +0000
In-Reply-To: <20240314232637.2538648-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-3-seanjc@google.com>
Message-ID: <diqzle63kr5w.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 02/18] KVM: sefltests: Add kvm_util_types.h to hold common
 types, e.g. vm_vaddr_t
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Move the base types unique to KVM selftests out of kvm_util.h and into a
> new header, kvm_util_types.h.  This will allow kvm_util_arch.h, i.e. core
> arch headers, to reference common types, e.g. vm_vaddr_t and vm_paddr_t.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 16 +--------------
>  .../selftests/kvm/include/kvm_util_types.h    | 20 +++++++++++++++++++
>  2 files changed, 21 insertions(+), 15 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/kvm_util_types.h
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 95baee5142a7..acdcddf78e3f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -21,28 +21,14 @@
>  #include <sys/ioctl.h>
>  
>  #include "kvm_util_arch.h"
> +#include "kvm_util_types.h"
>  #include "sparsebit.h"
>  
> -/*
> - * Provide a version of static_assert() that is guaranteed to have an optional
> - * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/assert.h)
> - * #undefs and #defines static_assert() as a direct alias to _Static_assert(),
> - * i.e. effectively makes the message mandatory.  Many KVM selftests #define
> - * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE.  As
> - * a result, static_assert() behavior is non-deterministic and may or may not
> - * require a message depending on #include order.
> - */
> -#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
> -#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
> -
>  #define KVM_DEV_PATH "/dev/kvm"
>  #define KVM_MAX_VCPUS 512
>  
>  #define NSEC_PER_SEC 1000000000L
>  
> -typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
> -typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
> -
>  struct userspace_mem_region {
>  	struct kvm_userspace_memory_region2 region;
>  	struct sparsebit *unused_phy_pages;
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
> new file mode 100644
> index 000000000000..764491366eb9
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef SELFTEST_KVM_UTIL_TYPES_H
> +#define SELFTEST_KVM_UTIL_TYPES_H
> +
> +/*
> + * Provide a version of static_assert() that is guaranteed to have an optional
> + * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/assert.h)
> + * #undefs and #defines static_assert() as a direct alias to _Static_assert(),
> + * i.e. effectively makes the message mandatory.  Many KVM selftests #define
> + * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE.  As
> + * a result, static_assert() behavior is non-deterministic and may or may not
> + * require a message depending on #include order.
> + */
> +#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
> +#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
> +
> +typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
> +typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
> +
> +#endif /* SELFTEST_KVM_UTIL_TYPES_H */
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
