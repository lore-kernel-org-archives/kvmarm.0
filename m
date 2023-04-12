Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DD5A93B
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:21 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-54f8e31155bso34173587b3.11
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335321; x=1683927321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FCUsl1ZTxToHK35g7kMPjWEsQGVLI4o3jf0Ta0rdcNU=;
        b=GqYSDW8zsU2k4X6g1gBul0HwBunj4Kc5oYYOBMCg2HxZHahOe7VzzKcmgXGNk6Y76U
         ES2/HgE87JrE3Kj+DU1U7U7ZPB3OeWv2fQqzkndHu4nkh9tNJXo+8XA6i+dP16vd5jH6
         yhhp5Xlpg/1WXEt2TCimkolDf+lDpG00WZd+4Rf7ToYnySMIrDySxVaaJY8qsIpPh+Xc
         F6NoX4FGulsoWmc57IaSRd8SkJ6BOC/oz9X5iq9fyC4RhUl/E/ELD4HBRCVFBKSZpISJ
         5uLvNeMIJ+NcqD5ZUkiMlnPJ9ZP/M8N/9PrABFSOd2H7umgblTHbxO2YbtmUCYZAHR+e
         8T1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335321; x=1683927321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCUsl1ZTxToHK35g7kMPjWEsQGVLI4o3jf0Ta0rdcNU=;
        b=au5uV7mEAiDJODEkrCbff4mZkO8WGBZ2XfTUGKHD0NQjFkcfJ23lyIbiL2pZLTwjCA
         mfxdEYlx0OKzp8BdsbDOIVFp//RKrCDoO9yvndlLMalEbDXXNFjciYISH7yUE3J76lZ0
         rZ+fYIVeYE8c8Y5iZYEabsuavoUBRRaJIANfUnkaUIc81on2rkjShM06UNDYAC24H+4q
         MxFTVPU507u7w8QfftfmN6Uk5kCKTz8gasNzkr+apMep3vF61gLT20FPNC0HawPGdOHj
         9WWlD45xtblBUsNb7fyWdBhA1mxkoGrJSAZjy/6ElonKXj8VgR2XsgRVI9bzGn/Zh7kg
         E1Kw==
X-Gm-Message-State: AAQBX9cBAmIRM3T0iHA3+BbCHQUXBTXbcPp8J3MUZEeyfFfiTDBbVTt3
	/YZ0gRTsUvz0NqL7nWSutysnekY7mw86Rw==
X-Google-Smtp-Source: AKy350YICLmkH8ieQ0EkmaBManzdBLGb7Tvuk3VBxUWumq1jgSxExJBdj4wohiY0LLASz9PuLStOSQz2vaCbWA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:d0f:b0:545:f3ed:d251 with SMTP
 id cn15-20020a05690c0d0f00b00545f3edd251mr3435849ywb.1.1681335321139; Wed, 12
 Apr 2023 14:35:21 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:34:55 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-8-amoorthy@google.com>
Subject: [PATCH v3 07/22] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Implement KVM_CAP_MEMORY_FAULT_INFO for efaults from
kvm_vcpu_write_guest_page()

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 63b4285d858d1..b29a38af543f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3119,8 +3119,11 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      const void *data, int offset, int len)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	int ret = __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 
-	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
+	if (ret == -EFAULT)
+		kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset, len);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
-- 
2.40.0.577.gac1e443424-goog

