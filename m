Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594399;
	b=GoWx8VgyGKuZkKxCgmJ5DUSTGCaOBaDNENgcYKjVWBeA/o7xWYvP1dU+CQ3Wl5TJTrIR
	 ZiRTlSTCi8K2nqY7ZlX0M//q31WsCvI0qWnDXpshDbvsQotAxkqBd0iwO42PVLt7uUDQL
	 ojsKNPxqhiNKE2RQKZ9G2Ks7DCmkDK/nD3P6xJfTQkf3WuIi1qY3e4MZoYdakB4GBIwSl
	 ZEMaaFkP6z/ZBmQoKU3tb7sdvEOf3iTdqCvyQ+8pl/T4Q/QpCzZMiNKQkNXXNj0RQoWWK
	 CBJsL6sTdPEP/DyCqG/aR2/+/jh/gms+IK9vp5fF5k1S4TAGJV+YBKaDnyXwBnUO2YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594399;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=a447najyP6oiEfQOMuEwmzsq+JuFRrv0E+AbaPhpCIo=;
	b=giTeOojsa6QkVOkWnPfSyI7PBKXtSQYogwRDFMBc9O9cUtjS/raNdJq0M2sre8DlhlJE
	 AYgMhquEKCjjOaBgwGWYleMSms3DrHcYwDCYiqRDVgA2yXkcBeoaIu5/LtlFiGUjrZ/yI
	 Mrq24dP3PQuq3EaQIOJICc0ZyOt/ww41OyCnoCEhlNPqOOnVKvLRwZEgUMfktydIxyHOJ
	 duxCyRBw4Z7iAEq7n4qRh2fLdCGw4AX+JihxJL7noWFU/5ZnsHiTG8PfkMlfQRM4ELPU2
	 1l7gTaFYjh5QeOS3xmRIiK5OO+VsjMJBHesky+i9+ZkvBBaWk0sWcULF6TFxPvyJp1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=hOEc3Ykw;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE38606C14C;
	Fri, 13 Nov 2026 18:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EE38606C14C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=hOEc3Ykw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=a447najyP6oiEfQOMuEwmzsq+JuFRrv0E+AbaPhpCIo=; b=hOEc3YkwQtQpZARn5ieWyaY5Ne
	Fee1m0HWE6LQ/qA1Behapz2i4AlA7dulrNddxuRIvHhJPeFGiaLYlTpC8BDGwfEFZ46z6C7VlAu68
	KOcy7f+V6eNYB3Cyi7RBaYgOT0TlTmX9dDDm0TwfZ9T29PSA3RPC7nRBMdx9PjXKu4dCzbokBKXla
	3qQ+w62TjIfT7oD6HIwpvhreNe+8CfnsnlYeDj6n4k4R702pjDkkNSqcirtqUHm6p/RL7NIonFGzf
	s3jdwOrmFyuMm3DKOL5B9HErrcjdvzC/ejUh4FtoEpmuRHex0vdSSgxvt0i+zef5PxcKwiDbDeAuM
	RQJevh8g==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyU-0000000BeOW-16LO;
	Fri, 13 Nov 2026 18:26:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LXo-1IJ3;
	Fri, 13 Nov 2026 18:26:07 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com,
	Mushahid Hussain <hmushi@amazon.co.uk>,
	Sriram Nambakam <snambakam@linux.microsoft.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC PATCH 00/13] KVM: planes: Userspace API
Date: Fri, 13 Nov 2026 11:25:54 -0700
Message-ID: <20261113182607.82813-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The VSM work¹ drives planes from userspace, which takes a little
more API than the planes series² itself provides: an explicit
userspace opt-in (enabling KVM_CAP_PLANES with the plane count,
before any vCPU is created), KVM_GET/SET_PLANE_RUN_STATE vCPU
ioctls, and the mechanics to go with them — per-plane requests
fanned out to the twin vCPUs, XCR0 shared across twins (with every
twin's fpstate sized for the dynamic xfeatures that allows), and
APICv inhibited while planes are enabled (for now). With selftests,
including Paolo's plane infrastructure tests from the original
planes RFC³, ported forward.

Posted separately from the VSM RFC v2 (to follow) so this part can
be reviewed — or folded — with the rest of the planes series. Based
on that series² with my fixes⁴ applied (including two follow-up
patches on that thread); the whole stack is at ⁵.

¹ https://lore.kernel.org/kvm/20261017122501.610248-1-dwmw2@infradead.org/
² https://lore.kernel.org/kvm/20260608144252.351443-1-joro@8bytes.org/
³ https://lore.kernel.org/all/20250401161106.790710-29-pbonzini@redhat.com/
⁴ https://lore.kernel.org/kvm/20261111222911.477-1-dwmw2@infradead.org/
⁵ https://git.infradead.org/?p=users/dwmw2/linux.git;a=shortlog;h=refs/heads/vsm2/planes-uapi

David Woodhouse (12):
  KVM: x86: Let userspace opt in to multiple planes with KVM_CAP_PLANES
  KVM: selftests: Add x86 planes lifecycle test
  KVM: Add KVM_GET/SET_PLANE_RUN_STATE vCPU ioctls
  KVM: selftests: Cover plane run-state ioctls in planes_test
  KVM: planes: Fan out per-plane requests to twin vCPUs
  KVM: x86: Inhibit APICv when VM planes are enabled
  KVM: planes: Enlarge every twin's fpstate for dynamic xfeatures
  KVM: x86: Let userspace choose state for plane twins to share
  KVM: planes: Let plane twins share XCR0
  KVM: planes: Let plane twins share DR6
  KVM: selftests: Check CPUID handling of plane twins
  KVM: selftests: Cover plane state sharing

Paolo Bonzini (1):
  KVM: selftests: Add VM plane infrastructure and tests

 Documentation/virt/kvm/api.rst                | 129 +++-
 arch/powerpc/kvm/trace.h                      |   3 +-
 arch/x86/include/asm/kvm_host.h               |   8 +-
 arch/x86/include/uapi/asm/kvm.h               |   4 +
 arch/x86/kvm/cpuid.c                          |  25 +-
 arch/x86/kvm/mmu/mmu.c                        |  13 +-
 arch/x86/kvm/regs.c                           |   1 +
 arch/x86/kvm/svm/svm.h                        |   3 +-
 arch/x86/kvm/trace.h                          |   3 +-
 arch/x86/kvm/vmx/main.c                       |   3 +-
 arch/x86/kvm/x86.c                            | 221 ++++++-
 arch/x86/kvm/x86.h                            |  21 +
 include/linux/kvm_host.h                      |  36 +-
 include/uapi/linux/kvm.h                      |   7 +
 tools/testing/selftests/kvm/Makefile.kvm      |   3 +
 .../testing/selftests/kvm/include/kvm_util.h  |  73 +++
 .../selftests/kvm/include/x86/processor.h     |  14 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  74 ++-
 .../testing/selftests/kvm/lib/x86/processor.c |  47 +-
 tools/testing/selftests/kvm/plane_test.c      | 137 ++++
 .../selftests/kvm/x86/plane_x86_test.c        | 331 ++++++++++
 tools/testing/selftests/kvm/x86/planes_test.c | 605 ++++++++++++++++++
 virt/kvm/kvm_main.c                           | 138 +++-
 23 files changed, 1852 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/plane_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/plane_x86_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/planes_test.c

-- 
2.50.1

