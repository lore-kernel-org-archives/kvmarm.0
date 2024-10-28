Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C941D79B3
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730130313; cv=none; b=ZdnEnzI0YjzGAU8+h7YB9GOJV3VvBd2mvxdEOsnG8Dk0VDT+y6mQHLp0Lt9VDmb6Oo0EoiapCCh61QmS8URKpdJffLUsDF5xal/iPgo5WXAtHJwCzIZkrzm4GlWWsutAwbuQ5QHouOzaTkLbg+J5mjoAmH6J5LoGz1bA7TOUHcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730130313; c=relaxed/simple;
	bh=U2QXffbO67R3C2xSt619DnG+5G2mHfdrhPPetMCeFeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E1B4OsFiC/VdO2xwy6CGlYjDfQ4fFJNeKCy+V33/q8ceUpvRZ/g6pJHCys01q16Y3HXqoCPSbxukO/517ZnYJGP718hzq7Nl/TnimezF8auUiT/0Q1d3GS/Vx4fzFdK24UKHvpA/I/qKliGt1pWkSpApzDAO9HakfDxJHwVh/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NRtUmjdk; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NRtUmjdk"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-4a492f73befso1329844137.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 08:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730130310; x=1730735110; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=75XNMAa64Nrib7pgLMg1Z1XYi4OYy86joo0hy0CXwKI=;
        b=NRtUmjdkqcLb9Z40gRn7IYP+2ftiGx8OxXRjJiVQ0nVUAaCX5VrS2NM5N3INKNqJN4
         5BJs7Xzgo5TwW6RaPY3ybU996cq2jWO5YbYOuktcrE1dwvIg9BE+cgfeB/m1KjNY9QPd
         FpGpV1I7Wmvty9dzxkESl1ujgOm97NlmGLt0E4xoSru9pkNDDi088YLKITiU+9KY/TCu
         9X2W0ep/ZS8x16rEvrCEzhHBQTHTeuona8T0kHYS7CbbD1ZVOzVnU6+kM9rW2El+6FRj
         qC/FMR4cHPrk7yGynn1e2lWErt+zLpqxEPoDe2bbqhwDJvncNzA/bTOUr7b9/nBLuQ3b
         frXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730130310; x=1730735110;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=75XNMAa64Nrib7pgLMg1Z1XYi4OYy86joo0hy0CXwKI=;
        b=dLWOIIBBt8HrRTu5Fgjc5vqXd2ul+/tsLYkjb7jDhGRixkLlEdbGjYejHBZKvHDEjp
         djClCU6n/2EyjUiuqHutICg39+ADwRMk7p4jllNysvhwhZqn3vIld6QXc5Sld7Cwj3gH
         UKGnpARjwl1hgWRQ61m8nNmCuhgoWxEdlgR39UZXz7+VcrJFobhTUbmROMJ727OhbxyY
         gHn3MHWOjUb1pOUKn48QkExEhv3dXXt7b9sbylecsru0kx7rA3aV9CJW/M/Q9FtXQYXm
         RV067pfhv73Ppv4r14yyo4xdglFIq1dOrgDa1UiNPXKJKfPALKNfszT4EaCNXN4yMXcJ
         l32g==
X-Forwarded-Encrypted: i=1; AJvYcCUKZhhx7dgp9BvpYc0xY8qDTM0zPfJqydiSazR6uPSJ6/AGtt/Lxp52WripftrJjyW88UjN5Po=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzwtt/D/mvwwfV2t2IHet95uY5LRwWNTSEjIDE92eA9OYvpldJ3
	GNz2mqgEpBGH6HGbaVHnjBNvCBJzXfkRh7tE30vpxSNmrhNUSI3moQ/MGHWpoX8C8BGvFZrbCEn
	Hhsj2wFSKDyiZ4roKcHIFwOaQOe74TvX3UuzLeQ==
X-Google-Smtp-Source: AGHT+IGLxPJJ2NCoGI8hRsiiwLEAN/a5Dqx+FocGdkHpFfwjM3keyeu4LatSC2h948xtYi1UWvkv7JVZmh/VHgunRi4=
X-Received: by 2002:a05:6102:2924:b0:4a5:b543:ee64 with SMTP id
 ada2fe7eead31-4a8cfb5f764mr5871139137.11.1730130309682; Mon, 28 Oct 2024
 08:45:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241028062312.001273460@linuxfoundation.org>
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 28 Oct 2024 21:14:57 +0530
Message-ID: <CA+G9fYu-tpwX=09=VOjniFnBz3MSXpaHb_gir2AqyNpihERT2Q@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 28 Oct 2024 at 12:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.6 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The selftests: kvm: vgic_init test failed on stable-rc linux-6.11.y,
also seen on Linux next-20241023 onwards and Linus v6.12-rc5
on the Graviton4 and rk3399-rock-pi.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Test log:
---------
# selftests: kvm: vgic_init
# Random seed: 0x6b8b4567
# Running GIC_v3 tests.
# ==== Test Assertion Failure ====
#   lib/kvm_util.c:727: false
#   pid=2680 tid=2680 errno=5 - Input/output error
#      1 0x0000000000404eaf: __vm_mem_region_delete at kvm_util.c:727
(discriminator 5)
#      2 0x0000000000405d0f: kvm_vm_free at kvm_util.c:765 (discriminator 12)
#      3 0x0000000000402d5f: vm_gic_destroy at vgic_init.c:101
#      4 (inlined by) test_vcpus_then_vgic at vgic_init.c:368
#      5 (inlined by) run_tests at vgic_init.c:720
#      6 0x0000000000401a6f: main at vgic_init.c:748
#      7 0x0000ffff8620773f: ?? ??:0
#      8 0x0000ffff86207817: ?? ??:0
#      9 0x0000000000401b6f: _start at ??:?
#   KVM killed/bugged the VM, check the kernel log for clues
not ok 9 selftests: kvm: vgic_init # exit=254

Upstream discussion thread on this failures,
 - https://lore.kernel.org/linux-arm-kernel/20241009183603.3221824-1-maz@kernel.org/

Test failed log:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.4-397-g4ccf0b49d5b6/testrun/25583294/suite/kselftest-kvm/test/kvm_vgic_init/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.4-397-g4ccf0b49d5b6/testrun/25583294/suite/kselftest-kvm/test/kvm_vgic_init/history/

## Build
* kernel: 6.11.6-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 4ccf0b49d5b6ec739a290593658bebd035bb5f10
* git describe: v6.11.4-397-g4ccf0b49d5b6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.4-397-g4ccf0b49d5b6

## Test Regressions (compared to v6.11.4-136-g96563e3507d7)
* graviton4-metal, kselftest-kvm
  - kvm_vgic_init

* rk3399-rock-pi-4b-nvhe, kselftest-kvm
  - kvm_vgic_init

* rk3399-rock-pi-4b-protected, kselftest-kvm
  - kvm_vgic_init

* rk3399-rock-pi-4b-vhe, kselftest-kvm
  - kvm_vgic_init

## Metric Regressions (compared to v6.11.4-136-g96563e3507d7)

## Test Fixes (compared to v6.11.4-136-g96563e3507d7)

## Metric Fixes (compared to v6.11.4-136-g96563e3507d7)

## Test result summary
total: 143710, pass: 118866, fail: 1602, skip: 23242, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 129 passed, 2 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 35 total, 35 passed, 0 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-rust
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
