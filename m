Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800CD17556F
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340456; cv=none; b=ZbAtInIdBuEnFpwrm9U20lnRCWo8XEPDkdv9RRq5kFtQZB26jQ4itQMFAoSS0R7b24BNIKVyJdUdcUYqg3D6S1RfmLN6Kot9wloNOlOeuQVziMjOZNZ8qB1PFQTe1KKxjBE1SG09yATUQ15sRr4es0mabrkqtaVeyM5HVaSTjQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340456; c=relaxed/simple;
	bh=WDIF/IYfsmu+ixH4sDQsPfWeDKguwD4ZsBjXEU5uvDI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cIXOYXHK/XoXQsyTKkCZbjWmLNq2mKiPccsCWv0tBvm6OCLwt5yVG4lOVO6V7FHrPby5EHfA1Tvnw9Elq4Zl1+djchCx4pMR8hKecMzBZCptdXs1BjThvQJcfhFHQ7ZDMOMsvDfXkeLBFUsKO/ATwcU/9AwT/15zt+Co+9QS7Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fNNpPwRr; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fNNpPwRr"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a59a0d2280cso148868066b.1
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340453; x=1715945253; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=49RDvmrkbnpDyrHr4vuzEjRKizGtD9K6IaD6JegXO3A=;
        b=fNNpPwRrfOyxKKH5LIeqjIpOt380mJmJb4Fzhd5fzz0sq3Lt1iJDU3dLgluTF/siXr
         eII0vFWSCTVTFnUu+Sa6+ANlDORqEFADDkcl3ACF4ibssYl/YbWOw8yzWEQmOhazt8E6
         QAA+6wURmi80uixu7j0L7w69/7cJJTddPzHHCrwUqmDiq8Ya5EBTNQLhpQV/xHnBd95e
         nmeRDNCrGPqrFPiDF51E7YCjnOxfLRWKJSvcVZaGzkQlv9G4gy95cTJSI+MBo2oIjmzU
         LKLDZP17t9VoYBPzYU8OlFfZxSYKI947hL+OL5vBqHoL+43n6iBXofp4Zi8xy6fULrNj
         KLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340453; x=1715945253;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=49RDvmrkbnpDyrHr4vuzEjRKizGtD9K6IaD6JegXO3A=;
        b=wtUn8AwXK0e8BQXOwUtSLvjyjoPVBTAGc53SZ7BTxEvwzbk5mZLTdi1yEpfpDZNcWg
         dmtvCR19LWQTz1C2D2AwD2PcI8bfg0HQ/tkajEe5Y/UiYiQp+T4YVuwEoiaMGPWLaau6
         HzsE/yQ7HLvaLI2Ud9VLdZzxNUGVfx61PHS5AnG1ZPF9S9nWJste9MvkjQsWO+9geZjW
         j5k7zM+8FKKHBvTs7EOANSkt6HxMUlI03lkJc95KJizTGogBqjHqHGZK2uJpm5RycMXL
         0dDBt8g3Flgm2CACDzKwYIXc5T1BmXlcULUloMo6Ub/nBxsMSWAvqzK5kN91MayGajhM
         fNoQ==
X-Gm-Message-State: AOJu0YwrCl3vc1esB+01UaqFjOPGFluVk+fK/Jr11YaQxmsGs7rbjYXa
	HwymiY8kXm5QWt1OBMEyHyRqbZ9qu4NYXlnnr3VjnUgU/3gXyg/Tu5L6m+gta9iQOCl6K9nBSXV
	HI0WbZW36wWbzcV7FAVetKgDt4Ld6YWsjPTvTMOf1ivp3H5aV+1/2ZJB535UA+zwJBYqUA/km9p
	e8E1iTQUvsE/Fz4uZZc+gPiyl4b8Y=
X-Google-Smtp-Source: AGHT+IGbgNiv89bjQrlHWpgNH9EcVBcfDrRvtOjM5hynq/y8S7do68WKAWDs0MZ3rKCKgKDcmOOmZ9+0TQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:1188:b0:a59:c39c:f202 with SMTP id
 a640c23a62f3a-a5a2d5a6a3amr235366b.5.1715340452299; Fri, 10 May 2024 04:27:32
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:35 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-7-ptosi@google.com>
Subject: [PATCH v3 06/12] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
the relocation table of the hypervisor. The toolchain might produce them
when generating function calls with kCFI, to allow type ID resolution
across compilation units (between the call-site check and the callee's
prefixed u32) at link time. They are therefore not needed in the final
(runtime) relocation table.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe=
/gen-hyprel.c
index 6bc88a756cb7..b63f4e1c1033 100644
--- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -50,6 +50,9 @@
 #ifndef R_AARCH64_ABS64
 #define R_AARCH64_ABS64			257
 #endif
+#ifndef R_AARCH64_ABS32
+#define R_AARCH64_ABS32			258
+#endif
 #ifndef R_AARCH64_PREL64
 #define R_AARCH64_PREL64		260
 #endif
@@ -383,6 +386,9 @@ static void emit_rela_section(Elf64_Shdr *sh_rela)
 		case R_AARCH64_ABS64:
 			emit_rela_abs64(rela, sh_orig_name);
 			break;
+		/* Allow 32-bit absolute relocation, for kCFI type hashes. */
+		case R_AARCH64_ABS32:
+			break;
 		/* Allow position-relative data relocations. */
 		case R_AARCH64_PREL64:
 		case R_AARCH64_PREL32:
--=20
2.45.0.118.g7fe29c98d7-goog

