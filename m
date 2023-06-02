Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE181C75F
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:19:50 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bacfa4eefd2so3140617276.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722790; x=1688314790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3S/+6B4sIASEmcbAiWUGrwdrzyn3Ij/qOhyq0MCeDZU=;
        b=3KnMQGCxKmRUQNx9/GCrwoNNuCixk06ds3u4KEOi/wBb8zEVX3zs6I0WB6qefr8Uf5
         keKzQ3SMN7tF8SdmDp8m00jbXVEefJ3rH5J+M4XOhW0yOoV7HQc/h92GGhi429v90ErS
         mt/+ADOIuj/xd+F6GJBmFzwVDCJkIE629FPeaWgIE89Kua6KyLMNJaTLzoqo5hTPnZrj
         VFEW2lzLBYg8ECwvbQdeD16HEpbsKBAjS8AJeP1FrB75mTCkg5OHvWo9ALaPvZ3337fw
         70XglXByk8/ZytgCMJCKNNWPjViqg+pQgBKViEpsXkrw2MroTlNnh2nCzS+nlH0BmF7C
         HMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722790; x=1688314790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3S/+6B4sIASEmcbAiWUGrwdrzyn3Ij/qOhyq0MCeDZU=;
        b=gGT14Yc7gZzJujW+3Z/gqYg1UuoaR0DlXQrCj4iaeoaekXMJvj5PhI9Rtb/2GHNzEa
         GVmsQWzLgn0w/a/sLEqs+p3rdU5Eijim5d11f67Ri3rXkPy86JYZzw/hdLKrsnpsy2Do
         M4By4llVTr2kI2Sa8PsR4QeRyflB9m5xxySVRd9hUnXpZU8XDH6qBOXR0IxQAsATTAl0
         beH0QMOZXVnIKqbtwQYDMsUlXhkfvdNDj0xKuCBLMAEUZm1ycKx6ehxpVVD6JJw1UpUQ
         xbISKP4xYjyXghTIHn/UJegRN1N+adGZz3QUXTlIUlCJjMTbkcDoOulVX99tlzARkHaS
         e8Zg==
X-Gm-Message-State: AC+VfDxvxnwr/ZSUwCmlSLRaPdAa9gSMlUV1Y7O9kjV0+eAGsyjUwvtQ
	GXIeS9cKZojoqxvMdrgMC3CWHAz0zJl1wA==
X-Google-Smtp-Source: ACHHUZ7LmOAw8I6mCP70UYYxUu8dl4OdoZ+FYLa9vbMmwQKQEEjk5cDjm8BJnNrFHtRHYk8QXcsObPSpVZMJEw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:adc6:0:b0:b8f:6b84:33cb with SMTP id
 d6-20020a25adc6000000b00b8f6b8433cbmr1333210ybe.11.1685722789992; Fri, 02 Jun
 2023 09:19:49 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:19:06 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-2-amoorthy@google.com>
Subject: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

hva_to_pfn_fast() currently just fails for read-only faults, which is
unnecessary. Instead, try pinning the page without passing FOLL_WRITE.
This allows read-only faults to (potentially) be resolved without
falling back to slow GUP.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb5c13eee193..fd80a560378c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2482,7 +2482,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 }
 
 /*
- * The fast path to get the writable pfn which will be stored in @pfn,
+ * The fast path to get the pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
@@ -2496,10 +2496,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 	 * or the caller allows to map a writable pfn for a read fault
 	 * request.
 	 */
-	if (!(write_fault || writable))
-		return false;
+	unsigned int gup_flags = (write_fault || writable) ? FOLL_WRITE : 0;
 
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (get_user_page_fast_only(addr, gup_flags, page)) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)
-- 
2.41.0.rc0.172.g3f132b7071-goog

