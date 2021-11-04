Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CC7C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E13CF611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E13CF611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91F9D4A3A5;
	Wed,  3 Nov 2021 20:26:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tIzxTqERXSiY; Wed,  3 Nov 2021 20:26:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D68064B18F;
	Wed,  3 Nov 2021 20:26:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 112024B13E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VDDFzjsfcMYf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:06 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9666E4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:05 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 l7-20020a622507000000b00494608c84a4so262440pfl.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=E63+zcqes7aObPmDEJrvowSyb7WASC2+JFrjiGuoOMk=;
 b=G1EofX3RvsgDocbJ2WdlZIxLPrRqCOY3yk9dCpHXn3BrotBTcINoCOIdoZtnGuqNkz
 XjduJywdhEpzM76x4KoUTmOMqDWGTwqBcR9WlCLJ/Ixo7OZNiFzolIn6uGeuv97Lynv7
 ddl94QsCyWYRP1cDpWTxGlOfLjkpa9JMyPhL71/QGQqzOCEiWBc8/ntYod6VDaOBqRIS
 X353qmmShX/kJORUwjw2weuKuQNgd6XS84Jwff3SPGUNlABXgf8tKjegkYwWGGN3YZ/S
 LGQAetSmsnJyG5LH2Wdt7/WsV81v8KEKNpq61Fts5PSRMZc9eqQNsC0W+vLYcBCTaqSh
 tOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=E63+zcqes7aObPmDEJrvowSyb7WASC2+JFrjiGuoOMk=;
 b=nfsTMC02X12vKBgnbsvyhPDRvz20eN1zR7Dzv4Mrhwx8m2I4/XeUt0fGhPzheYCqsQ
 vVMS6XbeKfTIGV7zHW/ImXDOslyQGVfu8yoqxPZ7STnc49DM3JVQ/irE5HwPnZBWHJCa
 IeJMHPjIxQwJVYh9a9XiBYSLPWN9PgGz1oDg0FyJW2tQsS2178B8jeWZUiy1frhoUl/D
 mTUV98u3RNgz+l3rUWuGI+yKbptupkhGVs4gpoCZJLPZJhlV05oVmlXF5PgPjqWyqpiL
 ERe+diIHkHLIW2fI5agWIzHaWBRnsTOx2qZL2efzSYUtxCdDiTL2Nd80hj2Z5fRfNRWL
 Zqsw==
X-Gm-Message-State: AOAM533VqYJSSoforxjCg1AGmkaSzkMMGLzbk+XDWuKBo2uEAsRXQfWT
 ebY/NKSgUQwXPtSHoVi8Il6nRxASCCU=
X-Google-Smtp-Source: ABdhPJyxb/nQ01mzKYX4m8bfp03Ule2nAlwfJSHz9a05yqoefRBI+SnT6XPXcdLf6g/xUstLGwYZnueYC+Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:1b8e:0:b0:44c:9318:f6e1 with
 SMTP id
 b136-20020a621b8e000000b0044c9318f6e1mr48578653pfb.84.1635985564791; Wed, 03
 Nov 2021 17:26:04 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:05 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 04/30] KVM: Open code kvm_delete_memslot() into its only
 caller
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-riscv@lists.infradead.org,
 Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Fold kvm_delete_memslot() into __kvm_set_memory_region() to free up the
"kvm_delete_memslot()" name for use in a future helper.  The delete logic
isn't so complex/long that it truly needs a helper, and it will be
simplified a wee bit further in upcoming commits.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 264c4b16520b..6171ddb3e31c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1653,29 +1653,6 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return r;
 }
 
-static int kvm_delete_memslot(struct kvm *kvm,
-			      const struct kvm_userspace_memory_region *mem,
-			      struct kvm_memory_slot *old, int as_id)
-{
-	struct kvm_memory_slot new;
-
-	if (!old->npages)
-		return -EINVAL;
-
-	if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
-		return -EIO;
-
-	memset(&new, 0, sizeof(new));
-	new.id = old->id;
-	/*
-	 * This is only for debugging purpose; it should never be referenced
-	 * for a removed memslot.
-	 */
-	new.as_id = as_id;
-
-	return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
-}
-
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -1732,8 +1709,23 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		old.id = id;
 	}
 
-	if (!mem->memory_size)
-		return kvm_delete_memslot(kvm, mem, &old, as_id);
+	if (!mem->memory_size) {
+		if (!old.npages)
+			return -EINVAL;
+
+		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old.npages))
+			return -EIO;
+
+		memset(&new, 0, sizeof(new));
+		new.id = id;
+		/*
+		 * This is only for debugging purpose; it should never be
+		 * referenced for a removed memslot.
+		 */
+		new.as_id = as_id;
+
+		return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
+	}
 
 	new.as_id = as_id;
 	new.id = id;
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
