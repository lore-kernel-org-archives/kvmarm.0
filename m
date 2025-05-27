Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428A527700B
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748355887; cv=none; b=U/f/gs86BBtnhEJSu9qUlOpFuKACuRjvTJaujOZwn8EI+5agxb0tQM0BSdzTURO+tVJkKRCha3Mx3lbSt9YB9suNRUAhp/6GshL0gIm2/jC8D7dV536qEUOZ3BgLm1M6WvlIJZhKM9bwLXtSiQJ0LY+r/o+UuU2gScMgFeAjgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748355887; c=relaxed/simple;
	bh=+SSxOMMFNEUYqXyhOMZxzDFcaBj3MIuICtYi5zenoUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=O4z3DZihXEoXOSo3V38a89kNJZfIRXGRyIaSDtAbeJaY7++RQZ6QVYcDLbMe1zPwScKcj/BH+hocmRN0LCV4podBntbj7WD+VvZIUD39B+xm+EcgXqdfPL/Tb94tDIufbbfPIQB3t4cYGTdUkbfJHQsYYp9KuPLoMcqqosvE9OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NqJi0W3R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NqJi0W3R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748355885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+M4G1HOIYzO3zH6634YUQensr31XqNL9E1Ubp3gcMeM=;
	b=NqJi0W3Rm7faRAwXLw5AafYHu4+uZdF1V3qCmG6VfHzC7nw/IbaWuhLx/YNny5lWs005Wf
	mIZePgBtFC1jRF4/uVLw7nGHc0pFZamVU9kjBvz+vBpXLf2RAI3i2P71cdTCO+bhiunsRR
	7mk9LaEsGEtlmcukionRjfLwq5/ZJYs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-O06nTjfbNu20rA7mqndTnA-1; Tue, 27 May 2025 10:24:44 -0400
X-MC-Unique: O06nTjfbNu20rA7mqndTnA-1
X-Mimecast-MFC-AGG-ID: O06nTjfbNu20rA7mqndTnA_1748355883
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-441c96c1977so20470555e9.0
        for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 07:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748355883; x=1748960683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+M4G1HOIYzO3zH6634YUQensr31XqNL9E1Ubp3gcMeM=;
        b=SpewNK2W79SZQCf2pbeJQ6EXX7a4sEvRaxCpojveC7Cvcy5dwnjJXZqb2ATH/GwzUa
         b5u9zpssUR1XBe9e88m+48YFHOMIS/AmztWJV3p7oZE23ymPJkUMzWu9LsvLJT/4Qlgm
         n9h2nmMfHKNyRGL80LvCUnHCajFcX7xpuIIH3u2juDPLmVi1F/h9N4xPHCAUriHAVskv
         d2m9nVd0KIIgZVvQ/sCxRBjUiHb9VF/YyAERMOfhiseHFEUfivYsy9Cx0DEvmR5qZ9aL
         0QDdJygW+nyc9nALjZlRO0kz58UFXbYxC97hjB7+cObwX42tfBDLXm5pkjli/dN6JjCR
         JBww==
X-Forwarded-Encrypted: i=1; AJvYcCVzkeZYyXgKGe/B6hOM/YAi9fAy5Ml1h6n+VsupHCeBrnhOd0DBFXMVpLjz7yozJcmad6gOLp4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYD+MpGQ5qX62N0QFZ1pL+DoLw6FdftehucXEBkdvdvO2WBuyn
	NE4sqIAGEIsu9ILw9saPeWfe9XdG3I4jfF2wIPg70M/PRH4jMA8LAM749UGEmtg3xF/lSDSxpC3
	51RThjpjURLV8Wo6gN99xVMDISvtezXKqpsMaxNt1B1FOhYEy6qtko6ECdQ==
X-Gm-Gg: ASbGncus7X8XcMWF9GID10+qwgmpA0axL+yLRPpb9SR29TVk+W8pf7WxrlcaYCbxaP0
	sO5I3D77PNDEXcgI0u0G69kpKQ+0Ur8ZWs1ddpJG4siOvtOhkhXqxnQ1FiTDC5G28Yw1clUygmh
	1AvukwkS+syyaJHx9qQ1NTqUUI1cVbnvd9q6QRUvZzkO9HkRkinaRmGOFq/YqFBTEGEl1Wrw+cR
	dWgkXTAgENVSK6ihhKUzxsqeGdaNVR1CNfFpi78/4NKSjrFRaQptnNhsS06WONzRGJm0143kcsc
	UZYD++O3tBlDXMbTIhILevWyv8lBsskqSwcZzYOHlj4paVMa0Az3pjMa1rLvUAn7BLzTHJZ4Vw=
	=
X-Received: by 2002:a05:600c:3ca6:b0:44a:b478:1387 with SMTP id 5b1f17b1804b1-44c9465c97cmr126923875e9.17.1748355882719;
        Tue, 27 May 2025 07:24:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2Y1uyM7+4XnYXdfaOr89AGuzVgzEd4y5M+LgOhzm3Rp5mg6OEofI/yliTAkfcRwsyfx9W9g==
X-Received: by 2002:a05:600c:3ca6:b0:44a:b478:1387 with SMTP id 5b1f17b1804b1-44c9465c97cmr126923535e9.17.1748355882319;
        Tue, 27 May 2025 07:24:42 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f73d3edcsm278766415e9.20.2025.05.27.07.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 07:24:42 -0700 (PDT)
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
Subject: [PATCH v2 0/3] KVM: arm64: selftests: arch_timer_edge_cases fixes
Date: Tue, 27 May 2025 16:24:31 +0200
Message-ID: <20250527142434.25209-1-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kaY7V9l1ZTFtO87FgcdMhP_daNvSz7DggOdX46Hui_0_1748355883
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Some small fixes for arch_timer_edge_cases that I stumbled upon
while debugging failures for this selftest on ampere-one.

Changes since v1: modified patch 3 based on suggestions from Marc.

I've done some tests with this on various machines - seems to be all
good, however on ampere-one I now hit this in 10% of the runs:
==== Test Assertion Failure ====
  arm64/arch_timer_edge_cases.c:481: timer_get_cntct(timer) >= DEF_CNT + (timer_get_cntfrq() * (uint64_t)(delta_2_ms) / 1000)
  pid=166657 tid=166657 errno=4 - Interrupted system call
     1  0x0000000000404db3: test_run at arch_timer_edge_cases.c:933
     2  0x0000000000401f9f: main at arch_timer_edge_cases.c:1062
     3  0x0000ffffaedd625b: ?? ??:0
     4  0x0000ffffaedd633b: ?? ??:0
     5  0x00000000004020af: _start at ??:?
  timer_get_cntct(timer) >= DEF_CNT + msec_to_cycles(delta_2_ms)

This is not new, it was just hidden behind the other failure. I'll
try to figure out what this is about (seems to be independent of
the wait time)..


Sebastian Ott (3):
  KVM: arm64: selftests: fix help text for arch_timer_edge_cases
  KVM: arm64: selftests: fix thread migration in arch_timer_edge_cases
  KVM: arm64: selftests: arch_timer_edge_cases - determine effective counter width

 .../kvm/arm64/arch_timer_edge_cases.c         | 37 ++++++++++++-------
 1 file changed, 24 insertions(+), 13 deletions(-)


base-commit: 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
-- 
2.49.0

