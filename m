Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FC014A84
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 11:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732273709; cv=none; b=KpEIbu0J8cqhdm5w7N4V/qBT7n3GIrx+913GResu9N2zTlv9jKRRCB1h+7LPvXP0QXpQ0SPoF5g1+JcQRn2j8P0XvOep8n11cUWEOm9oOL6N/kzfLhGcOhLFSToGZ3YN5/H9advD2U8W98MHMSK+P9uHAkxyMYm18FKTjIAC7BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732273709; c=relaxed/simple;
	bh=ThBBfttCQJ+YHr7Rls6VhEbrVuz43yNnXrmuepXBPcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6b0OA3ghEQYk2ieNPgib1566KmgsS99k+nmBh9xGo+pUdyNKnaxvoVfDcF8DVdXkgMHRtR95XrWUGEBf42UbMH/pxkF1yfu+TSvyvY9CkwxerHXa/CPlDqtKh6BWa3jdEtBITnbfzTfQb32PUC943SU0bV0Vg+6oH7c4x0zsRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TgKAvqzE; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TgKAvqzE"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso23052785e9.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 03:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732273704; x=1732878504; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t1Ux0rT2yP6xjvZBgmai8Ou1pKZCW9rFt2YBqF7CElI=;
        b=TgKAvqzErx1wIq2W0/5211wvhtsRyGp7/4L+Qn562UHpaJ2YVljdYkPizxzwmn0XHx
         cncJpYOD913BhuDFhGXbi5Z9GKAFFJRomvlWCTQpeMjXzpLPS/aUezKhFsuCopzFX2UU
         lDChZiX3WOfolpMV764unQxySsHmtffV3TZ0oLH2L5LYFR9un3pXEvzJ7f58aWoVBLHT
         rz23H1nVapS+iPfeCpiUA6VYcwCUeqGTmq3fqMU/eblzWYa7lQ8piRONBa9adUudsc0k
         DmBeSwXC/JmsOtpPJF2X9XpKsJ6WQSjw/trSS8cYpiCJLHzGObNmS0kxiCuvV/vZ5I8U
         C5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732273704; x=1732878504;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t1Ux0rT2yP6xjvZBgmai8Ou1pKZCW9rFt2YBqF7CElI=;
        b=gW7ZHXIO0NY9Ey2l1UKViUJu2OGJX76CFG2uFQdA2rA5OwHxxc7MJaXmOb9DK0dBXx
         6+kzbyjq1fddRB2aZeAcwgPrN44puwJcbE6Sa7KXoq+dN+bBiGSYpHeirgRpmpN4cf4m
         fzSi4Wg5a35xm23pok/8PVqe7x+6NUcZKb1EswQxCGdyZHPpktw6oTgAJCEB16pZZmjU
         EGxzpKVPjn+d/pC+C8k/9fmSWbWiIRZqXrdSamVJDM1BAKVjTbt2YnT79JWuwoPHICZ1
         /jXi1k4zPe07yyOh8HUxiQHaLpwujD75p6dkM1DJJVOfnoxeKFH0v2ojILfXjN2BUb99
         YnjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2oM4klci7CnE4EZpB/joa3jEHSLc+eqsLz3+c/v9AS6s29BQH/0XD9ZYs4mSowtIBMMAcxN0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3E+53UNgEVO2B5RTRYFTF5FX8hFLvPOeEuNq29fQFyoeMx3Uj
	bXcnfu+QqQH5ArwdBqx8GUjdhZDFMBqwauTZarxdAxpx9ktfocstsMjdE+ooKYQ=
X-Gm-Gg: ASbGncvKmc8XUulPWLOrXJ3PvpTgyVAgMa8Jejz1y2f2UA+m6x7NSd/rPGk/tjOSuVu
	YRhtt73dkVmtjx/NjRnH4TMZzOoftcPNXv/kgizXdgJX7Cyu+c0lybhnM/7qke8mGzEhu/Vt6Nb
	6BSYN0KVj/vmrnyb/+RSz2uF2ztrhotH4tiB4jqfTgK+7A86z5b/qPlyBHIznNda0ePUimX+jJJ
	FTUmbc+hHWICjqk6/nzkbsIJZZhKze8NAjlqd87McQ8/jZK3kva0tXrEktKmQ==
X-Google-Smtp-Source: AGHT+IGw+dmvPHSrDCXq/F0RSuSoWDngS2C1EG+R1/yhxXCSIWQQUNBqpRajs8IbtEFFXzG8HkhfRA==
X-Received: by 2002:a05:600c:4f06:b0:431:5f8c:ccb9 with SMTP id 5b1f17b1804b1-433ce426a01mr23511215e9.17.1732273704247;
        Fri, 22 Nov 2024 03:08:24 -0800 (PST)
Received: from [192.168.68.163] ([209.198.129.246])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-433b463ab1fsm85701975e9.29.2024.11.22.03.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 03:08:23 -0800 (PST)
Message-ID: <5edb7c69-f548-4651-8b63-1643c5b13dac@linaro.org>
Date: Fri, 22 Nov 2024 11:08:22 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] KVM: arm64: Debug cleanups
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>,
 Colton Lewis <coltonlewis@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20241115224924.2132364-1-oliver.upton@linux.dev>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20241115224924.2132364-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 15/11/2024 10:49 pm, Oliver Upton wrote:
> Second pass at cleaning up the mess of debug support / trap
> configuration we have.
> 
> Marc, I haven't yet gotten around to moving the per-CPU value of
> mdcr_el2 into kvm_host_data. If you're alright with it, I'd like
> to clean up the configuration + storage of all the trap registers
> in a separate series, especially the pKVM bits of it.
> 
> Tested the userspace-facing parts by single-stepping + setting
> breakpoints for a guest using QEMU's gdbstub. Tested the guest-facing
> side of things with the debug-exceptions selftest.
> 

Hi Oliver,

I get this bug when running the selftests, but the tests themselves seem 
to pass ok:

[  105.534801] BUG: using smp_processor_id() in preemptible [00000000] 
code: debug-exception/1046
[  105.543466] caller is debug_smp_processor_id+0x20/0x30
[  105.543470] CPU: 3 UID: 0 PID: 1046 Comm: debug-exception Not tainted 
6.12.0-rc5+ #144
[  105.543473] Call trace:
[  105.543474]  dump_backtrace+0x100/0x158
[  105.543476]  show_stack+0x24/0x38
[  105.543477]  dump_stack_lvl+0x3c/0x98
[  105.543480]  dump_stack+0x18/0x28
[  105.543482]  check_preemption_disabled+0xe0/0xe8
[  105.543485]  debug_smp_processor_id+0x20/0x30
[  105.543488]  kvm_debug_set_guest_ownership+0x48/0x130
[  105.543490]  trap_debug_regs+0x4c/0x88
[  105.543492]  perform_access+0x94/0x1b0
[  105.543494]  kvm_handle_sys_reg+0x12c/0x228
[  105.543497]  handle_exit+0x9c/0x158
[  105.543498]  kvm_arch_vcpu_ioctl_run+0x53c/0xa68
[  105.543501]  kvm_vcpu_ioctl+0x754/0x8a0
[  105.543503]  __arm64_sys_ioctl+0x9c/0xe0
[  105.543505]  invoke_syscall+0x4c/0x110
[  105.543508]  el0_svc_common+0xb8/0xf0
[  105.543511]  do_el0_svc+0x28/0x40
[  105.543514]  el0_svc+0x4c/0xc0
[  105.543517]  el0t_64_sync_handler+0x84/0x100
[  105.543519]  el0t_64_sync+0x190/0x198

> v1 -> v2:
>   - Route debug exceptions to vEL2 if MDCR_EL2.TDE=1
>   - Avoid reading ID_AA64DFR0_EL1 a bunch for debug save/restore
>   - Set up HPMN with the right mask (Suzuki)
>   - Minor cleanups on host_data_*_flag() helpers (Marc)
>   - Squash patches responsible for updating debug_owner into 1 (Marc)
>   - Un-macro a few things I needed macro'ed in v0 (Marc)
>   - Completely rip out the debug tracepoints (Marc)
>   - Add new documentation for debug_owner, 'external' debug behaviors
>     (Marc)
> 
> Oliver Upton (16):
>    KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
>    KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
>    KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
>      vCPU
>    KVM: arm64: Move host SME/SVE tracking flags to host data
>    KVM: arm64: Evaluate debug owner at vcpu_load()
>    KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
>    KVM: arm64: Select debug state to save/restore based on debug owner
>    KVM: arm64: Remove debug tracepoints
>    KVM: arm64: Remove vestiges of debug_ptr
>    KVM: arm64: Use debug_owner to track if debug regs need save/restore
>    KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
>    KVM: arm64: Compute MDCR_EL2 at vcpu_load()
>    KVM: arm64: Don't hijack guest context MDSCR_EL1
>    KVM: arm64: Manage software step state at load/put
>    KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
>    KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore
> 
>   arch/arm64/include/asm/kvm_asm.h           |   5 +-
>   arch/arm64/include/asm/kvm_host.h          |  94 +++---
>   arch/arm64/include/asm/kvm_nested.h        |   1 +
>   arch/arm64/kvm/arm.c                       |  14 +-
>   arch/arm64/kvm/debug.c                     | 376 +++++++--------------
>   arch/arm64/kvm/emulate-nested.c            |  23 +-
>   arch/arm64/kvm/fpsimd.c                    |  12 +-
>   arch/arm64/kvm/guest.c                     |  31 +-
>   arch/arm64/kvm/handle_exit.c               |   5 +-
>   arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  42 +--
>   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 ++-
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  13 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c         |   8 -
>   arch/arm64/kvm/hyp/vhe/debug-sr.c          |   5 -
>   arch/arm64/kvm/sys_regs.c                  |  55 +--
>   arch/arm64/kvm/trace_handle_exit.h         |  75 ----
>   16 files changed, 279 insertions(+), 523 deletions(-)
> 
> 
> base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df

