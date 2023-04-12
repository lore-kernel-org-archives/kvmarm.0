Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3B0A936
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:21 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id c67-20020a254e46000000b00b88f1fd158fso29213792ybb.17
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335320; x=1683927320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wl6iG0DOT7sovg486sG/qtkYJxnYf7LGgKWwCJBoMuk=;
        b=e6oJMJAXHkG1GgpSvcna+UUqOW6jAVvShZ5EdXAucj6cFMXDvMYAc7fhW6BNAkflBZ
         gm9HtIbwRa7Mr1HBJgRmG0sivVcTDY1okRzGulVzvhKujEyWGbAYRj86jyOiqogTK+HX
         zH8eZ3I8wLGkEHq1RFtbhG54176VhNBW3ppd1Ufcer0GgeLbG6KjSbVn/r4X6GGrQIQD
         A1FhT5EwCxIJqg6EK4njGOlZSUi/o8lzcPsHzbnG0kbKu5XN+8lpYIaw2cgMsvSarZ1I
         K4RUM2haY6aKr8ttVscTRXWARYqk68+ZtfFUhh2enJPcDEUR6B8Or5xBWdMFY2O3GXPG
         6Qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335320; x=1683927320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wl6iG0DOT7sovg486sG/qtkYJxnYf7LGgKWwCJBoMuk=;
        b=h5XqivG0dTkHekJSe35VF2Ot758k2nONXTkreq3LvS+UggZKuCn5H/GG3dHTeTgCrL
         /Bn/2K8ghSdGR1S5WJFqmd701ShsRVdtXHHtnEpqbr6ejd7dxXfK7vgLTHGakt72yxm+
         6JkTggrX8d+QClzhUA05m7vC1YLcODmlrl2R+JEbz362YXqjhikRDyg4AiEm6zLWtQx3
         BH5T4h+JRW/gi1IvFcW0flBBaqsKoVf9fScANrOhnmnQ0Aaf2EnYS+IN1/7EDzdIuyXJ
         Cdoh582FguvYWLHLkieOfZl0YNZc9w5vaGPTjVz/8WUost2HIr5+rbcMuIHZC8o+5tUr
         SOUA==
X-Gm-Message-State: AAQBX9fdbwxMQ2beZeKbROJuPuiFXm9k56hGzKipvLJgCRKZzrZzNxEr
	1ROur7AudiJ8zREsDNaAxcCDEIN2H4G7IQ==
X-Google-Smtp-Source: AKy350ZEHPQmI8hm7Ol6t1Lr3Upb/g72LKo6Tr5VDajGP6irllnJy24C2tTFtoEJLO01pwL6l2QifUQCzDsdNQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:40f:0:b0:b26:884:c35e with SMTP id
 15-20020a25040f000000b00b260884c35emr3043114ybe.4.1681335320281; Wed, 12 Apr
 2023 14:35:20 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:34:54 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-7-amoorthy@google.com>
Subject: [PATCH v3 06/22] KVM: Add docstrings to __kvm_write_guest_page() and __kvm_read_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The order of parameters in these function signature is a little strange,
with "offset" actually applying to "gfn" rather than to "data". Add
short comments to make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f3effc93cbef3..63b4285d858d1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2982,6 +2982,9 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/*
+ * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
+ */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3083,6 +3086,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/*
+ * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
+ */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.40.0.577.gac1e443424-goog

