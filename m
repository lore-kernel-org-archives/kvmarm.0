Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45E1CBE97
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 19:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404689; cv=none; b=FLkOcViIeJlHzFuNt6+cr9yeZfjUJEqCWB8hnkARZcxxLbIdn5he/3vWY84sARepkVrfW53yjeVzMDqhisIb3XVQ/RGirZhFALt2eBJssg+E72Wge9/AR9pA/+TVcVUusGbTjoPwEe4k/kavLBlDlO1Nw/aKVAFZ99jgc+Mlxdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404689; c=relaxed/simple;
	bh=Ene4XBpjeGsq36rc0IQrdysqTlwlDeZGDAKixhoHnFI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sA4nnfiAbcmLCz0NXfNgOM+EWX+tqiBIYbNUtAE9oLhBcRfhQmm9OD/QoYgW4Dm57xHtz/cCZ7IhhDoXK1KmFnrz12zXJRB2ULZ0kezQB8aGW9KBaZWA2nsCtOkCSZBMRgt3SYaknF09AzOLYSmiKcw1Xbap90f6YUj+l1d7XF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sGnmyNNX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sGnmyNNX"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7eaac1e95ffso1331644a12.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 12:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404687; x=1731009487; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RD5TkR246EsKLWEa1qebyIvoAMqqwjYwsx4rtMlmzqs=;
        b=sGnmyNNXEg+lNJZNryVGmMYTkqejswTHpHere19iPYX1zDnuE/yeO5G7dK9/zaGmPa
         AZTIZpuc6NhvYCwC/MkLqJkLwQQTpBbbLTfmBMqC9vsQUfO95y5vrnNtO+H9nxuyur5a
         RmVzgZq1KQybIo+bJ/9/9ABL3vvVEIwYSNcF2oAkLrC3J+XseAOm8nZ8u4IIRVxiEkfg
         VqxVW2Oqaynxorivkn/OcTBGdJERtwmYPXltKhppTS7syB+ynCgN6L+2QBFv+IMROojI
         ieNt7RMcoQ6o+4CC+PjAxTLrtJ+/75FUFc7YNifydCYYFzCidHzZ7wS+c4buMj4/uZRd
         tmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404687; x=1731009487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RD5TkR246EsKLWEa1qebyIvoAMqqwjYwsx4rtMlmzqs=;
        b=Adbii0BJ+PtQvUVc1+6t3dQCdn1z+gWyeKy30ta1y3HuV9iaGba7z6YHg5RNrAMgZ0
         EjIMvrTw7UrTTkZtmXjDeF9NytbsOXZ6XLTJUVaPwJjJW991twJa0qrxWdDuPV4Oj/S+
         1LyH/YP4agx8O4hRMqzTy1V+fqe59ggIyeke/MDpzAtWf0sZZgrYEMLAmjTa9AStz/D2
         H6zWZ0cgYuUueUtJcIwOme4etIaXBh5SbY+5ZuZYwWqvWAatarHodQu17in4XjHA+k6f
         jjXywzXj9xHDWcY9a6oxA60L7L3t+GkU9Eg1PJjx5r8m9tCruiNoop6rvf26bQDZ1cp4
         1AUA==
X-Forwarded-Encrypted: i=1; AJvYcCXOU7/0smyjO9hQ1+Cf2vGZfdnt0G6rRw7vItYpmi9bQqScAbSwLZT51fo1CWIXyUUSvUjBEHM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4EzKMhjw8coDMgaUfcMoUje5NtcCwFoWxwQyBOtiqxv/0H0OL
	Mio5yBYcwHaQCJ6I6wtwylTOSP8EwNMN4VRtXGH4dJ63UkOCJjSKvoLmtDOP+UZp51dkLzm2SY6
	YwQ==
X-Google-Smtp-Source: AGHT+IF7vPMCnsf289NsrnjjyCJ2jg68bo1NjMnBqv1ndlVw/EyDldgRRbbWWMUr551ln7/BYp8yDv7S73k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2c4a:b0:2e2:d3dc:d3ca with SMTP id
 98e67ed59e1d1-2e8f0d4bd47mr35478a91.0.1730404686850; Thu, 31 Oct 2024
 12:58:06 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:56 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039503553.1508387.3074658713815866060.b4-ty@google.com>
Subject: Re: [PATCH v3 00/14] KVM: selftests: Morph max_guest_mem to mmu_stress
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 09 Oct 2024 08:49:39 -0700, Sean Christopherson wrote:
> The main purpose of this series is to convert the max_guest_memory_test
> into a more generic mmu_stress_test.  The basic gist of the "conversion"
> is to have the test do mprotect() on guest memory while vCPUs are
> accessing said memory, e.g. to verify KVM and mmu_notifiers are working
> as intended.
> 
> Patches 1-4 are a somewhat unexpected side quest.  The original plan was
> that patch 3 would be a single patch, but things snowballed.
> 
> [...]

Applied to kvm-x86 selftests, with the typo fixup pointed out by James.  Thanks!

[01/14] KVM: Move KVM_REG_SIZE() definition to common uAPI header
        https://github.com/kvm-x86/linux/commit/5e07fd0bf516
[02/14] KVM: selftests: Disable strict aliasing
        https://github.com/kvm-x86/linux/commit/d1ce2bcd8d2e
[03/14] KVM: selftests: Return a value from vcpu_get_reg() instead of using an out-param
        https://github.com/kvm-x86/linux/commit/5c6c7b71a45c
[04/14] KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
        https://github.com/kvm-x86/linux/commit/6aa2df3eb90b
[05/14] KVM: selftests: Check for a potential unhandled exception iff KVM_RUN succeeded
        https://github.com/kvm-x86/linux/commit/be9f2746d20b
[06/14] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
        https://github.com/kvm-x86/linux/commit/06694f27cfcc
[07/14] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
        https://github.com/kvm-x86/linux/commit/8556ce365a07
[08/14] KVM: selftests: Compute number of extra pages needed in mmu_stress_test
        https://github.com/kvm-x86/linux/commit/c7b7876ac5d4
[09/14] KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
        https://github.com/kvm-x86/linux/commit/a657856469e1
[10/14] KVM: selftests: Enable mmu_stress_test on arm64
        https://github.com/kvm-x86/linux/commit/1e53cde06102
[11/14] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
        https://github.com/kvm-x86/linux/commit/8630563012b9
[12/14] KVM: selftests: Precisely limit the number of guest loops in mmu_stress_test
        https://github.com/kvm-x86/linux/commit/3d4585c220dc
[13/14] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
        https://github.com/kvm-x86/linux/commit/eaafeebca75a
[14/14] KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
        https://github.com/kvm-x86/linux/commit/a3cd5c187742

--
https://github.com/kvm-x86/linux/tree/next
