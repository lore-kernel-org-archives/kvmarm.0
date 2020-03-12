Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FA5C10DCE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 09:52:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 730AE20736
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 09:52:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 730AE20736
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=remlab.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 235B24A576;
	Thu, 12 Mar 2020 05:52:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WNfTzEX+OJqI; Thu, 12 Mar 2020 05:52:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5EF44A51D;
	Thu, 12 Mar 2020 05:52:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2986D4A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 05:40:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vBaoxlY-fx+z for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 05:40:04 -0400 (EDT)
Received: from ns207790.ip-94-23-215.eu (poy.remlab.net [94.23.215.26])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 415DC4A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 05:40:04 -0400 (EDT)
Received: from basile.remlab.net (ip6-localhost [IPv6:::1])
 by ns207790.ip-94-23-215.eu (Postfix) with ESMTP id 983595FD7F;
 Thu, 12 Mar 2020 10:40:02 +0100 (CET)
From: =?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm64: move kimage_vaddr to .rodata
Date: Thu, 12 Mar 2020 11:40:02 +0200
Message-Id: <20200312094002.153302-1-remi@remlab.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 12 Mar 2020 05:52:50 -0400
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

RnJvbTogUmVtaSBEZW5pcy1Db3VybW9udCA8cmVtaS5kZW5pcy5jb3VybW9udEBodWF3ZWkuY29t
PgoKVGhpcyBkYXR1bSBpcyBub3QgcmVmZXJlbmNlZCBmcm9tIC5pZG1hcC50ZXh0OiBpdCBkb2Vz
IG5vdCBuZWVkIHRvIGJlCm1hcHBlZCBpbiBpZG1hcC4gTGV0cyBtb3ZlIGl0IHRvIC5yb2RhdGEg
YXMgaXQgaXMgbmV2ZXIgd3JpdHRlbiB0byBhZnRlcgplYXJseSBib290IG9mIHRoZSBwcmltYXJ5
IENQVS4KKE1heWJlIC5kYXRhLnJvX2FmdGVyX2luaXQgd291bGQgYmUgY2xlYW5lciB0aG91Z2g/
KQoKU2lnbmVkLW9mZi1ieTogUsOpbWkgRGVuaXMtQ291cm1vbnQgPHJlbWlAcmVtbGFiLm5ldD4K
LS0tCiBhcmNoL2FybTY0L2tlcm5lbC9oZWFkLlMgfCAxMiArKysrKysrLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rZXJuZWwvaGVhZC5TIGIvYXJjaC9hcm02NC9rZXJuZWwvaGVhZC5TCmluZGV4IDZl
MDhlZTJiNGQ1NS4uOGU1YzBlMDA0MGU0IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9o
ZWFkLlMKKysrIGIvYXJjaC9hcm02NC9rZXJuZWwvaGVhZC5TCkBAIC00NTcsMTcgKzQ1NywxOSBA
QCBTWU1fRlVOQ19TVEFSVF9MT0NBTChfX3ByaW1hcnlfc3dpdGNoZWQpCiAJYglzdGFydF9rZXJu
ZWwKIFNZTV9GVU5DX0VORChfX3ByaW1hcnlfc3dpdGNoZWQpCiAKKwkucHVzaHNlY3Rpb24gIi5y
b2RhdGEiLCAiYSIKK1NZTV9EQVRBX1NUQVJUKGtpbWFnZV92YWRkcikKKwkucXVhZAkJX3RleHQg
LSBURVhUX09GRlNFVAorU1lNX0RBVEFfRU5EKGtpbWFnZV92YWRkcikKK0VYUE9SVF9TWU1CT0wo
a2ltYWdlX3ZhZGRyKQorCS5wb3BzZWN0aW9uCisKIC8qCiAgKiBlbmQgZWFybHkgaGVhZCBzZWN0
aW9uLCBiZWdpbiBoZWFkIGNvZGUgdGhhdCBpcyBhbHNvIHVzZWQgZm9yCiAgKiBob3RwbHVnIGFu
ZCBuZWVkcyB0byBoYXZlIHRoZSBzYW1lIHByb3RlY3Rpb25zIGFzIHRoZSB0ZXh0IHJlZ2lvbgog
ICovCiAJLnNlY3Rpb24gIi5pZG1hcC50ZXh0IiwiYXd4IgogCi1TWU1fREFUQV9TVEFSVChraW1h
Z2VfdmFkZHIpCi0JLnF1YWQJCV90ZXh0IC0gVEVYVF9PRkZTRVQKLVNZTV9EQVRBX0VORChraW1h
Z2VfdmFkZHIpCi1FWFBPUlRfU1lNQk9MKGtpbWFnZV92YWRkcikKLQogLyoKICAqIElmIHdlJ3Jl
IGZvcnR1bmF0ZSBlbm91Z2ggdG8gYm9vdCBhdCBFTDIsIGVuc3VyZSB0aGF0IHRoZSB3b3JsZCBp
cwogICogc2FuZSBiZWZvcmUgZHJvcHBpbmcgdG8gRUwxLgotLSAKMi4yNS4xCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
