Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC89416CD11
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654976; cv=none; b=VD98MlPI+iEK3hUmCJ+mFc9zUG79NGjUcHIeUh5G7rv8L2IxhzIp14yBA1AqLMpP8t2kaVOM9/4Vuiy5i+L5FUhhExKP9q/feV7fYaBp+XGH/unzz8CkL5JHptxN1+Kj1uDFWNmoKg/8pT59ENA7AGFTKVDUJjw+lEh5bmAHpUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654976; c=relaxed/simple;
	bh=8593VQW+qY6IG/jYYpHCncdh+HTnZZx/ZSFesd4ewL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJ1QfJ5QVvqtBZT6FJgj/WV+UmHq53XvN+zNoIOsBXB4NYMNpgPXIwt+hLIhUtBekgYCgI9CcmMG1n19vV7wRKl3qINBiSIcZe4OGde33wy4cfaaRIgstcYDLmtP0kEvFXqrM1aKSxpgtSXYhc629nREwmOQnShm7HFN4od64/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KhniOC88; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KhniOC88"
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-49007746a33so105595137.2
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654974; x=1721259774; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KrWHeRDFVlfzCLm2guf0VTYM9h/W1rUjUnfwvHRBaDY=;
        b=KhniOC88REOGY7387UWQ6w8///U8xGfbCvxswGqldJS1ifG7CqBhUopOq9fgzaqbyS
         7tNr6DQGahkv8XNaFRQV7mO2KgwQUIpCvSXT+8E68VgjCUly7pv1dbjLRQ7Lptsks3td
         RlExeTHbFY7nN+cAjfkPViXqAY2cNIKTHqfSoSGVBBlk6LJJA+NIaP66tyIIQdgBwkRy
         ezBmbCQ52ptmNtEM47noswQln9hc6A6bAJliZp5upCPeUJ2y0WKy+T0PO9zTAAT/EUVl
         WI+BjEwKiWdoD3faimWS7PtHyQO7ZZRIniGi3BaQgUGIu2UrIClsbXPUi/0ulMtsy06O
         OKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654974; x=1721259774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KrWHeRDFVlfzCLm2guf0VTYM9h/W1rUjUnfwvHRBaDY=;
        b=RlpjaqPmTj3fL2U6VycGfj3CdokaXqW4hzDPrUBfRtAczV4k9JxcLB3808RkJUjAAH
         IXmQBGzbLodXBkIcjpIF+VbaKPHhMIOGcGBlaTVd/xWQuxSUqEQQxWYIV6oC2eWDATRG
         um08xpi8pdfm7lWrFw9KoOCZbGOXIyUf+GZOoGrRHmF7uAXWawJufhJZKBO7WS8k1PCF
         iFc4/46h8SyApJd0xsRl00QhlzO4ad+ody12/XctZoRuKNHEn1e9eHzcUOZ71pEt6i+W
         gDV9YR7aR2l31HzvAX7s9DdPv+BgMTTql48isWb14QbXBduhCtM7HD7zt7sWRFGmqyKk
         w9rg==
X-Forwarded-Encrypted: i=1; AJvYcCU6H/5cxWzB2bGRqk2FRgC6RphzaRrRn8vShy+cf54U85eeR9AxOaiwNAKyvRe4nyXsPaqrLuZa7hMMr+4g/ugeH+pR6UPB
X-Gm-Message-State: AOJu0Yzsn2o7X40u5lBmEXzQxjh4aEnCC3PQNE268OJLK4CessO/fy7A
	ip29c6Xx+ia0l3rWG7JBxmTVl+taLRjr1Wtnmt69Ei77m8+mdKGxiezxkLKU0RbHJmwspcjREoe
	4g/c4CN4gCdteKq0mgA==
X-Google-Smtp-Source: AGHT+IEk1FL65vqiK6UE5KirHXI/3mEOw3BUqoQ0HFsCZaEXrmaSc1CqWM95u18pik8VbBJeKyVeyhW9FRI1OD+8
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6102:5490:b0:48d:89b6:85d2 with
 SMTP id ada2fe7eead31-49031dbea2dmr435474137.0.1720654973979; Wed, 10 Jul
 2024 16:42:53 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:20 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-17-jthoughton@google.com>
Subject: [RFC PATCH 16/18] KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Advertise support for KVM_CAP_USERFAULT when CONFIG_KVM_USERFAULT is
enabled.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d2ca16ddcaa1..90ce6b8ff0ab 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4916,6 +4916,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_KVM_USERFAULT
+	case KVM_CAP_USERFAULT:
+		return 1;
 #endif
 	default:
 		break;
-- 
2.45.2.993.g49e7a77208-goog

