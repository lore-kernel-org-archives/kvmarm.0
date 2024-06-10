Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAFB200C7
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 06:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001194; cv=none; b=OSfegI5Qawr4luML9q9qwr00ufwUFrj2Rw6JoPZ2Xueuts6lPEV1p9KvsjtT5IAIM2Spit+62Bzvp5U0nFDIcCV672/4KLYYdSoku1+AQNVOrC1aLVGN+xBYboJ0cuTIWVoTZzZGxj3TNM9a3tntARKcKLeAtnRF6Gypc3Sg5+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001194; c=relaxed/simple;
	bh=gHt8zqUvDCjK16BTv1X5Tnkv3fxtChncwef6D10cFcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NHeTm0mlHnoj4hujLH1AnmROcuykKygXNaY96P5y+WN8mRu8i3HwofmsHmmoUU7bgzHFR3Q5UPnfEcSYJeuC2NIinBuPu6V7DiLcPdJOY/hTdX24XTtMh2kFQPAglkX9BEYAxhypol4XSybD9bSrAgbzXGGDKJHdGw9vxtL2Rng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eVf1Rez0; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eVf1Rez0"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a6efbb08949so108410166b.0
        for <kvmarm@lists.linux.dev>; Sun, 09 Jun 2024 23:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001191; x=1718605991; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z0udD/PdRvQwx4wKxPuf11kZ4dOxHkqKwOOLvcn5nZA=;
        b=eVf1Rez0lq7lPUdQh98Tolmk97IJzgMsuS4eNoEWtfAoM7ybUFt1x4XxBu++LO8uCN
         lXhtP8KL/xO2FP6uN/ceLoGnMtkw80+Cfz4UNCA1FRwg6eO2LMrkxm9aBNYLz52Xv2x9
         YecjZoYahm3pxJFtPyZQa5wRp49FkuZ74GM6QgDLc6q+pp6cn2eT7+DO72h+ZD0g7z2r
         LzKRPlWc8cvxyCDl7iFDQO4gtfaYaO035Xtj0sQxapo7bgRj5SjdCRYtjHGrr4fLapme
         B8oe9K5ckqwxCI2zRR7Ue+0WA+7Br9T44Wk2xQ/ZoWvhAbAWH8q7eWiUdTs+1/AAX4M4
         H85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001191; x=1718605991;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z0udD/PdRvQwx4wKxPuf11kZ4dOxHkqKwOOLvcn5nZA=;
        b=WnLABmyKxem2P+2ChsDtwjMUrykPl0FuzDduLiVDio9o3J5DbtG5+BAsRfn+LNGzIV
         URzDQ2FM56EkTHpjB5y1r4MpbCwd3mrVUznyHhAl0j+MfB/NZOmstfrfYOxBWHFGRx4j
         G7bLXCgsDbr0Kq6gZyToVYRlZ8ETGt2fbGxtD2NWhDjE2YlHRFgt1uT1iOqMlPHkUGhd
         8d21LKk9TCAyqKDSWIdT/jY5X4xNVoPoi7c8KB4oM8kTKTq8/xePwR1oPhDDWMjqtcnF
         wcPK3wFGiRGwrh5NeBD+78ivLpT8nElLdtZSgnH+5eV+IIuOWnnusw+sM+dQVjgq1jph
         OZKQ==
X-Gm-Message-State: AOJu0YztOCMdcBqC7+fNb52DeAVxHOlfpUbWUj2VJoPPTD+jWYaCx4lN
	vgsMtp9JR40SrABqXG0ILW51B0r5DMt3fpYAPzfcgFcPwD21qrIe/hyEGRZRbhWGfwHwU8XPA4e
	7BMNjueC5dA5I6MpixObeFGqCWjUJUCrb2XuX1EA5YIiIHN0ICL8dTULNAFPRVTx/L02lJJovQf
	eSaAiGsplYzqC46uQ+qxuAGj+1Nws=
X-Google-Smtp-Source: AGHT+IGv+s66RkOnG2No4QDLJnAjBEudC4CdDJBYCyTNdZf9o4rJX0PEOZM4CVBe0sIJilA7BZCLdN9lgQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:1cc5:b0:a6e:f44d:3c65 with SMTP id
 a640c23a62f3a-a6ef44d6407mr655866b.0.1718001190442; Sun, 09 Jun 2024 23:33:10
 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:33 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-5-ptosi@google.com>
Subject: [PATCH v5 4/8] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
the relocation table of the hypervisor. The toolchain might produce them
when generating function calls with kCFI to represent the 32-bit type ID
which can then be resolved across compilation units at link time.  These
are NOT actual 32-bit addresses and are therefore not needed in the
final (runtime) relocation table (which is unlikely to use 32-bit
absolute addresses for arm64 anyway).

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
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
2.45.2.505.gda0bf45e8d-goog

