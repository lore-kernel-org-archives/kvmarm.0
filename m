From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v5 10/11] arm/arm64: gicv3: add an IPI test
Date: Fri, 11 Nov 2016 10:00:07 +0000
Message-ID: <8737iy8hg8.fsf@linaro.org>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-11-git-send-email-drjones@redhat.com>
 <874m3f8621.fsf@linaro.org> <4d1964d4-6540-3df6-8193-6dac3efa7d5c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C933404BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 04:59:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J0vG28gPA-uk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2016 04:59:46 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8867404DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 04:59:45 -0500 (EST)
Received: by mail-wm0-f42.google.com with SMTP id f82so82372205wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 02:00:10 -0800 (PST)
In-reply-to: <4d1964d4-6540-3df6-8193-6dac3efa7d5c@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CkFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPiB3cml0ZXM6Cgo+IEhpLAo+
Cj4gT24gMTAvMTEvMTYgMTk6NTMsIEFsZXggQmVubsOpZSB3cm90ZToKPgo+IC4uLi4KPj4gU28g
SSB3YXMgcmUtYmFzaW5nIG15IGt2bS11bml0LXRlc3RzIGFnYWluc3QgeW91ciBHSUMgcmV3b3Jr
IGFuZCBmb3VuZAo+PiBteXNlbGYgY29weSBhbmQgcGFzdGluZyBhIGJ1bmNoIG9mIHRoaXMgaW50
byBteSB0ZXN0cyB0aGF0IGZpcmUgSVJRcy4KPgo+IFNvIEkgdGFrZSBpdCB5b3UgYXJlIHdvcmtp
bmcgb24gKG9yIGFscmVhZHkgaGF2ZSkgY29kZSB0byB0ZXN0IFNQSXMsCj4gcHJvYmFibHkgdmlh
IEdJQ0RfSVNQRU5EUj8KPiBKdXN0IGFza2luZyBiZWNhdXNlIEkgd2FzIHRoaW5raW5nIGFib3V0
IGdvaW5nIHRoZXJlIGFuZCB0aHVzIGNvdWxkIHNhdmUKPiBteSB0aW1lIGlmIHlvdSBhcmUgb24g
aXQgYWxyZWFkeS4uLgoKSW4gbXkgY2FzZSBJIHdhbnRlZCB0byB0cmlnZ2VyIFNQSXMgdG8gZXhl
cmNpc2UgbXkgVENHIHRlc3RzIGZvciBNVFRDRzoKCiAgaHR0cHM6Ly9naXRodWIuY29tL3N0c3F1
YWQva3ZtLXVuaXQtdGVzdHMvYmxvYi9tdHRjZy9jdXJyZW50LXRlc3RzLXY2L2FybS90Y2ctdGVz
dC5jI0wxMTMKCj4+IFRoYXQgbWFrZXMgbWUgdGhpbmsgdGhlIGFic3RyYWN0aW9uIHNob3VsZCBi
ZSBpbiB0aGUgbGlicmFyeSBjb2RlIHNvCj4+IG90aGVyIHRlc3RzIGNhbiBmaWRkbGUgd2l0aCBz
ZW5kaW5nIElSUXMuCj4KPiAuLi5iZWNhdXNlIEkgd2FzIHdvbmRlcmluZyB0aGUgc2FtZS4KClRv
IGFuc3dlciBBbmRyZXcncyBxdWVzdGlvbiBmcm9tIHRoZSBvdGhlciBwb3N0IEkgd291bGQgYmUg
aGFwcHkgd2l0aCBhCmNvbW1vbjoKCiAgZ2ljX2VuYWJsZQogIGdpY19zZW5kX3NwaShjcHUsIGly
cSkKICBnaWNfaXJxX2FjaygpIHdoaWNoIHJldHVybnMgdGhlIGlhci4KCgo+Cj4gQ2hlZXJzLAo+
IEFuZHJlLgoKCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
