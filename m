Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6F226CF5
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 14:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746801217; cv=none; b=AV4tvfiLOE0PhI4d2wNvLlwcDOUMM9WUBpkVPB3+ot5cg/BeDM76FQmtvYtmEOPq2Rv31Q9Gqwvqo6Lo+jL/Jt8DoFQM/bCfL83QVPbPlQhpnRqzYlYT3LuvozPwKTXnNgUmGNV+KwPh+le/d9jaMOwwHA7x3X65fHzwoXXp6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746801217; c=relaxed/simple;
	bh=naf0ZTgkhlpI+qKa6xvqWgk8ol/hCC97goS1SGCaatU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ctlZvWeJAKOGx/zJWPci9cL3iwyDCcfMDC1O/ds7ZtJrZB7pzqBvUMOa2cPchtQA/j+HgthnhCKdsrux4PiybuRzNz0OVPW3Tp5cE4yjJDAfF4JJ194FBTq6lGU5nO+B9Ned0vcGiAuDvB+Y47AL9b4H5djOt3Ib+YW3iFVrT3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OhfGEIKD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OhfGEIKD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746801215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6L+bu3C5bNo3IB9ZkU52/sTrMkPyP3mUjU6YriIz+Oo=;
	b=OhfGEIKDaLAn/1CnKYOHKqEPZBxf1SfR5v4FFPWi2jf4HP4gvnPFxYazRk6ISD5grz4t5c
	3F5d/GZA1/aUViyEhqM9p5Fh7RdLZA2Gud9wzoX1jHTfv1/qTOXBb7bmLuHDz/ZAdXpo7V
	hRdHVnmpyJoYeSjFpD7NCwXgiUuQHc4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-kPXtLCyqPtiykkbpTAlDdg-1; Fri, 09 May 2025 10:33:31 -0400
X-MC-Unique: kPXtLCyqPtiykkbpTAlDdg-1
X-Mimecast-MFC-AGG-ID: kPXtLCyqPtiykkbpTAlDdg_1746801211
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-441c122fa56so9149265e9.2
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 07:33:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746801210; x=1747406010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6L+bu3C5bNo3IB9ZkU52/sTrMkPyP3mUjU6YriIz+Oo=;
        b=BlwYTC3czqATdPPzsrl8TPCeScl5xFc0yjFwVoMhJg9XpbN1ng/jQRV69Juz5Kj+yg
         FbOlMUT8jKm3/ucnmHkUvgOmTX8FuZkk/YNl/MsB2mKebucsNMG0GsbVd5gCd/k0qVKx
         Cjxu+R2GoCW/MhMGdO2QVV0j1nH5hMXcOHf4Y+PoHjDAKSe9lQLiyeX9HZ9RJknoXLKo
         JT7/PNOIOi/NzAm8a+zorgVA8xhSFi7ynk5VxTiSbwB3I/3Kc6+XlLvDrQ7yhmd6aIbo
         MoscPLuO/u8t2GkYqP/Cf0Y5UIoRDzyWupf24EhH53WujywmoUxiLWMOZRkFscCnH2Fz
         J15w==
X-Forwarded-Encrypted: i=1; AJvYcCWoeW/YBQsK/z4hhWaSut1uC/uooVfSpY74eejtkizt6hnflq3Le5tNMTHtq4yjWwobmVFsmGI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxwf+26SkEO3sbAw9fvg5KfuVhs22zvhL6PUMi/oWqa37aQ1BYL
	0+w8C4FhKNWC1FJdTXMLuQTd2rIF4Ii0dpuVACF+HXYifXNr0mL8VRHfb6wiUscOZMVfLlRrZL6
	lPZQXiuk/ciExaEMZtt3pz6ETVEsf/J53PQ9zZKLxI4f/kySt4m0l2g==
X-Gm-Gg: ASbGncvac396rDj2wYmvjTNMZnLJOaAjRhRNMPBitgctPpvlFoERc4/oytAk4YS0Xxt
	HpOx4U74UeEZi406G/FOB+EJOWLUERRFySGoreqW0vKSD2X2L/txLtDaIVPQzXzjjgMFEpPrsU+
	YdCL6vJa6O4jPWz735nEVoo7ijUdhwOByOGfhNQ9JLv+CquqXMj0aTWIseDOgmKb3HnZU8hfhBR
	xqLzdtgGe49zQQz3zGWzEtiCcK9iO5JyjB7A3BaHkjvG+VbBhSqYJryOQdVHgrJJPlKtGSmX/iP
	cVLMoHDlB88oyptaGy64g8N/oT+s5JNwDoFI+1XKHgdlDKNm3QNG6jQMSLK/N34AOXqbLt5IRCY
	=
X-Received: by 2002:a05:600c:a42:b0:43d:24d:bbe2 with SMTP id 5b1f17b1804b1-442d6ddcff4mr23932635e9.28.1746801210566;
        Fri, 09 May 2025 07:33:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkHBgasEQcr/4ZVQSpWJmPLcvd6o7zSPvgSmEK9zaLE7PuQpFCA6hRhF0NO2Opfzb52f6PlA==
X-Received: by 2002:a05:600c:a42:b0:43d:24d:bbe2 with SMTP id 5b1f17b1804b1-442d6ddcff4mr23932325e9.28.1746801210127;
        Fri, 09 May 2025 07:33:30 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67d5c7bsm32150775e9.4.2025.05.09.07.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 07:33:29 -0700 (PDT)
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
Subject: [PATCH 3/3] KVM: arm64: selftests: arch_timer_edge_cases - workaround for AC03_CPU_14
Date: Fri,  9 May 2025 16:33:12 +0200
Message-ID: <20250509143312.34224-4-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250509143312.34224-1-sebott@redhat.com>
References: <20250509143312.34224-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z4hrmOlWDYF_OgM60I23GBH1OCHxgrYa93IDMf73xrg_1746801211
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

arch_timer_edge_cases currently fails on ampere-one machines with
the following assertion failure:

==== Test Assertion Failure ====
  arm64/arch_timer_edge_cases.c:169: timer_condition == istatus
  pid=11236 tid=11236 errno=4 - Interrupted system call
     1  0x0000000000404ce7: test_run at arch_timer_edge_cases.c:938
     2  0x0000000000401ebb: main at arch_timer_edge_cases.c:1053
     3  0x0000ffff9fa8625b: ?? ??:0
     4  0x0000ffff9fa8633b: ?? ??:0
     5  0x0000000000401fef: _start at ??:?
  0x1 != 0x0 (timer_condition != istatus)

Meaning that the timer condition was met and an interrupt
was presented but the timer status bit in the control register
was not set.

This happens due to AC03_CPU_14 "Timer CVAL programming of a delta
greater than 2^63 will result in incorrect behavior."

Work around this issue by reducing the value that is used to reset
the counter and thus reduce the delta.

Link: https://lore.kernel.org/kvmarm/ac1de1d2-ef2b-d439-dc48-8615e121b07b@redhat.com
Link: https://amperecomputing.com/assets/AmpereOne_Developer_ER_v0_80_20240823_28945022f4.pdf
Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index a813b4c6c817..2f0397df0aa6 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -31,7 +31,7 @@ static const int32_t TVAL_MIN = INT32_MIN;
 static const uint32_t TIMEOUT_NO_IRQ_US = 50000;
 
 /* A nice counter value to use as the starting one for most tests. */
-static const uint64_t DEF_CNT = (CVAL_MAX / 2);
+static const uint64_t DEF_CNT = (CVAL_MAX / 4);
 
 /* Number of runs. */
 static const uint32_t NR_TEST_ITERS_DEF = 5;
-- 
2.49.0

