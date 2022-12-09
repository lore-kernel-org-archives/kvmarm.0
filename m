Received: from out-75.mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EBC7E5
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 01:59:24 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Peter Gonda <pgonda@google.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] KVM: selftests: Avoid infinite loop if ucall_alloc() fails
Date: Fri,  9 Dec 2022 01:53:06 +0000
Message-ID: <20221209015307.1781352-8-oliver.upton@linux.dev>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221209015306.CucwFWsq5xfyOElniW66RoTKddOzvxXRdE6LhmPnVdQ@z>

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

