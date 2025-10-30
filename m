Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EE031A577
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843557; cv=none; b=XvpUUaZ97SW1R+BdCodirB+Fo+ALFrACskNmLfMTl8myLSzzdRBxhlxjhAzsyBPv9wmG40U9IESRfqZEIW9oAMEBBwhY06wa/znT8wEXEpZIGfAaIlzMlttpBSyRniIPRT8Fw6KXqMvZ4N6u+CNtEX+Rm59wUpeYmJ9SeJn05N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843557; c=relaxed/simple;
	bh=w4AiSi8ptQwSr8mcpa/oN3zet3lqMxfDUN+SznFdMFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=tobSCLtSyrq+wrGEoXZ98L9gx+2Kl2EjwReCoMBKn43miI9xrmZqSHxS4Zc1ryYRHpMr5zBRdFDGmwg/E6eII3I1BR5epdszwAHU6qwo/HbUlVj7LQ3p7qH+UPCqF7JmK0cHAjllCQOLtrOfUYscCjIjzk13jMY9NMDaNOpEHfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D0APvWgf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D0APvWgf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761843554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWmmkEUNuPGh9RNwegX9zD/J9TxS8gEM8JXHywhlakk=;
	b=D0APvWgfLfkX1gmPlEWoHw8GdSSO/tQmoXPKJnBQM0tLWQHA64n6tnapQU7Ob+jhPzdLOO
	RWgZdjD64BrudZd5kbx90rPMiZZMaS9I9Re1KIrnfqZTQCgla+tIvREu5ORS+y8YVVHV00
	ozuJsielmftjk6TKPhwSJqIng1rChHU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-s99s7CJLPLGaNJL0e-Xblw-1; Thu, 30 Oct 2025 12:59:13 -0400
X-MC-Unique: s99s7CJLPLGaNJL0e-Xblw-1
X-Mimecast-MFC-AGG-ID: s99s7CJLPLGaNJL0e-Xblw_1761843552
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-475dabb63f2so5969305e9.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 09:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843552; x=1762448352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hWmmkEUNuPGh9RNwegX9zD/J9TxS8gEM8JXHywhlakk=;
        b=oQfd6n27zyKAcPWGbBoj1Zrj/GpfY2YhBk700iPKBL/O0+Qlqo9XiEeHguaezbe9yX
         FyMhhs5sIxBtGBiJVT3LKQm708D4sxruJ3+ZKC6w8kaj2VQ+qkaa7f1uz5EHngwlakd0
         5TDydOYrFq2qdfa/8VG8UGYGNwrdiMCvNr/Ml/1X6Z+cmsfUHtLcBuW3uvQD+A68jjdw
         ER1cg/RvRr66UdYY/oZOWXJ+KlrsZH1wnizV07ec6yo8wywWGshtlWM0tyzZiCta/jB/
         GIazja0q7CRBRBqRmpJ4805xL84kSxQFCztETL/OJBs9g+Cj2QiSTn/Fsk/1YqgKXdsE
         HDng==
X-Forwarded-Encrypted: i=1; AJvYcCUJ48vE37S/J7n0zDUWWvDTRUYP1iBRi1luKqiuWRNo56w7HRYK30wJ7akWBFzMGvYWckm4S3Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh/tlV4RybnS+YxzPS0H7gm60mBttPucLPimGZsUG0aoz4lWNZ
	ni++fbNOvJHMeTg32NkqtlMcR+VeqoYoj83VlS3FsnHGlqsmEzHqORRMY7XINn+t/AZI7FpRD3b
	rBl3J627CEnKk7ebMXd3V5K5ZOahAI06KjhOYhOBmZgxvLIWUsEc8VrsMmA==
X-Gm-Gg: ASbGncsUDOLShL7l4TCYa73smxGPFnK9O3jnY0im8b55PwoXmkJlPJG8I7k0MS/jDYB
	uAsi3f30T2xaKTQHRlwyEUnIwWtG5ES3tqp9KDAH6+CSqMsO2DkW8qhGrPUOD0azafYovua9rcF
	CDTMW8m2CMnmvuUFdOwzvuWHkXSbhqXyj77x1Pa0H4FEwjv97X8b5PnQD3kd1vzc+vAJ+4/eqKh
	9xVFz+7zY4zmADY3MAYHm61BJ6T5Yxb1WMPHsyNuYbLdbEBB0hpqNf7ogk2PTR16Rr5E2ikco/t
	a3Y1dw5T6Qw1VpLMHFtt4x5uhBGyqlzFeM+gkvPh2atnR5LmfnZq/ZR+z6GqArgKuHRiBwzKcAU
	bCxcysOg1H+Ooysc3siTF8/7Q66cewk5IUvd+bHrbDSTKJIkGEk2X4xIOSmJPnQ0=
X-Received: by 2002:a05:600c:34d0:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-477308721b1mr4431715e9.25.1761843552025;
        Thu, 30 Oct 2025 09:59:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdysDVvnycX2QFcyER9PBsXwHxfA4shM0ptgu5S+ePqTnpY3IFDLDiXiVx7sJ1KtjfLnplcg==
X-Received: by 2002:a05:600c:34d0:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-477308721b1mr4431485e9.25.1761843551618;
        Thu, 30 Oct 2025 09:59:11 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289e7cf5sm51104085e9.14.2025.10.30.09.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:59:11 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v2 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Thu, 30 Oct 2025 17:59:04 +0100
Message-ID: <20251030165905.73295-2-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251030165905.73295-1-sebott@redhat.com>
References: <20251030165905.73295-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9c8SGeVIGa6CeIDunQNMrzw8OEnfZgVZQEAySdhXUeY_1761843552
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 54ae5da7ce..9fba3e886d 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_0_2                     0x00002
 #define QEMU_PSCI_VERSION_1_0                     0x10000
 #define QEMU_PSCI_VERSION_1_1                     0x10001
+#define QEMU_PSCI_VERSION_1_2                     0x10002
+#define QEMU_PSCI_VERSION_1_3                     0x10003
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 /* We don't bother to check every possible version value */
-- 
2.42.0

