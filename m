Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20927181B82
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984885; cv=none; b=kdgBvU/8VHhI150EsGFx4juF1tSLe9ynIK+Nj8ktjXOpIfWGK5f3vzStRl+V4d8t5e6SqcSLW94izGObMK3ksdqiclnZhhRZqJZU/XvgEpNL/bblM9Zsp7jVw6uvUoN3+YGZiGfNZecC4V4qGbO8W4dC8CA0JuvRn5kLahzzVdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984885; c=relaxed/simple;
	bh=+cKcneugNDE7L/qpVl91ixp1M6xylMEZ521Xa4hyBQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vg+9FPmYeNp/xQBbeQNataBooBc8PuDFBUfTxOxRPSf9ALjYS6G7pmZLsdRtXhM0KYoZIpPyLS4Hylx6F4VYalYtQtPFQDd6AiLChnCSMsmYSGAawcNnCKeBXeGvrPCYIrVwoTpxV8SQW+KDuk+3hUDlYtIjRhvuNTCQLTlzfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xzI4sTF1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xzI4sTF1"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627e4afa326so31446277b3.2
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984883; x=1717589683; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jFr7qj90it7wD8ycil4shHE/w7boH3XXa9rQ6TceJ7g=;
        b=xzI4sTF15rkoECameFBoDgrsfRU2oeoUyUUhKamZE2udJ1XULplFcH+OrQI7dLsmT6
         FcdcKKQQMG8Wfhzk8RRpfgqcdU/qHW+xtBLq4n23Z7+bNl86SFBEEWa1vo3M+DVkUyiH
         JDAlIeo73LXHxFMsIBVnJ47Ggn3BnUtj2Nbfhe4ruLFvS4mw0SraoeaVW7wu7dYe6cAt
         xH/umFzxat6hwK529zmcK63au+IEmOM9mqDEs90B35ChfaEON1lH9hPghExaRZN4AFSW
         MiFBSK9tETGWAMlwzJ/ENkJ4i8B5j5/wHGhWEnC3LBjBdLW2tnX6ASNzNtRfFakSW3Bb
         lKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984883; x=1717589683;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jFr7qj90it7wD8ycil4shHE/w7boH3XXa9rQ6TceJ7g=;
        b=lsLYkpqTrwtqQOm7z00gsWT4Ui3+on1sCgpBI7KnANvATnma9aPGvjTV5lkgnNKqlD
         BvfaT7KzFzkyJGAlnP/lA3fwL4i6zfv/2hpxMotD+NNZfdQEmw+rPIHJMjl5bSGRZmPm
         sUFIzurTD+dQuOugXvhdGZr9t5i4jjQZzNSIRe1nfoS2l5D4hepRjj871uTST3vNXaXC
         Gt1Yub33xEE+bNIILFyufzZ+TkwexWKguhsSFGvohCXatsYqUd6plyTEfaF4xHNwGEUu
         5Fg37UiVR5I9fx+rV3XJU+T0dm25LsCk2t/4DNRti9JNC3a5tIT/FYuubT2XVMpb5m//
         ObNw==
X-Gm-Message-State: AOJu0YzoRlFtLpamXRsOAACHtjYvUuVLiHBEgKzvVCywP2M1k+RKqUdq
	x9PP/yrm4yGngH1WOct6wMNqDMPIJxzgC8sdakukaVcdH/qVHNXIWCPYMnEqvQlaInohAXSb7K5
	68VB6roTpAUrs2vyUT9yp8LJZiD0MFK9uSENmhBoaOdeGE9vZlWSZkMKPFCLvq0SvLSlaOK8adk
	1tD1KXpa4yXxBP7vajUqXrYW7QKx8=
X-Google-Smtp-Source: AGHT+IFkqfeHx8YzJAunywpRdidgNdjLeTtWgg2p4V4vZYTrR/3mutQzX2qxXb5fN2wPSUT3J1iB5pmTTg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a81:4c56:0:b0:61a:d0d2:b31 with SMTP id
 00721157ae682-62a08d9304emr35784307b3.3.1716984883084; Wed, 29 May 2024
 05:14:43 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:12 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-7-ptosi@google.com>
Subject: [PATCH v4 06/13] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
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
when generating function calls with kCFI to represent the 32-bit type ID
which can then be resolved across compilation units at link time.  These
are NOT actual 32-bit addresses and are therefore not needed in the
final (runtime) relocation table (which is unlikely to use 32-bit
absolute addresses for arm64 anyway).

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
2.45.1.288.g0e0cd299f1-goog

