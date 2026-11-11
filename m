Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436157;
	b=eUu31DMIySVm8SUEIpvA1bfV7lEOn308SK9l6cjH/U+dI1qsF/5D7SdldUG+dg3HGKXV
	 Hf44IggixAoHcoQswRGqogp/hxRaVjTCCWKeXjU/+xKPwxWd71uA73UwjqBn1Qcnn01W3
	 qIRnMOg52NJGBIjQvJNptK9TfcTSdDkZvKO2WY2sLrD0NxAAvooiU27GzSqtGVW1+AQXG
	 /LOSS6wkxDNgcMcVf3Pyp1wH5BYgluEy7qkC5yu0nmPXqXBoK/O+zzX/n0005XI+Zsg67
	 gPMA3HuVOfdDQBf1fxtQQiiD0BJGdjHu6tBrpAcLbiKnoLnkKStxwr2+25IbqDIUwXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436157;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=5oGviVXaj4yIpvPzalC/+nOH5ZvHArwTVGOnk6W3OXc=;
	b=uwZnVG4T/vI5Rzbuk6awo2/iboewm7DtxQPQcyuic/Lxdthasqxvm0j+VL9cHsAG7LWW
	 VisyXl8mLPbiWiif/8vrTgJ8YZK54LsfcPjlpDcqzhbVRkUZOi7dTS8WLTBPWwn4Jy9Jg
	 YWyTi4pOni3erWF+DXrtOCCGPJNU8ktzNLznl81Tv+O87ISW1JOA3RB83fU1/nhnWx18d
	 PQ14W4gAdopkg47Xv6y4b1p12KUY7lE+5gi5zkJ2YzhlPTWsWR3uz1gCcErysnoRbDvlt
	 6JRPmPcIhLOOfs1WoCMpjBIGcjUqaH0i0RemO56ldHJYkkZ6cxV9F4rWWqU2MNaziKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=r831SIFp;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF35606A32E;
	Wed, 11 Nov 2026 22:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EF35606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=r831SIFp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5oGviVXaj4yIpvPzalC/+nOH5ZvHArwTVGOnk6W3OXc=; b=r831SIFpUymlUnTYb61dln9ahD
	0eq+3vHkta/eyOr8OjQOrTXs4PQ2Z5nkgjHTKRBoFGNNESSqbK1xW1kMm5l6ehPgP1uky4tadiaqu
	G/LFt5CqsbRhH4+LSNf2Flu74ncwO/CqIBRgm4xFye0GNhuOlTHjWMGrg0O4AT3Yqo0JAHoucKw9s
	zmSiXequaXXxhDsMvMqtpW+qRETgkLIw6BUPW9RX1/NfDs1owEHdfQstQY/e8+JeLH+B8nTQHw686
	w2YkvByQxjnQnrL/OsQFTnkSY5h/aKlBE/Tjt2cCGWegc0Csc7Iz4QOgWEbfIWcoXvYQ/WYep07ko
	EICQHRSQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoa-0000000G3nz-1WjJ;
	Wed, 11 Nov 2026 22:29:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoa-0000000008e-0kHG;
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
Subject: [PATCH 13/16] KVM: x86: Leave TSC matching to the plane 0 vCPUs
Date: Wed, 11 Nov 2026 14:29:08 -0800
Message-ID: <20261111222911.477-14-dwmw2@infradead.org>
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

From: Mushahid Hussain <hmushi@amazon.co.uk>

KVM enables the master clock when every vCPU has a matching TSC, judged
by nr_vcpus_matched_tsc + 1 == online_vcpus.  online_vcpus counts a vCPU
once, but each of its plane vCPUs synchronizes its TSC at creation and
counts as another matching vCPU.  With one higher plane the count can
never equal the number of vCPUs again, the master clock stays off and
kvmclock loses PVCLOCK_TSC_STABLE_BIT.  Among other things the Hyper-V
reference TSC page then breaks: KVM writes sequence 0 to it, finds the
clock unstable and leaves it that way.

The planes of a vCPU share its TSC.  Give a plane vCPU its plane-0
sibling's TSC offset and generation, and leave the matching count and
generation changes to the sibling.  The offset the caller computed is
ignored: it comes from the VM-global matching window, so it differs
from the sibling's whenever the sibling is not in the current
generation, or on a host with an unstable TSC, and a host TSC write on
a plane fd would otherwise move the twin's TSC away from plane 0's.

Fixes the TSC match count for the plane vCPUs that "KVM: Implement
KVM_CREATE_VCPU ioctl for planes" creates.

Fixes: https://lore.kernel.org/all/20260608144252.351443-34-joro@8bytes.org/
Not-signed-off-by: Mushahid Hussain <hmushi@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd0e9b6cf8f7..f9adb4e81ebc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1366,6 +1366,35 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	if (vcpu->arch.guest_tsc_protected)
 		return;
 
+	/*
+	 * The planes of a vCPU share its TSC and online_vcpus counts the
+	 * vCPU once, so a plane vCPU neither counts as a matching vCPU nor
+	 * starts a generation; its plane 0 sibling speaks for it.  Nor may
+	 * it perturb the global matching window (last_tsc_ and
+	 * user_set_tsc): KVM_SET_MSRS is accepted on plane fds, and a TSC
+	 * write on a plane fd moving the window would corrupt the next
+	 * plane-0 write's match decision.
+	 *
+	 * Take the offset and the generation from the plane-0 sibling,
+	 * which exists by construction for a plane twin, and ignore the
+	 * caller's offset: that one comes from the VM-global matching
+	 * window, which may belong to a different vCPU's generation, and
+	 * is recomputed from elapsed time on an unstable host.  A host
+	 * TSC write on a plane fd therefore leaves the TSC alone; plane 0
+	 * owns it.
+	 */
+	if (vcpu->plane_level) {
+		struct kvm_vcpu *sibling = vcpu->common->vcpus[0];
+
+		kvm_vcpu_write_tsc_offset(vcpu, sibling->arch.l1_tsc_offset);
+		vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+
+		vcpu->arch.this_tsc_generation = sibling->arch.this_tsc_generation;
+		vcpu->arch.this_tsc_nsec = sibling->arch.this_tsc_nsec;
+		vcpu->arch.this_tsc_write = sibling->arch.this_tsc_write;
+		return;
+	}
+
 	if (user_set_tsc)
 		vcpu->kvm->arch.user_set_tsc = true;
 
-- 
2.50.1

