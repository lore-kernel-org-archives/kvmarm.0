Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B41C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 13:06:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4A134B23D;
	Mon, 16 May 2022 09:05:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id crTEr0+QqKMr; Mon, 16 May 2022 09:05:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A93AE4B1FA;
	Mon, 16 May 2022 09:05:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E02F14B137
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 09:05:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ar2HY4z3oOUV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 09:05:55 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B7EC4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 09:05:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id EC351B81208;
 Mon, 16 May 2022 13:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13E6C385AA;
 Mon, 16 May 2022 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652706352;
 bh=jw3o8eEDIzu7WOwEeO6x4ffoRPaBbvlab9yuIOiJA0s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=TY8a/yhnlIWAlk2+dlR0uKUyHf2lVgERSK5cvQ9kNXMj9DCwjzehX/sCO8KmfjL1P
 eFsOd0WogOgHHAMo+fCbzDNERd2EPIheLnSi/zR+XPl7ZqtbL/bcvRh1lGvHIkPFJY
 jiOjBmTa01y/qjI5xHslxm0wDtIR/sM3mI0nymDmXit/YMYhPXRVEqoKXPkWumoDYH
 uSXbgsaac9nLOHQxoftyI8EPDSGDLJ19C+iSbu2aWXIopKJ4S7OnGTRu2kiOROZYx/
 XUtck0UOQXLP5aPPEn307Ne47zLPUKHZPLYn+iLv16JmbPvR1Xf4y3Hj2o4JLqt/sN
 LKmXvFbOW/9iQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nqaQ1-00BcP3-Ri; Mon, 16 May 2022 14:05:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: vgic: Misc ITS fixes
Date: Mon, 16 May 2022 14:05:47 +0100
Message-Id: <165270634124.3854328.11897129560761257128.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
References: <20220510001633.552496-1-ricarkol@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 ricarkol@google.com, alexandru.elisei@arm.com, pshier@google.com,
 drjones@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
 andre.przywara@arm.com, reijiw@google.com, oupton@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: andre.przywara@arm.com, pshier@google.com, pbonzini@redhat.com
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

On Mon, 9 May 2022 17:16:29 -0700, Ricardo Koller wrote:
> The purpose of this series is to help debugging failed ITS saves and
> restores.  Failures can be due to misconfiguration on the guest side:
> tables with bogus base addresses, or the guest overwriting L1 indirect
> tables. KVM can't do much in these cases, but one thing it can do to help
> is raising errors as soon as possible. Here are a couple of cases where
> KVM could do more:
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
      commit: cafe7e544d4979da222eaff12141ecac07901b9c
[2/4] KVM: arm64: vgic: Add more checks when restoring ITS tables
      commit: 243b1f6c8f0748bd7b03eab17323f1187e580771
[3/4] KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
      commit: a1ccfd6f6e06eceb632cc29c4f15a32860f05a7e
[4/4] KVM: arm64: vgic: Undo work in failed ITS restores
      commit: 8c5e74c90bb522181dfb051fffff3dad702e704d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
