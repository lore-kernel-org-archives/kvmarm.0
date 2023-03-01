Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0868BEE
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 21:09:44 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id o8-20020a17090a5b0800b0023740160d09so5031965pji.6
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 13:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DqA9XPbdG72ij8bnt7P1FG5k/aZwFU14SdlEVjUmaeQ=;
        b=Di8RI9KA4HPs+lwFiOVEWU1f+4M8cDSY9XVJ/MlMifv+lFD1Kx+kz15kGAQ26n33Rw
         mLMjSPzYRJ/nA8sEBvn7Ge1ky3/HXLI5lzHK4ddEk0XvH3x3kphbhtm2NM7a3PFMtPmw
         dQu24XlzT/OTKwnEC/dX6oZ2++xnNEzNw/S7IoZ/bPVBy0rcJX8g0cGQuCqBcc1oczET
         V/5F98DdOOcXw+2cKe9nhAEnUrJiEpuL9jW+tdG8YqbPnTlKBoXpgbkwU9UMxbh05YRH
         sWwwgixDq//SOtNAEZI7n+RQGa2bY6wjv3xzSj98H8ReMzzb+wnY20jIzezLmA09eWVj
         IbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqA9XPbdG72ij8bnt7P1FG5k/aZwFU14SdlEVjUmaeQ=;
        b=FnHZr7xh6IV9S8QX35uE3ugN0q6TVey/8teIYy4QFyUZFcZyjwbkBgA231qfzZT6ra
         /n0ata+C71i07Rzu7rjm08gsOpLgmgYYuYdJd3NioodstLqw31eG7vsH6ELsxqbEUAqO
         6JSNmPGDYkqhGENfi2syXZ7aGI44nyidqobWSkGEYU+Y6qYTFi9piSnGiU1HP7B7fZIx
         hNdofLyc/HH9Gzn5fmjKp2qJQtHtvcOSN70d7tntAEPYbsf0fmdgKI9PjTKnCj9/D8Zi
         5q1eJ2Xuu+lhICDp9/Kw4872eXC8R5bnWYBLclZ5NO6zp86CeXlz5tZTGF+a8i5p9Coo
         m8lg==
X-Gm-Message-State: AO0yUKV7A2AgAwrWtEh3G1G0cOurbqDWyuvdjdyh6x6utJB78YHCiqhU
	mdYFNuF4x3L1leufTaUKBZgEbZWvNr15aQ==
X-Google-Smtp-Source: AK7set9aWhP2GLViX6xifcLL83bOgHSFy+VYxOzjjIe65tdTxY8xZL1AY5Jg738RWC0IZjRmQr5q+r1hn95JbQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:903:187:b0:19b:36:30e0 with SMTP id
 z7-20020a170903018700b0019b003630e0mr3105569plg.5.1677704983960; Wed, 01 Mar
 2023 13:09:43 -0800 (PST)
Date: Wed,  1 Mar 2023 21:09:23 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-8-ricarkol@google.com>
Subject: [PATCH v5 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
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
2.39.2.722.g9855ee24e9-goog

