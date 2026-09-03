Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA324CCDC7;
	Thu,  3 Sep 2026 23:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788477385; cv=none; b=O7Qc3wnmihvLgXAy6kz+1bqjC7Qn0+cpX2Z4M5k18Pq79ekomLZNwxlvvRFYtVTJgj80tKFN2wXJOw9OquRJzq6tagt8Tsi3XWQdVNGoBHTBAtuoNPUIRpZRTy1fCPdYHYGstAbXwN+8oPOYzn5CXzuitcO0YmdwELM72NZKmS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788477385; c=relaxed/simple;
	bh=Kqp3K7FfT78LyAqnNA+N+3rE5LyP7h9v+UWaBdZW9L8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WYqR/W7qOxejtak5sx21S7xIcnI5RVvcanazjA5ix5NXfkcMXPBy1PQBT28I/0E267/q4ordla9lt1TDbQox7vqiI23kw5msWBWDrSXDayczAcRIEOVm9JZK9uwqdK9FV5N/nyvF35xK89Bi3LNmDs84agv2ERUgoccdBsj+ySg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZimDhuxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZimDhuxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53611F000E9;
	Thu,  3 Sep 2026 23:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788477384;
	bh=YzkNSVmu73Wg+xMwKSV7/J3QFwDq8+WVAzCbtfpU41A=;
	h=From:Subject:Date:To:Cc;
	b=ZimDhuxIWEmdWVNEsbR7+NVKKoiKvhETMmtTv//OPz/xTShu3AvNPTAq5t18ukNOq
	 jywIOAY/HgZai7tut5ht08FvumtFWKJWCkZkSQphgkaHe72jlgQTPmwo5wzE36yENH
	 ThMoix0IQ2oJoZUx2tcEpq34eSoId0WtRx9vHTTnDBNOjABzxfhSgv+GMS8OGguG4x
	 n0c5K4Oz+wxoMzqj9SWgvUdYnnI6VZ/av9X3wV30VgHy60ukiacCVxM7ejXERdvgjJ
	 nBpV2miOyBEndKdtYq9rCY3kTfxRkhgIvulcu2fSZSj90MlVOcChII7okwIJVjLDDy
	 pyasgMg8rEDtQ==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Date: Fri, 04 Sep 2026 00:14:40 +0100
Message-Id: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGD/mWoC/yXMQQ6CMBBG4auQWTMJNKRWrmJYtPVHRkIlLTQmh
 Ltbdfkt3jsoIQoS9dVBEVmSvEJBW1fkJxseYLkXk2qUbowyPOeFbVx0xyFP4FXA3hntu/YyXmG
 phGvEKO/f9Db8nXb3hN++JzrPDwerKCJ2AAAA
X-Change-ID: 20260828-kvm-arm64-nvhe-pie-cb86c417f9ea
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1213; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Kqp3K7FfT78LyAqnNA+N+3rE5LyP7h9v+UWaBdZW9L8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqmf/BrIDaGAlklwATNnNXtoreOYeo86LT6Bzc6
 9DZsNdIAa+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapn/wQAKCRAk1otyXVSH
 0K0SB/9H9SLSIF1wblTncMr48qmLLBv+ArWZx2kw3fXOEb4aC0/wV0Tuk5CUFiyxEODntvt6Utg
 zRKs0/1B7+C0AWhjMpfIVH8+79e1Djv0/zI/oL282624SXOAVICCqzZxf2qT428ExxqFqDprSmy
 gSRwm5U6BQx/JPu4rH1C3cXgRQ7Ei4rcA56OYrDVrzLjLLj5FEjXu9OBGmcvryWF36z61WeCfHb
 RGilypEQGg8MUDE5+hK/WLnU0WBwUuo/eb9mCIRgogjDQanPAT0llxmBKltbphyj9DCvuShGo5g
 Qi1Cnq0SRkQAnSxZuwieb8rz0aFKrWI7mqQHNfCjS/GeM4th
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When Stage 1 Permission Indirection (FEAT_S1PIE) support was merged KVM
was updated to enable it in the VHE hypervisor but we do not currently
use it in the nVHE hypervisor.  Update the nVHE hypervisor to use it as
well, as with the initial merge of the S1PIE this should have no
immediate practical impact but it makes the nVHE and VHE hypervisors
more consistent and will be required for use of features like D128 and
GCS which depend on permission indirection.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Mark Brown (2):
      KVM: arm64: Initialise TCR2_EL2 for nVHE mode
      KVM: arm64: Enable S1PIE for nVHE and hVHE

 arch/arm64/include/asm/kvm_asm.h     |  2 ++
 arch/arm64/include/asm/kvm_pgtable.h | 26 ++++++++++++++++++++++++++
 arch/arm64/kernel/asm-offsets.c      |  2 ++
 arch/arm64/kvm/arm.c                 | 13 ++++++++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 24 ++++++++++++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c         |  7 +++++++
 6 files changed, 71 insertions(+), 3 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260828-kvm-arm64-nvhe-pie-cb86c417f9ea

Best regards,
--  
Mark Brown <broonie@kernel.org>

