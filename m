Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A236C32771
	for <kvmarm@archiver.kernel.org>; Fri, 19 Aug 2022 19:02:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 963B54CA0B;
	Fri, 19 Aug 2022 15:02:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QqMl4830+Z28; Fri, 19 Aug 2022 15:02:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C54E4CA10;
	Fri, 19 Aug 2022 15:02:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94FF04CA0D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 15:02:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bsh+s7lTgnQs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Aug 2022 15:02:33 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABBA04CA0B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 15:02:33 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660935752;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=qeilJkUjgYD++ZOMtMBSkczOrjiQxtJLWwy7xJrcqHQ=;
 b=rmyb69jLBe9H6Q7EGCSdAkL+5/r8HNg5NEW/e98Kh028IlZIEQyM7HGnap+fhpigMzbZHH
 dNPOhhGxNEbO6jXFX/3bB7mHpsNcgyJYnsXQAGc3OvLJWHloYpJ3Dir+aU2UeBy08aQU4P
 wTN4uCNP4PyoNKE89tgBNnVYh0xmwxc=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] mailmap: Update Oliver's email address
Date: Fri, 19 Aug 2022 19:01:58 +0000
Message-Id: <20220819190158.234290-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

V2hpbGUgSSdtIHN0aWxsIGF0IEdvb2dsZSwgSSd2ZSBzaW5jZSBzd2l0Y2hlZCB0byBhIGxpbnV4
LmRldiBhY2NvdW50CmZvciB3b3JraW5nIHVwc3RyZWFtLgoKQWRkIGFuIGFsaWFzIHRvIHRoZSBu
ZXcgYWRkcmVzcy4KClNpZ25lZC1vZmYtYnk6IE9saXZlciBVcHRvbiA8b2xpdmVyLnVwdG9uQGxp
bnV4LmRldj4KLS0tCiAubWFpbG1hcCB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspCgpkaWZmIC0tZ2l0IGEvLm1haWxtYXAgYi8ubWFpbG1hcAppbmRleCAzODI1NWQ0MTJmMGIu
LmQxZjdlZDEwMTljZiAxMDA2NDQKLS0tIGEvLm1haWxtYXAKKysrIGIvLm1haWxtYXAKQEAgLTMz
MCw2ICszMzAsNyBAQCBPbGVrc2lqIFJlbXBlbCA8bGludXhAcmVtcGVsLXByaXZhdC5kZT4gPGV4
dGVybmFsLk9sZWtzaWouUmVtcGVsQGRlLmJvc2NoLmNvbT4KIE9sZWtzaWogUmVtcGVsIDxsaW51
eEByZW1wZWwtcHJpdmF0LmRlPiA8Zml4ZWQtdGVybS5PbGVrc2lqLlJlbXBlbEBkZS5ib3NjaC5j
b20+CiBPbGVrc2lqIFJlbXBlbCA8bGludXhAcmVtcGVsLXByaXZhdC5kZT4gPG8ucmVtcGVsQHBl
bmd1dHJvbml4LmRlPgogT2xla3NpaiBSZW1wZWwgPGxpbnV4QHJlbXBlbC1wcml2YXQuZGU+IDxv
cmVAcGVuZ3V0cm9uaXguZGU+CitPbGl2ZXIgVXB0b24gPG9saXZlci51cHRvbkBsaW51eC5kZXY+
IDxvdXB0b25AZ29vZ2xlLmNvbT4KIFBhbGkgUm9ow6FyIDxwYWxpQGtlcm5lbC5vcmc+IDxwYWxp
LnJvaGFyQGdtYWlsLmNvbT4KIFBhb2xvICdCbGFpc29yYmxhZGUnIEdpYXJydXNzbyA8YmxhaXNv
cmJsYWRlQHlhaG9vLml0PgogUGF0cmljayBNb2NoZWwgPG1vY2hlbEBkaWdpdGFsaW1wbGFudC5v
cmc+CgpiYXNlLWNvbW1pdDogNTY4MDM1YjAxY2ZiMTA3YWY4ZDJlNGJkMmZiOWFlYTIyY2Y1Yjg2
OAotLSAKMi4zNy4xLjU5NS5nNzE4YTNhOGYwNC1nb29nCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
