Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6B61F0E39
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757602176; cv=none; b=GKCT7glWgTVBVYcPaTtrGiRyaRxDgMXFKQgqckprtd9FXIKoPN5nvzX/H5N8ajv+4xGyxHy1SawaTvlODGIREB+5nXf5iU5T5UsMp17377Z+p95SPv8Xr18JFHA92IrHPKCZ2bHbIxy3OqPJTj054d9P19nqoZLv+4SyKaPzfrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757602176; c=relaxed/simple;
	bh=ykqcLBsCxyMRFiTl7Thb/eUaBwmC39ARNaHnK0Qqi/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=O5m0Xle9H20uUP126m6QZo9reajUbsdAVRnpAEhhdGxqX5LJq1oQEGB1mql7RCIIdvDQET/1/cGRb2CgExrfXw9CQQqGFSPhhWAdHMd6j444pt0/hPGfo3vx9G7S/DDKBk/l9Ft9sKGP9qUu12fq8/Fs7dOt92KJm4OPoXxquM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IxIlN6zT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IxIlN6zT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757602173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0a4n2ZzYOr7lU8ApVVE4XfictzucsNLVIeb31abwSM=;
	b=IxIlN6zTJKSyUnIkusCgAbeGLYdZOqn1xJmSQx7YM6+68jdos2QfiD1bEmubSkwZNjwTCS
	wpA/BXE4BZ1sqNcVf9TIT6RMQ/YqnDqS0tnoweiUJcpt8Hyiu5ZHK7IWj3Me0FXWPQDM0k
	7ufkseRk6mVcZUbITHqsnENA88tV5m0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-K_tdpWqVM8KA-0Xo2nD45Q-1; Thu, 11 Sep 2025 10:49:32 -0400
X-MC-Unique: K_tdpWqVM8KA-0Xo2nD45Q-1
X-Mimecast-MFC-AGG-ID: K_tdpWqVM8KA-0Xo2nD45Q_1757602171
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e014bf8ebfso650118f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 07:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757602171; x=1758206971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0a4n2ZzYOr7lU8ApVVE4XfictzucsNLVIeb31abwSM=;
        b=pPVbGpC9o5e4bhe1EHEmEWBJNnJ3/MMweTGZ1WVIR2tucNvPFuYDU+j0f7RI/8VflC
         v2QB7kmoMju+1s+DJeSmUmCb57KcxI3AbS3xGpv3NeA0eWCeKwQfqRYgH1+u/70SNQnG
         iGzxb3sMjJ76GjJs8/qkqMn7CP6iRLU1lSS8RZyyCgqX/pwcDIyadqFdGYEcScO2NDPQ
         V8r1IiRCvbpsHOs6TvQwLCBHW56Df/whMGPu1EIojwfrVxB4Ufvdzep5kLRIzkiBKGP8
         iLmsTwfEsKbv7vwjSLIVv0U3JdhEOB6Rs0GoUpkDkvEGx14/rhM3CHl63yMRkY6fspSD
         v1bQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxTfhEcmRLvazW/BkvMYuzJCsL+AxlMmTH1YyZ/ffHhZfWp1jGm5fyMy/kRICieFV9wXOr6j4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwkVNexu1kYrI4eamIaL+4sYjPgEA3YwywtcEX6G7vzhKHyrNoP
	9BcI7BmtbCf5WycDQZwiPJf962w/vU4MIZ8YJr8C6RlKylrfWgXt9X+nxtFf1c+OCZc2Kw/zXTY
	2Fj8M59DXlV9rAGxne/x/b6O2Tni3wkmYL1u7k+QEP6d4I0Vjn1HIABAFlQ==
X-Gm-Gg: ASbGncvqQYVR7Ra7ovB1EOkA4HykfSVY8eGDhsv+cVup2f7XfBkcuDaYN7Bxxn9nJhL
	QVBvQ/hvxvZPoo+4hRe+ums2LnIx3IGZEI8AQp+pvS+8yfFx9veHD/RuUR/0Rj9GMwpugMLbBhZ
	yFHJsjd581es/wPAUc3NmuAbZEcwl0NuVLviN/0mXFiQ3Epxr0cuVeanRAdafGmC6tIJtnPbxQR
	xnIuJxFqQ6aytT9i0ETFctigvp/q83zgiG5heNE83BvKBxzFM9DWsXhGXaGpMSmqfnQfgnHORQ8
	bNkrjNEG7x2cXl5QYxviZW+WlYkohPIatyOkqIvISDR6whFUTFVgm5ijQgtezVRZB0wUVyTgIoO
	HvJjaZLqUL/u5pdftRu0uQZ4Nn2nc
X-Received: by 2002:a5d:5885:0:b0:3e0:63dc:913c with SMTP id ffacd0b85a97d-3e75e0f0321mr3085769f8f.3.1757602171252;
        Thu, 11 Sep 2025 07:49:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw1IcstkmaYZN9of6DaQnGTrA008KACS07maSaSJLOzYY0ys0I9zEDtisEheF3g2dnd82HYQ==
X-Received: by 2002:a5d:5885:0:b0:3e0:63dc:913c with SMTP id ffacd0b85a97d-3e75e0f0321mr3085750f8f.3.1757602170839;
        Thu, 11 Sep 2025 07:49:30 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0159c27csm14941575e9.8.2025.09.11.07.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 07:49:30 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Thu, 11 Sep 2025 16:49:22 +0200
Message-ID: <20250911144923.24259-2-sebott@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250911144923.24259-1-sebott@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LkH_K5syGYhmAWeQrUlvllS-wCiJkLmIXEYRcvg9GGE_1757602171
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index c44d23dbe7..239a8801df 100644
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

