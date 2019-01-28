From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 110/170] arm64: KVM: Skip MMIO insn after
 emulation
Date: Mon, 28 Jan 2019 11:11:00 -0500
Message-ID: <20190128161200.55107-110-sashal@kernel.org>
References: <20190128161200.55107-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14CA74A32D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 11:16:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KpyuaUsQdPQ0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 11:16:48 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF3F34A321
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 11:16:48 -0500 (EST)
In-Reply-To: <20190128161200.55107-1-sashal@kernel.org>
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
eTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPgotLS0KIHZpcnQva3ZtL2FybS9tbWlv
LmMgfCAxMSArKysrKystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vbW1pby5jIGIvdmlydC9rdm0v
YXJtL21taW8uYwppbmRleCBkYWM3Y2ViMWE2NzcuLjA4NDQzYTE1ZTZiZSAxMDA2NDQKLS0tIGEv
dmlydC9rdm0vYXJtL21taW8uYworKysgYi92aXJ0L2t2bS9hcm0vbW1pby5jCkBAIC0xMTcsNiAr
MTE3LDEyIEBAIGludCBrdm1faGFuZGxlX21taW9fcmV0dXJuKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgc3RydWN0IGt2bV9ydW4gKnJ1bikKIAkJdmNwdV9zZXRfcmVnKHZjcHUsIHZjcHUtPmFyY2gu
bW1pb19kZWNvZGUucnQsIGRhdGEpOwogCX0KIAorCS8qCisJICogVGhlIE1NSU8gaW5zdHJ1Y3Rp
b24gaXMgZW11bGF0ZWQgYW5kIHNob3VsZCBub3QgYmUgcmUtZXhlY3V0ZWQKKwkgKiBpbiB0aGUg
Z3Vlc3QuCisJICovCisJa3ZtX3NraXBfaW5zdHIodmNwdSwga3ZtX3ZjcHVfdHJhcF9pbF9pczMy
Yml0KHZjcHUpKTsKKwogCXJldHVybiAwOwogfQogCkBAIC0xNDQsMTEgKzE1MCw2IEBAIHN0YXRp
YyBpbnQgZGVjb2RlX2hzcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGJvb2wgKmlzX3dyaXRlLCBp
bnQgKmxlbikKIAl2Y3B1LT5hcmNoLm1taW9fZGVjb2RlLnNpZ25fZXh0ZW5kID0gc2lnbl9leHRl
bmQ7CiAJdmNwdS0+YXJjaC5tbWlvX2RlY29kZS5ydCA9IHJ0OwogCi0JLyoKLQkgKiBUaGUgTU1J
TyBpbnN0cnVjdGlvbiBpcyBlbXVsYXRlZCBhbmQgc2hvdWxkIG5vdCBiZSByZS1leGVjdXRlZAot
CSAqIGluIHRoZSBndWVzdC4KLQkgKi8KLQlrdm1fc2tpcF9pbnN0cih2Y3B1LCBrdm1fdmNwdV90
cmFwX2lsX2lzMzJiaXQodmNwdSkpOwogCXJldHVybiAwOwogfQogCi0tIAoyLjE5LjEKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
