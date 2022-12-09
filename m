Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36B1C4167B
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 01:53:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA664B9C0;
	Thu,  8 Dec 2022 20:53:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A63P1Pd8C+pk; Thu,  8 Dec 2022 20:53:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2B94B9C8;
	Thu,  8 Dec 2022 20:53:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0FD4BA25
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:53:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bAIxGuTroGIr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 20:53:48 -0500 (EST)
Received: from out-243.mta0.migadu.com (out-243.mta0.migadu.com
 [91.218.175.243])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC8FF4BA26
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:53:47 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Peter Gonda <pgonda@google.com>,
 Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2 7/7] KVM: selftests: Avoid infinite loop if ucall_alloc()
 fails
Date: Fri,  9 Dec 2022 01:53:06 +0000
Message-Id: <20221209015307.1781352-8-oliver.upton@linux.dev>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
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

Guest assertions depend on successfully allocating a ucall structure. As
such, the use of guest assertions when ucall_alloc() fails simply leads
to an infinite loop in guest code.

Use GUEST_UCALL_NONE() to indicate failure instead. Though not
technically necessary, use a goto to have a single callsite and an
associated comment about why assertions don't work here. It isn't
perfect, at least the poor developer gets some signal out of the
guest...

Fixes: 426729b2cf2e ("KVM: selftests: Add ucall pool based implementation")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 0cc0971ce60e..e8370da3de24 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -41,7 +41,8 @@ static struct ucall *ucall_alloc(void)
 	struct ucall *uc;
 	int i;
 
-	GUEST_ASSERT(ucall_pool);
+	if (!ucall_pool)
+		goto out;
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (!test_and_set_bit(i, ucall_pool->in_use)) {
@@ -51,7 +52,14 @@ static struct ucall *ucall_alloc(void)
 		}
 	}
 
-	GUEST_ASSERT(0);
+out:
+	/*
+	 * If the guest cannot grab a ucall structure from the pool then the
+	 * only option to get out to userspace is a bare ucall. This is probably
+	 * a good time to mention that guest assertions depend on ucalls with
+	 * arguments too.
+	 */
+	GUEST_UCALL_NONE();
 	return NULL;
 }
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
