From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v4 02/11] arm64: fix get_"sysreg32" and make
 MPIDR 64bit
Date: Thu, 10 Nov 2016 17:07:55 +0100
Message-ID: <1478794084-5273-3-git-send-email-drjones@redhat.com>
References: <1478794084-5273-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD3C40460
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 11:07:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OXcJ0dD9plxZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2016 11:07:51 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31E2C404EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 11:07:51 -0500 (EST)
In-Reply-To: <1478794084-5273-1-git-send-email-drjones@redhat.com>
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

bXJzIGlzIGFsd2F5cyA2NGJpdCwgc28gd2Ugc2hvdWxkIGFsd2F5cyB1c2UgYSA2NGJpdCByZWdp
c3Rlci4KU29tZXRpbWVzIHdlJ2xsIG9ubHkgd2FudCB0byByZXR1cm4gdGhlIGxvd2VyIDMyLCBi
dXQgbm90IGZvcgpNUElEUiwgYXMgdGhhdCBkb2VzIGRlZmluZSBmaWVsZHMgaW4gdGhlIHVwcGVy
IDMyLgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4K
UmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9m
Zi1ieTogQW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+Ci0tLQogbGliL2FybTY0L2Fz
bS9wcm9jZXNzb3IuaCB8IDE1ICsrKysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5z
ZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saWIvYXJtNjQvYXNtL3By
b2Nlc3Nvci5oIGIvbGliL2FybTY0L2FzbS9wcm9jZXNzb3IuaAppbmRleCA4NGQ1YzdjZTc1MmIu
LjlhMjA4ZmY3MjliNyAxMDA2NDQKLS0tIGEvbGliL2FybTY0L2FzbS9wcm9jZXNzb3IuaAorKysg
Yi9saWIvYXJtNjQvYXNtL3Byb2Nlc3Nvci5oCkBAIC02NiwxNCArNjYsMTcgQEAgc3RhdGljIGlu
bGluZSB1bnNpZ25lZCBsb25nIGN1cnJlbnRfbGV2ZWwodm9pZCkKIAlyZXR1cm4gZWwgJiAweGM7
CiB9CiAKLSNkZWZpbmUgREVGSU5FX0dFVF9TWVNSRUczMihyZWcpCQkJCVwKLXN0YXRpYyBpbmxp
bmUgdW5zaWduZWQgaW50IGdldF8jI3JlZyh2b2lkKQkJCVwKKyNkZWZpbmUgREVGSU5FX0dFVF9T
WVNSRUcocmVnLCB0eXBlKQkJCQlcCitzdGF0aWMgaW5saW5lIHR5cGUgZ2V0XyMjcmVnKHZvaWQp
CQkJCVwKIHsJCQkJCQkJCVwKLQl1bnNpZ25lZCBpbnQgcmVnOwkJCQkJXAotCWFzbSB2b2xhdGls
ZSgibXJzICUwLCAiICNyZWcgIl9lbDEiIDogIj1yIiAocmVnKSk7CVwKLQlyZXR1cm4gcmVnOwkJ
CQkJCVwKKwl1bnNpZ25lZCBsb25nIHI7CQkJCQlcCisJYXNtIHZvbGF0aWxlKCJtcnMgJTAsICIg
I3JlZyAiX2VsMSIgOiAiPXIiIChyKSk7CVwKKwlyZXR1cm4gKHR5cGUpcjsJCQkJCQlcCiB9Ci1E
RUZJTkVfR0VUX1NZU1JFRzMyKG1waWRyKQorI2RlZmluZSBERUZJTkVfR0VUX1NZU1JFRzMyKHJl
ZykgREVGSU5FX0dFVF9TWVNSRUcocmVnLCB1bnNpZ25lZCBpbnQpCisjZGVmaW5lIERFRklORV9H
RVRfU1lTUkVHNjQocmVnKSBERUZJTkVfR0VUX1NZU1JFRyhyZWcsIHVuc2lnbmVkIGxvbmcpCisK
K0RFRklORV9HRVRfU1lTUkVHNjQobXBpZHIpCiAKIC8qIE9ubHkgc3VwcG9ydCBBZmYwIGZvciBu
b3csIGdpY3YyIG9ubHkgKi8KICNkZWZpbmUgbXBpZHJfdG9fY3B1KG1waWRyKSAoKGludCkoKG1w
aWRyKSAmIDB4ZmYpKQotLSAKMi43LjQKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
