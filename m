Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64394B64D
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:29:54 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59b5d4a8242so10383767b3.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212193; x=1694816993; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wf8TO8PxR5yOir1Q53pTO4W/7i3l7j9F46MQ/NBc+xE=;
        b=1JjBF7DB3aCtq0yHptHZ4HRaajbfraiDTLhu69hVtzZt+hwKnsIy6yM0gJt5rRMCqJ
         O41QklHKH0KbNYn4i34BQ2ihP43+nJA2nqfQ+kxI/Ze/Q2Kv9UWa929C4ZaZ28LBlWSk
         Ti6wUjVdF/pSM266skHnUnwYVF2vewuLzVBFyWR0GnuRqlD1siJBkxxtTdDvlB8DViWr
         2pVdOPHxjZhX0Z9v24AzfpltwpM0rjAZOrn6/2P0cOthYB1Kvk+IVCuZoXq/jAyMp3lK
         4TL6AmHUbwCpjtcLU7u8ST1POQNqAbP2EbAupKRfACzDM9pMPpUWsYmceVw9kS1ZNvvD
         hoEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212193; x=1694816993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wf8TO8PxR5yOir1Q53pTO4W/7i3l7j9F46MQ/NBc+xE=;
        b=YqiHPQ5u8XSAsSrIFLiCJv5fp3C+eM83/6B8u5ACt1g0yyRaLmMGWiGXqtk76Qkgf0
         iLpkGqCZGhCPGhYvJK7dX0THDYqhv8twN8bZjXv7JJSXvHzeoPaR5mZl7AzLc0qfc0+I
         +0lpFeQEIe/ynTLdG7rqKtSH5Ks9oaSiKaYmkuP7Yz13wRASYlkiEFuoG+fanpE+9rh1
         iRvQx/T3TOuxvYfJEPge4Vg96DA5gtGhaKgNJsh82mkDdux8rPSPMQLRgDH5Dt19eUSY
         ldncvRtC36cyY5kOzJ79O25ZvGjRf3tY4JmSSCxdm3fwMf9l07h1a+Du0GRv09IwvZ67
         cR5w==
X-Gm-Message-State: AOJu0YyTh9qgkG9xmxZWtAp1OnNXIf6fNT5DhgD3nHtEjFIak5coTclC
	QRENTB8bunizC54PX3oTRHqUXfYhd7oaOQ==
X-Google-Smtp-Source: AGHT+IGgTkMjv+1Zp4Trc1aoaNyokP2piKmk6xlEDnMLwdBUdnUHoIzK29yx1Osrr1Pf4OF8Tp58c7zQv62wxw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:a1ca:0:b0:d78:2c3:e633 with SMTP id
 a68-20020a25a1ca000000b00d7802c3e633mr73175ybi.2.1694212193355; Fri, 08 Sep
 2023 15:29:53 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:52 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-6-amoorthy@google.com>
Subject: [PATCH v5 05/17] KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures in
kvm_vcpu_read/write_guest_page()

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e31435179764..13aa2ed11d0d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3043,8 +3043,12 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 			     int offset, int len)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	int r = __kvm_read_guest_page(slot, gfn, data, offset, len);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	if (r)
+		kvm_handle_guest_uaccess_fault(vcpu, gfn * PAGE_SIZE + offset,
+					       len, KVM_MEMORY_FAULT_FLAG_READ);
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -3149,8 +3153,12 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      const void *data, int offset, int len)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	int r = __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 
-	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
+	if (r)
+		kvm_handle_guest_uaccess_fault(vcpu, gfn * PAGE_SIZE + offset,
+					       len, KVM_MEMORY_FAULT_FLAG_WRITE);
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
-- 
2.42.0.283.g2d96d420d3-goog

