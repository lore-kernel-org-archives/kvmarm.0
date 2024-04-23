Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA6813BADD
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884752; cv=none; b=N2TEXmCjbTVYrM5xGKWNtHyKYMysI+BtnZyxvfWAVKG8avIvALQtB3v7ByrLc5hT0NxuZhKFK5vRjb4JrxvT9n65IgV1HfkuKU3FPTbMHw8MikQ4qe5GJJfK5Pq9uqXgAYdLzqRm5+Hodi5YHX+G0kIb40F+OLS8yxd1nvw07Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884752; c=relaxed/simple;
	bh=vtogVAifVPZKkCAz+2mDqhqyszqWQ659/3xtyqLQK2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ENcQNq3snzVRyx8BLuZshiclZ+Ew9SulOGX+pMHSLzryE9vRrG7AD3reTYjMIOTMCJJTmi4qOWUXKzfYzCJxIG1YI+6stj4XZuqXPhvdko0TOinlG/uREn6OIk4ADEYXEeDFsx3BzH/9GuCilRjxUZ5/68mjpd+p03IXUh/d5Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=abXXpnv6; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="abXXpnv6"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de4691a0918so11455082276.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884750; x=1714489550; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ikSaXoFKf1wLAyACTTUVaZ2PDIoXO3/gDxsl101nxRc=;
        b=abXXpnv6MjY0WZs6D5rcEX21CAnMd5tcQnwJMS8YJWrw1OxEbAogwMa4/XnlYS49av
         Slo5Otn1yxyBcCwCk/Uq5BBDQdTUQHbTAX3U3lz3YoK8z5ciCcIVxXILJmTBtSLBk/PJ
         FUamG6HVbJ8B7jpAaW6ouYKC+hvzICf8pO0muIeZYFjChq62Gr1Pg7bxTBCSQTegzTnn
         nUFlWIJb2f6w9dBQ7a33cbdBOdfKPpAEEqQh8exKfRtc/pqnWAdGTrRDLuIzrXEZNuSE
         rOtMkCrlnFrcWuFPZwlF05psaXHm4f0ktcPKztYPJdC7i24RDC9qBKLEjNe884h86Lbd
         Z/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884750; x=1714489550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikSaXoFKf1wLAyACTTUVaZ2PDIoXO3/gDxsl101nxRc=;
        b=Kog67Q+OmJ64E69VV8JVMByl8gPpg+wlkjBYeN4EpmjwElUwzpWGT9CVYEuTuP3YXZ
         mxcdAOKOHMTDpZuD8hCl23xNg9QXadlAsRN5kekfUL6PXU5r+PRtgmPcgh0i0kOyOC59
         Qzwwm4M+GuDwbmUoiKAQsOegsz1g2S2vPSh2/nFGJ0QgwvQnXCgS72tw3jN5Efl/d6J9
         /GJwtpB2bCeUHprRttfnQqEwtUocvSi4ri2yRWZHVL2vIRhM4ucnouyVaN09NpxoELk2
         1wCrJ7RB8CzSiOYkNNQfku0Jb9w2IrMXAeHhivqzSD8470gBmopWE+vf6DSATsq9Vbb+
         HTlg==
X-Gm-Message-State: AOJu0YxMAQN+KJxd1ZzsAhl0Pj0g1Xi9jcDIFoUKW7W1hWXhcDk+KchO
	w10JYJHH5oHUm3gLuqp2vRQGf7Kfju+EgwFuEmD/gND8ZEvtiiit1a/qMo95OAVcQycgzGNdG4r
	6vkc4mWiW9HKTnKrh6/fmlCv85DPLiongvp9yvHymDumCHFnngaezYXViWN8e5D2n67J2R7Rx9D
	gkisfDDnLcxPdTsZPyAbmHX/4J9Hs=
X-Google-Smtp-Source: AGHT+IGAh3VTtSMIP93VEQOfLjUfy13ZP8BaDI3RoKHRhPgeYMZH9e6E8K6bI3XWiMd0DGcbAa5ZCj7GvQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:c12:b0:de4:6624:b763 with SMTP id
 fs18-20020a0569020c1200b00de46624b763mr994996ybb.0.1713884750008; Tue, 23 Apr
 2024 08:05:50 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:12 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-5-tabba@google.com>
Subject: [PATCH v4 04/30] KVM: arm64: Do not re-initialize the KVM lock
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

The lock is already initialized in core KVM code at
kvm_create_vm().

Fixes: 9d0c063a4d1d ("KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from EL1")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b7be96a53597..e2c08443f284 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -222,7 +222,6 @@ void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 
 int pkvm_init_host_vm(struct kvm *host_kvm)
 {
-	mutex_init(&host_kvm->lock);
 	return 0;
 }
 
-- 
2.44.0.769.g3c40516874-goog

