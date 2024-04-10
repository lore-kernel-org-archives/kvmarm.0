Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680CD13D61C
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 08:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737752; cv=none; b=c8KILY93Du2niPV4PX88pU0TCS3DEPDT/N41alVMS4aMLRxo66i4gRQ4pVUAAqxSxbw2ahgxnAng6Dgwk1+Bv6rtt62nimETDD4boJDPrVz1R7LNe1uaGNWuzJ/yb/Jay8o3EnwCYjOH1E5t9o/6x3JkeLEAZRbKr4Ncue1lCxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737752; c=relaxed/simple;
	bh=kgnqMQDzRwAX/8s3ORh3D/qKYGRwk7ltldtZkzXhbzU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Lc30Lk7kcFuqhg+4HuiDreXbJNYbJb23qyIXGPwr2s9kf9Is2MvZGY6fVGm6n0VhG48FTjSvE1lTKf3pyU7G1Q1OH46XlKP5fAdx+jAmqW+2Tq9Yeb9QBN1xdfF8/dKI/kAb1oS+FE0lfl79nkx1n3M8jt1QbeCK/gyiJAPQZi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=11lErzHA; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="11lErzHA"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a51969e780eso793185266b.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 01:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737747; x=1713342547; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PGd3bMV1YAEF5Hagbbpcdm+V4PDQlrcvcx2hUHTQ9g=;
        b=11lErzHACe65PpeGG63hqwbWKDEclni5wmFJ9LQnKtVpj6PZnmE3rK7ufKpngFzKv/
         0voc/3SpmQdJFcte1cpock7pzveoZPBBc0SLAeXEL2e4LeBk031/5BOjgqREgEZmlD+3
         6YzSDdrQ0fw2+LDeXMTpulQX/MwZa8NjN25ZfLjY5RvahdH6gv3DV6gfpnvBq81mIVAw
         5OOpXn65XfXhyTEGgPv3eoHKlKUAP2lUlCzOJ8K4V3i5SNWVWhDjR8hyUYFoUVVDqUDb
         m9MyANT+XE4Y8qMnc60ddU6W+xMcZQ5u3oLmAxpSIZEgb4u6ICwLVIP1WCuKpL8hK5q0
         j0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737747; x=1713342547;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3PGd3bMV1YAEF5Hagbbpcdm+V4PDQlrcvcx2hUHTQ9g=;
        b=PceOtP54lFW6TYFXxRRylnh8EYPJjohAUIJatWuLAM+21/JNG51TRn3htQeuqAS2MM
         9fsvrLTZm5SH+PS7WkF6D0nD+Yv/QSL8x96buJhEg+LaKxfiK1lau0ophuW02WCnRHGJ
         AKaeExwSMvmpoOqoxGoe0pESoXem2Sw4ItMDlF1kWxfShpHhOBjTHXNr9Ea0Xu2RCEG5
         khLGH+RoHkJeyJU3G4HLLEpfsTbphOPWSRH8VtWeNQKo6hma76oWirikkVM0oQAlvY6U
         Nu3jA2sbTys/R2HU3zcHZfpCtoSYTYda6q4zDzWNxGpKQXXj9h2QTsvoogow+0NO8Chk
         QZvQ==
X-Gm-Message-State: AOJu0YxoCtcBtvZGeTKIwxYtbzjEeCSQsk5XAPb21a1x+Suod9WfnI/E
	OgHw16FAQMXT4PFWpzP2DxUrpTppoGrL+vk8ynK8skK7M8r02LriIdeEAxozjflLWvnmQ0R0cAM
	y/g==
X-Google-Smtp-Source: AGHT+IH61cn+dX4vldfSxdcYm9FVH61Ciw9ZsCjHLsITsN4DKWMU3FJ45IW/shiIDSzz7xSZXKNICg==
X-Received: by 2002:a17:906:490:b0:a51:b326:ed41 with SMTP id f16-20020a170906049000b00a51b326ed41mr1201398eja.52.1712737747375;
        Wed, 10 Apr 2024 01:29:07 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id jx16-20020a170907761000b00a5197fa2970sm6678498ejc.25.2024.04.10.01.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:29:07 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:29:03 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 06/12] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
Message-ID: <iyqimnbc75g264riny63k5y3tujiz4frzsexaiy5pjnla4cvfi@xzvncd4em5cs>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
the relocation table of the hypervisor. The toolchain might produce them
when generating function calls with kCFI, to allow type ID resolution
across compilation units (between the call-site check and the callee's
prefixed u32) at link time. They are therefore not needed in the final
(runtime) relocation table.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
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
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre
