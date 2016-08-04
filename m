From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 1/8] KVM: api: Pass the devid in the msi routing entry
Date: Thu,  4 Aug 2016 13:40:29 +0200
Message-ID: <1470310836-10371-2-git-send-email-christoffer.dall@linaro.org>
References: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC24410B5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:33:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ToM3HFlwg8v for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2016 07:33:52 -0400 (EDT)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3493949B34
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:33:52 -0400 (EDT)
Received: by mail-lf0-f46.google.com with SMTP id g62so180275549lfe.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2016 04:40:45 -0700 (PDT)
In-Reply-To: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKT24gQVJNLCB0aGUgTVNJ
IG1zZyAoYWRkcmVzcyBhbmQgZGF0YSkgY29tZXMgYWxvbmcgd2l0aApvdXQtb2YtYmFuZCBkZXZp
Y2UgSUQgaW5mb3JtYXRpb24uIFRoZSBkZXZpY2UgSUQgZW5jb2RlcyB0aGUKZGV2aWNlIHRoYXQg
d3JpdGVzIHRoZSBNU0kgbXNnLiBMZXQncyBjb252ZXkgdGhlIGRldmljZSBpZCBpbgprdm1faXJx
X3JvdXRpbmdfbXNpIGFuZCB1c2UgS1ZNX01TSV9WQUxJRF9ERVZJRCBmbGFnIHZhbHVlIGluCmt2
bV9pcnFfcm91dGluZ19lbnRyeSB0byBpbmRpY2F0ZSB0aGUgbXNpIGRldmlkIGlzIHBvcHVsYXRl
ZC4KClNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KUmV2
aWV3ZWQtYnk6IEFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPgpBY2tlZC1i
eTogUmFkaW0gS3LEjW3DocWZIDxya3JjbWFyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IE1h
cmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+Ci0tLQogRG9jdW1lbnRhdGlvbi92aXJ0
dWFsL2t2bS9hcGkudHh0IHwgMTkgKysrKysrKysrKysrKysrKystLQogaW5jbHVkZS91YXBpL2xp
bnV4L2t2bS5oICAgICAgICAgIHwgIDUgKysrKy0KIDIgZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnR1
YWwva3ZtL2FwaS50eHQgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2FwaS50eHQKaW5kZXgg
MDcwNDllYS4uNDE1Y2RlMSAxMDA2NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9h
cGkudHh0CisrKyBiL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dApAQCAtMTQ2OCw3
ICsxNDY4LDExIEBAIHN0cnVjdCBrdm1faXJxX3JvdXRpbmdfZW50cnkgewogI2RlZmluZSBLVk1f
SVJRX1JPVVRJTkdfUzM5MF9BREFQVEVSIDMKICNkZWZpbmUgS1ZNX0lSUV9ST1VUSU5HX0hWX1NJ
TlQgNAogCi1ObyBmbGFncyBhcmUgc3BlY2lmaWVkIHNvIGZhciwgdGhlIGNvcnJlc3BvbmRpbmcg
ZmllbGQgbXVzdCBiZSBzZXQgdG8gemVyby4KK2ZsYWdzOgorLSBLVk1fTVNJX1ZBTElEX0RFVklE
OiB1c2VkIGFsb25nIHdpdGggS1ZNX0lSUV9ST1VUSU5HX01TSQorICByb3V0aW5nIGVudHJ5IHR5
cGUsIHNwZWNpZmllcyB0aGF0IHRoZSBkZXZpZCBmaWVsZCBjb250YWlucworICBhIHZhbGlkIHZh
bHVlLgorLSB6ZXJvIG90aGVyd2lzZQogCiBzdHJ1Y3Qga3ZtX2lycV9yb3V0aW5nX2lycWNoaXAg
ewogCV9fdTMyIGlycWNoaXA7CkBAIC0xNDc5LDkgKzE0ODMsMjAgQEAgc3RydWN0IGt2bV9pcnFf
cm91dGluZ19tc2kgewogCV9fdTMyIGFkZHJlc3NfbG87CiAJX191MzIgYWRkcmVzc19oaTsKIAlf
X3UzMiBkYXRhOwotCV9fdTMyIHBhZDsKKwl1bmlvbiB7CisJCV9fdTMyIHBhZDsKKwkJX191MzIg
ZGV2aWQ7CisJfTsKIH07CiAKK2RldmlkOiBJZiBLVk1fTVNJX1ZBTElEX0RFVklEIGlzIHNldCwg
Y29udGFpbnMgYSB1bmlxdWUgZGV2aWNlIGlkZW50aWZpZXIKKyAgICAgICBmb3IgdGhlIGRldmlj
ZSB0aGF0IHdyb3RlIHRoZSBNU0kgbWVzc2FnZS4KKyAgICAgICBGb3IgUENJLCB0aGlzIGlzIHVz
dWFsbHkgYSBCRkQgaWRlbnRpZmllciBpbiB0aGUgbG93ZXIgMTYgYml0cy4KKworVGhlIHBlci1W
TSBLVk1fQ0FQX01TSV9ERVZJRCBjYXBhYmlsaXR5IGFkdmVydGlzZXMgdGhlIHJlcXVpcmVtZW50
IHRvCitwcm92aWRlIHRoZSBkZXZpY2UgSUQuIElmIHRoaXMgY2FwYWJpbGl0eSBpcyBub3Qgc2V0
LCB1c2VybGFuZCBjYW5ub3QKK3JlbHkgb24gdGhlIGtlcm5lbCB0byBhbGxvdyB0aGUgS1ZNX01T
SV9WQUxJRF9ERVZJRCBmbGFnIGJlaW5nIHNldC4KKwogc3RydWN0IGt2bV9pcnFfcm91dGluZ19z
MzkwX2FkYXB0ZXIgewogCV9fdTY0IGluZF9hZGRyOwogCV9fdTY0IHN1bW1hcnlfYWRkcjsKZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaCBiL2luY2x1ZGUvdWFwaS9saW51eC9r
dm0uaAppbmRleCBkOGM0YzMyLi5lYjIyMjA4IDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvbGlu
dXgva3ZtLmgKKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oCkBAIC04NzksNyArODc5LDEw
IEBAIHN0cnVjdCBrdm1faXJxX3JvdXRpbmdfbXNpIHsKIAlfX3UzMiBhZGRyZXNzX2xvOwogCV9f
dTMyIGFkZHJlc3NfaGk7CiAJX191MzIgZGF0YTsKLQlfX3UzMiBwYWQ7CisJdW5pb24geworCQlf
X3UzMiBwYWQ7CisJCV9fdTMyIGRldmlkOworCX07CiB9OwogCiBzdHJ1Y3Qga3ZtX2lycV9yb3V0
aW5nX3MzOTBfYWRhcHRlciB7Ci0tIAoxLjkuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
