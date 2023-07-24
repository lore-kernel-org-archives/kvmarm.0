Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1E06AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:47 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3142665f122so2598397f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202325; x=1690807125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fw/zi6S9TpUpn6bP4HvBi5LEnCrD1TR71KwU6RzN2og=;
        b=jAh0BxryQQOWxhwKClvk/Doa3ABHFbwPDCZWcNT4ifn2PQHbnJUPvJ+BheM61XR4BD
         p/A7Oh2GXcsr4opoZUPfCl5ubznUIpDVez30EgEAAEm9z4CvDDCEMHI86qmvAj5ErCsM
         RbiOp+4qLv1GkTlcNVYCERb44c3GdL/DwzPTDfaEYBZb/HKbpDImbDm+NH0grBneqHY8
         cxAlKK89NSZ/RWETgLnHTVrLan15x8fIRiVzmk0yHxi50cebcXkzGJxQgrJehYaEWyDy
         3+qaOhj7VQQNKDN+y6wpg8YvdqnwnZK0pTKIqH8FnVXbu/19U2RbjJShKS8TRmHNOfwi
         XepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202325; x=1690807125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fw/zi6S9TpUpn6bP4HvBi5LEnCrD1TR71KwU6RzN2og=;
        b=iuea3O2hT7GmurptaGTzgxzfFdpAIdWCl//zMaFswxTfNJqKxuAHUGz8EWoiKQFcuJ
         YzF2u1SkHleDL/3Y5CQZBKnqOldGzniyFhMkmdoMZHNYGmoSB7gincvvTW6cs046zDxZ
         QoUimZ0vHXlHJQua03xIHOJONe2MOIErFJrbh4FMeJ7sdeWO8NQo3dAzxDkSW3OcS0dK
         nYUR/IIBKge00N3zAQulIh06kaQ488aycc5rG1hsimbZiaRCGiyE+cT9zBO3ZebNrvsa
         jRNY8DWrFAXw6mnQe9W8fIwblO+B2imSpMhxWOxyQ78udsqWYGMHzcZL2SLyiFu9/XjJ
         WISA==
X-Gm-Message-State: ABy/qLajS3F8eH4EP3RczqFua0mmBW6DcanQ3r6CPHKrU+NbKdHtnwWH
	4VUV5J6HZSOCam6pBObnkuiq6G/1t5kdcRRvRk+LtrBzJ0yrmWPLTlBAd2At+5T/oVuxRv+Rzo5
	Hih0h3a4punUAo8WIl762UFL2abme1C93f/vmHS4fqJnv1G8ipLRBe7U7Iok=
X-Google-Smtp-Source: APBJJlGFKbcBIJLT2EwalLGUhE46kQUypxbiPWkfDYCF19OeP0VuyV3lxQ8R4wBXh712PjBTo8pPTR4TQA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e503:0:b0:314:4db:e0b7 with SMTP id
 j3-20020adfe503000000b0031404dbe0b7mr58317wrm.4.1690202325500; Mon, 24 Jul
 2023 05:38:45 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:27 +0100
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-7-tabba@google.com>
Subject: [PATCH v3 5/7] KVM: arm64: Use the appropriate feature trap register
 when activating traps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Instead of writing directly to cptr_el2, use the helper that
selects which feature trap register to write to based on the KVM
mode.

Fixes: 75c76ab5a641 ("KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0a6271052def..e89a23153e85 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -63,7 +63,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-	write_sysreg(val, cptr_el2);
+	kvm_write_cptr_el2(val);
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-- 
2.41.0.487.g6d72f3e995-goog

