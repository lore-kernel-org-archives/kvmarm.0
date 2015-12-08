From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v10 3/6] target-arm: kvm - support for single step
Date: Tue,  8 Dec 2015 18:32:30 +0000
Message-ID: <1449599553-24713-4-git-send-email-alex.bennee@linaro.org>
References: <1449599553-24713-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C097407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 13:31:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TzIiEVd-UMTY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 13:31:09 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21EAD40F90
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 13:31:08 -0500 (EST)
Received: by wmec201 with SMTP id c201so225309284wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2015 10:33:00 -0800 (PST)
In-Reply-To: <1449599553-24713-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBhZGRzIHN1cHBvcnQgZm9yIHNpbmdsZS1zdGVwLiBUaGVyZSBpc24ndCBtdWNoIHRvIGRv
IG9uIHRoZSBRRU1VCnNpZGUgYXMgYWZ0ZXIgd2Ugc2V0LXVwIHRoZSByZXF1ZXN0IGZvciBzaW5n
bGUgc3RlcCB2aWEgdGhlIGRlYnVnIGlvY3RsCml0IGlzIGFsbCBoYW5kbGVkIHdpdGhpbiB0aGUg
a2VybmVsLgoKVGhlIGFjdHVhbCBzZXR0aW5nIG9mIHRoZSBLVk1fR1VFU1REQkdfU0lOR0xFU1RF
UCBmbGFnIGlzIGFscmVhZHkgaW4gdGhlCmNvbW1vbiBjb2RlLiBJZiB0aGUga2VybmVsIGRvZXNu
J3Qgc3VwcG9ydCBndWVzdCBkZWJ1ZyB0aGUgaW9jdGwgd2lsbApzaW1wbHkgZXJyb3IuCgpTaWdu
ZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CgotLS0KdjIK
ICAtIGNvbnZlcnQgdG8gdXNpbmcgSFNSX0VDCnYzCiAgLSB1c2UgaW50ZXJuYWxzLmggZGVmaW5p
dGlvbnMKdjEwCiAgLSBmaXggYXJtMzIgYnVpbGQKICAtIHJlbW92ZSByZWR1bmRlbnQgZmxhZyBz
ZXR0aW5nIChkb25lIGluIG1haW4ga3ZtLmMpCiAgLSBtb3JlIHdvcmRzIG9uIGZhaWwgY2FzZQot
LS0KIHRhcmdldC1hcm0va3ZtNjQuYyB8IDcgKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDcgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL3RhcmdldC1hcm0va3ZtNjQuYyBiL3RhcmdldC1hcm0v
a3ZtNjQuYwppbmRleCAzYjM5MjlkLi41Zjk2Y2RlIDEwMDY0NAotLS0gYS90YXJnZXQtYXJtL2t2
bTY0LmMKKysrIGIvdGFyZ2V0LWFybS9rdm02NC5jCkBAIC01MzQsNiArNTM0LDEzIEBAIGJvb2wg
a3ZtX2FybV9oYW5kbGVfZGVidWcoQ1BVU3RhdGUgKmNzLCBzdHJ1Y3Qga3ZtX2RlYnVnX2V4aXRf
YXJjaCAqZGVidWdfZXhpdCkKICAgICBrdm1fY3B1X3N5bmNocm9uaXplX3N0YXRlKGNzKTsKIAog
ICAgIHN3aXRjaCAoaHNyX2VjKSB7CisgICAgY2FzZSBFQ19TT0ZUV0FSRVNURVA6CisgICAgICAg
IGlmIChjcy0+c2luZ2xlc3RlcF9lbmFibGVkKSB7CisgICAgICAgICAgICByZXR1cm4gdHJ1ZTsK
KyAgICAgICAgfSBlbHNlIHsKKyAgICAgICAgICAgIGVycm9yX3JlcG9ydCgiQ2FtZSBvdXQgb2Yg
U0lOR0xFIFNURVAgd2hlbiBub3QgZW5hYmxlZCIpOworICAgICAgICB9CisgICAgICAgIGJyZWFr
OwogICAgIGNhc2UgRUNfQUE2NF9CS1BUOgogICAgICAgICBpZiAoa3ZtX2ZpbmRfc3dfYnJlYWtw
b2ludChjcywgZW52LT5wYykpIHsKICAgICAgICAgICAgIHJldHVybiB0cnVlOwotLSAKMi42LjMK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
