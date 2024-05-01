Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D02E9474
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714581247; cv=none; b=deDDWyhidT+4pNFgq9NPELdy4UvUcIyM2drDIlkQCnAj7hyc3euY9Yjy8H2rWoabJpY1PD810TTQAUTiGaSQqdLNYR8Qpx0fxsZ4CZ+lEH1pTy+ciGqmwZkduAr9GynpuTXZAQk+W7Bsx3KT401Z9goEibLS0SaElHC9DqW9cns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714581247; c=relaxed/simple;
	bh=vVE6A0ZX8YYYvJ8iJgqupBt3NBrgyKJG4Euv+HlzFdI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N5Fg0X9kY6HoUJNwNbbtBVG1U7NVM68qzeYq8VbIfojwmeAaUUfvFtT3bwTQW/7e97zkBMe0xKF9Svsyspjuyju476cuxLv84GCQJaUMmOggZ0McIUHhiHqsz2E81eGbqUASLxJbzIzB+F6ovIpisgRaRPGTC/OBKtYWO/f6i1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPamrdjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPamrdjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C878DC4AF18;
	Wed,  1 May 2024 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714581246;
	bh=vVE6A0ZX8YYYvJ8iJgqupBt3NBrgyKJG4Euv+HlzFdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPamrdjc4JnRM0Xnpg/pSVtB7wEg8QkIhceDo+9yUpHUiQtnOyQt+UVSPz4dIC5d4
	 tDfqFRd4I5XQ3DWG5fR8gJ5luw+8spchrTC38ukvo1ef3RyOuDoijrkap80he9Hw1Q
	 /seWuctoQVjymbldTrY3hZwxtSfIP6Ze/4ciaQRePBEUMsDYrHmyudjvnsbUMg6HUI
	 3x/dgc9ZHbpMSV/ToEnCa0KOLISxHpJlMOLxe5tQsVSIjlW7qfqcLUEssHcpUoJi0g
	 NsX8+BZZuVLf/qhJdtjNsssXCBeJVMOdPUKvJxZ9Yr+eZbYpzJ/ee00jik+RMLrhmA
	 6iMa6Kl3r1aWw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: Fix hvhe/nvhe early alias parsing
Date: Wed,  1 May 2024 17:33:59 +0100
Message-Id: <20240501163400.15838-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240501163400.15838-1-will@kernel.org>
References: <20240501163400.15838-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Booting a kernel with "arm64_sw.hvhe=1 kvm-arm.mode=nvhe" on the
command-line results in KVM initialising using hVHE, whereas one might
expect the latter option to override the former.

Fix this by adding "arm64_sw.hvhe=0" to the alias expansion for
"kvm-arm.mode=nvhe".

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/pi/idreg-override.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/pi/idreg-override.c b/arch/arm64/kernel/pi/idreg-override.c
index aad399796e81..39c9253fcf23 100644
--- a/arch/arm64/kernel/pi/idreg-override.c
+++ b/arch/arm64/kernel/pi/idreg-override.c
@@ -209,7 +209,7 @@ static const struct {
 	char	alias[FTR_ALIAS_NAME_LEN];
 	char	feature[FTR_ALIAS_OPTION_LEN];
 } aliases[] __initconst = {
-	{ "kvm_arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
+	{ "kvm_arm.mode=nvhe",		"arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" },
 	{ "kvm_arm.mode=protected",	"id_aa64mmfr1.vh=0" },
 	{ "arm64.nosve",		"id_aa64pfr0.sve=0" },
 	{ "arm64.nosme",		"id_aa64pfr1.sme=0" },
-- 
2.45.0.rc0.197.gbae5840b3b-goog

