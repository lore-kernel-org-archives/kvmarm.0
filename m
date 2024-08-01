Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3081482E2
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 23:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722554060; cv=none; b=kipCc1ErkFJzEGeW1aFbYsAqnPrirqkbXOCaEB04nwzaFsttUrAerFe1p0lqY6nkSgxe3f+hqg+PgVbvSV84nbWGMYLA6fSnsgauj2Y2kvG1CBtnNmHfAhpMklk8StIkV/4Pu94kGyzrvvSKmRSV3dR6TLuUiIbKulLPwHd4j8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722554060; c=relaxed/simple;
	bh=LakDI92yHujNYi+vD9cXq4g/itDQoPvZyDTcFrObMss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GV1p98KbAe+oeQ7FdjgvrXPUYvpIUIBtJGJ7ekD4PSTx35dGyxHDzSulqjN9uAri56N00EaWcHBAu1AGoiBKUk9hJelTX8X5SNaPY5nZM1m+fPZPftqu0V8NTmKpMwNbTflEBBm2WovlQ3aMCbp7n1h4HeJ9Zzytcftm/HK+apA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q59Cdu6W; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q59Cdu6W"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-44fdc70e695so1145421cf.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Aug 2024 16:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722554057; x=1723158857; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgdFSK67EnlVzS0oNU0oXBgCMZ8Z41GsOasZvN/Cis8=;
        b=q59Cdu6WXCKtEnlI0txgZ1ZAPqxO4rMicFJ/FKutAN+jFzwZmDZZIBTS8Aly6Y8zhe
         PUpFTauIn9MVnb3LjObDxjok6vIsXJdz1Vhb/p40ma/GbNRXmEyTYy+X61Lwoo89Dfcb
         SEsYaqTl+Vq1PIBHLLBVnJEENHtNG7WK6Zlppuy6BNYvcrPafg+Gfp4hrzp3/cITmQXA
         KEr+dJ1IILX1SeWhHV5FBi66bFKp6zEuAmAlzhAdZ6J4RwJ6YTAhypjwm62J3fKfrKeg
         6hr5CMdPkfOB2nKRFIeYIKZnbtE6ZPDNJacZDMxRER1iIcmc8+qZLd97FeWUvTzXKq1P
         xgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722554057; x=1723158857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgdFSK67EnlVzS0oNU0oXBgCMZ8Z41GsOasZvN/Cis8=;
        b=E1gVZQyYooVcH08ZM/qxvy92KL2Zp/fAuIWqQ7rQd2FSh6Jh9EAFLUxBNbuQQUZHsH
         aHuA8Cvo9lSGQTesbhK11wb7cISlfRne1GCDhGZi7RqYv6s2WdAV1BsgA+JLbfqFoGwW
         n2rz4+6yTdX8IcIIzEaczd6Y3LsbCedBiOViB+1yJrIAgzcrUbP+1RzLrXp+jsmk8Njf
         tPqguIV6YJvyGKsg9te/5La3n3SjIcR0y/ttNSXl93ktRE4tcITkuCeDKAPBB5DOCDA0
         88Cc9MTJSimt0QpxAWNs57sTnFx21/iqelqxtN0xZDzM0S4Gp0POoFYOeWpmmWmF5EBC
         aMkA==
X-Forwarded-Encrypted: i=1; AJvYcCUQQoVKD1t/MNK+m0T1BWD9k0Ca5C8tUx8XstPiEq5DFZVUgYHdpspDwjY+s2VH67qe6gSBj0+vDR88G57PuoGLMpMjOcc7
X-Gm-Message-State: AOJu0YwW/7QV/216hBMMYlxpL3do6Le8lA5UzC8mHniX7JAe2EmPloDy
	nBwt0YICIvb6KJGerIj07apO71Xgx7253kv64AHcrLSX9LTe2iDFSv3UUHjDkPaHc6mhG/K1omq
	7pJUGbngCoy85TapLiL7w+/a7+Eh/eADSJGhV
X-Google-Smtp-Source: AGHT+IEavFuwjE3Uo37LnJzCLlUcmMvqQudZCR32/8HyzTxNRzd5eGXPN4zy9/nrSL3qCpUTpDg7un5y0ylSK+y54Ao=
X-Received: by 2002:a05:622a:178a:b0:447:e153:66e0 with SMTP id
 d75a77b69052e-4518c6e3d95mr497911cf.2.1722554057325; Thu, 01 Aug 2024
 16:14:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-6-jthoughton@google.com> <37ae59f2-777a-4a58-ae58-4a20066364dd@redhat.com>
In-Reply-To: <37ae59f2-777a-4a58-ae58-4a20066364dd@redhat.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 1 Aug 2024 16:13:40 -0700
Message-ID: <CADrL8HUmQWDc-75p=Z2KZzHkyWCCh8xnX=+ZXm5MZ-drALjKTA@mail.gmail.com>
Subject: Re: [PATCH v6 05/11] mm: Add fast_only bool to test_young and
 clear_young MMU notifiers
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 2:36=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 24.07.24 03:10, James Houghton wrote:
> > For implementers, the fast_only bool indicates that the age information
> > needs to be harvested such that we do not slow down other MMU operation=
s,
> > and ideally that we are not ourselves slowed down by other MMU
> > operations.  Usually this means that the implementation should be
> > lockless.
>
> But what are the semantics if "fast_only" cannot be achieved by the
> implementer?
>
> Can we add some documentation to the new functions that explain what
> this mysterious "fast_only" is and what the expected semantics are?
> Please? :)

Thanks for pointing out the missing documentation. How's this?

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 45c5995ebd84..c21992036dd3 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -106,6 +106,18 @@ struct mmu_notifier_ops {
         * clear_young is a lightweight version of clear_flush_young. Like =
the
         * latter, it is supposed to test-and-clear the young/accessed bitf=
lag
         * in the secondary pte, but it may omit flushing the secondary tlb=
.
+        *
+        * The fast_only parameter indicates that this call should not bloc=
k,
+        * and this function should not cause other MMU notifier calls to
+        * block. Usually this means that the implementation should be
+        * lockless.
+        *
+        * When called with fast_only, this notifier will be a no-op unless
+        * has_fast_aging is set on the struct mmu_notifier.
+        *
+        * When fast_only is true, if the implementer cannot determine that=
 a
+        * range is young without blocking, it should return 0 (i.e.,
+        * that the range is NOT young).
         */
        int (*clear_young)(struct mmu_notifier *subscription,
                           struct mm_struct *mm,
@@ -118,6 +130,8 @@ struct mmu_notifier_ops {
         * the secondary pte. This is used to know if the page is
         * frequently used without actually clearing the flag or tearing
         * down the secondary mapping on the page.
+        *
+        * The fast_only parameter has the same meaning as with clear_young=
.
         */
        int (*test_young)(struct mmu_notifier *subscription,
                          struct mm_struct *mm,

I've also moved the commit that follows this one (the one that adds
has_fast_aging) to be before this one so that the comment makes sense.
