Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221E2745D5
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710438681; cv=none; b=pq5BhjF3hcDGchc20ZHhKuhXfiRkNjussdpVqIHO9/syLSve0/Q9bYcoGxFmSZD2kG9QPqnOIN12U2jXUIlAR7NsgTgkWYfVl8Vh7RuLTTFtP+PJq4f2F/1wUo9Hs/D+DW5h3AO0GFAhW3LEi6JX8BTMi+tpx9QSvmxpQelDuHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710438681; c=relaxed/simple;
	bh=kUVqfqBl6OrS8y6lo4ykNNWJdbCOGT3O6tMkIPe5R8I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=A+By0XRDQYFCSoi4apVqMeVHtwgJqkAWTh5Kvp4Kkro2fiYidHfKJTiNdkOQFqNvS6fG5voN2TTUzWhKsg75NEfHttXlYEDOGJO5D47+DX9EfH18IAt7turylwsEk1cwxVOG3g5IgV0CSWU6eIJ3S6b3Fj4diH2AXaMXBAF8Cds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eHajfmIC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eHajfmIC"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so2034470276.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 10:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710438679; x=1711043479; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yo6oS4AcC009MmPBD5DloFbZft+lin+hzANIRBSkUSA=;
        b=eHajfmICAZnTU0y3VZnUSqyIp3uotXWxlPG6ixsBttFCqVAdJ0Z07yPzyX8e1/zYP/
         DbjfBvKj/8Y6OLyTf14bVeo8gbSSZHY8zmi9Yp7aWhof0pWdKlRMb4ExxqNeSKe8r2Um
         EUDhaGOK+OWiSKvNqrBpmfMkKrBBeX4ybAoZeffne509Z7wcADuFkp0vqEGxSx1obYzO
         eNeHcWAPCdD6lU0wzDYaANdxAeje94oRIH4zMJ0qEvuQkLmaQ/NnstDtKUVGaDQDcpJ1
         pBHA9RdcMpFBQl2kd8B+I8JtJVa6rUHijUYqn9PUsWFV4c2vzgojjJkC2TakyrJ2MTwe
         J0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710438679; x=1711043479;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Yo6oS4AcC009MmPBD5DloFbZft+lin+hzANIRBSkUSA=;
        b=Htke17LHA6ZYobYTBKE5WzY9NKeJb/9kMmigTyOsqJMqd2s81oZ5kfmk2pPxM3V5tD
         fDnP5Q3MK8CGiEzSuSDT+ZNcTaby+4/rWLCe/mkGkc0ejWaR4dyH3Pk1vpVJ6YQFoe2X
         jOgPWTIsIFeGO83a3YApP2EX+/79ENY316cTcS1UqTn7TOPTkh1kwCjXKd2IZSJU0Mm0
         rRlIZOFuRh7Jf5kqX+qFICH5MHhghrg+Re1JtvXvCAnMHjZvBbV4anyES8qiZviJZuEL
         b7D5gWcEhE4IQvm6ZPewOfNgB8FCIHEvl6xOYUlOdMAuWT6N8/W64hoSxfV5B4kmUM4i
         xfOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHw/ATtvmSYvYLniAc/kB2wMCYp7VJxH/TLfEakrZBFwL96L42L9NMGu8Ez6TtHF0QRxPTqDuWOHUpx+E55rc9yzMi+hQI
X-Gm-Message-State: AOJu0YxjPV4yvAhBRd6eYlBViou0s6ERShX823iVR5SlYsCWNGqX/9ia
	q4lr9nLUUR1NRYYvt0tFOh9llUeKTGEluTMq7vHMGqVohahtwDwvuIXVWmdKjZ56rJOGmj3hJgH
	hNA==
X-Google-Smtp-Source: AGHT+IHj12Fv5pkl+ktVSIACg0smeX5esnto6C7bfpPJvOND3/RpBJcke5Qg1JIRU0EQaPE2grYP8ghXkRc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b85:b0:dc6:e1ed:bd1a with SMTP id
 ei5-20020a0569021b8500b00dc6e1edbd1amr582659ybb.2.1710438679190; Thu, 14 Mar
 2024 10:51:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 10:51:15 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314175116.2366301-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Fix __GUEST_ASSERT() format warnings in ARM's
 arch timer test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Use %x instead of %lx when printing uint32_t variables to fix format
warnings in ARM's arch timer test.

aarch64/arch_timer.c: In function =E2=80=98guest_run_stage=E2=80=99:
aarch64/arch_timer.c:138:33: warning: format =E2=80=98%lx=E2=80=99 expects =
argument of type =E2=80=98long unsigned int=E2=80=99,
                             but argument 6 has type =E2=80=98uint32_t=E2=
=80=99 {aka =E2=80=98unsigned int=E2=80=99} [-Wformat=3D]
  138 |                                 "config_iter + 1 =3D 0x%lx, irq_ite=
r =3D 0x%lx.\n"
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
......
  141 |                                 config_iter + 1, irq_iter);
      |                                 ~~~~~~~~~~~~~~~
      |                                             |
      |                                             uint32_t {aka unsigned =
int}

Fixes: d1dafd065a23 ("KVM: arm64: selftests: Enable tuning of error margin =
in arch_timer test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

2024 Whack-a-Mole Champion.

Note, this is based on kvm/queue and probably won't apply to your tree as
the buggy commit went in via the RISC-V pull request.

 tools/testing/selftests/kvm/aarch64/arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testi=
ng/selftests/kvm/aarch64/arch_timer.c
index ddba2c2fb5de..93100b3f1312 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -135,7 +135,7 @@ static void guest_run_stage(struct test_vcpu_shared_dat=
a *shared_data,
=20
 		irq_iter =3D READ_ONCE(shared_data->nr_iter);
 		__GUEST_ASSERT(config_iter + 1 =3D=3D irq_iter,
-				"config_iter + 1 =3D 0x%lx, irq_iter =3D 0x%lx.\n"
+				"config_iter + 1 =3D 0x%x, irq_iter =3D 0x%x.\n"
 				"  Guest timer interrupt was not trigged within the specified\n"
 				"  interval, try to increase the error margin by [-e] option.\n",
 				config_iter + 1, irq_iter);

base-commit: e9a2bba476c8332ed547fce485c158d03b0b9659
--=20
2.44.0.291.gc1ea87d7ee-goog

