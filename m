Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436160;
	b=igqAOWy/ob+lPRoxqBfqyzZT/RZF66djgrch1Yxc2sq2zbLOBdncU05j7zGet2YesINJ
	 7lW09eNq5zy6W+XtUnBjIsBjxioOTiSCgid3JCNTRRJSMDXgBKKxbhm75LejuQ4KEulKp
	 E+3Oc/nSDUDh10SazZgXfwjIGRX+mgLA7ZnEU+6ng70pXtDw+g7VmyJz7lxi0DXTARP1O
	 8FJJVT7tpmo2EUz1ZeUIa87k7yxw5HJXP9U9VuB3lyIKRGpDZzKuF4MuDEwVN/eHCKb6P
	 i0RV7lxeu39WsptJPahN4HE4t9UuA0s3frGAXnHWpQ7DS64FIkrq6qGG3JwW002f/Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436160;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=AUQ62nciiYmS/RrmAlFykNNXWeaUW8xe6NLNrO4/KVo=;
	b=quW2S+dlh9hvQLIZ32eCM8I2weEWQOTHLKNU4hGeCgu06iERkTxfPw6LfOLpp++bWinp
	 TNjNGhEy+dGYzY9NU4ijiEbLnSc+ctDUKDy2Ut7U8eTt1ks3lKcUGDT29LE1iAIQe3OHE
	 1aR/4PBsV3x6SbtumBQBjsNOhVKTj+i4qvBWAdHAEgVQaK+G+aX7XvTM/U6BQw/PgkIFq
	 tJ8alRVefVY7ccIxSfjeqRhKDzbR79lP6YLk4jnztuBEH8ed02Yj1wZpTRtkWOccFOzVb
	 oWYc9VHtTujANbHxQdG/1F9FpeXstRVi4BPKvjtXlxTxHIYF1tuKpaGP7E/dK0eQfVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=Fn8DRH0P;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D4B60A2629;
	Wed, 11 Nov 2026 22:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8D4B60A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=Fn8DRH0P
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AUQ62nciiYmS/RrmAlFykNNXWeaUW8xe6NLNrO4/KVo=; b=Fn8DRH0PTa38iOsEBJZ/OUfQD9
	aVZwxWfunFhokJy6jRyVHWPE/SZdTjjj5mS9P2dtOOLB3kbsMqfPtHSYU0xq5yFTXxypah/+XGGF3
	N7afAQPYvUbY7RUt5lHYO35uK6t/cDCciZlbe2O7VZ77kmR80C63VDqTvGpmKNideEtKb35aBaAqt
	WS7ginmGocYjO7UmBWs5LSafERe671Ua1SyM1nWc61zjSDsOiHVocC7I/f7g+cvnWlbSsZAaBEP5b
	Auf6I4HOU2j0UGGaLlz81j6WnSg4SK4hOpG9efS2EaLrMu1RwHm/QiT0S3Leo3+0kZa/NBi8xQBeP
	VFGEwBGQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoc-00000009dbY-2AQN;
	Wed, 11 Nov 2026 22:29:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoZ-0000000007y-2Xj3;
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
Subject: [PATCH 03/16] KVM: planes: Report KVM_MAX_PLANES from the system fd
Date: Wed, 11 Nov 2026 14:28:58 -0800
Message-ID: <20261111222911.477-4-dwmw2@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

KVM_CHECK_EXTENSION(KVM_CAP_PLANES) on the system fd returns a
hardcoded 1. The KVM_CAP_PLANES opt-in added later in this series takes
its ceiling from exactly that query, so a VMM following the documented
negotiation concludes it may request one plane, and never enables VSM
at all. Return KVM_MAX_PLANES there instead.

While there, move the id bound check in kvm_vm_ioctl_create_plane()
under kvm->lock. Every KVM_ENABLE_CAP path that changes
kvm_arch_max_planes() takes that lock, and the limit only ever grows,
so an unlocked check could at worst spuriously reject a create racing
KVM_CAP_SPLIT_IRQCHIP. Checking under the lock just makes the bound the
one the plane is actually installed against.

Found by a local Sashiko review.

Fixes the system-fd KVM_CAP_PLANES query in "kvm: Implement
KVM_CAP_PLANES".

Fixes: https://lore.kernel.org/all/20260608144252.351443-29-joro@8bytes.org/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/svm/svm.c |  5 ++---
 virt/kvm/kvm_main.c    | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1848136f3bb9..1c63eb3fcdc0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5522,9 +5522,8 @@ static unsigned svm_max_planes(struct kvm *kvm)
 	 * state: KVM_CHECK_EXTENSION(KVM_CAP_PLANES) reaches here with no
 	 * lock held, while __sev_guest_init() sets and rolls back
 	 * sev->active/es_active/SNP_ACTIVE under kvm->lock.  The VM type
-	 * is fixed at creation, so the lockless read neither races the
-	 * rollback nor lets the limit change under KVM_CREATE_PLANE's
-	 * pre-lock bound check.
+	 * is fixed at creation, so the lockless read cannot race the
+	 * rollback.
 	 */
 	if (kvm->arch.vm_type == KVM_X86_SNP_VM)
 		return sev_snp_max_planes(kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8550303f5757..0136156df252 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5375,7 +5375,12 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_PLANES:
 		if (kvm)
 			return kvm_arch_max_planes(kvm);
-		return 1;
+		/*
+		 * The system fd reports the ceiling a VM may opt in to via
+		 * KVM_ENABLE_CAP(KVM_CAP_PLANES); a VM fd reports what the
+		 * VM actually has.
+		 */
+		return KVM_MAX_PLANES;
 	default:
 		break;
 	}
@@ -5587,6 +5592,13 @@ static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
 	struct file *file;
 	int r, fd;
 
+	guard(mutex)(&kvm->lock);
+
+	/*
+	 * Check the limit under kvm->lock, where KVM_ENABLE_CAP sets it,
+	 * so a concurrent cap enable cannot change it between this check
+	 * and the installation below.
+	 */
 	if (id >= kvm_arch_max_planes(kvm) ||
 	    WARN_ON_ONCE(id >= KVM_MAX_PLANES))
 		return -EINVAL;
@@ -5595,7 +5607,6 @@ static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
 	if (!kvm_arch_irqchip_in_kernel(kvm))
 		return -EINVAL;
 
-	guard(mutex)(&kvm->lock);
 	if (kvm->planes[id])
 		return -EEXIST;
 
-- 
2.50.1

