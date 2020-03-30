Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F03C2D0EB
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 08:47:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1ACB920748
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 08:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hR+egNjQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ACB920748
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81D3D4B16A;
	Mon, 30 Mar 2020 04:47:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 30AXwuALUohJ; Mon, 30 Mar 2020 04:47:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C43F4B22C;
	Mon, 30 Mar 2020 04:47:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FE3A4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 04:47:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kv6bfOvD3+Tn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 04:47:08 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F7F54B22A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 04:47:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585558028;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=V3toyHtdmIDsvhTBATPytSTJjTPkQkswWc1NSEnUkCA=;
 b=hR+egNjQzEk5eifKHk07jk7VBWeFrgqXvYq7fKYtQxX+NcCd1OAIA2ZbklLrKxR0+xF/2r
 +r8JI78ntq5vGu563DNqQHsqN/Mc48Vn/L6vP6tqzOjv+4gjFT3DJXuvSPlYbkxNgKhmQv
 YoHNspxR8+4DWiuOtqbVU69fRIyPg3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-PV9z_La-NdqheXia0TXc2w-1; Mon, 30 Mar 2020 04:47:05 -0400
X-MC-Unique: PV9z_La-NdqheXia0TXc2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 427BD1937FC0;
 Mon, 30 Mar 2020 08:47:04 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C33CE19925;
 Mon, 30 Mar 2020 08:46:58 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
Date: Mon, 30 Mar 2020 10:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

SGkgWmVuZ2h1aSwKCk9uIDMvMzAvMjAgMTA6MzAgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDIwLzMvMjAgMTc6MjQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+ICtzdGF0
aWMgdm9pZCBpdHNfY21kX3F1ZXVlX2luaXQodm9pZCkKPj4gK3sKPj4gK8KgwqDCoCB1bnNpZ25l
ZCBsb25nIG9yZGVyID0gZ2V0X29yZGVyKFNaXzY0SyA+PiBQQUdFX1NISUZUKTsKPj4gK8KgwqDC
oCB1NjQgY2Jhc2VyOwo+PiArCj4+ICvCoMKgwqAgaXRzX2RhdGEuY21kX2Jhc2UgPSAodm9pZCAq
KXZpcnRfdG9fcGh5cyhhbGxvY19wYWdlcyhvcmRlcikpOwo+IAo+IFNob3VsZG4ndCB0aGUgY21k
X2Jhc2UgKGFuZCB0aGUgY21kX3dyaXRlKSBiZSBzZXQgYXMgYSBHVkE/CnllcyBpdCBzaG91bGQK
PiAKPiBPdGhlcndpc2UgSSB0aGluayB3ZSB3aWxsIGVuZC11cCB3aXRoIG1lbW9yeSBjb3JydXB0
aW9uIHdoZW4gd3JpdGluZwo+IHRoZSBjb21tYW5kIHF1ZXVlLsKgIEJ1dCBpdCBzZWVtcyB0aGF0
IGV2ZXJ5dGhpbmcganVzdCB3b3JrcyBmaW5lIC4uLgo+IFNvIEknbSByZWFsbHkgY29uZnVzZWQg
aGVyZSA6LS8KSSB3YXMgdG9sZCBieSBQYW9sbyB0aGF0IHRoZSBWQS9QQSBtZW1vcnkgbWFwIGlz
IGZsYXQgaW4ga3ZtdW5pdCB0ZXN0LgoKPiAKPj4gKwo+PiArwqDCoMKgIGNiYXNlciA9ICgodTY0
KWl0c19kYXRhLmNtZF9iYXNlIHwgKFNaXzY0SyAvIFNaXzRLIC0gMSnCoMKgwqAgfAo+PiBHSVRT
X0NCQVNFUl9WQUxJRCk7Cj4+ICsKPj4gK8KgwqDCoCB3cml0ZXEoY2Jhc2VyLCBpdHNfZGF0YS5i
YXNlICsgR0lUU19DQkFTRVIpOwo+PiArCj4+ICvCoMKgwqAgaXRzX2RhdGEuY21kX3dyaXRlID0g
aXRzX2RhdGEuY21kX2Jhc2U7Cj4+ICvCoMKgwqAgd3JpdGVxKDAsIGl0c19kYXRhLmJhc2UgKyBH
SVRTX0NXUklURVIpOwo+PiArfQo+IAo+IE90aGVyd2lzZSB0aGlzIGxvb2tzIGdvb2QsCj4gUmV2
aWV3ZWQtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgpUaGFua3MhCgpFcmlj
Cj4gCj4gCj4gVGhhbmtzCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
