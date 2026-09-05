Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F723ABB9
	for <kvmarm@lists.linux.dev>; Sat,  5 Sep 2026 09:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788599229; cv=none; b=hLYySi095N+pgZVfiYFNhIoB9B9Hjjw2CYEv+3Rdzn5FDH30OAGm3WGJSrZ2U0cGFSh6lKTKzTPI6Mo8T7hbPJXrC/kMjIIwW2pTPIHseeK5yE2DuoybQ3EfvKXr+oLGqpHqKDqowUvAKYKok5KB7V5AphG+mlfzx/sjajuZBjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788599229; c=relaxed/simple;
	bh=rc5XxMzqZHN/h8i9gnu5Hvcap9+yLXVxJXL+WFRkUqk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hv/eH1Tv6inbW6OLtzPwAgTQMTCa78A9dT8pNSSbnV37ESmxn70vIh5BxtUKFHz8C/mmzNkgN8qpbdhclWyEWZSz0mOKBXVIdBQWYsF379HKGu3HsEKULEzNDH+RvsHlNFgww+muMcnT+zlpfsEXMy448iyTEdt+J/TVAYUeuR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=abr8q7ZY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="abr8q7ZY"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso20776615e9.1
        for <kvmarm@lists.linux.dev>; Sat, 05 Sep 2026 02:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788599226; x=1789204026; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e3AIKTqtccN8F5dbw/sA+nWDkX82cUAi4NxD23crSBI=;
        b=abr8q7ZYioiLk++TXUf9WDSfN/uo0GjhRV2+xAb9yxnSXkt6wFzvbFy07vOn/SLt5r
         OHVe+DfbsaOSdD7Ib0PFPb0/9JWmh8SZcaXwu/qWX5HK0qd8dp6gsXeGhHqpoyIlNMvY
         K6x2gwzk76GIMKPMTN81z4p1SXmIFT/QiMeBO89uuyT0fJc925wPQ11gOrzPQTcfn88S
         IjOv8TH+uG+aWWD4BxTsH9hEdgjTfFlvAczsWBCphM9GeDypbQCfWPG7TZRlHnlH/4o6
         jk2qJC4ptkoQjaVKbdsk/pMKw4FMeQK9Odblvv2VbpcsbF+PVqc2Dh+FWqDbzQrf9vxQ
         LTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788599226; x=1789204026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e3AIKTqtccN8F5dbw/sA+nWDkX82cUAi4NxD23crSBI=;
        b=FiPT/d4EoJUjPXeG9/oRY9GJb+IlqX4Y5+cyWaBuIT4le0skegfzER3Wd7IBR/b+1e
         Hky+tyPXrxjb5QMcQvlPd7ioEa9MnQ3aBcuUfiufgVfsTNJZ3pBiU+7LAn8W2gymb1IS
         8cxNaI92n8fh5/f9pJJb7v/JmaWDA8SWOZd2K7d6cCkz7VDp8cDdv22v/RzZhR1vertn
         jVBa4pIHFu6eyuZLb9zD5cFaxjaelY0MlUntVti25cBSZ5AhQjcbZ0OQ1x5ImLj9lkC+
         F1S9D1a5gna290Bwl8Xlq4Tvlq5FxI5JzOYw/FMTyjg5U03w4YLwMoxNMGgUiqBU9dbN
         SRyw==
X-Forwarded-Encrypted: i=1; AKwUvBzOMgiKg6rfC3eXBSs2EBNwMyAv6tj1GlWUlcK2dJGwfPX37SGkVJ+MiNXhV1eELj2RgdAzEXU=@lists.linux.dev
X-Gm-Message-State: AFuF++nSsaqxXDQ8vhvXDPOp5tIC8m2Fjv0eQKPHoRcTmZqQhV05mNaA
	EbrkJC6JPNz/GNTOv89Ax+2V/9zfylskNNhIRlWyVd+Wk38gH/gPh+08
X-Gm-Gg: AYBFou0QcI0tXHC07i1MPsZNhBI0OVJh0wvjxJ9uWPFBGJiC8jTYBr5MruHd3lHc49d
	yGAaEDDkrby/oPzAJAI+gOWtNapK9xwGDWlpgHNXYlBIealxkWLlahJF5mHjnnKBA9XLvXF7FXv
	nv0LwJPRxwHV6SxBjGxF1/ZfU4NA4iufRSxsMymOsnAIJcMNTX5fTveXzgABHTsfZ5yKFeYfq52
	SKvf1JBYXGTfkkDnvzPSfrH1BKB17Zr+CefiZdLUMs9rvf7rN/InW1SMg5aTyErrEBARhoMu65i
	aFI78hGNrGlp0R0TK+WYvUjxFKZDm0l9x8n39MY53y74BKtu17yOa9Ge/zdSZOsB5tOlKtwjk8U
	jUsYFyTLXEJ+B+SxDk3kc4cUqnd3jU5XCoCrCMDlRGWXAKLV2o3pqfV02p+HCawKGnaHI1Pf0ep
	UT4iJMEjO9FPI+wUWniMojNHdQk3dZOxu6y/iuBtCQH277/J9QeoBE6kdRpVMaKhpX6vexHpfHJ
	dP7cvbYhAT7tTbY3KPq4WAYApgPMu6L7i7a/NBgyRJqmozfO+yeiua2BhI8WhrXjiY/6ORirQVW
	17kL3vmmMGpH7/74fZ7/3s7tYqV9jz8MFmVJvLmskQaTt15BqBWqi/U9CE1E/EZuo3du
X-Received: by 2002:a05:600c:6383:b0:49c:f4ff:e872 with SMTP id 5b1f17b1804b1-49cf820507cmr104027405e9.5.1788599225704;
        Sat, 05 Sep 2026 02:07:05 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a4eb-3001-c06d-af27-9fa2-ea53.310.pool.telefonica.de. [2a02:3100:a4eb:3001:c06d:af27:9fa2:ea53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d00a5b19dsm52248545e9.2.2026.09.05.02.07.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 02:07:05 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] Documentation: KVM: Fix the struct kvm_arm_device_addr name
Date: Sat,  5 Sep 2026 11:06:55 +0200
Message-Id: <20260905090655.40683-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM_ARM_SET_DEVICE_ADDR takes struct kvm_arm_device_addr; the document
names it struct kvm_arm_device_address, which does not exist.

Use the real name.

Fixes: 3401d54696f9 ("KVM: ARM: Introduce KVM_ARM_SET_DEVICE_ADDR ioctl")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e0430cc750c9..7a2de8640226 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3676,7 +3676,7 @@ type KVM_X86_REG_TYPE_MSR, but are NOT enumerated via KVM_GET_REG_LIST.
 :Capability: KVM_CAP_ARM_SET_DEVICE_ADDR
 :Architectures: arm64
 :Type: vm ioctl
-:Parameters: struct kvm_arm_device_address (in)
+:Parameters: struct kvm_arm_device_addr (in)
 :Returns: 0 on success, -1 on error
 
 Errors:
-- 
2.53.0

