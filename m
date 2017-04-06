From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC kvm-unit-tests PATCH 6/8] Makefiles: handle linking of scripts
 into build-tree
Date: Thu,  6 Apr 2017 20:07:25 +0100
Message-ID: <20170406190727.5624-7-alex.bennee@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4E840C4F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 15:05:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cFFb-8Ik1ED1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Apr 2017 15:05:24 -0400 (EDT)
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F3C040C2A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 15:05:24 -0400 (EDT)
Received: by mail-wr0-f179.google.com with SMTP id g19so32949182wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Apr 2017 12:07:40 -0700 (PDT)
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

V2hlbiBkb2luZyBhbiBvdXQtb2Ytc3JjLXRyZWUgYnVpbGQgd2Ugc3RpbGwgd2FudCBhY2Nlc3Mg
dG8gdGhlCnZhcmlvdXMgYml0cyBvZiBjb21tb24gc2NyaXB0IG1hY2hpbmVyeSB0byBydW4uIFRo
aXMgaXMgaGFuZGxlZCBieSB0aGUKc2NyaXB0cy1jb21tb24gbGlzdCB3aGljaCBzdWItYnVpbGRz
IGNhbiBhZGQgZXhwbGljaXQgZXh0cmEgc3R1ZmYgdG8uCgpUaGUgZmluYWwgcnVsZSBpcyBjb25k
aXRpb25hbCBzbyB3ZSBkb24ndCBhdHRlbXB0IHRvIGxpbmsgZmlsZXMgd2hlbgp3ZSBhcmUgZG9p
bmcgYW4gaW4tc3JjLXRyZWUgYnVpbGQuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFs
ZXguYmVubmVlQGxpbmFyby5vcmc+Ci0tLQogTWFrZWZpbGUgICAgICAgICAgICB8IDEzICsrKysr
KysrKysrKysKIHg4Ni9NYWtlZmlsZS5jb21tb24gfCAgNCArKysrCiAyIGZpbGVzIGNoYW5nZWQs
IDE3IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCmluZGV4
IDU2NTk4ZGYuLmM5ZmVhODggMTAwNjQ0Ci0tLSBhL01ha2VmaWxlCisrKyBiL01ha2VmaWxlCkBA
IC0zMSw2ICszMSwxMCBAQCBjZmxhdG9ianMgOj0gXAogCWxpYi9yZXBvcnQubyBcCiAJbGliL3N0
YWNrLm8KIAorIyBUaGVzZSBhcmUgc2NyaXB0cyB3ZSB3YW50IGxpbmtlZCBmcm9tIHRoZSBzb3Vy
Y2UgdHJlZQorc2NyaXB0cy1jb21tb24gOj0gcnVuX3Rlc3RzLnNoIFwKKwlzY3JpcHRzCisKICMg
bGliZmR0IHBhdGhzCiBMSUJGRFRfb2JqZGlyID0gJChTUkNESVIpL2xpYi9saWJmZHQKIExJQkZE
VF9zcmNkaXIgPSAkKFNSQ0RJUikvbGliL2xpYmZkdApAQCAtODYsOCArOTAsMTcgQEAgJChMSUJG
RFRfYXJjaGl2ZSk6ICQoYWRkcHJlZml4ICQoTElCRkRUX29iamRpcikvLCQoTElCRkRUX09CSlMp
KQogCW1rZGlyIC1wICQoZGlyICRAKQogCSQoQ0MpICQoQ0ZMQUdTKSAtYyAtbyAkQCAkPAogCisk
KHNjcmlwdHMtY29tbW9uKTogJChTUkNESVIpLyRACisJbG4gLXNmICQ8JEAgJEAKKwogLWluY2x1
ZGUgKi8uKi5kICovKi8uKi5kCiAKKworIyBXZSBvbmx5IG5lZWQgdG8gbGluayBjb21tb24gc2Ny
aXB0cyBmb3Igb3V0LW9mLXNyYy10cmVlIGJ1aWxkcworaWZuZXEgKCQoQ1VSRElSKSwgJChTUkNE
SVIpKQorYWxsOiAkKHNjcmlwdHMtY29tbW9uKQorZW5kaWYKKwogYWxsOiAkKHNoZWxsIGdpdCAt
QyAkKFNSQ0RJUikgcmV2LXBhcnNlIC0tdmVyaWZ5IC0tc2hvcnQ9OCBIRUFEID5idWlsZC1oZWFk
IDI+L2Rldi9udWxsKQogCiBzdGFuZGFsb25lOiBhbGwKZGlmZiAtLWdpdCBhL3g4Ni9NYWtlZmls
ZS5jb21tb24gYi94ODYvTWFrZWZpbGUuY29tbW9uCmluZGV4IGZiYWI4MmMuLmVmNmU1NDMgMTAw
NjQ0Ci0tLSBhL3g4Ni9NYWtlZmlsZS5jb21tb24KKysrIGIveDg2L01ha2VmaWxlLmNvbW1vbgpA
QCAtNTQsOCArNTQsMTIgQEAgdGVzdHMtY29tbW9uICs9IGFwaS9kaXJ0eS1sb2cKIHRlc3RzLWNv
bW1vbiArPSBhcGkvZGlydHktbG9nLXBlcmYKIGVuZGlmCiAKK3NjcmlwdHMtY29tbW9uICs9ICQo
VEVTVF9ESVIpL3J1bgorc2NyaXB0cy1jb21tb24gKz0gJChURVNUX0RJUikvdW5pdHRlc3RzLmNm
ZworCiB0ZXN0X2Nhc2VzOiAkKHRlc3RzLWNvbW1vbikgJCh0ZXN0cykKIAorCiAkKFRFU1RfRElS
KS8lLm86IENGTEFHUyArPSAtc3RkPWdudTk5IC1mZnJlZXN0YW5kaW5nIC1JIGxpYiAtSSBsaWIv
eDg2CiAKICQoVEVTVF9ESVIpL3JlYWxtb2RlLmVsZjogJChURVNUX0RJUikvcmVhbG1vZGUubwot
LSAKMi4xMS4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
