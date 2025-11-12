Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682A834A77F
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971255; cv=none; b=fm75v1tIvPjXX5zXCqboC8HKWnFhSVWP5qEa4UoBqgmj4sL9p1buxi8o5RdVv32ryUR3XrFu1tJISefB70kk4pZXlTdvAuo0qThqo2imxGfGn5hjrgjk2x4lopY2+61yfusDH3dqbITCfeSklfTJyjUOWs08uTl5oX8mJT6IClw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971255; c=relaxed/simple;
	bh=5Yb3X6PZiKols/sQXmoknfK/pTPbA3jLRfEhVBUsSgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=NdzL1Em+gBuYUOXDmQvmcc+xNN1/yi53jzuieef1H8Guudtct4bOGoHAtS7sHFpgpTyyvE6rGTcGh8GJEZsQKJZibyEHVjKy2UHnk1n4lnqEJ5WwbrULnyeMatrzJ4ONqGgJa5M3NiPKP96LtfwMaEQiIeHOdcYpICSpadu+OqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BV866DrX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BV866DrX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762971252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
	b=BV866DrX1/wgZPsIztWlivEw2rg4UItTAXUaBGHdRWt7ATujf0e2Ajus53JELjhNJ5Q6dL
	EH9S0blPn729m8yl+1QK+bj+016KoHl5VGlUBkX+MGUoTzcQoD+SvWH7vA8zGxuTr1g31o
	kW2kt7+VKbDWUY055NU758oDS6MiKeY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-OQqoDfG6Oy-9hvP05JvUYQ-1; Wed, 12 Nov 2025 13:14:09 -0500
X-MC-Unique: OQqoDfG6Oy-9hvP05JvUYQ-1
X-Mimecast-MFC-AGG-ID: OQqoDfG6Oy-9hvP05JvUYQ_1762971248
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47778daa4d2so9676345e9.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:14:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762971248; x=1763576048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
        b=SCTNnkSrCC8ds7O7MN3EOEAwWnharVP7gof5SO++yGpOEFP29Na8hvRKrfniHl/ZRY
         nGWf1JfD+gSaPBQlLQoePA8SBeWjHSD42g9hfoiZkG7PYZI5/mSL2aoVod8Gsiyu0R8g
         70p+GTNvEY+D1u+sR+GNZD0JUlWClmZ9USPjfO8YW7gysaDS6e/O7wmUXUP/lL/SD8N3
         C11D2zkwVeCgjHN/zIxIp43p72lXvKxSrG+H66o8hvsZp6kgOlk1Xh8a8qn96sBotBxS
         ZAJ/uwT9q9xEZKqEd9li4BNlKv1+jYn3SXAgj0Y48NXmYyWWBjSDMYuwBeFmEyoBgWRK
         t3GA==
X-Forwarded-Encrypted: i=1; AJvYcCWreCWKCwP6WE1WqgvTpqB4sCXmWqIEDigwgnlP8VVwtElPGKkkYv7jnLyxFdLDLyowo1DNZLU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3G7c2xR2ck12R+yRU37bvX7weeJemk8xgZWUwFKxDM70alza/
	bvDjELTNEfSEgBxr+WQdNj0aHJKVBmDLFMDJC1ftzdn5rJ0t8eMJa4DrB+EdN4ceQhUxHRmx4W+
	ixtoAfSo0L6WcdcGOh3+0xGVxMFePigNXJ5bhjMGWiuVld73j35BoMq+sxw==
X-Gm-Gg: ASbGncvWp8FAwyBLagXjmnmsNtlnpDV7lSMjAMrO+ky/HZ7VzPZUSE7fx1L8gUjbAXT
	gn3M4kwxL/bW4+3XhkwA99ywo/gxJe40rqnAJpUUvlpGRfP8eeYDKesbimuCOKIMncIz8daGCRF
	EE1cDFmuR4f9zhOLKI7DJ/wWpqp+NIBSCiBUKjSUnD3alQcPTh80P8y2u5WnbJSrP8Ju14Uk/e8
	XmQqn7wFOjdONLWnXNB/ivcXrFebHX3Ho07/QupyYnX3a1FFurz7GRDG8B87vCJQKBhFvJwjpm8
	/wU8eULGI5jxbgAe3us5tLUBePq0l56l+dJOYqknOvwzjqdaK3FSdPmT+T5cFu02iUP21EZfJGW
	BoOrHaKzxyHHJb48BgTlC0mdh8naFfcCP5AtmLbQUlF8vh9YI3SFfUg02cNKWig==
X-Received: by 2002:a05:600c:1d0f:b0:471:16e5:6d7a with SMTP id 5b1f17b1804b1-4778706ea91mr33694045e9.13.1762971247839;
        Wed, 12 Nov 2025 10:14:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExx7YrdQI+IydYpEMMuMdDOGxLo8j/rSItSIu9aQs64pFfJY+BoQHkmXgSTSSwlx02YpTuFw==
X-Received: by 2002:a05:600c:1d0f:b0:471:16e5:6d7a with SMTP id 5b1f17b1804b1-4778706ea91mr33693785e9.13.1762971247394;
        Wed, 12 Nov 2025 10:14:07 -0800 (PST)
Received: from rh.fritz.box (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e51e49sm46851355e9.7.2025.11.12.10.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:14:06 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Wed, 12 Nov 2025 19:13:56 +0100
Message-ID: <20251112181357.38999-2-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112181357.38999-1-sebott@redhat.com>
References: <20251112181357.38999-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eavEA90T6F8Y8jdt9Oj4PEGwM9MVZI30cDLXuk1sWps_1762971248
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

