From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v10 0/6] QEMU support for KVM Guest Debug on arm64
Date: Tue,  8 Dec 2015 18:32:27 +0000
Message-ID: <1449599553-24713-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D10DF411F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 13:31:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id imigWvausQQU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 13:31:07 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6C9F407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 13:31:07 -0500 (EST)
Received: by wmvv187 with SMTP id v187so226456516wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2015 10:32:58 -0800 (PST)
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

SGksCgpIZXJlIGlzIHRoZSBsYXRlc3QgcGF0Y2ggc2V0IHRvIHN1cHBvcnQgZGVidWdnaW5nIG9m
IEtWTSBndWVzdHMgb24KYXJtNjQuIFRoZSBtYWluIGNoYW5nZXMgYXJlIGZpeGluZyBhcm0zMiBj
b21waWxlcyAobW9zdGx5IHdpdGggc3R1YnMKZm9yIHRoZSB1cGNvbW1pbmcgYXJtMzIgZGVidWcp
IGFuZCB0aGUgdXN1YWwgYnVuY2ggb2YgbWlub3IgdHdlYWtzIGFuZApjbGFyaWZpY2F0aW9ucyBm
b2xsb3dpbmcgcmV2aWV3LgoKSSd2ZSBrZXB0IHRoZSBHREIgUHl0aG9uIGJhc2VkIHRlc3QgaW4g
dGVzdHMvZ3Vlc3QtZGVidWcgYW5kIGNsZWFuZWQKaXQgdXAgc28gaXQgd2lsbCB3b3JrIHdpdGgg
cHl0aG9uMi8zIGxpbmtlZCBHREJzLiBJdCBzdGlsbCBpc24ndApwbHVtYmVkIGl0IGluIHRvIHRo
ZSAibWFrZSBjaGVjayIgc28gY2FuIGJlIGRyb3BwZWQgdW50aWwgd2UgaGF2ZSBhCnNvbHV0aW9u
IGZvciB0ZXN0aW5nIGFnYWluc3Qgbm9uLWhvc3QgYmluYXJpZXMuCgpTbyBpbiBzdW1tYXJ5IHRo
ZSBjaGFuZ2VzIGFyZToKCiAgLSBGaXhlZCBhcm0zMiBjb21waWxlCiAgLSBVc2UgcmVzdWx0cyBv
ZiBkZWJ1ZyBjYXBhYmlsaXR5IGNoZWNrcwogIC0gV2hpdGVzcGFjZSBhbmQgY29tbWVudCBjbGVh
bnVwcwogIC0gUHkyLzMgY2xlYW5saW5lc3MgZm9yIHRlc3Qgc2NyaXB0CgpNb3JlIGRldGFpbGVk
IGNoYW5nZWxvZ3MgYXJlIGF0dGFjaGVkIHRvIGVhY2ggcGF0Y2guCgpHSVQgUmVwbzoKClRoZSBw
YXRjaCBzZXJpZXMgaXMgYmFzZWQgb2ZmIGEgcmVjZW50IG1hc3RlciBhbmQgY2FuIGJlIGZvdW5k
IGF0OgoKaHR0cHM6Ly9naXRodWIuY29tL3N0c3F1YWQvcWVtdQpicmFuY2g6IGt2bS9ndWVzdC1k
ZWJ1Zy12MTAKCkFsZXggQmVubsOpZSAoNik6CiAgdGFyZ2V0LWFybToga3ZtNjQgLSBpbnRyb2R1
Y2Uga3ZtX2FybV9pbml0X2RlYnVnKCkKICB0YXJnZXQtYXJtOiBrdm0gLSBpbXBsZW1lbnQgc29m
dHdhcmUgYnJlYWtwb2ludHMKICB0YXJnZXQtYXJtOiBrdm0gLSBzdXBwb3J0IGZvciBzaW5nbGUg
c3RlcAogIHRhcmdldC1hcm06IGt2bSAtIGFkZCBzdXBwb3J0IGZvciBIVyBhc3Npc3RlZCBkZWJ1
ZwogIHRhcmdldC1hcm06IGt2bSAtIHJlLWluamVjdCBndWVzdCBkZWJ1ZyBleGNlcHRpb25zCiAg
dGVzdHMvZ3Vlc3QtZGVidWc6IGludHJvZHVjZSBiYXNpYyBnZGJzdHViIHRlc3RzCgogdGFyZ2V0
LWFybS9oZWxwZXItYTY0LmMgICAgICAgICAgIHwgIDEyICstCiB0YXJnZXQtYXJtL2t2bS5jICAg
ICAgICAgICAgICAgICAgfCAgNjUgKysrLS0tCiB0YXJnZXQtYXJtL2t2bTMyLmMgICAgICAgICAg
ICAgICAgfCAgNDcgKysrKwogdGFyZ2V0LWFybS9rdm02NC5jICAgICAgICAgICAgICAgIHwgNDY0
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiB0YXJnZXQtYXJtL2t2bV9h
cm0uaCAgICAgICAgICAgICAgfCAgMzAgKysrCiB0ZXN0cy9ndWVzdC1kZWJ1Zy90ZXN0LWdkYnN0
dWIucHkgfCAxNzYgKysrKysrKysrKysrKysrCiA2IGZpbGVzIGNoYW5nZWQsIDc1NyBpbnNlcnRp
b25zKCspLCAzNyBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCB0ZXN0cy9ndWVzdC1k
ZWJ1Zy90ZXN0LWdkYnN0dWIucHkKCi0tIAoyLjYuMwoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
