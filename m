Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A33914A4F0
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823864; cv=none; b=ScmmTJBSLfJkxjbDuy42X8lot0fZl8qAoJI7Z3az0fMNG8Xx0cQ7Xu0zG4kTjOGQCS9v2m0CSyjS9zeanVAOsMzAZj1yxXzlyHgTdhfcprXCjLcrJdNc3ZHa8VDCtFgJ2qAtphiFTsrE6PdAGlwavxL44oybsqME7P786FCqxjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823864; c=relaxed/simple;
	bh=rB75pWAx4bl2HPDkD1L2il0Zdqnq2SU6NSMuJUFdWS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fvpGYBFSjDESQ0b+Lgni0RDtu1+udlg+6EtbFZBqOvCwwb+8Qwu85ckhETkgRXQUhuo+XYMFNm4emNeX34FU0W+mfgUlFjvO1dNUCN/kQFOZJGMuqEbIo1rQCs4jYbsjIa6gQCF9ZoCVblH+jfT2YEJp7U7Mx4mQ7qRV1KQs2kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Po+zylR+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Po+zylR+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770823862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4uMBqfdZsQbe7YIFKz45QFjnUCRjbkXzgrDvDI+qPJ8=;
	b=Po+zylR+PZ8LgGICeyAw5J6yRNuJ33T3GWyHdIix4XQ31tcTXoNtoRcmQN52LHzBGIecpt
	s8eJGdX3PLnDSKIaYQ7tC/mt5J6nQa63XcWzu1LhaeR/mi+sAlR3vTL7LCvilsLbkYWmeS
	Qgnz/Uw4FEEqdQyyjV1MEB0UwX+1HB0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-3OECydLPMha5J5aEiX3BTQ-1; Wed, 11 Feb 2026 10:31:00 -0500
X-MC-Unique: 3OECydLPMha5J5aEiX3BTQ-1
X-Mimecast-MFC-AGG-ID: 3OECydLPMha5J5aEiX3BTQ_1770823859
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4376e25bb4dso2421103f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 07:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823859; x=1771428659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4uMBqfdZsQbe7YIFKz45QFjnUCRjbkXzgrDvDI+qPJ8=;
        b=ABlExkjilnT8PaeZQvxQEmtjP26k/MPv9mRaS2uhtPmwmaoMam2tvF0RnfPfc/h4od
         iBosBhD0jYL6d2V94Cip8e3U/kVvPyrzemHDBAh7OngfjrmcAYFT5CDKw+gp/hxFe0qR
         oVZHB4PUIGbKtsQ47J3UcGxf59bfuTIPgkPMkxPFjfNhpSzr4slkZN1+13m7uMx/Y+TX
         CGlI5/Dtx3Pz0MuSNR4A0wQpAZhdEP02zD0vHYh9sgw+UsftZ6V5OCbzjQRh0SrLQww4
         1tzkRqGy5El7yzBXzQ7fpc/INia7JUN9cHsmq5PXwzQ0EotJrfoiMhgzf2lXuZ2w3fJN
         s0qg==
X-Forwarded-Encrypted: i=1; AJvYcCWeUEC+5RC7M/OHNQKSiMvdfMg2pozanB0vdLYO6OJ7A3m6BR9xgHwtfLHe0E+0lDiflrEnp/M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGrJKyxq7QikR1qU7rUQPJRXEtZ1HPALb5Z+s35NlWJWMvqW10
	epsQ5gcIt3kNrDR7zmhlmOroDgQqybrGdMwUnoDme6zdlG9+78dU64yAtVHZSMwDC3hgEokktrk
	Y5wL5CN2oZa9kJqGWlGPcWj44O12sZrVyIFXfiHDgEVOncNsVgTTrfxpKjQ==
X-Gm-Gg: AZuq6aIRai4M8rc7NMkF+fTb+VilO4d2uwkbHygxUReC7dKzg2vFZ3lqgOno+RxMjRe
	MLagYJBIf839Nll81Zn8DxwSaxbbYsKoq479r/gYvyzpa9+KuRMOCDGnfbTzmiC3jvc+47x/zWe
	ocX//wi1V8XNZAO8BNxfep/mCi2unCcM4XtoF7LdJemkDs9hZek9SYifbZMg7TBBZm2Y+33eOLv
	51F++ED5YM+P6XSN9wuXW0P8yv3MD4xOsO7GkcF9aka1RpMnpfyLMb6FaBXJSIS+4ovNSRgbAPO
	BsiVOGlcgJoHqDKskPGmtBqEmWJs6eikT99JEbxMGU2VPtpj4w3nHJq+Xzp6nOCy9YaKKF4pBCH
	81vuywlAtsOgjYq+wuimGpZgPv4BFLXlffYnstswRMxfk7RM38kmqk5v9eYKJXtq/Zb85QaY6sO
	FyFvIj5X0W
X-Received: by 2002:a05:600c:46cb:b0:483:ea6:8767 with SMTP id 5b1f17b1804b1-4835e2cd408mr35512135e9.36.1770823858857;
        Wed, 11 Feb 2026 07:30:58 -0800 (PST)
X-Received: by 2002:a05:600c:46cb:b0:483:ea6:8767 with SMTP id 5b1f17b1804b1-4835e2cd408mr35511455e9.36.1770823858114;
        Wed, 11 Feb 2026 07:30:58 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d34657sm6448511f8f.6.2026.02.11.07.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:30:57 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	Stefan Weil <sw@weilnetz.de>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Wed, 11 Feb 2026 16:30:31 +0100
Message-ID: <20260211153032.19327-2-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260211153032.19327-1-sebott@redhat.com>
References: <20260211153032.19327-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PviDwQPWbQz95ba_njFzThprj6iP_jv2qaCRmE_4CUw_1770823859
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add constants for PSCI version 1_2 and 1_3.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Stefan Weil <sw@weilnetz.de>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Eric Auger <eric.auger@redhat.com>
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
2.52.0

