Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2926220DD63
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527182; cv=none; b=IEX8Y1cBpkXEoeaBZBQmAuFcqCwLZwe1waplmH71kn4f6HB4wMRbcF9Qiltu/tW2nWJ/7dUqKhfN0Rql/4U5KmBQ4Qes/fFkpYS36goVWp6mik4k98gv20fU0kij3Wh34XzgyF2n3bF645tYX17WC5oOEXiYyOY/q/ERNIiX6IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527182; c=relaxed/simple;
	bh=oa79efjOKM9SRXURi1BaVT0pmfHaFaEt9V3KsZ4Q6nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5rLFYq2c1GAFL5f8xUXHx0EGZd5bXuDsqq2nCFFZR/qKZFoajAWyWTqSMfxPg6ueH1wwXOw2KWv/j6gPXGxIyDeRFBDRLCFXxovQgxfyNCYwcwlKo3dwidnvU1jjLqeG1GNmJbAcC/ok2gLqIkG1EmvPwjzY93dr6rvCaIDHY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KFEv++2X; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFEv++2X"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2264aefc45dso145527785ad.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 10:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527180; x=1744131980; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqoSwIUEkmAFZzDF1jp7biKBQ9RqCAjci7v8QaNjgL0=;
        b=KFEv++2X0CUAQ8e1t6iGw65M5Fji6rfO+N1d1C1ciR0H5N2o3RgErZ0uEXFYwfTOKN
         vbdknoTVv/U6F5EfPLns6QjqHazxAylroqhqAYUPsS7PTseX1dm9vwgjQyt1/FSjZftB
         RCzWJS3xxFxzbp2+qCR3qaCa8vEbzivhdB9c1oRkVo3UkY67Iev7d+bJzcwg5z/VJLGU
         vAP1Rm75VzlHio0EskCL6NBeLqCL4oCPCQW0m4cp++9tWmL4WCsxt9VGt1u9+vUepxTA
         c7VBEvz1fglZM4ZGcYbaO4V/2o9Bv9++lFZwuKtpZ8U+WH9Q/qlX6iFvJipuVXYdi13T
         WOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527180; x=1744131980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FqoSwIUEkmAFZzDF1jp7biKBQ9RqCAjci7v8QaNjgL0=;
        b=YgBhCwb1/zQEEX1h22EPTUKm+LfhMOV9a7oI5hZer4yLq8yFJhc8KlAqKNgTcTx+GY
         3cJ7B4zdLbCDWsylGDT3/BVmlYkSNsc/8Pf16FuWZ9zSXlTaLamyw7LTH2lRHjrJpY1n
         6n86utJNT2NAS7H/NeAtkYdgEwmHR820my4f9GLffi++Y1EMVuic2XmnFVrewKG3D59h
         5l+scukdobHSHSndc/F48RDeORKPsKJcIdTDCEfcPHYY8cATsFV2GdZwh63vlTMps3mm
         7gbFYrsY+H4RDgOdKnPqXbHurXlFh1p7I/65Vbjlk9coz5QtkVqldG978gxoM36XbT7l
         di+Q==
X-Gm-Message-State: AOJu0YwNzqp6KCkPvh4QbjnOWwSeDmIFytCK71DPKs5ba0biHlziV8CP
	FesQ5zn4MRd9Rj/mKMfnidZpcsupcx83pytyFXWcpI3uzITXm+Go9IZOpw==
X-Gm-Gg: ASbGncusajWTTvfpU4QeOh/Nr5Bi/sa8gjsBzhJgIXjhPoBWPC4/37Zk6hwl9QqIQpi
	ZsJ6+yq/VhL4m+dw5lCuQ+0rNngiU8GiiYj6msGKKNmkQlQtQ2kNSshdk5TQcmnVxeETQpqK/dg
	iFaMJtN2JhSoSmvxrHvvkYPZCfDOxDb+gsJ9rAX8IF+JtpQERXzY/M3zdlBuzmVASbfpL5ssZoE
	nWWM5Ma/78Gi++11lLuysRgqmrFby0LVG7/3QF1D39sB+QenzZHcPkSmen7QEodbqgTHvBhnDuG
	pwWJ/kR7omq2TjoF4ogud40Rxc1Nj1ncXNqMLJ+L
X-Google-Smtp-Source: AGHT+IHMLcW/UgSU+B9QLYjzegvhSUSQLiYd7WdSUYNTNPJYM4iVdsXCx+9AUOlAl0q1OhIHYB2AXw==
X-Received: by 2002:a17:902:f544:b0:21f:6bda:e492 with SMTP id d9443c01a7336-2292f9ee9e8mr226767855ad.35.1743527180233;
        Tue, 01 Apr 2025 10:06:20 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:19 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 5/7] tee: optee: Add OPTEE_SMC_VM_CREATED and OPTEE_SMC_VM_DESTROYED
Date: Tue,  1 Apr 2025 22:35:25 +0530
Message-ID: <20250401170527.344092-6-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OP-TEE when compiled with NS-Virtualization support expects NS-Hypervisor
to notify events such as guest creation and destruction through SMCs.

This change adds two macros OPTEE_SMC_VM_CREATED and OPTEE_SMC_VM_DESTROYED.

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 drivers/tee/optee/optee_smc.h | 53 +++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/tee/optee/optee_smc.h b/drivers/tee/optee/optee_smc.h
index 879426300821..988539b2407b 100644
--- a/drivers/tee/optee/optee_smc.h
+++ b/drivers/tee/optee/optee_smc.h
@@ -452,6 +452,59 @@ struct optee_smc_disable_shm_cache_result {
 /* See OPTEE_SMC_CALL_WITH_REGD_ARG above */
 #define OPTEE_SMC_FUNCID_CALL_WITH_REGD_ARG	19
 
+/*
+ * Inform OP-TEE about a new virtual machine
+ *
+ * Hypervisor issues this call during virtual machine (guest) creation.
+ * OP-TEE records client id of new virtual machine and prepares
+ * to receive requests from it. This call is available only if OP-TEE
+ * was built with virtualization support.
+ *
+ * Call requests usage:
+ * a0	SMC Function ID, OPTEE_SMC_VM_CREATED
+ * a1	Hypervisor Client ID of newly created virtual machine
+ * a2-6 Not used
+ * a7	Hypervisor Client ID register. Must be 0, because only hypervisor
+ *      can issue this call
+ *
+ * Normal return register usage:
+ * a0	OPTEE_SMC_RETURN_OK
+ * a1-7	Preserved
+ *
+ * Error return:
+ * a0	OPTEE_SMC_RETURN_ENOTAVAIL	OP-TEE have no resources for
+ *					another VM
+ * a1-7	Preserved
+ *
+ */
+#define OPTEE_SMC_FUNCID_VM_CREATED		13
+#define OPTEE_SMC_VM_CREATED \
+	OPTEE_SMC_FAST_CALL_VAL(OPTEE_SMC_FUNCID_VM_CREATED)
+
+/*
+ * Inform OP-TEE about shutdown of a virtual machine
+ *
+ * Hypervisor issues this call during virtual machine (guest) destruction.
+ * OP-TEE will clean up all resources associated with this VM. This call is
+ * available only if OP-TEE was built with virtualization support.
+ *
+ * Call requests usage:
+ * a0	SMC Function ID, OPTEE_SMC_VM_DESTROYED
+ * a1	Hypervisor Client ID of virtual machine being shut down
+ * a2-6 Not used
+ * a7	Hypervisor Client ID register. Must be 0, because only hypervisor
+ *      can issue this call
+ *
+ * Normal return register usage:
+ * a0	OPTEE_SMC_RETURN_OK
+ * a1-7	Preserved
+ *
+ */
+
+#define OPTEE_SMC_FUNCID_VM_DESTROYED	14
+#define OPTEE_SMC_VM_DESTROYED \
+	OPTEE_SMC_FAST_CALL_VAL(OPTEE_SMC_FUNCID_VM_DESTROYED)
+
 /*
  * Resume from RPC (for example after processing a foreign interrupt)
  *
-- 
2.43.0

