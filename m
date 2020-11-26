Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E65C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:34:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F9C321D7E
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIqV3mB4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F9C321D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD92D4C042;
	Thu, 26 Nov 2020 10:34:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8+lBHOOoJE4d; Thu, 26 Nov 2020 10:34:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AECB04C05A;
	Thu, 26 Nov 2020 10:34:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E1F94C042
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:34:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dpLV0hZSE9Y8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:34:18 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 239544BD6D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:34:18 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0729821D46;
 Thu, 26 Nov 2020 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606404857;
 bh=Igx9jXBr7rpPOrw2MqxIsTEP9nndo9myMGoaHB2g/iU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=nIqV3mB40duYn7B9JjVKyQhYGKWwujORRiFiiVPiXLxlIOSwKwVa0X9U9n6FOVCxT
 DxkADEC1BnDQ6kWO4ArX0X+EjeN4eSH2VJJUIlGiuydBv1nTNbUW6eerpsJVp+bF7j
 hTaLSTLt1uiueA5OJ0v/jqA+fYaZIT3C/smkDufQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiJHi-00DqFH-DH; Thu, 26 Nov 2020 15:34:14 +0000
MIME-Version: 1.0
Date: Thu, 26 Nov 2020 15:34:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 6/8] KVM: arm64: Remove dead PMU sysreg decoding code
In-Reply-To: <1ed6dfd6-4ace-a562-bc2f-054a5c853fa6@arm.com>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-7-maz@kernel.org>
 <1ed6dfd6-4ace-a562-bc2f-054a5c853fa6@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <3ae09ecc95b732129f71076b4b59c873@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgQWxleCwKCk9uIDIwMjAtMTEtMjYgMTU6MTgsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4g
SGkgTWFyYywKPiAKPiBJIGNoZWNrZWQgYW5kIGluZGVlZCB0aGUgcmVtYWluaW5nIGNhc2VzIGNv
dmVyIGFsbCByZWdpc3RlcnMgdGhhdCB1c2UKPiB0aGlzIGFjY2Vzc29yLgo+IAo+IEhvd2V2ZXIs
IEknbSBhIGJpdCB0b3JuIGhlcmUuIFRoZSB3YXJuaW5nIHRoYXQgSSBnb3Qgd2hlbiB0cnlpbmcg
dG8gcnVuIAo+IGEgZ3Vlc3QKPiB3aXRoIHRoZSBQTVUgZmVhdHVyZSBmbGFnIHNldCwgYnV0IG5v
dCBpbml0aWFsaXplZCAocmVwb3J0ZWQgYXQgWzFdKQo+IHdhcyBhbHNvIG5vdAo+IHN1cHBvc2Vk
IHRvIGV2ZXIgYmUgcmVhY2hlZDoKPiAKPiBzdGF0aWMgdTMyIGt2bV9wbXVfZXZlbnRfbWFzayhz
dHJ1Y3Qga3ZtICprdm0pCj4gewo+IMKgwqDCoCBzd2l0Y2ggKGt2bS0+YXJjaC5wbXV2ZXIpIHsK
PiDCoMKgwqAgY2FzZSAxOsKgwqDCoCDCoMKgwqAgwqDCoMKgIC8qIEFSTXY4LjAgKi8KPiDCoMKg
wqAgwqDCoMKgIHJldHVybiBHRU5NQVNLKDksIDApOwo+IMKgwqDCoCBjYXNlIDQ6wqDCoMKgIMKg
wqDCoCDCoMKgwqAgLyogQVJNdjguMSAqLwo+IMKgwqDCoCBjYXNlIDU6wqDCoMKgIMKgwqDCoCDC
oMKgwqAgLyogQVJNdjguNCAqLwo+IMKgwqDCoCBjYXNlIDY6wqDCoMKgIMKgwqDCoCDCoMKgwqAg
LyogQVJNdjguNSAqLwo+IMKgwqDCoCDCoMKgwqAgcmV0dXJuIEdFTk1BU0soMTUsIDApOwo+IMKg
wqDCoCBkZWZhdWx0OsKgwqDCoCDCoMKgwqAgLyogU2hvdWxkbid0IGJlIGhlcmUsIGp1c3QgZm9y
IHNhbml0eSAqLwo+IMKgwqDCoCDCoMKgwqAgV0FSTl9PTkNFKDEsICJVbmtub3duIFBNVSB2ZXJz
aW9uICVkXG4iLCBrdm0tPmFyY2gucG11dmVyKTsKPiDCoMKgwqAgwqDCoMKgIHJldHVybiAwOwo+
IMKgwqDCoCB9Cj4gfQo+IAo+IEkgcmVhbGl6ZSBpdCdzIG5vdCBleGFjdGx5IHRoZSBzYW1lIHRo
aW5nIGFuZCBJJ2xsIGxlYXZlIGl0IHVwIHRvIHlvdQo+IGlmIHlvdSB3YW50Cj4gdG8gYWRkIGEg
d2FybmluZyBmb3IgdGhlIGNhc2VzIHRoYXQgc2hvdWxkIG5ldmVyIGhhcHBlbi4gSSdtIGZpbmUg
Cj4gZWl0aGVyIHdheToKCkkgYWxyZWFkeSBoYXZlIHF1ZXVlZCBzdWNoIGEgd2FybmluZ1sxXS4g
SXQgdHVybnMgb3V0IHRoYXQgTExWTSB3YXJucwppZHggY2FuIGJlIGxlZnQgdW5pbml0aWFsaXpl
ZCwgYW5kIHNob3V0cy4gTGV0IG1lIGtub3cgaWYgdGhhdCB3b3Jrcwpmb3IgeW91LgoKVGhhbmtz
LAoKICAgICAgICAgTS4KClsxXSAKaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvbWF6L2FybS1wbGF0Zm9ybXMuZ2l0L2NvbW1pdC8/aD1rdm0tYXJtNjQvcG11
LXVuZGVmJmlkPWFmN2VmZjcwZWFmOGYyODE3OTMzNGY1YWVhYmI3MGEzMDYyNDJjODMKLS0gCkph
enogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
