From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC kvm-unit-tests PATCH 3/8] Makefile: set VPATH based on SRCDIR
Date: Thu,  6 Apr 2017 20:07:22 +0100
Message-ID: <20170406190727.5624-4-alex.bennee@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F22D840CC6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 15:05:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Olt33alyY0Xa for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Apr 2017 15:05:23 -0400 (EDT)
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F8CD40C1C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 15:05:22 -0400 (EDT)
Received: by mail-wr0-f179.google.com with SMTP id c55so3242212wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Apr 2017 12:07:38 -0700 (PDT)
In-Reply-To: <20170406190727.5624-1-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

U2V0dGluZyB0aGUgVlBBVEggcHJvbXB0cyBtYWtlIHRvIHNlYXJjaCBWUEFUSCBmb3Igc291cmNl
IGZpbGVzLiBUaGVyZQphcmUgc3RpbGwgc29tZSBmaXgtdXBzIG5lZWRlZCBmb3IgbGlua2luZyBh
bmQgaW5jbHVkaW5nIG90aGVyIE1ha2VmaWxlCmZyYWdtZW50cyBmb3IgZWFjaCBhcmNoaXRlY3R1
cmUuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+
Ci0tLQogTWFrZWZpbGUgfCAzICsrKwogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoK
ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggZWJhN2IyOC4uODBiYzU3ZSAx
MDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAgLTcsNiArNyw5IEBAIGVuZGlm
CiAKIGluY2x1ZGUgY29uZmlnLm1hawogCisjIFNldCBzZWFyY2ggcGF0aCBmb3IgYWxsIHNvdXJj
ZXMKK1ZQQVRIPSQoU1JDRElSKQorCiBsaWJkaXJzLWdldCA9ICQoc2hlbGwgWyAtZCAibGliLyQo
MSkiIF0gJiYgZWNobyAibGliLyQoMSkgbGliLyQoMSkvYXNtIikKIEFSQ0hfTElCRElSUyA6PSAk
KGNhbGwgbGliZGlycy1nZXQsJChBUkNIKSkgJChjYWxsIGxpYmRpcnMtZ2V0LCQoVEVTVF9ESVIp
KQogCi0tIAoyLjExLjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
