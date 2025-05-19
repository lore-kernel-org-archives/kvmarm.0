Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E986421CC7F
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680938; cv=none; b=Gzf1XXr866hu8K9Z4hD1MTv5tZHNN1vWQjSuhvufJCSGp3P/Ex+wKfqDQHMzXmQjtkmoZZW4nxiKf3BTOyF7vKl4pvfMRMvrNOKwpxjfK9csOd+SHj005D1EN3xJJtTUZL+QrghxE8l46SUB/Um/YbS/tK1q56l0ao1qYph8Hek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680938; c=relaxed/simple;
	bh=lKEiDtco8Zjxw+6Ce1l/2Woozc6T4pKTzIMLnMhgjbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jsWzUpiliOrjJMKToxyWY1atNSPDq2O0uUhUrT+d7EuKPi2VhYDWq8s02rX4BI7g8KLWgMzpOkrMXeN5K+C0JjbR4RppiCyePOvapK2eIZoVidrq4iap1Hm9La8VOM1fQA+tkOEDUWM1hS+kAwI/G59Gp6AUpwz6fKXJwkSjo9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iLsnUYlt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iLsnUYlt"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so7235338a91.3
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680936; x=1748285736; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=svZAfnlSTeaMolfrtcaOq/xEYvu0qCBcCbJ0k6qFXts=;
        b=iLsnUYltH4QjqS97H68Ja85nR82bnYaOf5LFDJcl4TYBtSgzPxWwN8ISmjH2UFriGr
         Tr7RnVZs2/33HJRhX0OxEG90yoIaD5BHv515z/QnkXXf2Wd6jSrlSaB/aiRE2K6Vcsne
         TBxko5Mdow6bntrkH4+9glfUvFT82pLypthM46JHOEQhy3ahZRiFvr7XiWxp6duJwHXB
         Gty+DdTTx+ggXWP3LAAzRQIyRONa0MU8RhBIrKFrT5qW2O0rD4fRinBLh/hlLyo7Jm2h
         zo68foj0CF2OQpYRox5GeVqCF48pq+a98vbk3HKn87D8JDgAwHvuzfslSE4CIEOqNuXK
         ecNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680936; x=1748285736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=svZAfnlSTeaMolfrtcaOq/xEYvu0qCBcCbJ0k6qFXts=;
        b=aoAdo+B4LMpHUKoOV9R3dRj+ywwKDVczkSPk1nawEgtWvIxB4gKat9WrxIdSiZVIaZ
         b6T+rh4WIyGKc8hzhekWllEG0lhtZF1H6baljKhpFevcAXkQZgRPfSHUhV2pCKTxMnfN
         dZ6pcE4vIj6GlUH+T36VbLduP+cWnb7zApKzcUoh/EACrkNJjoWDL3I+pXlJSwQVXlg9
         Jhc/jgCNyhgx+kkvLkaT0+3+nr9aLa2V3+/i0oW/yKFPhM8Y9AJOoGVQ1cNg6RECmSOa
         xEBuBNteMTMk0/4xN0D6n7wJjIJvsNXCXKRPdXZ4aAandk+rqBejmrr+zqj7ckKPsw1c
         e2uw==
X-Forwarded-Encrypted: i=1; AJvYcCVMAiygx/rgytVY+1oNdO7PgKA3fr+bMULGERUo71AD/mYsWRSmapULyy0W7bMX+Id9kFDyVnQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqvbKm/PH+fbDMydKVK7Kw0xCsslvd3oT8/2EDdqwfuzGQPGZW
	dekpnIfchTWfIeWnFeHQY3CEei/k4jG7akN2hJ0g2HFhcs9Oltz14tCFFPPeIxauOWtCGV1a5No
	U+kgdzw==
X-Google-Smtp-Source: AGHT+IHFHSV2Ke7uVRMojNlgnegTrMTQP9GQqHVO1VwR0CTBk3daaqGT0xYoclFSkFU0/yQOifv0EZ0lYtM=
X-Received: from pjbsb5.prod.google.com ([2002:a17:90b:50c5:b0:301:2679:9d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:2fe:ba82:ca5
 with SMTP id 98e67ed59e1d1-30e7d52221bmr23752952a91.11.1747680936483; Mon, 19
 May 2025 11:55:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:12 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-11-seanjc@google.com>
Subject: [PATCH v2 10/12] KVM: selftests: Assert that eventfd() succeeds in
 Xen shinfo test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Assert that eventfd() succeeds in the Xen shinfo test instead of skipping
the associated testcase.  While eventfd() is outside the scope of KVM, KVM
unconditionally selects EVENTFD, i.e. the syscall should always succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 287829f850f7..34d180cf4eed 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -548,14 +548,11 @@ int main(int argc, char *argv[])
 
 	if (do_eventfd_tests) {
 		irq_fd[0] = eventfd(0, 0);
+		TEST_ASSERT(irq_fd[0] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[0]));
+
 		irq_fd[1] = eventfd(0, 0);
+		TEST_ASSERT(irq_fd[1] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[1]));
 
-		/* Unexpected, but not a KVM failure */
-		if (irq_fd[0] == -1 || irq_fd[1] == -1)
-			do_evtchn_tests = do_eventfd_tests = false;
-	}
-
-	if (do_eventfd_tests) {
 		irq_routes.info.nr = 2;
 
 		irq_routes.entries[0].gsi = 32;
-- 
2.49.0.1101.gccaa498523-goog

