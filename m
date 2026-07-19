Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144B33803DA;
	Sun, 19 Jul 2026 23:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502629; cv=none; b=X+OuTOOSU8OGEaTl7IaLSh0prMsiYN60oM3rcyOKeYj/0kW6GXi5H6poYtCXhRU5xyfqbd6r2GJ6J+R8gFIt+Q3wKVULe2zskuaIopDg22sHQZnhHv/3OD2N2Xb8Iq2gbqpAhov30YbNzZiqr2VFKA9nWthZBujUugx+mK2sbYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502629; c=relaxed/simple;
	bh=LQ82hLeixhPo51PUrjrzXUzX6f0ySuwDN5dUrbNo3NM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qph7JRHSzZXwAAmHqgLLX/Xmy1zG7TVTN7rdp04fzoM7ukmMlwpx9gPy9DC1okm4JSyt9hc1jr9m3YM0mV9xRKs7cDaHMnHlx+zHtT/nJ6AWkvxmjaRLq0CKFW194IzY3yESOPXlxZFLLqtByTHCyMzlGn/j93zBagDdulmTpfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lo+44WdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lo+44WdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F111F00A3E;
	Sun, 19 Jul 2026 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502627;
	bh=kHHDIsQbOpwZi830OTqOQ3hDBLn1pO6beb+B2zMHong=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lo+44WdHWR5FaVr2MBCA2Oi12puRxO33IEUwiiwkesDFzeJfFzlmbpsGDUGo9pfO7
	 alscwjcwFtUfcrjoOeTXvNfrIeKqYMZNofGvqAqzXVnH+5ygn9gfeMqrcSENMmyPKJ
	 BqalFy7DICoPecWYv4c7YbA1r3fjK+fTqaCszo4SNy0ZIzr4xj28mRcskaqPTUocS5
	 h25SS9MFv+Hrr6v5/NRTeNIYBxiyJ97Yg6RCaNuqKE1KNsCFqtY9viO4HRTCeSTUYK
	 YAQGRm1pvqmL3ZM8ZbEol+nyjQEJVm4GaKr3HfjXaLwXhuA4jYGA0wJ3z4xJHYhsJX
	 GyLJHjDwh85DA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:34 +0100
Subject: [PATCH v13 07/32] KVM: arm64: Remove bitrotted comment on
 handle_sve()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-7-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=842; i=broonie@kernel.org;
 h=from:subject:message-id; bh=LQ82hLeixhPo51PUrjrzXUzX6f0ySuwDN5dUrbNo3NM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVksEu2TfVUeiwJxJfegVrA3okXWKBKbLNFG6
 7+06mW1CBWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZLAAKCRAk1otyXVSH
 0AtOB/4nD3lNzZzEhkQxDTqe121DOffEM7mPd0/E/XOXQUbMwYpopWzhfFY3H9+GRkIARvq2Z4q
 kXFMMb6Gttx+24ZE3LaswzpFPQCevP85rdp2rPR+Iztfb44hzeYKNvGm5loa82w8778+AiNKzfX
 dLGZdPeRKpbqdZu7NWhWSJ9UyNx1mKmdbDhIDeKYpbTc4TVe0R0qVB/pcuc8pDvsinuhjrk0qj7
 Agd+KsKJthnwRIzFG3mFkZrFYNduL1YTD8VgksqPTTRXdT1KAhusF163mjw9XFJuJezdBcdNFhf
 huZn5D47QZhk0jCoUoWdg8vOhb70Ml8GoDxwSozEGwdCKpD6
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The comment for handle_sve() says that we only call it if the guest does
not support SVE but it is now also used for nested guests which have
enabled traps at EL2.  Just remove the comment.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..f674cd25d894 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -224,10 +224,6 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-/*
- * Guest access to SVE registers should be routed to this handler only
- * when the system doesn't support SVE.
- */
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
 	if (guest_hyp_sve_traps_enabled(vcpu))

-- 
2.47.3

