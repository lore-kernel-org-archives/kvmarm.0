Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1768E26B742
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 21:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759527280; cv=none; b=Xxk+OikYuCys2h35O0L8uhfB1TVyNlTwj9eBKzYIcHix1HGWs/4qx0qbpiRb9b4WqZAXi/2dTdDrwLGKIyq/+0+Bhkt1zRSiuPXq4QMyqjwmSK0TOjy+lItfTsEyzvO/WO4gqpdZdgp0ILsxtOG4YzHbsChnoREuNjlVahzScHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759527280; c=relaxed/simple;
	bh=i2NrTqq/SkzZHBEgQ7eO1+wlsUWMi9F4A/jiIevvQwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IegLFIb3ID54gw0HULdMahV33pcx89PV9PPa2g/Kh/p9TWqyIwy452B62yH6pJ5fV17+53DR1rcQSPqHeEgnqR/gpEucYSMizWVUtUqbub6rw8QAxTxWkFSPPfwpGOu58b4auMGSxCM4MagBl6PTrdd5KKj/w7jWNTxw9YnuIEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dc4BMUOM; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dc4BMUOM"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e3bcf272aso19145e9.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 14:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759527275; x=1760132075; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AolOsZu5isQ6acd/8wA384z0bhlwgTK8nhLOayCIhiU=;
        b=dc4BMUOMa0eS86Fap67U6oWy7McavXzCP/UQq4JU9YkBPDMcLWiNB9W0Q6InwGwoTW
         jCIWgo2kPg7AgoIeioC7JeHekd3y7wUE+dnn/ZYALqNRbSnDQHo2D5504Ys7PkmxJNkJ
         NNqLGcTpnki9GlzmgRM8AYSpDiujDydIarBo6+w4D/RCLFm5yY9YpYnb08MtiEneCqCY
         viOhAeumQK5REKf5z5IPsI1Rr1IsynZvwUsP7+FqsqUfaAcmqdP8NDyzRNtVA7mfXKP3
         /iXtM9eXfUUi7rjHMXoyOOFKi6UFmEzndRQ/HMNphmS1tC3rG7TdJ23p3aYesJjRMWUM
         ebgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759527275; x=1760132075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AolOsZu5isQ6acd/8wA384z0bhlwgTK8nhLOayCIhiU=;
        b=pigSEc5SbIzD9dSAwzsne5wnVosGwol9K40xqBTEuSVWwLDJsUCFBzXpjx282RVa04
         Y5oPSii2weQDik9+BQtPzj2UuDEer0R/jRDVYlYoSoFoTNzRjnkBKnPkj5/UDS0rGSJu
         nTEsCgbg7IssT0cjsZiMkYdr8x8mvYhvDV+jBAd/i298Wus8yy303HhZjwOfhdTSCmc+
         2Sae8H4zRpXd7DAXdAoMTrmoTczZn+Wa2J1w0RfStFnvuzdG1Heuwm5UiNkrzsD/cPTK
         Go4X8IxnEw4aQiFGWIbATdON50MxZsdS0dpasH2OEz7K/juBvTXX7UF9ixv+o+jLrxZl
         hN5A==
X-Forwarded-Encrypted: i=1; AJvYcCXIKe63LGhIsUf6cF6ZF0oSKDdKw0YfKTaUI/B1Acc51yhDL95CmNHjljwyKD+Cc41ccm7SfYc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaLMPijEGNByM8j/6S81N+51meu8tscAsKybsFT5tuKGUqYDrx
	7F2Un6N4V9Vp5VSq9JXfKos70K091Rg3cc2tKAjyL5mDZI6m2C+UB0aUwoiUJ541paN5yD3mB0A
	2hP3aOOnrAvAGqe+Ey4VGVK+N1Gj8AOUYoSslF2S8XmKsZsZhPxOvP+mxXWg=
X-Gm-Gg: ASbGnct+4kockUYdnS6zIL47FNXMlNO+xw15MinPc8cDIPn0KUjelw7odMgJBxZNRUu
	0Yhy5TKfmX+yOWHSYoH8eSFO6xgIPerxWS9VVpWn80PEhRhAXWR9zUPGKJBCnBu+8FIZCwXSOwk
	W4z96DgX7ZUzgXXImVPpc5piYwd52R3/RUeDQj+rJS9h1GbxxRSjForj5AUmRn0q1VU5G3mN0Qo
	5KMlk+7cncPen/OeE4vcEHB9vlg8Zptc7ldGp2ZBkMgzL+9LcyJT3sN9j6NxQHfu33Dc40B5QPP
	FYU=
X-Google-Smtp-Source: AGHT+IG+g888nHbRtas0R01E+jPK4UfBpLJ8GQnOWINQky6xv5HWVReEjuHHu18tH8G5o/mleUJVD+7aBJEJSt2Urkg=
X-Received: by 2002:a05:600c:8582:b0:45f:2e6d:ca01 with SMTP id
 5b1f17b1804b1-46e789ad00amr340925e9.4.1759527275228; Fri, 03 Oct 2025
 14:34:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250731205844.1346839-1-jiaqiyan@google.com>
In-Reply-To: <20250731205844.1346839-1-jiaqiyan@google.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 3 Oct 2025 14:34:23 -0700
X-Gm-Features: AS18NWC200qL2INhmKRcSigwRYSlRaKCFejFFI6CifV04SzXltQ6LUTRzublc7I
Message-ID: <CACw3F51QG70YpSfWaj_gQjAwoPcZ6uFa5dfd+Ave5PxQYDt-Ew@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc, Oliver, and other upstream friends, can you help review this
patch series? I would really appreciate any comments and feedback.

[sorry for resending, as previous msg was sent as HTML]



On Thu, Jul 31, 2025 at 1:58=E2=80=AFPM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> Problem
> =3D=3D=3D=3D=3D=3D=3D
>
> When host APEI is unable to claim a synchronous external abort (SEA)
> during guest abort, today KVM directly injects an asynchronous SError
> into the VCPU then resumes it. The injected SError usually results in
> unpleasant guest kernel panic.
>
> One of the major situation of guest SEA is when VCPU consumes recoverable
> uncorrected memory error (UER), which is not uncommon at all in modern
> datacenter servers with large amounts of physical memory. Although SError
> and guest panic is sufficient to stop the propagation of corrupted memory=
,
> there is room to recover from an UER in a more graceful manner.
>
> Proposed Solution
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The idea is, we can replay the SEA to the faulting VCPU. If the memory
> error consumption or the fault that cause SEA is not from guest kernel,
> the blast radius can be limited to the poison-consuming guest process,
> while the VM can keep running.
>
> In addition, instead of doing under the hood without involving userspace,
> there are benefits to redirect the SEA to VMM:
>
> - VM customers care about the disruptions caused by memory errors, and
>   VMM usually has the responsibility to start the process of notifying
>   the customers of memory error events in their VMs. For example some
>   cloud provider emits a critical log in their observability UI [1], and
>   provides a playbook for customers on how to mitigate disruptions to
>   their workloads.
>
> - VMM can protect future memory error consumption by unmapping the poison=
ed
>   pages from stage-2 page table with KVM userfault [2], or by splitting t=
he
>   memslot that contains the poisoned pages.
>
> - VMM can keep track of SEA events in the VM. When VMM thinks the status
>   on the host or the VM is bad enough, e.g. number of distinct SEAs
>   exceeds a threshold, it can restart the VM on another healthy host.
>
> - Behavior parity with x86 architecture. When machine check exception
>   (MCE) is caused by VCPU, kernel or KVM signals userspace SIGBUS to
>   let VMM either recover from the MCE, or terminate itself with VM.
>   The prior RFC proposes to implement SIGBUS on arm64 as well, but
>   Marc preferred KVM exit over signal [3]. However, implementation
>   aside, returning SEA to VMM is on par with returning MCE to VMM.
>
> Once SEA is redirected to VMM, among other actions, VMM is encouraged
> to inject external aborts into the faulting VCPU.
>
> New UAPIs
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This patchset introduces following userspace-visible changes to empower
> VMM to control what happens for SEA on guest memory:
>
> - KVM_CAP_ARM_SEA_TO_USER. While taking SEA, if userspace has enabled
>   this new capability at VM creation, and the SEA is not owned by kernel
>   allocated memory, instead of injecting SError, return KVM_EXIT_ARM_SEA
>   to userspace.
>
> - KVM_EXIT_ARM_SEA. This is the VM exit reason VMM gets. The details
>   about the SEA is provided in arm_sea as much as possible, including
>   sanitized ESR value at EL2, faulting guest virtual and physical
>   addresses if available.
>
> * From v2 [4]:
>   - Rebased on "[PATCH] KVM: arm64: nv: Handle SEAs due to VNCR redirecti=
on" [5]
>     and kvmarm/next commit 7b8346bd9fce ("KVM: arm64: Don't attempt vLPI
>     mappings when vPE allocation is disabled")
>   - Took the host_owns_sea implementation from Oliver [6, 7].
>   - Excluded the guest SEA injection patches.
>   - Updated selftest.
>
> * From v1 [8]:
>   - Rebased on commit 4d62121ce9b5 ("KVM: arm64: vgic-debug: Avoid
>     dereferencing NULL ITE pointer").
>   - Sanitize ESR_EL2 before reporting it to userspace.
>   - Do not do KVM_EXIT_ARM_SEA when SEA is caused by memory allocated to
>     stage-2 translation table.
>
> [1] https://cloud.google.com/solutions/sap/docs/manage-host-errors
> [2] https://lore.kernel.org/kvm/20250109204929.1106563-1-jthoughton@googl=
e.com
> [3] https://lore.kernel.org/kvm/86pljbqqh0.wl-maz@kernel.org
> [4] https://lore.kernel.org/kvm/20250604050902.3944054-1-jiaqiyan@google.=
com/
> [5] https://lore.kernel.org/kvmarm/20250729182342.3281742-1-oliver.upton@=
linux.dev/
> [6] https://lore.kernel.org/kvm/aHFohmTb9qR_JG1E@linux.dev/#t
> [7] https://lore.kernel.org/kvm/aHK-DPufhLy5Dtuk@linux.dev/
> [8] https://lore.kernel.org/kvm/20250505161412.1926643-1-jiaqiyan@google.=
com
>
> Jiaqi Yan (3):
>   KVM: arm64: VM exit to userspace to handle SEA
>   KVM: selftests: Test for KVM_EXIT_ARM_SEA
>   Documentation: kvm: new UAPI for handling SEA
>
>  Documentation/virt/kvm/api.rst                |  61 ++++
>  arch/arm64/include/asm/kvm_host.h             |   2 +
>  arch/arm64/kvm/arm.c                          |   5 +
>  arch/arm64/kvm/mmu.c                          |  68 +++-
>  include/uapi/linux/kvm.h                      |  10 +
>  tools/arch/arm64/include/asm/esr.h            |   2 +
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../testing/selftests/kvm/arm64/sea_to_user.c | 327 ++++++++++++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
>  9 files changed, 476 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/arm64/sea_to_user.c
>
> --
> 2.50.1.565.gc32cd1483b-goog
>
