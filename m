Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E2239EF12
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 08:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139027; cv=none; b=V3DssSwQ+g8oeJgILpF3uPMtCeCUeBUhmg3/5FPJCXUQTnaJtBGSrKChkMwhDXrlVlJ1ouYrAt2f+pZY9DGfTEUq5p+SVBA4O27+Dn1PBdCakYrtv00nHi3wXPGjU7ad4RQil9cgAVu9dXnQfCBSShd2x/GLT/9x0lMepbjQdzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139027; c=relaxed/simple;
	bh=TAKHJ1wRNmc6FRr+r/vyusvSCvH1hGFEGvqJ9J2tBRk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qvwku2SeG26H97KUjjMFiyoA0Fm/q3zTJfFR7oeFgPLhZh8dPS8Z2AYRefVU2+Omkam6zg4DaeZxwtFVN0QEhaSe2B8d/alNco0YwZJ24sA+tfQkP3LPLctrjlflrx8hnWZUD5q0LFiMiVSwDJA8i78C+7SVTQYbOdk77HPvU88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z27qZeaX; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z27qZeaX"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a01c621dc2so47027945e9.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 01:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792139023; x=1792743823; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jTA/E6KagxCsXAcjrRnC+iKPqmNPE9H/PtvqQ3MoRHU=;
        b=Z27qZeaX9dzL5jD7uCElRHndA95VE9L/X0dFD3cYzZH1NYnMIzOV/4ikXHqF7dfdK+
         oMLf38/I4gVRU7Rw48orFavLGwXyErOjTmiE8zqfmfc8kxvDxXPRSsVSuZP1MXwQOYaK
         gj0ztj7QgxfJYkQonZj9q6qCk8wyK1YjpO7s+hRWGhl20PBMu17fJmzQtbZmWKmTLLv5
         49QKXMy7k6VxdFz47xv7Y8UByGc3JDSRcPw7VzAvh/ZgS0jZ6wU2rLAS71N2ZX7Jw/IR
         VI2F2IgfBAEJwY3blEYgWM48sxMLzsgaIjQ/tgkl6Py6e3RJe49BVAmfFEio6/jvonKd
         XC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139023; x=1792743823;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jTA/E6KagxCsXAcjrRnC+iKPqmNPE9H/PtvqQ3MoRHU=;
        b=i1l9of1/JjtMc8hX2fogPKoNFyiqcIk4wGiR3ZJbZipfrHEloo+cXJA4YI0a3S1tak
         HfGamAfNW+catXUEXxef6d/w3CPGRS8pUg+xJAUpvHreRhit6WrVDAObjW5zL/LsOyc/
         ++1+r9F8Zi47P/0CDxmfuw+qgFyC7t1pGrR76TYba9GLr+6kKCu6o2Yd1Fw9SWFpvhvK
         fy3x6xzctGL6vkpEWItJU9N4MWkELHoCaNpogjbJRuXkPz25IMwmWcrdrq4WAo1Zl5Bs
         815xbbeNee2FyH6GXYRW/Qy1WThcfVAckakjFzVLD4KMwrFi3YpGimx2AXHUh/RpF+qq
         YRtQ==
X-Forwarded-Encrypted: i=1; AKwUvByJRW7m0gHXU+pY2qLunsjsWU5fyVdvn+rzlJWH/V0LLxKJJgqwrzyIayTnWdfDBb/FTFCnjms=@lists.linux.dev
X-Gm-Message-State: AFq9FYIKcAqhjdL89/z9/9GdEPX++ki23u5THygGnbbHx34pMRC2KnT6
	SlFVVcUrAqD8Xm2dPSwf5IB8aC4OmlD2m9N/qF9arcgRJJjqJ66lwwj+GTK6Do6osxZYcgDG0E4
	PN0nfbv9wQPyksXoVId24ai+ezQ==
X-Received: from wmsz15.prod.google.com ([2002:a05:600c:c16f:b0:4a0:2a5:ce1a])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:310b:b0:4a1:813f:2a5b with SMTP id 5b1f17b1804b1-4a18e4a9da8mr407450355e9.14.1792139022921;
 Fri, 16 Oct 2026 01:23:42 -0700 (PDT)
Date: Fri, 16 Oct 2026 08:23:39 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261016082341.4030770-1-snehalreddy@google.com>
Subject: [RFC PATCH v2 0/2] KVM: arm64: Support FFA_MEM_RECLAIM2 in host handler
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Snehal Koukuntla <snehalreddy@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The Arm Firmware Framework for Arm A-profile (FF-A) v1.3 ALP5
specification (DEN0140 rev J) [1] introduces the optional
FFA_MEM_RECLAIM2 (0xC4000091) ABI.

Reclaiming large memory regions with the existing FFA_MEM_RECLAIM ABI
can take significant time, or relies on a stateful time-slicing
mechanism in the Relayer. FFA_MEM_RECLAIM2 allows an Owner to reclaim
exclusive access to a subset of pages from a shared or lent memory
region by passing an array of constituent memory region descriptors in
its TX buffer along with a starting descriptor byte offset and initial
page index. The Relayer returns the number of 4K pages reclaimed in
that invocation without maintaining intermediate transaction state.

This series adds the FFA_MEM_RECLAIM2 function ID definition and
implements host proxy support in the pKVM nVHE FF-A handler, unsharing
the reclaimed pages in the host stage-2 page tables upon a successful
reclaim response from EL3/SPMD.

As the FF-A v1.3 specification is still at ALPHA, this series is
posted as an RFC and is not intended for merging until the
specification reaches BETA.

This series is based on kvmarm/next, as Patch 2 uses
ffa_check_unused_args_sbz() introduced in commit 3e9df0b0ebd5
("KVM: arm64: Enforce strict SBZ checks in the FF-A proxy").

Changes in v2:
- Mark as RFC until the FF-A v1.3 specification reaches BETA (Sudeep)
- Rename FFA_FN64_MEM_RECLAIM2 to FFA_MEM_RECLAIM2 (sashiko)
- Check total_pages against the sum of constituent pg_cnt (Vincent)
- Simplify the flags and offset alignment checks (Vincent)
- Rebase on latest kvmarm/next
- Link to v1: https://lore.kernel.org/r/20260921164748.2958578-1-snehalreddy@google.com

[1] https://support.arm.com/documentation/den0140/j

Snehal Koukuntla (2):
  firmware: arm_ffa: Add FFA_MEM_RECLAIM2 function ID
  KVM: arm64: Support FFA_MEM_RECLAIM2 in host handler

 arch/arm64/kvm/hyp/nvhe/ffa.c | 126 ++++++++++++++++++++++++++++++++++
 include/linux/arm_ffa.h       |   1 +
 2 files changed, 127 insertions(+)


base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.56.0.176.g3575e65682-goog

