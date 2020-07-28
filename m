Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E56C433E8
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 13:30:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB5042074F
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 13:30:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FB1Gwsib"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB5042074F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A16C4BAFD;
	Tue, 28 Jul 2020 09:30:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jK5QAzQCXKKv; Tue, 28 Jul 2020 09:30:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DADB4BAF6;
	Tue, 28 Jul 2020 09:30:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F58D4BAF5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 09:30:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id usmMZ2NvEC1B for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 09:30:01 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6C04BAEC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 09:30:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1595943001;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qaXFgbIXbbiYypmy31cvS8ckfizfH9y99XJ2GUhBVa8=;
 b=FB1Gwsibt6GhSCtjy8nmKNmh+0Ja192fwD2U3rwshrjgYGhlmLr7JAMkeYELbyjGzObKQR
 QkJ/6OmQP4/BP2+7zby0DiG+s5nWgaF34W2Ewui/4IfLZpj8QGtOWJchCNvzCsOo7y1+ue
 J2iOfrmFhe5dzQNWLFthWhuxLq3p6Ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-f5vA5ZqXM2mZWZUxZn6GfA-1; Tue, 28 Jul 2020 09:29:57 -0400
X-MC-Unique: f5vA5ZqXM2mZWZUxZn6GfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D19958;
 Tue, 28 Jul 2020 13:29:56 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BC2360CD0;
 Tue, 28 Jul 2020 13:29:55 +0000 (UTC)
Date: Tue, 28 Jul 2020 15:29:45 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/5] KVM: arm64: pvtime: steal-time is only supported
 when configured
Message-ID: <20200728132945.zsjrf4xyjtgrw2zl@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-2-drjones@redhat.com>
 <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
 <20200728125553.3k65bfdxs6u5pb4i@kamzik.brq.redhat.com>
 <ef8a19e07a2735d0d684ef54f8600d66@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ef8a19e07a2735d0d684ef54f8600d66@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

T24gVHVlLCBKdWwgMjgsIDIwMjAgYXQgMDI6MTM6NTRQTSArMDEwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IE9uIDIwMjAtMDctMjggMTM6NTUsIEFuZHJldyBKb25lcyB3cm90ZToKPiA+IE9uIE1v
biwgSnVsIDI3LCAyMDIwIGF0IDA2OjI1OjUwUE0gKzAxMDAsIE1hcmMgWnluZ2llciB3cm90ZToK
PiA+ID4gSGkgQW5kcmV3LAo+ID4gPiAKPiA+ID4gT24gMjAyMC0wNy0xMSAxMTowNCwgQW5kcmV3
IEpvbmVzIHdyb3RlOgo+ID4gPiA+IERvbid0IGNvbmZ1c2UgdGhlIGd1ZXN0IGJ5IHNheWluZyBz
dGVhbC10aW1lIGlzIHN1cHBvcnRlZCB3aGVuCj4gPiA+ID4gaXQgaGFzbid0IGJlZW4gY29uZmln
dXJlZCBieSB1c2Vyc3BhY2UgYW5kIHdvbid0IHdvcmsuCj4gPiA+ID4KPiA+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBBbmRyZXcgSm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4KPiA+ID4gPiAtLS0KPiA+
ID4gPiAgYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMgfCA1ICsrKystCj4gPiA+ID4gIDEgZmlsZSBj
aGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiA+ID4gPgo+ID4gPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9wdnRpbWUuYyBiL2FyY2gvYXJtNjQva3ZtL3B2dGlt
ZS5jCj4gPiA+ID4gaW5kZXggZjdiNTJjZTE1NTdlLi4yYjIyMjE0OTA5YmUgMTAwNjQ0Cj4gPiA+
ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMKPiA+ID4gPiArKysgYi9hcmNoL2FybTY0
L2t2bS9wdnRpbWUuYwo+ID4gPiA+IEBAIC00Miw5ICs0MiwxMiBAQCBsb25nIGt2bV9oeXBlcmNh
bGxfcHZfZmVhdHVyZXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+ID4gPiA+Cj4gPiA+ID4gIAlz
d2l0Y2ggKGZlYXR1cmUpIHsKPiA+ID4gPiAgCWNhc2UgQVJNX1NNQ0NDX0hWX1BWX1RJTUVfRkVB
VFVSRVM6Cj4gPiA+ID4gLQljYXNlIEFSTV9TTUNDQ19IVl9QVl9USU1FX1NUOgo+ID4gPiA+ICAJ
CXZhbCA9IFNNQ0NDX1JFVF9TVUNDRVNTOwo+ID4gPiA+ICAJCWJyZWFrOwo+ID4gPiA+ICsJY2Fz
ZSBBUk1fU01DQ0NfSFZfUFZfVElNRV9TVDoKPiA+ID4gPiArCQlpZiAodmNwdS0+YXJjaC5zdGVh
bC5iYXNlICE9IEdQQV9JTlZBTElEKQo+ID4gPiA+ICsJCQl2YWwgPSBTTUNDQ19SRVRfU1VDQ0VT
UzsKPiA+ID4gPiArCQlicmVhazsKPiA+ID4gPiAgCX0KPiA+ID4gPgo+ID4gPiA+ICAJcmV0dXJu
IHZhbDsKPiA+ID4gCj4gPiA+IEknbSBub3Qgc28gc3VyZSBhYm91dCB0aGlzLiBJIGhhdmUgYWx3
YXlzIGNvbnNpZGVyZWQgdGhlCj4gPiA+IGRpc2NvdmVyeSBpbnRlcmZhY2UgdG8gYmUgImRvIHlv
dSBrbm93IGFib3V0IHRoaXMgU01DQ0MKPiA+ID4gZnVuY3Rpb24iLiBBbmQgaWYgeW91IGxvb2sg
YXQgdGhlIHNwZWMsIGl0IHNheXMgKDQuMiwKPiA+ID4gUFZfVElNRV9GRUFUVVJFUyk6Cj4gPiA+
IAo+ID4gPiA8cXVvdGU+Cj4gPiA+IElmIFBWX2NhbGxfaWQgaWRlbnRpZmllcyBQVl9USU1FX0ZF
QVRVUkVTLCB0aGlzIGNhbGwgcmV0dXJuczoKPiA+ID4g4oCiIE5PVF9TVVBQT1JURUQgKC0xKSB0
byBpbmRpY2F0ZSB0aGF0IGFsbAo+ID4gPiBwYXJhdmlydHVhbGl6ZWQgdGltZSBmdW5jdGlvbnMg
aW4gdGhpcyBzcGVjaWZpY2F0aW9uIGFyZSBub3QKPiA+ID4gc3VwcG9ydGVkLgo+ID4gPiDigKIg
U1VDQ0VTUyAoMCkgdG8gaW5kaWNhdGUgdGhhdCBhbGwgdGhlIHBhcmF2aXJ0dWFsaXplZCB0aW1l
Cj4gPiA+IGZ1bmN0aW9ucyBpbiB0aGlzIHNwZWNpZmljYXRpb24gYXJlIHN1cHBvcnRlZC4KPiA+
ID4gPC9xdW90ZT4KPiA+ID4gCj4gPiA+IFNvIHRoZSB3YXkgSSB1bmRlcnN0YW5kIGl0LCB5b3Ug
Y2Fubm90IHJldHVybiAic3VwcG9ydGVkIgo+ID4gPiBmb3IgUFZfVElNRV9GRUFUVVJFUywgYW5k
IHlldCByZXR1cm4gTk9UX1NVUFBPUlRFRCBmb3IKPiA+ID4gUFZfVElNRV9TVC4gSXQgYXBwbGll
cyB0byAqYWxsKiBmZWF0dXJlcy4KPiA+ID4gCj4gPiA+IFllcywgdGhpcyBpcyB2ZXJ5IGJpemFy
cmUuIEJ1dCBJIGRvbid0IHRoaW5rIHdlIGNhbiBkZXZpYXRlCj4gPiA+IGZyb20gaXQuCj4gPiAK
PiA+IEFoLCBJIHNlZSB5b3VyIHBvaW50LiBCdXQgSSB3b25kZXIgaWYgd2Ugc2hvdWxkIGRyb3Ag
dGhpcyBwYXRjaAo+ID4gb3IgaWYgd2Ugc2hvdWxkIGNoYW5nZSB0aGUgcmV0dXJuIG9mIEFSTV9T
TUNDQ19IVl9QVl9USU1FX0ZFQVRVUkVTCj4gPiB0byBiZSBkZXBlbmRhbnQgb24gYWxsIHRoZSBw
diBjYWxscz8KPiA+IAo+ID4gRGlzY292ZXJ5IHdvdWxkIGxvb2sgbGlrZSB0aGlzCj4gPiAKPiA+
IElGIChTTUNDQ19BUkNIX0ZFQVRVUkVTLCBQVl9USU1FX0ZFQVRVUkVTKSA9PSAwOyBUSEVOCj4g
PiAgIElGIChQVl9USU1FX0ZFQVRVUkVTLCBQVl9USU1FX0ZFQVRVUkVTKSA9PSAwOyBUSEVOCj4g
PiAgICAgUFZfVElNRV9TVCBpcyBzdXBwb3J0ZWQsIGFzIHdlbGwgYXMgYWxsIG90aGVyIFBWIGNh
bGxzCj4gPiAgIEVMSUYgKFBWX1RJTUVfRkVBVFVSRVMsIFBWX1RJTUVfU1QpID09IDA7IFRIRU4K
PiA+ICAgICBQVl9USU1FX1NUIGlzIHN1cHBvcnRlZAo+ID4gICBFTElGIChQVl9USU1FX0ZFQVRV
UkVTLCA8YW5vdGhlci1wdi1jYWxsPikgPT0gMDsgVEhFTgo+ID4gICAgIDxhbm90aGVyLXB2LWNh
bGw+IGlzIHN1cHBvcnRlZAo+ID4gICAuLi4KPiA+ICAgRU5ESUYKPiA+IEVMU0UKPiA+ICAgTm8g
UFYgY2FsbHMgYXJlIHN1cHBvcnRlZAo+ID4gRU5ESUYKPiA+IAo+ID4gSSBiZWxpZXZlIHRoZSBh
Ym92ZSBpbXBsZW1lbnRzIGEgcmVhc29uYWJsZSBpbnRlcnByZXRhdGlvbiBvZiB0aGUKPiA+IHNw
ZWNpZmljYXRpb24sIGJ1dCB0aGUgYWxsIGZlYXR1cmUgKFBWX1RJTUVfRkVBVFVSRVMsIFBWX1RJ
TUVfRkVBVFVSRVMpCj4gPiB0aGluZyBpcyBpbmRlZWQgYml6YXJyZSBubyBtYXR0ZXIgaG93IHlv
dSBsb29rIGF0IGl0Lgo+IAo+IEl0IGl0IGluZGVlZCB0cnVlIHRvIHRoZSBzcGVjLiBUaGFua2Z1
bGx5IHdlIG9ubHkgc3VwcG9ydCBQVl9USU1FCj4gYXMgYSBmZWF0dXJlIGZvciBub3csIHNvIHdl
IGFyZSAoc29ydCBvZikgaW1tdW5lIHRvIHRoZSBicmFpbmRlYWQKPiBhc3BlY3Qgb2YgdGhlIGRp
c2NvdmVyeSBwcm90b2NvbC4KPiAKPiBJIHRoaW5rIHJldHVybmluZyBhIGZhaWx1cmUgd2hlbiBQ
Vl9USU1FIGlzbid0IHNldHVwIGlzIGEgdmFsaWQgdGhpbmcKPiB0byBkbywgYXMgbG9uZyBhcyBp
dCBhcHBsaWVzIHRvIGFsbCBmdW5jdGlvbnMgKGkuZS4gc29tZXRoaW5nIGxpa2UKPiB0aGUgYmVs
b3cgcGF0Y2gpLgo+IAo+IFRoYW5rcywKPiAKPiAgICAgICAgIE0uCj4gCj4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQva3ZtL3B2dGltZS5jIGIvYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMKPiBpbmRl
eCBmN2I1MmNlMTU1N2UuLmMzZWY0ZWJkNjg0NiAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2
bS9wdnRpbWUuYwo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3B2dGltZS5jCj4gQEAgLTQzLDcgKzQz
LDggQEAgbG9uZyBrdm1faHlwZXJjYWxsX3B2X2ZlYXR1cmVzKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkKPiAgCXN3aXRjaCAoZmVhdHVyZSkgewo+ICAJY2FzZSBBUk1fU01DQ0NfSFZfUFZfVElNRV9G
RUFUVVJFUzoKPiAgCWNhc2UgQVJNX1NNQ0NDX0hWX1BWX1RJTUVfU1Q6Cj4gLQkJdmFsID0gU01D
Q0NfUkVUX1NVQ0NFU1M7Cj4gKwkJaWYgKHZjcHUtPmFyY2guc3RlYWwuYmFzZSAhPSBHUEFfSU5W
QUxJRCkKPiArCQkJdmFsID0gU01DQ0NfUkVUX1NVQ0NFU1M7Cj4gIAkJYnJlYWs7Cj4gIAl9CgpM
b29rcyBnb29kIHRvIG1lLiBJJ2xsIGRvIHRoYXQgZm9yIHYyLgoKVGhhbmtzLApkcmV3CgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
