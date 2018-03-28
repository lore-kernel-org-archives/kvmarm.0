From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 05/85] KVM: arm64: Enable the EL1 physical timer for AArch32
 guests
Date: Wed, 28 Mar 2018 13:51:34 +0100
Message-ID: <20180328125254.31380-6-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBB0349FF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:45:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id odnjv6geiWBq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:45:15 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6640E49F7E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:45:15 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogSsOpcsOpbXkgRmFuZ3XDqGRlIDxqLmZhbmd1ZWRlQHZpcnR1YWxvcGVuc3lzdGVtcy5j
b20+CgpTb21lIDMyYml0cyBndWVzdCBPUyBjYW4gdXNlIHRoZSBDTlRQIHRpbWVyLCBob3dldmVy
IEtWTSBkb2VzIG5vdApoYW5kbGUgdGhlIGFjY2Vzc2VzLCBpbmplY3RpbmcgYSBmYXVsdCBpbnN0
ZWFkLgoKVXNlIHRoZSBwcm9wZXIgaGFuZGxlcnMgdG8gZW11bGF0ZSB0aGUgRUwxIFBoeXNpY2Fs
IFRpbWVyIChDTlRQKQpyZWdpc3RlciBhY2Nlc3NlcyBvZiBBQXJjaDMyIGd1ZXN0cy4KClNpZ25l
ZC1vZmYtYnk6IErDqXLDqW15IEZhbmd1w6hkZSA8ai5mYW5ndWVkZUB2aXJ0dWFsb3BlbnN5c3Rl
bXMuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbHZpc2UgUmlnbyA8YS5yaWdvQHZpcnR1YWxvcGVuc3lz
dGVtcy5jb20+ClNpZ25lZC1vZmYtYnk6IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRh
bGxAbGluYXJvLm9yZz4KLS0tCiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIHwgNiArKysrKysK
IDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2t2bS9zeXNfcmVncy5jIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwppbmRleCA1NTk4MmI1
NjVlYjIuLjZmZWI0YTIyMTVjYiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3Mu
YworKysgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCkBAIC0xNTY1LDYgKzE1NjUsMTEgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgY3AxNV9yZWdzW10gPSB7CiAKIAl7IE9w
MSggMCksIENSbigxMyksIENSbSggMCksIE9wMiggMSksIGFjY2Vzc192bV9yZWcsIE5VTEwsIGMx
M19DSUQgfSwKIAorCS8qIENOVFBfVFZBTCAqLworCXsgT3AxKCAwKSwgQ1JuKDE0KSwgQ1JtKCAy
KSwgT3AyKCAwKSwgYWNjZXNzX2NudHBfdHZhbCB9LAorCS8qIENOVFBfQ1RMICovCisJeyBPcDEo
IDApLCBDUm4oMTQpLCBDUm0oIDIpLCBPcDIoIDEpLCBhY2Nlc3NfY250cF9jdGwgfSwKKwogCS8q
IFBNRVZDTlRSbiAqLwogCVBNVV9QTUVWQ05UUigwKSwKIAlQTVVfUE1FVkNOVFIoMSksCkBAIC0x
NjM4LDYgKzE2NDMsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyBjcDE1XzY0
X3JlZ3NbXSA9IHsKIAl7IE9wMSggMCksIENSbiggMCksIENSbSggOSksIE9wMiggMCksIGFjY2Vz
c19wbXVfZXZjbnRyIH0sCiAJeyBPcDEoIDApLCBDUm4oIDApLCBDUm0oMTIpLCBPcDIoIDApLCBh
Y2Nlc3NfZ2ljX3NnaSB9LAogCXsgT3AxKCAxKSwgQ1JuKCAwKSwgQ1JtKCAyKSwgT3AyKCAwKSwg
YWNjZXNzX3ZtX3JlZywgTlVMTCwgYzJfVFRCUjEgfSwKKwl7IE9wMSggMiksIENSbiggMCksIENS
bSgxNCksIE9wMiggMCksIGFjY2Vzc19jbnRwX2N2YWwgfSwKIH07CiAKIC8qIFRhcmdldCBzcGVj
aWZpYyBlbXVsYXRpb24gdGFibGVzICovCi0tIAoyLjE0LjIKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
