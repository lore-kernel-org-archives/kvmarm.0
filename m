From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC kvm-unit-tests PATCH 2/8] Makefile: ensure build-head works
 out-of-src-tree
Date: Thu,  6 Apr 2017 20:07:21 +0100
Message-ID: <20170406190727.5624-3-alex.bennee@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52D8B40A80
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 15:05:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 36CZiAm5EeqS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Apr 2017 15:05:21 -0400 (EDT)
Received: from mail-wr0-f176.google.com (mail-wr0-f176.google.com
 [209.85.128.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8432340AF9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 15:05:21 -0400 (EDT)
Received: by mail-wr0-f176.google.com with SMTP id t20so76935557wra.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Apr 2017 12:07:37 -0700 (PDT)
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

UGFzcyAtQyAkKFNSQ0RJUikgdG8gdGhlIGdpdCBjb21tYW5kIHRoYXQgZ2VuZXJhdGVzIHRoZSBi
dWlsZC1oZWFkCnN0YW1wLgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5l
ZUBsaW5hcm8ub3JnPgotLS0KIE1ha2VmaWxlIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtlZmls
ZQppbmRleCAxNmNlMjk3Li5lYmE3YjI4IDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtl
ZmlsZQpAQCAtODAsNyArODAsNyBAQCAkKExJQkZEVF9hcmNoaXZlKTogJChhZGRwcmVmaXggJChM
SUJGRFRfb2JqZGlyKS8sJChMSUJGRFRfT0JKUykpCiAKIC1pbmNsdWRlICovLiouZCAqLyovLiou
ZAogCi1hbGw6ICQoc2hlbGwgZ2l0IHJldi1wYXJzZSAtLXZlcmlmeSAtLXNob3J0PTggSEVBRCA+
YnVpbGQtaGVhZCAyPi9kZXYvbnVsbCkKK2FsbDogJChzaGVsbCBnaXQgLUMgJChTUkNESVIpIHJl
di1wYXJzZSAtLXZlcmlmeSAtLXNob3J0PTggSEVBRCA+YnVpbGQtaGVhZCAyPi9kZXYvbnVsbCkK
IAogc3RhbmRhbG9uZTogYWxsCiAJQHNjcmlwdHMvbWtzdGFuZGFsb25lLnNoCi0tIAoyLjExLjAK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
