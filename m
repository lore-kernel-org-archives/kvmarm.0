Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02284582F5
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052574; cv=none; b=s8/Mo6Fu1SarGfczNVTO86WXOSysvmsuxXsqDASK1O1zDhgm6Ldu+tFxvZHoThjzyIue99rAVJnqDrF79av7Bw8OsBi3SOVFVjOAj3OT6/GM8Eu3RptdiDbnYER694k9mMDcdsY31Qlm9ySjNd9cf6shoVu99ZvM86c1riZoV0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052574; c=relaxed/simple;
	bh=mqinjzXhUcoLMkqFncjy3awDJ9xmqF05YJhAD3a/vfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP558W+PhxWhnYqtKQyLyvjZaoiYiT85wFUy1GTAt2At50apQPtlT3jW4iyV/08W2H5Z4t3dFrlDwz1hS32l1UwEPOPnvNuzG/qSbRnPUhUNwu+BW40tHB7y7HFzYRiX2Dvx3fzBBL5Vjj8S0eJ9IcHDCKCIBkIs4Xgn1GZuKP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p3Tgphzt; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p3Tgphzt"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso5807815a91.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 04:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787052572; x=1787657372; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TgcDc4oA52oVFhPCIzepFvLDOjJcdq190pOOMughMV4=;
        b=p3TgphztnsHp46w+692UBZrge+XjgcOEV/j/4v7ubfBncWJU+d8Lva/0Z26rtYOu3D
         /U5o4OrPu2Pljr00raFSk1gokVeofYkGyAjNv8EupHOjIRsVJVNMWPyy8iz743jK8Ytw
         mSiPddF1/a7V0PBoqWYTMVSncArPbhArq9Ca+0Of0tHcdjocYGgT9DqeJT5hJS7AydcO
         Xjetcqm0fluiGrpxoBtr+yMavODNSApVjkJW2MlaiogkaxLHbEkpNASPDCFoBkJv/zVN
         eoDBRET311hHp5tgRekCEZmkL6LvS5Siq/Jf3ApCkZLz0RGnm4O9fwaF8kOyEr/pa81C
         e+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787052572; x=1787657372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TgcDc4oA52oVFhPCIzepFvLDOjJcdq190pOOMughMV4=;
        b=JjJOa8RgPQp+zxWw504m/LZ8FNnd2wgGx7Hsn1ytir/7R5EP/BXwKN8HaqXcTsplsJ
         6pzWDV13QB1rCmvZcOgGfqPNfCJW+mhWiZCAbB+F01RPvm7WiL1Qxw0TQvb106MAcnLH
         daYQc0dmSN22CtpdtwGpu3+O944wVpj8esZVURFv1P3GeycTM45BbtNsn/QCfFVcGfx3
         EAbVAdiClgZCc05i22AiYuKcS2kAkB6Y9fwuKUzkShjbaGu90cOyd1Ydv5agyknG2py7
         5kZidM810PHDBvvACRdi88xm429PbWc3B4z10HeEq7CE/6jB24vkKv4/xugqBCAW8U7E
         f4nA==
X-Forwarded-Encrypted: i=1; AHgh+Rp35ojAK28jrgGzResSoSClkTADSUkcmEaPT1XCoqxVGLpqWm1iBOWIH1mYcmuGrWyrrqZBkzA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVgBnE4gttMox2qIPJEGExoo6Ab5HzvMJNBGYVCsMDbTqPwRLK
	L2Ld9N/ql5p3ej7jyUUPeKxXBlzN4G6rXZ0F7wBh0BEsSh0+Pl+HFeTT
X-Gm-Gg: AR+sD11cmfXZfNXGCcLlcI225af4jtRbUIlyWUgwDDqxcutMINk50+KrCQN09LOtKZL
	JpSnLIyq5U4HjJ+/jG/2YzSWfe9fc2sB4aSt63AUEM6h8b2NtUeZh1BPthsiJ7nAht6sT+IRfsf
	ZTLyiVrVK5vzynbbbno8IBxun7jpvlhD31gCxdrk5c6or1dQkCZmEpWuAcJyNS+r4JOVXTr7Ya8
	Wl0gOxceJZ3q95hXhfKVCE5pXgQeBfuxPBF0KnRRLprnTLyHUpq1PhhzEZp7cR1ibxutY8w/y2K
	WwjL/N8F2WJ1IxcInVqzi4NEWa4DgmeQtUW2BciOLrSaYVA8h8W+B9rJMaXuplvZ1m2r5tBTDA0
	2uSG6NY7XLluVk0VlzL8s4jZMvMd6p5kQXbhZwqE/KtaSfiD96Oc5HgVfp9DcvdVj8PMsJXE7ZU
	EkJ5akRGISkjRDhqcehKdxJA9ltXBjb/8AyE0ujmuviow7Ofdo/QAIu06lZICUJ+0GfsV74FsV+
	xt8wHG7s/MIHXU=
X-Received: by 2002:a17:90b:48ce:b0:390:b41a:b92b with SMTP id 98e67ed59e1d1-3933b6d05c3mr37501585a91.4.1787052572199;
        Tue, 18 Aug 2026 04:29:32 -0700 (PDT)
Received: from LIKEXU-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e31a9dsm8423420a91.4.2026.08.18.04.29.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Aug 2026 04:29:31 -0700 (PDT)
From: Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: jiaqiyan@google.com,
	kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: selftests: arm64: Skip sea_to_user when EINJ places no poison
Date: Tue, 18 Aug 2026 19:29:20 +0800
Message-ID: <20260818112920.26252-4-likexu@tencent.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260818112920.26252-1-likexu@tencent.com>
References: <20260818112920.26252-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sea_to_user injects a memory UER with EINJ notrigger=1 and expects the
guest to consume it and trap to KVM as an SEA. On some firmware the test
aborts instead:

  arm64/sea_to_user.c:223: exit_reason == (41)
  Wanted KVM exit reason: 41 (ARM_SEA), got: 6 (MMIO)

notrigger=1 asks firmware to arm the poison without consuming it, but on
these platforms the poison is only armed as part of the trigger step that
notrigger skips, so nothing consumable is left in memory. The guest reads
back the sentinel, no SEA occurs, and GUEST_FAIL fires. On arm64 a ucall
is delivered as an MMIO write, which surfaces as the KVM_EXIT_MMIO above
rather than a KVM bug.

The file already documents that the test must be skipped when firmware
cannot deliver a consumable error. Detect the guest abort that follows a
missing SEA and skip, instead of failing on a firmware limitation the
test cannot control.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Like Xu <likexu@tencent.com>
---
 .../testing/selftests/kvm/arm64/sea_to_user.c | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 7cf95da8e594d..d4af6e0eed288 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -215,13 +215,33 @@ static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 	ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
 		       exit_reason_str(run->exit_reason));
+
+	/*
+	 * The guest's read of the injected location is expected to trap to KVM
+	 * as an SEA. If it does not, the injected error was never placed as
+	 * consumable poison: some firmware honours EINJ's notrigger request by
+	 * arming the poison only as part of the (now skipped) trigger step, so
+	 * nothing is left in memory for the guest to consume. The guest then
+	 * reads back the sentinel value and reports it via GUEST_FAIL, which
+	 * arm64 delivers as a ucall over MMIO (hence a KVM_EXIT_MMIO here).
+	 * Treat that as "this platform cannot host the test" and skip, matching
+	 * the requirement documented at the top of this file, rather than
+	 * failing on a hardware/firmware limitation the test cannot control.
+	 */
+	if (run->exit_reason != KVM_EXIT_ARM_SEA &&
+	    get_ucall(vcpu, &uc) == UCALL_ABORT) {
+		ksft_print_msg("Guest consumed no SEA: %s", uc.buffer);
+		ksft_exit_skip("EINJ notrigger placed no consumable poison on this platform\n");
+	}
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
+
+	/* arm_sea holds valid data only for a KVM_EXIT_ARM_SEA exit. */
 	ksft_print_msg("kvm_run.arm_sea: esr=%#llx, flags=%#llx\n",
 		       run->arm_sea.esr, run->arm_sea.flags);
 	ksft_print_msg("kvm_run.arm_sea: gva=%#llx, gpa=%#llx\n",
 		       run->arm_sea.gva, run->arm_sea.gpa);
 
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
-
 	esr = run->arm_sea.esr;
 	TEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_LOW);
 	TEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
-- 
2.50.1 (Apple Git-155)

