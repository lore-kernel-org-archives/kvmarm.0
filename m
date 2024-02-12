Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C92A39FC3
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 12:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707740653; cv=none; b=toN87a4pha0U9jOXjqjI5X+uLIa8aCDeNV9NqseOXWy6YY9YR5Y5On/ikSaEnfRr7GIG5n071Ct06WkqVqBw0klXRGxNt+bQ/X9DDYjKNnjC6SzMH8mQ+bGUmRbyOvlgQ4Ntc080HS+Tm5fPhh/vFFiPqVU5CctgQS7Y5WsprpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707740653; c=relaxed/simple;
	bh=enGcxkA/imgb+5ygnxbIY0QQCaD86a1hixHI14ZUv1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s/KLyY5HgMKNp/aIhl29tpsyi/GiVFBsqCIQGZ3gXzZ9nP+QQsRXbPNdWgz1DsLB+uQ9C3/veGnwDVIFn+lxBF6Ntuzsn742/TGfYAYZrN40c7Uao3m7AWeRmAmg9efHYHexdaw59DkDpPdzhN0LjX/cmbnsSQlfBRN+8Gu3ct0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=LJzpd69E; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="LJzpd69E"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3640487d9c4so3104365ab.3
        for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 04:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1707740649; x=1708345449; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CQJAbVN1hEJxIfRK6BeBiBHbVNEAmKsPHC3r9j+pPA=;
        b=LJzpd69EZX25EyMpZUflvSDuegq+oPK5yABd5l4MV/FsSWjc2dvrgwNlLD3g7cXEoT
         3AWzWz2X4f5r7lxHjiNni8PvwkVjs+YtHXousg/nRijSit/yfgMS1u17EGHJeyPvJP1Z
         e2JXg7QkdYc6cYEAtdOprmSVPyavsaWoNSmg4vo0V7ULV706W0nvFcUH8f0BOLOcjpO9
         f4xlcFdy+EKMOLjG7WE77HfROKHenOvmb7lC7p5S99UTwPRxxRyRK8025Tf1a3ai5RaQ
         TAaPZOoXGf2qmoGjPPY/55wm1+lVdJuuGjnXqdIAX+rr6WBOCSCk6N8vnGL249+QKuN7
         zUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707740649; x=1708345449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5CQJAbVN1hEJxIfRK6BeBiBHbVNEAmKsPHC3r9j+pPA=;
        b=Z3KvW/SykOsR3b5BOlhOoMf1yEUDueUjKGDCBAyEZVnzjRnYxsO3QVcsEiiPBZCsiW
         W9+S/zGuX6R10Luvl1QfwJXRi7rn6CVYYSeplZbMhkN6FBAdGUDd+v8IUY05U1GarriS
         qDWfsA9LjzEFwKjTyHYNYihwtd/G1/Re8dLlFcc2RDPiG0nHrzhpDOeu5XLmV5bWdDVC
         abVJavs4+7Cxc9LmVh2HMsvlFTjxBleBqvMqJ9H14UFoWXbCv6F1WUDrprIuQl5o1Vmj
         wQWb54oZIKzVXxujLTztSX4Cf+DF8OhxKmaFeFQhJDpzwqTCeLXT7XnQkRpb4euGyuTJ
         V2Wg==
X-Gm-Message-State: AOJu0YzEO+d80Jju0DtE5PNbWQ/1jlrS1DW9CS75uBLGiPqhQkmd2+RO
	+BPrQtKlnQ4bEu0wtXWOa/4D+f56d9MduJlQl5ANvyrirWyucw+tHmbuE7xlABV5wInOTnLZboj
	PBRE2J8SmJt9tgwI5y8T12Fn6/VM4PhCxS/0sEg==
X-Google-Smtp-Source: AGHT+IGzhXfq5zT3FYgC1LPkY3wsC1WD62YVWVgEP5W8s001037XANdQn59nNXrbCGSEhsi8pEoYiewroYfMiW87JoM=
X-Received: by 2002:a92:caca:0:b0:363:e7ff:f378 with SMTP id
 m10-20020a92caca000000b00363e7fff378mr8506844ilq.28.1707740649498; Mon, 12
 Feb 2024 04:24:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com>
In-Reply-To: <cover.1705916069.git.haibo1.xu@intel.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 12 Feb 2024 17:53:58 +0530
Message-ID: <CAAhSdy2wFzk0h5MiM5y9Fij0HyWake=7vNuV1MExUxkEtMWShw@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] RISCV: Add kvm Sstc timer selftests
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, ajones@ventanamicro.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atishp@atishpatra.org>, 
	Guo Ren <guoren@kernel.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, wchen <waylingii@gmail.com>, 
	Greentime Hu <greentime.hu@sifive.com>, Jisheng Zhang <jszhang@kernel.org>, 
	Samuel Holland <samuel@sholland.org>, Minda Chen <minda.chen@starfivetech.com>, 
	Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, Thomas Huth <thuth@redhat.com>, 
	Aaron Lewis <aaronlewis@google.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 3:15=E2=80=AFPM Haibo Xu <haibo1.xu@intel.com> wrot=
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

Rebased on Linux-6.8-rc4 and queued this series for Linux-6.9

Thanks,
Anup

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
