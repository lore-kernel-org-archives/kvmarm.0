Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2891786329;
	Tue, 10 Dec 2024 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733858041; cv=none; b=P+qW998C8a8yZn2qhG7Igiyojo41mprdxiMnKY5Fl9pMAI4wOYqUZvku8CIDeaWSPzQhvvS1dW92jA97Lk0SvFyCh6KQXfwl1LlEw/sb73VCTHdWAV4Z5Dh8OeynZOevZ5NWtxG1/VXgEGvi/jCgqS9fmx/qaqVt8CH30+WxltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733858041; c=relaxed/simple;
	bh=EfGv77Fi7tVWJPf4Pn+GHdzo5MOrRQ9k328puPrALvE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IiXmf9QjhX2p+0f0bOC5E9LJti1Evvhn1/gIC6Y+8iW9IHkdpHU8BdQP5Y/7SVnzAZWaczrL7uKIRb0z8mLUQZROwupe1wHUIrFLdBBTgnrD3/XYdpn9HihT49tlIKDZ3+q/Bb4dQwJ8QK0dVPG5bEpMXcgBzdgZ07O0q4j4xEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFoJASA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFoJASA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1CCC4CED6;
	Tue, 10 Dec 2024 19:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733858040;
	bh=EfGv77Fi7tVWJPf4Pn+GHdzo5MOrRQ9k328puPrALvE=;
	h=From:Date:Subject:To:Cc:From;
	b=LFoJASA4HdOUhUgyjJ5o9/BVB7ibjQo/l6eGQZOPIugfmaxw5bhqYX+ps5Ja5oqPV
	 8/yQKsXaKEn+tdEK9pltBIuZmg5VfZrIkhbd2Mj9XSjsH0wgjzxQjtGnfBm/PRO11a
	 BZM8Wi8rEmKvF5ER3Ztgw9937/NwdZaST17bubwwWp35L7uVjnITMFJIdtNvSu+6Cx
	 rXtZLjjjx7UYJkSVS00jh+EYcILsCakuiizufdQhtTbYq9A0jyLufIfCU1bhTbLqbe
	 IHTDqHMLBtzdrhTs7NdpBmFD8BdIJnH4gYwJawE5uS7wRMkYcO5iG9x7iuPDwc9HaO
	 NTdVUpF8leWMw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 10 Dec 2024 19:12:58 +0000
Subject: [PATCH v5] KVM: arm64: Fix confusion in documentation for pKVM SME
 assert
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241210-kvm-arm64-sme-assert-v5-1-995c8dd1025b@kernel.org>
X-B4-Tracking: v=1; b=H4sIALmSWGcC/4XOTQrCMBAF4KtI1kbyM0kTV95DXKTNVIO2laQER
 Xp3UzcqUly+gfe9eZCEMWAi29WDRMwhhaEvQa1XpDm5/og0+JKJYAKYZkDPuaMudhpo6pC6VPo
 jVc5XSnlA4zQp1WvENtxe7P5Q8imkcYj310rm8/UPmDnlVHlrJBjPWGt2Z4w9XjZDPJJZzOJTU
 QuKmBWQlteMSdHCjyLfSiXZgiKLYrS1oABVU//+Am/FLipQFNlY31bc19p8K9M0PQEBi0+UiwE
 AAA==
X-Change-ID: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-9b746
X-Developer-Signature: v=1; a=openpgp-sha256; l=2986; i=broonie@kernel.org;
 h=from:subject:message-id; bh=EfGv77Fi7tVWJPf4Pn+GHdzo5MOrRQ9k328puPrALvE=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhvSISV9z7ibKuu5d5/mmSNW5ze6yuukXJjYXr23KE6McV1hO
 44nuZDRmYWDkYpAVU2RZ+yxjVXq4xNb5j+a/ghnEygQyhYGLUwAmwlnH/j+oVPqBnmtLUuwC5roX/7
 Oj2ZIZ7r1OVkgw/GW9oGFF2Ybpcy0DVTrjmJeZTXmgZyxqyfJy7kbGpsf6c89dWiK7kaNNjYXbMvhm
 s//nerldBosC1+4WeiT01k/wZQ//Mpv3DyTMTn5L4Hnvzdj96NKHq86PjbgtPnpfVJYw+Vzk+eZCcq
 mIXGyFxLnAYhX1iOjLHV3uWdxt5T4RYd9NmL2XzHQxU7PlO7ns74knl2XWPrHzdzpsfnnPnL91L+JW
 Kn2wYDdTyLn7QKv1z6TUQJndaRltubvnefRXqK33Ozb5SVk5k69GRZvSQZYvh9WfXr8j6HX4YMa66N
 8KMZfrjTpsFucz/P0d8T7DINEeAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As raised in the review comments for the original patch the assert and
comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
disabled in protected mode") are bogus. The comments says that we check
that we do not have SME enabled for a pKVM guest but the assert actually
checks to see if the host has anything set in SVCR which is unrelated to
the guest features or state, regardless of if those guests are protected
or not. This check is also made in the hypervisor, it will refuse to run
a guest if the check fails, so it appears that the assert here is
intended to improve diagnostics.

Update the comment to reflect the check in the code, and to clarify that
we do actually enforce this in the hypervisor. While we're here also
update to use a WARN_ON_ONCE() to avoid log spam if this triggers.

Fixes: afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are disabled in protected mode")
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
This has been sent with v6.10 with only positive review comments after
the first revision, if there is some issue with the change please share
it.
---
Changes in v5:
- Rebase onto v6.13-rc1.
- Link to v4: https://lore.kernel.org/r/20240930-kvm-arm64-sme-assert-v4-1-3c9df71db688@kernel.org

Changes in v4:
- Rebase onto v6.12-rc1
- Link to v3: https://lore.kernel.org/r/20240730-kvm-arm64-sme-assert-v3-1-8699454e5cb8@kernel.org

Changes in v3:
- Rebase onto v6.11-rc1.
- Link to v2: https://lore.kernel.org/r/20240605-kvm-arm64-sme-assert-v2-1-54391b0032f4@kernel.org

Changes in v2:
- Commit message tweaks.
- Change the assert to WARN_ON_ONCE().
- Link to v1: https://lore.kernel.org/r/20240604-kvm-arm64-sme-assert-v1-1-5d98348d00f8@kernel.org
---
 arch/arm64/kvm/fpsimd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ea5484ce1f3ba3121b6938bda15f7a8057d49051..5fb9b3fc61ec7a53641d7a34a5d39a334a8f5f5a 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -93,11 +93,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * If normal guests gain SME support, maintain this behavior for pKVM
-	 * guests, which don't support SME.
+	 * The pKVM hypervisor does not yet understand how to save or
+	 * restore SME state for the host so double check that if we
+	 * are running with pKVM we have disabled SME.  The hypervisor
+	 * enforces this when the guest is run, this check is for
+	 * clearer diagnostics.
 	 */
-	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
-		read_sysreg_s(SYS_SVCR));
+	WARN_ON_ONCE(is_protected_kvm_enabled() && system_supports_sme() &&
+		     read_sysreg_s(SYS_SVCR));
 }
 
 /*

---
base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
change-id: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

