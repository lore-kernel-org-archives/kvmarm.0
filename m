Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24E9C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 633806115B
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 633806115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE234B1AA;
	Wed,  3 Nov 2021 02:28:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7GpwkxCitHHc; Wed,  3 Nov 2021 02:28:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C90834B1BC;
	Wed,  3 Nov 2021 02:28:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DFA04B0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZL3mH0cMSINe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:41 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCE3D4B162
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:39 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 n22-20020a6563d6000000b0029261ffde9bso981368pgv.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ugTp3pj0zYJHc3RiE+6osaY4VwnihaeWletwlGqcNzU=;
 b=R3uU4a/mva3/sHp7C4ovXEbTpY7IYU6h/nzYCMUJp+ghGJCGhatLHR1IKqI10LJdsq
 metLBMGZYNoR04MfVYDKXlUey3kGDSwo0EjdTYks9XJKbommPpi8BgxoxZsCJFWVn+FH
 suf/FuoQtsLvDHUgsMRQSKYW6N1T76XjKMIT5Nofnr4EqXt5x9/XND18vMR8omRCh86s
 lmj2LyQP8xjLWfKoCds4tFt8KtCS6W5Xvnfb9Ast3913Gm3/3W7g9o2hEZ70yRhH9PIb
 d85b0EGtsmqV1k28mIcfQVqisSh3ApCaLI0unMYmbjVQtkJP9vVP6MdUcTHer2id1sPz
 46RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ugTp3pj0zYJHc3RiE+6osaY4VwnihaeWletwlGqcNzU=;
 b=3lz+9eNu5Lo+DSHHRzQxhrbaLm5t2txfD/jgW+siI6usxRK5lxdEOnxfo1kZ539EBQ
 sIaWgUslPVjVYoSua7nbnIieoWCIoU15gwpA9pfznDFpwert2MR9GV6s4KwXuUBSUXkZ
 Wlw1UQFnIJgffKMUD8MtJjfZQLnbIakaghBBd5+6wszA1gojfL8ZejLysGcLfLC7feuA
 i7bk7EXmOcASzRuCGjuQet4PL8WJUYds2AktWlS/VnQHnmDnfgkSisf1AfhepEeaWASa
 zI0SmRZwATTvKHhD29AqPTvQXe7gMbZj10rt3bdHo/h2bKcGvWzaFm6yBYvdcpbj/T1J
 Fjxg==
X-Gm-Message-State: AOAM533y1s4ExCOvdIddSjf23UECmfOTcrbBJHaH35ALuKNqUYP81ax9
 RNAJwdlYUVhi62TkIsNmYfwIkhxmG44=
X-Google-Smtp-Source: ABdhPJxwjlhoTqnj4E9V//tM6ijYmQGHJIKCJ/YZeqcBnm3mpZgLE3LmRBu6b58jjITFPpnfBiYA1pEZdDg=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:353:: with SMTP id
 19mr12674037pjf.83.1635920918981; Tue, 02 Nov 2021 23:28:38 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:19 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-28-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 27/28] KVM: arm64: Activate trapping of disabled CPU
 features for the guest
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

Call kvm_vcpu_id_regs_trap_activate() at the first KVM_RUN
to activate trapping of disabled CPU features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 691cb6ee0f5c..41f785fdc2e6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -743,6 +743,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
 int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
+void kvm_vcpu_id_regs_trap_activate(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index afc49d2faa9a..330a35217987 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -583,6 +583,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		return -EPERM;
 	}
 
+	kvm_vcpu_id_regs_trap_activate(vcpu);
+
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
