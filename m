Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436157;
	b=w57hamKfCSr34TR4uqXEEprjwiC8s16Rlml8SDYv1psS/7ygu6NjV0EDSbodvtvQfZ7G
	 6w5lpdW8QaWXQ+BYBVE7UxLo1aOgB1Vie0qixRjqTh4PeOliOFy2hXiF0zsfseKrFn+nR
	 3K5rAcea4zIOYQ0NL0hTdbIdhAgZNGn+cTOmfL51PDIqpmYVExcCPP4bnCIBvynN32Ttf
	 n4rExucJsc1Bay38iUTl+huziRAgFuBwnfa01sLpn0im/AnPx4VcxYnIixfVfzYvN42EI
	 B1P8jWIM8Yf3Vjilht8frKrcl/3ZILFZn8wTdAiSB4Jvck7EZsVtMnTnX99oMp9rlNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436157;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=wBoZDHT0z6uhalEs33RytkDoGLTQdmaMj7+RO9mWG/g=;
	b=MGpaI6LqxHyazh1W6H9NZcVRvCwfWQW4HcdADHh9YfIz06i7zTArmxkPYP/fqfwS5Jxs
	 lOMSDSVa+wJwJdPec00568ZfJLY3zwX9hYlZLc55205OJrkrfrugrsbcCzJb5gBd2X+Cn
	 eTOcscgn9ljsdzt8t85QIKe4chKHpbyHj4ZEmiHyIVW63NOezEgepDok1zpqPLx0w8GdV
	 HLRUMWwMDqz/SyuIr/KinKJkEZ73NM62AHnSKuoKok/VmqPiMqjAxajdx7Ozqik9eFCbF
	 5GOUuAswC9n6HVMJjQPt/OMXxCb3y6BVn4VxEMV8aEPfEQa63qGLBFDFvdFK4p/Kjdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b="A/Qgv401";
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED16606A326;
	Wed, 11 Nov 2026 22:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ED16606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=A/Qgv401
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wBoZDHT0z6uhalEs33RytkDoGLTQdmaMj7+RO9mWG/g=; b=A/Qgv401Xd439MOoTlIWy/QCUX
	KkI0CNA5bjK9uvI3mC7FrQPIsPnBsOl1WzcM4u6IBagrIswEGZc1a4vg8CwxqXx6hyKG/orjReKID
	Lgczt9ZjgYx+asxZPytsfJVI2OLqITC/QhFGiKti2xuWx9ed+cgr+FDvQAmZZDzX+2VQojbOBusuL
	KtmUSmkOk+recg6loelcyEIwFpy9jVHJobd1dJ6xW9UzdD5MVUmk7WccPuzwk+hkGgRPibC21NvUB
	nT22ymAKXmFQ/02LEEAAorNIfLGw4es/AtlWw2jWalDpF5FIdRPnpYy1F3Fc17pZci3dPc+x68ZpS
	vIhN9o4Q==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoa-0000000G3nw-0LUa;
	Wed, 11 Nov 2026 22:29:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoZ-0000000008G-3ZWT;
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
Subject: [PATCH 07/16] KVM: x86/mmu: Free obsolete roots of all planes
Date: Wed, 11 Nov 2026 14:29:02 -0800
Message-ID: <20261111222911.477-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261111222911.477-1-dwmw2@infradead.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20261111222911.477-1-dwmw2@infradead.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

KVM_REQ_MMU_FREE_OBSOLETE_ROOTS lives in the request set shared by all
planes of a vCPU. A fast zap (e.g. memslot deletion) invalidates
*every* plane's TDP roots and raises the request once per vCPU, but
whichever plane enters the guest next consumes the shared bit and
frees only its own obsolete roots. The other planes keep an obsolete
root with a valid-looking root.hpa, kvm_mmu_reload() does nothing for
them, and every page fault bails out in is_page_fault_stale() with
RET_PF_RETRY. The vCPU livelocks, taking the same EPT violation
forever.

Observed with a Windows VSM guest spinning at ~18k EPT violations/s
after a memslot update during boot, with the root obsolete (inv=1
obs=1) and the request already consumed (req=0).

Service every plane twin in kvm_mmu_free_obsolete_roots(). The
inactive twins cannot be running (all planes of a vCPU share one
thread), so their MMUs are stable.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 89cec6dd757a..e8eb1e48df36 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6401,8 +6401,20 @@ static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 
 void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu)
 {
-	__kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.root_mmu);
-	__kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.guest_mmu);
+	struct kvm_vcpu *v;
+	int i;
+
+	/*
+	 * KVM_REQ_MMU_FREE_OBSOLETE_ROOTS is tracked in the request set
+	 * shared by all of the vCPU's planes, so the plane that consumes
+	 * the request is not necessarily the plane whose root is obsolete.
+	 * Service every plane: the inactive twins cannot be running (all
+	 * planes of a vCPU share one thread), so their MMUs are stable.
+	 */
+	vcpu_for_each_plane(vcpu->common, i, v) {
+		__kvm_mmu_free_obsolete_roots(vcpu->kvm, &v->arch.root_mmu);
+		__kvm_mmu_free_obsolete_roots(vcpu->kvm, &v->arch.guest_mmu);
+	}
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_mmu_free_obsolete_roots);
 
-- 
2.50.1

