Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE8EC432C3
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 19:58:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8009216F4
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 19:58:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8009216F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A2BB4A51F;
	Thu, 28 Nov 2019 14:58:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W5ZSvt4-2bmo; Thu, 28 Nov 2019 14:58:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9EA14A52C;
	Thu, 28 Nov 2019 14:58:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EA694A51E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 14:58:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L0wQxs6BR6uh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 14:58:07 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A46264A511
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 14:58:07 -0500 (EST)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
 (envelope-from <bigeasy@linutronix.de>)
 id 1iaPvR-0001FP-B4; Thu, 28 Nov 2019 20:58:05 +0100
Date: Thu, 28 Nov 2019 20:58:05 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: James Morse <james.morse@arm.com>
Subject: [PATCH v2] arm64: KVM: Invoke compute_layout() before alternatives
 are applied
Message-ID: <20191128195805.c2pryug4ohmcoqwd@linutronix.de>
References: <20191016165953.o6ogh4fdmsjmd2sw@linutronix.de>
 <ecfbb413-e97e-c3eb-e051-1f218b387edd@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ecfbb413-e97e-c3eb-e051-1f218b387edd@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Y29tcHV0ZV9sYXlvdXQoKSBpcyBpbnZva2VkIGFzIHBhcnQgb2YgYW4gYWx0ZXJuYXRpdmUgZml4
dXAgdW5kZXIKc3RvcF9tYWNoaW5lKCkuIFRoaXMgZnVuY3Rpb24gaW52b2tlcyBnZXRfcmFuZG9t
X2xvbmcoKSB3aGljaCBhY3F1aXJlcyBhCnNsZWVwaW5nIGxvY2sgb24gLVJUIHdoaWNoIGNhbiBu
b3QgYmUgYWNxdWlyZWQgaW4gdGhpcyBjb250ZXh0LgoKUmVuYW1lIGNvbXB1dGVfbGF5b3V0KCkg
dG8ga3ZtX2NvbXB1dGVfbGF5b3V0KCkgYW5kIGludm9rZSBpdCBiZWZvcmUKc3RvcF9tYWNoaW5l
KCkgYXBwbGllcyB0aGUgYWx0ZXJuYXRpdmVzLiBBZGQgYSBfX2luaXQgcHJlZml4IHRvCmt2bV9j
b21wdXRlX2xheW91dCgpIGJlY2F1c2UgdGhlIGNhbGxlciBoYXMgaXQsIHRvbyAoYW5kIHNvIHRo
ZSBjb2RlIGNhbiBiZQpkaXNjYXJkZWQgYWZ0ZXIgYm9vdCkuCgpTaWduZWQtb2ZmLWJ5OiBTZWJh
c3RpYW4gQW5kcnplaiBTaWV3aW9yIDxiaWdlYXN5QGxpbnV0cm9uaXguZGU+Ci0tLQoKdjHigKZ2
MjogTW92ZSBjb2RlIGFzIHN1Z2dlc3RlZCBieSBKYW1lcyBNb3JzZS4gRGlkbid0IGFkZCBoaXMg
UmV2aWV3ZWQtYnkKICAgICAgIChhcyBzdWdnZXN0ZWQpIGJlY2F1c2UgSSdtIG5vdCBzdXJlIHRo
YXQgSSBnb3QgZXZlcnl0aGluZwogICAgICAgY29ycmVjdC4KCiBhcmNoL2FybTY0L2luY2x1ZGUv
YXNtL2t2bV9tbXUuaCB8IDEgKwogYXJjaC9hcm02NC9rZXJuZWwvc21wLmMgICAgICAgICAgfCA0
ICsrKysKIGFyY2gvYXJtNjQva3ZtL3ZhX2xheW91dC5jICAgICAgIHwgOCArLS0tLS0tLQogMyBm
aWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fbW11LmggYi9hcmNoL2FybTY0L2luY2x1ZGUv
YXNtL2t2bV9tbXUuaAppbmRleCBiZWZlMzdkNGJjMGU1Li41M2Q4NDZmMWJmZTcwIDEwMDY0NAot
LS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9tbXUuaAorKysgYi9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL2t2bV9tbXUuaApAQCAtOTEsNiArOTEsNyBAQCBhbHRlcm5hdGl2ZV9jYl9lbmQK
IAogdm9pZCBrdm1fdXBkYXRlX3ZhX21hc2soc3RydWN0IGFsdF9pbnN0ciAqYWx0LAogCQkJX19s
ZTMyICpvcmlncHRyLCBfX2xlMzIgKnVwZHB0ciwgaW50IG5yX2luc3QpOwordm9pZCBrdm1fY29t
cHV0ZV9sYXlvdXQodm9pZCk7CiAKIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBfX2tlcm5f
aHlwX3ZhKHVuc2lnbmVkIGxvbmcgdikKIHsKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva2VybmVs
L3NtcC5jIGIvYXJjaC9hcm02NC9rZXJuZWwvc21wLmMKaW5kZXggZGM5ZmU4NzljMjc5My4uMDJk
NDFlYWUzZGE4NiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvc21wLmMKKysrIGIvYXJj
aC9hcm02NC9rZXJuZWwvc21wLmMKQEAgLTMxLDYgKzMxLDcgQEAKICNpbmNsdWRlIDxsaW51eC9v
Zi5oPgogI2luY2x1ZGUgPGxpbnV4L2lycV93b3JrLmg+CiAjaW5jbHVkZSA8bGludXgva2V4ZWMu
aD4KKyNpbmNsdWRlIDxsaW51eC9rdm1faG9zdC5oPgogCiAjaW5jbHVkZSA8YXNtL2FsdGVybmF0
aXZlLmg+CiAjaW5jbHVkZSA8YXNtL2F0b21pYy5oPgpAQCAtMzksNiArNDAsNyBAQAogI2luY2x1
ZGUgPGFzbS9jcHV0eXBlLmg+CiAjaW5jbHVkZSA8YXNtL2NwdV9vcHMuaD4KICNpbmNsdWRlIDxh
c20vZGFpZmZsYWdzLmg+CisjaW5jbHVkZSA8YXNtL2t2bV9tbXUuaD4KICNpbmNsdWRlIDxhc20v
bW11X2NvbnRleHQuaD4KICNpbmNsdWRlIDxhc20vbnVtYS5oPgogI2luY2x1ZGUgPGFzbS9wZ3Rh
YmxlLmg+CkBAIC00MDgsNiArNDEwLDggQEAgc3RhdGljIHZvaWQgX19pbml0IGh5cF9tb2RlX2No
ZWNrKHZvaWQpCiAJCQkgICAiQ1BVOiBDUFVzIHN0YXJ0ZWQgaW4gaW5jb25zaXN0ZW50IG1vZGVz
Iik7CiAJZWxzZQogCQlwcl9pbmZvKCJDUFU6IEFsbCBDUFUocykgc3RhcnRlZCBhdCBFTDFcbiIp
OworCWlmIChJU19FTkFCTEVEKENPTkZJR19LVk1fQVJNX0hPU1QpKQorCQlrdm1fY29tcHV0ZV9s
YXlvdXQoKTsKIH0KIAogdm9pZCBfX2luaXQgc21wX2NwdXNfZG9uZSh1bnNpZ25lZCBpbnQgbWF4
X2NwdXMpCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92YV9sYXlvdXQuYyBiL2FyY2gvYXJt
NjQva3ZtL3ZhX2xheW91dC5jCmluZGV4IDJjZjdkNGI2MDZjMzguLmRhYjFmZWE0NzUyYWEgMTAw
NjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZhX2xheW91dC5jCisrKyBiL2FyY2gvYXJtNjQva3Zt
L3ZhX2xheW91dC5jCkBAIC0yMiw3ICsyMiw3IEBAIHN0YXRpYyB1OCB0YWdfbHNiOwogc3RhdGlj
IHU2NCB0YWdfdmFsOwogc3RhdGljIHU2NCB2YV9tYXNrOwogCi1zdGF0aWMgdm9pZCBjb21wdXRl
X2xheW91dCh2b2lkKQorX19pbml0IHZvaWQga3ZtX2NvbXB1dGVfbGF5b3V0KHZvaWQpCiB7CiAJ
cGh5c19hZGRyX3QgaWRtYXBfYWRkciA9IF9fcGFfc3ltYm9sKF9faHlwX2lkbWFwX3RleHRfc3Rh
cnQpOwogCXU2NCBoeXBfdmFfbXNiOwpAQCAtMTEwLDkgKzExMCw2IEBAIHZvaWQgX19pbml0IGt2
bV91cGRhdGVfdmFfbWFzayhzdHJ1Y3QgYWx0X2luc3RyICphbHQsCiAKIAlCVUdfT04obnJfaW5z
dCAhPSA1KTsKIAotCWlmICghaGFzX3ZoZSgpICYmICF2YV9tYXNrKQotCQljb21wdXRlX2xheW91
dCgpOwotCiAJZm9yIChpID0gMDsgaSA8IG5yX2luc3Q7IGkrKykgewogCQl1MzIgcmQsIHJuLCBp
bnNuLCBvaW5zbjsKIApAQCAtMTU2LDkgKzE1Myw2IEBAIHZvaWQga3ZtX3BhdGNoX3ZlY3Rvcl9i
cmFuY2goc3RydWN0IGFsdF9pbnN0ciAqYWx0LAogCQlyZXR1cm47CiAJfQogCi0JaWYgKCF2YV9t
YXNrKQotCQljb21wdXRlX2xheW91dCgpOwotCiAJLyoKIAkgKiBDb21wdXRlIEhZUCBWQSBieSB1
c2luZyB0aGUgc2FtZSBjb21wdXRhdGlvbiBhcyBrZXJuX2h5cF92YSgpCiAJICovCi0tIAoyLjI0
LjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
