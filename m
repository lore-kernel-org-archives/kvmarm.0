Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8862B3BB12B
	for <kvmarm@lists.linux.dev>; Sun,  6 Sep 2026 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788714343; cv=none; b=M0crxA0At2IhbjfU9U8V49epZ7r83F+I/s9G4VcwnQY4Geq9FIVSoSjNDARQWOauXuur9GtNYLWf/3nKnDFbVZT9YLfzpAl2gon5TL0QdNkhFfVvLo3IobmpcB9EZKIAz/i1oo/pcihdmEjcuSSPwaDuWyEngOejEJoFA43Ry+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788714343; c=relaxed/simple;
	bh=Jot0d4tdAX4ga7oGrQxB+O2Nf0GAD5rK+9m4nrHPeww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DzAiprqerfzE64MxiFg8qYaVTcq6Z+INT+9MkS8vC9g6o2avD3R0bxndpjgOo2dj1KNGiQffU/rcVWvC9fkTOZNk0e45MdFBFeYPgraaw36R8AVTUy2kfB9lrmhcQwXbPcupUEimMqcIZId1uAMVwmFlUaHy5amgjd+9R1GbB2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MUthX1Eu; arc=none smtp.client-ip=95.215.58.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MUthX1Eu"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Jot0d4tdAX4ga7oGrQxB+O2Nf0GAD5rK+9m4nrHPeww=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788714336; v=1; x=1789319136;
 b=MUthX1EuSn3CaF3uazWVsMUtJpQkwMykheVCykhxg2vhOHDcifZZnWM2NhavzWffu9OyrZ03
 OktjCyaYu1xoIGOiaCJFvDQqeReoiCxToaENjDTGqOZSHlR09AzAGBniWvdrvl+asLHiD/QVkF5
 nH6hBztKdaKj4d15v7bUSZLg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id eb07d5af51e96472;
	Sun, 06 Sep 2026 17:05:36 +0000
X-Mizu-Trace-ID: eb07d5af51e96472
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17358so3166e87.1
        for <kvmarm@lists.linux.dev>; Sun, 06 Sep 2026 10:05:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw3l+/u2dMISI4dMtqM8521OateE+Y4CTMRhQ+TWOWBpYlY0dr4nrLhCpn13J1qCbta5orM6lg=@lists.linux.dev
X-Gm-Message-State: AFuF++mBOdKm6cN6zHf+9TPJGfRaPbjn4T4a/kUNxhQjaWLvCsK0IfOB
	vxDaUnUmhTe9FdNCcZPgiZAuy05IeMwksJWvgHcc/pstFCO52LClpagiA2F1o8HQS4aQ7+0w8NU
	jAl8FPOqjtZXIfuZ0g8eofUlJy4GpjOj50wmCUgwB
X-Received: by 2002:a05:6512:3185:b0:5b6:19c6:a91b with SMTP id
 2adb3069b0e04-5b74d1e0c5bmr121728e87.14.1788714331510; Sun, 06 Sep 2026
 10:05:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904175550.430266-1-dongli.zhang@oracle.com>
In-Reply-To: <20260904175550.430266-1-dongli.zhang@oracle.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 6 Sep 2026 18:04:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzfJz-Svda-Fia5ZS30U4hTDu+S2OfieGM7qWWpT=Jj=g@mail.gmail.com>
X-Gm-Features: AcwNN1VP4_TDp5r8i9di6gzQC14e3bohlNpxyyJkOQ7W-Gf2v9WuUtmDgfuRj38
Message-ID: <CA+EHjTzfJz-Svda-Fia5ZS30U4hTDu+S2OfieGM7qWWpT=Jj=g@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: Reset steal time accounting on vCPU pid change
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, zhaotianrui@loongson.cn, 
	maobibo@loongson.cn, chenhuacai@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, dwmw2@infradead.org, joe.jin@oracle.com
Content-Type: text/plain; charset="UTF-8"

Hi Dongli,

On Fri, 4 Sept 2026 at 18:56, Dongli Zhang <dongli.zhang@oracle.com> wrote:
>
> v1: https://lore.kernel.org/all/20260816053630.527528-1-dongli.zhang@oracle.com
>
> v1->v2:
>   - move the last_steal field in the main vcpu structure (suggested by
>     Marc Zyngier).
>   - Reset last_steal from the caller of kvm_arch_vcpu_run_pid_change().

I built and ran the series on QEMU/arm64: the new
steal_time_change_pid selftest and the existing steal_time selftest
both pass, and non-protected and protected guest boots are clean.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>
> KVM does not support vCPU hotplug. When a vCPU is removed, its
> corresponding data structures are not freed by KVM. Instead, QEMU destroys
> only the userspace state and the vCPU thread, while the KVM vCPU fd remains
> open and parked in QEMU.
>
> As a result, vcpu->arch.st.last_steal is not reset. If the same vCPU is
> later re-created by QEMU, last_steal retains its old value, while
> current->sched_info.run_delay starts from zero since a new vCPU thread is
> created. This causes current->sched_info.run_delay - vcpu->arch.st.last_steal
> to produce a large, bogus value.
>
> For instance, current->sched_info.run_delay can become smaller than
> vcpu->arch.st.last_steal (see line 3804) if a QEMU vCPU is re-added after
> it has previously been removed.
>
> As a result, st->steal restarts from a very small value, close to
> current->sched_info.run_delay.
>
> 3720 static void record_steal_time(struct kvm_vcpu *vcpu)
> 3721 {
> ... ...
> 3803         unsafe_get_user(steal, &st->steal, out);
> 3804         steal += current->sched_info.run_delay -
> 3805                 vcpu->arch.st.last_steal;
> 3806         vcpu->arch.st.last_steal = current->sched_info.run_delay;
> 3807         unsafe_put_user(steal, &st->steal, out);
>
>
> This patchset resets last_steal when the vCPU PID changes, as suggested by
> Sean.
>
> Although David suggested accounting the run_delay left over from the
> previous vCPU PID, this series does not do that. It would be easy to make
> that work if KVM could simply assume every transition is a vCPU PID change.
> In practice, KVM does not always have enough information about the previous
> vCPU PID, e.g. after live migration, unless a new ioctl is introduced. For
> now, this series simply resets last_steal.
>
> Although David also suggested doing the same for Xen-on-KVM vCPUs, this
> series does not reset last_steal for Xen vCPUs. That change itself would
> not be difficult, but Xen uses a different mechanism to account downtime,
> including runnable time and offline time when a vCPU is not running. It may
> therefore need no additional ioctl, or a smaller ioctl extension, to account
> run_delay left over from the previous PID.
>
> As I have access to only x86 and arm64 KVM hosts, I created and validated
> the selftest on those two architectures only.
>
> Dongli Zhang (4)
>   KVM: Move last_steal to common struct kvm_vcpu
>   KVM: Reset last_steal on vCPU pid change
>   KVM: selftests: Test steal time across vCPU pid changes on x86
>   KVM: selftests: Add arm64 coverage for steal time pid changes
>
>  arch/arm64/include/asm/kvm_host.h               |   1 -
>  arch/arm64/kvm/Kconfig                          |   1 +
>  arch/arm64/kvm/pvtime.c                         |   8 +-
>  arch/loongarch/include/asm/kvm_host.h           |   1 -
>  arch/loongarch/kvm/Kconfig                      |   1 +
>  arch/loongarch/kvm/exit.c                       |   2 +-
>  arch/loongarch/kvm/vcpu.c                       |   6 +-
>  arch/riscv/include/asm/kvm_host.h               |   1 -
>  arch/riscv/kvm/Kconfig                          |   1 +
>  arch/riscv/kvm/vcpu_sbi_sta.c                   |  10 +-
>  arch/x86/include/asm/kvm_host.h                 |   1 -
>  arch/x86/kvm/Kconfig                            |   1 +
>  arch/x86/kvm/x86.c                              |   5 +-
>  include/linux/kvm_host.h                        |   4 +
>  tools/testing/selftests/kvm/Makefile.kvm        |   2 +
>  .../selftests/kvm/steal_time_change_pid.c       | 216 +++++++++++++++++++
>  virt/kvm/Kconfig                                |   3 +
>  virt/kvm/kvm_main.c                             |   4 +
>  18 files changed, 248 insertions(+), 20 deletions(-)
>
> base-commit: 8ab1afb2eb246ab15b301cd255b5943d208a93c1
>
> Thank you very much!
>
> Dongli Zhang
>
