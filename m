Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7A2C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 00:24:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 254E04B831;
	Wed, 16 Nov 2022 19:24:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5lcEX9P-QHo0; Wed, 16 Nov 2022 19:23:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D59F64B7E6;
	Wed, 16 Nov 2022 19:23:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BAEA49F53
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:23:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hKSjrEg17luR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 19:23:58 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D11C649F37
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:23:57 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 q93-20020a17090a1b6600b0021311ab9082so213304pjq.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 16:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=VX9OKVCYLHXg3sgm+SKHBF1lsbwezomKuVCS9AQNAya+wDS7p8CUb6Npay0Vj5HzmX
 8E9xg8IgejWMLpmlcFzvWkkUJ4UjYxp5pVq2FGKGokyxb2d+bcBJTDVN5IBVNi5KhUCZ
 MnSTn8MBhnLhMKAuMkbnUyUEcQsC23U45AipiDs7XktD/JDWdEZYhFiU9Tb0wuTspivV
 CArAhAISVWfaQhhTGbW4NOHhtX/PTzzBuArKpMFHCAcnK7fTmsZal61MiLtCiLP7Fk4N
 /9PVPbez2VwysiSV5a5LPxffgzQR4VzB4hQiF82kEkZCYIHw0qbZJN6ZjYfU9H+VBf5o
 Z9AQ==
X-Gm-Message-State: ANoB5pnsVFjgLcebDR0iyYVrxdmigc8zSYmVN7/eCgZzXZd4MV3BzMkj
 vw+xckF3PCiA8YB3MF8EDWtGa65W3CQ=
X-Google-Smtp-Source: AA0mqf48bzKDE2Lb8bz6HjmAijvXpLnfL7EKx0nmUTvxI/NOxkKZ8jGDDtXitJI0o6StktvINPXJ6rgmuPU=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7609:b0:187:3c62:5837 with SMTP id
 k9-20020a170902760900b001873c625837mr223332pll.123.1668644636835; Wed, 16 Nov
 2022 16:23:56 -0800 (PST)
Date: Thu, 17 Nov 2022 00:23:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117002350.2178351-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: arm64: selftests: Fixes for single-step test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
