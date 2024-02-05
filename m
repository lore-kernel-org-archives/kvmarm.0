Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6054168D7
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 13:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707138642; cv=none; b=DC2HWE20qm1X6TiSZ2A31MFBOS5mC8iDgOo037RAuxovMlm+mf/7bd8vbDK4SH3/DQ/1bCYnVqMGNeAbVOxa8tNvcl/aQTPEdqj0eSzyDnIIj1378Uf969SBhILQcXlDjCD8cXTw0t45+HSOJfsdUCBoEbUqSr8V7UpDt2IWfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707138642; c=relaxed/simple;
	bh=a7C8ciPQZp5QzEHWJtui24Jra/hcnLQehMJdzgp1ngY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CnD4stc16BkjPA4uHMcbN3RZAh7UYBtlvP0J5c6RXGlOzK0aXE5zdW5PKtO7Bx6CByNg+gDb0VshwTNRfb8wxWW581ZIESRJDzTtwo9djiD0tF/hHT9qU1FdeaUVeOVwt0yVJBj0IpZzlBXsIqujekPs0IYKTIC1Hh6w0JrYgxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ATS2GVH0; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATS2GVH0"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-511413e52d4so2367650e87.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 05:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707138639; x=1707743439; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l52wGRJpdNZd5ZMPG8emXQNk5j5Wmg7cRfJ4UIcR334=;
        b=ATS2GVH0qi87upvTDjQ7uf5D7OgMwY90Iuhfh+6zQEEh16nChdjmXxFEhOWrHEIVlp
         L5mCbEsToEUspr6nea+JAuQMUANrtjQO13PUkdNax9bfgsbWxcoCLL4AkCwq3W4rwrEh
         5O991Q28VZb7dT5A8OLtlitSpQC7cDaY9pQsoFzcxoHQ3RbXkdiG2ARduo8S6zkKHBwD
         feY/rnRsPVyAxKuHbwaydYaz+OkViADwv9W5OMOEhcgaGew/h++0A7DhDUX5ixZusAUL
         UAnkKVOAzSiZunDxErfdJStY5HBXCNz1gprVTeFJSb/IQ1z9EVI78b/y2IrZ9zkzAz1l
         gcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707138639; x=1707743439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l52wGRJpdNZd5ZMPG8emXQNk5j5Wmg7cRfJ4UIcR334=;
        b=YlhG9pBYeFW0lx0SXFum25LJJlWMWRzY6gXCqgdbNeapXkxptOiKZxuj0kOn+gPIEa
         qQ4Ug3WLtb4YsBbbDCTUPSF4Xrq04/wOibi5/Ai2rm009L+KqFQpbaqdLVcToSnj+ZCe
         WMfS09Vne8ubw/glRURFa3JjJtqkMfnW2qU4PMtQSJhPCmN7O9uilOoMkT9dc51vRQ+p
         tK6JAeZ+O5IT+q1lN8soCFV/5Gc22YDrTKbrw10qyqPO5ryrudn8tmhcKiyuP8UhHl/V
         hPtXp/646uSdpA2EvuRyUevlCm8OlNsLR4fftNIVXIXutAgSlZfhWEhTtCloDYyFG1sk
         o/9w==
X-Gm-Message-State: AOJu0YxuhnWKRUNM71vIoFe3VNAw9xBSgTo/0/hUrqgw/1288wNqnTii
	TCuBn24SCQ56f8Sk+MHzuNaeAyjPq389A8s6jMkaucFq+6t+uaGw5KE8GR/AVp5PXBtQLgua+H2
	i/pv37Ps2uFT2wWqemMo6AWvzKUA=
X-Google-Smtp-Source: AGHT+IHcjgafryspZvflYvXmNwPr/1ZTRC4o5v0aRZqmLV0WFqjr47M7EyynLPGoweDD8l30req/4VrqIPpQvTK6l0U=
X-Received: by 2002:a05:6512:1150:b0:511:4e0c:bc3f with SMTP id
 m16-20020a056512115000b005114e0cbc3fmr2466365lfg.51.1707138638651; Mon, 05
 Feb 2024 05:10:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com>
In-Reply-To: <cover.1705916069.git.haibo1.xu@intel.com>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Mon, 5 Feb 2024 21:10:26 +0800
Message-ID: <CAJve8onDbX44Ph6a-FdO2+p7QOQLah-7OyF+yUc06wud+SvmQQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] RISCV: Add kvm Sstc timer selftests
To: Haibo Xu <haibo1.xu@intel.com>
Cc: ajones@ventanamicro.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	wchen <waylingii@gmail.com>, Greentime Hu <greentime.hu@sifive.com>, 
	Jisheng Zhang <jszhang@kernel.org>, Samuel Holland <samuel@sholland.org>, 
	Minda Chen <minda.chen@starfivetech.com>, Sean Christopherson <seanjc@google.com>, 
	Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, Thomas Huth <thuth@redhat.com>, 
	Aaron Lewis <aaronlewis@google.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

Could you help review the first 3 patches in this series?

Thanks,
Haibo

On Mon, Jan 22, 2024 at 5:45=E2=80=AFPM Haibo Xu <haibo1.xu@intel.com> wrot=
e:
>
> The RISC-V arch_timer selftests is used to validate Sstc timer
> functionality in a guest, which sets up periodic timer interrupts
> and check the basic interrupt status upon its receipt.
>
> This KVM selftests was ported from aarch64 arch_timer and tested
> with Linux v6.7-rc8 on a Qemu riscv64 virt machine.
>
> ---
> Changed since v4:
>   * Rebased to Linux 6.7-rc8
>   * Added new patch(2/12) to clean up the data type in struct test_args
>   * Re-ordered patch(11/11) in v4 to patch(3/12)
>   * Changed the timer_err_margin_us type from int to uint32_t
>
> Haibo Xu (11):
>   KVM: arm64: selftests: Data type cleanup for arch_timer test
>   KVM: arm64: selftests: Enable tuning of error margin in arch_timer
>     test
>   KVM: arm64: selftests: Split arch_timer test code
>   KVM: selftests: Add CONFIG_64BIT definition for the build
>   tools: riscv: Add header file csr.h
>   tools: riscv: Add header file vdso/processor.h
>   KVM: riscv: selftests: Switch to use macro from csr.h
>   KVM: riscv: selftests: Add exception handling support
>   KVM: riscv: selftests: Add guest helper to get vcpu id
>   KVM: riscv: selftests: Change vcpu_has_ext to a common function
>   KVM: riscv: selftests: Add sstc timer test
>
> Paolo Bonzini (1):
>   selftests/kvm: Fix issues with $(SPLIT_TESTS)
>
>  tools/arch/riscv/include/asm/csr.h            | 541 ++++++++++++++++++
>  tools/arch/riscv/include/asm/vdso/processor.h |  32 ++
>  tools/testing/selftests/kvm/Makefile          |  27 +-
>  .../selftests/kvm/aarch64/arch_timer.c        | 295 +---------
>  tools/testing/selftests/kvm/arch_timer.c      | 259 +++++++++
>  .../selftests/kvm/include/aarch64/processor.h |   4 -
>  .../selftests/kvm/include/kvm_util_base.h     |   9 +
>  .../selftests/kvm/include/riscv/arch_timer.h  |  71 +++
>  .../selftests/kvm/include/riscv/processor.h   |  65 ++-
>  .../testing/selftests/kvm/include/test_util.h |   2 +
>  .../selftests/kvm/include/timer_test.h        |  45 ++
>  .../selftests/kvm/lib/riscv/handlers.S        | 101 ++++
>  .../selftests/kvm/lib/riscv/processor.c       |  87 +++
>  .../testing/selftests/kvm/riscv/arch_timer.c  | 111 ++++
>  .../selftests/kvm/riscv/get-reg-list.c        |  11 +-
>  15 files changed, 1353 insertions(+), 307 deletions(-)
>  create mode 100644 tools/arch/riscv/include/asm/csr.h
>  create mode 100644 tools/arch/riscv/include/asm/vdso/processor.h
>  create mode 100644 tools/testing/selftests/kvm/arch_timer.c
>  create mode 100644 tools/testing/selftests/kvm/include/riscv/arch_timer.=
h
>  create mode 100644 tools/testing/selftests/kvm/include/timer_test.h
>  create mode 100644 tools/testing/selftests/kvm/lib/riscv/handlers.S
>  create mode 100644 tools/testing/selftests/kvm/riscv/arch_timer.c
>
> --
> 2.34.1
>
