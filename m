Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1135ECAAD3
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 10:42:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F614BC40;
	Wed, 14 Sep 2022 06:42:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q2rwzyLa8A+a; Wed, 14 Sep 2022 06:42:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39B2A4BC4F;
	Wed, 14 Sep 2022 06:42:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA2194BC40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 06:41:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z9qRRF1wWzd5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 06:41:58 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61F254BC39
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 06:41:58 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 61A1CB819D3;
 Wed, 14 Sep 2022 10:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15444C433D6;
 Wed, 14 Sep 2022 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663152115;
 bh=qZF9xZYgF5fgg3ULL55FWObrA8P8t6PL2FkrqN2TU5M=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SSBKh/oyI9Bwsfx7CwpRUk7rkmI5v3KMUiAH56t6QWKoP5GfnqeRfi110Z8w2Ouhc
 VskBVB7/xoK5YsGlC4HVtrfSBup3fMSly+dtd6JajXX5Kbn7p+ajK8OJMe2C8ja+iJ
 jDGrYyH2U8cvF53jW8eGlZIRKLymbRHB29X64+8Zafn10qGYWq9w9e7RpZLq0R3sNh
 xUZivgtybovgcOauwhuBC4gZP26MQS7epNoD//YxChloR07RfpmKNK8ig35QNPax8K
 8VJoSdwvYVSAJhZG7sCk/TUNeVcM078669cNweLMSxeAlHaGqzCY9ozE4/Y/dpwuPw
 +jRfiN/V81hkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oYPq4-00AB2X-Oj;
 Wed, 14 Sep 2022 11:41:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 0/7] KVM: arm64: Use visibility hook to treat ID regs
 as RAZ
Date: Wed, 14 Sep 2022 11:41:50 +0100
Message-Id: <166315210221.2105633.12201786772874832958.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220913094441.3957645-1-oliver.upton@linux.dev>
References: <20220913094441.3957645-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, oliver.upton@linux.dev,
 james.morse@arm.com, reijiw@google.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 andrew.jones@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>
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

On Tue, 13 Sep 2022 09:44:33 +0000, Oliver Upton wrote:
> For reasons unknown, the Arm architecture defines the 64-bit views of
> the 32-bit ID registers as UNKNOWN [1]. This combines poorly with the
> fact that KVM unconditionally exposes these registers to userspace,
> which could throw a wrench in migration between 64-bit only systems.
> 
> This series reworks KVM's definition of these registers to RAZ/WI with
> the goal of providing consistent register values across 64-bit machines.
> 
> [...]

Applied to kvm-arm64/next, thanks!

[1/7] KVM: arm64: Use visibility hook to treat ID regs as RAZ
      commit: 34b4d20399e6fad2e3379b11e68dff1d1549274e
[2/7] KVM: arm64: Remove internal accessor helpers for id regs
      commit: 4782ccc8ef50fabb70bab9fa73186285dba6d91d
[3/7] KVM: arm64: Drop raz parameter from read_id_reg()
      commit: cdd5036d048ca96ef5212fb37f4f56db40cb1bc2
[4/7] KVM: arm64: Spin off helper for calling visibility hook
      commit: 5d9a718b64e428a40939806873ecf16f072008b3
[5/7] KVM: arm64: Add a visibility bit to ignore user writes
      commit: 4de06e4c1dc949c35c16e4423b4ccd735264b0a9
[6/7] KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
      commit: d5efec7ed826b3b29c6847bf59383d8d07347a4e
[7/7] KVM: selftests: Add test for AArch32 ID registers
      commit: 797b84517c190053597e3f7e03ead15da872e04d

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
