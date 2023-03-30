Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2F08C02
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 17:32:14 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id q1-20020a656841000000b0050be5e5bb24so5612730pgt.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 10:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680197534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nnTxsagUavl4R5aNPiZp2P+s0f7o2Hc1Pg/eKFJp8lA=;
        b=Tbftoqox//lZxbaYckaOW2jLVCOWAr7GWaUOL82qbvrJCy/mMJPuj/3f2H7ZFuS5yB
         hBsKdEhNaqwUHaG/myxU4nSEcTVmPZd22Ai/s2inSUgRjPVi19MqgveLSoH3MXl/zBuK
         2OGO27X0nuriV2ZEcAPrBWGREVHFoUpSBXWZg6PY8pOlLEsU/vTFddtIWnD9UzHN8cLb
         MmaLjPpJF1yTTlI0gwiwKKSVbn+wFGFeAcimW7Bwe03gl2gYgrFS24rBYtHCoAi1/4dI
         IbNBf+BcaCMBhBTF0fa6zR3dswkAI5EeB6i4FNe1DNt5XwrwigVS/lgHxB+U5r6aiuu8
         X3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680197534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nnTxsagUavl4R5aNPiZp2P+s0f7o2Hc1Pg/eKFJp8lA=;
        b=5yKu4x5bPAUfTLgZCFABTIrh4m2NNuqi2MCy3wfKCie5a78wneRJOWQYe6XmitcgwD
         ui2plM+cdXpOr2hV0votsnZMjbTnFdu6Y2JMMne5dtvoBUMxR/u3bTXSX+887CZgCRMB
         tCGz18uPTv9BXAf97YGkuA74hVqDI/a70qEA7+QmP/8PHyoM2P2QuPNzPYJO1O82MYrt
         X3ny++jdROsgTsud+sbXR6xP7NC6skew2boDcvY3u4axfuo+ovrnhUsl+Y5eRlI9M4hL
         UJYJVnXxnY3ZADLcBkhh5BaTxxeLoWoNOt9tuaTamDr4HN4t6zYnyYqGLR99Wj+AHhGv
         0Jkg==
X-Gm-Message-State: AAQBX9c1nCAny+O8W0BQSmmkOl01d9TyY7ve6wVmqfpcRR2lOi4ZTBZo
	kr0JmTqqjp0OnbV5kGkHdE26FD5maBQ=
X-Google-Smtp-Source: AKy350azwWwpDFQd4w8zJIPRbA66xXSs/muh2nz2rtjySYQAHjCaHNE9llrmnCWe8Mcu6uxntD2BlSaMQdY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88e:b0:1a0:7630:8ef9 with SMTP id
 w14-20020a170902e88e00b001a076308ef9mr9302444plg.12.1680197534051; Thu, 30
 Mar 2023 10:32:14 -0700 (PDT)
Date: Thu, 30 Mar 2023 10:32:12 -0700
In-Reply-To: <20230330154918.4014761-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230330154918.4014761-1-oliver.upton@linux.dev> <20230330154918.4014761-2-oliver.upton@linux.dev>
Message-ID: <ZCXHnFz7gB8QJzvD@google.com>
Subject: Re: [PATCH v2 01/13] KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Salil Mehta <salil.mehta@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 30, 2023, Oliver Upton wrote:
> The 'longmode' field is a bit annoying as it blows an entire __u32 to
> represent a boolean value. Since other architectures are looking to add
> support for KVM_EXIT_HYPERCALL, now is probably a good time to clean it
> up.
> 
> Redefine the field (and the remaining padding) as a set of flags.
> Preserve the existing ABI by using bit 0 to indicate if the guest was in
> long mode and requiring that the remaining 31 bits must be zero.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

>  Documentation/virt/kvm/api.rst  | 3 +--
>  arch/x86/include/asm/kvm_host.h | 7 +++++++
>  arch/x86/include/uapi/asm/kvm.h | 3 +++
>  arch/x86/kvm/x86.c              | 6 +++++-
>  include/uapi/linux/kvm.h        | 9 +++++++--
>  5 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 62de0768d6aa..9b01e3d0e757 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6218,8 +6218,7 @@ to the byte array.
>  			__u64 nr;
>  			__u64 args[6];
>  			__u64 ret;
> -			__u32 longmode;
> -			__u32 pad;
> +			__u64 flags;
>  		} hypercall;
>  
>  Unused.  This was once used for 'hypercall to userspace'.  To implement

Note to self, this needs to be updated as "hypercall" is longer unused.
