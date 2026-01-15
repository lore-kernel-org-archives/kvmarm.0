Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C10376BEF
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 11:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768475674; cv=none; b=gmRjCUE+2Rqsy3MJM1wFJyemr5VmDKrj2ZqfSlnftmoL31wdpAogeuK98T+O/jgHggP3+q62GPH2BLRWTX2vu7b+kQOzzsL+pzxHgCnwszPxpEPzp8LddNXhkcFvZXGsuIxjfpTCI4wrIptHgYUjzd+SLX4A2TNgK9esm+E0U98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768475674; c=relaxed/simple;
	bh=crk2BPKgOABwEMqIT88wHU85QBtM8jrCzokUqOBOo24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ky5Ry9lHzVIU3xLLUNw5lqJtOvisx5Xxeerz/9sem+qZthhk+zO3Ya93DTVUv8y0aMC+syWrAhqjxCNAi10WhKnM2mKiN4mzE3em+N5K8Ot2q36G2bwSnAD4+wezynn0Y+69vAuKYTvQnYL0ezXm730Y2kW0NC/DA5fSvPKMJOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fwg4PP1W; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fwg4PP1W"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b876bf5277dso250535866b.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 03:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768475671; x=1769080471; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MASScfCP1EDzrcxDg5IdgyEQHS3BC9CGtRRE53o2vFY=;
        b=fwg4PP1W6SO1Uj4Cg2V3vtUW4l8vhWCb2+foNrqR74KCSpMM9upHDVjUfAs954lX3/
         6+Epd1l+wtQlq0NE4QL4joJuIc4SFurIKz0+6LmVvCHCMk/7BCdt2uXe/gXBgnYZOU3u
         0Z26HQNjOPtYqpHsvyKFTmVilMiPrjLNudEuArLiwvr8gyLcB0t/y/XUFBCgLaNUVrS7
         Fh2nkgwyWMUqs8tEIIsGflu8C7bXznL2cLORG0DcR5scsvzSBzQAHp8P1qb3IYUypcMz
         c5bN0wQGU/+pMUSLVcq+SVMOGZE0DrDl94qXirGGzGiPgM6J8lxgiIy/WyBHROOSxcG7
         z2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768475671; x=1769080471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MASScfCP1EDzrcxDg5IdgyEQHS3BC9CGtRRE53o2vFY=;
        b=nWLtwFH5T6tVNkSXPWReou7gNPmKU57emJqRo2RtY0UG4ZvkG6yQWMAlazGOT9EN0R
         bQbbGHz3TcOEModDASR5GDOHSX0+0UhpxPSYOM8nMQzgKEVRIBALiCaMhNZefimcqcH4
         qFkUkhwJV+tzt6Dg7IqxpIlhkZp0CvWAV/NS3ZgDJQGVVZDi0U1cWScem08wFDBjKf9w
         V81ZMfhU15n5jD6/fd7ePI620PjpaosOiPzXegtDDheg3sI4WBOEWK4qgvzxzanqxFSr
         iCe4rPCEuFGvs1TSYwmNUTp4Ks7+uzu7pAG/QXaW1uB7Q/0IR7prNUN24qCbzLw+Iyvq
         1DWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8NteSKuq3BvINtoWtVFplJJz/utUn/wWA/Xb8eMFQ3ADR2sh16LHDypet6Fot8YmXLpBpOKk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuttmpOaDeUKFJGg8dSoZZNnVCJCx0LEmE1S1wyF7FefL+W/8u
	YUzBtO6nfZCXLeZ/i8KVP35rSEHR/jC/oOI7v9ykEaC8MKZG6tK26ccCMIObX9Xbp0oAE+n9v9W
	KofiQzeev03wdyPWL8rwQ3bgsM446t0bY9kThHflj
X-Gm-Gg: AY/fxX6VJ8j/Vi9Vo3jqDWfvgw1XZaaxZ8fj3HLM1OipomPwBTU6MbGsZ87TK3IHfQv
	5rXz2VFuY4ecktTuDEoiVaI/gwF0z5lmt9CZ1yFQRfVdKeuTtaOk55Z+0Xugts2/6oq0BwixhDg
	eK7Of6HeAtlZCPMRY/YvME4qWp2uhg1OcshGYcb+RiIXUOghSn2vdR52E4K9LtVE4LdpHC2EALA
	9qBnqSnp3Yhk7GWXs1+m2VbxK+6Yigto4DIZVonzqgP/jlyHLYE0B+LHuy1ypw5Omp9j5Z3Pcmq
	I4NnCNIBooyFoEF/HhJApyN8omgj+A9lnrJ1
X-Received: by 2002:a17:907:3f13:b0:b79:ea1b:f13d with SMTP id
 a640c23a62f3a-b8777a7953dmr294862466b.2.1768475670767; Thu, 15 Jan 2026
 03:14:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260112165914.4086692-1-ben.horgan@arm.com>
In-Reply-To: <20260112165914.4086692-1-ben.horgan@arm.com>
From: Peter Newman <peternewman@google.com>
Date: Thu, 15 Jan 2026 12:14:19 +0100
X-Gm-Features: AZwV_QiEcqX9Z62pOe8axjpGIo-oG2d6Z-8Wh0LIfRSc7y-vQKSv9qD72xMgM5w
Message-ID: <CALPaoCh=brY6+_oJZXJLfpv_Qkz0i0RuPfuRa+TgXLu_xV6rsQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/47] arm_mpam: Add KVM/arm64 and resctrl glue code
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com, 
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com, 
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com, 
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com, 
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com, 
	reinette.chatre@intel.com, rohit.mathew@arm.com, scott@os.amperecomputing.com, 
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, 
	catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net, maz@kernel.org, 
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Mon, Jan 12, 2026 at 5:59=E2=80=AFPM Ben Horgan <ben.horgan@arm.com> wro=
te:
>
> This new version of the mpam missing pieces has no major rework from the
> previous version. It's mainly small corrections and code tidying based on
> review and things I spotted along the way. To be able to merge this we ne=
ed
> review from more people and people to start testing on their platforms an=
d
> giving some Tested-by tags.
>
> Change list in patches.
>
> As mentioned in the cover letter for v2, one major departure from the
> previous snapshot branches referenced in the base driver series is that t=
he
> same MPAM setting are used for kernel-space and user-space. There are pro=
s
> and cons of choosing this policy but I think it is the best thing to star=
t
> with as there are AMD plans for adding a resctrl feature to allow a
> different closid/rmid configuration for user-space from kernel space. The
> AMD feature is called PLZA and is mentioned in this lpc slide deck[1]. Th=
is
> gives us a path forward to add support for having the EL1 and EL0 MPAM
> partid/pmg configuration differ from each other.
>
> From James' cover letter:
>
> This is the missing piece to make MPAM usable resctrl in user-space. This=
 has
> shed its debugfs code and the read/write 'event configuration' for the mo=
nitors
> to make the series smaller.
>
> This adds the arch code and KVM support first. I anticipate the whole thi=
ng
> going via arm64, but if goes via tip instead, the an immutable branch wit=
h those
> patches should be easy to do.
>
> Generally the resctrl glue code works by picking what MPAM features it ca=
n expose
> from the MPAM drive, then configuring the structs that back the resctrl h=
elpers.
> If your platform is sufficiently Xeon shaped, you should be able to get L=
2/L3 CPOR
> bitmaps exposed via resctrl. CSU counters work if they are on/after the L=
3. MBWU
> counters are considerably more hairy, and depend on hueristics around the=
 topology,
> and a bunch of stuff trying to emulate ABMC.
> If it didn't pick what you wanted it to, please share the debug messages =
produced
> when enabling dynamic debug and booting with:
> | dyndbg=3D"file mpam_resctrl.c +pl"
>
> I've not found a platform that can test all the behaviours around the mon=
itors,
> so this is where I'd expect the most bugs.
>
> The MPAM spec that describes all the system and MMIO registers can be fou=
nd here:
> https://developer.arm.com/documentation/ddi0598/db/?lang=3Den
> (Ignored the 'RETIRED' warning - that is just arm moving the documentatio=
n around.
>  This document has the best overview)
>
>
> Based on v6.19-rc5
> This series can be retrieved from:
> https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v3
>
> v2 can be found at:
> https://lore.kernel.org/linux-arm-kernel/20251219181147.3404071-1-ben.hor=
gan@arm.com/
>
> rfc can be found at:
> https://lore.kernel.org/linux-arm-kernel/20251205215901.17772-1-james.mor=
se@arm.com/
>
> [1] https://lpc.events/event/19/contributions/2093/attachments/1958/4172/=
resctrl%20Microconference%20LPC%202025%20Tokyo.pdf
>
> Ben Horgan (10):
>   arm_mpam: Use non-atomic bitops when modifying feature bitmap
>   arm64/sysreg: Add MPAMSM_EL1 register
>   KVM: arm64: Preserve host MPAM configuration when changing traps
>   KVM: arm64: Make MPAMSM_EL1 accesses UNDEF
>   arm64: mpam: Initialise and context switch the MPAMSM_EL1 register
>   KVM: arm64: Use kernel-space partid configuration for hypercalls
>   arm_mpam: resctrl: Add rmid index helpers
>   arm_mpam: resctrl: Add kunit test for rmid idx conversions
>   arm_mpam: resctrl: Wait for cacheinfo to be ready
>   arm_mpam: resctrl: Add kunit test for mbw min control generation
>
> Dave Martin (2):
>   arm_mpam: resctrl: Convert to/from MPAMs fixed-point formats
>   arm_mpam: resctrl: Add kunit test for control format conversions
>
> James Morse (30):
>   arm64: mpam: Context switch the MPAM registers
>   arm64: mpam: Re-initialise MPAM regs when CPU comes online
>   arm64: mpam: Advertise the CPUs MPAM limits to the driver
>   arm64: mpam: Add cpu_pm notifier to restore MPAM sysregs
>   arm64: mpam: Add helpers to change a task or cpu's MPAM PARTID/PMG
>     values
>   KVM: arm64: Force guest EL1 to use user-space's partid configuration
>   arm_mpam: resctrl: Add boilerplate cpuhp and domain allocation
>   arm_mpam: resctrl: Sort the order of the domain lists
>   arm_mpam: resctrl: Pick the caches we will use as resctrl resources
>   arm_mpam: resctrl: Implement resctrl_arch_reset_all_ctrls()
>   arm_mpam: resctrl: Add resctrl_arch_get_config()
>   arm_mpam: resctrl: Implement helpers to update configuration
>   arm_mpam: resctrl: Add plumbing against arm64 task and cpu hooks
>   arm_mpam: resctrl: Add CDP emulation
>   arm_mpam: resctrl: Add support for 'MB' resource
>   arm_mpam: resctrl: Add support for csu counters
>   arm_mpam: resctrl: Pick classes for use as mbm counters
>   arm_mpam: resctrl: Pre-allocate free running monitors
>   arm_mpam: resctrl: Pre-allocate assignable monitors
>   arm_mpam: resctrl: Add kunit test for ABMC/CDP interactions
>   arm_mpam: resctrl: Add resctrl_arch_config_cntr() for ABMC use
>   arm_mpam: resctrl: Allow resctrl to allocate monitors
>   arm_mpam: resctrl: Add resctrl_arch_rmid_read() and
>     resctrl_arch_reset_rmid()
>   arm_mpam: resctrl: Add resctrl_arch_cntr_read() &
>     resctrl_arch_reset_cntr()
>   arm_mpam: resctrl: Update the rmid reallocation limit
>   arm_mpam: resctrl: Add empty definitions for assorted resctrl
>     functions
>   arm64: mpam: Select ARCH_HAS_CPU_RESCTRL
>   arm_mpam: resctrl: Call resctrl_init() on platforms that can support
>     resctrl
>   arm_mpam: Generate a configuration for min controls
>   arm_mpam: Quirk CMN-650's CSU NRDY behaviour
>
> Jiapeng Chong (1):
>   arm_mpam: Remove duplicate linux/srcu.h header
>
> Shanker Donthineni (4):
>   arm_mpam: Add quirk framework
>   arm_mpam: Add workaround for T241-MPAM-1
>   arm_mpam: Add workaround for T241-MPAM-4
>   arm_mpam: Add workaround for T241-MPAM-6
>
>  Documentation/arch/arm64/silicon-errata.rst |    9 +
>  arch/arm64/Kconfig                          |    6 +-
>  arch/arm64/include/asm/el2_setup.h          |    3 +-
>  arch/arm64/include/asm/mpam.h               |   98 +
>  arch/arm64/include/asm/resctrl.h            |    2 +
>  arch/arm64/include/asm/thread_info.h        |    3 +
>  arch/arm64/kernel/Makefile                  |    1 +
>  arch/arm64/kernel/cpufeature.c              |   21 +-
>  arch/arm64/kernel/mpam.c                    |   58 +
>  arch/arm64/kernel/process.c                 |    7 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h     |   12 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c          |    8 +
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c          |   13 +
>  arch/arm64/kvm/sys_regs.c                   |    2 +
>  arch/arm64/tools/sysreg                     |    8 +
>  drivers/resctrl/Kconfig                     |    9 +-
>  drivers/resctrl/Makefile                    |    1 +
>  drivers/resctrl/mpam_devices.c              |  306 ++-
>  drivers/resctrl/mpam_internal.h             |  131 +-
>  drivers/resctrl/mpam_resctrl.c              | 1930 +++++++++++++++++++
>  drivers/resctrl/test_mpam_devices.c         |   66 +
>  drivers/resctrl/test_mpam_resctrl.c         |  426 ++++
>  include/linux/arm_mpam.h                    |   32 +
>  23 files changed, 3119 insertions(+), 33 deletions(-)
>  create mode 100644 arch/arm64/include/asm/mpam.h
>  create mode 100644 arch/arm64/include/asm/resctrl.h
>  create mode 100644 arch/arm64/kernel/mpam.c
>  create mode 100644 drivers/resctrl/mpam_resctrl.c
>  create mode 100644 drivers/resctrl/test_mpam_resctrl.c

Like before, I applied the patches and successfully booted a kernel on
a baremetal Google Cloud C4A instance. I was able to confirm that the
resources we expect were present and I was able to successfully run
the monitor assignment test cases I used to validate ABMC on AMD
systems. (Though I had to hack the driver to pretend there were less
MBWU monitors so that the counter assignment interfaces would become
available.)

My use cases only cover resctrl in the host, so I didn't try any of
the KVM integration, but I can at least say there wasn't any evidence
that it interfered with resctrl.

Tested-by: Peter Newman <peternewman@google.com>

Thanks,
-Peter
