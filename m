Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6619C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 12:48:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 289686121E
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 12:48:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 289686121E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A67834B4D3;
	Thu, 22 Apr 2021 08:48:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rCoo8HnisVuW; Thu, 22 Apr 2021 08:48:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 873F34B4E4;
	Thu, 22 Apr 2021 08:48:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACCE44B3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 08:48:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EteA+VqKmiao for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 08:48:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B46C44B300
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 08:48:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 911A4613FB;
 Thu, 22 Apr 2021 12:48:31 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lZYku-008tBg-Vz; Thu, 22 Apr 2021 13:48:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-sh@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/5] perf: oprofile spring cleanup
Date: Thu, 22 Apr 2021 13:48:03 +0100
Message-Id: <161909565607.1722628.9529859651633898388.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414134409.1266357-1-maz@kernel.org>
References: <20210414134409.1266357-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-sh@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 maz@kernel.org, hca@linux.ibm.com, acme@kernel.org, borntraeger@de.ibm.com,
 mark.rutland@arm.com, kernel-team@android.com, james.morse@arm.com,
 nathan@kernel.org, alexandru.elisei@arm.com, will@kernel.org,
 suzuki.poulose@arm.com, viresh.kumar@linaro.org, dalias@libc.org,
 peterz@infradead.org, ysato@users.sourceforge.jp
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Rich Felker <dalias@libc.org>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 nathan@kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>,
 Viresh Kumar <viresh.kumar@linaro.org>, kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

On Wed, 14 Apr 2021 14:44:04 +0100, Marc Zyngier wrote:
> This small series builds on top of the work that was started with [1].
> 
> It recently became apparent that KVM/arm64 is the last bit of the
> kernel that still uses perf_num_counters().
> 
> As I went ahead to address this, it became obvious that all traces of
> oprofile had been eradicated from all architectures but arm64, s390
> and sh (plus a bit of cruft in the core perf code). With KVM fixed,
> perf_num_counters() and perf_pmu_name() are finally gone.
> 
> [...]

Applied to kvm-arm64/kill_oprofile_dependency, thanks!

[1/5] KVM: arm64: Divorce the perf code from oprofile helpers
      commit: 5421db1be3b11c5e469cce3760d5c8a013a90f2c
[2/5] arm64: Get rid of oprofile leftovers
      commit: e9c74a686a45e54b2e1c4586b14c84f3ee2f2014
[3/5] s390: Get rid of oprofile leftovers
      commit: 8c3f7913a106aa8b94d331cb59709c84a9a1d55b
[4/5] sh: Get rid of oprofile leftovers
      commit: ac21ecf5ad32b89909bee2b50161ce93d6462b7d
[5/5] perf: Get rid of oprofile leftovers
      commit: 7f318847a0f37b96d8927e8d30ae7b8f149b11f1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
