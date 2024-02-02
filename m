Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDC4DF5E
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 02:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706842635; cv=none; b=SGPc7BIoOIv3sbp6ZlGfTHgI47+UbkK4DBg43spIpeCBRlhsl59jebKEVKcMaAYryUDS83qr/+oHUTYTzoqX9bgnB1IEZ83NvNeNQ46Kb/lMtNQ6s8vzf4zFUCGNj9obK5rRrYOrnGTch5S3WUlWwhKIS/wUAnhAGgBzMh64boY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706842635; c=relaxed/simple;
	bh=CFCmJjwKp5av5hjkAYWAQpnhq7Fv7wpmWOVD0ITvnNA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TuajL2XT02mot8xqZ3/XtIa16n4u57uTnyx9g9Vj6JS1UrSSkmdyfI7yGsndGpX2dsKw1CNSDlOQJVdj5h8z0ciSKNmjT3UfeaI7Wx0HAukere8hJfWE5gAkpYeiNJq4AkaD1Pq+rnCVEpOazd5IhYfcuo/SDpdMmGif5iVXKSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M7scfsq7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M7scfsq7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706842632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hi+EdE9BcVWpF5frSoCALRQVB52U4QNkUOAopYUQrrE=;
	b=M7scfsq7xDxe6t3XTO6qaxQ+xT+bOGI8i/TxTVaPU3gw972Ox3L6EJ1HsTlb5gkz5jO7Nf
	RNmII3h+JoI0e9JmMCdtwCATRkxBMeIEr9h/TyuS6s04wv4Y3tKsV2dlWZVlXhK9s+XACZ
	bOMWvQlz3Ioo84jBDywRFDoLUGq0ydQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-DpsQMxLPPnu5XY_HqBOn1Q-1; Thu,
 01 Feb 2024 21:57:08 -0500
X-MC-Unique: DpsQMxLPPnu5XY_HqBOn1Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F24672825BA8;
	Fri,  2 Feb 2024 02:57:07 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8E30C1D36C;
	Fri,  2 Feb 2024 02:57:07 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Eric Auger <eauger@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/5] KVM: selftests: aarch64: Fix the buggy [enable|disable]_counter
Date: Thu,  1 Feb 2024 21:56:52 -0500
Message-Id: <20240202025659.5065-4-shahuang@redhat.com>
In-Reply-To: <20240202025659.5065-1-shahuang@redhat.com>
References: <20240202025659.5065-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

In general, the set/clr registers should always be used in their
write form, never in a RMW form (imagine an interrupt disabling
a counter between the read and the write...).

The current implementation of [enable|disable]_counter both use the RMW
form, fix them by directly write to the set/clr registers.

At the same time, it also fix the buggy disable_counter() which would
end up disabling all the counters.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 tools/testing/selftests/kvm/include/aarch64/vpmu.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/vpmu.h b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
index f78c93a08bff..92715021f892 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vpmu.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
@@ -77,17 +77,13 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
 
 static inline void enable_counter(int idx)
 {
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenset_el0);
+	write_sysreg(BIT(idx), pmcntenset_el0);
 	isb();
 }
 
 static inline void disable_counter(int idx)
 {
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
+	write_sysreg(BIT(idx), pmcntenclr_el0);
 	isb();
 }
 
-- 
2.40.1

