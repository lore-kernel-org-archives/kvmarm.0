Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFE9348C7E
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197461; cv=none; b=MKk5lgqtvKx19J25ctf7IKG0PYQxQEilDySsC+68LyRZk6aTKo9PCeYJXFKbsy091ED+LCYh89IdHM7oLojzHeIOSw0BlkfzUzdlYQ80puKItmVwjSktvz13sKQRRWh2id+mUcymnVx4fJjoSUVvTcl6C9abCWXaikIQ4JJtKLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197461; c=relaxed/simple;
	bh=3lUph+V60qgOHtuIk8bmPYbyfecJaCl8qgT/hLS2fP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=OSt7p0hR2i3q5J10mDvG2apXfLHKIfGMRH6yy3v9RjwmPLr1K8e8YVZ8WaXk55aEPWnN7ypILjAEQdiSEN1IA22rycry6ccqz5Mnhb34ivfeR/2ILFT9gIp9ReIoK4JUHLbBZryCeLjXIxsKOIBZpvbbeK0M+20rl53vNcmfidc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YY6XX1KM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YY6XX1KM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYpIswBUbvAWx5c0QdJS1zE0eazgwAPhomjHPpZ7pys=;
	b=YY6XX1KMGgq/lrhPjFndq9a9734RmTCyVvbLTHp/QABVFVGEW0UIkbF7NMptt4nZm8Y2tL
	808gUvs9Z9WnYfOKtM81PS61oudgNjAiVbhVVQzO3WgF2Wc/E/g5Ca9L7PjWKeMsS8yg05
	wGh4DZv4lf7cMZ/Jd/Vqi7qOV4lMg2c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-569-O16OgMxxObS4d8EfO-avrw-1; Tue,
 19 May 2026 09:30:52 -0400
X-MC-Unique: O16OgMxxObS4d8EfO-avrw-1
X-Mimecast-MFC-AGG-ID: O16OgMxxObS4d8EfO-avrw_1779197448
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09F5B1956053;
	Tue, 19 May 2026 13:30:48 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4AEE2180034E;
	Tue, 19 May 2026 13:30:42 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v5 14/18] target/arm/kvm: Special case REVIDR_EL1 and AIDR_EL1
Date: Tue, 19 May 2026 15:27:28 +0200
Message-ID: <20260519132905.145643-15-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: cFLDjFjeP91UeTlvds1NwpziGzBIlAKSsCrUe4DePb0_1779197448
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Special case REVIDR_EL1 and AIDR_EL1 which are writable but
does not expose named fields. They will need to be handled
separately

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 960052e67e..6373a66bbd 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -472,7 +472,15 @@ void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
                 warn_report("%s: reg %d writable, but not in list of idregs?",
                             __func__, i);
             } else {
-                decode_idreg_writemap(obj, i, mask, &regs[idx]);
+                /*
+                 * special case REVIDR_EL1 and AIDR_EL1 which are writable but
+                 * does not expose named fields. They will need to be handled
+                 * separately
+                 */
+                if (strcmp(regs[idx].name, "REVIDR_EL1") &&
+                    strcmp(regs[idx].name, "AIDR_EL1")) {
+                    decode_idreg_writemap(obj, i, mask, &regs[idx]);
+                }
             }
         }
     }
-- 
2.53.0

