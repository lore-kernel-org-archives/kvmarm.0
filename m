Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5068A1537A3;
	Fri,  2 Aug 2024 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722613343; cv=none; b=Wp6/YsgXShBYXgIrv6KPqRo53rYOkenJyvUcZPX94vnWXccedvuEE3Hbz7Ls1pF2mmsDaEjwOOKmwJB0HPKOvDBoHdgXSupyEEucYWxIXaK5LuIJV5bCtW9I1Hd4mScNB6/sLfhx8tQ6NvYDxxBpOa22WdGhKeNTxAaq+BXQ2ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722613343; c=relaxed/simple;
	bh=0ccNknCx8NY78mfhENw9pRFYGFJerN5Iod19SIgGspo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RnJtKlLwFAXhSheUBebIJwXvJdYcvcIOm3EJXkdq4H6O1n9kEtWUbq2SPR++r3TSRjsJYTK3On9F/bnuuVNSidzPeBU/jU8ExZBPReVcA4378VTWRE6hAmyCq54h/6vsZw0DDDZSviG3Y22BUwmVrPE1vpLyAK4X1XtYzUj0nJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfIQlkiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfIQlkiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33A0C4AF0D;
	Fri,  2 Aug 2024 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722613343;
	bh=0ccNknCx8NY78mfhENw9pRFYGFJerN5Iod19SIgGspo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qfIQlkiN6KCoOu5uQBuR+iBpEwovMgYv8PhoUkkQvADV6S5tF/QPXYWyc4ws7uiYf
	 A43QDhX1HnuxUz9BD5eiGdBKtDshgXH8KCHxdDmGSO7yAt5Erl7qdkk4ZjKA0iS8MC
	 04h9fy+repB+iWH/uaqKm/66r2uik2/lS0NqfgMJMvpjFfJsxf9lyobPz3WHyx9wha
	 mu7OhGhgC4yqoQaO+P+eSZCY64nsVvVa3mQnDtKSIjuBW5+uCRM9o9I9f7b0yvv8Hw
	 DUkP4SIteb/mONJURdmaXZOnYqbx7Tmw4GuGWReLzaX3eCwr1LB+kb1Aaqn3554wLP
	 +/H7PLbsPuTNw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 02 Aug 2024 16:37:33 +0100
Subject: [PATCH v2 1/2] KVM: arm64: Fix outdated comment about incomplete
 FGT bitmask definitions
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240802-kvm-arm64-fgt-doc-v2-1-b90183df14f6@kernel.org>
References: <20240802-kvm-arm64-fgt-doc-v2-0-b90183df14f6@kernel.org>
In-Reply-To: <20240802-kvm-arm64-fgt-doc-v2-0-b90183df14f6@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=1309; i=broonie@kernel.org;
 h=from:subject:message-id; bh=0ccNknCx8NY78mfhENw9pRFYGFJerN5Iod19SIgGspo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmrP5X8h/vTnMzeMdeQNnLe41ebB3+7wMfOigNGQhN
 yUL1PQ+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqz+VwAKCRAk1otyXVSH0OYrB/
 96OhtxQ0pXenIcluf4V1mPe71qVgRgsmZpj1tv/09UD864WxeYMKF4Ikaq4fnTa2TVm9n0Sw6CmndP
 BKgu033vZ1oMSVeaY4H/Gr/MeYbkUlfY01JCei3d/ivGW+vojelZ3gVgWMvPOWqqXcDH7pMRI7JciM
 0N185Nl57aahFsZuS5u8zKfucPc4CljawIaH44dQ77ta3I0NeUQdQV4AViFxJWzKu2W7mfFq76SdyT
 sa23xkcFH/s1ACZnohwSQfFl2PMbJ/JOd0kEJ0vJWHMJJ81YzOSvcSPraS8iMAzZh4H6XvA4hDKMrg
 PWPwBJuLtTfm6DG3iT2MmWULhlzVQq
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Comments in the code say that our definitions for the FGT registers are
not the generated ones and are updated only as far as DDI0487 J.a.  In
commit 9ff67dd26a9e ("KVM: arm64: Use generated FGT RES0 bits instead of
specifying them") we updated to use the generated definitions.  As of
the release of DDI0487 K.a the XML in DD0601 2024-06 is in sync with the
ARM.  Remove the outdated comment about divergence.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d81cc746e0eb..d347483395b4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -342,12 +342,7 @@
 /*
  * FGT register definitions
  *
- * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
- * We're not using the generated masks as they are usually ahead of
- * the published ARM ARM, which we use as a reference.
- *
- * Once we get to a point where the two describe the same thing, we'll
- * merge the definitions. One day.
+ * RES0 and polarity masks for the FGT registers.
  */
 #define __HFGRTR_EL2_RES0	HFGxTR_EL2_RES0
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)

-- 
2.39.2

