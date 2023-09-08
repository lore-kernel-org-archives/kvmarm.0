Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098F7B64D
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:30:00 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d71f505d21dso2550433276.3
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212199; x=1694816999; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/sy4Cn1X3f23j6DJCKOvy7yO2KD//Ic8lCob4A9AHhQ=;
        b=uVsSMYMHajRpyINjtS1Ay1Mm8ylschd25obgYbogDFK4C2mt0xDcQ6Okei4qYpoLfz
         eCqkU9P8BIr1LoQpgEtBD+3xIMCIVNyDrF0J62o3fWbshHgRU8UZaTuVC2Tm4oER/DfA
         tP2yTYjMWnrNXBKdeLOO3A/omm9/rYxuuyIe3sK8j546+fMTe98e5I01yr8H9aFBtANf
         lGOpWi9SGVeMPUwL6uuSbv3alEsIHw2GIJwQHwaxGtjdvbTLl0bvZ7jB3sKFgVfT9Roy
         0aTa5oYgMlh+eYhTWvp7iY3lEQdSaZPaNVU8iY0my6F4cpa6GrekXGZYl4rViOS1girl
         M+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212199; x=1694816999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/sy4Cn1X3f23j6DJCKOvy7yO2KD//Ic8lCob4A9AHhQ=;
        b=utYZGHB/KWQYATlpIlRuVwG/wM4ylQJxTrAheM8lw5tVHwV3OiEkmgi87VxgjViyGy
         xFHDd21bNSdXNyee6746ZM1jAeTXM8cntWPp6HkdB0eqaaaVXQ06uMrWj98BIYWKEsMZ
         KyxR7jEHl1hrLtE6kiXijE+Rl0wtnkdOYxN4r/HzPORFspzEK8/EXIp+w6KJX7hGJoDl
         oGZN5jCiBFcz3kEWhiX0j0Tqtkr3qtOD3xw3KZpzp7wj4vIJz/jZrrvl0xWx91PzwTMm
         NNxwpoy86NU5ZH4P/ocm8D9BhLfc1IGA8PvwJGlKX3pTDn/8WDqbIj2pySNQ++n7K8m0
         Q6vg==
X-Gm-Message-State: AOJu0Yy2xLpkUxWZ80e37UH1CQnj88ov+rjsd8TT1OYDVuQp+7lTROEF
	DSoq5OzdbnssB7CPfTsf4ZJCQ1bofZCOZg==
X-Google-Smtp-Source: AGHT+IHfZ0/H1S0KyKpbxmbTxxAv4PkI43WgGvDpPDRHv30smv/EmWxfKi0rHwtfKXYTF2yg50kBD8Rw7qxr2g==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:98d:b0:d7a:bd65:18ba with SMTP
 id bv13-20020a056902098d00b00d7abd6518bamr89404ybb.3.1694212199283; Fri, 08
 Sep 2023 15:29:59 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:58 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-12-amoorthy@google.com>
Subject: [PATCH v5 11/17] KVM: x86: Enable KVM_CAP_USERFAULT_ON_MISSING
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The relevant __gfn_to_pfn_memslot() calls in __kvm_faultin_pfn()
already use MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/x86/kvm/Kconfig           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c2eaacb6dc63..a74d721a18f6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7788,7 +7788,7 @@ error/annotated fault.
 7.35 KVM_CAP_USERFAULT_ON_MISSING
 ---------------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ed90f148140d..11d956f17a9d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -49,6 +49,7 @@ config KVM
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+        select HAVE_KVM_USERFAULT_ON_MISSING
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
-- 
2.42.0.283.g2d96d420d3-goog

