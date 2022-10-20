Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7C8C43217
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:43:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1946B4B916;
	Thu, 20 Oct 2022 01:43:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K1SVji2tMOrJ; Thu, 20 Oct 2022 01:43:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF73C4B92D;
	Thu, 20 Oct 2022 01:43:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 017C94B91C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dNvqjC+jV0zR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:43:31 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F17EE4B90D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:30 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 p5-20020a25bd45000000b006beafa0d110so18193413ybm.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=VB1jPPUEjrX48I4GSjyuQn7W+BcJBZ1KSoLIzPYJb4c=;
 b=ZBvzHWXEg5+0LfNox4fGQHvZCGExRABrADPgKQ0uJAT3GS2bcwXVcPUHDokKK0oD8e
 rBfcnafeNZELKVFMbhHowJDe7++TZWn9+acFfzRzNTYOvkyUYvbGXQueYUS7+V7xHqjc
 pASv4I9AmarKpMizQUqSSMGE+PrD1DktzRC0sEF4OWpoRrGdgBAo3uvOROA8AlwjqjE0
 bxaJb3Vla6LFM5hsDsBAYwGA5biTNljRB4SUgd2nJUMnSSiio4kL7inDOrpqnyBxmh5O
 0tPO6YMpMe3QmY5eX0aMQCl+cXZNO+TWL4qwf6QJ270u6kIT3RQormWGvj9KrJgD9jYd
 Rfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=VB1jPPUEjrX48I4GSjyuQn7W+BcJBZ1KSoLIzPYJb4c=;
 b=vDVjprzzviD3+XmO2vxk17DnfpLPSEN2ORrpVQagDIkLERAlVRsryTx8aEIof2DeBs
 yzD84ab5EY9FPj5x7cwwkFjBOLe2yPakic2ceMbcfAoowbyFFtWsHaU+pzd2yNJBkko7
 LkzugFNqCxnEesGbCDNjuQ0GxumYvMN7L8P2yi7JAVvGZJKtJ3fcjJYyGUwusPim1hcC
 opUvvT+/waNgD9+rBK9k1MyEfjMmfpKaR5GXqY8/tP1EK0sBF/XQa6KsMP0j0EYIEQtt
 b8ajNZ6v9SyJdoEoVc7q1rC+kmU2QBj74WgVFSUqJaXs9LzcRl6/tdVWflkK7ThTbxJo
 dOvg==
X-Gm-Message-State: ACrzQf1oJhSJU1OaJf2bVjAU/yOL3MlBICcMf8naP3o9scj4vZMq6zEJ
 HvydlbCbFdRrPofhsdYecSYq1YhBz8g=
X-Google-Smtp-Source: AMsMyM4QU19wSO5ZMBNGHX43y4ZfNhPpdLhf7KWE0/041MMlzko8xOXHq23D3L2kQwLsCPfLQLR/LWK3xuY=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:a4ea:0:b0:6c0:2f38:431d with SMTP id
 g97-20020a25a4ea000000b006c02f38431dmr10273171ybi.276.1666244610630; Wed, 19
 Oct 2022 22:43:30 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:41:59 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-7-reijiw@google.com>
Subject: [PATCH v2 6/9] KVM: arm64: selftests: Change debug_version() to take
 ID_AA64DFR0_EL1
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Change debug_version() to take the ID_AA64DFR0_EL1 value instead of
vcpu as an argument, and change its callsite to read ID_AA64DFR0_EL1
(and pass it to debug_version()).
Subsequent patches will reuse the register value in the callsite.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 040e4d7f8755..72ec9bb16682 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -337,11 +337,8 @@ static void guest_code_ss(int test_cnt)
 	GUEST_DONE();
 }
 
-static int debug_version(struct kvm_vcpu *vcpu)
+static int debug_version(uint64_t id_aa64dfr0)
 {
-	uint64_t id_aa64dfr0;
-
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
 }
 
@@ -466,9 +463,11 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	int opt;
 	int ss_iteration = 10000;
+	uint64_t aa64dfr0;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
 		       "Armv8 debug architecture not supported.");
 	kvm_vm_free(vm);
 
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
