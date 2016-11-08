From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v4 05/11] arm/arm64: irq enable/disable
Date: Tue,  8 Nov 2016 21:21:33 +0100
Message-ID: <1478636499-14339-6-git-send-email-drjones@redhat.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D534048E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 15:21:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CNXZNl4Y7M6i for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2016 15:21:36 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE18040419
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 15:21:36 -0500 (EST)
In-Reply-To: <1478636499-14339-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

UmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KUmV2aWV3
ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTog
QW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+Ci0tLQogbGliL2FybS9hc20vcHJvY2Vz
c29yLmggICB8IDEwICsrKysrKysrKysKIGxpYi9hcm02NC9hc20vcHJvY2Vzc29yLmggfCAxMCAr
KysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9saWIvYXJtL2FzbS9wcm9jZXNzb3IuaCBiL2xpYi9hcm0vYXNtL3Byb2Nlc3Nvci5oCmluZGV4
IGFmYzkwM2NhN2Q0YS4uNzVhOGQwOGI4OTMzIDEwMDY0NAotLS0gYS9saWIvYXJtL2FzbS9wcm9j
ZXNzb3IuaAorKysgYi9saWIvYXJtL2FzbS9wcm9jZXNzb3IuaApAQCAtMzUsNiArMzUsMTYgQEAg
c3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGN1cnJlbnRfY3Bzcih2b2lkKQogCiAjZGVmaW5l
IGN1cnJlbnRfbW9kZSgpIChjdXJyZW50X2Nwc3IoKSAmIE1PREVfTUFTSykKIAorc3RhdGljIGlu
bGluZSB2b2lkIGxvY2FsX2lycV9lbmFibGUodm9pZCkKK3sKKwlhc20gdm9sYXRpbGUoImNwc2ll
IGkiIDogOiA6ICJtZW1vcnkiLCAiY2MiKTsKK30KKworc3RhdGljIGlubGluZSB2b2lkIGxvY2Fs
X2lycV9kaXNhYmxlKHZvaWQpCit7CisJYXNtIHZvbGF0aWxlKCJjcHNpZCBpIiA6IDogOiAibWVt
b3J5IiwgImNjIik7Cit9CisKIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGdldF9tcGlkcih2
b2lkKQogewogCXVuc2lnbmVkIGludCBtcGlkcjsKZGlmZiAtLWdpdCBhL2xpYi9hcm02NC9hc20v
cHJvY2Vzc29yLmggYi9saWIvYXJtNjQvYXNtL3Byb2Nlc3Nvci5oCmluZGV4IDk0ZjdjZTM1YjY1
Yy4uZDU0YTRlZDFjMTg3IDEwMDY0NAotLS0gYS9saWIvYXJtNjQvYXNtL3Byb2Nlc3Nvci5oCisr
KyBiL2xpYi9hcm02NC9hc20vcHJvY2Vzc29yLmgKQEAgLTY4LDYgKzY4LDE2IEBAIHN0YXRpYyBp
bmxpbmUgdW5zaWduZWQgbG9uZyBjdXJyZW50X2xldmVsKHZvaWQpCiAJcmV0dXJuIGVsICYgMHhj
OwogfQogCitzdGF0aWMgaW5saW5lIHZvaWQgbG9jYWxfaXJxX2VuYWJsZSh2b2lkKQoreworCWFz
bSB2b2xhdGlsZSgibXNyIGRhaWZjbHIsICMyIiA6IDogOiAibWVtb3J5Iik7Cit9CisKK3N0YXRp
YyBpbmxpbmUgdm9pZCBsb2NhbF9pcnFfZGlzYWJsZSh2b2lkKQoreworCWFzbSB2b2xhdGlsZSgi
bXNyIGRhaWZzZXQsICMyIiA6IDogOiAibWVtb3J5Iik7Cit9CisKICNkZWZpbmUgREVGSU5FX0dF
VF9TWVNSRUcocmVnLCB0eXBlKQkJCQlcCiBzdGF0aWMgaW5saW5lIHR5cGUgZ2V0XyMjcmVnKHZv
aWQpCQkJCVwKIHsJCQkJCQkJCVwKLS0gCjIuNy40CgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
