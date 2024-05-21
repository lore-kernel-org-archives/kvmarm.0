Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95B1448CD
	for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 16:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309445; cv=none; b=npqeXc5XlBznI1AHX86bC6Mr0foS5/T9tVVRXGJ9fmV+Z7NdC3BKsnzCVvC2liTQ64pJadOL3oANPsXfm++eMGU/9K0kuckkONUaLBxOzqceWPgxOalI4yvsf/Jz3I0Ydfdsl6oJIzNMNjWyi8cVI5PF2vhI8IM+nAJTKNIuPH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309445; c=relaxed/simple;
	bh=GZPQsjY4w/ao92kOg+wXFYI2HdJeasDGrDpNGHJaamQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RmLlB5ZYiAFgz4rVOpgvIz2LgV3JYj+VDQhDfbhpvsdzEFdxyScMSMNT/0R11heNWRjUkgyMXGkIZs6TGKNwXVQ0WpxOSKAr7u8S/QC3nC6Oh/UqAb2eF42pX6Q68V4SQuQTvpmwfLVgG7ZYAbzU8jN3EwftqRmcW5A1wm46n8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3snAQMfo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3snAQMfo"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61510f72bb3so248871487b3.0
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 09:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716309443; x=1716914243; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9H/gMcLsyDJucs2LHXIMRNEaJIU2Gh10NsbC0rjpD9E=;
        b=3snAQMfoyl+sUxmAiL131ltN18Vk6RM/T9E7neVfRFDUL8370IMR8BBdpXIe9pa+M7
         3eWijYIURXkXlJC0zbnePg3L/EIo/D2LMoSiPtp2gGEaJk/j3BR6lGFl3iGXsLpONKr5
         AKhT54IwdiPy96iXDlyDoJbfm5OdcADNF2o4uj6i/3UGNsM9tLPrtMOySPfAV2TckKcW
         HcJayp7Gujkv1wqcyzbGVD1STda8mS4zZMTXcxzMUyaDj4uQqxjrdQ7cQrpdbsFEEQ4n
         qxqLbbW0u1NMwjUx+4TS2ec789YXaAh9+fYx6DTKqagn9rzqQB5C449vz63ykglL3Ma3
         IWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716309443; x=1716914243;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9H/gMcLsyDJucs2LHXIMRNEaJIU2Gh10NsbC0rjpD9E=;
        b=urKCZn45fqclnu7xsJNQilGrW7XGbeImMTfWC+gNeFohQEQvec3f8IW6HZoO41wQYa
         1iF79VU7iKwZIG9CJtPKVBV+hDijPyeqk4R5ufI89ci55iFkrbC8JzQCikiEjjof3u6g
         8eYv7p1FrhCRQ+KBFJoqKTZFlPIaZiRh8LkV/DhSBYqjPEv0MQBweI4whItFHVIVomNR
         zrlef/4s4kYjcu/pXrVMgd9D92gNhKu7eX01bvTkh+r4e1sjoH0Izqb6IHkOiy71iv7V
         mdXWcKOi537x7n/LdAXda62GauxWiTQ5pjXeCuTzhCbBgeQF97SIttRlm55G2vsVlYNw
         BoUw==
X-Gm-Message-State: AOJu0Yx+gW+wsu51pQPgz4CTS+vihhdN/fzBBrImLPuYk6cGVxLaT+/m
	dsCj/yd7lj7Y7UqYv3n7bArhFPEf9n4omhe5Iy24zQgSjnhAdv1mTdvX3V4jWoXtDy5CRSherWG
	CTvEMv451+Z70+xe2AD2Rn6xe3MgchFA8BkxQAMqqHH3dmNxqz38WY5QE50+EfpXyRWvwEVCx1t
	x2Vo+I5RsptdX8CxYvzW7booVhOgs=
X-Google-Smtp-Source: AGHT+IHF4VAxf51SQ9BhAxC106xZQPZC8bNXkGiibnlQhe1c51MdWVz/W2UuC70v8OugdnbNT2vK1g6wPA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:6646:0:b0:de4:f7d9:3310 with SMTP id
 3f1490d57ef6-dee4f2ded34mr7873124276.4.1716309443138; Tue, 21 May 2024
 09:37:23 -0700 (PDT)
Date: Tue, 21 May 2024 17:37:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240521163720.3812851-1-tabba@google.com>
Subject: [PATCH v2 0/7] KVM: arm64: Fix handling of host fpsimd/sve state in
 protected mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Changes since v1 [1]
- Introduced a new helper, cpacr_clear_set(), which abstracts
setting/clearing CPTR_EL2 or CPACR_EL1, depending on the mode
(vhe/nvhe/hvhe) (Oliver)
- Dropped the patch that specializes deactivating fpsimd/sve
traps on guest trap, since the new helper removes the need for
doing that

With the KVM host data rework [2], handling of fpsimd and sve
state in protected mode is done at hyp. For protected VMs, we
don't want to leak any guest state to the host, including whether
a guest has used fpsimd/sve.

To complete the work started with the host data rework, in
regards to protected mode, ensure that the host's fpsimd context
and its sve context are restored on guest exit, since the rework
has hidden the fpsimd/sve state from the host.

This patch series eagerly restores the host fpsimd/sve state on
guest exit when running in protected mode, which happens only if
the guest has used fpsimd/sve. This means that the saving of the
state is lazy, similar to the behavior of KVM in other modes, but
the restoration of the host state is eager.

This series is based on kvmarm-6.10-1 (kvmarm/next). It should
not have any functional effect on modes other than protected mode.

Tested on qemu, with the kernel sve stress tests.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20240517131814.719933-1-tabba@google.com/
[2] https://lore.kernel.org/all/20240322170945.3292593-1-maz@kernel.org/

Fuad Tabba (7):
  KVM: arm64: Reintroduce __sve_save_state
  KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
  KVM: arm64: Specialize handling of host fpsimd state on trap
  KVM: arm64: Store the maximum sve vector length at hyp
  KVM: arm64: Allocate memory at hyp for host sve state in pKVM
  KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
  KVM: arm64: Consolidate initializing the host data's fpsimd_state/sve
    in pKVM

 arch/arm64/include/asm/kvm_emulate.h    | 34 +++++++++++
 arch/arm64/include/asm/kvm_host.h       | 11 +++-
 arch/arm64/include/asm/kvm_hyp.h        |  2 +
 arch/arm64/include/asm/kvm_pkvm.h       |  9 +++
 arch/arm64/include/uapi/asm/ptrace.h    | 14 +++++
 arch/arm64/kvm/arm.c                    | 75 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/fpsimd.S             |  6 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 32 ++++++-----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 59 ++++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 15 ++---
 arch/arm64/kvm/hyp/nvhe/setup.c         | 25 ++++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 19 +++++++
 arch/arm64/kvm/hyp/vhe/switch.c         |  5 ++
 arch/arm64/kvm/reset.c                  |  2 +
 15 files changed, 273 insertions(+), 36 deletions(-)


base-commit: eaa46a28d59655aa89a8fb885affa6fc0de44376
-- 
2.45.0.215.g3402c0e53f-goog

