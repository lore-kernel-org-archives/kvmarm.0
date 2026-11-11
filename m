Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436157;
	b=byFvvWXziB9236BUmbt1FmqZUvSZJBt08hvCqvQEQAFmqqvXC1joJSqOxiVe+IIo8zQI
	 MdweTmUPB1Q0RLitOqAw2yffkskitg1rhW/Y+3ctfnv0VHoOjDioXQZHCaY7r9Bvgd8wk
	 JMEDOgE4pU73hN17WZB+fqdOneWSoKKn8ELA9toHlUHxs2UelPLQbeK32PoLMsaLFsXlO
	 Wj3sPtNnZgkZrT+RPzYcyaTdpRjAv21L/8L8jeTOnPkpVyANeVOZCTlACx55IPcKa71DA
	 HKJZm3OSj9cYOQ/lgOfDjHu8f0QtXAUKNRwJgfZBgdg9M0ytty4xoOw1TjzHCfo10rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436157;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=E8rVfKCMqU27RWIM2bfWVZEtsM9bj4ortAwrQwz/hPM=;
	b=vyCAjfpg+m7JkxZ8yBGXQJra7bfVnxU62erglp0Qi6k9CUsc4z8V29aVAOcK60hb5Cu7
	 uC6Pang5wo7F2qgQ1qLzz8ZgvsNjTf/kTk+2Wa6pQF6znW2arBy7ngiXbUrMZK1lY0HB+
	 lbtGiZe4JE1BEFY8ChgHsrcY0A7K+MBrnhyp6TEsoW/QOffonA3SurSUdw6Z+tN8X+CIk
	 rolMq5HUHQI8NvVzupqUW8MQFCF5KvHphlNtX6vgM0tB8d7kG4UCN8ozIRPHpUZSPzOu2
	 VzwdMooLOJ1elGczkcCNA3sVq/TezdFI0Ocpg56+kcuTdpJ+sdEJ0ExWDT4Yg6F4pAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=wCjtEbpv;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE23606A32D;
	Wed, 11 Nov 2026 22:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EE23606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=wCjtEbpv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E8rVfKCMqU27RWIM2bfWVZEtsM9bj4ortAwrQwz/hPM=; b=wCjtEbpv8XHuBy6wJMmQMnzuo0
	h0jSZydE2akV5ZyvNvFU8gfabmnnX1AvPipDVPw8246mtWUuU0pqGoi9KOmi9xDMlTnWUd3RFEsvu
	wNx9R8j+Tv10A/0+n1ha9K917Mfen35ra3jusd2RJHDj8TcYgZoU6ofIr1TSFWqRK3h8Sh3fPEAxu
	svIoD7jIOopcL6q84r7feglY523gu6q+DATzxxIoGKhygr5u8wz/Bx0cJ1oknpRP3XqCD8DJW7JiH
	5OjrfuABd5NyZA3x73i3dJcjLwYlKffTZdbNWzzOmLK1VFVZZoIq5/XVZiQvOzF9Sotr67KDOwB5P
	5M3WSmmg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoa-0000000G3ny-1BO7;
	Wed, 11 Nov 2026 22:29:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoa-0000000008W-0P3R;
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
Subject: [PATCH 11/16] KVM: x86: Load each plane twin while updating it after KVM_SET_CPUID
Date: Wed, 11 Nov 2026 14:29:06 -0800
Message-ID: <20261111222911.477-12-dwmw2@infradead.org>
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

kvm_vcpu_ioctl_set_cpuid() runs kvm_vcpu_after_set_cpuid() on every
plane twin, but only the calling vCPU is loaded. The vendor callback
writes VMCS/VMCB controls, and on VMX those writes go to whatever VMCS
is loaded on the current pCPU: the caller's, not the twin's. The
twin's controls shadow is updated anyway, so the stale values in its
real VMCS can never be corrected later; a twin created before
KVM_SET_CPUID2 keeps its empty-CPUID controls (RDSEED/RDRAND exiting
among them), and the guest's higher VTL takes a spurious #UD on its
first RDSEED.

Swap each twin in as the loaded vCPU for its update, and reload the
caller once at the end. Plane ioctls all share the common vCPU mutex,
so the twin cannot be loaded elsewhere concurrently. A preemption
inside the window is safe only because vcpu_load() now publishes the
loaded twin as common->current_vcpu (previous patch); before that, the
preempt notifiers would arch-put and arch-load the caller instead.

Fixes the twin updates in "kvm: x86: Update state for all plane VCPUs
after CPUID update".

Fixes: https://lore.kernel.org/all/20260608144252.351443-46-joro@8bytes.org/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/cpuid.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 54bcfedc5226..c9b7dfc5c967 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -501,7 +501,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 {
 	struct kvm_vcpu_common *common = vcpu->common;
 	u32 vcpu_caps[NR_KVM_CPU_CAPS];
-	struct kvm_vcpu *v;
+	struct kvm_vcpu *v, *loaded = vcpu;
 	unsigned i;
 	int r;
 
@@ -568,9 +568,24 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 #ifdef CONFIG_KVM_XEN
 		v->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
 #endif
+		/*
+		 * The ioctl loaded the calling vCPU; updating a twin's
+		 * VMCS/VMCB controls requires that twin to be the loaded
+		 * one, so swap it in for the update.
+		 */
+		if (v != loaded) {
+			vcpu_put(loaded);
+			vcpu_load(v);
+			loaded = v;
+		}
 		kvm_vcpu_after_set_cpuid(v);
 	}
 
+	if (loaded != vcpu) {
+		vcpu_put(loaded);
+		vcpu_load(vcpu);
+	}
+
 success:
 	kvfree(e2);
 	return 0;
-- 
2.50.1

