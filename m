Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84EF3FCB2D;
	Mon,  8 Jun 2026 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929819; cv=none; b=NvB7oLsHL81JmpetB/8Bm5fQn7dr4AqqBfYgTXImxFgxpfSqQr+WgYK0b6hj5h58rMBRkjB/bUlAOeVK+EWylZSRG4WBZsZ5FbvIR4V2JY05lGuHT9c/x6VOESCyza2av1d6xkqYlSZ7hG8JWqGmKbDKmA2/hMHJh52XWNxQJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929819; c=relaxed/simple;
	bh=EwK3CSoQdraq8pfMizHC19RAMLpGfxhyu5K4AKU0RXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daqYGpejfl7ts4uuGP4C2f+fzBwv6CkcVbvN0wW5AjTKPjQCZEWTiQcd29ATJocMwWUaHIba+KZQ8VKgkJL5fchmz19oNxBth9CrRc0WRStGKR0XM9nwjHk96qam153ml4ywJ/gBvk6vWKb1SbO70ITIJP4ZkLomF7/4IBfW1vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id EF34E2028DF;
	Mon,  8 Jun 2026 16:43:17 +0200 (CEST)
From: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
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
	joerg.roedel@amd.com
Subject: [PATCH 60/60] kvm: svm: Advertise full multi-VMPL support to the SNP guest
Date: Mon,  8 Jun 2026 16:42:52 +0200
Message-ID: <20260608144252.351443-61-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

Indicate full multi-VMPL support to the guest through the GHCB feature
bitmap.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 528c8bd3e8fc..0736e1c778d9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -43,7 +43,8 @@
 #define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP			| \
 				 GHCB_HV_FT_SNP_AP_CREATION	| \
 				 GHCB_HV_FT_SNP_RINJ		| \
-				 GHCB_HV_FT_APIC_ID_LIST)
+				 GHCB_HV_FT_APIC_ID_LIST	| \
+				 GHCB_HV_FT_SNP_MULTI_VMPL)
 
 /*
  * The GHCB spec essentially states that all non-zero error codes other than
-- 
2.53.0

