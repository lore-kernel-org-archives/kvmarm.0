Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05D8242D76
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254208; cv=none; b=UNAFZoe5A2bJWL78YOjZcgMYJ1df9nZQiX2+VzsZE7y4T98Q2+pdWWnlNtAw747KsjDXuF/NnY5E/kZFOC4KMDtFBsEdhOVG+ZzBjCrI/qungjSIA3Xt48gbm4K2DQipRS+jyALgWWVolrIOWcefAU/HY/KgjgWuqvoZt6LoQXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254208; c=relaxed/simple;
	bh=tAhDaW1UKjDSoNvp463R7s5asIhTvTptfxnbQS/b8mI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PwO+CMg8l1k2GNbezILWQr0Ihr7tk+Fr7Oln7f/o3lBaxOIzLTK83VK8/0mEiUwUmom5U9miLSZOPaKQHvOu5MdLL9KDFALjEhUeKW6PPTGxz6k2hzGlgOi/jXUvK1cKHrt5Tf4mF2g6cqD91FjxQV5HFEuKcS61h+g4MrD1YTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W99br4OK; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W99br4OK"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74292762324so2652752b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254206; x=1749859006; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VrOwB60iRPSms6H0AJKyXzUgvUqpPNkdC9MViEx8qm8=;
        b=W99br4OKAZ51QXszzo/mPHdPd9SBOtNVe2wEJ5LOs0Ppru5ZmMvIP7OVT9E+fe1GVv
         D28Ar1zZSf4Jo4+yKlscQRmUc7bAAfo74nwBF8LTo8Ppt7vo/zcqhqPOk6Tr+OVo0biG
         GS3cgMBLsBLgq8WhdweGIq3oJrHXTubfxX7zveNPy6ik/3rXSqA+M/4YVjz028hsAQnS
         MRUAiMymU+AiL3n+EbGwj4tToc3gyNTl/n8Jc9FmIi+fNR33XHx2xflFMU6aHdq/90Ur
         i3ArNuVGO2zXccLzWvYnk0vFNSHCok89gFHOrYeN8neUwJPpa1KVPFZW4R0Sc/KZ3McE
         +ymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254206; x=1749859006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VrOwB60iRPSms6H0AJKyXzUgvUqpPNkdC9MViEx8qm8=;
        b=FH5ppRTUWQNU4I5vug5wOMvxdjneMJQm49tLYQzlxfhXx+ZdJjLSEnupHE52f+gAjE
         yZUTnrOuVMXy4zY3bejdwvJazRy2CXdU0rOYwFIDyRIKYv4fx3z/7L7lwwvvDnOHRH+4
         MN7ADDZFzOscuWw5/ILa2/pKfBiyisVuXyXnaK6bUx45gBDj5uuBYmI+xvLj0006fVPJ
         pp+yLVjctbnJi9SdzHK6LgF1yDotLJgFNbrjJgBvW+mxUlZypDQiPeCSrf/VeCkGTDAl
         vgjWRr6k5Mj7zuX5ktcVAp+T3g0mAQ5L0p+gSIqK8wKri7QrSHbfsWMxR5CfLYta9GnC
         Vo0w==
X-Forwarded-Encrypted: i=1; AJvYcCV+xjnnB2KkUuU3Kvg8g/MzqE4CNxBUY6yNyLzKxtKmBOKvm9dkuCxxNUmpranM0BULxjHfLvo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUwWwreLKJ1RWoVKYgGLvCW5a8R2uvxIdv8vAZXWVX1+sVPdkk
	xVpoxCkYjHFFynd9ec1qM0/jOAWA2DG04EIghxLX33L1ORa6FynO4S2XqUs80GCOhZq6qtQCnjz
	YcCKcpaaXBw==
X-Google-Smtp-Source: AGHT+IGcO5eLR5D4rJUvqyhcG7DPzhqjWvwjT9S1GiHqHVEpWgfsWBe6SJIclWzcovJY/XCNJMaAI3VDhG0T
X-Received: from pfbhm22.prod.google.com ([2002:a05:6a00:6716:b0:746:2bf3:e5e8])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1ad4:b0:742:aecc:c47c
 with SMTP id d2e1a72fcca58-74827fcd87cmr7087572b3a.7.1749254205891; Fri, 06
 Jun 2025 16:56:45 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:13 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-10-vipinsh@google.com>
Subject: [PATCH v2 09/15] KVM: selftests: Add a flag to print only sticky
 summary in the selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a commandline flag, --sticky-summary-only, which only let sticky
summary print to the terminal and all other outputs are suppressed.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/runner/__main__.py | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 4406d8e4847a..2dcac1f4d1c4 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -124,6 +124,11 @@ def cli():
                         help="Print only tests which didn't run."
                         )
 
+    parser.add_argument("--sticky-summary-only",
+                        action="store_true",
+                        default=False,
+                        help="Print only the summary status line.")
+
     return parser.parse_args()
 
 
@@ -131,6 +136,9 @@ def level_filters(args):
     # Levels added here will be printed by logger.
     levels = set()
 
+    if args.sticky_summary_only:
+        return levels
+
     if args.print_passed or args.print_passed_status or args.print_status:
         levels.add(SelftestStatus.PASSED)
 
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

