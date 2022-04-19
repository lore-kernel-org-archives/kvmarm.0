Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D765C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 18:11:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D97F44B216;
	Tue, 19 Apr 2022 14:11:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YxoWtv9XfU0M; Tue, 19 Apr 2022 14:11:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF13E4B1FD;
	Tue, 19 Apr 2022 14:11:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 336D94B1E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:11:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YZysFDBoBWij for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 14:11:36 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04C484B18A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:11:35 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 11A8E60C51;
 Tue, 19 Apr 2022 18:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E1DC385AD;
 Tue, 19 Apr 2022 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650391894;
 bh=zqYE2dBiFpRl4OeuEjvjF+2WlsvVq3M+PLNfL0rUOW0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=TorB5OBPUgcOVi3jj4o8HgIaGBnh39cNXDnTNge5Vkj1g9qa8dsZzV9trrSkamsrE
 rEIrEgESP7WHupC35SfUl1qBCa/94UD9Wslpt94tui8oNVPb0SAaTNHN4jsdjVtDRE
 d124rg/beZWrQZofKRrh/SDubg4anNOvbSSuE/xJcd+bVt+QumED2X9OKPFRf2Da7H
 BrQNHo8UxVitBYtbiszxo3gmntzkEphTpklE5w0YlC/4ZF6BlZkDzKargCd8aOOOWm
 iOJ60cwvXq0P8O8Mym3CF9h2s55Xpz444zABmdvxAPB6DCfiX1sOI9Z0ep0jlDiAnE
 saGCZ7CWXiM4Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 09/34] selftests: KVM: Free the GIC FD when
 cleaning up in arch_timer
Date: Tue, 19 Apr 2022 14:10:36 -0400
Message-Id: <20220419181104.484667-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kselftest@vger.kernel.org,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
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

From: Oliver Upton <oupton@google.com>

[ Upstream commit 21db83846683d3987666505a3ec38f367708199a ]

In order to correctly destroy a VM, all references to the VM must be
freed. The arch_timer selftest creates a VGIC for the guest, which
itself holds a reference to the VM.

Close the GIC FD when cleaning up a VM.

Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220406235615.1447180-4-oupton@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
