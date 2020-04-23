Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3B4C54FCB
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 15:41:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E76732075A
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 15:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wgO3AfdB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E76732075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E73F4B205;
	Thu, 23 Apr 2020 11:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Or4zqMxAG81o; Thu, 23 Apr 2020 11:40:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8E4B4B28D;
	Thu, 23 Apr 2020 11:40:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 309A14B1EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 11:40:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5CFGi0T+DqeI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 11:40:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AD594B1EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 11:40:33 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5B07E2076C;
 Thu, 23 Apr 2020 15:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587656432;
 bh=4DuwlILzO9hzvyysFjgJ3379wFv4s1rSPnAK2bFpaTs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=wgO3AfdBxQ5L9TwoxHZk2oTCEXGNO3QjqONrDkRWAfcWa8L76plT1O2ZPWegtrg7+
 i8C3AzprII/rdO3bjLm1LgCwHm+bLBiI1Dr9+Rq87/xMdk4og41x2UUipxc459DCl0
 o6gy5G51pXzJL8MvLgDqeB8GlA+FRcCjBpf8IxkE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRdxm-005oPM-Mj; Thu, 23 Apr 2020 16:40:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/8] KVM: arm: vgic: Fix limit condition when writing to
 GICD_I[CS]ACTIVER
Date: Thu, 23 Apr 2020 16:40:02 +0100
Message-Id: <20200423154009.4113562-2-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200423154009.4113562-1-maz@kernel.org>
References: <20200423154009.4113562-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 andre.przywara@arm.com, christoffer.dall@arm.com, julien@xen.org,
 yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
 stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

V2hlbiBkZWNpZGluZyB3aGV0aGVyIGEgZ3Vlc3QgaGFzIHRvIGJlIHN0b3BwZWQgd2UgY2hlY2sg
d2hldGhlciB0aGlzCmlzIGEgcHJpdmF0ZSBpbnRlcnJ1cHQgb3Igbm90LiBVbmZvcnR1bmF0ZWx5
LCB0aGVyZSdzIGFuIG9mZi1ieS1vbmUgYnVnCmhlcmUsIGFuZCB3ZSBmYWlsIHRvIHJlY29nbml6
ZSBhIHdob2xlIHJhbmdlIG9mIGludGVycnVwdHMgYXMgYmVpbmcKZ2xvYmFsIChHSUN2MiBTUElz
IDMyLTYzKS4KCkZpeCB0aGUgY29uZGl0aW9uIGZyb20gPiB0byBiZSA+PS4KCkNjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnCkZpeGVzOiBhYmQ3MjI5NjI2YjkzICgiS1ZNOiBhcm0vYXJtNjQ6IFNp
bXBsaWZ5IGFjdGl2ZV9jaGFuZ2VfcHJlcGFyZSBhbmQgcGx1ZyByYWNlIikKUmVwb3J0ZWQtYnk6
IEFuZHLDqSBQcnp5d2FyYSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4KU2lnbmVkLW9mZi1ieTog
TWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KLS0tCiB2aXJ0L2t2bS9hcm0vdmdpYy92Z2lj
LW1taW8uYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8uYyBiL3Zp
cnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby5jCmluZGV4IDIxOTkzMDI1OTdmYWYuLmQwODVlMDQ3
OTUzZmEgMTAwNjQ0Ci0tLSBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby5jCisrKyBiL3Zp
cnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby5jCkBAIC00NDQsNyArNDQ0LDcgQEAgc3RhdGljIHZv
aWQgdmdpY19tbWlvX2NoYW5nZV9hY3RpdmUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qg
dmdpY19pcnEgKmlycSwKIHN0YXRpYyB2b2lkIHZnaWNfY2hhbmdlX2FjdGl2ZV9wcmVwYXJlKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIGludGlkKQogewogCWlmICh2Y3B1LT5rdm0tPmFyY2gu
dmdpYy52Z2ljX21vZGVsID09IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMyB8fAotCSAgICBpbnRp
ZCA+IFZHSUNfTlJfUFJJVkFURV9JUlFTKQorCSAgICBpbnRpZCA+PSBWR0lDX05SX1BSSVZBVEVf
SVJRUykKIAkJa3ZtX2FybV9oYWx0X2d1ZXN0KHZjcHUtPmt2bSk7CiB9CiAKQEAgLTQ1Miw3ICs0
NTIsNyBAQCBzdGF0aWMgdm9pZCB2Z2ljX2NoYW5nZV9hY3RpdmVfcHJlcGFyZShzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIHUzMiBpbnRpZCkKIHN0YXRpYyB2b2lkIHZnaWNfY2hhbmdlX2FjdGl2ZV9m
aW5pc2goc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgaW50aWQpCiB7CiAJaWYgKHZjcHUtPmt2
bS0+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPT0gS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1YzIHx8Ci0J
ICAgIGludGlkID4gVkdJQ19OUl9QUklWQVRFX0lSUVMpCisJICAgIGludGlkID49IFZHSUNfTlJf
UFJJVkFURV9JUlFTKQogCQlrdm1fYXJtX3Jlc3VtZV9ndWVzdCh2Y3B1LT5rdm0pOwogfQogCi0t
IAoyLjI2LjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
