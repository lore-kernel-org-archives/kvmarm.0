Return-Path: <SRS0=7JFX=ZK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0181DC432C0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Nov 2019 08:06:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 724702071C
	for <kvmarm@archiver.kernel.org>; Mon, 18 Nov 2019 08:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hIpeA6rq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 724702071C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8004AC83;
	Mon, 18 Nov 2019 03:06:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vJglJ6FZNWCR; Mon, 18 Nov 2019 03:06:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C85874AC84;
	Mon, 18 Nov 2019 03:06:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10E324A7E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Nov 2019 03:06:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P2EeNj6H5+LE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Nov 2019 03:06:22 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F2664A5C3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Nov 2019 03:06:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574064381;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KNJ55WbT7VycZ8uCkUtv4AEa8qD8C2oOjxRZZ8HXkAA=;
 b=hIpeA6rqJt5gUDG30A2wDFj1AJFCvgindTiq2yv+7Ly+rsCdbEK4ts/8kqmd0zPb6ZlJS9
 yvtx8GO3ky9vA3IJsI+Pr2B+kxhVW7cgleHmC9q9KL/ps8D5EyQygTvL3XEf1F0Dd1vAiT
 5TXr1DXlaw1dP/cSOSc1uraHkaBP4xg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-ab65OHwEMvKV-SjST_EDqw-1; Mon, 18 Nov 2019 03:06:18 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01E1D801FD2;
 Mon, 18 Nov 2019 08:06:17 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D32B10002D0;
 Mon, 18 Nov 2019 08:06:15 +0000 (UTC)
Date: Mon, 18 Nov 2019 09:06:12 +0100
From: Andrew Jones <drjones@redhat.com>
To: kuhn.chenqun@huawei.com
Subject: Re: [kvm-unit-tests PATCH] arm: Add missing test name prefix for
 pl031 and spinlock
Message-ID: <20191118080612.cudiybi3xlkruc55@kamzik.brq.redhat.com>
References: <20191118022720.17488-1-kuhn.chenqun@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20191118022720.17488-1-kuhn.chenqun@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ab65OHwEMvKV-SjST_EDqw-1
X-Mimecast-Spam-Score: 0
Content-Disposition: inline
Cc: pannengyuan@huawei.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 zhang.zhanghailiang@huawei.com
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

T24gTW9uLCBOb3YgMTgsIDIwMTkgYXQgMTA6Mjc6MjBBTSArMDgwMCwga3Vobi5jaGVucXVuQGh1
YXdlaS5jb20gd3JvdGU6Cj4gRnJvbTogQ2hlbiBRdW4gPGt1aG4uY2hlbnF1bkBodWF3ZWkuY29t
Pgo+IAo+IHBsMDMxIGFuZCBzcGlubG9jayB0ZXN0Y2FzZSB3aXRob3V0IHByZWZpeCwgd2hlbiBy
dW5uaW5nCj4gdGhlIHVuaXQgdGVzdHMgaW4gVEFQIG1vZGUgKC4vcnVuX3Rlc3RzLnNoIC10KSwg
aXQgaXMKPiBkaWZmaWN1bHQgdG8gdGhlIHRlc3QgcmVzdWx0cy4KPiAKPiBUaGUgdGVzdCByZXN1
bHRz77yaCj4gb2sgMTMgLSBQZXJpcGgvUENlbGwgSURzIG1hdGNoCj4gb2sgMTQgLSBSL08gZmll
bGRzIGFyZSBSL08KPiBvayAxNSAtIFJUQyB0aWNrcyBhdCAxSFoKPiBvayAxNiAtIFJUQyBJUlEg
bm90IHBlbmRpbmcgeWV0Cj4gLi4uCj4gb2sgMjQgLSAgIFJUQyBJUlEgbm90IHBlbmRpbmcgYW55
bW9yZQo+IG9rIDI1IC0gQ1BVMTogRG9uZSAtIEVycm9yczogMAo+IG9rIDI2IC0gQ1BVMDogRG9u
ZSAtIEVycm9yczogMAo+IAo+IEl0IHNob3VsZCBiZSBsaWtlIHRoaXPvvJoKPiBvayAxMyAtIHBs
MDMxOiBQZXJpcGgvUENlbGwgSURzIG1hdGNoCj4gb2sgMTQgLSBwbDAzMTogUi9PIGZpZWxkcyBh
cmUgUi9PCj4gb2sgMTUgLSBwbDAzMTogUlRDIHRpY2tzIGF0IDFIWgo+IG9rIDE2IC0gcGwwMzE6
IFJUQyBJUlEgbm90IHBlbmRpbmcgeWV0Cj4gLi4uCj4gb2sgMjQgLSBwbDAzMTogICBSVEMgSVJR
IG5vdCBwZW5kaW5nIGFueW1vcmUKPiBvayAyNSAtIHNwaW5sb2NrOiBDUFUwOiBEb25lIC0gRXJy
b3JzOiAwCj4gb2sgMjYgLSBzcGlubG9jazogQ1BVMTogRG9uZSAtIEVycm9yczogMAo+IAo+IFNp
Z25lZC1vZmYtYnk6IENoZW4gUXVuIDxrdWhuLmNoZW5xdW5AaHVhd2VpLmNvbT4KPiAtLS0KPiAg
YXJtL3BsMDMxLmMgICAgICAgICB8IDEgKwo+ICBhcm0vc3BpbmxvY2stdGVzdC5jIHwgMSArCj4g
IDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL2FybS9w
bDAzMS5jIGIvYXJtL3BsMDMxLmMKPiBpbmRleCA1NjcyZjM2Li5kMGM5YzEwIDEwMDY0NAo+IC0t
LSBhL2FybS9wbDAzMS5jCj4gKysrIGIvYXJtL3BsMDMxLmMKPiBAQCAtMjUyLDYgKzI1Miw3IEBA
IGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKPiAgCQlyZXR1cm4gMDsKPiAgCX0KPiAg
Cj4gKwlyZXBvcnRfcHJlZml4X3B1c2goInBsMDMxIik7Cj4gIAlyZXBvcnQoIlBlcmlwaC9QQ2Vs
bCBJRHMgbWF0Y2giLCAhY2hlY2tfaWQoKSk7Cj4gIAlyZXBvcnQoIlIvTyBmaWVsZHMgYXJlIFIv
TyIsICFjaGVja19ybygpKTsKPiAgCXJlcG9ydCgiUlRDIHRpY2tzIGF0IDFIWiIsICFjaGVja19y
dGNfZnJlcSgpKTsKPiBkaWZmIC0tZ2l0IGEvYXJtL3NwaW5sb2NrLXRlc3QuYyBiL2FybS9zcGlu
bG9jay10ZXN0LmMKPiBpbmRleCBkNTU0NzFiLi5mZjE2ZmIwIDEwMDY0NAo+IC0tLSBhL2FybS9z
cGlubG9jay10ZXN0LmMKPiArKysgYi9hcm0vc3BpbmxvY2stdGVzdC5jCj4gQEAgLTcyLDYgKzcy
LDcgQEAgc3RhdGljIHZvaWQgdGVzdF9zcGlubG9jayh2b2lkICpkYXRhIF9fdW51c2VkKQo+ICAK
PiAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQo+ICB7Cj4gKwlyZXBvcnRfcHJlZml4
X3B1c2goInNwaW5sb2NrIik7Cj4gIAlpZiAoYXJnYyA+IDEgJiYgc3RyY21wKGFyZ3ZbMV0sICJi
YWQiKSAhPSAwKSB7Cj4gIAkJbG9ja19vcHMubG9jayA9IGdjY19idWlsdGluX2xvY2s7Cj4gIAkJ
bG9ja19vcHMudW5sb2NrID0gZ2NjX2J1aWx0aW5fdW5sb2NrOwo+IC0tIAo+IDIuMTQuMS53aW5k
b3dzLjEKPiAKPgoKUXVldWVkIHRvIGh0dHBzOi8vZ2l0aHViLmNvbS9yaGRyam9uZXMva3ZtLXVu
aXQtdGVzdHMvdHJlZS9hcm0vcXVldWUKClRoYW5rcywKZHJldyAKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
