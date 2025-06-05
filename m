Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912A521A449
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749119829; cv=none; b=aWPkRHN9EcUU8pUhzexERvy5n+5jkVHzpuHNfORns1EM0hynB7yd+DrMuBnv3MNX82PW8mBfqa8rJinY667b9Pxj8AgNYkw6w9iU6m2wyuBNOMtH5NLj26Rhc/SWtmMKFi+g1yEACgoYs1SgE+aiw8szuIyYWDpl3+x9ARjP/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749119829; c=relaxed/simple;
	bh=9XeYGeARuady+jct2m+tvWS5mZLD2RXXr/jmj8/Q/5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hiY0njvKFI6nikRTurkOSh6WcWKWgI5WY7Ww1KzXNJdZNMTElSGB3MS/UXitoarGzHU36DKrv2WC+0j83lhxgz1BeF6d8gEt6wE516lLK/I2Kdldr6UHaLvhvwfS0OjBXJrRrQd8g4+9cYyW3K+uvc9YVgnhQapZrXliplenTcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YA3a4Kp+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YA3a4Kp+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749119826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rVhjvVcIXx5T86Gzf/rZsso5uT7BOLjFW6qVNZ4D4g=;
	b=YA3a4Kp+MzlEnyDLauyr455rhusV/KhctdkhZTXz0P0J4b+JxR2VlUQT6Ggi+JtDJwv6s6
	raEXl4DFbR5KB3RDlMZhRpjTTE3WX3bIvNq7goeky9+NMMVgbkw39RIsNMwmy34Zvibwpf
	myBA/SXCyUpm5C821sE2nzZKWn4MYRY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-AO2y5V9JOVCBoptauQG92Q-1; Thu, 05 Jun 2025 06:37:03 -0400
X-MC-Unique: AO2y5V9JOVCBoptauQG92Q-1
X-Mimecast-MFC-AGG-ID: AO2y5V9JOVCBoptauQG92Q_1749119822
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442fda1cba7so3979145e9.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749119822; x=1749724622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rVhjvVcIXx5T86Gzf/rZsso5uT7BOLjFW6qVNZ4D4g=;
        b=Ku/Jphh4Brsj0HxWBVz9BEiK6GKHrccKtGKl2c2pKF22WWkkuk5HXLqP2KnQAZlDU4
         X4zc4fenAOpB9Nh0uxDcp6vI6AMgT1wsx4yS+gEzb3gFYZjrubCRlS5OYtJF+dFjMgvV
         Kd8heHFZxQ9khydYRzn63qjMlnGI8OuwG3qOv/55tvH+jsBl1GWA2aMov/VSAKoeF5Fd
         3CngRZ+2hOL78xpOii/53PfQBtXskTPdAOveaa+YwyNmdHTB//Fuo8WbgvnrrVoSRI+Y
         3VZtz55ouZYigGAdaOU47N8v7F7F233XcHYC2MfCwkkeytLhbBOSgwQSPoS260rFzAx8
         QKxg==
X-Forwarded-Encrypted: i=1; AJvYcCUnm7kQI0iK6JQTYukjmZIvfxJNcdLB+5qSn/AjZ2RwTPtGnmby20Q2Zoi0aCv0CVXgH3CEbpQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6WzObIXMF9cNdNWdHz0LXReD+fJWExQpeZfMPMH8jf5LnTUVQ
	5idNF1YSQGdxEkrf5NUDKVObvj5lnvmgU8HptVHd+e3OKylS+Ys/Cg6hJhBG9gG8FkV5qaIm3P0
	5yx9wj+oIj4xMeM5mspbcjskmX7hHByImqBaTxHzmiKqyRq45WMucDzAZPA==
X-Gm-Gg: ASbGncsjIAdoqDSeUauXswm2ZKucZBIMWBCbztSX3fD1COG3xLsvW/CIWpNoAKpZEfu
	gsIF4AaUZ3oT1P7Y0rSuQhPPea82yNJkp0mATbYIly7fQT+1Hi9dkX+nQwcjEqswXdPoRJokpAA
	eAvTZK1wvCqzhEatNuZCGXZW3HJEpSj1+OEfcOCFr2oeG3KbNoygD9mOaLgLkQpYAj06S2/ueWJ
	Z27l8NjmG7rbPE9pipUYUCOp7tyYM2SKRREazGdaUL5doWYu7JV/Y7sl/TVXLMGX85zZ5IS5cDM
	NxbsHBY9l7k8i2g1LDEVPp8zMvGH0dC6lF4Hq32MQs4kRMMJRSw41BUY+co8XcLdGjKF65rxCg=
	=
X-Received: by 2002:a05:600c:46d1:b0:450:d5f6:55f5 with SMTP id 5b1f17b1804b1-451f0a6a475mr59189945e9.6.1749119821945;
        Thu, 05 Jun 2025 03:37:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGl6x7gVIPWibQhMLU8nel9VytzISKQ2PPkA0o/8Tg4UeXbk96NsVZsi/1KR13ZEgWYC/qLMQ==
X-Received: by 2002:a05:600c:46d1:b0:450:d5f6:55f5 with SMTP id 5b1f17b1804b1-451f0a6a475mr59189665e9.6.1749119821528;
        Thu, 05 Jun 2025 03:37:01 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f8311ae6sm14105175e9.2.2025.06.05.03.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:37:00 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 3/4] KVM: arm64: selftests: arch_timer_edge_cases - fix xval init
Date: Thu,  5 Jun 2025 12:36:12 +0200
Message-ID: <20250605103613.14544-4-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605103613.14544-1-sebott@redhat.com>
References: <20250605103613.14544-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aH3Ey9ZpgWyzFhaG2IpRpnT9Lsrgl6elm_It2Zq2yjU_1749119822
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

arch_timer_edge_cases hits the following assertion in < 10% of the test runs:

==== Test Assertion Failure ====
  arm64/arch_timer_edge_cases.c:490: timer_get_cntct(timer) >= DEF_CNT + (timer_get_cntfrq() * (uint64_t)(delta_2_ms) / 1000)
  pid=17110 tid=17110 errno=4 - Interrupted system call
     1  0x0000000000404ec7: test_run at arch_timer_edge_cases.c:945
     2  0x0000000000401fa3: main at arch_timer_edge_cases.c:1074
     3  0x0000ffffa774b587: ?? ??:0
     4  0x0000ffffa774b65f: ?? ??:0
     5  0x000000000040206f: _start at ??:?
  timer_get_cntct(timer) >= DEF_CNT + msec_to_cycles(delta_2_ms)

Enabling the timer without proper xval initialization in set_tval_irq()
resulted in an early interrupt during timer reprogramming. Make sure
to set the xval before setting the enable bit.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index a813b4c6c817..be8bbedc933b 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -191,8 +191,8 @@ static void set_tval_irq(enum arch_timer timer, uint64_t tval_cycles,
 {
 	atomic_set(&shared_data.handled, 0);
 	atomic_set(&shared_data.spurious, 0);
-	timer_set_ctl(timer, ctl);
 	timer_set_tval(timer, tval_cycles);
+	timer_set_ctl(timer, ctl);
 }
 
 static void set_xval_irq(enum arch_timer timer, uint64_t xval, uint32_t ctl,
-- 
2.49.0

