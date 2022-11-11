Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AC2C4321E
	for <kvmarm@archiver.kernel.org>; Fri, 11 Nov 2022 23:20:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E97C4B827;
	Fri, 11 Nov 2022 18:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b7CraojKlIl8; Fri, 11 Nov 2022 18:20:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA1974B811;
	Fri, 11 Nov 2022 18:20:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6EB04B80B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 18:19:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q5F2mZilIGFA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2022 18:19:58 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81CAE4B7FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 18:19:58 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668208797;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=r3Mxkoz9yPxl2ebLuf8V6mN46tSyBQbdzK/qJ9VV9Pc=;
 b=QfGoQIh4mca3HDhHokOJyORl/l2YJZ4ZQgHTFgn3XROh2W7y85pZ/H3INIZgFDGVziDkjy
 2HoloB9tqNz0+jh9eisokKhpuF0fvgoODgC78kE+xRo314fVIafoOsMfpTIoTCZUW7sumB
 3/3YQ8glAWj0ck/SQlX/eOLmkRUW2EU=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH 1/2] KVM: selftests: Allow >1 guest mode in
 access_tracking_perf_test
Date: Fri, 11 Nov 2022 23:19:45 +0000
Message-Id: <20221111231946.944807-2-oliver.upton@linux.dev>
In-Reply-To: <20221111231946.944807-1-oliver.upton@linux.dev>
References: <20221111231946.944807-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, David Matlack <dmatlack@google.com>,
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

As the name implies, for_each_guest_mode() will run the test case for
all supported guest addressing modes. On x86 that doesn't amount to
anything, but arm64 can handle 4K, 16K, and 64K page sizes on supporting
hardware.

Blindly attempting to run access_tracking_perf_test on arm64 stalls on
the second test case, as the 'done' global remains set between test
iterations. Clear it after VM teardown in anticipation of a subsequent
test case.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 76c583a07ea2..4da066479e0a 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -326,6 +326,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	perf_test_join_vcpu_threads(nr_vcpus);
 	perf_test_destroy_vm(vm);
+
+	/* Clear done in anticipation of testing another guest mode */
+	done = false;
 }
 
 static void help(char *name)
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
