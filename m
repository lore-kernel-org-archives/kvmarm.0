Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463F737B00F;
	Tue, 17 Mar 2026 20:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773778262; cv=none; b=K6QzZ07fCLkJexrFTQDUyqLVIj0ZMo3uSk+On6yAz4hQDCkFX4fvSX/1RM6h4DfDyQWdd3i5lNc21UbhoHEtFz5SupAZnV3HsztAzsJUZpQzawHm5nhqrp/5AITU5go2gWUku4Kt+qF561s3PuEBeLb9Dv1PcRgXFIpOOdhiFt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773778262; c=relaxed/simple;
	bh=fAVZD87pbrERscO5EBbL4UXt/gj+nHPQY7XsvwsyJC0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ppi1TARk0ca0MF4WJthHZgE77Tx2/lazyu6Ea4nu5rWx8d3OkkCcOkzg6pKCxC/XWc9okggL10yK6/GR2nuqJAeBOspMurQB6TIm7W616Vspxlm30sBjXhdI9XBHcxKlqhlFSc+2XFBV+sRtaFClawLBEkVX5htvWw7AimabaE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tlJk2j2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tlJk2j2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABEDC2BCB1;
	Tue, 17 Mar 2026 20:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773778261;
	bh=fAVZD87pbrERscO5EBbL4UXt/gj+nHPQY7XsvwsyJC0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tlJk2j2MzYJvID+dpbCh1navkrRurTQmiczQjaillDfWg6ARn3tyVFuZE0uCDs7Nr
	 1Og1m41DWMpp7Ob8Mf+wC2A4HwTnFY+tHBbiM++QXHSrTQsZpOsxmQtzPWA06mcUFy
	 9gaaQBNQa17NHxSRA7V4coDfIPaFD91Jg1Dfnw8sVEBXWdpM+vFGNKI00WSF9bbk/c
	 hcpzZIZOzR4bdeKnB41pK//HsMwBvLU1xII/Mo2pkGFE+eFjd7VdWIsadC3TxiUi92
	 VrL56TROCKFlbC3kjADqiRifxwt5WSmLcbL3p42VcCyzKsK6CqpAbn8bo5F6m5P0WB
	 bu8Q7RBAjyFVw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 17 Mar 2026 20:10:38 +0000
Subject: [PATCH v5 5/5] KVM: selftests: arm64: Use is_aarch32_id_reg() in
 test_vm_ftr_id_regs()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-kvm-arm64-set-id-regs-aarch64-v5-5-a60f2b956e22@kernel.org>
References: <20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org>
In-Reply-To: <20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-e1b5b
X-Developer-Signature: v=1; a=openpgp-sha256; l=1148; i=broonie@kernel.org;
 h=from:subject:message-id; bh=fAVZD87pbrERscO5EBbL4UXt/gj+nHPQY7XsvwsyJC0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpubVEYd+aI9Wa+jg3Mcnf1FBheli96NlRfce8t
 XvXHerjELyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCabm1RAAKCRAk1otyXVSH
 0EhzB/9K4jNR0iqFUOb78qCy2x/wNhKRW0krzdRLgpZt5kJiumqyovOYWOyNkcw5uTqDRZkasqj
 Flags4TK84CeWQ9JlTbSFDbBS9nDJ7pG8RnBlkjHfisWibJKEfa2g593d1DJpO/VHnXbm3sB+u5
 YKMfcYlFZjUi4TSOGNgbFsEWTMW+oSvqStZIjubMQjCSRQBcbUDE+RQkm7v7RwcIm/SFcfCFamz
 c+a8axfpP9fCLJC+y8sDmUOTj8935NnNo7+1y+SYja73ZnJQeITdXdu4CMe0aj9/RS29x5MRqQ3
 2b4FsxaEDnbfd6tHnjbGV0sSZ2JugFleYWSukuogEMO02HpS
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

test_vm_ftr_id_regs() uses a simplified check for 32 bit ID registers since
it knows it will only run on ID registers. For clarity update this to use
the newly added is_aarch32_id_reg(), there should be no functional change.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 127defebb35a..50e9e9b6a365 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -502,7 +502,7 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 
 		for (int j = 0;  ftr_bits[j].type != FTR_END; j++) {
 			/* Skip aarch32 reg on aarch64 only system, since they are RAZ/WI. */
-			if (aarch64_only && sys_reg_CRm(reg_id) < 4) {
+			if (aarch64_only && is_aarch32_id_reg(reg_id)) {
 				ksft_print_msg("%s on AARCH64 only system\n",
 					       ftr_bits[j].name);
 				ksft_test_result_skip("%s invalid write rejected\n",

-- 
2.47.3

