Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E1438F90
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O+511P1c"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da0cb98f66cso1594682276.2
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563832; x=1700168632; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FlXGm33qnDUGSwPi6nRUH+NhfpRFfL8yhZwyreXloOM=;
        b=O+511P1ca+E/wGedA8VDt1t13c9m+Tcyyr9htXEuwAv2f/GvffTA7A+TKcN7aR2q13
         mltvGqw0V6ZyxyXpjzlaOvmFAYd2lHG4X485irly3d8NRWXc5YqE3lSxU4VAITbyEtGT
         CZouXR3ZCvBSbrOVdiqvtfEtri3p51Tg1EMdWzhYVlbZ7/Id9EE94KOI7FxrcotDws3G
         THF2cKLUsDEQBweqtnfPvf66TTn5cVOARV6TjqcrEDvU5kUD26o9KF8otu0YEP8P+g3v
         KTFZjlNfusXKO3x2o40wN4hPPmTGpP4xaaD6mTtVbA8brppC38TmFgFr4fArhPFpdOjh
         Z6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563832; x=1700168632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlXGm33qnDUGSwPi6nRUH+NhfpRFfL8yhZwyreXloOM=;
        b=PvCW0Xg5JstYSUc35OuXi4Fd4DXBZ/zlHwK10S5NfdPwpBnl3gQSA750agpHlhPBRS
         swCZEymn1b5J0OkybgLkS6SwJjsNOY0ZvVY+FWnHRvNbik6xJZTlEL8ufktdEAJ78U5P
         PMc/2gB+xWCQ4wbf2KKLluN9HKubV9F0YF8RQLmPRi6uCgn1D5IeOpJ5ccu1I2+e9HNE
         W4UcQ1VD1nj9vqvVd8DCT8QEm5Q/767/LmFb2zUrqeUNfNgFLCUemj8BOd+tdbTAnLf5
         glAnAawBeqial51cCIp8/bmWLrUlnaez/M5m7aputluk4XQx2igXoO5hMUtl4DrF66sh
         y3pg==
X-Gm-Message-State: AOJu0Yzlz6C1v3jUZZGlKBxfauV7ElS8jg26hVZJfoKVjw/1H0KYHWhg
	rMj6XqbylwEKZevgCPC45F1mqvh/1Iak9A==
X-Google-Smtp-Source: AGHT+IFaRWh9Kbo8WRKxbI1CvM7U18p+ZwojLoHrOJQ0ULGFOG0q4KET+/ELOWlz9GcEp/WRM4l5DEYeDb6NvQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1366:b0:dae:49a3:ae23 with SMTP
 id bt6-20020a056902136600b00dae49a3ae23mr158715ybb.7.1699563832063; Thu, 09
 Nov 2023 13:03:52 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:19 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-9-amoorthy@google.com>
Subject: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

TODO: Changelog -- and possibly just merge into the "god" arm commit?

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 317964bad1e1..b5c1d1fb77d0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -241,6 +241,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
-- 
2.42.0.869.gea05f2083d-goog

