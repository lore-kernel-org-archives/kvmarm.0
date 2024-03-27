Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B34314C5A7
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560984; cv=none; b=Xbhk49glGoAXr0/FN1l6ZP4FIGJV8nrpuZHb658MsAcHRE1Q9cHf3QnYAHJXrdkOwUa2fg4W/vRAM3mmDzib738vj5tmQwLZUiMZ9jxvY+MrsJqwxTYbTuxLBFknpSKchywPcjanr+FeZiVnP2rjFEYFZmU6iekAMLa6kxv/0TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560984; c=relaxed/simple;
	bh=DvEA2DsoZwN1b+8wToQ/5AET2wpS1QIPzq8eViMhxPg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jKJneXONcqLWDXokCGkJaGSvdKnm8Jh/SMyguf/Uc/ZqB8BlNp70EPDYEcSOwdkUQFKp65iLW+SQ/IhNTCDG6wbq+OA4A9WALyxHuEri5oAts5AdaqlfcFQPkAJdpjjLVYEff3vUYSDRiZso4ntLv8Qaj20+c17Q7MCsA18WKKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iVH+WHgz; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iVH+WHgz"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf618042daso69772276.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560982; x=1712165782; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GG/17rfXKx/eRqq4EbWCpiNZCoYJ682KJooA3YdXPxw=;
        b=iVH+WHgzfzCXo88gG6uIeATsqGzL4RwP1lPmwriavQlU7pmSG/4gRuzzOB0uzfkVtY
         EpXRJBSrpyFDyZLdPQvQFxdheOJCpe+Q7qZ9pxVC1gWCWsVmwJMFGp6cgvg/od3Wn+c6
         vFk9u5GwoOCH35lIS7/DoKLfBAt61FqZmJOOfXJf6Nea7umDLEbQCvXaMJ8Xnslu4JGj
         bkDvVz27J/UPCW7EsaqTSl+DFm2G/v+1MLh2pjpbFgqD0pymQlyX14AiUsIItBIcJPlP
         vnBOw5nMSoXjRk2tAkqw2c4U8EOlr4q75w+tqCm3frFpZ3nVL7NR4EWe9+vO1m9qX0JN
         2y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560982; x=1712165782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GG/17rfXKx/eRqq4EbWCpiNZCoYJ682KJooA3YdXPxw=;
        b=hjyMkIIk6osBdfq8Sd8wbPSctjypt2yQdnAv5+3/1gjGtYF77oMPuMnG5qquZWmqeR
         vocUOob1meEbHZNjqTTSVXK3czikO4uoF9XOF11weKVrnD2184vdIZbYNJ/LGsYtPIIy
         HnVKxfYfqugEki4QLgm5r5YA/23Q9xYQNYmIfiOFZKfKZAyuIiArSLh/wtbpScxoXw7a
         3F1Cayg/VEqTfQZ1+wkHRvQpNKRUesgWR4D+v47JOIHrQazIs3w9WEkl4HXTbN8MLN++
         O0Xad9zlaflYBRr6Pc/4H2fsH4k7eitdHOlOVUMZDfN57DZweELfwAdDiQNOekaWKSqy
         K1nw==
X-Gm-Message-State: AOJu0YzEid/zJ2T41RpqB4y7lqUwP4iMSJNhX4LomXrpu5tp/OISANrS
	7A+B7hY61n6ReS4/qplte0Xwf+NsbKftBhqc52OgaDENCIvqZU/1wSPNtyQsroVfqwG9GGQocJ8
	c/rSireSI8owWpbKqgV0KeRUkwCAv5DrYnKCe6j8Oykohad/U/wjyoEO38rqIRTBjGMKuhPMPKJ
	yKKbJ1bA/UrOv79ub5idYezhCSq7Q=
X-Google-Smtp-Source: AGHT+IEGAwxzsL1U3Lh1GidH2+TaWZoIimXq8Fb4bRfgEqs8/ppmU8IgZDvCzkx0BrIEQCE3ZP0vb7CBQg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:100e:b0:dd9:2a64:e98a with SMTP id
 w14-20020a056902100e00b00dd92a64e98amr60029ybt.9.1711560982568; Wed, 27 Mar
 2024 10:36:22 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:08 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-22-tabba@google.com>
Subject: [PATCH v1 21/44] KVM: arm64: Add PC_UPDATE_REQ flags covering all PC updates
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

In order to deal with PC updates (such as INCREMENT_PC and the
collection of flags that come with PENDING_EXCEPTION), add a single
mask that covers them all.

This will be used to manipulate these flags as a single entity.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cdbbfa3246c1..3c0fefb1dd73 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -786,6 +786,8 @@ struct kvm_vcpu_arch {
 #define INCREMENT_PC		__vcpu_single_flag(iflags, BIT(1))
 /* Target EL/MODE (not a single flag, but let's abuse the macro) */
 #define EXCEPT_MASK		__vcpu_single_flag(iflags, GENMASK(3, 1))
+/* Cover both PENDING_EXCEPTION and EXCEPT_MASK for global operations */
+#define PC_UPDATE_REQ		__vcpu_single_flag(iflags, GENMASK(3, 0))
 
 /* Helpers to encode exceptions with minimum fuss */
 #define __EXCEPT_MASK_VAL	unpack_vcpu_flag(EXCEPT_MASK)
-- 
2.44.0.478.gd926399ef9-goog

