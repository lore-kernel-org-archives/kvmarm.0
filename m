Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0518C2F1FE2
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760101295; cv=none; b=uJT9q++H4DEKGFcVq8qyXTbvs9AQ4X3T9d/6wGliMJqeQWUKNON/b2TxAh/sjaGw/p4IPsU7svIyfoCu4iiyBVAaTIMVGDQVNi1RvfIYvS+6lpDTqZ7kcYqj0+Qdj/dbOBK6VfakwL6VUg9Gdhc4vsa6ZjFhP0je0aM2B4X2y9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760101295; c=relaxed/simple;
	bh=/IXKbZhwEimc9XYzsrBKF5X0GUTxZZOStH8cfmUv1XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFXYae6iKCwqtygXlDf2IZCeU45xBQkXYUKmnq/98zCo1m6nEPpdvckNd2ch8yKMvIJ3mDcEEW6I6H9f3QB/qpduzXgSD3vLOWvCeyQ54Pt5uCBukMsl10cO7hMEG37ISVk2MKRQBsynT4lwlTcNQnByH0h5rPXNFNaVCg+uwSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g60qLntd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g60qLntd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760101290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YwHD8YNFYL0oE0NGAUXqtpuAglHzZS7fKr8Z8h16h7A=;
	b=g60qLntd1aesZGrGHMlnx2dPaGnnNRnHqSRFBknZxR1synk0g/aTJUyOHVxnbaxOzzEr4i
	tBcw0hTFtAfzAn7lTPSqe2S30DacwffkjE3d1F8AIGqsXQtDIxKiV5xzxd75vt/NyhZJLm
	/UkjRZoMKYMBnKWb8fKmkh7ldsp3Cmk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-HeHpHRlCMmqbNBrlJpazNg-1; Fri,
 10 Oct 2025 09:01:27 -0400
X-MC-Unique: HeHpHRlCMmqbNBrlJpazNg-1
X-Mimecast-MFC-AGG-ID: HeHpHRlCMmqbNBrlJpazNg_1760101285
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEFFF1800365;
	Fri, 10 Oct 2025 13:01:24 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.128])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E8AFA1954128;
	Fri, 10 Oct 2025 13:01:21 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 1/2] arm64: Replace __ASSEMBLY__ with __ASSEMBLER__ in uapi headers
Date: Fri, 10 Oct 2025 15:01:15 +0200
Message-ID: <20251010130116.828465-2-thuth@redhat.com>
In-Reply-To: <20251010130116.828465-1-thuth@redhat.com>
References: <20251010130116.828465-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Thomas Huth <thuth@redhat.com>

__ASSEMBLY__ is only defined by the Makefile of the kernel, so
this is not really useful for uapi headers (unless the userspace
Makefile defines it, too). Let's switch to __ASSEMBLER__ which
gets set automatically by the compiler when compiling assembly
code.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/arm64/include/uapi/asm/kvm.h        | 2 +-
 arch/arm64/include/uapi/asm/ptrace.h     | 4 ++--
 arch/arm64/include/uapi/asm/sigcontext.h | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c7..a792a599b9d68 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -31,7 +31,7 @@
 #define KVM_SPSR_FIQ	4
 #define KVM_NR_SPSR	5
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/ptrace.h>
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index 0f39ba4f3efd4..6fed93fb2536f 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -80,7 +80,7 @@
 #define PTRACE_PEEKMTETAGS	  33
 #define PTRACE_POKEMTETAGS	  34
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 /*
  * User structures for general purpose, floating point and debug registers.
@@ -332,6 +332,6 @@ struct user_gcs {
 	__u64 gcspr_el0;
 };
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI__ASM_PTRACE_H */
diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
index d42f7a92238b9..e29bf3e2d0ccd 100644
--- a/arch/arm64/include/uapi/asm/sigcontext.h
+++ b/arch/arm64/include/uapi/asm/sigcontext.h
@@ -17,7 +17,7 @@
 #ifndef _UAPI__ASM_SIGCONTEXT_H
 #define _UAPI__ASM_SIGCONTEXT_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 
@@ -192,7 +192,7 @@ struct gcs_context {
 	__u64 reserved;
 };
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #include <asm/sve_context.h>
 
-- 
2.51.0

