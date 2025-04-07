Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB1B1FF7DE
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744039686; cv=none; b=K2nqhrAuynVKqF60mztxb5KsylSQ7v8N4S/kt2GHuBcpnBXaV2JbSdH9pbkBdgnzRMYQxWGPCDbGrzet9hFfrMiRawNDOzrLSxVpfTMflKLdfM81u1ViKK7QWI2kSew2q7QBjpHWWvApyjA9yIHr4K18gLWmlaAxYdNnMSXzoas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744039686; c=relaxed/simple;
	bh=n7AuZH2NV6e9SfuaGYDx0Zea6O4ejBD51YJlqGzjX5E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r+d+E3XRdcoTJvFO+YlGlLQQX7lXl6TxbjbACdOyALYFbfAkswQpv6uoN7SJg1W+m+PCNrYq2f9WRiZzqk6dZOW7SdLV9xeD/6n8Cx1Qg0+qgpKm/Mm5z8TCahckjb9md53PF8L+W1B0uPjJJ90jZ+oT1eszIKpaMxbG90ZUfGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LIs5oU82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LIs5oU82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14125C4CEDD;
	Mon,  7 Apr 2025 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744039685;
	bh=n7AuZH2NV6e9SfuaGYDx0Zea6O4ejBD51YJlqGzjX5E=;
	h=From:To:Cc:Subject:Date:From;
	b=LIs5oU82hOs58k3V/F0QMcM04ENZ6yVikRFy1jxLY1jTdOufd3aXIKFo0MgeKqlpo
	 ZRK6TMU2q+YnYppM0gLXQwDTZeinuRsnXL5oq6/jf32hYk7QrA1f1XGNZRAJ7yEFeY
	 /8GqXLXOAs01PE5O6x3WY5rBI4eiBMdDEPyr1taI4Qceyjgx0u57xqQaNWsnqRCTxb
	 OT7ROSjAHhkuH7/yWj4oAm2e1hsfXz1U3k3RSudbHlw+ZyIKkRV2Wid7cfQLQEVEDn
	 7ijCDZjmqsJ0PDau9zDwrTsJ6NyT7vjH1cDuiGC1SoYDGzgGSJePAHEsSCzxVczYmK
	 PEKYpHOf3NizA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Quentin Perret <qperret@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm64: Use acquire/release to communicate FF-A version negotiation
Date: Mon,  7 Apr 2025 16:27:55 +0100
Message-Id: <20250407152755.1041-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pKVM FF-A proxy rejects FF-A requests other than FFA_VERSION until
version negotiation is complete, which is signalled by setting the
global 'has_version_negotiated' variable.

To avoid excessive locking, this variable is checked directly from
kvm_host_ffa_handler() in response to an FF-A call, but this can race
against another CPU performing the negotiation and potentially lead to
reading a torn value (incredibly unlikely for a 'bool') or problematic
re-ordering of the accesses to 'has_version_negotiated' and
'hyp_ffa_version' whereby a stale version number could be read by
__do_ffa_mem_xfer().

Use acquire/release primitives when writing 'has_version_negotiated'
with the version lock held and when reading without the lock held.

Cc: Sebastian Ene <sebastianene@google.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Fixes: c9c012625e12 ("KVM: arm64: Trap FFA_VERSION host call in pKVM")
Signed-off-by: Will Deacon <will@kernel.org>
---

Found by code inspection rather than any real issue in practice.

 arch/arm64/kvm/hyp/nvhe/ffa.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e433dfab882a..3369dd0c4009 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -730,10 +730,10 @@ static void do_ffa_version(struct arm_smccc_res *res,
 		hyp_ffa_version = ffa_req_version;
 	}
 
-	if (hyp_ffa_post_init())
+	if (hyp_ffa_post_init()) {
 		res->a0 = FFA_RET_NOT_SUPPORTED;
-	else {
-		has_version_negotiated = true;
+	} else {
+		smp_store_release(&has_version_negotiated, true);
 		res->a0 = hyp_ffa_version;
 	}
 unlock:
@@ -809,7 +809,8 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	if (!is_ffa_call(func_id))
 		return false;
 
-	if (!has_version_negotiated && func_id != FFA_VERSION) {
+	if (func_id != FFA_VERSION &&
+	    !smp_load_acquire(&has_version_negotiated)) {
 		ffa_to_smccc_error(&res, FFA_RET_INVALID_PARAMETERS);
 		goto out_handled;
 	}
-- 
2.49.0.504.g3bcea36a83-goog

