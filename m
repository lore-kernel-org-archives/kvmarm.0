Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB2FC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Sep 2022 09:58:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BFFE41049;
	Thu, 29 Sep 2022 05:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6fLHKFkZW7BE; Thu, 29 Sep 2022 05:58:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E8F04B10B;
	Thu, 29 Sep 2022 05:58:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F5641174
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 05:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ls+BSJl0HHRF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Sep 2022 05:58:47 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68CE341049
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 05:58:47 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id ED2EDB82209;
 Thu, 29 Sep 2022 09:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF62C433D6;
 Thu, 29 Sep 2022 09:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664445524;
 bh=eSMwBKa9imsr6TaLmSDnLEatSh53XGbj9jMl67t/9vc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=IY4IgaY4MKlkwWYDiOCrp8cVtrr18gRGx7Yky3IbBs+4xmxgOrZk/IsBVd8XNxld9
 Q3AcpGyfvasdn8ZiCdOTbrxjOLMlP7vidyO3z+iQkrnOiqAocBlGTMFXfZUMnnGr8t
 u/TatetA3VYzb3CtEAIQ5ky9fiESUO57t0P8zmgtk3w8pQqvCOwPcWi6E0uEe0tp9G
 9fb9jPSTR4OU26+mHjvHckds8bfakaH1+4CaVR0IaVbRWrQn0j9OY9N3ZyornVOoPs
 XHo5mzLfY0Jwyzm580m19MTyuU5O+e50RQztuApkiCz2pJ6L7ZhQvGwhqzxCGgOsod
 vSlqx3r5soA2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1odqJW-00DVUy-Ag;
 Thu, 29 Sep 2022 10:58:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 0/6] KVM: Fix dirty-ring ordering on weakly ordered
 architectures
Date: Thu, 29 Sep 2022 10:58:39 +0100
Message-Id: <166444538478.3798115.5401520250620155536.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, will@kernel.org,
 dmatlack@google.com, zhenyzha@redhat.com, shuah@kernel.org,
 pbonzini@redhat.com, shan.gavin@gmail.com, bgardon@google.com,
 andrew.jones@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com, zhenyzha@redhat.com,
 shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, andrew.jones@linux.dev, shuah@kernel.org
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

On Mon, 26 Sep 2022 15:51:14 +0100, Marc Zyngier wrote:
> [Same distribution list as Gavin's dirty-ring on arm64 series]
> 
> This is an update on the initial series posted as [0].
> 
> As Gavin started posting patches enabling the dirty-ring infrastructure
> on arm64 [1], it quickly became apparent that the API was never intended
> to work on relaxed memory ordering architectures (owing to its x86
> origins).
> 
> [...]

Applied to next, thanks!

[1/6] KVM: Use acquire/release semantics when accessing dirty ring GFN state
      commit: 8929bc9659640f35dd2ef8373263cbd885b4a072
[2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
      commit: 17601bfed909fa080fcfd227b57da2bd4dc2d2a6
[3/6] KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
      commit: fc0693d4e5afe3c110503c3afa9f60600f9e964b
[4/6] KVM: Document weakly ordered architecture requirements for dirty ring
      commit: 671c8c7f9f2349d8b2176ad810f1406794011f63
[5/6] KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release semantics
      commit: 4eb6486cb43c93382c27a2659ba978c660e98498
[6/6] KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available
      commit: 4b3402f1f4d9860301d6d5cd7aff3b67f678d577

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
