Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7227B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:41:02 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-4c8e781bc0aso229723417b3.22
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F7pmS0etoscsJWB31SNQ0h7rXLmwCbZI5n0ahNK1Zxc=;
        b=BkglgUo7hgFH0voA/pzzH9dAyhjXKOyLokdbDXnZmmat37ke58uDWgCy8VW/Wy/cqy
         t5SY2VP4f5nQPltPGAlXM4o+C9zUoX1UhOZgOqaERs/Q0guYOZXHIoeTF8XGmYXj5KBh
         U6HPOEubmicYwXVNYIznD+IE7BBCfQA0Nl7IERklHdSwdTdOWs1B/TkQZbt6RYCy3IuT
         nO/SQvThH02fcyD16UxXoMDjq6Y22JXC3ju9/MXG6+9jKwplhwaOYpTWOB4E5AZv1Ru9
         fFF7uKdlPzEdvaXp67uB3P1YvgacBYjJUK2aTjAgO8NOzQLvoGnDtc4I6eaQ7yf7FDqG
         qnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F7pmS0etoscsJWB31SNQ0h7rXLmwCbZI5n0ahNK1Zxc=;
        b=zoABvMtoNcaVtoVw5y+8Lw26JdO7JsXt6+zbap+r4AeIqZsWznKli/uTmuY8x7yTdK
         aKoc/KNuhwXJWzzR2cv7OgTOyjVthLIcm6RN/p8fPQvL400o8jTeqdzTj2LEOLNNZzjE
         yVp6/A9cQKbAajV/ZQ7OfIbb4e/sKeV9cGN/B6blDnAEOmOIr1cf/h7zWTRyMH4Y1F5G
         L+sSk88hUdrXBiEVU1CLSQp099w01qWJ50OJl1ybcnk7lD6hLLvPeAhOFj41nrQSRFQK
         WtdkQ98WJnlMBoRMZgtE2OjTSHxkcQEQwWrL1FYjVPQuj5298vpDBUBE+6ENaRcnWiDE
         PpKw==
X-Gm-Message-State: AO0yUKUW3U7ilkqlnDVPUib7iZNfLDwIg9N14Bsci2Cdl3OHOvZUNPjq
	RqJMm8ZcVGCMDUBCee4v/5Ngj2zMpLVP3Q==
X-Google-Smtp-Source: AK7set+Jy7z2qk9y2xPyd0hgX9cF2Rs6bN8+J369ziuNiWMAFJ8XPlPOKXYBYze5fVC1+rVVIeLv/76M+F4NKg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:7903:0:b0:855:d2c4:2119 with SMTP id
 u3-20020a257903000000b00855d2c42119mr366476ybc.107.1676482861684; Wed, 15 Feb
 2023 09:41:01 -0800 (PST)
Date: Wed, 15 Feb 2023 17:40:41 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-8-ricarkol@google.com>
Subject: [PATCH v3 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..8c5530e03a78 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -991,6 +991,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
+bool kvm_are_all_memslots_empty(struct kvm *kvm);
+
 #define kvm_for_each_memslot(memslot, bkt, slots)			      \
 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
 		if (WARN_ON_ONCE(!memslot->npages)) {			      \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..3940d2467e1b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4604,7 +4604,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return -EINVAL;
 }
 
-static bool kvm_are_all_memslots_empty(struct kvm *kvm)
+bool kvm_are_all_memslots_empty(struct kvm *kvm)
 {
 	int i;
 
-- 
2.39.1.637.g21b0678d19-goog

