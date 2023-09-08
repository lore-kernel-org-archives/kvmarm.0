Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED684B654
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:30:00 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d7e79ec07b4so2662420276.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212200; x=1694817000; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=43OsBVzgibsjHQzcaxYrViWOyyh57gKn8UrK+ylhvCI=;
        b=fKjXdJFnFTwZQMc1Yt9yuI05yxcGRmmyie9b/btGMvGl+/1jYJ+zJ7kEjHX/xTDQDc
         r7NnNcedseO03nZWioK+00Iq124WCqfbeWuSffUhmhAdvV5mwfTiYSGbREDkHN0aZcou
         Jx3sQwCY1GnL0CtknyHZpRj1CBuf2VmB+nk/Sr3L54T5vSdcew5x88YX6nyr/rrTiaZX
         47fvSQKcw6ZGgqBQFpz2k1QRUiufO2zVI168hrIe/yxKAdLHDA0p7YJ/Thdr18nu9PKm
         ifpVm0VPvo00NmALxpeAc+sSq7FCVKcwipNUHoeZ7MNnSET+h5BYl+/ARQXBBoKRjALm
         6XQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212200; x=1694817000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=43OsBVzgibsjHQzcaxYrViWOyyh57gKn8UrK+ylhvCI=;
        b=ZMP9VB8Y5y7dyc4stoNCsJJHXcGurpIoKlm0ZZTVVip3Z8x9E3RjdHCUak1aHq+ug8
         vueZ/2xC8YsP5xl6BDdKyGsLJwah8geW2HdDFsg/xwBS5No6Nxd14ClFml2zMQraKCdz
         YN+3q7gRX0p66d/q7UJTI4eOD2ZSYbBOK6JlUgT0o6nOXIv+2Gm7Hlkn4AYR1HGt+Gvv
         SGFFHwf11aj6Utw+1D3htSMSPTuNnO6nN0I2BuomNirk6R9zUNsZbQLc6170J2z9zrLb
         74tdLxfwm+hUiwbUjYpiL3pt6D0CksLFyzl0azYFWEU1PKa/EV5+fUwHbN7ViKoIb47O
         m8Pg==
X-Gm-Message-State: AOJu0YwXI8mu6WSn3uTcvepPUMe3m+ftM3sw0o5dLXLee/KhmEL1v95k
	UltgxHrhNblTatlV+xj1BB87RFP5aKwMNA==
X-Google-Smtp-Source: AGHT+IG2K9vYapHGZteSKcwo3I41HEOYuLvqUgZ/ljkv2g4SRllJC/MiufE8PmX5pJDyOTUwONJY/zrQWnN7Kw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1022:b0:d80:1250:89bb with SMTP
 id x2-20020a056902102200b00d80125089bbmr87935ybt.7.1694212200222; Fri, 08 Sep
 2023 15:30:00 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:59 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-13-amoorthy@google.com>
Subject: [PATCH v5 12/17] KVM: arm64: Enable KVM_CAP_USERFAULT_ON_MISSING
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The relevant __gfn_to_pfn_memslot() call in user_mem_abort() already
uses MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/Kconfig         | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a74d721a18f6..b0b1124277e8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7788,7 +7788,7 @@ error/annotated fault.
 7.35 KVM_CAP_USERFAULT_ON_MISSING
 ---------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 83c1e09be42e..d966a955d876 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -43,6 +43,7 @@ menuconfig KVM
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select INTERVAL_TREE
 	select XARRAY_MULTI
+        select HAVE_KVM_USERFAULT_ON_MISSING
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.42.0.283.g2d96d420d3-goog

