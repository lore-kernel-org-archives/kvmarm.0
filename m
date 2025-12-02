Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41822283FC5
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 16:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691744; cv=none; b=HiowFHEWWMhtSmsnAXJjCecSZnH+HD8muumTzKHKao2oCBimAshnI7DEmJnTbpa9Mkjf4NTx2AKdVeTzPRUzNtbAbjsDbqtjRRMlKh2rzSyDSXxk2TGalKMHMIwWb9MtfNAyvRuiNyV1diZkJ6FUIU2ggcYLbVmuxbDV3oF30Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691744; c=relaxed/simple;
	bh=5Yb3X6PZiKols/sQXmoknfK/pTPbA3jLRfEhVBUsSgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=JOorxbPOM0rThxIr9u8VeascEX7yny4cHjUObTHgu2OgmRjPVa6jEjhzoc2nWFB5G5Jswq5vbhNwuvq0dHXiqk/C3jo6ojPgny2eAWKaCiqa5+MTX93V2UjXIhLt07z2O9olwWNdjOW6X63Kln00qq4E9Y5YBI+RtlyaquugTzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IVx8cYxK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IVx8cYxK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764691742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
	b=IVx8cYxKOmOe5GXguHj3oiJc9Ats5Yk+2HGqv0u9sNA67dcmoF9fiQRtK4si/Bvxv1yDuX
	NQzHpDCphCLMGjJnxOOt2tAHtoT8e0SzKz+BZQ43teXFrRSPorefybonGUXiE4nZZXqgbt
	WoH9nV6Nhm68jyXHFxOHOVGTnTO3Edg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-PhnVz8P-P-C_J7l2jThTLg-1; Tue, 02 Dec 2025 11:09:01 -0500
X-MC-Unique: PhnVz8P-P-C_J7l2jThTLg-1
X-Mimecast-MFC-AGG-ID: PhnVz8P-P-C_J7l2jThTLg_1764691740
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477c49f273fso55261925e9.3
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 08:09:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691739; x=1765296539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
        b=tVdXlgQ2CVBdVqOOVLDb5DOrQGmMzTA2i66rWXHsX0Ejf1iO9MwGwgglWjgy29ZHF9
         QSVpVluzCcs2TcvQFxLLJRdvrjYl38WR6s08ect1HAs/vgNOHM7alZcHR4omC0yZka8q
         U7T3kJS7v/CsSrrzuiJ6Rs+AlQvARrtskPov7DHHOAGTTO2Tjt3oHB0+87Rdo/YQg9YF
         gMm9pLIiZcGMv4EiLUmNRXjP/hZ4OWPazbPhnmn3HMi0IGAInw+fgIB4Ik2r0RYFAUYP
         UGAHMKeAG5tP24Q5KKbYzA/86LPctN6JCaVAVa5UGI8KneDdxgKUYkArtkavCZerVb3A
         hUEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIQywa5tfb1sjzfEoZV2sIE4cIVLO+gknCqJY8kEen7IJ56w2O6F8K1fjEt2cDIZz5u3nrUSc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwcDXWNMNP/+m53gVawl/MZurgDlS2oyWwq+JJmBUc+fj/4rjt
	aZ2cXl2CENef288oT9nSkn2E40cYzab0wA0Jg1D3Lmv+x2CPBtKnEJvPj0LZ/zKh4C0oEXaP2zZ
	kRGFh0+7dIYKMfLxRiwrRq7tcV7ZqE6AfAO5RgY9FEfXlfb0wBS2Y1BGM8g==
X-Gm-Gg: ASbGncvZI5dgcIRftiwg+UTGLXllREFkU+RWTSzjDAGI9vrMDNaX+NoyjObtw/LO2WM
	0cBtW0JNGOtuR0w7OkrYVlN370MfmGynTGeM6kLbgC7ZfWYpZdv8jRdmnFnsM9AtY9Ooy0Z9wyL
	iA3hCxDL7m+gATtGq0YFd+ze//5Xp4AJScLyYeaE2FIkDN1deW+Z973uxUISF/6frR7BGHzqXrp
	erfm5MC1+6yYHZ/5qiBxS89IN0Jp/GDbHCBbiRbCLPAS42Ojzwwv8+n66CW6NJxKbclbj4gQ1aQ
	6AuBXGiUMfXqFeCLAzY9LWERzXJrwowYzxq3ROSofBWL94FMwe8zKTJIIQBp4h5aU9zrIafLS/K
	dZQQYgn7SJCsEInSc7eiH+X1ulXnF6vjTDTshC9CQeAxoYmp5SRnGwUYQF5QDUSPRwj99dEZi
X-Received: by 2002:a05:600c:1c8a:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-477c01ff636mr474350625e9.32.1764691739647;
        Tue, 02 Dec 2025 08:08:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCJcOKBkToQRQqCimSXYNAuCA53uuEuTDBUZ/jgsC1gwfTGJxcvlPlmY/zYIMOG9XF+jmUlA==
X-Received: by 2002:a05:600c:1c8a:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-477c01ff636mr474350245e9.32.1764691739282;
        Tue, 02 Dec 2025 08:08:59 -0800 (PST)
Received: from rh.redhat.com (p200300f6af35a800883b071bf1f3e4b6.dip0.t-ipconnect.de. [2003:f6:af35:a800:883b:71b:f1f3:e4b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa767dsm34300899f8f.38.2025.12.02.08.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:08:58 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v4 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Tue,  2 Dec 2025 17:08:52 +0100
Message-ID: <20251202160853.22560-2-sebott@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251202160853.22560-1-sebott@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: myqIMnZxQdFCtFRul7ICAE1jEOrbyhFP9pZkv68yYiI_1764691740
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
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

