Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93421D536
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:45:35 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5834d9ec5f7so21142357b3.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 09:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698734; x=1692290734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xS0acJp+aIDXIQPo5QGK2XMol5RfSj1wMM22zpXYALg=;
        b=EmteLCMQlNbrceRaps12nferypQUXRntTEFrR9lZz6K827vbH7l9xInXAD8nRBwgvg
         Nva18ll74bKF8/JyGdMnCPK6Z5eslobhaqxhrZQXBercFtxS1nvRRu6VslmWJ9U5xlzC
         J82k7CDSz52ze/FeoVydqdPa0/dVg1iSLdO9q1FCCO8sqCF5WHiCRTu4+p/e9SlcTfbA
         Rc/JesNjjDk9jSuEVjFWNQFfHkMlTK2oJmGd9ptCIhR5AoSRUHhNWPA264e7oLmqdDgL
         +2Y7q2wR2u7v/LnQXbl2PTC6Z0bqSTlqmvRIh6DIgrGRYcHCTTCxgzeZ5vJgJiP3rQ9T
         j/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698734; x=1692290734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xS0acJp+aIDXIQPo5QGK2XMol5RfSj1wMM22zpXYALg=;
        b=d0smglocmVgvLTcp7WC15Guq8vDAZ3u3Y3izFveCaWBn68qFJuyR9XQPf75ICRmkp1
         y3g0QxDa1436amtVFG9f0PnWAs40Yd9XSmHv49BNfEW4egBKNnsSLrIgcxjIcrUfMcMX
         mqbsUJGwWRuIDjPdxY/yxvegDDyxO1ShvZ5X5GLst6th21Fz6JCvpQWsCyljiBfexzKZ
         0Rw18ARlkPvN1Rwlvnx7mH/xjdDAL5EjCY5ER8HO8jyqB1fb9d1fKSrsQn6hUJaZfiEL
         2KhXrqfFOX7HwiqQd6R42hEtgTwhMnZgkH4V+HSRez0QN6oKv06WpEnnWXt8O6NlRsbL
         eItw==
X-Gm-Message-State: ABy/qLbNxCbi5fkAgT+Ckk90yo97FxrYJIT7cPzAQpNAZE4shEH2Y0LA
	kn7ZTy+oqNbMJx40yQgwB9ycS+qpRLsGDVq0dw==
X-Google-Smtp-Source: APBJJlEQmDSoHkGi9JQIAr4wuITHz7fAluVasMRt8k18NTKlsRsIsnD0bdJ4EqDubIUM0oQB7DLI1CT99QjPdZDFHQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:fe09:0:b0:57a:6019:62aa with SMTP
 id j9-20020a81fe09000000b0057a601962aamr237002ywn.5.1689698734735; Tue, 18
 Jul 2023 09:45:34 -0700 (PDT)
Date: Tue, 18 Jul 2023 16:45:20 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-5-jingzhangos@google.com>
Subject: [PATCH v6 4/6] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

All valid fields in ID_AA64PFR0_EL1 are writable from usrespace
with this change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f33aec83f1b4..12b81ab27dbe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2042,7 +2042,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.255.g8b1d071c50-goog

