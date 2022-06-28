Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07A3C43334
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jun 2022 18:02:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 850C94B228;
	Tue, 28 Jun 2022 14:02:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5TZpA2PZ3g7I; Tue, 28 Jun 2022 14:02:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5516F4B48A;
	Tue, 28 Jun 2022 14:02:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68E974B1AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 14:02:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KJlkQfgnYrsr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2022 14:02:49 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 568A84B481
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 14:02:49 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D897D61A44;
 Tue, 28 Jun 2022 18:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5ACC3411D;
 Tue, 28 Jun 2022 18:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656439368;
 bh=wRLfI31WrZ59IkEj+z6Z5ZZev9x2pVNmX2cjKkCxs74=;
 h=From:To:Cc:Subject:Date:From;
 b=mUAs0OXyMYCIQY+Msh4eCdQKG4n6S+0XnOPFWmVF8o7i/P3HdnPp3ztOq460HhKbh
 z+4AU3aTT8sSp/+SugH8e9oKVSUODPhdljVc1jzoKwR84n3zv0SFzUwv3Z40dyWfCQ
 CQ43H3wyelPh8uy27ir9wYUVZURadbwrtd3MbdLzlUyEkeUfmW1QyjIjAUAcshJEUh
 ov7upuSRIxL4woC018to8h/6XRZ97YV+FHTv9uGFkbb/c/CyC1mvHxaKErBwrNczxh
 jjD4Yu5AYnPNc3yUVZWizCQi+aAxNIqcufobbiX0VBO8LFk6WskKnVoPjiOsrqRcQi
 A5xzoIWS/aMJA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH MANUALSEL 5.4] selftests: KVM: Handle compiler optimizations
 in ucall
Date: Tue, 28 Jun 2022 14:02:44 -0400
Message-Id: <20220628180244.621315-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Andrew Jones <drjones@redhat.com>,
 kvm@vger.kernel.org, maz@kernel.org, llvm@lists.linux.dev,
 ndesaulniers@google.com, nathan@kernel.org, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: Raghavendra Rao Ananta <rananta@google.com>

[ Upstream commit 9e2f6498efbbc880d7caa7935839e682b64fe5a6 ]

The selftests, when built with newer versions of clang, is found
to have over optimized guests' ucall() function, and eliminating
the stores for uc.cmd (perhaps due to no immediate readers). This
resulted in the userspace side always reading a value of '0', and
causing multiple test failures.

As a result, prevent the compiler from optimizing the stores in
ucall() with WRITE_ONCE().

Suggested-by: Ricardo Koller <ricarkol@google.com>
Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Message-Id: <20220615185706.1099208-1-rananta@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/aarch64/ucall.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 6cd91970fbad..3b2a426070c4 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -73,20 +73,19 @@ void ucall_uninit(struct kvm_vm *vm)
 
 void ucall(uint64_t cmd, int nargs, ...)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
+	struct ucall uc = {};
 	va_list va;
 	int i;
 
+	WRITE_ONCE(uc.cmd, cmd);
 	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
 
 	va_start(va, nargs);
 	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
+		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
 	va_end(va);
 
-	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
+	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
 }
 
 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
