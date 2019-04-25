From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v7 00/27] KVM: arm64: SVE guest support
Date: Thu, 25 Apr 2019 11:33:09 +0100
Message-ID: <878svywf16.fsf@zen.linaroharston>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 915FB4A480
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 06:33:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VwszXRDB3a0k for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 06:33:12 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 748354A331
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 06:33:12 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id s15so29517182wra.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 03:33:12 -0700 (PDT)
In-reply-to: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFRoaXMgc2VyaWVz
IGltcGxlbWVudHMgc3VwcG9ydCBmb3IgYWxsb3dpbmcgS1ZNIGd1ZXN0cyB0byB1c2UgdGhlIEFy
bQo+IFNjYWxhYmxlIFZlY3RvciBFeHRlbnNpb24gKFNWRSksIHN1cGVyc2VkaW5nIHRoZSBwcmV2
aW91cyB2NiBzZXJpZXMgWzFdLgo+Cj4gVGhlIHBhdGNoZXMgYXJlIGFsc28gYXZhaWxhYmxlIG9u
IGEgYnJhbmNoIGZvciByZXZpZXdlciBjb252ZW5pZW5jZS4gWzJdCj4KPiBUaGUgcGF0Y2hlcyBh
cmUgYmFzZWQgb24gdjUuMS1yYzIuCj4KPiBUaGlzIHNlcmllcyBhZGRyZXNzZXMgYSBjb3VwbGUg
b2YgbWlub3IgcmV2aWV3IGNvbW1lbnRzIHJlY2VpdmVkIG9uIHY2Cj4gYW5kIG90aGVyd2lzZSBh
cHBsaWVzIHJldmlld2VyIHRhZ3Mgb25seS4gIFRoZSBjb2RlIGRpZmZlcmVuY2VzCj4gYmV0d2Vl
biB2NiBhbmQgdGhpcyBzZXJpZXMgY29uc2lzdCBvZiBtaW5vciBjb3NtZXRpYyBmaXh1cHMgb25s
eS4KPgo+IERyYWZ0IGt2bXRvb2wgcGF0Y2hlcyB3ZXJlIHBvc3RlZCBzZXBhcmF0ZWx5IFszXSwg
WzRdLgo+Cj4gRm9yIGEgZGVzY3JpcHRpb24gb2YgbWlub3IgdXBkYXRlcywgc2VlIHRoZSBpbmRp
dmlkdWFsIHBhdGNoZXMuCj4KPgo+IFRoYW5rcyBnbyB0byBKdWxpZW4gVGhpZXJyeSBhbmQgSnVs
aWFuIEdyYWxsIGZvciB0aGVpciByZXZpZXcgZWZmb3J0cywKPiBhbmQgdG8gWmhhbmcgTGVpIGZv
ciB0ZXN0aW5nIHRoZSBzZXJpZXMgLS0gbWFueSB0aGFua3MgZm9yIHRoZWlyIGhlbHAKPiBpbiBn
ZXR0aW5nIHRoZSBzZXJpZXMgdG8gdGhpcyBwb2ludCEKPgo+Cj4gUmV2aWV3ZXJzJyBhdHRlbnRp
b24gaXMgZHJhd24gdG8gdGhlIGZvbGxvd2luZyBwYXRjaGVzLCB3aGljaCBoYXZlIG5vCj4gUmV2
aWV3ZWQtYnkvQWNrZWQtYnkuICBQbGVhc2UgdGFrZSBhIGxvb2sgaWYgeW91IGhhdmUgYSBtb21l
bnQuCj4KPiAgKiBQYXRjaCAxMSAoS1ZNOiBhcm02NDogU3VwcG9ydCBydW50aW1lIHN5c3JlZyB2
aXNpYmlsaXR5IGZpbHRlcmluZykKPgo+ICAgIFByZXZpb3VzbHkgUmV2aWV3ZWQtYnkgSnVsaWVu
IFRoaWVycnksIGJ1dCB0aGlzIHZlcnNpb24gb2YgdGhlCj4gICAgcGF0Y2ggY29udGFpbnMgc29t
ZSBtaW5vciByZXdvcmsgc3VnZ2VzdGVkIGJ5IE1hcmsgUnV0bGFuZCBkdXJpbmcKPiAgICB0aGUg
djUgcmV2aWV3IFs1XS4KPgo+ICAqIFBhdGNoIDE1IChLVk06IGFybTY0OiBBZGQgbWlzc2luZyAj
aW5jbHVkZSBvZiA8bGludXgvc3RyaW5nLmg+Cj4gICAgaW4gZ3Vlc3QuYykKPgo+ICAgIChUcml2
aWFsIHBhdGNoLikKPgo+ICAqIFBhdGNoIDI2OiAoS1ZNOiBEb2N1bWVudCBlcnJvcnMgZm9yIEtW
TV9HRVRfT05FX1JFRyBhbmQKPiAgICBLVk1fU0VUX09ORV9SRUcpCj4KPiAgICAoRG9jdW1lbnRh
dGlvbiBvbmx5LikKPgo+ICAqIFBhdGNoIDI3OiBLVk06IGFybTY0L3N2ZTogRG9jdW1lbnQgS1ZN
IEFQSSBleHRlbnNpb25zIGZvciBTVkUKPgo+ICAgIChEb2N1bWVudGF0aW9uIG9ubHkuKQoKSSd2
ZSBmaW5pc2hlZCBnb2luZyB0aHJvdWdoIHRoZSBzZXJpZXMuIEFzaWRlIGZyb20gYSBmZXcgbWlu
b3Igbml0cyBhbmQKdGhlIGRpc2N1c3Npb24geW91J3ZlIGFscmVhZHkgaGFkIHdpdGggZHJldyBo
YXBweSB3aXRoIGl0LiBIYXZlIGEKZ2VuZXJhbDoKClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUg
PGFsZXguYmVubmVlQGxpbmFyby5vcmc+Cgpmb3IgdGhlIG1haWwgcmVjb3JkLi4uCj4KPiBLbm93
biBpc3N1ZXM6IG5vbmUKPgo+Cj4gVGVzdGluZyBzdGF0dXM6Cj4KPiAgKiBMaWdodHdlaWdodCB0
ZXN0aW5nIG9uIHRoZSBBcm0gRmFzdCBNb2RlbCwgcHJpbWFyaWx5IHRvIGV4ZXJjaXNlIHRoZQo+
ICAgIG5ldyB2Y3B1IGZpbmFsaXphdGlvbiBBUEkuCj4KPiAgICBSYW4gc3ZlLXN0cmVzcyB0ZXN0
aW5nIGZvciBzZXZlcmFsIGRheXMgb24gdjYgb24gdGhlIEFybSBGYXN0IE1vZGVsLAo+ICAgIHdp
dGggbm8gZXJyb3JzIG9ic2VydmVkLgoKT25jZSB3ZSBoYXZlIFZIRSBzdXBwb3J0IGluIFFFTVUg
SSBpbnRlbmQgdG8gZ2l2ZSBpdCBhIGJpdCBtb3JlIHRlc3RpbmcuCgotLQpBbGV4IEJlbm7DqWUK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
