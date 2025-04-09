Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D13E1D61B7
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 19:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744228431; cv=none; b=h3zEasRNhZ1WWJrqJp04XlXm7Wr+IUKFmJJlUtvkD7QVy7oloYB1HByNP43tAmAhbPHpCMBBmwLko9J8EmY53DWOj8I7xcOBV2t+8MLsnkDV0pmaFD6FzR9po7DU4GQRFXeXXODSdqcuLgdkMGUJ4vrlnTfBaCo7v+ErInSW+C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744228431; c=relaxed/simple;
	bh=rv4mMwuG4jkn773xC8sA0ToKXoLaQgRn7SHaoclVUrY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bLxqrI1vdlQ6rZNLaUgLW8r6NlUfD92DtL+7FEaeSnVOztB9Mwu5ivjgdRO3scMf2jorFovFnbE5mgYVtV8XekzD2CMwO76XRfhV2CNI4mD14Z0PA/RzS60ntXZUTSrnxrzR1U75j/I0yj7mlrKajBnp1Hnf5HPMDh/WqVyy70k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y/9XbN1z; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y/9XbN1z"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-72f3b4c0305so16827b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Apr 2025 12:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744228429; x=1744833229; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B/LBm3aV4zfAmxi92/BK6RmsqnpaBnCdXpzKq52/Foc=;
        b=y/9XbN1z1d0a5/UEfCv4OYDz1Z7QUMUhsEk/FqUgsnHYQtYPzWFgQtIuueRlfJE8zx
         oA12mOHF2mby27ajADHmidfMaDyP6OCBmAB9qsrpF6O8hGy5ZLUAjq4coL7mHfd/uW7s
         uwY0rhvvK2XE8DuXLkwYAmsGwT7+57q9AJ17FCeETqrPMB8bJEBtA04IwaNP5B8fZWKj
         zyirFWPcyB0D9afbtWfbwWqHQV7I5RO1wDJw7XUPWeGEZLFcyNzATsPP9ohqhnYdwz8y
         5iF9o/jWKeFgM+KtXLRI98qu/dnXxQW7TCYrUDWwKqqbxzPfcXyjkQsYDSED11N3srYB
         JRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744228429; x=1744833229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B/LBm3aV4zfAmxi92/BK6RmsqnpaBnCdXpzKq52/Foc=;
        b=LKdNwXSuq2enksqbagsFesL/t8blOYOMkWltFByWDqcM4zF4hQQBNWaFi/jbKUi5py
         pBDlc2tkp7pxZSmbF3VJg1mTva+Rz3gthN9cr4EW0/WJu53oFSphWuiN25gOCiep2TYp
         +eCAWyNWJmmD70rVLDXjXvwzqIrehXJF5vvLsPyrd7fW/CYDUUx7lLphwBLr5JY91c+g
         YIIBXTiFILi3e0Rb+AiXpdDoqoINrhLbunXm4Rl1maDbS3tcO/zphqDc0s6chQi76ydM
         nlfdkIz2K5P22+DFfg1LTRqBpz8lwlO9oCpsGAxrZIFAQOiehAtQbU54PAhas4UvdHK0
         HIcg==
X-Forwarded-Encrypted: i=1; AJvYcCUneGwevwRtzxTw6f8WKi7HFglQn6COg5uQ+5i5N7TO6ZjpMxn+ulfksKGOu2R4YB6x2mUC1a8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNm8yB9/kX7DZPtUw6ePA5QA3kXV/LwinFGLEgztD4VoyN8GrL
	aMp2Bp75MFT78yiGsNahYfdpfMNAeFnHXEh0nj4mEWmU4syQW6vWiFYv9tN8zDRaPFjIGy2vX14
	9HQ==
X-Google-Smtp-Source: AGHT+IEeESm/upruWypiAiAFjj3gqiD2FWPZpn5Oi58JT7YjI+D2LtDvdvxhwdzcKYcXLoDvWUFBt/R8XtU=
X-Received: from pfkq6.prod.google.com ([2002:a05:6a00:846:b0:737:6e43:8e34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:130c:b0:736:bfc4:ef2c
 with SMTP id d2e1a72fcca58-73bbec49ac8mr221785b3a.0.1744228428902; Wed, 09
 Apr 2025 12:53:48 -0700 (PDT)
Date: Wed, 9 Apr 2025 12:53:47 -0700
In-Reply-To: <20250409014136.2816971-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
Message-ID: <Z_bQS63A2bd-LzgQ@google.com>
Subject: Re: [PATCH v2 0/4] KVM: extract lock_all_vcpus/unlock_all_vcpus
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvm-riscv@lists.infradead.org, 
	Oliver Upton <oliver.upton@linux.dev>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jing Zhang <jingzhangos@google.com>, Waiman Long <longman@redhat.com>, x86@kernel.org, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Albert Ou <aou@eecs.berkeley.edu>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>, 
	Borislav Petkov <bp@alien8.de>, Alexandre Ghiti <alex@ghiti.fr>, 
	Keisuke Nishimura <keisuke.nishimura@inria.fr>, Sebastian Ott <sebott@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, linux-riscv@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"

+Adrian

On Tue, Apr 08, 2025, Maxim Levitsky wrote:
> Implement Paolo's suggestion of reusing

Ha!  I *knew* this felt familiar when I suggested extracting (un)lock_all_vcpus()
to common code in the context of the TDX series.

https://lore.kernel.org/all/Z-V0qyTn2bXdrPF7@google.com

> sev_lock/unlock_vcpus_for_migration in arm and riscv code
> for the purpose of taking vcpu->mutex of all vcpus of a VM.
> 
> Because sev_lock/unlock_vcpus_for_migration already have a workaround
> for lockdep max lock depth, this fixes the lockdep warnings on arm
> which were the inspiration for this refactoring.
> 
> This patch series was only compile tested on all 3 architectures.
> 
> V2: added trylock option to kvm_lock_all_vcpus to be better compatible
> with the orginal code.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (4):
>   locking/mutex: implement mutex_trylock_nested
>   KVM: x86: move sev_lock/unlock_vcpus_for_migration to kvm_main.c
>   KVM: arm64: switch to using kvm_lock/unlock_all_vcpus
>   RISC-V: KVM: switch to kvm_lock/unlock_all_vcpus
> 
>  arch/arm64/include/asm/kvm_host.h     |  3 --
>  arch/arm64/kvm/arch_timer.c           |  4 +-
>  arch/arm64/kvm/arm.c                  | 43 ----------------
>  arch/arm64/kvm/vgic/vgic-init.c       |  4 +-
>  arch/arm64/kvm/vgic/vgic-its.c        |  8 +--
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++---
>  arch/riscv/kvm/aia_device.c           | 34 +------------
>  arch/x86/kvm/svm/sev.c                | 65 ++----------------------
>  include/linux/kvm_host.h              |  6 +++
>  include/linux/mutex.h                 |  8 +++
>  kernel/locking/mutex.c                | 14 ++++--
>  virt/kvm/kvm_main.c                   | 71 +++++++++++++++++++++++++++
>  12 files changed, 116 insertions(+), 156 deletions(-)
> 
> -- 
> 2.26.3
> 
> 
