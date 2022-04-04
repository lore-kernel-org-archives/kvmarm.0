Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59443C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 18:21:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12ED84B23F;
	Mon,  4 Apr 2022 14:21:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8v+7HtxR1GuT; Mon,  4 Apr 2022 14:21:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07BE24B2D1;
	Mon,  4 Apr 2022 14:21:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E29F74B2A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 14:21:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 44CWxTxc0bBz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 14:21:31 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9D1B4B2BF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 14:21:31 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2e644c76556so88451177b3.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 11:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
 b=pD4+208dXd+MuHbyfJYWyePRJiEoaz4qSgQF8/hxMsKV0Z77tFRwC9sUU2JZ74zbJN
 Nlx5Axiw++PDyBNl2HV3VZvug6drX2xzxJfLCeMbpi2IVdhGJTyKXQYDIlOUkOJDaG/U
 iepheGb2k8zTo54D5xJ4g1d40r92qSQZajd6inFsq2CyMqBwM0sBRQghFW0OCXgcjDEC
 SR3U2crly/QNYAVdd/EEvyop1nywh9D3m92nz/i8+U1+woMZ9ZvSk5oMGmsLxa/V1Udx
 TxlfQuZhwK3T9hIAV4TsTqwqva87iJ2lYmlpt23OOpbQJY2u9rHr3uEOleyMUM1aY8I5
 5Fsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
 b=qenGNz6lnOUtaxkWIirl7cQxHECGX8rLvoFhDO6JJmFckLXcLHRBUdNlEAQiL1dxnA
 JvQ1yfYnkA8zU8Sn21FrBkQSwMy/WIM1ZbKdh3nHK8CGVdkaHLxhL3dDMgK+S0Yl0xa3
 zRxm2aJRD/5zvmXEfdQfOq9n6YvILq7QOqfhslDl2jg6To5p6YUhkpXeCwCBIV6kfUWm
 9sl4FkFWRMtnZlqycFVg8MMPeyOY+VZnzmE2tLpAwMgQo+sa4DPC4vTZhMNv/eUMrqoz
 fZISuIJXtIavX7i3jkz5mohv6AEtJmTCi02sKuoFoqYqrGDpFLDu2J8GZCaA9sIS+F1G
 aJ4g==
X-Gm-Message-State: AOAM532+5/n16uj/m49W48EEvVJGZ5HrOMqDzJ0I+UWzhWf84jHgXEPE
 dgOHw4f48peunDsvTWEUUod9kSMp4n57IZxIYB/7p0D6jZhHvmNP9ijKrH0r8C3oukTSToc1Mzk
 6tuLpkNqUxAXQBrqopp3sqqIALv84JJk2nHSTzEI3SB9UMlXN4dwpZGfAjtFnd8jhHisVSg==
X-Google-Smtp-Source: ABdhPJyae0iAnZ5vVEgpMLzFzDK8g3K2mXaBfdK4hiobTFKYWjRk2EN5sWj512nGNHMjsWgcvI/z556o6Kc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:1082:b0:63e:145c:dc55
 with SMTP id
 v2-20020a056902108200b0063e145cdc55mr805811ybu.283.1649096491105; Mon, 04 Apr
 2022 11:21:31 -0700 (PDT)
Date: Mon,  4 Apr 2022 18:21:19 +0000
In-Reply-To: <20220404182119.3561025-1-oupton@google.com>
Message-Id: <20220404182119.3561025-4-oupton@google.com>
Mime-Version: 1.0
References: <20220404182119.3561025-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 3/3] selftests: KVM: Free the GIC FD when cleaning up in
 arch_timer
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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

In order to correctly destroy a VM, all references to the VM must be
freed. The arch_timer selftest creates a VGIC for the guest, which
itself holds a reference to the VM.

Close the GIC FD when cleaning up a VM.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index b08d30bf71c5..3b940a101bc0 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -362,11 +362,12 @@ static void test_init_timer_irq(struct kvm_vm *vm)
 	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
 }
 
+static int gic_fd;
+
 static struct kvm_vm *test_vm_create(void)
 {
 	struct kvm_vm *vm;
 	unsigned int i;
-	int ret;
 	int nr_vcpus = test_args.nr_vcpus;
 
 	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
@@ -383,8 +384,8 @@ static struct kvm_vm *test_vm_create(void)
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
-	if (ret < 0) {
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	if (gic_fd < 0) {
 		print_skip("Failed to create vgic-v3");
 		exit(KSFT_SKIP);
 	}
@@ -395,6 +396,12 @@ static struct kvm_vm *test_vm_create(void)
 	return vm;
 }
 
+static void test_vm_cleanup(struct kvm_vm *vm)
+{
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
 static void test_print_help(char *name)
 {
 	pr_info("Usage: %s [-h] [-n nr_vcpus] [-i iterations] [-p timer_period_ms]\n",
@@ -478,7 +485,7 @@ int main(int argc, char *argv[])
 
 	vm = test_vm_create();
 	test_run(vm);
-	kvm_vm_free(vm);
+	test_vm_cleanup(vm);
 
 	return 0;
 }
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
