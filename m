Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A4AC388F9
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 13:32:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5349A216C4
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 13:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFWsy+Yh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5349A216C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9724B394;
	Tue,  3 Nov 2020 08:32:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3C8Y4eRZEzeZ; Tue,  3 Nov 2020 08:32:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 778BA4B3A8;
	Tue,  3 Nov 2020 08:32:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E79084B386
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 08:32:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I5AQRU4uL-CJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 08:32:24 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6574B365
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 08:32:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604410344;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rs0ZCqo1W7PUbdiD3y1cTUQWLQZfVMeq5dfEesPbjL8=;
 b=BFWsy+YhI511MYwP+9BXyrG0evp+9c6UoxiiEGImhp0o8lSSEebYmHSRxKJc8UWcYXAWAj
 mOLruuv2ZtsOYQJ2j+lR9SmnXCEmwxvRQBRnJU6wtQFBVSmmXaoM2ofpta/7p+XX8Hthz4
 q0iVRbwQgcbucjnxpwCyUY7fr4gZLM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-n45QBk_QNPiXRuCJPecqjg-1; Tue, 03 Nov 2020 08:32:22 -0500
X-MC-Unique: n45QBk_QNPiXRuCJPecqjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 202FB8058A4;
 Tue,  3 Nov 2020 13:32:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D340C5B4A1;
 Tue,  3 Nov 2020 13:32:17 +0000 (UTC)
Date: Tue, 3 Nov 2020 14:32:15 +0100
From: Andrew Jones <drjones@redhat.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Don't hide ID registers from userspace
Message-ID: <20201103133215.rfgjcv6fvh4rgzdg@kamzik.brq.redhat.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-2-drjones@redhat.com>
 <20201103111816.GG6882@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201103111816.GG6882@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: maz@kernel.org, xu910121@sina.com, kvmarm@lists.cs.columbia.edu,
 stable@vger.kernel.org
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

T24gVHVlLCBOb3YgMDMsIDIwMjAgYXQgMTE6MTg6MTlBTSArMDAwMCwgRGF2ZSBNYXJ0aW4gd3Jv
dGU6Cj4gT24gTW9uLCBOb3YgMDIsIDIwMjAgYXQgMDc6NTA6MzVQTSArMDEwMCwgQW5kcmV3IEpv
bmVzIHdyb3RlOgo+ID4gSUQgcmVnaXN0ZXJzIGFyZSBSQVogdW50aWwgdGhleSd2ZSBiZWVuIGFs
bG9jYXRlZCBhIHB1cnBvc2UsIGJ1dAo+ID4gdGhhdCBkb2Vzbid0IG1lYW4gdGhleSBzaG91bGQg
YmUgcmVtb3ZlZCBmcm9tIHRoZSBLVk1fR0VUX1JFR19MSVNUCj4gPiBsaXN0LiBTbyBmYXIgd2Ug
b25seSBoYXZlIG9uZSByZWdpc3RlciwgU1lTX0lEX0FBNjRaRlIwX0VMMSwgdGhhdAo+ID4gaXMg
aGlkZGVuIGZyb20gdXNlcnNwYWNlIHdoZW4gaXRzIGZ1bmN0aW9uIGlzIG5vdCBwcmVzZW50LiBS
ZW1vdmluZwo+ID4gdGhlIHVzZXJzcGFjZSB2aXNpYmlsaXR5IGNoZWNrcyBpcyBlbm91Z2ggdG8g
cmVleHBvc2UgaXQsIGFzIGl0Cj4gPiBhbHJlYWR5IGJlaGF2ZXMgYXMgUkFaIHdoZW4gdGhlIGZ1
bmN0aW9uIGlzIG5vdCBwcmVzZW50Lgo+IAo+IFBsZWFlIHN0YXRlIHdoYXQgdGhlIHBhdGNoIGRv
ZXMuICAoVGhlIHN1YmplY3QgbGluZSBzZXJ2ZXMgYXMgYSBzdW1tYXJ5Cj4gb2YgdGhhdCwgYnV0
IHRoZSBjb21taXQgbWVzc2FnZSBzaG91bGQgbWFrZSBzZW5zZSB3aXRob3V0IGl0LikKCkkgZG9u
J3QgbGlrZSAiVGhpcyBwYXRjaCAuLi4iIHR5cGUgb2Ygc2VudGVuY2VzIGluIHRoZSBjb21taXQg
bWVzc2FnZSwKYnV0IHVubGVzcyB5b3UgaGF2ZSBhIGJldHRlciBzdWdnZXN0aW9uLCB0aGVuIEkn
ZCBqdXN0IGFkZCBhIHNlbnRlbmNlCmxpa2UKCiJUaGlzIHBhdGNoIGVuc3VyZXMgd2Ugc3RpbGwg
ZXhwb3NlIHN5c3JlZyAnMywgMCwgMCwgNCwgNCcKKElEX0FBNjRaRlIwX0VMMSkgdG8gdXNlcnNw
YWNlIGFzIFJBWiB3aGVuIFNWRSBpcyBub3QgaW1wbGVtZW50ZWQuIgoKPiAKPiBBbHNvLCBob3cg
ZXhhY3RseSAhdmNwdV9oYXNfc3ZlKCkgY2F1c2VzIElEX0FBNjRaRlIwX0VMMSB0byBiZWhhdmUg
YXMKPiBSQVogd2l0aCB0aGlzIGNoYW5nZT8gIChJJ20gbm90IHNheWluZyBpdCBkb2Vzbid0LCBi
dXQgdGhlIGNvZGUgaXMgbm90Cj4gdHJpdmlhbCB0byBmb2xsb3cuLi4pCgpndWVzdF9pZF9hYTY0
emZyMF9lbDEoKSByZXR1cm5zIHplcm8gZm9yIHRoZSByZWdpc3RlciB3aGVuICF2Y3B1X2hhc19z
dmUoKSwKYW5kIGFsbCB0aGUgYWNjZXNzb3JzICh1c2Vyc3BhY2UgYW5kIGd1ZXN0KSBidWlsZCBv
biBpdC4KCkknbSBub3Qgc3VyZSBob3cgaGVscGZ1bCBpdCB3b3VsZCBiZSB0byBhZGQgdGhhdCBz
ZW50ZW5jZSB0byB0aGUgY29tbWl0Cm1lc3NhZ2UgdGhvdWdoLgoKPiAKPiA+IAo+ID4gRml4ZXM6
IDczNDMzNzYyZmNhZSAoIktWTTogYXJtNjQvc3ZlOiBTeXN0ZW0gcmVnaXN0ZXIgY29udGV4dCBz
d2l0Y2ggYW5kIGFjY2VzcyBzdXBwb3J0IikKPiA+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9y
Zz4gIyB2NS4yKwo+ID4gUmVwb3J0ZWQtYnk6IOW8oOS4nOaXrSA8eHU5MTAxMjFAc2luYS5jb20+
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgSm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4KPiA+
IC0tLQo+ID4gIGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgfCAxOCArLS0tLS0tLS0tLS0tLS0t
LS0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDE3IGRlbGV0aW9ucygtKQo+
ID4gCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJt
NjQva3ZtL3N5c19yZWdzLmMKPiA+IGluZGV4IGZiMTJkM2VmNDIzYS4uNmZmMGMxNTUzMWNhIDEw
MDY0NAo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+ID4gKysrIGIvYXJjaC9h
cm02NC9rdm0vc3lzX3JlZ3MuYwo+ID4gQEAgLTExOTUsMTYgKzExOTUsNiBAQCBzdGF0aWMgdW5z
aWduZWQgaW50IHN2ZV92aXNpYmlsaXR5KGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPiA+
ICAJcmV0dXJuIFJFR19ISURERU5fVVNFUiB8IFJFR19ISURERU5fR1VFU1Q7Cj4gPiAgfQo+ID4g
IAo+ID4gLS8qIFZpc2liaWxpdHkgb3ZlcnJpZGVzIGZvciBTVkUtc3BlY2lmaWMgSUQgcmVnaXN0
ZXJzICovCj4gPiAtc3RhdGljIHVuc2lnbmVkIGludCBzdmVfaWRfdmlzaWJpbGl0eShjb25zdCBz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gPiAtCQkJCSAgICAgIGNvbnN0IHN0cnVjdCBzeXNfcmVn
X2Rlc2MgKnJkKQo+ID4gLXsKPiA+IC0JaWYgKHZjcHVfaGFzX3N2ZSh2Y3B1KSkKPiA+IC0JCXJl
dHVybiAwOwo+ID4gLQo+ID4gLQlyZXR1cm4gUkVHX0hJRERFTl9VU0VSOwo+IAo+IEluIGxpZ2h0
IG9mIHRoaXMgY2hhbmdlLCBJIHRoaW5rIHRoYXQgUkVHX0hJRERFTl9HVUVTVCBhbmQKPiBSRUdf
SElEREVOX1VTRVIgYXJlIGFsd2F5cyBlaXRoZXIgYm90aCBzZXQgb3IgYm90aCBjbGVhci4gIEdp
dmVuIHRoZQo+IGRpc2N1c3Npb24gb24gdGhpcyBpc3N1ZSwgSSdtIHRoaW5raW5nIGl0IHByb2Jh
Ymx5IGRvZXNuJ3QgZXZlbiBtYWtlCj4gc2Vuc2UgZm9yIHRoZXNlIHRvIGJlIGluZGVwZW5kZW50
ICg/KQo+IAo+IElmIFJFR19ISURERU5fVVNFUiBpcyByZWFsbHkgcmVkdW5kYW50LCBJIHN1Z2dl
c3Qgc3RyaXBwaW5nIGl0IG91dCBhbmQKPiBzaW1wbGlmeWluZyB0aGUgY29kZSBhcHByb3ByaWF0
ZWx5Lgo+IAo+IChJbiBlZmZlY3QsIEkgdGhpbmsgeW91ciBSQVogZmxhZyB3aWxsIGRvIGNvcnJl
Y3RseSB3aGF0IFJFR19ISURERU5fVVNFUgo+IHdhcyB0cnlpbmcgdG8gYWNoaWV2ZS4pCgpXZSBj
b3VsZCBjb25zb2xpZGF0ZSBSRUdfSElEREVOX0dVRVNUIGFuZCBSRUdfSElEREVOX1VTRVIgaW50
byBSRUdfSElEREVOLAp3aGljaCBaQ1JfRUwxIGFuZCBwdHJhdXRoIHJlZ2lzdGVycyB3aWxsIHN0
aWxsIHVzZS4KCj4gCj4gPiAtfQo+ID4gLQo+ID4gIC8qIEdlbmVyYXRlIHRoZSBlbXVsYXRlZCBJ
RF9BQTY0WkZSMF9FTDEgdmFsdWUgZXhwb3NlZCB0byB0aGUgZ3Vlc3QgKi8KPiA+ICBzdGF0aWMg
dTY0IGd1ZXN0X2lkX2FhNjR6ZnIwX2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4g
PiAgewo+ID4gQEAgLTEyMzEsOSArMTIyMSw2IEBAIHN0YXRpYyBpbnQgZ2V0X2lkX2FhNjR6ZnIw
X2VsMShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gPiAgewo+ID4gIAl1NjQgdmFsOwo+ID4gIAo+
ID4gLQlpZiAoV0FSTl9PTighdmNwdV9oYXNfc3ZlKHZjcHUpKSkKPiA+IC0JCXJldHVybiAtRU5P
RU5UOwo+ID4gLQo+ID4gIAl2YWwgPSBndWVzdF9pZF9hYTY0emZyMF9lbDEodmNwdSk7Cj4gPiAg
CXJldHVybiByZWdfdG9fdXNlcih1YWRkciwgJnZhbCwgcmVnLT5pZCk7Cj4gPiAgfQo+ID4gQEAg
LTEyNDYsOSArMTIzMyw2IEBAIHN0YXRpYyBpbnQgc2V0X2lkX2FhNjR6ZnIwX2VsMShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsCj4gPiAgCWludCBlcnI7Cj4gPiAgCXU2NCB2YWw7Cj4gPiAgCj4gPiAt
CWlmIChXQVJOX09OKCF2Y3B1X2hhc19zdmUodmNwdSkpKQo+ID4gLQkJcmV0dXJuIC1FTk9FTlQ7
Cj4gPiAtCj4gPiAgCWVyciA9IHJlZ19mcm9tX3VzZXIoJnZhbCwgdWFkZHIsIGlkKTsKPiA+ICAJ
aWYgKGVycikKPiA+ICAJCXJldHVybiBlcnI7Cj4gPiBAQCAtMTUxOCw3ICsxNTAyLDcgQEAgc3Rh
dGljIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2Mgc3lzX3JlZ19kZXNjc1tdID0gewo+ID4gIAlJ
RF9TQU5JVElTRUQoSURfQUE2NFBGUjFfRUwxKSwKPiA+ICAJSURfVU5BTExPQ0FURUQoNCwyKSwK
PiA+ICAJSURfVU5BTExPQ0FURUQoNCwzKSwKPiA+IC0JeyBTWVNfREVTQyhTWVNfSURfQUE2NFpG
UjBfRUwxKSwgYWNjZXNzX2lkX2FhNjR6ZnIwX2VsMSwgLmdldF91c2VyID0gZ2V0X2lkX2FhNjR6
ZnIwX2VsMSwgLnNldF91c2VyID0gc2V0X2lkX2FhNjR6ZnIwX2VsMSwgLnZpc2liaWxpdHkgPSBz
dmVfaWRfdmlzaWJpbGl0eSB9LAo+ID4gKwl7IFNZU19ERVNDKFNZU19JRF9BQTY0WkZSMF9FTDEp
LCBhY2Nlc3NfaWRfYWE2NHpmcjBfZWwxLCAuZ2V0X3VzZXIgPSBnZXRfaWRfYWE2NHpmcjBfZWwx
LCAuc2V0X3VzZXIgPSBzZXRfaWRfYWE2NHpmcjBfZWwxLCB9LAo+ID4gIAlJRF9VTkFMTE9DQVRF
RCg0LDUpLAo+ID4gIAlJRF9VTkFMTE9DQVRFRCg0LDYpLAo+ID4gIAlJRF9VTkFMTE9DQVRFRCg0
LDcpLAo+IAo+IE90aGVyd2lzZSBsb29rcyByZWFzb25hYmxlLgo+CgpUaGFua3MsCmRyZXcKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
