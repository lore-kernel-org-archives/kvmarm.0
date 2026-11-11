Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436158;
	b=OS5LZ1H1L8UuqwbUl/PyUc6rk9If6WCgES46yoTwo+0AWUXFOk4XC1tE7yVeKuxVXjtR
	 MuV3SZrs99jFMnQ5p6cibMLU5BlH2hOeDwEmOJ5wK5jjGtho0t/BEAsA0xhwlctJyJYtJ
	 XACjHflcwOks/yp9dfRfPbzbTQ0ivNL/u8j29UuxYOltfHCM/vtfn2L7ctDovFDbRQr+f
	 +pV31W5bCX5Ch5DOTgURf3kRNpFgqlrrp4obge8hOqRuP7bTuuK4YjXzQGq3P4orbqgx8
	 criNQ0Zdzrv4TlIwKRKPJnITADDth17XEdOWE+jO95zb5fEogLksgK3pHQKLaLjBE/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436158;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=8rIcuP/4Kb5zS07YkanQvDf9xFXdSyL1L4TPZLIk6kE=;
	b=KLsIZoo7xfkJrhlJnIL3fcbQ90Y9bP4JR35aphUk1oYYFYu37s68hPl3UZrGlpz+aArc
	 gIwq6TGABbHLZakNsy1zuB+tKu2Lday5zUoAxn36woEvWKNRu1nn0PlVA6bMi1IX89AC2
	 rNla7UxzXV0Zkt3jvyNt7++JcX8ZVjcNdAPWLgA76pynoS8jd/C9nzXWUMcDlzFazOQ73
	 aZmd1fpw28PSi7ex09gxGBC5645yS1DH4pcivoewrOUTcbWzGrinz2ewFa2pUqeqBUzMT
	 GbhUNZz8IWu70BwuyRDz9HsNmJ5J7EKms3CtyLfE3u2cI+2ms8oGPy4balFruD9W4xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Mhmpih29;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6D0606A31C;
	Wed, 11 Nov 2026 22:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D6D0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Mhmpih29
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8rIcuP/4Kb5zS07YkanQvDf9xFXdSyL1L4TPZLIk6kE=; b=Mhmpih290/1F4Cy7rNJmsiv5xh
	KTagvj0bmx+Rz/i0HPD3LG1iyTt/YmhjDLkwCJ6yHvibNng59JHqE5BtJb9aKzo/MWT+/eB4oK7PQ
	eTna6CYO28WO6lwYglmDm/xSFfqkQZoizUi5y0Qaz9Ty61r0JMZdXBURF/cMtIJDbKjA9D9u3ODHa
	onjj0lnNe8MSLGmSP4n4y825566WLHZTuVs1adnPZyKyiN9uFpPP6pJgcA9XKflU+jvrFpUnayZnN
	p7k6mKovmSz+llF1OnTs1x+AEIYOdy7OnvmjDLtRjBdYbc8pE55CLndTDWfWHVu4WlK9Vz6EZ5/l6
	hHZ6kcSg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoa-0000000G3o6-1sWv;
	Wed, 11 Nov 2026 22:29:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoa-0000000008m-15dz;
	Wed, 11 Nov 2026 22:29:12 +0000
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
Subject: [PATCH 15/16] KVM: planes: Annotate the lockless twin-publication protocol
Date: Wed, 11 Nov 2026 14:29:10 -0800
Message-ID: <20261111222911.477-16-dwmw2@infradead.org>
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

Plane twins are published with a plain store to common->vcpus[] plus an
smp_wmb() that pairs with online_vcpus, not with twin initialisation,
while vcpu_for_each_plane() reads the slots with a bare load.  x86-TSO
hides it, but the protocol is unannotated generic code: KCSAN reports
it, and nothing stops a reordered publication from exposing a
half-initialised twin to a lockless iterator.

Publish the slot with smp_store_release(), read it with READ_ONCE() in
vcpu_for_each_plane(), and document the pairing at the iterator. The
lockless readers here are vcpu_for_each_plane() callers that walk other
vCPUs' twins, such as the APICv BLOCKIRQ recompute; the kick paths read
common->current_vcpu instead, and the Hyper-V twin lookups that also
pair with the release come later, with the VSM code.

No functional change on x86.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/kvm_host.h | 7 ++++++-
 virt/kvm/kvm_main.c      | 9 ++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1f47b3bfa4bb..6922e3063ad8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -393,9 +393,14 @@ struct kvm_vcpu_common {
 	struct kvm_vcpu_arch_common arch;
 };
 
+/*
+ * The slot read pairs with the smp_store_release() publication in
+ * kvm_vcpu_finish_common() for iterators running outside the locks that
+ * serialise twin creation.
+ */
 #define vcpu_for_each_plane(common, i, v)			\
 	for ((i) = 0; (i) < KVM_MAX_PLANES; ++(i))		\
-		if (((v) = common->vcpus[(i)]) != NULL)
+		if (((v) = READ_ONCE(common->vcpus[(i)])) != NULL)
 
 /* Tracked per plane-VCPU - used for deciding which plane-vcpu to run */
 enum kvm_vcpu_state {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b6bdbe5c5133..7f215822e48e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -548,7 +548,14 @@ static int kvm_vcpu_init_common(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned
 static void kvm_vcpu_finish_common(struct kvm_vcpu *vcpu)
 {
 	WARN_ON(vcpu->common->vcpus[vcpu->plane_level] != NULL);
-	vcpu->common->vcpus[vcpu->plane_level] = vcpu;
+	/*
+	 * Publish with release semantics so that vcpu_for_each_plane()
+	 * callers running outside the locks that serialise twin creation
+	 * (such as the APICv BLOCKIRQ recompute, which walks every vCPU's
+	 * twins) observe a fully initialised vCPU through their READ_ONCE()
+	 * of the slot; the plain store relied on x86-TSO.
+	 */
+	smp_store_release(&vcpu->common->vcpus[vcpu->plane_level], vcpu);
 	smp_wmb();
 	if (vcpu->plane_level == 0) {
 		/*
-- 
2.50.1

