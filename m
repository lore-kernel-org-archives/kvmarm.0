Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6668DC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 19:00:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A55DF4BAF2;
	Thu, 10 Nov 2022 14:00:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VPiYXoyhmoP9; Thu, 10 Nov 2022 14:00:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 940A14BAF0;
	Thu, 10 Nov 2022 14:00:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 135F14BAF0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 14:00:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cV6qbC+pv8uf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 14:00:54 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C403D4BAC2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 14:00:53 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 619EBCE23FD;
 Thu, 10 Nov 2022 19:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8018BC433D6;
 Thu, 10 Nov 2022 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668106844;
 bh=Xo5ZXPpv2Kz2QQAGSoMKDNSlgsw71TmAienD13Km1Z8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bceoK/IiO31N0l4xqOqhszwwzTzzH79tlkJG/Wjq20uTXVJmWDb17Qc3kkVsqqvBC
 VfCLQ5T+w9YOhH/No2W6ja8zCGx34roiiXIvIVVDVr/jM4py3ZdOJoKukGO3K+Tf0O
 yD9c6fzXALHfvsW8ExvyuLLxNqnLxI8Ds9HONhU8cgWn5WY4uuXNXDC30G2/xPDQ8Y
 YkImyr8Pig9+utm8AwGuGvc1fhYktn4XsSN2DRUK8zuLXmq5vLhUb93OWhr4+XB7bF
 6yZpSC0s4YZ7clMuSRyMHJ5ygDpiyfNjCjQWK8JsTQt//J/cuzMt4BB8jIlxAgkhIg
 nRwZpUj7PxKaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1otCn4-005EHi-3v;
 Thu, 10 Nov 2022 19:00:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 0/6] KVM: selftests: memslot_perf_test: aarch64
 cleanup/fixes
Date: Thu, 10 Nov 2022 19:00:38 +0000
Message-Id: <166810681799.3361246.8104966072193072364.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020071209.559062-1-gshan@redhat.com>
References: <20221020071209.559062-1-gshan@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, gshan@redhat.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, oliver.upton@linux.dev,
 linux-kernel@vger.kernel.org, zhenyzha@redhat.com, peterx@redhat.com,
 kvmarm@lists.cs.columbia.edu, ricarkol@google.com, mail@maciej.szmigiero.name,
 shan.gavin@gmail.com, shuah@kernel.org, seanjc@google.com,
 ajones@ventanamicro.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: mail@maciej.szmigiero.name, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhenyzha@redhat.com, shan.gavin@gmail.com,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

On Thu, 20 Oct 2022 15:12:03 +0800, Gavin Shan wrote:
> kvm/selftests/memslots_perf_test doesn't work with 64KB-page-size-host
> and 4KB-page-size-guest on aarch64. In the implementation, the host and
> guest page size have been hardcoded to 4KB. It's ovbiously not working
> on aarch64 which supports 4KB, 16KB, 64KB individually on host and guest.
> 
> This series tries to fix it. After the series is applied, the test runs
> successfully with 64KB-page-size-host and 4KB-page-size-guest.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
      commit: 3bfadb2325891d122771ce534336af531e93d7b2
[2/6] KVM: selftests: memslot_perf_test: Consolidate loop conditions in prepare_vm()
      commit: 2aae5e6795e1407334bb849f96f11c9051b959e2
[3/6] KVM: selftests: memslot_perf_test: Probe memory slots for once
      commit: 34396437b11f904fc61b272e3974f4c92868451b
[4/6] KVM: selftests: memslot_perf_test: Support variable guest page size
      commit: 8675c6f226986ddb67752be22279a0e2385b197e
[5/6] KVM: selftests: memslot_perf_test: Consolidate memory
      commit: 88a64e65484ef6b5cb09fe545d0dd00c950a1131
[6/6] KVM: selftests: memslot_perf_test: Report optimal memory slots
      commit: a69170c65acdf430e24fc1b6174dcc3aa501fe2f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
