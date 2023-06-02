Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABD91C750
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:19:54 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-565a1788f3fso33847227b3.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722793; x=1688314793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lyZUHE9/fyNrrbCY+2awKzeCg8s/o8YA8lAkE85HkUA=;
        b=5KQr/N/vL8WS85s3yvYVvDH060if/rqEHZclIifsEOMW5RjhqBu8cEpUBR1EsXAJiK
         CvAmfgCxBqe1xlh4pYKqPw6lv5F6iu5NTPblKg3PzcP/gDnSvHBIknCqxnTw0VGCB/d4
         ekH8oK3P/gn+D/e55I8dkJuesutlDZnHIl10n2lRL3MHVShuomENwFNhrUHIE6IKzxCY
         W1dAyBDugyJdrO8giQIfmhpNxMO/scWRsdfG64Uwd52Xl4B+MoacP0grXr+LqgHMpgm9
         CF6cBMYk3xRSzR7CZxX5Zufji1l7oszkaYIvfyFFsvnamY0fqemW545JacjhVd9ndRi1
         Pn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722793; x=1688314793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lyZUHE9/fyNrrbCY+2awKzeCg8s/o8YA8lAkE85HkUA=;
        b=EKO991lbBX6u62y+0vgJTK5q+1AXyxZiOoc50OHVrrEzVXKxbJW65v+m5SoGw2qazb
         RtWIulON/bmPL64jMRUF2WWC9+CUSfbucgnwdAeqAOxCBxu51olsGAq+O0icAiQ2FUP8
         43CCxGheDV7c8YsGkuen5AjDUD8oMmmjirtoQmp+JRbohU66ke5G4PB6nzsm/Xd+dwUG
         HtLJRh/Xrx3K2nyvYuQOXWT8JLOaChIEo8Oz6oM7WXO+558QlNKBpDmUrN30PQWLOcEU
         itAq16qr3r+MVsicoVENtScUYNPskJUGyhV4+4eSMZ27cIMMu2Wi4QgdvD5oDUW9JwOe
         UP8Q==
X-Gm-Message-State: AC+VfDzNxDPXgJ8dqlO1NyTTfHzwmfgbdEBRUHrhUm0MO/c/aCvQw+HJ
	qRNyDCTOzBzgSQn3GGxSh887Sj8dQphyAg==
X-Google-Smtp-Source: ACHHUZ5xagS7Qj6bDef2zTXcmIPJ0OibSez/salGei0Ga5GomMaZ50IiZeSgtu2e40duF3DhLlFNe55hQwjkDg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:b512:0:b0:568:a244:d8e5 with SMTP id
 t18-20020a81b512000000b00568a244d8e5mr192120ywh.9.1685722793529; Fri, 02 Jun
 2023 09:19:53 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:19:09 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-5-amoorthy@google.com>
Subject: [PATCH v4 04/16] KVM: Add docstrings to __kvm_write_guest_page() and __kvm_read_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

The order of parameters in these function signature is a little strange,
with "offset" actually applying to "gfn" rather than to "data". Add
short comments to make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 09d4d85691e1..d9c0fa7c907f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2984,6 +2984,9 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/*
+ * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
+ */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3085,6 +3088,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/*
+ * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
+ */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.41.0.rc0.172.g3f132b7071-goog

