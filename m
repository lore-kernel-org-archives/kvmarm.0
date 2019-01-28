From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 3.18 35/61] arm64: KVM: Skip MMIO insn after emulation
Date: Mon, 28 Jan 2019 11:25:57 -0500
Message-ID: <20190128162623.59854-35-sashal@kernel.org>
References: <20190128162623.59854-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E56A4A37D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 11:27:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GSNbbP3qSjV3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 11:27:25 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 751A64A36C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 11:27:25 -0500 (EST)
In-Reply-To: <20190128162623.59854-1-sashal@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, Sasha Levin <sashal@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4KClsgVXBzdHJlYW0gY29t
bWl0IDBkNjQwNzMyZGJlYmVkMGYxMGYxODUyNmRlMjE2NTI5MzFmMGIyZjIgXQoKV2hlbiB3ZSBl
bXVsYXRlIGFuIE1NSU8gaW5zdHJ1Y3Rpb24sIHdlIGFkdmFuY2UgdGhlIENQVSBzdGF0ZSB3aXRo
aW4KZGVjb2RlX2hzcigpLCBiZWZvcmUgZW11bGF0aW5nIHRoZSBpbnN0cnVjdGlvbiBlZmZlY3Rz
LgoKSGF2aW5nIHRoaXMgbG9naWMgaW4gZGVjb2RlX2hzcigpIGlzIG9wYXF1ZSwgYW5kIGFkdmFu
Y2luZyB0aGUgc3RhdGUKYmVmb3JlIGVtdWxhdGlvbiBpcyBwcm9ibGVtYXRpYy4gSXQgZ2V0cyBp
biB0aGUgd2F5IG9mIGFwcGx5aW5nCmNvbnNpc3RlbnQgc2luZ2xlLXN0ZXAgbG9naWMsIGFuZCBp
dCBwcmV2ZW50cyB1cyBmcm9tIGJlaW5nIGFibGUgdG8gZmFpbAphbiBNTUlPIGluc3RydWN0aW9u
IHdpdGggYSBzeW5jaHJvbm91cyBleGNlcHRpb24uCgpDbGVhbiB0aGlzIHVwIGJ5IG9ubHkgYWR2
YW5jaW5nIHRoZSBDUFUgc3RhdGUgKmFmdGVyKiB0aGUgZWZmZWN0cyBvZiB0aGUKaW5zdHJ1Y3Rp
b24gYXJlIGVtdWxhdGVkLgoKQ2M6IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJv
Lm9yZz4KUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4K
UmV2aWV3ZWQtYnk6IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAYXJtLmNvbT4K
U2lnbmVkLW9mZi1ieTogTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4KU2lnbmVk
LW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KU2lnbmVkLW9mZi1i
eTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPgotLS0KIGFyY2gvYXJtL2t2bS9tbWlv
LmMgfCAxMSArKysrKystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybS9rdm0vbW1pby5jIGIvYXJjaC9hcm0v
a3ZtL21taW8uYwppbmRleCA0Y2I1YTkzMTgyZTkuLmMyMTViYjQ0MjNhYyAxMDA2NDQKLS0tIGEv
YXJjaC9hcm0va3ZtL21taW8uYworKysgYi9hcmNoL2FybS9rdm0vbW1pby5jCkBAIC0xMTgsNiAr
MTE4LDEyIEBAIGludCBrdm1faGFuZGxlX21taW9fcmV0dXJuKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgc3RydWN0IGt2bV9ydW4gKnJ1bikKIAkJKnZjcHVfcmVnKHZjcHUsIHZjcHUtPmFyY2gubW1p
b19kZWNvZGUucnQpID0gZGF0YTsKIAl9CiAKKwkvKgorCSAqIFRoZSBNTUlPIGluc3RydWN0aW9u
IGlzIGVtdWxhdGVkIGFuZCBzaG91bGQgbm90IGJlIHJlLWV4ZWN1dGVkCisJICogaW4gdGhlIGd1
ZXN0LgorCSAqLworCWt2bV9za2lwX2luc3RyKHZjcHUsIGt2bV92Y3B1X3RyYXBfaWxfaXMzMmJp
dCh2Y3B1KSk7CisKIAlyZXR1cm4gMDsKIH0KIApAQCAtMTU0LDExICsxNjAsNiBAQCBzdGF0aWMg
aW50IGRlY29kZV9oc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBwaHlzX2FkZHJfdCBmYXVsdF9p
cGEsCiAJdmNwdS0+YXJjaC5tbWlvX2RlY29kZS5zaWduX2V4dGVuZCA9IHNpZ25fZXh0ZW5kOwog
CXZjcHUtPmFyY2gubW1pb19kZWNvZGUucnQgPSBydDsKIAotCS8qCi0JICogVGhlIE1NSU8gaW5z
dHJ1Y3Rpb24gaXMgZW11bGF0ZWQgYW5kIHNob3VsZCBub3QgYmUgcmUtZXhlY3V0ZWQKLQkgKiBp
biB0aGUgZ3Vlc3QuCi0JICovCi0Ja3ZtX3NraXBfaW5zdHIodmNwdSwga3ZtX3ZjcHVfdHJhcF9p
bF9pczMyYml0KHZjcHUpKTsKIAlyZXR1cm4gMDsKIH0KIAotLSAKMi4xOS4xCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
