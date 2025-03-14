Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027AF1FF5EB;
	Fri, 14 Mar 2025 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741959265; cv=none; b=KUyNzneOXop+M7jLl2ANeobEy3fjv/Kwjpr84X82v1Y88rvJvEQ6vojY+um4G1YlNSlMmexsOFwBA4WQ/3al+h993cRTcD85C1KlFp5QfqcLY1lO14jfQ5YbEeNSUMETCL9JnXLJgOwprD14AKjkR5vsqBKumCvki9j2kUhnIpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741959265; c=relaxed/simple;
	bh=Nh5wUl4x9u8EMy8wWXBvkYp2HpGM28PTwr1jqa491Ek=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WcZI1/LwFK3ldOpApkMHWeV7S2CfFb8IdRTHEvGFULZHrXUgwAq+33lSqnVLftZKjlofBqa0IbyEQfKz3IivfRMWtWc1CUKFphYKURGduWhGq9cStZY3crSNfFchBB92C8p7VkC8WZsc3kHJo4hVaQIMJf8tB9uFqLzYYAlZeFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spcca3v5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spcca3v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D00EC4CEE3;
	Fri, 14 Mar 2025 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741959264;
	bh=Nh5wUl4x9u8EMy8wWXBvkYp2HpGM28PTwr1jqa491Ek=;
	h=From:To:Cc:Subject:Date:From;
	b=spcca3v5SutSp2uGX31Y9pVTWxuWKbNyywVCiV+txSk9catfchEKY1vB/6eYIh8m9
	 wnLJ3tjygr+CJfFMRyJKfdzttIG+XJw91bjPc+20WEDXngA59JbYB5K27p6WWh++Jp
	 //jEOhG991TB3niUsqCMaOW09XDdKYeSxSjyG+sYnGyCDk0LYr3rSUJ67GBmVmBSXE
	 OqCtSk4GnGeWOELqd1cs1Vo9xwJFxTFh1SbsEDlsKzVRj0zJHzfQakEPYnGFUoE2ZS
	 chi+fvuPP49C+5iDwHkt647fsHAPUEupNKzwpgZJSnv4Xa9vXMQAiqI9+Z0nKam76z
	 W3ewsm5PT7FoA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	stable@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH] KVM: arm64: Tear down vGIC on failed vCPU creation
Date: Fri, 14 Mar 2025 13:34:09 +0000
Message-Id: <20250314133409.9123-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If kvm_arch_vcpu_create() fails to share the vCPU page with the
hypervisor, we propagate the error back to the ioctl but leave the
vGIC vCPU data initialised. Note only does this leak the corresponding
memory when the vCPU is destroyed but it can also lead to use-after-free
if the redistributor device handling tries to walk into the vCPU.

Add the missing cleanup to kvm_arch_vcpu_create(), ensuring that the
vGIC vCPU structures are destroyed on error.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---

It's hard to come up with a "Fixes:" tag for this. Prior to 3f868e142c0b
("KVM: arm64: Introduce kvm_share_hyp()"), create_hyp_mappings() could
still have failed, although if you go back before 66c57edd3bc7 ("KVM:
arm64: Restrict EL2 stage-1 changes in protected mode") then it's
vanishingly unlikely.

 arch/arm64/kvm/arm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b8e55a441282..fa71cee02faa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -466,7 +466,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
-	return kvm_share_hyp(vcpu, vcpu + 1);
+	err = kvm_share_hyp(vcpu, vcpu + 1);
+	if (err)
+		kvm_vgic_vcpu_destroy(vcpu);
+
+	return err;
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
-- 
2.49.0.rc1.451.g8f38331e32-goog

