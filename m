Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D135218E05
	for <kvmarm@lists.linux.dev>; Mon,  6 Nov 2023 11:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BKrKLzPq"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-579de633419so51970147b3.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Nov 2023 03:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699271092; x=1699875892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DX7ek6JbnQBP3kmz+KR8GNUYI0kM1PtX+UUHfn3vax8=;
        b=BKrKLzPqDcea+RUtqCy42rKvmdE2pBf+/gDBXBO2a++gbQRLcBdaQZ7HEl6F+SXLJs
         4OTpSpQpIzFVIHLpoEyxz2bWdnc5JDkYCzkWJmgRwEm2K31+h0xrmA5zWQ0fwt2dEB1m
         +7pMBTip1tvsv+18LZIMAo8fnSHXi0RAIUCKcQUXS/ODK3KoyrXECTuBiGXssiq3OTtX
         MHU33ZT3wr2AzvlkXfOHyNWij6/UpSpBK7KyjfsH/3L0wPtY1IfZtByI1Zz/aC3elHex
         O1YM7cH2ti8RPsIrFbz69m9GxQ+cW51X+4S8QG6gG0fckKCDXEOzphFUS1XcGFMhYIkX
         jPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699271092; x=1699875892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DX7ek6JbnQBP3kmz+KR8GNUYI0kM1PtX+UUHfn3vax8=;
        b=L/mZDxhb5BoJcbNxFk3YQ/6Enhwrc9F9jhGugWePWQ+QmqZBsm97xui9L8i11D0F97
         3GjNDH5uH8xTTcBcpy6X48IdcrYhbk9kNRAHkZsPAuy5RcJPOK/KYmE2+7novYr+Tveg
         L7E6dU8DqW7jfXlZdUOXaBWDfDJkqCVLViSS23gvoy7ZW9+e9exUs/WTYluqNTQX9aEa
         dMP9utYGgw7tjxr3/Cl20y+Yyd7yGsSGXWdZWlfJEbcaLB7Fzy/eZOF9pYM5nR9FUa71
         3yCp8UsYS78mwfTEyUNdhSkwuMS61W6H7ydT/tikQDLV33xcgSlVYZlFgSfPeB8lk+zj
         Cu/Q==
X-Gm-Message-State: AOJu0YwLw1k5VY8FF447TRtGkeEJI3Y/7qNdnYNCnJc0JXgizYmMTNA4
	QqoARs16EoHniijovSKREMijgvouAlFVxbqkbrUgZQ==
X-Google-Smtp-Source: AGHT+IERnN25ZpQWhSoveHYhjH1bHINt0TuAVLiTz7wZcF5ueihZgXoSAZV3dV6i7b/f23cd983VPNMQFTyQCDpDsN0=
X-Received: by 2002:a0d:ccc5:0:b0:5a7:e4fe:ea3 with SMTP id
 o188-20020a0dccc5000000b005a7e4fe0ea3mr10768851ywd.22.1699271092440; Mon, 06
 Nov 2023 03:44:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-27-pbonzini@redhat.com>
In-Reply-To: <20231105163040.14904-27-pbonzini@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 6 Nov 2023 11:44:16 +0000
Message-ID: <CA+EHjTymGLsfHvdP4fPOFWTtaRwbtbCOBZ0XOC3gsX+nYm-cZQ@mail.gmail.com>
Subject: Re: [PATCH 26/34] KVM: selftests: Add helpers to do
 KVM_HC_MAP_GPA_RANGE hypercalls (x86)
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 5, 2023 at 4:34=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> From: Vishal Annapurve <vannapurve@google.com>
>
> Add helpers for x86 guests to invoke the KVM_HC_MAP_GPA_RANGE hypercall,
> which KVM will forward to userspace and thus can be used by tests to
> coordinate private<=3D>shared conversions between host userspace code and
> guest code.
>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> [sean: drop shared/private helpers (let tests specify flags)]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20231027182217.3615211-29-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/too=
ls/testing/selftests/kvm/include/x86_64/processor.h
> index 25bc61dac5fb..a84863503fcb 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -15,6 +15,7 @@
>  #include <asm/msr-index.h>
>  #include <asm/prctl.h>
>
> +#include <linux/kvm_para.h>
>  #include <linux/stringify.h>
>
>  #include "../kvm_util.h"
> @@ -1194,6 +1195,20 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, u=
int64_t a1, uint64_t a2,
>  uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
>  void xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
>
> +static inline uint64_t __kvm_hypercall_map_gpa_range(uint64_t gpa,
> +                                                    uint64_t size, uint6=
4_t flags)
> +{
> +       return kvm_hypercall(KVM_HC_MAP_GPA_RANGE, gpa, size >> PAGE_SHIF=
T, flags, 0);
> +}
> +
> +static inline void kvm_hypercall_map_gpa_range(uint64_t gpa, uint64_t si=
ze,
> +                                              uint64_t flags)
> +{
> +       uint64_t ret =3D __kvm_hypercall_map_gpa_range(gpa, size, flags);
> +
> +       GUEST_ASSERT(!ret);
> +}
> +
>  void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
>
>  #define vm_xsave_require_permission(xfeature)  \
> --
> 2.39.1
>
>
