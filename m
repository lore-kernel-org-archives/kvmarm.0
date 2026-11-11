Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436160;
	b=F2ou1okzLGyqA3K0i3v4hof1244eFIMK3ReWdl8ZE+aDj92gnzBPHBrFQtJHsZ8Jr+T0
	 +P1wqlBO/BukHpsd5Iptl5MXwSJdLbIc0pMQi4F/XaHklNCpZXN9XOxPAYzfj3lrg0jxb
	 1y0J7EfLOl3pSsiMHChdniwIW7qAk0qsrFTEiD1BIh5mSOKalkR3AtHN7n4PcJW5NLyrM
	 LR8lemIF/09UDpdS1Eg82TbZEPfZi4SIQBR3ouH96D8vTqJ8RatzpebnAKntq9ohKYCei
	 OlMSpsUtdKWy/h3NobaiGDdpDVNDE3kcAUVzontL6mC9rRDluEXd48PESrpqU4Gh54w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436160;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=W87fSQlkCnHCOpy3utcFbD7aEeTD91fXvM7EUGmB8/Y=;
	b=HVxhDAvR0rjD1m1Ibd1gTO1w6bj9mwA2u2Z+B7fDfuhIypF7Omg5lF0rfKRsiiEHL1Rj
	 DRozDshU3p3l5sZA3JOi0rawOmuZuSuT7r2pNZyDDSMSUQ9XzU6sJp9FvVwFcc6LvlToe
	 nV1PR4NrRbv6D6EyYqDDYqqrvogOeSOnuvdKX9K2DcoAtdTYGKK47OmHnStfCX3lmviCk
	 2T4m4XERgX9FHPK60Ieem7KH3IVjkozQXaGNJrdyzu6bsWe2sBVAvWpOo21Kdk9togR/J
	 5hpYhvglzlAVsBSWugVicpdet+NEgoZFZMKUipvdtZo4Vrt+MHgEfWrE6/jA6UjoVkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=S89Ev5TO;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DA260A262B;
	Wed, 11 Nov 2026 22:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8DA260A262B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=S89Ev5TO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W87fSQlkCnHCOpy3utcFbD7aEeTD91fXvM7EUGmB8/Y=; b=S89Ev5TOPgWtVFvcEZ+48OAJIO
	XHz1eDA+g6T6JYfr9wgyxYW44qIPA8sMuP2LBy3drm3Mq6Z16AUPK4cIEXJctn0e5AK/C/ii/1BPF
	I8sHywp0m+SfQ0xUp4Ii92OiXPKnlcRyDIBGQF+a6OjjCamoqWClM6iPFWN+CGsFU0S6T+6yXOAEm
	eOqyw+qJlVgYyC6BY/D3zJSWLRDxFfI0oJ4GoGkSwhknnUlc2HminKTDEuO4NmygkjAg2Fwc9SFRK
	RWREfWfDrkmvA1BXZou0ErgSnapYQD/h+818v2lfgDVsrjTdwXB80aHIrnGH8dGLlsf4QdWgSC6r2
	vKOpUNOg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoc-00000009dbZ-2ABi;
	Wed, 11 Nov 2026 22:29:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoZ-0000000007r-26M1;
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
Subject: [PATCH 01/16] KVM: s390: arm64: Pass plane_level to the kvm_set_routing_entry() stub
Date: Wed, 11 Nov 2026 14:28:56 -0800
Message-ID: <20261111222911.477-2-dwmw2@infradead.org>
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

kvm_set_routing_entry() gained a plane_level argument, and every
architecture's implementation was converted except the stub in the
arm64 KVM module on s390, which arrived in the same release. An s390
build with that module then fails:

  arch/s390/kvm/arm64/arm.c:745:5: error: conflicting types for 'kvm_set_routing_entry'

Give the stub the new signature. It still refuses every routing entry.

Fixes the s390 arm64 stub that "kvm: Pass plane_level to
kvm_set_routing_entry()" did not convert.

Fixes: https://lore.kernel.org/all/20260608144252.351443-38-joro@8bytes.org/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202611102242.ywP1yvPR-lkp@intel.com/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/s390/kvm/arm64/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/arm64/arm.c b/arch/s390/kvm/arm64/arm.c
index 64a609f087a8..0f0fab76e71a 100644
--- a/arch/s390/kvm/arm64/arm.c
+++ b/arch/s390/kvm/arm64/arm.c
@@ -744,7 +744,8 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
+			  const struct kvm_irq_routing_entry *ue,
+			  unsigned plane_level)
 {
 	return -EINVAL;
 }
-- 
2.50.1

