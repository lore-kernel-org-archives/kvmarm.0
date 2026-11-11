Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436160;
	b=rCMKo6z9zLj+3wmiop3yDgXzHpn68XGyxbTDGyW44KPqJWB7Dp8K02Mye3cTu8Mu500r
	 JqTXjjHfJo2zc5Bbk6XvWZa+ztOuhEKvFVSjv7oDS7BAEGva8iBHUq5CduKVFes6AhUuy
	 yGWSYwkOaqqWuVn5UKgpI04tLU764nsWDOFhZk2eWAvCk0Rqx/yEgExMf9A928m3NJaOr
	 AuLamFR55DKhCCSFcf7OeOgj4Sw86h/bqFTWlJgsmE5fkwp/1OokoqNxlUcqU9iUkfpM1
	 SwjG+z3mLJBYbtLj0BdpXx9QuN9doOj9GZZzlaWNOOqy0fvaNpTVmQZAo7KJI5FucMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436160;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=hNcFDdx6SEsMQ2wb+0TdBub7tg0kF/xbhNU9Q5R/+fI=;
	b=vv9NwfncDeb2p3PSo9fHxANQvJB9/MnxuhvbCmkrJvUm+8jF6w+36qxhGWtK/Md7Tw7y
	 O7I+Xx22a6puTwANHEbPnNpcOctosXRYT9QrgpjCgUF4sI8+PNkl6Qo/mEbYPC8vBiDz3
	 f2CbGyjR/Ejaw+dvVL5vdglNfGS6miyoddcL8FM7XmCJJnCZQOvUhF3hqx4o//iR8tKYQ
	 8IS2ah9K6u3ao4+hOOGYew6CKSOTgHdq2jkEr1HjHLnITXr9eRba4hV0ycHoKKKSsU8ra
	 0yuBLurd8cVR+fipgXl5Dd0tsWQcMqdpQj34SQqUkYDn3R2wf7rdqXvjCiwmNDKTrSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=nWz1gFPi;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CD160A2628;
	Wed, 11 Nov 2026 22:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8CD160A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=nWz1gFPi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=hNcFDdx6SEsMQ2wb+0TdBub7tg0kF/xbhNU9Q5R/+fI=; b=nWz1gFPieTMjS6ZWY7nAHM/nOJ
	syw4NbeMkSO0aHt+eO0M1dMge7tZNU7ehYKvmryl84z8rwj+DmAtGbpkvydeEKAcnNNw7+jYyD5t4
	5sxuulgOozKiHvuBZx2/ltbcOJucbl3aEMjTjPGGZtuwMFAUW+4UIl/9RnjpEs5wzYs//JOQCxVfe
	Z5vV95kf3tW2bfUmND973isg/ref1Y14Ui9VcW5OAU9bFdTYvOD/IO7iUOyLzG5ENC+BD8ktH62+N
	CNhTo0V4MYK/g3P3FYB65jEOYAjZy162p7oL8xg+UySIOd4jizNQ1HXVfvs38/yhP7RmuPdZR+eB6
	2JplI6gg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoc-00000009dbX-29VX;
	Wed, 11 Nov 2026 22:29:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoZ-0000000007o-1y0L;
	Wed, 11 Nov 2026 22:29:11 +0000
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
Subject: [PATCH 00/16] KVM: Fixes for the Planes + SEV-SNP series
Date: Wed, 11 Nov 2026 14:28:55 -0800
Message-ID: <20261111222911.477-1-dwmw2@infradead.org>
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

I rebased Jörg's KVM Planes + SEV-SNP series¹ to 7.4-rc2² and used it
to add VSM support³. Here's a batch of fixes.

Thirteen of the sixteen apply in order, without conflicts, to the
kvm-planes-v7.1 branch. The other three need what has landed upstream
since v7.1: patch 1 fixes the s390 arm64 KVM module, which only
arrived in 7.4; patch 12 touches the PID-table clearing in
vmx_vcpu_free() from b41f2ca6c060; and patch 16 extends the VMSA
invalidation from d1a3c2162334.

The ones that matter:

 - 01 s390: arm64: Pass plane_level to the kvm_set_routing_entry() stub
   The arm64 KVM module on s390 kept the old prototype; the kernel
   test robot caught it on the rebased tree.

 - 05 Initialise Hyper-V state on every plane vCPU
   kvm_set_cpuid() passed the plane 0 vCPU to kvm_hv_vcpu_init() for
   every plane, and a twin created late got vp_index -1.

 - 08 Publish a new plane only once KVM_CREATE_PLANE cannot fail
   A failed create left a freed plane in kvm->planes[], where the SNP
   VMPL switch could still find it, and VM teardown freed it again.

 - 10 Keep current_vcpu in sync in vcpu_load()
   A reschedule inside an ioctl on a plane fd put and loaded the wrong
   twin, and a failed twin create left current_vcpu dangling.

 - 11 Load each plane twin while updating it after KVM_SET_CPUID
   On VMX the vendor callback wrote the twins' controls into the
   caller's VMCS.

 - 12 Leave the IPIv PID-table entry to the plane 0 vCPU
   A twin has the same vCPU ID as plane 0, so creating or freeing one
   repointed or cleared plane 0's entry. Latent for now, since planes
   inhibit APICv.

 - 13 Leave TSC matching to the plane 0 vCPUs
   Each twin counted as another vCPU with a matching TSC, so the master
   clock could never come back on.

 - 14 Derive runtime CPUID bits from the executing plane
   OSXSAVE, OSPKE, APIC, MWAIT and the XSAVE sizes follow per-plane
   registers, but the table they live in is shared.

Three things I've noticed and *not* fixed here:

 - The AVIC physical ID table is indexed by vCPU ID too, so it has the
   same collision as the IPIv PID table in patch 12. It's masked while
   APICv is inhibited for planes, as it is today.

 - A host-side TSC write on plane 0 (or KVM_SET_TSC_KHZ) after the
   twins exist doesn't reach them. Fixing that means loading each twin,
   and I'd rather agree how before doing it.

 - For Jörg and Tom: the SNP VMPL switch stops the current plane with
   kvm_vcpu_set_plane_stopped() and no latch, so KVM_GET_PLANE_RUN_STATE
   reports it as STOPPED, and a VMM that saves and restores that value
   turns it into a userspace stop. Does VMPL want a notion of
   KVM-initiated suspension of its own, or is that the intended
   contract?

¹ https://lore.kernel.org/all/20260608144252.351443-1-joro@8bytes.org/
² https://git.infradead.org/?p=users/dwmw2/linux.git;a=shortlog;h=refs/heads/vsm2/planes-fixes
³ https://lore.kernel.org/kvm/20261017122501.610248-1-dwmw2@infradead.org/

David Woodhouse (14):
  KVM: s390: arm64: Pass plane_level to the kvm_set_routing_entry() stub
  KVM: SVM: Derive the plane limit from the immutable VM type
  KVM: planes: Report KVM_MAX_PLANES from the system fd
  KVM: Guard the per-plane KVM_SIGNAL_MSI cases with __KVM_HAVE_MSI
  KVM: x86: Initialise Hyper-V state on every plane vCPU
  KVM: x86: Widen the plane vCPU fd ioctl allowlist
  KVM: x86/mmu: Free obsolete roots of all planes
  KVM: planes: Publish a new plane only once KVM_CREATE_PLANE cannot
    fail
  KVM: planes: Kick the running twin's pCPU, not the request target's
  KVM: planes: Keep current_vcpu in sync in vcpu_load()
  KVM: x86: Load each plane twin while updating it after KVM_SET_CPUID
  KVM: VMX: Leave the IPIv PID-table entry to the plane 0 vCPU
  KVM: planes: Annotate the lockless twin-publication protocol
  KVM: SVM: Make KVM_REQ_VMSA_PAGE_RELOAD per plane

Mushahid Hussain (2):
  KVM: x86: Leave TSC matching to the plane 0 vCPUs
  KVM: x86: Derive runtime CPUID bits from the executing plane

 Documentation/virt/kvm/api.rst  |  21 ++++--
 arch/s390/kvm/arm64/arm.c       |   3 +-
 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/cpuid.c            | 128 +++++++++++++++++++++++---------
 arch/x86/kvm/cpuid.h            |   6 +-
 arch/x86/kvm/hyperv.c           |   7 +-
 arch/x86/kvm/irq.c              |   5 +-
 arch/x86/kvm/mmu/mmu.c          |  16 +++-
 arch/x86/kvm/svm/sev.c          |  29 ++++++--
 arch/x86/kvm/svm/svm.c          |  10 ++-
 arch/x86/kvm/svm/svm.h          |   2 -
 arch/x86/kvm/vmx/vmx.c          |  10 ++-
 arch/x86/kvm/x86.c              |  87 ++++++++++++++++++++--
 include/linux/kvm_host.h        |   7 +-
 virt/kvm/kvm_main.c             | 115 +++++++++++++++++++++++-----
 15 files changed, 365 insertions(+), 84 deletions(-)

-- 
2.50.1

