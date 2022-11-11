Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11981B54A
	for <kvmarm@lists.linux.dev>; Fri, 11 Nov 2022 23:19:59 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
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
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: selftests: Allow >1 guest mode in access_tracking_perf_test
Date: Fri, 11 Nov 2022 23:19:45 +0000
Message-ID: <20221111231946.944807-2-oliver.upton@linux.dev>
In-Reply-To: <20221111231946.944807-1-oliver.upton@linux.dev>
References: <20221111231946.944807-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221111231945.IC1z4ad495VQ-0YPG0blzOFvfcz73n7P5ocjz9MExvQ@z>

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

