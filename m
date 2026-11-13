Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794529793;
	b=uq7KgBCp9rByJJYuolpts9heX15M3KI946pWr1WuDlJxDZqnyQicWnUyouBIvbLzo517
	 o310op+k4wRuleaqg2E7aFrwlfSGKvpkp/8LdR/dHpXXnQon4UFd+TT/rYmhILRMs8SqE
	 4Ig+4x2+R4gkTvhRj3GF/SAcVV25VfggSPyjqXBAoGW5a0Z3fS70EdSFcdoktcwWk9zEM
	 JYd2e2zYxVG1W+5DJsucUtFGkv0VTDJcVlCvgD48q3PrnLuDInGqUN7HEIl7OxIH6oAi4
	 LlZtu20kQLJfg+Q6cACFsBZug6tbXqkYI5986s0tbH6zZnxIbYD6Jci+9QRwv935hyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794529793;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=r4E+MTESEWZeubmBM7/YkvNZnlWh5Dhkmonv/pR6l2E=;
	b=y6f0Nll5v/bOf33u1/7aD0GoJQNWwZy/8Y6ojD/zIkJZ9P83ixny6wbl3kWFM4zn8S2p
	 BlPAikAWePzSVgfv2p559zU2tdlebbo+tIZQwsjfSPAi3oNcS+WImLknn2bTWwRaMshvI
	 Sy/Bl4vODa10+zlBiMoBc300MHDc4JrGMALqTQXBa1RuaaiDV8K7MawlpZ3Pqcl55F6AM
	 Pm+8aNmkITIgZWpzaKhKpu+rfLWxvbHUWECOLwL106rVUeyXYxH1mvYlYTh98/xFWaxII
	 n1UcKugRWL2skDeLKczxuwih/vd70LPlyg7m5QU4hW1JvLGrLiza/C8UFtroLvMwp4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=t8lS+h1x;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7296606A321;
	Fri, 13 Nov 2026 00:29:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7296606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=t8lS+h1x
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r4E+MTESEWZeubmBM7/YkvNZnlWh5Dhkmonv/pR6l2E=; b=t8lS+h1xoqqcNCX6bvUQ6GPBG3
	czOnBE3wbdobT8Xt4PbuAuPs6szpn7rX1ZYfX4KebCgyrEdTx+HfnnFUSEjMVNXqEJzWPXJPmTDzl
	G2jDnmgINPeVSnatFqidjs2yw/xK3G/hIg72zvZo1RoW1Y8u8zJnkNvxWVJ4BgNLyatu8CmydO5hT
	btrhY2LDnkjTrKfX4BmMJGovM0g0FvdzxKr8PMjjy80ZjTDzIIWr/MRyamnDb7s9yLSSP57oCwDU2
	xdsRsVcWR0GsFxCvyPbRygnISpR20u9vxhzIJfcUO5UB/u9ZCIUHDTw2v4xbZVhheW+5uC92tv89q
	ga5jTSFA==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRfAq-0000000D12s-1rZk;
	Fri, 13 Nov 2026 00:29:48 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRfAq-00000000DvP-11Bi;
	Fri, 13 Nov 2026 00:29:48 +0000
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
Subject: [PATCH 18/16] KVM: SVM: Bound the SNP plane count by the architectural VMPL limit
Date: Thu, 12 Nov 2026 17:29:48 -0700
Message-ID: <20261113002948.53522-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261111222911.477-1-dwmw2@infradead.org>
References: <20261111222911.477-1-dwmw2@infradead.org>
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

sev_snp_max_planes() reports the VMPL count straight from CPUID
0x8000001f EBX[15:12], a 4-bit field the host provides. A value above
four lets userspace create SNP planes that no VMPL switch can ever
reach, because the switch already refuses a VMPL at or above
SVM_SEV_VMPL_MAX.

Clamp the count to between one and SVM_SEV_VMPL_MAX, so that a
VM's plane count never exceeds what the architecture defines.

Fixes the plane count in "kvm: svm: Implement max_planes x86
operation".

Fixes: https://lore.kernel.org/all/20260608144252.351443-60-joro@8bytes.org/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/svm/sev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c8a9f808dcc4..eefa8641100b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -6010,8 +6010,10 @@ bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
 int sev_snp_max_planes(struct kvm *kvm)
 {
 	/*
-	 * CPUID 0x8000001f EBX[15:12] is host-provided data; a zero there
-	 * must not report "no planes at all" (plane 0 always exists).
+	 * CPUID 0x8000001f EBX[15:12] is host-provided data.  A zero there
+	 * must not report "no planes at all" (plane 0 always exists), and
+	 * the architecture defines no more than SVM_SEV_VMPL_MAX VMPLs, the
+	 * bound the VMPL switch already enforces.
 	 */
-	return max(vmpl_levels, 1U);
+	return clamp(vmpl_levels, 1U, SVM_SEV_VMPL_MAX);
 }
-- 
2.50.1

