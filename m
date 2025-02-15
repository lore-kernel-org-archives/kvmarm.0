Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FB41ACEAD
	for <kvmarm@lists.linux.dev>; Sat, 15 Feb 2025 00:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581001; cv=none; b=tqCwMkn2a1Cg+rTn81aS72AaY2L6swtOr+gIjYjtBFJJn3jVT+MhKkX4dG/9FyfWewtM/cJbPl3VcNkg1H6kFTAIxjERBf9aaNnZu7usajZ7B2l8LZiDTgBquuwThMh5haFFl9vc1++47kNwls7q8ihqGj4FROB0flcXIisM3KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581001; c=relaxed/simple;
	bh=t5fBXrvCr67phNEupZpwrfY2MdXvaC6HpdmBwzxxlCs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=On0FuHuiz9hlMIHTSn62hfKIy182sYiuPYXkVGneKww1GAZ/BEEX+zIMmMDJWzgVgNi9vZ/zJLpR6fiHHF+LwcYf0gp+DJN2H9lScxN+s1KWovHq5gbz9Iy6u4hMtOyiHbeOBkivEMZuPxpZiPLcPV+5vu8gaXxP1wPNVgsZHkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DxPEZB4I; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DxPEZB4I"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f81a0d0a18so5183565a91.3
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 16:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580999; x=1740185799; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=clvSOaTIwEa9bgc9cdZpN3zTDEuSaQ80Bs4rjxPQt4M=;
        b=DxPEZB4Iiw5igfRqDsQ9uFTl3vy0r9pgh2SHK/XpF3rTwTzywAZF1M5DHbPkG+YrVc
         CHSVyZfzOd8XkcCJSm7PIht3v5+OnZdU0gNKjJ+TDit1sqDPwuFTB76XZMBQKp4FUOoY
         gwk9SWtRoCb5Ei3jdj5hybdSmyBWQVfFTQeWOlS4agUsxjLmn1yJfqq2hI1ac5rT40Cd
         sXsX94RkX9iUM7JqZz3tVQscmzWto6vjmr3e40/89/q5Q5PMAamgCOUgr5142mBnBtXm
         ojKBcqLQCRkqwUih5wFQuUXDpjoEPf7TP1kgeuSkkyqkm+W1qZAAMotuATZe88llO17D
         hGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580999; x=1740185799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clvSOaTIwEa9bgc9cdZpN3zTDEuSaQ80Bs4rjxPQt4M=;
        b=C/HW/Ff45ybuQZ++5lSF0ySLAUz18vcKCxbcYn0IxE5HNn1yAdhLgynXtArqcNytWB
         50MC8fhi/A5xYCyrsAFY3FYvWusXd4/t5LTXMu/q/1ITIj8oKwbs0B9Wg2//WvuszwNn
         MeBgBwTqn32gp/2DjSKAlr6jqrRAcUn7bFQiG+l8BvPqP8rnaTtFgWZKv37N8Ihs5fxn
         IYCimvm7mehXsVmOoq/phF4eFsoF/ZFUSlLlrfoyLuQRH4cVq8Aj2Xl8vmdqOIjfIlPp
         VUfen7apjAtEfKz2ESPTN5ll7d4/0YyjFiZjl1VkmFycLTbYunAafyC0LqLNJNX2ArGI
         Cyjw==
X-Forwarded-Encrypted: i=1; AJvYcCXEQUP+onJ4JYULhJKXfPNAvWRd7NPE/1s7UkEooYPEWNba533KudvcRs5ta2fEqBAOj9j7Lhc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbXP33oorp7koC2gtCIWYmU32ir4gNUnThiz3DPuinI+YNtMCM
	mmMS4SpHzqIKOpA9aE2eGvvRiNvCsz8tchHk2T7aE7vGQ06DOT04EEh8A4Jp1XfzCr0W9Z9jAYj
	ZfQ==
X-Google-Smtp-Source: AGHT+IEDBkpXU3G4/lKZrs/PoISbfgAX1w1fyvpk5cFq3/CN1zXVNsLI9tdZL04a2XEND4anIVs8+UjqyEg=
X-Received: from pjbsp4.prod.google.com ([2002:a17:90b:52c4:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a49:b0:2ea:aa56:499
 with SMTP id 98e67ed59e1d1-2fc40d13e61mr1911642a91.1.1739580998875; Fri, 14
 Feb 2025 16:56:38 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:35 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958028389.1189761.4728178272323667525.b4-ty@google.com>
Subject: Re: [PATCH v2 0/9] KVM: selftests: Binary stats fixes and infra updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 10 Jan 2025 16:50:40 -0800, Sean Christopherson wrote:
> Fix a handful of bugs in the binary stats infrastructure, expand support
> to vCPU-scoped stats, enumerate all KVM stats in selftests, and use the
> enumerated stats to assert at compile-time that {vm,vcpu}_get_stat() is
> getting a stat that actually exists.
> 
> Most of the bugs are benign, and AFAICT, none actually cause problems in
> the current code base.  The worst of the bugs is lack of validation that
> the requested stat actually exists, which is quite annoying if someone
> fat fingers a stat name, tries to get a vCPU stat on a VM FD, etc.
> 
> [...]

Applied to kvm-x86 selftests (attempt #2).  Like the previous attempt, I skipped
the compile-time assertions.

[1/9] KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
      https://github.com/kvm-x86/linux/commit/fd546aba1967
[2/9] KVM: selftests: Close VM's binary stats FD when releasing VM
      https://github.com/kvm-x86/linux/commit/f7f232a01f3d
[3/9] KVM: selftests: Assert that __vm_get_stat() actually finds a stat
      https://github.com/kvm-x86/linux/commit/eead13d493af
[4/9] KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name string
      https://github.com/kvm-x86/linux/commit/b0c3f5df9291
[5/9] KVM: selftests: Add struct and helpers to wrap binary stats cache
      https://github.com/kvm-x86/linux/commit/e65faf71bd54
[6/9] KVM: selftests: Get VM's binary stats FD when opening VM
      https://github.com/kvm-x86/linux/commit/ea7179f99514
[7/9] KVM: selftests: Adjust number of files rlimit for all "standard" VMs
      https://github.com/kvm-x86/linux/commit/9b56532b8a59
[8/9] KVM: selftests: Add infrastructure for getting vCPU binary stats
      https://github.com/kvm-x86/linux/commit/16fc7cb406a5
[9/9] KVM: selftests: Add compile-time assertions to guard against stats typos
      (no commit info)

--
https://github.com/kvm-x86/linux/tree/next
