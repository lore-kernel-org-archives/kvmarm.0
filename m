From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v5 10/11] arm/arm64: gicv3:
 add an IPI test
Date: Fri, 11 Nov 2016 10:02:59 +0000
Message-ID: <871syi8hbg.fsf@linaro.org>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-11-git-send-email-drjones@redhat.com>
 <874m3f8621.fsf@linaro.org>
 <20161110203713.4idzgs5u2xm7ms4o@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE34404BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 05:02:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U-J8EQ8mbJ08 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2016 05:02:37 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 626F9403F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 05:02:37 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id a197so416409948wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 02:03:01 -0800 (PST)
In-reply-to: <20161110203713.4idzgs5u2xm7ms4o@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIFRodSwgTm92
IDEwLCAyMDE2IGF0IDA3OjUzOjU4UE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPiBbLi4u
XQo+PiA+ICtzdHJ1Y3QgZ2ljIGdpY3YyID0gewo+PiA+ICsJLmlwaSA9IHsKPj4gPiArCQkuZW5h
YmxlID0gZ2ljdjJfZW5hYmxlX2RlZmF1bHRzLAo+PiA+ICsJCS5zZW5kX3NlbGYgPSBnaWN2Ml9p
cGlfc2VuZF9zZWxmLAo+PiA+ICsJCS5zZW5kX3RsaXN0ID0gZ2ljdjJfaXBpX3NlbmRfdGxpc3Qs
Cj4+ID4gKwkJLnNlbmRfYnJvYWRjYXN0ID0gZ2ljdjJfaXBpX3NlbmRfYnJvYWRjYXN0LAo+PiA+
ICsJfSwKPj4gPiArCS5yZWFkX2lhciA9IGdpY3YyX3JlYWRfaWFyLAo+PiA+ICsJLmlycW5yID0g
Z2ljdjJfaXJxbnIsCj4+ID4gKwkud3JpdGVfZW9pID0gZ2ljdjJfd3JpdGVfZW9pLAo+PiA+ICt9
Owo+PiA+ICsKPj4gPiArc3RydWN0IGdpYyBnaWN2MyA9IHsKPj4gPiArCS5pcGkgPSB7Cj4+ID4g
KwkJLmVuYWJsZSA9IGdpY3YzX2VuYWJsZV9kZWZhdWx0cywKPj4gPiArCQkuc2VuZF9zZWxmID0g
Z2ljdjNfaXBpX3NlbmRfc2VsZiwKPj4gPiArCQkuc2VuZF90bGlzdCA9IGdpY3YzX2lwaV9zZW5k
X3RsaXN0LAo+PiA+ICsJCS5zZW5kX2Jyb2FkY2FzdCA9IGdpY3YzX2lwaV9zZW5kX2Jyb2FkY2Fz
dCwKPj4gPiArCX0sCj4+ID4gKwkucmVhZF9pYXIgPSBnaWN2M19yZWFkX2lhciwKPj4gPiArCS5p
cnFuciA9IGdpY3YzX2lycW5yLAo+PiA+ICsJLndyaXRlX2VvaSA9IGdpY3YzX3dyaXRlX2VvaXIs
Cj4+ID4gK307Cj4+ID4gKwo+Pgo+PiBTbyBJIHdhcyByZS1iYXNpbmcgbXkga3ZtLXVuaXQtdGVz
dHMgYWdhaW5zdCB5b3VyIEdJQyByZXdvcmsgYW5kIGZvdW5kCj4+IG15c2VsZiBjb3B5IGFuZCBw
YXN0aW5nIGEgYnVuY2ggb2YgdGhpcyBpbnRvIG15IHRlc3RzIHRoYXQgZmlyZSBJUlFzLgo+PiBU
aGF0IG1ha2VzIG1lIHRoaW5rIHRoZSBhYnN0cmFjdGlvbiBzaG91bGQgYmUgaW4gdGhlIGxpYnJh
cnkgY29kZSBzbwo+PiBvdGhlciB0ZXN0cyBjYW4gZmlkZGxlIHdpdGggc2VuZGluZyBJUlFzLgo+
Pgo+PiBXaGF0IGRvIHlvdSB0aGluaz8KPj4KPgo+IEkgZ3Vlc3MgeW91IG1lYW4gbW92aW5nIHRo
ZSBhYm92ZSB0d28gc3RydWN0cyBhbmQgdGhlaXIgY29ycmVzcG9uZGluZwo+IGZ1bmN0aW9ucyAo
YWxsIHdoaWNoIGFyZW4ndCBhbHJlYWR5IGNvbW1vbikgdG8gbGliL2FybS8gPyBPciBkbyB5b3UK
PiBqdXN0IG1lYW4gdGhlIG9uZSBub24tdHJpdmlhbCBmdW5jdGlvbiBnaWN2M19pcGlfc2VuZF90
bGlzdD8gSSB0aGluawo+IGFncmVlIHdpdGggZ2ljdjNfaXBpX3NlbmRfdGxpc3QgZ2V0dGluZyBz
aGFyZWQsIGJ1dCB0aGUgb3RoZXJzIGFyZQo+IG1vc3RseSBvbmUtbGluZXJzLCBzbyBJJ20gbm90
IHN1cmUuIEkgZ3Vlc3MgSSdkIGhhdmUgdG8gc2VlIGhvdyB5b3UncmUKPiB1c2luZyB0aGVtIGZp
cnN0LgoKU28gaXQgbG9va2VkIGxpa2UgdGhlcmUgd2VyZSBzb21lIGZ1bmN0aW9ucyBpbiB0aGUg
Y29tbW9uIGNvZGUgZm9yIG9uZQpHSUMgd2hpY2ggaGFkIGxvY2FsIHRlc3QgZGVmaW5lZCBmdW5j
dGlvbnMgZm9yIHRoZSBvdGhlci4gVGhleSBzaG91bGQgYXQKbGVhc3QgYmUgY29uc2lzdGVudC4K
CkZvciBteSB1c2UgY2FzZSBJIGNvdWxkIGRvIHdpdGggYSBjb21tb246CgogIGdpY19lbmFibGUK
ICBnaWNfc2VuZF9zcGkoY3B1LCBpcnEpCiAgZ2ljX2lycV9hY2soKSB3aGljaCByZXR1cm5zIHRo
ZSBpYXIuCgpTZWU6CgogIGh0dHBzOi8vZ2l0aHViLmNvbS9zdHNxdWFkL2t2bS11bml0LXRlc3Rz
L2Jsb2IvbXR0Y2cvY3VycmVudC10ZXN0cy12Ni9hcm0vdGNnLXRlc3QuYyNMMTEzCgo+Cj4gVGhh
bmtzLAo+IGRyZXcKCgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
