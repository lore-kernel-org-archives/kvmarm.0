Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663F1C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 12:56:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBDD82065C
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 12:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0BSe/3S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBDD82065C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F4624BA69;
	Tue, 28 Jul 2020 08:56:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CCqHxx+Z3PYN; Tue, 28 Jul 2020 08:56:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3926A4BA72;
	Tue, 28 Jul 2020 08:56:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A94DD4BA6B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 08:56:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oqhqM-Rm5XTs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 08:56:08 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCC8A4BA64
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 08:56:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1595940968;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=w5V0t0GXMya6+gO7R5IUe7YZ/97/s6ZAsI0sAaujI+I=;
 b=Y0BSe/3SYT4qYNvipbHyAPiamuP3uz0V3HtwGCoMuTsAZyptxbXFTWinO/6c90OyfeoHWc
 cTHgD/CAuDh1KCuq9a6e4MmAC8+QmCFpLpekzk5mp5rkqxZO2K2IUeHqrDE0/xsKqDg4ph
 JiD3KH9SV523x/pUbUFFo0HepogjqkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-dHA4XqSMMsC-o1tUNrqHBw-1; Tue, 28 Jul 2020 08:56:05 -0400
X-MC-Unique: dHA4XqSMMsC-o1tUNrqHBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86ACBA3485F;
 Tue, 28 Jul 2020 12:56:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA8C8612AB;
 Tue, 28 Jul 2020 12:55:58 +0000 (UTC)
Date: Tue, 28 Jul 2020 14:55:53 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/5] KVM: arm64: pvtime: steal-time is only supported
 when configured
Message-ID: <20200728125553.3k65bfdxs6u5pb4i@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-2-drjones@redhat.com>
 <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 steven.price@arm.com
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

T24gTW9uLCBKdWwgMjcsIDIwMjAgYXQgMDY6MjU6NTBQTSArMDEwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IEhpIEFuZHJldywKPiAKPiBPbiAyMDIwLTA3LTExIDExOjA0LCBBbmRyZXcgSm9uZXMg
d3JvdGU6Cj4gPiBEb24ndCBjb25mdXNlIHRoZSBndWVzdCBieSBzYXlpbmcgc3RlYWwtdGltZSBp
cyBzdXBwb3J0ZWQgd2hlbgo+ID4gaXQgaGFzbid0IGJlZW4gY29uZmlndXJlZCBieSB1c2Vyc3Bh
Y2UgYW5kIHdvbid0IHdvcmsuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBKb25lcyA8
ZHJqb25lc0ByZWRoYXQuY29tPgo+ID4gLS0tCj4gPiAgYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMg
fCA1ICsrKystCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMgYi9hcmNo
L2FybTY0L2t2bS9wdnRpbWUuYwo+ID4gaW5kZXggZjdiNTJjZTE1NTdlLi4yYjIyMjE0OTA5YmUg
MTAwNjQ0Cj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9wdnRpbWUuYwo+ID4gKysrIGIvYXJjaC9h
cm02NC9rdm0vcHZ0aW1lLmMKPiA+IEBAIC00Miw5ICs0MiwxMiBAQCBsb25nIGt2bV9oeXBlcmNh
bGxfcHZfZmVhdHVyZXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+ID4gCj4gPiAgCXN3aXRjaCAo
ZmVhdHVyZSkgewo+ID4gIAljYXNlIEFSTV9TTUNDQ19IVl9QVl9USU1FX0ZFQVRVUkVTOgo+ID4g
LQljYXNlIEFSTV9TTUNDQ19IVl9QVl9USU1FX1NUOgo+ID4gIAkJdmFsID0gU01DQ0NfUkVUX1NV
Q0NFU1M7Cj4gPiAgCQlicmVhazsKPiA+ICsJY2FzZSBBUk1fU01DQ0NfSFZfUFZfVElNRV9TVDoK
PiA+ICsJCWlmICh2Y3B1LT5hcmNoLnN0ZWFsLmJhc2UgIT0gR1BBX0lOVkFMSUQpCj4gPiArCQkJ
dmFsID0gU01DQ0NfUkVUX1NVQ0NFU1M7Cj4gPiArCQlicmVhazsKPiA+ICAJfQo+ID4gCj4gPiAg
CXJldHVybiB2YWw7Cj4gCj4gSSdtIG5vdCBzbyBzdXJlIGFib3V0IHRoaXMuIEkgaGF2ZSBhbHdh
eXMgY29uc2lkZXJlZCB0aGUKPiBkaXNjb3ZlcnkgaW50ZXJmYWNlIHRvIGJlICJkbyB5b3Uga25v
dyBhYm91dCB0aGlzIFNNQ0NDCj4gZnVuY3Rpb24iLiBBbmQgaWYgeW91IGxvb2sgYXQgdGhlIHNw
ZWMsIGl0IHNheXMgKDQuMiwKPiBQVl9USU1FX0ZFQVRVUkVTKToKPiAKPiA8cXVvdGU+Cj4gSWYg
UFZfY2FsbF9pZCBpZGVudGlmaWVzIFBWX1RJTUVfRkVBVFVSRVMsIHRoaXMgY2FsbCByZXR1cm5z
Ogo+IOKAoiBOT1RfU1VQUE9SVEVEICgtMSkgdG8gaW5kaWNhdGUgdGhhdCBhbGwKPiBwYXJhdmly
dHVhbGl6ZWQgdGltZSBmdW5jdGlvbnMgaW4gdGhpcyBzcGVjaWZpY2F0aW9uIGFyZSBub3QKPiBz
dXBwb3J0ZWQuCj4g4oCiIFNVQ0NFU1MgKDApIHRvIGluZGljYXRlIHRoYXQgYWxsIHRoZSBwYXJh
dmlydHVhbGl6ZWQgdGltZQo+IGZ1bmN0aW9ucyBpbiB0aGlzIHNwZWNpZmljYXRpb24gYXJlIHN1
cHBvcnRlZC4KPiA8L3F1b3RlPgo+IAo+IFNvIHRoZSB3YXkgSSB1bmRlcnN0YW5kIGl0LCB5b3Ug
Y2Fubm90IHJldHVybiAic3VwcG9ydGVkIgo+IGZvciBQVl9USU1FX0ZFQVRVUkVTLCBhbmQgeWV0
IHJldHVybiBOT1RfU1VQUE9SVEVEIGZvcgo+IFBWX1RJTUVfU1QuIEl0IGFwcGxpZXMgdG8gKmFs
bCogZmVhdHVyZXMuCj4gCj4gWWVzLCB0aGlzIGlzIHZlcnkgYml6YXJyZS4gQnV0IEkgZG9uJ3Qg
dGhpbmsgd2UgY2FuIGRldmlhdGUKPiBmcm9tIGl0LgoKQWgsIEkgc2VlIHlvdXIgcG9pbnQuIEJ1
dCBJIHdvbmRlciBpZiB3ZSBzaG91bGQgZHJvcCB0aGlzIHBhdGNoCm9yIGlmIHdlIHNob3VsZCBj
aGFuZ2UgdGhlIHJldHVybiBvZiBBUk1fU01DQ0NfSFZfUFZfVElNRV9GRUFUVVJFUwp0byBiZSBk
ZXBlbmRhbnQgb24gYWxsIHRoZSBwdiBjYWxscz8KCkRpc2NvdmVyeSB3b3VsZCBsb29rIGxpa2Ug
dGhpcwoKSUYgKFNNQ0NDX0FSQ0hfRkVBVFVSRVMsIFBWX1RJTUVfRkVBVFVSRVMpID09IDA7IFRI
RU4KICBJRiAoUFZfVElNRV9GRUFUVVJFUywgUFZfVElNRV9GRUFUVVJFUykgPT0gMDsgVEhFTgog
ICAgUFZfVElNRV9TVCBpcyBzdXBwb3J0ZWQsIGFzIHdlbGwgYXMgYWxsIG90aGVyIFBWIGNhbGxz
CiAgRUxJRiAoUFZfVElNRV9GRUFUVVJFUywgUFZfVElNRV9TVCkgPT0gMDsgVEhFTgogICAgUFZf
VElNRV9TVCBpcyBzdXBwb3J0ZWQKICBFTElGIChQVl9USU1FX0ZFQVRVUkVTLCA8YW5vdGhlci1w
di1jYWxsPikgPT0gMDsgVEhFTgogICAgPGFub3RoZXItcHYtY2FsbD4gaXMgc3VwcG9ydGVkCiAg
Li4uCiAgRU5ESUYKRUxTRQogIE5vIFBWIGNhbGxzIGFyZSBzdXBwb3J0ZWQKRU5ESUYKCkkgYmVs
aWV2ZSB0aGUgYWJvdmUgaW1wbGVtZW50cyBhIHJlYXNvbmFibGUgaW50ZXJwcmV0YXRpb24gb2Yg
dGhlCnNwZWNpZmljYXRpb24sIGJ1dCB0aGUgYWxsIGZlYXR1cmUgKFBWX1RJTUVfRkVBVFVSRVMs
IFBWX1RJTUVfRkVBVFVSRVMpCnRoaW5nIGlzIGluZGVlZCBiaXphcnJlIG5vIG1hdHRlciBob3cg
eW91IGxvb2sgYXQgaXQuCgpUaGFua3MsCmRyZXcKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
