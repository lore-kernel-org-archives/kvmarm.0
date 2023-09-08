Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57886B64F
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:29:51 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d8011973047so1610241276.3
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212190; x=1694816990; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/0BHnhPQjohMasi1FkwP4rKpLhtBzedfsHeNgZmOOQA=;
        b=Pjb+BsrP7rcLJzxjbXpb95QZD4OkUONrWjKa8yimZZrW8ks8AXEHMMZD2m8y8U/TjN
         vuDWiYn48R0zaA0qVXRY5KjIgxi85iX8SGyGCPoG3o+27UjCzAGwxVo9HX5EWuftEGPN
         PtY80JY+2I6tz7FFIEmu5y0w8lsyV5blSAKrFDfb5ps7jndXKQ6DWqrVcoa0A+UC/zyI
         lrSlFanad14jZl5vMbKsDIrjcip5nlZjUnH2JzOtJVvr7Z6HZYikl9uZA7k7/VnulCtT
         Fzp3cHfnho7D4L8IOuFcKDxGENQOYTFVzoiXYUgjPzFyPjJbaqsPT0e547aICLHOcfKm
         CuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212190; x=1694816990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0BHnhPQjohMasi1FkwP4rKpLhtBzedfsHeNgZmOOQA=;
        b=DOXVrKDKRAU+PCAsvCDQ1GHiUS1Rwuy99lvDVtUSFoNNQob2k8K7vTxnSUpebxVcPK
         bD8yxBUjJHC/0V3n+eI3PabBPxkgKNdfSFBpWeDhq7QchQODogNPb0M1OJlC+iYl2DUO
         OvmmDufMJ2qOob6mhZgbXZC7k2eIiZzI85ylGnlsi/ouai9eDKzkp77YfFUCS0z9of/s
         6Xi6Vkx6tIZoWDIbimJw3e5KxRYWqvGyCdny+asDpx9FsizTp8Lgxe6TH1ch7GcpcNdG
         v7A7nF6/2+L9rX/4KvFGSnL2sH0mq7B1PMN/94UQUKb2ohPTivFTTqRJyVmgMKDPYU0+
         wjFQ==
X-Gm-Message-State: AOJu0YyAvbXXbWAiWZZIjj2Kso7RCHLzUcVLB409IzIzLoA/GQ0PODwE
	BJ7dH1aJhLsKds8p2mC3FLZmS0e69RlD9g==
X-Google-Smtp-Source: AGHT+IGp3U+3huHXNrxPmxtY8xOiIHumjFDWxT6bJyVrVGJlTBuqH0tDk2yalvdlbk+Mgf/zY5+CmxE2i9YNdA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:a8b:b0:d12:d6e4:a08f with SMTP
 id cd11-20020a0569020a8b00b00d12d6e4a08fmr72162ybb.6.1694212190325; Fri, 08
 Sep 2023 15:29:50 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:49 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-3-amoorthy@google.com>
Subject: [PATCH v5 02/17] KVM: Add docstrings to __kvm_read/write_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The (gfn, data, offset, len) order of parameters is a little strange,
since "offset" actually applies to "gfn" rather than to "data". Add
docstrings to make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 84e90ed3a134..12837416ce8a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3014,6 +3014,9 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/*
+ * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
+ */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3115,6 +3118,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/*
+ * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
+ */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.42.0.283.g2d96d420d3-goog

