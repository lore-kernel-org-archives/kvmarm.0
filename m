Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99ED156C62
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527170; cv=none; b=I4M9p22mOu9aCGxc1ckJfhJCyr/qqGPq/JNI0K2S8HphHB/8EKvoc3gj0Ltoctr8inhFKbyThuPRb0SW9zPcuddYHKwtaylKkVF8yY/jPmtc7R60On8XX/jyjmAJCrGlIIEd8Yj4Uwc80hCrMWQUK2orOp0WUlb3YQhBjnmW22s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527170; c=relaxed/simple;
	bh=Rw2iroImYquTfYTUaIXKUvTb6nsAifYMwZfzyDLbF+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMo1jsbeqGmOA6fh/In6Rbkv+6Tx8xvvBEWo4VJyrwC05w6UJZcj3qaZtrVeN+9pb2TkjwyL/ZHD7+EWsS0Dn/mBrWZNZ3bpb3/XPS96I1bfdJ0oK8MmHZysQ4CoaW9CDmeeZf4l3A5kuxSW/OxcKnCSMGiM+SrGyLGZEQ6U/S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSI0XCcm; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSI0XCcm"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-227d6b530d8so106540325ad.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 10:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527168; x=1744131968; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPTaf4AvEp4o/nHIyBvUFwkL4QhKCenH5rmcz21UYa4=;
        b=mSI0XCcmb4uCHv1/IFVUj4iSqmsF6jLaR3p9dlg/xwB8lIp82iHOCvTYkDhEL7USC/
         h+iEMkXw7bO+309OcMe5MtoO2xF5OFbogsDoT5LrryuTTpB3uIqhyxf5BHPjtt2++DWo
         HfdeUGxX0Vs52OU1S56y/aM8DIelVG2Q17qLHvNdUbVznp7AeBcx04OiXh7BxHR1SboD
         IHUPlUufLabEpgkmRcUK8nYO0znkCrsDDxVgY+6E3agDNl0ytvzkDHAgmvj4E33XXyi4
         p26DiXdQi4FHOYGPsgfyfqs2+MGxJLTKc8eS2f8uD57OnVXqehJRirJ+6YuDfTn/KsE9
         yosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527168; x=1744131968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPTaf4AvEp4o/nHIyBvUFwkL4QhKCenH5rmcz21UYa4=;
        b=GluKmpQHkS/1WJPzOunwlgyVgfSIO5haty+m93LUsjdt0VM8gG9BjfnGLgdvLAd2kI
         Qku4FqF7+IyipagvA+cfJ0NkY7JrqBjJfQJQX2FQE/H5J51R9hjk4/tyCYPFV0aKZrXh
         MaLYiRditvjY9G/1GNcJ8tKYYd7BmCuE1be44jIeMjUS7ZttvPn4k84zY/WJcj2sXU1f
         XgTxNN9uIfyq49B/YFNzZNP5Zobhcx8Om4RJgy8o1A5o/UTrx/GkcBS6tRd++qtFgH31
         BvcIAS7StUN046kXsCp/hoG9H5IUH87Iufm2uugqY4HBncsIRekJ67xg5TpBvTdJl9qw
         CWXQ==
X-Gm-Message-State: AOJu0YzOdQw26GJJXa1PYM5RsEfh6kQKnHhRWe1U+NWK4HrehQk9tcr3
	QcMfQK3M5yqPlqcp9hJQKh0S2R3cALE2Ck95ogPuDy1kRIa0YRZzQQ7omA==
X-Gm-Gg: ASbGncuDTfx/c08oOkj3vg9C6bE06Zel1VQ7Xwa1DpvqtBjru8In8I+7DqhhaWu3Qaz
	WBDFglko5Xp1zOxskobQoajZf3VwlI4EByJmwFgGQ+puB9TNQjRWDP6S7/V5OjP2JoeFX6mL+VG
	s1+ioACqiiOFuvelbzEjRRDbUd+yUOdrL//rTD9F6yisKGf18hW9pJYfmouiDAOZ4XqmCh/6GwG
	s8lvKUYyeYVktzYuEdKTM5iaVTjgj6QBtVvgItaZnAyaZPldueg05Q4wf2ykKYoLNzIbUGGnn8F
	YGA4BlfdXXak0LDPAcxiOZ81zdedRrKIK3RoKMNz
X-Google-Smtp-Source: AGHT+IEjsBLuez7vDqzanq2HadS3lU0vRC6ZaIOd+CRj0E+wgUGCYo6tCeZNUN+1jjah0vIuS2C9pA==
X-Received: by 2002:a05:6a00:1306:b0:736:65c9:9187 with SMTP id d2e1a72fcca58-739b5ff8a4bmr5231754b3a.9.1743527167748;
        Tue, 01 Apr 2025 10:06:07 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:07 -0700 (PDT)
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
Subject: [RFC PATCH 3/7] KVM: Notify TEE Mediator when KVM creates and destroys guests
Date: Tue,  1 Apr 2025 22:35:23 +0530
Message-ID: <20250401170527.344092-4-yuvraj.kernel@gmail.com>
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

TEEs supporting virtualization in the rich execution environment
would want to know about guest creation and destruction by the
hypervisor.

This change notifies the TEE mediator of these events (if its active).

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 virt/kvm/kvm_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba0327e2d0d3..65f1f5075fdd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -49,6 +49,7 @@
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
+#include <linux/tee_mediator.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -1250,7 +1251,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
 {
 	int i;
 	struct mm_struct *mm = kvm->mm;
-
+#ifdef CONFIG_TEE_MEDIATOR
+	if (tee_mediator_is_active())
+		(void) tee_mediator_destroy_vm(kvm);
+#endif
 	kvm_destroy_pm_notifier(kvm);
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
@@ -5407,7 +5411,10 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 * care of doing kvm_put_kvm(kvm).
 	 */
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
-
+#ifdef CONFIG_TEE_MEDIATOR
+	if (tee_mediator_is_active())
+		(void) tee_mediator_create_vm(kvm);
+#endif
 	fd_install(fd, file);
 	return fd;
 
-- 
2.43.0

