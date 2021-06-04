Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23001C4743C
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 18:18:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B18C6054E
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 18:18:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B18C6054E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CB4B405A6;
	Fri,  4 Jun 2021 14:18:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W1ZTnEsoB5e2; Fri,  4 Jun 2021 14:18:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A824B118;
	Fri,  4 Jun 2021 14:18:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92D624B118
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 14:18:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id il9u5ZCCZNiu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 14:18:40 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6225E405A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 14:18:40 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 om12-20020a17090b3a8cb029016a4ee7d56fso5672633pjb.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jun 2021 11:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=OURJ6TzGdfX+C5aElOfrvLYLXIEwqt+64W7DY078FOs=;
 b=DoohwkvXjAFEjB702S1RR85vweNK+i/nJ9ySyGXZL7k7ooN4RLk2j6KK0JpK4KBp0W
 BUCiT5U1dWIDDUHEwVM7l41dmz4VGvpZC68yGABSBExHHEVCcyStRIbAUKmecH0d3lw0
 WAeJhuBJ4/auMLn3lWtehD0nD9R4kYgREzE0Un51yljJ0Kkkn40uZeXLGZHBrDMZFbku
 B4nAxYWuyr1KCo72Kw/gia2f9dqgfXPC3SsCi2vYLkGHhOf+aK2m8i9J8dOwiGL36dXM
 NUkgGWEj9O1cTJKdJc7xeWZ9KBsejArXk3bHK3N01RJcAJDiym53uZ99msNDGxs+7R97
 YEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=OURJ6TzGdfX+C5aElOfrvLYLXIEwqt+64W7DY078FOs=;
 b=fWoJrZ74evqU+rbeTpmurxghyPTrXgYfDlkLri+3FvgqWFrMdXIsXFV5PBQJ6gicFq
 8h0vYVR1wkSR4P1VK0jlqNkQRO3qockHbskzEKcHrukio/EtyX7F/8Z3MohB9ztJAJ6P
 WzCkdutDd3LIzgdoTwN/VNeIGpcBa47a1dNJv569scIQDOHBmtEuAcmAkhYoe6FiXX9W
 I+a44z413eJrkVZEB0NMioVPVIMbktQz9lysAebM/fiXp2/p3qo7i/MDA2qXk8sVdRzL
 LVT76s6DX4yGDpvDxIC1If3MnFdFtnZ3FKdS27qqq25rOPCzZ8JBbPzgaNCxVchQoMz8
 YkWg==
X-Gm-Message-State: AOAM530I0tSabcj/EaOIse1UtCT25lxRpk0SeR067/mKT2putibNn41m
 Ig28oIg56X/OYUcvQ+jPkZRd2WAgyKM1Exc5EdjqxP5RX3e4+bh3e/V7QLgKKZBPFYIb/1LywRN
 126ZJKuu/bqwl/2SZcSdirNu7MqrcotRZ8lKYQfY336LONHZLepZR8ehY3c6WgUA7hlM506rKFG
 4=
X-Google-Smtp-Source: ABdhPJy9PKCQtJIEuOUg8w1qPNwviZRTxC7lSkcVhvhRw5bRINA/J7AJOwPEGcjkcY9tf+d4n0aJ6rlK3EBbhQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:c68a:: with SMTP id
 n10mr18432159pjt.32.1622830719294; Fri, 04 Jun 2021 11:18:39 -0700 (PDT)
Date: Fri,  4 Jun 2021 11:18:33 -0700
Message-Id: <20210604181833.1769900-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
From: Ricardo Koller <ricarkol@google.com>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: maz@kernel.org, kernel test robot <oliver.sang@intel.com>,
 pbonzini@redhat.com
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

Kernel test robot reports this:

> /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:157: undefined reference to `vm_handle_exception'
> /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:158: undefined reference to `vm_handle_exception'
> collect2: error: ld returned 1 exit status

Fix it by renaming vm_handle_exception to vm_install_vector_handler in
evmcs_test.c.

Fixes: a2bad6a990a4 ("KVM: selftests: Rename vm_handle_exception")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/x86_64/evmcs_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 63096cea26c6..278711723f4b 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -154,8 +154,8 @@ int main(int argc, char *argv[])
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
-	vm_handle_exception(vm, NMI_VECTOR, guest_nmi_handler);
+	vm_install_vector_handler(vm, UD_VECTOR, guest_ud_handler);
+	vm_install_vector_handler(vm, NMI_VECTOR, guest_nmi_handler);
 
 	pr_info("Running L1 which uses EVMCS to run L2\n");
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
