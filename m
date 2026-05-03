Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F593A875A
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793834; cv=none; b=K1/1j0s0zouY3LPEPzcDhy1lJdtP/mEGt0spwIYtl0vNJZLZ6C773aK/CKzScNYxpmRL+twKq50mbaKbt7B4pJprruwWfu4NuhVYnt++4/xhCuz3muLRMiRdkcAcK/m7s/oQqFoyz2VdJQXqX+8AdVmyjnPUKSMYnqiEuEx2v0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793834; c=relaxed/simple;
	bh=lIzQ0GGj0ISHSBIzKuUtgCMGaajh1EcUEGwfE8MFlI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VeHHmTSwykpAKRxkr5iMyaWSk2loGZeywDZJ8eCT/wjClziMNGLIDb6w625TCw30mghxQF+y4PwoaHK7xTJUtFdltP4y2DfdARUaE4ykRgTBNor2I4xwN6cLDFfeFY3jrIybCYxE0jm8Dn+b6MvJM3O9jLyzQr92EcNAE0jGyHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O07yEhiN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O07yEhiN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0EpqKYpTXEPxNm026kI8ZZiBo2WkIy555KMBsAHNIY0=;
	b=O07yEhiN4c2PPI5aIFqahYGxLp9P94zULZroYt7kRvEqBu30za0viObxrI/QlfUjZdNBbE
	vEUJRE2vECk8ZLAui0GUvCG5nWEFPCMvjV9RkGlxm3cXHqdFEKNKe55DG7wlfBBkSaO6//
	xSMDptanZHl/kpxMdtNbr8uKMiVwSXY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-oUFfIJIFOyiPGg9RdLJuxQ-1; Sun,
 03 May 2026 03:37:08 -0400
X-MC-Unique: oUFfIJIFOyiPGg9RdLJuxQ-1
X-Mimecast-MFC-AGG-ID: oUFfIJIFOyiPGg9RdLJuxQ_1777793827
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 637DE1800282;
	Sun,  3 May 2026 07:37:07 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7836E1800345;
	Sun,  3 May 2026 07:37:02 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	cohuck@redhat.com,
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
Subject: [PATCH v4 13/17] target/arm/kvm: Special case REVIDR_EL1 and AIDR_EL1
Date: Sun,  3 May 2026 09:33:33 +0200
Message-ID: <20260503073541.790215-14-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 2DsLuVP9s7Vb5AC43gBN13Yq-StnFmMiHIsa4SxAftA_1777793827
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
index d9bf1ec039..f3aecef35c 100644
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

