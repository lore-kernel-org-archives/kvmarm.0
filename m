Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8DC182
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 00:23:57 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id k9-20020a17090a39c900b0021671e97a25so228977pjf.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 16:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lpmvhPUsFZSSLhAYtyq+lnahyrVFyMY6HS7SD72pXuo=;
        b=gNlC3pG6woPDN/PLsQTy7kCfejxGoDjjgCDqeYlESkUwnl4hdFlijtgdjR92RU+gDu
         Zvo8aD6WPhj34C6XqgL8Sskbz28auhO8ceP0/v4Qh6yw/gYonpMDGFF2irfWRDwSHyCJ
         R/ICN9FQuNt2xrG9CFVwkPxtgwMvdbVsMB65kgtt35DNEtXRdtqpCU2V13yuti5yTYL8
         Z3VSSx1ug+op/sspO4IX8cxnJtAIuY89m6RhH/CqaIrxUOGiouWM3QjjyQlbL0bHBQMD
         1YLN18yT9tPwAwJv3JeHZvjHNPbabEUNFw65JWje87zDEuyCoJDSomUUafz3p9TOXCCL
         zUxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lpmvhPUsFZSSLhAYtyq+lnahyrVFyMY6HS7SD72pXuo=;
        b=vLBeMJm5hy8zpElVKJioX8iUZXzFNHmd9gz5foMzBBavJGRml0hnlrpg4Jrp7l/yF2
         u1+mJPzN+8PIk/LGVfBAbZI9qWngss5Jni4mNvF6FpnJ9RzqSPfosndxfzzQZJ7hFgSQ
         6sD1JU47qwrjx2lD7QebwZ03FHi3ARFKwu7AIhlThTIqwOQtUGrcKH2dcKLI2R6dIB30
         8n0KqUXO31aWF8jw+nZpTfHoc8vJ8qcg5eXUsfKfq6lP/qvGNC+u68/wQkb6V4czK7pU
         U6s4g9NCucdlDNHKZoWI/RL71ue9S7Ji0gJry6wWDqjMoLoAsOgBBV/BPaVBnAfJJgTi
         YuEw==
X-Gm-Message-State: ANoB5pk6FeqWEyOAnfM2mc5hI1bMJbXmAsSor8W5caseTtr9QoIm9VVl
	vFPSZ8mlnItz2xiX2LVzv8uEqqgdBqc=
X-Google-Smtp-Source: AA0mqf48bzKDE2Lb8bz6HjmAijvXpLnfL7EKx0nmUTvxI/NOxkKZ8jGDDtXitJI0o6StktvINPXJ6rgmuPU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7609:b0:187:3c62:5837 with SMTP id
 k9-20020a170902760900b001873c625837mr223332pll.123.1668644636835; Wed, 16 Nov
 2022 16:23:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 17 Nov 2022 00:23:48 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117002350.2178351-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: arm64: selftests: Fixes for single-step test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221117002348.1W0qH0nHziSORD-t19ubWhvo0Pv_EoLz1RRhJwIB5mQ@z>

Marc,

I would like to route this through Paolo's tree/queue for 6.2 along with
a big pile of other selftests updates.  I am hoping to get the selftests
pile queued sooner than later as there is a lot of active development in
that area, and don't want to have the selftests be in a broken state.
I'm going to send Paolo a pull request shortly, I'll Cc you (and others)
to keep everyone in the loop and give a chance for objections.



Fix a typo and an imminenent not-technically-a-bug bug in the single-step
test where executing an atomic sequence in the guest with single-step
enable will hang the guest due to eret clearing the local exclusive
monitor.


Sean Christopherson (2):
  KVM: arm64: selftests: Disable single-step with correct KVM define
  KVM: arm64: selftests: Disable single-step without relying on ucall()

 .../selftests/kvm/aarch64/debug-exceptions.c  | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)


base-commit: d663b8a285986072428a6a145e5994bc275df994
-- 
2.38.1.431.g37b22c650d-goog

