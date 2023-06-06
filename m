Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A08174D4
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 17:04:15 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bacfa4eefcbso13610171276.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 10:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686071054; x=1688663054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V8qzwnilU7CBlAyrORrX+Rq/xc7XcjCZI3HBcrsSReA=;
        b=AHguQPaCli0Z6Kk+CO5rYFKKfQWZY0OhpKc5L71HVklmdkvCAO1wmDuyVEKmh9ewUU
         ZgcNzq7xdni1a3CtugomLcW1MAII4596bWnto4+D2qqcJMKr8v3+RiRZqaYxWGrITiKm
         rkGNCX6ed2Fkxt9vXgOPTcvkD4SeXKKOA3SAS3b0kf65oyUIrb10oZ0EBGciPjhcmLL+
         e9oArNo6WBao2TwmmH/+9C754jWjiV2QJzHYOUSQUdnIrKtz/7CiM6scXZ4Bs0yc+JFh
         IBuIq0PfbvSQJJboJee8nSpLJM/xi9r2FM0kQUSvVbSSJb+yDeOq59lT6kOXYeMLh0bj
         OUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686071054; x=1688663054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8qzwnilU7CBlAyrORrX+Rq/xc7XcjCZI3HBcrsSReA=;
        b=glQQLwdiNfPCDptCV3cA8vO/lZJzXznZywY91ubPxPbLCCur6S1W1SRbZgAoJ6GlCx
         6n06TWP5Xe/xhaPmJiL2ZWe8Z+DV9nc7kFg+X4GWRLS1jGDcOLHnDgkByl0SmwBB7twF
         mkSF30PnHw4AQab+o9CyjMfQulwccIgLlekiAKTzEHkq9vBQMUF+9GNtUVyau5Kj1esF
         hEJy/yFB/wd5+YKGsNvy/svHhhXi5DCMIDO9YknNfdyFeL5VyR88MqvZJxx1ysXLQsdi
         LpnpFr9t7xBJbB/ry3g/HkZ1BalB6NuRBtSU/qmmkzsT82sTkanZFxfrZAaiJ/RP56s8
         oaiQ==
X-Gm-Message-State: AC+VfDyZYk1GcYTtaZ8Hdo8555MTcRT58rCMF+D/8S7oYn9JQMPId+KD
	4Wb/z1JNPns1eIYn46OS4kbBV35jU74=
X-Google-Smtp-Source: ACHHUZ4qZcjvSUYMxKH7ZqKK5jG3I1bcHk8c4YCSNi3BAUw5BflMSXSLu5LCw/yiBxYmezusTpkyPX7rEy0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:f50d:0:b0:bb1:ca0e:29a0 with SMTP id
 a13-20020a25f50d000000b00bb1ca0e29a0mr1657054ybe.0.1686071054799; Tue, 06 Jun
 2023 10:04:14 -0700 (PDT)
Date: Tue, 6 Jun 2023 10:04:13 -0700
In-Reply-To: <ZH9mOXYDWnMqoL9c@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
 <ZH8+ZG7DOX9TYcIY@linux.dev> <ZH9CvE54NSVXqjlO@google.com>
 <ZH9OQzKIfwxR3q54@linux.dev> <ZH9UwSueTP37NaY7@google.com> <ZH9mOXYDWnMqoL9c@linux.dev>
Message-ID: <ZH9nDSPySNFs8tW/@google.com>
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible context
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sebastian Ott <sebott@redhat.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 06, 2023, Oliver Upton wrote:
> On Tue, Jun 06, 2023 at 03:46:09PM +0000, Sean Christopherson wrote:
> > I.e. can't you just do?
> 
> No, this would break the 'old' ABI, but if we decide to deliberately
> break it I prefer your suggestion over using CPU0.

Ah, if userspace pins the task when doing KVM_ARM_VCPU_PMU_V3_CTRL, then factoring
in the pCPU matters.
