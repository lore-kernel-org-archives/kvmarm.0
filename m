From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3 24/28] arm64/sve: KVM: Hide SVE from CPU features exposed
 to guests
Date: Tue, 10 Oct 2017 19:38:41 +0100
Message-ID: <1507660725-7986-25-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C040C49D44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 14:39:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0xYOknTWq9PU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Oct 2017 14:39:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2991549D56
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 14:39:06 -0400 (EDT)
In-Reply-To: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

S1ZNIGd1ZXN0cyBjYW5ub3QgY3VycmVudGx5IHVzZSBTVkUsIGJlY2F1c2UgU1ZFIGlzIGFsd2F5
cwpjb25maWd1cmVkIHRvIHRyYXAgdG8gRUwyLgoKSG93ZXZlciwgYSBndWVzdCB0aGF0IHNlZXMg
U1ZFIHJlcG9ydGVkIGFzIHByZXNlbnQgaW4KSURfQUE2NFBGUjBfRUwxIG1heSBsZWdpdGltYXRl
bHkgZXhwZWN0IHRoYXQgU1ZFIHdvcmtzIGFuZCB0cnkgdG8KdXNlIGl0LiAgSW5zdGVhZCBvZiB3
b3JraW5nLCB0aGUgZ3Vlc3Qgd2lsbCByZWNlaXZlIGFuIGluamVjdGVkCnVuZGVmIGV4Y2VwdGlv
biwgd2hpY2ggbWF5IGNhdXNlIHRoZSBndWVzdCB0byBvb3BzIG9yIGdvIGludG8gYQpzcGluLgoK
VG8gYXZvaWQgbWlzbGVhZGluZyB0aGUgZ3Vlc3QgaW50byBiZWxpZXZpbmcgdGhhdCBTVkUgd2ls
bCB3b3JrLAp0aGlzIHBhdGNoIG1hc2tzIG91dCB0aGUgU1ZFIGZpZWxkIGZyb20gSURfQUE2NFBG
UjBfRUwxIHdoZW4gYQpndWVzdCBhdHRlbXB0cyB0byByZWFkIHRoaXMgcmVnaXN0ZXIuICBObyBz
dXBwb3J0IGlzIGV4cGxpY2l0bHkKYWRkZWQgZm9yIElEX0FBNjRaRlIwX0VMMSBlaXRoZXIsIHNv
IHRoYXQgaXMgc3RpbGwgZW11bGF0ZWQgYXMKcmVhZGluZyBhcyB6ZXJvLCB3aGljaCBpcyBjb25z
aXN0ZW50IHdpdGggU1ZFIG5vdCBiZWluZwppbXBsZW1lbnRlZC4KClRoaXMgaXMgYSB0ZW1wb3Jh
cnkgbWVhc3VyZSwgYW5kIHdpbGwgYmUgcmVtb3ZlZCBpbiBhIGxhdGVyIHNlcmllcwp3aGVuIGZ1
bGwgS1ZNIHN1cHBvcnQgZm9yIFNWRSBpcyBpbXBsZW1lbnRlZC4KClNpZ25lZC1vZmYtYnk6IERh
dmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgpSZXZpZXdlZC1ieTogQWxleCBCZW5uw6ll
IDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpDYzogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJA
YXJtLmNvbT4KLS0tCiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIHwgMTIgKysrKysrKysrKyst
CiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAt
LWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVn
cy5jCmluZGV4IGIxZjc1NTIuLmEwZWU5YjAgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3N5
c19yZWdzLmMKKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwpAQCAtMjMsNiArMjMsNyBA
QAogI2luY2x1ZGUgPGxpbnV4L2JzZWFyY2guaD4KICNpbmNsdWRlIDxsaW51eC9rdm1faG9zdC5o
PgogI2luY2x1ZGUgPGxpbnV4L21tLmg+CisjaW5jbHVkZSA8bGludXgvcHJpbnRrLmg+CiAjaW5j
bHVkZSA8bGludXgvdWFjY2Vzcy5oPgogCiAjaW5jbHVkZSA8YXNtL2NhY2hlZmx1c2guaD4KQEAg
LTg5Nyw4ICs4OTgsMTcgQEAgc3RhdGljIHU2NCByZWFkX2lkX3JlZyhzdHJ1Y3Qgc3lzX3JlZ19k
ZXNjIGNvbnN0ICpyLCBib29sIHJheikKIHsKIAl1MzIgaWQgPSBzeXNfcmVnKCh1MzIpci0+T3Aw
LCAodTMyKXItPk9wMSwKIAkJCSAodTMyKXItPkNSbiwgKHUzMilyLT5DUm0sICh1MzIpci0+T3Ay
KTsKKwl1NjQgdmFsID0gcmF6ID8gMCA6IHJlYWRfc2FuaXRpc2VkX2Z0cl9yZWcoaWQpOwogCi0J
cmV0dXJuIHJheiA/IDAgOiByZWFkX3Nhbml0aXNlZF9mdHJfcmVnKGlkKTsKKwlpZiAoaWQgPT0g
U1lTX0lEX0FBNjRQRlIwX0VMMSkgeworCQlpZiAodmFsICYgKDB4ZlVMIDw8IElEX0FBNjRQRlIw
X1NWRV9TSElGVCkpCisJCQlwcl9lcnJfb25jZSgia3ZtIFslaV06IFNWRSB1bnN1cHBvcnRlZCBm
b3IgZ3Vlc3RzLCBzdXBwcmVzc2luZ1xuIiwKKwkJCQkgICAgdGFza19waWRfbnIoY3VycmVudCkp
OworCisJCXZhbCAmPSB+KDB4ZlVMIDw8IElEX0FBNjRQRlIwX1NWRV9TSElGVCk7CisJfQorCisJ
cmV0dXJuIHZhbDsKIH0KIAogLyogY3B1ZmVhdHVyZSBJRCByZWdpc3RlciBhY2Nlc3MgdHJhcCBo
YW5kbGVycyAqLwotLSAKMi4xLjQKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
