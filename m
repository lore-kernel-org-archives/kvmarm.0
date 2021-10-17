Return-Path: <SRS0=PgOR=PF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEE5C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 10:30:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB54061179
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 10:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BB54061179
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6F849FE6;
	Sun, 17 Oct 2021 06:30:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MPQqwZszrjoy; Sun, 17 Oct 2021 06:30:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F144086C;
	Sun, 17 Oct 2021 06:30:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8A4940630
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Oct 2021 06:30:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JSxXuWnR0R-V for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Oct 2021 06:30:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0572E4086C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Oct 2021 06:30:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F3D3B6103B;
 Sun, 17 Oct 2021 10:30:17 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mc3Ql-00HJIb-R3; Sun, 17 Oct 2021 11:30:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Jia He <justin.he@arm.com>
Subject: Re: [PATCH v2 0/2] Add memcg accounting to Arm KVM
Date: Sun, 17 Oct 2021 11:30:12 +0100
Message-Id: <163446660410.1612145.1235091428882070255.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907123112.10232-1-justin.he@arm.com>
References: <20210907123112.10232-1-justin.he@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, james.morse@arm.com,
 alexandru.elisei@arm.com, justin.he@arm.com, liushixin2@huawei.com,
 catalin.marinas@arm.com, eric.auger@redhat.com, keescook@chromium.org,
 kvmarm@lists.cs.columbia.edu, ndesaulniers@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 lorenzo.pieralisi@arm.com, yuzenghui@huawei.com, nixiaoming@huawei.com,
 will@kernel.org, samitolvanen@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Liu Shixin <liushixin2@huawei.com>, Sami Tolvanen <samitolvanen@google.com>,
 Xiaoming Ni <nixiaoming@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, 7 Sep 2021 20:31:10 +0800, Jia He wrote:
> Inspired by what had been done by X86 kvm and kvm common codes, it would
> be better to make arm64 kvm consistent with them.
> 
> The memory allocations of VM scope should be charged into VM process.
> Hence change the allocation flag from GFP_KERNEL to GFP_KERNEL_ACCOUNT.
> 
> There remain some GFP_KERNEL unchanged since they are global allocations,
> instead of VM scope.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: vgic: Add memcg accounting to vgic allocations
      commit: 3ef231670b9e9001316a426e794b2c74b8f6b4f6
[2/2] KVM: arm64: Add memcg accounting to KVM allocations
      commit: 115bae923ac8bb29ee635e0ed6b4d5a3eec9371e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
