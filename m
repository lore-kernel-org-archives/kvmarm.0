Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38A0175D20;
	Fri,  2 Aug 2024 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722613340; cv=none; b=bnJrbKjTRucp2ll+76sFr6tnlrHkrJQj0/Xx7idp0zw/XDD09iuOl09SWbGL122HcoZSjFhDd1xcAFwRk8+5ycLC9Lk6jNbNpm48irfhoxMcPNzaiRlEozcxYDrDkKgmq8makWzeYwd7OqpPy3/L17iIUtpVMquEohiS+qFtDmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722613340; c=relaxed/simple;
	bh=OfTz+C0a5Jq9MspoeOlZDqEj3CLS8tVtEzKCYL18HNI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Luu7wmPkoHVEQbkA7Vcuq2NnALSpZjHCaXHuRI8qLNE3Qtly8CJ3KejZZVg9f8ZbAsOxgKbUAoYPGvk23xeffJDrTyV9VjJg1oeWJONEWxTt/UYOjyuuENwD7feZqwAPpjKidBqUDRes5X7rqWdjBb+7fCprmk/gXzF51dWNjnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGy5nuPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGy5nuPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BD5C32782;
	Fri,  2 Aug 2024 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722613340;
	bh=OfTz+C0a5Jq9MspoeOlZDqEj3CLS8tVtEzKCYL18HNI=;
	h=From:Subject:Date:To:Cc:From;
	b=tGy5nuPvofbnUjk8Fsx+UDRGje9HcDje3HGDADOWSQfxFMxWn7VsbahlyIA0/eQGk
	 +WfdPuMlw9fZvdPAsuSV72rQyYAr+pQGA0T7DmH1h2Gpxaqo5Fg5EZTkmrnacL1gPt
	 cj35NVkawiNfMrDzu2DdtuQDmq07CzBvX61GROSWqA9s+2CQ23hu2AYakA45aDM8Qh
	 RQe60apLbAGaDUgxF1ZxFnUUvMJanUShMhg/krLAq6YTxx17zLCavpYg/9vE2ri7+t
	 xzHUAQzJ91cEEwaQo6M8s2xQ9ZnqABqzjgwMOY9Ccqf1GDNzh7UqAHyoVoEXbqUsW6
	 Mb6hLGGRtUFRw==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/2] KVM: arm64: Fine grained traps documentation
 clarification
Date: Fri, 02 Aug 2024 16:37:32 +0100
Message-Id: <20240802-kvm-arm64-fgt-doc-v2-0-b90183df14f6@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADz9rGYC/22NQQqDMBBFryKz7pQYY5Sueo/iIupEg9XIREKLe
 PemQnddvgf//R0CsaMAt2wHpuiC80sCecmgG80yELo+MUghlagKgVOc0fCsFdphw953aLRWdam
 tqXoNabcyWfc6m48m8ejC5vl9XsT8a3+1/E8t5ijQtG2hla0tldV9Il7oefU8QHMcxwcerqr8s
 wAAAA==
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=878; i=broonie@kernel.org;
 h=from:subject:message-id; bh=OfTz+C0a5Jq9MspoeOlZDqEj3CLS8tVtEzKCYL18HNI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmrP5X2B/YvLaPr5TDGXBDQjwrXk9bu9waQzI0UWXp
 ASbOgQaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqz+VwAKCRAk1otyXVSH0A3aB/
 979d4fFm1Hl7aqv92FJSuf0m6E2xtnMK2wIIqVQHAnn7eJKI1LdYfGBWJ/ze7Ny0f0zaGgMBZgSzEK
 /T5pIBxVd3mCk7UdjUB79HnDPpG3fYAzM60Pb+bPGvWciA0HpC1+TaFCIsJjdXVqx62t2k1ZjSFbPO
 B0pmErGkVIQXGPX2qbOx6l2mWeG2w2+2UxTYayqtfA2q1H5YNCcrOPkw6PmcAPy3MAbpXDf1SG/5Zv
 pXpFhhSfHlVLKYuWiGYt8Eh1lUhwmi7aZcMxqN44RDYhUSt7lNikZWt+ku/QH6f59c30QiC3Rxks1T
 WDX/TC2gia/uPKirBEr7LMewjLMLjQ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When looking at the code for management of fine grained traps I noticed
that some comments were out of date, and that there's some potentially
suprising usage which could usefully be clarified.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Commit message tweaks.
- Reword comments for _MASK and _nMASK.
- Link to v1: https://lore.kernel.org/r/20240731-kvm-arm64-fgt-doc-v1-0-abb364f8fe57@kernel.org

---
Mark Brown (2):
      KVM: arm64: Fix outdated comment about incomplete FGT bitmask definitions
      KVM: arm64: Clarify meaning of _MASK and _nMASK for FGT registers

 arch/arm64/include/asm/kvm_arm.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)
---
base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
change-id: 20240730-kvm-arm64-fgt-doc-a664856fa7d6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

