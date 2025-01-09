Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE189205E26
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 20:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455806; cv=none; b=pAIogaQ+6S5cWEyl8/K17xaLSCG+iEhMNZrNkbW0wrDjcqkQvR1mBzx9ckjQBpDoZLlK/R4nYNVfCuJY9mVavR+jcnCt5uTpkWNgwMhb4n5H4/6DDXiNkS9Do//vaEI1m94T99FWK+aKFF13/e/44lU+mwQqZQl2G3uXsdvvpAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455806; c=relaxed/simple;
	bh=7dvrWaFHLcfsBdDYCLYrpKWe49ir6woEr/o0fl0YETg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MU9A+3/TYgxYpJO9UYdHhRVv/a2aDkV+/pOW/RdlmeNRxBd/r1lSszkUG9PAXG73OEJI/oPMJPv+C0u0qdqx9s8G8Chort7SBJWk419rpRb+CC3wGtqnikYKb1jMk1rjIO2H/FIt5iuKcJ92Owbgv8TtIfErTW20qHYDT5O4B7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q/GkfGos; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q/GkfGos"
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-8610c442fe7so227874241.2
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 12:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455803; x=1737060603; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OvbYHGNl+8d7DJVwo06D1EaOJgLS4cwG8AKsUnFt2VU=;
        b=q/GkfGosMLdcRVCQiVpW3xscv2vXIie/mwY5mUVrP6ZOQmoXGjzO57hg1xquUQhXjm
         Q3zfgRNWtsQJVDmZX8D5CGy42ys9UC5Z4/taT++0gRXRDgtw3RWs0I98cEGBQn6wTu5b
         ZR/HhT1rpY8Uhto42pjLzOCQeUxPT/F2stYSX7GKyK+mx/xe+XvVd1sJ79mdT5noVfF/
         RPJQE3PCcwb4QAfJe3ffIAzZxNA9yiBo4Fh2yd1/Wf4J6tpwkhGSZ39FUxlRvuxwaiYz
         Q19dAfPPMtuHw+KzoZyRr+CdJpEKmPowIPtNfVOMBg0XtUu29uYuB6FKkXp91TxCS77e
         AtSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455803; x=1737060603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OvbYHGNl+8d7DJVwo06D1EaOJgLS4cwG8AKsUnFt2VU=;
        b=Zmzfookqa3aijkZDuKNgG5bLhbfqn1wxlnu8E8+SN1m9kL21AsjYg64qS6uPi7wWmV
         7W2a64An5M8GFZo8roL9veMDR+neLBq1dmbyaBYY3Uzh/Cy94/H3X+aKeQTyywZA2Grs
         6n4Ba50evjWLYh/4106l1Q7rfNNiagB8aSSmgO06XWdZ/HZFqFri1Re1ImrCbaGcsbb5
         RHhXjr5mwIItZCpIRDB5Pq76fdP0Udaz2+ZkJd9PM0QMd2Cs0iLm+LqrqUNmNSbQJ29j
         JY593CImMvCaR914N8jyXAAeExFiRiLBxA3EMNg7ZJ3lxACILAcr/iPM0DiDYhPTy61W
         35lQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8v9WXWuPLx2XDQVtymkJ7W5wzlr9usQRFd+EMSwzuxmKfvKCcnu46dz639lIoC8ZJUMwlzTA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9Nx8CMsuTlmmAshwc2JLPSrFu+SG+E+WwJPG+ka/Gt5vzPr2c
	nhybENYr+CjI9C26njTMl58XyRGXCAcJr9wLFOWvVRp2ifaxrNTqr5+Edch03vfzgJDvRu03vWu
	zLkI6wIw197LInfgoVA==
X-Google-Smtp-Source: AGHT+IE5vJKdBIol6yLO/bCx7LzYtkzGMj0nrEKYhdyPGNNYWWWO3Zt70S5/gUk7SHW9elNAbwwPb9/d1PnA+b6V
X-Received: from vsvj21.prod.google.com ([2002:a05:6102:3e15:b0:4af:dea8:7367])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:41a7:b0:4b1:1a11:95f8 with SMTP id ada2fe7eead31-4b3d0da8f06mr8495356137.11.1736455802892;
 Thu, 09 Jan 2025 12:50:02 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:25 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-10-jthoughton@google.com>
Subject: [PATCH v2 09/13] KVM: selftests: Add va_start/end into uffd_desc
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This will be used for the self-test to look up which userfaultfd we
should be using when handling a KVM Userfault (in the event KVM
Userfault and userfaultfd are being used together).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/include/userfaultfd_util.h | 2 ++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
index 60f7f9d435dc..b62fecdfe745 100644
--- a/tools/testing/selftests/kvm/include/userfaultfd_util.h
+++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
@@ -30,6 +30,8 @@ struct uffd_desc {
 	int *pipefds;
 	pthread_t *readers;
 	struct uffd_reader_args *reader_args;
+	void *va_start;
+	void *va_end;
 };
 
 struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 7c9de8414462..93004c85bcdc 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -152,6 +152,8 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 		    expected_ioctls, "missing userfaultfd ioctls");
 
 	uffd_desc->uffd = uffd;
+	uffd_desc->va_start = hva;
+	uffd_desc->va_end = (char *)hva + len;
 	for (i = 0; i < uffd_desc->num_readers; ++i) {
 		int pipes[2];
 
-- 
2.47.1.613.gc27f4b7a9f-goog

