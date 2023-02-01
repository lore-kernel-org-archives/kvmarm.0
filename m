Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C46B8483
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 17:21:35 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id u106-20020a25ab73000000b00843e2d6a2c8so3407642ybi.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 09:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dAwj5/lXzInaS9jfWyz64yLKr8tCxS9Z5jRLKFKML64=;
        b=raB/NA4dIkmnR516pfEwm0knT2JV3hTjtNysGUJa+oNJCoRdQNCWT+eWHWDUkGMp1z
         nemcgwGweS+1PvCf03HlnV+zFsGcHKROEKijvWQ6tXXQdNKDFPFV0uhc9DTBJ2WxkUnD
         l8nczlgz1IRMAsISGk4zS4qd0+zKNSxMN5LrFP3E/aHtvMyOBmqt0QPtMeh9+LQLuhE7
         YA5VQbnuD2vUKPAmUuc71aFHIb2NospTr7b8PdI0iObEnZamBeIldmxT4Juqt4e9/VgS
         JCl/b9x1rvanRMgnH5/Iy264T9XmSpOsVQQ89FjS50NRWwDF1s1oZFokADOfd5bCDQTj
         IGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dAwj5/lXzInaS9jfWyz64yLKr8tCxS9Z5jRLKFKML64=;
        b=LExcmYCoExvau+LlbpZeXg/S31UITElwO9gTJ7saCd6OWuCXwYtaNRdCdLKTuWVHot
         2Io24kfSp3BGB5FBOoMwlem6kOisCCHkidNSsigEAy/a2CvMlq1XJc2Xa/sa9GYXgWIL
         XnKBcQ5SiZ3eDyY0FT6L8oYTWAt3ddic9+7noZQaOoUHY+o0pur2uFn8fo+C8yk70Zc1
         KVhskyuMPL3NgFhW+Ssy/au6t5ptLWOJTQ0vBWJybPaBHHZ1743DAdBDvDTSZX36W7KT
         9P5iHm4ee2b3cDCwr607ouf/R3iT1KPaashkkM/PClFS0FbhTqsbcHuPiG5/8cERz0Mx
         E4OA==
X-Gm-Message-State: AO0yUKVrdQh+htS3ASXrxiNhaBzxnL86WzzLQH0JQd54jSgl3pd2WBA6
	Dt6hd4hMQ/+J0yRH2UZsVcQRxVk3Q9prTdbZzQ==
X-Google-Smtp-Source: AK7set9VoaOQ2sAxqOHh49EW15OK6oX7ZpblUNowiUpwgVsH4yb9krf7pPPf6epwC9xHunRGiv1kYyw7qr6muap8xA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:a84:b0:4ff:1141:f621 with
 SMTP id ci4-20020a05690c0a8400b004ff1141f621mr284480ywb.224.1675272094212;
 Wed, 01 Feb 2023 09:21:34 -0800 (PST)
Date: Wed,  1 Feb 2023 17:21:09 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201172110.1970980-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v4 0/1] arm: Replace MAX_SMP probe loop
From: Colton Lewis <coltonlewis@google.com>
To: thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	andrew.jones@linux.dev, imbrenda@linux.ibm.com, marcorr@google.com, 
	alexandru.elisei@arm.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

v4:

Remove last mention of awk and fix spelling mistakes in commit
message.

Colton Lewis (1):
  arm: Replace MAX_SMP probe loop in favor of reading directly

 scripts/runtime.bash | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--
2.39.1.456.gfc5497dd1b-goog
