Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7992100
	for <kvmarm@lists.linux.dev>; Mon,  4 Sep 2023 11:16:02 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-31c6cd238e0so1331280f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Sep 2023 04:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693826161; x=1694430961; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9GCAlEvdvaQhIuQIQlH6uZieVhDq0JG0Q/Lab40q3Y=;
        b=C2DiJEgo+izRqXXCIvea2GOKj2r73lCF+zHtd+837opPJcGZGXGHMsxOIsMwZ2wY/2
         qyprdwEmfFRjIYnzB2dFI5EdC9JDRo2LVCXquUCW5PnBYeihf/wYOkQIfcw9j1iuo98V
         IV3XhIunTMy1vEcRiqOtyDcbhFUS0hSBfnQR2FX2kNGM2dvRW+Lf0QN25D0fAAVa2kTR
         778R6Nw2vzBRBwlV5pUn0epdIs7D5xYMNUkQF4gUFswGaJLDyteoDuM9QuYSKiScIBRY
         DxXVvOhktAOX3YG+UH20DIsSPMRMvqwxhSyulOmVyO0s5tXp/TFO/uLE9pVHwV+KYeru
         LOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693826161; x=1694430961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9GCAlEvdvaQhIuQIQlH6uZieVhDq0JG0Q/Lab40q3Y=;
        b=SshKymfNr7Us2WTHG4SXtUjDNyLFC/0k0tQNhWdEvZ55eHSPTZXkB3ViOKIc9q1WuH
         +s2v2QOrR57ssYSnMqLblvhoX5NEUa0UjiGlZ6A1kH6cAAtN7DM06hFGegD4DgkZkMsu
         5HRoCacfdmIjni7cxkdqkV3dBXAp7cs+kbYmCWTkGc2X1SQoLChC0ve74z7VvmKKosCf
         fn/VNBetpIwfTstNQcPkV7ElyhZZqVc1TrTpJCk/GUzUStV2Hv4W4LUQbrZAeBAg2Rxd
         UoEYWo4OlIuXpTFBCKRIiROP1II1wKZTffJR9h4ygdRkwI0er4EDBBknfwoZgH0kfmLZ
         rtoA==
X-Gm-Message-State: AOJu0Yy1Ajb9cTusv+etNnMReHVFMQ1wukFk1ccbIjA+jIqAT3SrU8CS
	UyGATGVY4sesTQpZm07UC9sbkQ==
X-Google-Smtp-Source: AGHT+IHR3qJF/WADy7jFXe6yIqtW0lGNRVyiw5VlYSS4H2pPf8Rp4EorJnHY9mZBl7rKv7MV9xXpWQ==
X-Received: by 2002:adf:ee90:0:b0:319:6b56:94d9 with SMTP id b16-20020adfee90000000b003196b5694d9mr8511545wro.2.1693826161050;
        Mon, 04 Sep 2023 04:16:01 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id x18-20020adfec12000000b0031989784d96sm14281097wrn.76.2023.09.04.04.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 04:15:59 -0700 (PDT)
Date: Mon, 4 Sep 2023 13:15:56 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Sean Christopherson <seanjc@google.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Greentime Hu <greentime.hu@sifive.com>, wchen <waylingii@gmail.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Matlack <dmatlack@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Lei Wang <lei4.wang@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Like Xu <likexu@tencent.com>, Peter Gonda <pgonda@google.com>, 
	Thomas Huth <thuth@redhat.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, 
	zhang songyi <zhang.songyi@zte.com.cn>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 1/8] KVM: selftests: Unify the codes for guest
 exception handling
Message-ID: <20230904-ba5051a5bf17d17f2711d7dc@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <7affb0387d7272573f7093de7887872e1fb5979b.1693659382.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7affb0387d7272573f7093de7887872e1fb5979b.1693659382.git.haibo1.xu@intel.com>

On Sat, Sep 02, 2023 at 08:59:23PM +0800, Haibo Xu wrote:
> Rename the vm_init_descriptor_tables() and vcpu_init_vector_tables()
                                             ^ vcpu_init_descriptor_tables()

> prototypes to vm_init_vector_tables() and vcpu_init_vector_tables()
> respectively, so that we can use common names for the architectures
> (x86/aarch64/riscv) and then put them in a common header.
> 
> By the way, vm_install_exception_handler() prototype were also moved to
> the common header since they are commonly used across the architectures.
> 
> The patch is a preparation to share the guest exception handling codes
> in riscv.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/aarch64/arch_timer.c          | 4 ++--
>  tools/testing/selftests/kvm/aarch64/debug-exceptions.c    | 4 ++--
>  tools/testing/selftests/kvm/aarch64/page_fault_test.c     | 4 ++--
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c            | 4 ++--
>  tools/testing/selftests/kvm/include/aarch64/processor.h   | 8 +-------
>  tools/testing/selftests/kvm/include/kvm_util_base.h       | 7 +++++++
>  tools/testing/selftests/kvm/include/x86_64/processor.h    | 5 -----
>  tools/testing/selftests/kvm/lib/aarch64/processor.c       | 6 +++---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
>  tools/testing/selftests/kvm/x86_64/amx_test.c             | 4 ++--
>  tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c   | 4 ++--
>  tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c         | 4 ++--
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c      | 8 ++++----
>  tools/testing/selftests/kvm/x86_64/hyperv_ipi.c           | 6 +++---
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 4 ++--
>  tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c   | 4 ++--
>  .../testing/selftests/kvm/x86_64/pmu_event_filter_test.c  | 8 ++++----
>  .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c        | 4 ++--
>  tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c     | 4 ++--
>  .../selftests/kvm/x86_64/svm_nested_shutdown_test.c       | 4 ++--
>  .../selftests/kvm/x86_64/svm_nested_soft_inject_test.c    | 4 ++--
>  tools/testing/selftests/kvm/x86_64/ucna_injection_test.c  | 8 ++++----
>  .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 4 ++--
>  .../kvm/x86_64/vmx_exception_with_invalid_guest_state.c   | 4 ++--
>  tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c    | 4 ++--
>  tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 4 ++--
>  tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c      | 4 ++--
>  tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c      | 4 ++--
>  28 files changed, 66 insertions(+), 70 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
