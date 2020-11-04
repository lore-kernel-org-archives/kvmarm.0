Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E45C4742C
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 16:11:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4EF0120756
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 16:11:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EF0120756
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A0174B7CF;
	Wed,  4 Nov 2020 11:11:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q6vdRcAZUXjV; Wed,  4 Nov 2020 11:11:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A2474B711;
	Wed,  4 Nov 2020 11:11:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BDD34B711
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 11:11:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qZV530i4bMcq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 11:11:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0041C4B679
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 11:11:48 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F0BB139F;
 Wed,  4 Nov 2020 08:11:48 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A41E03F718;
 Wed,  4 Nov 2020 08:11:47 -0800 (PST)
Date: Wed, 4 Nov 2020 16:11:44 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Don't hide ID registers from userspace
Message-ID: <20201104161142.GA6882@arm.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-2-drjones@redhat.com>
 <20201103111816.GG6882@arm.com>
 <20201103133215.rfgjcv6fvh4rgzdg@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201103133215.rfgjcv6fvh4rgzdg@kamzik.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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

T24gVHVlLCBOb3YgMDMsIDIwMjAgYXQgMDI6MzI6MTVQTSArMDEwMCwgQW5kcmV3IEpvbmVzIHdy
b3RlOgo+IE9uIFR1ZSwgTm92IDAzLCAyMDIwIGF0IDExOjE4OjE5QU0gKzAwMDAsIERhdmUgTWFy
dGluIHdyb3RlOgo+ID4gT24gTW9uLCBOb3YgMDIsIDIwMjAgYXQgMDc6NTA6MzVQTSArMDEwMCwg
QW5kcmV3IEpvbmVzIHdyb3RlOgo+ID4gPiBJRCByZWdpc3RlcnMgYXJlIFJBWiB1bnRpbCB0aGV5
J3ZlIGJlZW4gYWxsb2NhdGVkIGEgcHVycG9zZSwgYnV0Cj4gPiA+IHRoYXQgZG9lc24ndCBtZWFu
IHRoZXkgc2hvdWxkIGJlIHJlbW92ZWQgZnJvbSB0aGUgS1ZNX0dFVF9SRUdfTElTVAo+ID4gPiBs
aXN0LiBTbyBmYXIgd2Ugb25seSBoYXZlIG9uZSByZWdpc3RlciwgU1lTX0lEX0FBNjRaRlIwX0VM
MSwgdGhhdAo+ID4gPiBpcyBoaWRkZW4gZnJvbSB1c2Vyc3BhY2Ugd2hlbiBpdHMgZnVuY3Rpb24g
aXMgbm90IHByZXNlbnQuIFJlbW92aW5nCj4gPiA+IHRoZSB1c2Vyc3BhY2UgdmlzaWJpbGl0eSBj
aGVja3MgaXMgZW5vdWdoIHRvIHJlZXhwb3NlIGl0LCBhcyBpdAo+ID4gPiBhbHJlYWR5IGJlaGF2
ZXMgYXMgUkFaIHdoZW4gdGhlIGZ1bmN0aW9uIGlzIG5vdCBwcmVzZW50Lgo+ID4gCj4gPiBQbGVh
ZSBzdGF0ZSB3aGF0IHRoZSBwYXRjaCBkb2VzLiAgKFRoZSBzdWJqZWN0IGxpbmUgc2VydmVzIGFz
IGEgc3VtbWFyeQo+ID4gb2YgdGhhdCwgYnV0IHRoZSBjb21taXQgbWVzc2FnZSBzaG91bGQgbWFr
ZSBzZW5zZSB3aXRob3V0IGl0LikKPiAKPiBJIGRvbid0IGxpa2UgIlRoaXMgcGF0Y2ggLi4uIiB0
eXBlIG9mIHNlbnRlbmNlcyBpbiB0aGUgY29tbWl0IG1lc3NhZ2UsCj4gYnV0IHVubGVzcyB5b3Ug
aGF2ZSBhIGJldHRlciBzdWdnZXN0aW9uLCB0aGVuIEknZCBqdXN0IGFkZCBhIHNlbnRlbmNlCj4g
bGlrZQo+IAo+ICJUaGlzIHBhdGNoIGVuc3VyZXMgd2Ugc3RpbGwgZXhwb3NlIHN5c3JlZyAnMywg
MCwgMCwgNCwgNCcKPiAoSURfQUE2NFpGUjBfRUwxKSB0byB1c2Vyc3BhY2UgYXMgUkFaIHdoZW4g
U1ZFIGlzIG5vdCBpbXBsZW1lbnRlZC4iCgpJJ20gbm90IHN1cmUgdGhlIHN5c3JlZyBlbmNvZGlu
ZyBudW1iZXIgaXMgcmVhbGx5IG5lZWRlZC4Kc3VibWl0dGluZy1wYXRjaGVzLnJzdCBhbHNvIHNh
eXMgc3VjaCBzdGF0ZW1lbnRzIHNob3VsZCBiZSBpbiB0aGUKaW1wZXJhdGl2ZS4gIFdoeSBub3Qg
ZGVsZXRlIHRoZSAiUmVtb3ZpbmcgdGhlIHVzZXJzcGFjZSB2aXNpYmlsaXR5CmNoZWNrcy4uLiIg
c2VudGVuY2UgYWJvdmUgYW5kIHdyaXRpbmc6CgoJRXhwb3NlIElEX0FBNjRaRlIwX0VMMSB0byB1
c2Vyc3BhY2UgYXMgUkFaIHdoZW4gU1ZFIGlzIG5vdAoJaW1wbGVtZW50ZWQuCgoJUmVtb3Zpbmcg
dGhlIHVzZXJzcGFjZSB2aXNpYmlsaXR5IGNoZWNrcyBpcyBlbm91Z2ggdG8gcmVleHBvc2UgaXQs
CglhcyBpdCBhbHJlYWR5IGJlaGF2ZXMgYXMgUkFaIGZvciB0aGUgZ3Vlc3Qgd2hlbiBTVkUgaXMg
bm90IHByZXNlbnQuCgooVGhlIGJhY2tncm91bmQgdG8gdGhpcyBncmlwZSBpcyB0aGF0ICJ0cmFk
aXRpb25hbCIgbWFpbGVycyBtYXkgaW52b2tlIGEKc3RhbmRhbG9uZSBlZGl0b3Igb24gdGhlIG1l
c3NhZ2UgYm9keSB3aGVuIGNvbXBvc2luZyByZXBseSwgc28gdGhlCnN1YmplY3QgbGluZSBtYXkg
bm90IGJlIHZpc2libGUuLi4pCgo+IAo+ID4gCj4gPiBBbHNvLCBob3cgZXhhY3RseSAhdmNwdV9o
YXNfc3ZlKCkgY2F1c2VzIElEX0FBNjRaRlIwX0VMMSB0byBiZWhhdmUgYXMKPiA+IFJBWiB3aXRo
IHRoaXMgY2hhbmdlPyAgKEknbSBub3Qgc2F5aW5nIGl0IGRvZXNuJ3QsIGJ1dCB0aGUgY29kZSBp
cyBub3QKPiA+IHRyaXZpYWwgdG8gZm9sbG93Li4uKQo+IAo+IGd1ZXN0X2lkX2FhNjR6ZnIwX2Vs
MSgpIHJldHVybnMgemVybyBmb3IgdGhlIHJlZ2lzdGVyIHdoZW4gIXZjcHVfaGFzX3N2ZSgpLAo+
IGFuZCBhbGwgdGhlIGFjY2Vzc29ycyAodXNlcnNwYWNlIGFuZCBndWVzdCkgYnVpbGQgb24gaXQu
Cj4gCj4gSSdtIG5vdCBzdXJlIGhvdyBoZWxwZnVsIGl0IHdvdWxkIGJlIHRvIGFkZCB0aGF0IHNl
bnRlbmNlIHRvIHRoZSBjb21taXQKPiBtZXNzYWdlIHRob3VnaC4KCk5vIHdvcnJpZXMsIEkgZG9u
J3QgdGhpbmsgeW91IG5lZWQgdG8gYWRkIGFudGhpbmcuICBJIGZpZ3VyZWQgb3V0IGhvdwp0aGlz
IHdvcmtzIGFmdGVyIG15IHByZXZpb3VzbHkgcmVwbHksIHNvIHlvdSBjYW4gcHV0IG15IHF1ZXN0
aW9uIGRvd24gdG8KbWUgYmVpbmcgc2xvdyBvbiB0aGUgdXB0YWtlLi4uCgo+IAo+ID4gCj4gPiA+
IAo+ID4gPiBGaXhlczogNzM0MzM3NjJmY2FlICgiS1ZNOiBhcm02NC9zdmU6IFN5c3RlbSByZWdp
c3RlciBjb250ZXh0IHN3aXRjaCBhbmQgYWNjZXNzIHN1cHBvcnQiKQo+ID4gPiBDYzogPHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuMisKPiA+ID4gUmVwb3J0ZWQtYnk6IOW8oOS4nOaXrSA8
eHU5MTAxMjFAc2luYS5jb20+Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBKb25lcyA8ZHJq
b25lc0ByZWRoYXQuY29tPgo+ID4gPiAtLS0KPiA+ID4gIGFyY2gvYXJtNjQva3ZtL3N5c19yZWdz
LmMgfCAxOCArLS0tLS0tLS0tLS0tLS0tLS0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMTcgZGVsZXRpb25zKC0pCj4gPiA+IAo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPiA+ID4gaW5k
ZXggZmIxMmQzZWY0MjNhLi42ZmYwYzE1NTMxY2EgMTAwNjQ0Cj4gPiA+IC0tLSBhL2FyY2gvYXJt
NjQva3ZtL3N5c19yZWdzLmMKPiA+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+
ID4gPiBAQCAtMTE5NSwxNiArMTE5NSw2IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgc3ZlX3Zpc2li
aWxpdHkoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+ID4gPiAgCXJldHVybiBSRUdfSElE
REVOX1VTRVIgfCBSRUdfSElEREVOX0dVRVNUOwo+ID4gPiAgfQo+ID4gPiAgCj4gPiA+IC0vKiBW
aXNpYmlsaXR5IG92ZXJyaWRlcyBmb3IgU1ZFLXNwZWNpZmljIElEIHJlZ2lzdGVycyAqLwo+ID4g
PiAtc3RhdGljIHVuc2lnbmVkIGludCBzdmVfaWRfdmlzaWJpbGl0eShjb25zdCBzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsCj4gPiA+IC0JCQkJICAgICAgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyAq
cmQpCj4gPiA+IC17Cj4gPiA+IC0JaWYgKHZjcHVfaGFzX3N2ZSh2Y3B1KSkKPiA+ID4gLQkJcmV0
dXJuIDA7Cj4gPiA+IC0KPiA+ID4gLQlyZXR1cm4gUkVHX0hJRERFTl9VU0VSOwo+ID4gCj4gPiBJ
biBsaWdodCBvZiB0aGlzIGNoYW5nZSwgSSB0aGluayB0aGF0IFJFR19ISURERU5fR1VFU1QgYW5k
Cj4gPiBSRUdfSElEREVOX1VTRVIgYXJlIGFsd2F5cyBlaXRoZXIgYm90aCBzZXQgb3IgYm90aCBj
bGVhci4gIEdpdmVuIHRoZQo+ID4gZGlzY3Vzc2lvbiBvbiB0aGlzIGlzc3VlLCBJJ20gdGhpbmtp
bmcgaXQgcHJvYmFibHkgZG9lc24ndCBldmVuIG1ha2UKPiA+IHNlbnNlIGZvciB0aGVzZSB0byBi
ZSBpbmRlcGVuZGVudCAoPykKPiA+IAo+ID4gSWYgUkVHX0hJRERFTl9VU0VSIGlzIHJlYWxseSBy
ZWR1bmRhbnQsIEkgc3VnZ2VzdCBzdHJpcHBpbmcgaXQgb3V0IGFuZAo+ID4gc2ltcGxpZnlpbmcg
dGhlIGNvZGUgYXBwcm9wcmlhdGVseS4KPiA+IAo+ID4gKEluIGVmZmVjdCwgSSB0aGluayB5b3Vy
IFJBWiBmbGFnIHdpbGwgZG8gY29ycmVjdGx5IHdoYXQgUkVHX0hJRERFTl9VU0VSCj4gPiB3YXMg
dHJ5aW5nIHRvIGFjaGlldmUuKQo+IAo+IFdlIGNvdWxkIGNvbnNvbGlkYXRlIFJFR19ISURERU5f
R1VFU1QgYW5kIFJFR19ISURERU5fVVNFUiBpbnRvIFJFR19ISURERU4sCj4gd2hpY2ggWkNSX0VM
MSBhbmQgcHRyYXV0aCByZWdpc3RlcnMgd2lsbCBzdGlsbCB1c2UuCgpTb3VuZHMgZ29vZCB0byBt
ZS4gIEdldHRpbmcgcmlkIG9mIF9ib3RoXyB0aGUgb2xkIG5hbWVzIHdlbGwgaGVscCBhdm9pZAph
Y2NpZGVudHMgdG9vLgoKWy4uLl0KCkNoZWVycwotLS1EYXZlCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
