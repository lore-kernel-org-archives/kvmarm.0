Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436160;
	b=yxtUl4mZsRLSCrOBnt6052lV5pVvwQFLRMp2RxMapFZ5yvX9q0rDtGHVXDIh6UCiMZJa
	 ZRf7tx8bjspLGlZXIpZKNpVn3y/dI6xn2VtbZj4/bfsPUTAOfkhDiBL+pvqM5BcJIfzLw
	 mx2G5X1owdqoFLO9d1Vz7E9dsbtgl5qQ/AK08rpO7XO32PVBsMpMBD4ScjFevIs6APjAy
	 +4V7h/z24unoN8+467b6JnljzWfNU8mBv8527UKb4ZdcmtsTwFomXRO6OMznHuhdc7U0Y
	 9ogHNoJEgKvs/DiirkoXQivenF/UnxWXsKEg2w0udy9wnb6ZpI0eog+j1qKA0IxZN2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436160;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=oFTOekiPiKL4T1KhOTcidabBpJ5GICpNBEzlP5Id0Nc=;
	b=BNNteILmjeMyDd33MHsA1nU0j8f2c1q/CQnlqpeJDe4WOHILDJ/mFY8xzlRj6cFhfsFJ
	 QPD31YAfltk0OZxGpycvr3uWaisdO6ppjdQKYZbvbYvagDb/mh+YnhagtP4mCK+Beffu9
	 JgGg4/Dm9CLBJEP4cSnVhK7DCCLTrOFFyh/PCnVZsmGag2cE7LxFJpZ4awSrLSbUs7nk2
	 xZb3PxNunYJ3bneoLbjyjiC4Az8aKyKNVdB0OiLRDOTVyGc+EaPeMhwc3v86x4+fEVlfn
	 qWM3uh0/vy9DXcZ1L03TfYAG5ny4Va5tEYDawgwrTRAcebgINE3h/RvlQ0SXw1BJ4ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=C9BSB26Y;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D7060A262A;
	Wed, 11 Nov 2026 22:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8D7060A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=C9BSB26Y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oFTOekiPiKL4T1KhOTcidabBpJ5GICpNBEzlP5Id0Nc=; b=C9BSB26YSXAAAt8dotx5k4npei
	7lOaJNzIG3vNyJXet0BSEzgeND3o0kmPi8zLlvguz0/YykL482sDuJo5mz8z+C8YDdaVn4MK2U3B4
	qeX6HzVze6Jw2bKaqD+IZuDS2A3FuaC92BrhMw3foF5vgGYk+QRLIbK+f2hyKYzpveDgRgWatXglx
	h9pgQtP9oXDL5gAGu1XPX2UhzPHdc6RiKTRcuWp+xsEd9gXZS14E6bSCqwHCYvenocTcMtqgTsRJB
	COcg+iRyM2waOsPu0BXkMhP1pEY/pF5Y6CDua+bGhd0RA33jBQwPEwTLAMZ+oLBw3uSlm0MnChIqM
	H2YjHJWg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoc-00000009dbd-2A1k;
	Wed, 11 Nov 2026 22:29:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoa-0000000008a-0ZfS;
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
Subject: [PATCH 12/16] KVM: VMX: Leave the IPIv PID-table entry to the plane 0 vCPU
Date: Wed, 11 Nov 2026 14:29:07 -0800
Message-ID: <20261111222911.477-13-dwmw2@infradead.org>
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

The IPI virtualization PID table is indexed by vCPU ID, and a plane
vCPU has the same vCPU ID as its plane 0 twin. vmx_vcpu_create() for a
twin therefore repoints plane 0's entry at the twin's posted-interrupt
descriptor, and vmx_vcpu_free() for a twin (including the error path
of a failed KVM_CREATE_VCPU on a plane fd) clears it. Plane 0 is left
with no valid entry, or one naming a freed descriptor.

Nothing consumes the table while that is the case today: a VM with
planes has APICv inhibited, so IPIv stays off. But the entry must not
depend on that. Fill and clear it for the plane 0 vCPU only.

Fixes the IPIv PID-table handling for the plane vCPUs that "KVM:
Implement KVM_CREATE_VCPU ioctl for planes" creates.

Fixes: https://lore.kernel.org/all/20260608144252.351443-34-joro@8bytes.org/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44d0e8eba45b..591c7745e3e9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7525,7 +7525,8 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	free_page((unsigned long)vmx->ve_info);
 
-	if (vmx_can_use_ipiv(vcpu))
+	/* See vmx_vcpu_create(): only the plane 0 vCPU owns the entry. */
+	if (vmx_can_use_ipiv(vcpu) && !vcpu->plane_level)
 		WRITE_ONCE(to_kvm_vmx(vcpu->kvm)->pid_table[vcpu->vcpu_id], 0);
 }
 
@@ -7614,7 +7615,12 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 		vmx->ve_info = page_to_virt(page);
 	}
 
-	if (vmx_can_use_ipiv(vcpu))
+	/*
+	 * The PID table is indexed by vCPU ID, which a plane vCPU shares
+	 * with its plane 0 twin: only plane 0 fills the entry, or creating
+	 * (and freeing) a twin would repoint (and clear) plane 0's.
+	 */
+	if (vmx_can_use_ipiv(vcpu) && !vcpu->plane_level)
 		WRITE_ONCE(to_kvm_vmx(vcpu->kvm)->pid_table[vcpu->vcpu_id],
 			   __pa(&vmx->vt.pi_desc) | PID_TABLE_ENTRY_VALID);
 
-- 
2.50.1

