From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH 1/6] libcflat: add PRI(dux)32 format types
Date: Wed, 11 Jan 2017 16:28:36 +0000
Message-ID: <20170111162841.15569-2-alex.bennee@linaro.org>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0A240670
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:27:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p42feK3-brLU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 11:27:08 -0500 (EST)
Received: from mail-wj0-f170.google.com (mail-wj0-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EE14405A8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:27:07 -0500 (EST)
Received: by mail-wj0-f170.google.com with SMTP id kq3so60636432wjc.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 08:28:51 -0800 (PST)
In-Reply-To: <20170111162841.15569-1-alex.bennee@linaro.org>
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

U28gd2UgY2FuIGhhdmUgcG9ydGFibGUgZm9ybWF0dGluZyBvZiB1aW50MzJfdCB0eXBlcy4gSG93
ZXZlciB0aGVyZSBpcwphIGNhdGNoLiBEaWZmZXJlbnQgY29tcGlsZXJzIGNhbiB1c2UgbGVnYWxs
eSBzdWJ0bHkgZGlmZmVyZW50IHR5cGVzCnRob3VnaCBzbyB3ZSBuZWVkIHRvIHByb2JlIHRoZSBj
b21waWxlciBkZWZpbmVkIGludGRlZi5oIGZpcnN0LgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5u
w6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgotLS0KIE1ha2VmaWxlICAgICAgIHwgIDEgKwog
Y29uZmlndXJlICAgICAgfCAxMyArKysrKysrKysrKysrCiBsaWIvbGliY2ZsYXQuaCB8ICA5ICsr
KysrKysrKwogMyBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEv
TWFrZWZpbGUgYi9NYWtlZmlsZQppbmRleCBhMzIzMzNiLi45ODIyZDlhIDEwMDY0NAotLS0gYS9N
YWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAtNTUsNiArNTUsNyBAQCBDRkxBR1MgKz0gJChmb21p
dF9mcmFtZV9wb2ludGVyKQogQ0ZMQUdTICs9ICQoZm5vX3N0YWNrX3Byb3RlY3RvcikKIENGTEFH
UyArPSAkKGZub19zdGFja19wcm90ZWN0b3JfYWxsKQogQ0ZMQUdTICs9ICQod25vX2ZyYW1lX2Fk
ZHJlc3MpCitDRkxBR1MgKz0gJChpZiAkKFUzMl9MT05HX0ZNVCksLURfX1UzMl9MT05HX0ZNVF9f
LCkKIAogQ1hYRkxBR1MgKz0gJChDRkxBR1MpCiAKZGlmZiAtLWdpdCBhL2NvbmZpZ3VyZSBiL2Nv
bmZpZ3VyZQppbmRleCA5OTVjOGZhLi4xMjc4NjhjIDEwMDc1NQotLS0gYS9jb25maWd1cmUKKysr
IGIvY29uZmlndXJlCkBAIC0xMDksNiArMTA5LDE4IEBAIGlmIFsgLWYgJHRlc3RkaXIvcnVuIF07
IHRoZW4KICAgICBsbiAtZnMgJHRlc3RkaXIvcnVuICR0ZXN0ZGlyLXJ1bgogZmkKIAorIyBjaGVj
ayBpZiB1aW50MzJfdCBuZWVkcyBhIGxvbmcgZm9ybWF0IG1vZGlmaWVyCitjYXQgPDwgRU9GID4g
bGliX3Rlc3QuYworI2luY2x1ZGUgPGludHR5cGVzLmg+CitFT0YKKworJGNyb3NzX3ByZWZpeCRj
YyBsaWJfdGVzdC5jIC1FIHwgZ3JlcCAidHlwZWRlZiIgfCBncmVwICJsb25nIiB8IGdyZXAgInVp
bnQzMl90IiAmPiAvZGV2L251bGwKK2V4aXQ9JD8KK2lmIFsgJGV4aXQgLWVxIDAgXTsgdGhlbgor
ICAgIHUzMl9sb25nPXRydWUKK2ZpCitybSAtZiBsaWJfdGVzdC5jCisKICMgY2hlY2sgZm9yIGRl
cGVuZGVudCAzMiBiaXQgbGlicmFyaWVzCiBpZiBbICIkYXJjaCIgIT0gImFybSIgXTsgdGhlbgog
Y2F0IDw8IEVPRiA+IGxpYl90ZXN0LmMKQEAgLTE1NSw0ICsxNjcsNSBAQCBURVNUX0RJUj0kdGVz
dGRpcgogRklSTVdBUkU9JGZpcm13YXJlCiBFTkRJQU49JGVuZGlhbgogUFJFVFRZX1BSSU5UX1NU
QUNLUz0kcHJldHR5X3ByaW50X3N0YWNrcworVTMyX0xPTkdfRk1UPSR1MzJfbG9uZwogRU9GCmRp
ZmYgLS1naXQgYS9saWIvbGliY2ZsYXQuaCBiL2xpYi9saWJjZmxhdC5oCmluZGV4IDM4MDM5NWYu
LmU4MGZjNTAgMTAwNjQ0Ci0tLSBhL2xpYi9saWJjZmxhdC5oCisrKyBiL2xpYi9saWJjZmxhdC5o
CkBAIC01OCwxMiArNTgsMjEgQEAgdHlwZWRlZiBfQm9vbAkJYm9vbDsKICNkZWZpbmUgdHJ1ZSAg
MQogCiAjaWYgX19TSVpFT0ZfTE9OR19fID09IDgKKyMgIGRlZmluZSBfX1BSSTMyX1BSRUZJWAog
IyAgZGVmaW5lIF9fUFJJNjRfUFJFRklYCSJsIgogIyAgZGVmaW5lIF9fUFJJUFRSX1BSRUZJWAki
bCIKICNlbHNlCisjaWYgZGVmaW5lZChfX1UzMl9MT05HX0ZNVF9fKQorIyAgZGVmaW5lIF9fUFJJ
MzJfUFJFRklYICAgICAgICAibCIKKyNlbHNlCisjICBkZWZpbmUgX19QUkkzMl9QUkVGSVgKKyNl
bmRpZgogIyAgZGVmaW5lIF9fUFJJNjRfUFJFRklYCSJsbCIKICMgIGRlZmluZSBfX1BSSVBUUl9Q
UkVGSVgKICNlbmRpZgorI2RlZmluZSBQUklkMzIgIF9fUFJJMzJfUFJFRklYCSJkIgorI2RlZmlu
ZSBQUkl1MzIgIF9fUFJJMzJfUFJFRklYCSJ1IgorI2RlZmluZSBQUkl4MzIgIF9fUFJJMzJfUFJF
RklYCSJ4IgogI2RlZmluZSBQUklkNjQgIF9fUFJJNjRfUFJFRklYCSJkIgogI2RlZmluZSBQUkl1
NjQgIF9fUFJJNjRfUFJFRklYCSJ1IgogI2RlZmluZSBQUkl4NjQgIF9fUFJJNjRfUFJFRklYCSJ4
IgotLSAKMi4xMS4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
