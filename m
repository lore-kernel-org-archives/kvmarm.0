Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799412EFDAF
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 13:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760101291; cv=none; b=rKMV5KviLesWPdZOWiVoEhqcymzhnNK4OXnoBOcHjh7YhjmHo4bxtT6RVnn32fZ0/YO1KamCi23o3xvhru53lfCfJb9APTx/5D/3fMPAglORW4HceQ6TnOc5y6sMqOfJlVWa2vwIqpfmnLFHdD0YQSFnmbksSVagj9tVM4N1reU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760101291; c=relaxed/simple;
	bh=VugrapcbBR+Hx+Ft2qn0t5WZwtN7/TTbajIt8PkKQXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e/4Um6i6xLFcYPaXb9pMfzx3p+Xwa6mcww6hEvCrOg7Ff/W0gK2iyD/lE/FaxDweWl9AZGGh20damsAL4WWYHfyJV8MBY8fQA2UOrQWnI+u89DScflIgmofjh4XVYOyy+mJgNKaOZdGtXWcYEPDnEYlHznCFde37GQYN1IoC+Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h0cu05LO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h0cu05LO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760101288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jiTFrzMAhXf0lHXfGbE7QYutHmJtDJtsPx27BIBz86Y=;
	b=h0cu05LOHrR/T18JG08JchaM8absOnwMCyL0v3QOpnMDQam6zeYzn5eYhHqnlqobieVU6O
	hQR64qQ7zLujDJet+MfIAfq7QG0cBBxcmipbzZjyjQAmralcNX77TbIJ9wX5AfVlYsRreB
	XYKwJSJ13RE7lR2BhxhXK0d9M2+TPvw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-2P4-NoKQNfO1yltQ51solQ-1; Fri,
 10 Oct 2025 09:01:23 -0400
X-MC-Unique: 2P4-NoKQNfO1yltQ51solQ-1
X-Mimecast-MFC-AGG-ID: 2P4-NoKQNfO1yltQ51solQ_1760101281
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4151D195609E;
	Fri, 10 Oct 2025 13:01:21 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.128])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 32AC71954128;
	Fri, 10 Oct 2025 13:01:17 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 0/2] arm64: Replace __ASSEMBLY__ with __ASSEMBLER__ in headers
Date: Fri, 10 Oct 2025 15:01:14 +0200
Message-ID: <20251010130116.828465-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The kernel Makefiles define the __ASSEMBLY__ macro to provide
a way to use headers in both, assembler and C source code.
However, all the supported versions of the GCC and Clang compilers
also define the macro __ASSEMBLER__ automatically already when compiling
assembler code, so some kernel headers are using __ASSEMBLER__ instead.
With regards to userspace code, this seems also to be constant source
of confusion, see for example these links here:

 https://lore.kernel.org/kvm/20250222014526.2302653-1-seanjc@google.com/
 https://stackoverflow.com/questions/28924355/gcc-assembler-preprocessor-not-compatible-with-standard-headers
 https://forums.raspberrypi.com/viewtopic.php?p=1652944#p1653834
 https://github.com/riscv-software-src/opensbi/issues/199

To avoid confusion in the future, it would make sense to standardize
on the macro that gets defined by the compiler, so this patch series
changes all occurances of __ASSEMBLY__ into __ASSEMBLER__.

I split the patches per architecture to ease the review, and I also
split the uapi headers from the normal ones in case we decide that
uapi needs to be treated differently from the normal headers here.

The related cleanup patches for x86, parisc, sh, arc, s390x and many
other architectures already got merged via their specific architecture
tree, see for example:

 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=24a295e4ef1ca8
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8a141be3233af7
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cccaea1d66e94b
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e2b6a188625a2b
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9cc646950eefda
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=179e949719fe81
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2cb74be378675c

The x86 have already been merged in Linux v6.15, and as far as I know,
there haven't been any complaints about problems in userspace with the
updated uapi headers yet, so I think these changes should be fine.

Thus, please merge the arm64 patches via the arm64 tree. Thanks!

 Thomas


v2:
- Split the arm64 patches from the global series
  (see https://lore.kernel.org/all/20250314071013.1575167-1-thuth@redhat.com/)
- Rebased the patches on linux-next and fixed the conflicts

Thomas Huth (2):
  arm64: Replace __ASSEMBLY__ with __ASSEMBLER__ in uapi headers
  arm64: Replace __ASSEMBLY__ with __ASSEMBLER__ in non-uapi headers

 arch/arm64/include/asm/alternative-macros.h       |  8 ++++----
 arch/arm64/include/asm/alternative.h              |  4 ++--
 arch/arm64/include/asm/arch_gicv3.h               |  4 ++--
 arch/arm64/include/asm/asm-extable.h              |  6 +++---
 arch/arm64/include/asm/assembler.h                |  2 +-
 arch/arm64/include/asm/barrier.h                  |  4 ++--
 arch/arm64/include/asm/cache.h                    |  4 ++--
 arch/arm64/include/asm/cpucaps.h                  |  4 ++--
 arch/arm64/include/asm/cpufeature.h               |  4 ++--
 arch/arm64/include/asm/cputype.h                  |  4 ++--
 arch/arm64/include/asm/current.h                  |  4 ++--
 arch/arm64/include/asm/debug-monitors.h           |  4 ++--
 arch/arm64/include/asm/el2_setup.h                |  2 +-
 arch/arm64/include/asm/elf.h                      |  4 ++--
 arch/arm64/include/asm/esr.h                      |  4 ++--
 arch/arm64/include/asm/fixmap.h                   |  4 ++--
 arch/arm64/include/asm/fpsimd.h                   |  2 +-
 arch/arm64/include/asm/ftrace.h                   |  6 +++---
 arch/arm64/include/asm/gpr-num.h                  |  6 +++---
 arch/arm64/include/asm/hwcap.h                    |  2 +-
 arch/arm64/include/asm/image.h                    |  4 ++--
 arch/arm64/include/asm/insn.h                     |  4 ++--
 arch/arm64/include/asm/jump_label.h               |  4 ++--
 arch/arm64/include/asm/kasan.h                    |  2 +-
 arch/arm64/include/asm/kexec.h                    |  4 ++--
 arch/arm64/include/asm/kgdb.h                     |  4 ++--
 arch/arm64/include/asm/kvm_asm.h                  |  4 ++--
 arch/arm64/include/asm/kvm_mmu.h                  |  4 ++--
 arch/arm64/include/asm/kvm_mte.h                  |  4 ++--
 arch/arm64/include/asm/kvm_ptrauth.h              |  6 +++---
 arch/arm64/include/asm/linkage.h                  |  2 +-
 arch/arm64/include/asm/memory.h                   |  4 ++--
 arch/arm64/include/asm/mmu.h                      |  4 ++--
 arch/arm64/include/asm/mmu_context.h              |  4 ++--
 arch/arm64/include/asm/mte-kasan.h                |  4 ++--
 arch/arm64/include/asm/mte.h                      |  4 ++--
 arch/arm64/include/asm/page.h                     |  4 ++--
 arch/arm64/include/asm/pgtable-prot.h             |  4 ++--
 arch/arm64/include/asm/pgtable.h                  |  4 ++--
 arch/arm64/include/asm/proc-fns.h                 |  4 ++--
 arch/arm64/include/asm/processor.h                |  4 ++--
 arch/arm64/include/asm/ptrace.h                   |  4 ++--
 arch/arm64/include/asm/rsi_smc.h                  |  4 ++--
 arch/arm64/include/asm/rwonce.h                   |  4 ++--
 arch/arm64/include/asm/scs.h                      |  4 ++--
 arch/arm64/include/asm/sdei.h                     |  4 ++--
 arch/arm64/include/asm/smp.h                      |  4 ++--
 arch/arm64/include/asm/spectre.h                  |  4 ++--
 arch/arm64/include/asm/stacktrace/frame.h         |  4 ++--
 arch/arm64/include/asm/sysreg.h                   | 10 +++++-----
 arch/arm64/include/asm/system_misc.h              |  4 ++--
 arch/arm64/include/asm/thread_info.h              |  2 +-
 arch/arm64/include/asm/tlbflush.h                 |  2 +-
 arch/arm64/include/asm/vdso.h                     |  4 ++--
 arch/arm64/include/asm/vdso/compat_barrier.h      |  4 ++--
 arch/arm64/include/asm/vdso/compat_gettimeofday.h |  4 ++--
 arch/arm64/include/asm/vdso/getrandom.h           |  4 ++--
 arch/arm64/include/asm/vdso/gettimeofday.h        |  4 ++--
 arch/arm64/include/asm/vdso/processor.h           |  4 ++--
 arch/arm64/include/asm/vdso/vsyscall.h            |  4 ++--
 arch/arm64/include/asm/virt.h                     |  4 ++--
 arch/arm64/include/uapi/asm/kvm.h                 |  2 +-
 arch/arm64/include/uapi/asm/ptrace.h              |  4 ++--
 arch/arm64/include/uapi/asm/sigcontext.h          |  4 ++--
 tools/arch/arm64/include/asm/cputype.h            |  4 ++--
 tools/arch/arm64/include/asm/esr.h                |  4 ++--
 tools/arch/arm64/include/asm/gpr-num.h            |  6 +++---
 tools/arch/arm64/include/asm/sysreg.h             | 10 +++++-----
 tools/arch/arm64/include/uapi/asm/kvm.h           |  2 +-
 69 files changed, 141 insertions(+), 141 deletions(-)

-- 
2.51.0

