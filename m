Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1600DC6FA8B
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 01:06:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C48834BD67;
	Fri, 16 Sep 2022 21:06:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ebbbh2UmC0oy; Fri, 16 Sep 2022 21:06:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B2EE4BD19;
	Fri, 16 Sep 2022 21:06:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85BD74BD33
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MqH5i7h1IYLG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 21:06:16 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F6614BD43
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:16 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 i201-20020a253bd2000000b006b28b887dbaso908190yba.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 18:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=P62ArTPc7+3A2J+iBFhu2NmzpTO392tFyQSa9B00I7o=;
 b=gQs+pUloXH7vOfPonPzkbtOTB0jf3YMXQ5CPD6RCnsFqnwdAK0hZcwcz8NJSzxtoZS
 5JVD0qCmjbGE7+CyAGZ9v8Ff55/Sw+zC+IJFh5lewEXB2sICf2UY/EfgeBSfz24rEOSm
 3MC07gAnmDTxVNZUCfnPvjzK9B5J9r5vXVm5zFzp7gzIe5qWTqWFrl7XvlZiZMyDTd4q
 uUGKlEycSRb+rJl819tg6lf2P3gKsYED9B1ycNpzItfGRbUW7q+0xEKANLXW7Ak+gzo9
 NMYMTrvb8Dm3TRe+3D1y+Xfc8ychf4aUlPWoh+35PnOKy5T0EyUrA9mP3yaA1VCTFh88
 mkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=P62ArTPc7+3A2J+iBFhu2NmzpTO392tFyQSa9B00I7o=;
 b=DR1+qhXjPD7NJnndsgaSnTqUbi/VwSZ8HbguOJc69ksuTptXfSnD5rH5J1KxlN3q14
 oAvfWwCYa/v4cwf2gjUp4tqr4ATvDuKoi0WW755LuQ3nBsSeytDxD1Qv5GtqD3DRhnT3
 /PN8fKTcDQ6Qu4ayKU5Iel19j51HofNVA4gR4nMihOvIsnU0bDB4oy19+CgtSW3Pv30x
 Av6sCb2ENW6VQ8oCHi4arpWtWgtN1R17wyfO5jp76/TtEW2BfkD6vmGAvz6j56z4co7J
 UpSFx6nHoXQpHK0o3fIf4Ft4Dax9lpkDzQHVISeQpLfb9y6ZcYCubbAGBPn9+7sArwN9
 R8vw==
X-Gm-Message-State: ACrzQf3lhDOlUiM2O7kSJ7Vk038bz7rWG6qofc5KROc+THJHvV5+J2yZ
 RQwX+ixFMqEdm9tpTcrIPIjoEYfaRzQ=
X-Google-Smtp-Source: AMsMyM5VgruCN2bvpzdWSE6f5BHhOI/uXg4nOMM6u0Ll+ZOiBxNJUH3SUKeI4ewiHSJGbviPr/4BGR3kHWY=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:bc7:0:b0:6af:d9a3:d721 with SMTP id
 190-20020a250bc7000000b006afd9a3d721mr6478800ybl.47.1663376776016; Fri, 16
 Sep 2022 18:06:16 -0700 (PDT)
Date: Fri, 16 Sep 2022 18:05:59 -0700
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-4-reijiw@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: selftests: Refactor debug-exceptions to
 make it amenable to new test cases
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

Split up the current test into a helper, but leave the debug version
checking in main(), to make it convenient to add a new debug exception
test case in a subsequent patch.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c   | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2ee35cf9801e..e6e83b895fd5 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -246,7 +246,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 	return id_aa64dfr0 & 0xf;
 }
 
-int main(int argc, char *argv[])
+static void test_guest_debug_exceptions(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -259,9 +259,6 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	__TEST_REQUIRE(debug_version(vcpu) >= 6,
-		       "Armv8 debug architecture not supported.");
-
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
@@ -294,5 +291,18 @@ int main(int argc, char *argv[])
 
 done:
 	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+		       "Armv8 debug architecture not supported.");
+	kvm_vm_free(vm);
+	test_guest_debug_exceptions();
+
 	return 0;
 }
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
