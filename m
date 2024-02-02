Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE9217C74
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 06:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857109; cv=none; b=NJkU7kK8oLwR2g+Pg1KyrBCSFTJF4WI6qqUKzLGWV9WTZMHp7q+ohFa1DWQyBdsNTZ5X3zcebcW1zaIgwo0kJvw/FLoTkWe8gO0/Cr86BTNEK/a7ROQoB5BSpKNqmxzL6duZOMQ4Scebw5kT9jaQlWkoGpv2QFYZUVn/KzQoAjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857109; c=relaxed/simple;
	bh=4yScsOrcnjKTTDzCPnl6oSqQbBcwqPOJzQMwRvXXfl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAqUUowH3fYdrd69zgq0RZAS38oqNlAdHQ9Mrtrf3Zp8tDsp/4pMvni2rb/nnJHhaJR+Ri/HL9HMGPptsyadpNLplFyOZSo2HmImPTOfj2mesf4K2ZscJzW9IbkawGrbHoLNwDmR3Gt+ZpHw4bzvVXiLZGXgsV0OKotqWStfB2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NawViCVe; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NawViCVe"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d95d67ff45so8672025ad.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 22:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857106; x=1707461906; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=NawViCVeG8ycw1tLXzWdDPFE2RgObDuMp22NxW8yIvjRWl/Wa1peJ+z00Q5/qrZaVl
         QGTAmPD/W4TOqwe+gtqUlqKSiPWFyGJv3g0dJv3Yylgsdnwjfzi1Ws+mIbnLeQmLwWr8
         1Y6uqt1U+BjeoG/5YeRiHhaH4VnQpU1Osi5UPSqx1fSnbNcV/wupn39MOwycbsNMmRW1
         OYXtxXaL/zNMT56gb549Qqj6H2fNiXQnqps3j5yRNplPJ3QROpmiUh/uGgDPuLVl8Zfs
         a4Wqnjvd71k0JzC3PwjulWQ7sRs+cIVtGIQHklK2FCWYOIqP6vRl+DPBSUiBlN44DaB6
         ZA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857106; x=1707461906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=ie2kygxiJkSL2jYsaanWl3rnWf+/UXBQY2yOCc5WZcz3Vd0WQ1uEKHQZCUItZ4tKLq
         MtGzQQVnPe1iTw079yGhf/su9ge5/HSYlYSYSbMXfqyYodSEDLSsjcRmfCQNhkPXMi2P
         kllqwfCMhq98nrPjRx8oxZMYtY05T78X9TFWkrMXqB0e9s9R3Gi7ijNJjd5VymVk/gbX
         mWH6M/Y6djXImCwPj4Au3diuk2At8b/ejGbmAo0DQqLtpIKrKTzwoW5HoH/OrgISpWin
         m/YdLpHH7pLmSL23iuUn6wUabsp9lyaJV4k5g7p/QzaQgpO3FpFC1zbDiB8NFUkojTkM
         h6Yg==
X-Gm-Message-State: AOJu0Yy3BkDcBIr7MqinYjLKg8dTjTTVqFKSkGdCyv1avC56bac0UVFr
	MRtcCKIF3wdK6HJrX93DvdjH1p7tbNycQVOXV/4i95zZl7pNbGnp
X-Google-Smtp-Source: AGHT+IGl/XMjvd9Klgg2/FWxCwJMxKc63HwstNQDO2ClYm/78uC2k5jJZCUW+UiCZN8A2rtA+7mFiQ==
X-Received: by 2002:a17:903:445:b0:1d9:5ef2:abdd with SMTP id iw5-20020a170903044500b001d95ef2abddmr1116146plb.0.1706857106567;
        Thu, 01 Feb 2024 22:58:26 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW/IOgMZYUZthoBpoNRMf/oli+krs0I7QalTXQLhmUUWWhn4KTEGdDr/tD4cxALPr5YanOFmAHpezVtwao2TQzO+RlJR3Ey/l7/3QH/K3g+wJhke1+8D7EBboNPM5WoqME9ClFM8Tb2qCEIYjo+bDj+JytizB/Z/HHC2r1N33PYMUgH67boLyOHJbDw9bZpjApoN82XPi+TIHolN046l5iX1K13QrymhO+WP1rEnsSa9hFW05dJESbK9n9XsLx0/+71n2h46K26UvtQ2Tvhi4CxxSgx61auRLuHt8a4ivXCW09clAuX2orO6qQmVgmRP6m0MuduJ7wcFMpF4m/Yyx8XgB+x2QC4G9sG0uUxRP61DypLkLC/HukTiuGgrKuWO8070olj+6YNjeeQFlx6mz0z7Ta+qF2P+x5aggZgJT35GSJypgDz0pyEIOTAPK75Tgu99P65NQ0dXD3u4iLw7/cZe08vmV/GqS8qWhRhxtJKwMQsq18X2q834tfjJ55jslSnq+Pu+viz/94=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:26 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 3/9] arch-run: Clean up initrd cleanup
Date: Fri,  2 Feb 2024 16:57:34 +1000
Message-ID: <20240202065740.68643-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index f22ead6f..cc7da7c5 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -271,10 +271,20 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+		unset KVM_UNIT_TESTS_ENV_OLD
+	fi
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0

