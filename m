Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DCD2E63C
	for <kvmarm@lists.linux.dev>; Sun, 22 Feb 2026 08:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771749336; cv=pass; b=MIOKqex1SYy4NEKiOPXcUpyxIu+uos/i+IPhrT5qAYLA9RnaMQG07AN2gBxXk3BOHt5ScGnqqA1drgtif1zVlxhCtNGFXbwexeYesEilCwdu77mAV0rbyjObo8QYgY0ymByLgwkh4R21S7q5jchniYP46IrfazQU3FRVG28U5Fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771749336; c=relaxed/simple;
	bh=oDbRAj537BjmtTSVtgS5kT1V5cHicPCu52oMV19Xw98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p/C9M5WmDwvwNSgqI16+yxqOt1Yzgtr/zMRHON0PTJsYCdhB/rwkUDprA2fjJl+7Bfyp34eQbMUWKdjWbhr1Al9RKgnNxwTUPe8iybzPqtBXSQ1Ld3kdIw/rSokOwLkar2z4syMlHG/QOOBQ7dZp8jR8g3TS4qRSobHa+2EDEjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DTFSEd/E; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTFSEd/E"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5069a785ed2so495641cf.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Feb 2026 00:35:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771749334; cv=none;
        d=google.com; s=arc-20240605;
        b=UC/80mieYoH5GBE4WUrOo98KTuczTAcdOgxzOq9V1gcoMQuuT9MRRXixut6/05uje9
         BeS6Yt+WXWYU1Le8fL5L2kVSyvAtKkWisb7EuHa6HpBUFnvPrU3xZKrZT4ILvGzv7PUz
         nlJLJAET1KdztUB9YUel8LdzqB9lVH7LmT+WpXTrviWJTaN8g1ToPtNNPsvYj+893/be
         kHev11r0sT6kerUWZBGWP/dG1jCnRsGZwSPtkYzrVsv6J291oUpULW4psty8PAQl72T5
         yz4/SzotqxyfBckJHs2p76/lHDrFCdbBSeSJdB1sP7y/n4QILqcdXgwPS4qYgo9H54a/
         eE/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j0mNz9Mubye2MgsrTZAxnzG5GOQUdhjijzm5m9nKg2k=;
        fh=+xDes2mP8pWF82bhK0gjitq98GgVLOMZrGM+Ek1G3tY=;
        b=ctHH5ugWS7kFQKET+ZiKvxuNoL+OGLHQALbYDz1D/qOf2G2N9YHTsoiCYBMG0QLRnS
         q74bCr2U07n3c9/1iSOUodR1u7qgv4XXIZPZIHwhwhBIVWxVh9K02N6e1cr04CuY+o5S
         EwTeSCu7tdKTx2e1aBBG+uUsosjUNLDaaoIIRDd/ave6wFPGqCwltJ9wTVfc+1kgEiRt
         C7jdmVM2Lg9M3k/mM7IWKng5BQvk0KS6rKVVpr3QhI0Dttg7h9Qrg8ACfNpVTB3vaiL0
         OKIpXE3+2sPYYg8jjANjKoqzM8OIUevRNIno0wERkTYK99OKi9+ChjIsbRvaC4V1wjUw
         sUSw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771749334; x=1772354134; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0mNz9Mubye2MgsrTZAxnzG5GOQUdhjijzm5m9nKg2k=;
        b=DTFSEd/E1Wmh+AXnJbaSrQ0PFC+Sub/S0uqvxFHF87n3qAL9g9KidfdbnztQQfUUPD
         PYI3uuHW3Se4+2UeoLIy7itOiLnBeNMPv0L2TzrZTymDjxPhMjN6SKTzm/mILcgJ2xoS
         nszmsMjRjZ72SgVKxaNlcGc9FtjdTi1mA5bROtPS/7ck0r4UwxVtbFuwudojVmBc0hZF
         qnfMtCZgPC8bK+cQpCTtOLroSZ1DB+pEn0I0woYhxsXCvt3/ATTXSDa53AKUssu/kDrs
         qQURfKhd2qGdDPtGd0D/me2dZD87lMIQJRRxu4Wd8MiNjPkk0Nd0BA9fFxYBslbSAcf9
         XMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771749334; x=1772354134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j0mNz9Mubye2MgsrTZAxnzG5GOQUdhjijzm5m9nKg2k=;
        b=nE5BC1utz4rYArBHKL9v5euXHSoSmayAeQxn9ZPUyaMjJ5bWgqF8sY/WtBZgqkHjrA
         aue3+TzKMKRkA1W75uh6EAPw76JLybIQhhqM37YHoAiSq6XA9OkH+rs52vTZ1oijmUiT
         bJWybJu7FlO2zSSrhB067EB7Xki+RH6H73G32R1phDYDAO/sFn4SLJxWiFu45k7tX15Y
         ogE0aYq5olAL2WLg9YSkfutyVvmFp+1Uh3gv3ogdVFrauWo0qjw8tdYGiqAf1SjDgqFE
         J/Dxz7AVPCgcdg6D9VTmIEAn1Y14m3yfyW0WFft4euRgFMEazhD9ega5ZXgrnUNfMlF9
         8kmA==
X-Forwarded-Encrypted: i=1; AJvYcCUi1nkQ+/ZUyFr1Ed4TfqYagWqcQapI7J6Vcd3Ub2O9BwjYTtbO2SrzFX+1p0Fm2/Bk/zSh/FE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxf76CdwUUkwv4Or94x6L+xdnPXABvNLOkr/pK/0z7jyNoxB1UV
	MQ8CP47UIjF6ZB7J883iFu1RuC39YHOy0YEruqdgJY6dhxB2LhocRvcqloKM/bCi1opU7m6DBrS
	gs+q0ITogxXpXwoKZniZm5AlephOaf5Jo7rEU4WY6
X-Gm-Gg: AZuq6aLlbxQpgamXrmr+oR0BGZSAAeDdtVBzKKcCssURWeG9X4asrUMiz3QXYFDamQJ
	hplk356S0fHFDgiPelxm0xL3SN9PCakSfscB4noENrPEHzpcbcWJ3Wtj9+/iORr8cOo/luLragX
	n+53GIO4cKgC/um93VJ9mEqgPg31owWiBxWlC1NIJppcy9G2v8ejk9QlDr4DL/5E7lU3CSTpM2+
	e9EF0539Pei0BYDzLHvvg3wFmHrZyxmpEpBEj1SS+V6Mnv3EDBKrMY76mXGCkc9e0Hsl7PYrm/y
	4zZ9y9Tb
X-Received: by 2002:ac8:5710:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5070e7e5187mr8428211cf.1.1771749333979; Sun, 22 Feb 2026
 00:35:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <60916cb6-f460-4751-b910-f63c58700ad0@sirena.org.uk> <87bjhie67o.wl-maz@kernel.org>
In-Reply-To: <87bjhie67o.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Feb 2026 08:34:57 +0000
X-Gm-Features: AaiRm50gVnwK_ayhB9NZOZ4Rfg9Gj51P6wQTKXI500EE-NyuWrHGP9k906H1SYk
Message-ID: <CA+EHjTwzjjNuZSQExZUsGAXWdaH=Uf=z4ks2XQAXqaU4DcmD9w@mail.gmail.com>
Subject: Re: pKVM breakage in mainline on n1sdp
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Feb 2026 at 10:33, Marc Zyngier <maz@kernel.org> wrote:
>
> [+ Fuad for the protected mode stuff]

I'm unable to reproduce it, but I think the following might be the fix:
https://lore.kernel.org/all/20260222083352.89503-1-tabba@google.com/

Thanks for catching this, and sorry for the trouble.

Cheers,
/fuad


> On Fri, 20 Feb 2026 19:08:59 +0000,
> Mark Brown <broonie@kernel.org> wrote:
> >
> > Hi,
> >
> > At some point since the 30th of January we have started seeing issues
> > in mainline when running kvm-unit-tests on N1SDP in pKVM mode:
> >
> > TESTNAME=3Dpmu-mem-access TIMEOUT=3D90s MACHINE=3D ACCEL=3D ./arm/run a=
rm/pmu.flat -smp 1 -append 'pmu-mem-access'
> > <4>[  114.487201] ------------[ cut here ]------------
> > <4>[  114.487206] WARNING: arch/arm64/kvm/pkvm.c:393 at pkvm_pgtable_st=
age2_map+0x1ac/0x1c4, CPU#1: qemu-system-aar/1955
> > <4>[  114.502672] Modules linked in: stm_p_basic coresight_tpiu coresig=
ht_stm stm_core arm_spe_pmu coresight_funnel coresight_tmc coresight_replic=
ator coresight arm_cmn sha256 cfg80211 rfkill fuse dm_mod ipv6
> > <4>[  114.520924] CPU: 1 UID: 0 PID: 1955 Comm: qemu-system-aar Not tai=
nted 6.19.0 #1 PREEMPT
> > <4>[  114.529261] pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS=
 BTYPE=3D--)
> > <4>[  114.536469] pc : pkvm_pgtable_stage2_map+0x1ac/0x1c4
> > <4>[  114.541681] lr : pkvm_pgtable_stage2_map+0x58/0x1c4
> > <4>[  114.546805] sp : ffff80008673b900
> > <4>[  114.550366] x29: ffff80008673b900 x28: 0000000000200000 x27: 0000=
000000200000
> > <4>[  114.557748] x26: 0000000000000000 x25: 00000000fffffff4 x24: 0000=
00000000000f
> > <4>[  114.565130] x23: ffff008047b65198 x22: 00000000080cbc00 x21: 0000=
000000040000
> > <4>[  114.572512] x20: ffff008046f65680 x19: 0000000000000200 x18: 0000=
000000000001
> > <4>[  114.579893] x17: 0000000000000000 x16: 0000000000000000 x15: 0000=
000000000000
> > <4>[  114.587275] x14: 0000000000000002 x13: 0000000000000002 x12: 0000=
00000031bf68
> > <4>[  114.594656] x11: 0000000000000000 x10: 0000ffff8be01000 x9 : ffff=
8000800728b0
> > <4>[  114.602037] x8 : ffff80008673bab8 x7 : 0000000000000001 x6 : 0000=
000000000008
> > <4>[  114.609419] x5 : 0000000040200000 x4 : 000000000000000f x3 : 0000=
000000000200
> > <4>[  114.616800] x2 : 0000000000040000 x1 : fffffffffffffff4 x0 : 0000=
000000000000
> > <4>[  114.624182] Call trace:
> > <4>[  114.626875]  pkvm_pgtable_stage2_map+0x1ac/0x1c4 (P)
> > <4>[  114.632088]  kvm_handle_guest_abort+0xe7c/0x12ec
> > <4>[  114.636953]  handle_exit+0x60/0x184
> > <4>[  114.640689]  kvm_arch_vcpu_ioctl_run+0x35c/0x968
> > <4>[  114.645554]  kvm_vcpu_ioctl+0x254/0xa50
> > <4>[  114.649638]  __arm64_sys_ioctl+0xac/0x104
> > <4>[  114.653896]  invoke_syscall+0x48/0x110
> > <4>[  114.657894]  el0_svc_common.constprop.0+0x40/0xe0
> > <4>[  114.662846]  do_el0_svc+0x1c/0x28
> > <4>[  114.666409]  el0_svc+0x34/0x10c
> > <4>[  114.669798]  el0t_64_sync_handler+0xa0/0xe4
> > <4>[  114.674228]  el0t_64_sync+0x198/0x19c
> > <4>[  114.678137] ---[ end trace 0000000000000000 ]---
> >
>
> The absence of any versioning information is really unhelpful. What
> kernel version is that? Upstream? Next? A date really doesn't help
> much, specially given how vague it is. Same thing for KUT.
>
> > The same tests running on N1SDP in VHE mode seem happy, and I've not
> > seen any other platforms showing issues.  Unfortunately due to various
> > infrastructure issues I don't have more detail on when this started
> > happening or anything, I'll update if I get more.
>
> I've ran that test on an Altra (Neoverse-N1, same as N1SDP), with both
> v6.19 and linux/master as of d79526b89571 together with KUT as of
> 86e53277 and nothing caught fire in protected mode, including a
> 32-parallel VM test.
>
> Most of KUT's PMU tests fail in protected mode though, probably due
> some issue with the routing of PMU exceptions (see below), but that
> doesn't seem new. Fuad, could you please have a look and see if
> something catches your eye?
>
> Thanks,
>
>         M.
>
> maz@filthy-habits:~/kvm-unit-tests$ ./arm/run arm/pmu.flat -smp 1 -append=
 'pmu-mem-access'
> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=3Dhost=
 -accel kvm -cpu host -device virtio-serial-device -device virtconsole,char=
dev=3Dctd -chardev testdev,id=3Dctd -device pci-testdev -display none -seri=
al stdio -kernel arm/pmu.flat -smp 1 -append pmu-mem-access # -initrd /tmp/=
tmp.S6qLYpNV6X
> INFO: PMU version: 0x4
> INFO: PMU implementer/ID code: 0(" ")/0
> INFO: Implements 6 event counters
> INFO: pmu: pmu-mem-access: 32-bit overflows: counter #0 is 0x0 (MEM_ACCES=
S)
> INFO: pmu: pmu-mem-access: 32-bit overflows: counter #1 is 0x0 (MEM_ACCES=
S)
> FAIL: pmu: pmu-mem-access: 32-bit overflows: Ran 20 mem accesses
> FAIL: pmu: pmu-mem-access: 32-bit overflows: Ran 20 mem accesses with exp=
ected overflows on both counters
> INFO: pmu: pmu-mem-access: 32-bit overflows: cnt#0=3D0xfffffff0 cnt#1=3D0=
xfffffff0 overflow=3D0x0
> SKIP: pmu: pmu-mem-access: 64-bit overflows: Skip test as 64 overflows ne=
ed FEAT_PMUv3p5
> SUMMARY: 3 tests, 2 unexpected failures, 1 skipped
>
> EXIT: STATUS=3D3
>
> --
> Jazz isn't dead. It just smells funny.
